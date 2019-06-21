﻿
Imports System.Data.SqlClient
Imports System.IO
Imports Microsoft.Azure
Imports Microsoft.WindowsAzure.Storage
Imports Microsoft.WindowsAzure.Storage.Blob
Imports Microsoft.WindowsAzure.Storage.File

Partial Class NewUpload
    Inherits System.Web.UI.Page
    Dim storageAccount As CloudStorageAccount = CloudStorageAccount.Parse(CloudConfigurationManager.GetSetting("StorageConnectionString"))
    Dim fileClient As CloudFileClient = storageAccount.CreateCloudFileClient()
    Dim cloudBlobClient As Blob.CloudBlobClient = storageAccount.CreateCloudBlobClient()



    Protected Sub btn_Click(sender As Object, e As EventArgs) Handles btn.Click
        If String.IsNullOrEmpty(text_style_no.Text) OrElse String.IsNullOrEmpty(txtDate.Text) Then
            lbl.Text = "Please enter at least one style and a Date of Import/Export."
            Return
        End If


        Dim refContainer = cloudBlobClient.GetContainerReference("edrawback")
        Dim blobref = refContainer.GetBlobReference(ddlcompany.SelectedItem.Text & "/" & imporexp.SelectedItem.Text & "/" & ddlfile.SelectedItem.Text)
        blobref.DownloadToFile(Path.GetTempPath() + ddlfile.SelectedItem.Text, FileMode.Create)
        Dim cloudblob As CloudBlockBlob = refContainer.GetBlockBlobReference(ddlcompany.SelectedItem.Text & "/" & imporexp.SelectedItem.Text & "/Archive/" & ddlfile.SelectedItem.Text)
        cloudblob.UploadFromFile(Path.GetTempPath() + ddlfile.SelectedItem.Text)
        refContainer = cloudBlobClient.GetContainerReference("docroot")
        Dim styles As String = text_style_no.Text.Replace(" ", "").Replace("/", "-")
        For Each Style As String In Regex.Split(styles, "\r\n")
            If String.IsNullOrEmpty(Style.Trim) Then
                Continue For
            End If
            Dim dt As DateTime = Convert.ToDateTime(txtDate.Text)
            Dim thedate As String = dt.Year & "-" & dt.Month.ToString("D2") & "-" & dt.Day.ToString("D2")
            Dim foldername = String.Concat(thedate, " ", imporexp.Text)
            cloudblob = refContainer.GetBlockBlobReference(ddlcompany.SelectedItem.Text & "/" & Style & "/" & foldername & "/" & ddlfile.SelectedItem.Text)
            cloudblob.UploadFromFile(Path.GetTempPath() + ddlfile.SelectedItem.Text)
        Next
        blobref.Delete()
        File.Delete(Path.GetTempPath() + ddlfile.SelectedItem.Text)
        Dim blobs = BlobHelper.ListFolderBlobsNonRecursive("edrawback", ddlcompany.SelectedItem.Text & "/" & imporexp.SelectedItem.Text).Select(Function(w) w.FileName).ToArray()
        Dim a As IEnumerable(Of String)
        If sort.Value = "ZA" Then

            a = blobs.ToArray.OrderByDescending(Function(x) x)
            ddlfile.DataSource = a
        Else
            ddlfile.DataSource = blobs
        End If
        ddlfile.DataBind()
        'Directory.CreateDirectory(ConfigurationManager.AppSettings("RootPath") & ddlcompany.SelectedItem.Text & "\" & imporexp.SelectedItem.Text & "\Archive")

        'Dim rootdir As String = ConfigurationManager.AppSettings("RootPath") & ddlcompany.SelectedValue & "\"

        'Dim newFullPath As String = String.Empty
        'Dim dt As DateTime = Convert.ToDateTime(txtDate.Text)
        'Dim thedate As String = dt.Year & "-" & dt.Month.ToString("D2") & "-" & dt.Day.ToString("D2")
        'Dim styles As String = text_style_no.Text.Replace(" ", "").Replace("/", "-")
        'Dim foldername As String = String.Empty
        'Dim filename As String = String.Empty
        'For Each Style As String In Regex.Split(styles, "\r\n")
        '    If String.IsNullOrEmpty(Style.Trim) Then
        '        Continue For
        '    End If
        '    foldername = String.Concat(thedate, " ", imporexp.Text)
        '    If Regex.IsMatch(Style, "\(") Then

        '        filename = String.Concat(imporexp.Text, " (", Regex.Split(Style, "\(")(1).Trim)

        '        Style = Regex.Split(Style, "\(")(0).Trim
        '    Else
        '        filename = String.Concat(thedate, " ", imporexp.Text)
        '    End If


        '    Directory.CreateDirectory(String.Concat(rootdir, "\", Style, "\", foldername))


        '    Dim fullpath As String = String.Concat(rootdir, "\", Style, "\", foldername, "\", filename)

        '    newFullPath = fullpath
        '    Dim i As Integer = 0
        '    Do While File.Exists((newFullPath & ".pdf"))
        '        i += 1
        '        newFullPath = String.Format((fullpath & "({0})"), i)
        '    Loop

        '    File.Copy(ConfigurationManager.AppSettings("RootPath") & ddlcompany.SelectedItem.Text & "\" & imporexp.SelectedItem.Text & "\" & ddlfile.SelectedItem.Text, String.Concat(newFullPath, ".pdf"))
        'Next

        'File.Move(ConfigurationManager.AppSettings("RootPath") & ddlcompany.SelectedItem.Text & "\" & imporexp.SelectedItem.Text & "\" & ddlfile.SelectedItem.Text, ConfigurationManager.AppSettings("RootPath") & ddlcompany.SelectedItem.Text & "\" & imporexp.SelectedItem.Text & "\Archive\" & ddlfile.SelectedItem.Text)
        'Dim c = New DirectoryInfo(ConfigurationManager.AppSettings("RootPath") & ddlcompany.SelectedItem.Text & "\" & imporexp.SelectedItem.Text & "\").GetFiles().Select(Function(o) o.Name).ToArray()
        'ddlfile.DataSource = c
        'ddlfile.DataBind()
        lbl.Text = "Items Created and Placed in Folders."
    End Sub

    Private Sub NewUpload_Load(sender As Object, e As EventArgs) Handles Me.Load
        If Not IsPostBack Then
            Dim UserCookie As HttpCookie = Request.Cookies("Edrawbacks_UserInfo")
            If UserCookie Is Nothing OrElse Not Regex.IsMatch(UserCookie("UserName"), "admin", RegexOptions.IgnoreCase) Then
                Response.Redirect("login.aspx")
            End If
            Dim DataSource As String = ConfigurationManager.AppSettings("DataSource")
            Dim InitialCatalog As String = ConfigurationManager.AppSettings("InitialCatalog")
            Dim UserId As String = ConfigurationManager.AppSettings("UserId")
            Dim Password As String = ConfigurationManager.AppSettings("Password")

            Dim connectionString As String = "Data Source=" & DataSource & ";Initial Catalog=" & InitialCatalog & ";User Id=" & UserId & ";Password=" & Password & ";"
            Dim queryString As String = "Select UserName from Users where username <> 'Admin';"
            Using connection As New SqlConnection(connectionString)
                connection.Open()
                Using Command As New SqlCommand(queryString, connection)
                    Using dr As SqlDataReader = Command.ExecuteReader
                        If dr.HasRows Then
                            While dr.Read
                                ddlcompany.Items.Add(dr("username"))
                            End While
                        End If
                    End Using
                End Using

            End Using



        End If



    End Sub
    

    Private Sub NewUpload_PreRender(sender As Object, e As EventArgs) Handles Me.PreRender

        Dim refContainer = cloudBlobClient.GetContainerReference("edrawback")
        Dim blobs = BlobHelper.ListFileBlobsNonRecursive("edrawback", ddlcompany.SelectedItem.Text & "/" & imporexp.SelectedItem.Text).Select(Function(w) w.FileName).ToArray()
        Dim a As IEnumerable(Of String)
        If sort.Value = "ZA" Then

            a = blobs.ToArray.OrderByDescending(Function(x) x)
            ddlfile.DataSource = a
        Else
            ddlfile.DataSource = blobs
        End If
        ddlfile.DataBind()

        Dim sb As StringBuilder = New StringBuilder
        sb.Append("<script>var Tags = [")
        blobs = BlobHelper.ListFolderBlobsNonRecursive("docroot", ddlcompany.SelectedItem.Text).Select(Function(w) w.FileName.Replace("/", "")).ToArray
        For i As Int16 = 0 To blobs.Count - 1
            Dim blobs2 = BlobHelper.ListFolderBlobsNonRecursive("docroot", ddlcompany.SelectedItem.Text & "/" & blobs(i)).Select(Function(w) w.FileName).ToArray
            For j As Int16 = 0 To blobs2.Count - 1
                If i = blobs.Count - 1 AndAlso j = blobs2.Count - 1 Then
                    sb.Append("""" & blobs(i) & " : " & blobs2(j) & """")
                Else
                    sb.Append("""" & blobs(i) & " : " & blobs2(j) & """" & ",")
                End If
            Next
        Next
        sb.Append(" ];</script>")
        txtFilter.Text = ""
        text_style_no.Text = ""
        ClientScript.RegisterStartupScript(Me.GetType(), "key", sb.ToString)
        txtFilter.Text = ""
        text_style_no.Text = ""
        'Dim c = New DirectoryInfo(ConfigurationManager.AppSettings("RootPath") & ddlcompany.SelectedItem.Text & "\" & imporexp.SelectedItem.Text & "\").GetFiles().Select(Function(o) o.Name).ToArray()
        'Dim a As IEnumerable(Of String)
        'If sort.Value = "ZA" Then
        '    a = c.ToArray.OrderByDescending(Function(x) x)
        '    ddlfile.DataSource = a
        'Else
        '    ddlfile.DataSource = c
        'End If
        'ddlfile.DataBind()
        'Dim d = New DirectoryInfo(ConfigurationManager.AppSettings("RootPath") & ddlcompany.SelectedItem.Text).GetDirectories().Select(Function(o) o.Name).ToArray()
        'Dim sb As StringBuilder = New StringBuilder
        'sb.Append("<script>var Tags = [")
        'For i As Int16 = 0 To d.Count - 1
        '    Dim dd = New DirectoryInfo(ConfigurationManager.AppSettings("RootPath") & ddlcompany.SelectedItem.Text & "\" & d(i)).GetDirectories().Select(Function(o) o.Name).ToArray()
        '    For j As Int16 = 0 To dd.Count - 1
        '        If i = d.Count - 1 AndAlso j = dd.Count - 1 Then
        '            sb.Append("""" & d(i) & " : " & dd(j) & """")
        '        Else
        '            sb.Append("""" & d(i) & " : " & dd(j) & """" & ",")
        '        End If
        '    Next




        'Next
        'sb.Append(" ];</script>")

        'ClientScript.RegisterStartupScript(Me.GetType(), "key", sb.ToString)
        'txtFilter.Text = ""
        'text_style_no.Text = ""

    End Sub
    Protected Sub Unnamed1_Click(sender As Object, e As EventArgs)
        Dim refContainer = cloudBlobClient.GetContainerReference("edrawback")
        Dim blobref = refContainer.GetBlobReference(ddlcompany.SelectedItem.Text & "/" & imporexp.SelectedItem.Text & "/" & ddlfile.SelectedItem.Text)
        blobref.DownloadToFile(Path.GetTempPath() + ddlfile.SelectedItem.Text, FileMode.Create)
        Dim cloudblob As CloudBlockBlob = refContainer.GetBlockBlobReference(ddlcompany.SelectedItem.Text & "/" & imporexp.SelectedItem.Text & "/Archive/" & ddlfile.SelectedItem.Text)
        cloudblob.UploadFromFile(Path.GetTempPath() + ddlfile.SelectedItem.Text)
        blobref.Delete()
        File.Delete(Path.GetTempPath() + ddlfile.SelectedItem.Text)
        Dim blobs = BlobHelper.ListFolderBlobsNonRecursive("edrawback", ddlcompany.SelectedItem.Text & "/" & imporexp.SelectedItem.Text).Select(Function(w) w.FileName).ToArray()
        Dim a As IEnumerable(Of String)
        If sort.Value = "ZA" Then

            a = blobs.ToArray.OrderByDescending(Function(x) x)
            ddlfile.DataSource = a
        Else
            ddlfile.DataSource = blobs
        End If
        ddlfile.DataBind()
        'File.Move(ConfigurationManager.AppSettings("RootPath") & ddlcompany.SelectedItem.Text & "\" & imporexp.SelectedItem.Text & "\" & ddlfile.SelectedItem.Text, ConfigurationManager.AppSettings("RootPath") & ddlcompany.SelectedItem.Text & "\" & imporexp.SelectedItem.Text & "\Archive\" & ddlfile.SelectedItem.Text)
        'Dim c = New DirectoryInfo(ConfigurationManager.AppSettings("RootPath") & ddlcompany.SelectedItem.Text & "\" & imporexp.SelectedItem.Text & "\").GetFiles().Select(Function(o) o.Name).ToArray()

        'Dim a As IEnumerable(Of String)
        'If sort.Value = "ZA" Then
        '    a = c.ToArray.OrderByDescending(Function(x) x)
        '    ddlfile.DataSource = a
        'Else
        '    ddlfile.DataSource = c
        'End If
        'ddlfile.DataBind()
        lbl.Text = "File Skipped."
    End Sub
    Protected Sub Unnamed_Click(sender As Object, e As EventArgs)
        If sort.Value = "AZ" Then
            sort.Value = "ZA"
        Else
            sort.Value = "AZ"
        End If

    End Sub
End Class
