Imports System.IO
Imports System.Data.SqlClient
Imports System.Data

Partial Class UploadAdmin
    Inherits System.Web.UI.Page

    Protected Sub btn_Click(sender As Object, e As EventArgs) Handles btn.Click
        Dim tracking_no As String = Regex.Replace(text_tracking_no.Text, " ", "")
        If String.IsNullOrEmpty(text_style_no.Text) OrElse String.IsNullOrEmpty(txtDate.Text) Then
            lbl.Text = "Please enter at least one style and a Date of Import/Export."
            Return
        End If
        If String.IsNullOrEmpty(tracking_no) AndAlso ImportorExport.Text = "Export" Then
            lbl.Text = "You need to enter a tracking # for Exports"
            Return
        End If

        Dim didupload As Boolean = False
        Dim UserCookie As HttpCookie = Request.Cookies("Edrawbacks_UserInfo")
        Dim dt As DateTime = Convert.ToDateTime(txtDate.Text)
        Dim thedate As String = dt.Year & "-" & dt.Month.ToString("D2") & "-" & dt.Day.ToString("D2")
        Dim rootdir As String = ConfigurationManager.AppSettings("RootPath") & ddlCompany.SelectedValue & "\"
        Dim styles As String = text_style_no.Text.Replace(" ", "").Replace("/", "-")
        Dim stylesarr As String() = Regex.Split(styles, "[\n]")
        Dim foldername As String = String.Empty
        Dim filename As String = String.Empty



        If FreightCarrier.Text = "UPS" Then
            Dim newFullPath As String = String.Empty

            Dim searchPattern As String = String.Concat("*", tracking_no, "*")

            Dim dirinfo As DirectoryInfo = New DirectoryInfo(rootdir + "AllFiles")
            Dim fi As FileInfo() = dirinfo.GetFiles(searchPattern)

            For Each f As FileInfo In fi
                didupload = True
                Dim fileExtension As String = Path.GetExtension(f.FullName)
                For Each Style As String In Regex.Split(styles, "\r\n")
                    If String.IsNullOrEmpty(Style.Trim) Then
                        Continue For
                    End If
                    foldername = String.Concat(thedate, " ", ImportorExport.Text)
                    If Regex.IsMatch(Style, "\(") Then
                        If Regex.IsMatch(ImportorExport.Text, "Export") AndAlso Not String.IsNullOrEmpty(tracking_no) Then
                            filename = String.Concat(tracking_no, " ", " (", Regex.Split(Style, "\(")(1).Trim)

                        Else
                            filename = String.Concat(ImportorExport.Text, " (", Regex.Split(Style, "\(")(1).Trim)
                        End If

                        Style = Regex.Split(Style, "\(")(0).Trim


                    Else
                        filename = String.Concat(thedate, " ", ImportorExport.Text)
                    End If

                    If Not Directory.Exists(String.Concat(rootdir, "\", Style)) Then
                        Directory.CreateDirectory(String.Concat(rootdir, "\", Style))
                    End If
                    'If Not Directory.Exists(String.Concat(rootdir, "\", Style, "\", String.Concat(startingDate.Month, "-", startingDate.Day, "-", startingDate.Year))) Then
                    '    Directory.CreateDirectory(String.Concat(rootdir, "\", Style, "\", startingDate.Month, "-", startingDate.Day, "-", startingDate.Year))
                    'End If
                    'File.Copy(f.FullName, String.Concat(rootdir, "\", Style, "\", startingDate.Month, "-", startingDate.Day, "-", startingDate.Year, "\", f.Name), True)
                    If Not Directory.Exists(String.Concat(rootdir, "\", Style, "\", foldername)) Then
                        Directory.CreateDirectory(String.Concat(rootdir, "\", Style, "\", foldername))
                    End If
                    Dim fullpath As String = String.Concat(rootdir, "\", Style, "\", foldername, "\", filename)

                    newFullPath = fullpath
                    Dim i As Integer = 0
                    Do While File.Exists((newFullPath & fileExtension))
                        i += 1
                        newFullPath = String.Format((fullpath & "({0})"), i)
                    Loop

                    File.Copy(f.FullName, newFullPath & fileExtension, True)
                Next

            Next
        End If


        If File.Exists(System.Web.HttpContext.Current.Request.MapPath(".") & "/UploadedImages/WebTWAINImage.pdf") Then
            didupload = True

            'Dim fileExtension As String = Path.GetExtension(fuChooseFile.FileName)
            ' The full path of the file on server without an extension

            ' If there is already a file with the same name on the server, the file will be 
            ' upload with a new name.
            Dim newFullPath As String = String.Empty


            For Each Style As String In Regex.Split(styles, "\r\n")
                If String.IsNullOrEmpty(Style.Trim) Then
                    Continue For
                End If
                foldername = String.Concat(thedate, " ", ImportorExport.Text)
                If Regex.IsMatch(Style, "\(") Then
                    If ImportorExport.Text = "Export" AndAlso Not String.IsNullOrEmpty(tracking_no) Then
                        filename = String.Concat(tracking_no, " ", " (", Regex.Split(Style, "\(")(1).Trim)
                    Else
                        filename = String.Concat(ImportorExport.Text, " (", Regex.Split(Style, "\(")(1).Trim)
                    End If

                    Style = Regex.Split(Style, "\(")(0).Trim
                Else
                    filename = String.Concat(thedate, " ", ImportorExport.Text)
                End If

                If Not Directory.Exists(String.Concat(rootdir, "\", Style)) Then
                    Directory.CreateDirectory(String.Concat(rootdir, "\", Style))
                End If
                'If Not Directory.Exists(String.Concat(rootdir, "\", Style, "\", String.Concat(startingDate.Month, "-", startingDate.Day, "-", startingDate.Year))) Then
                '    Directory.CreateDirectory(String.Concat(rootdir, "\", Style, "\", startingDate.Month, "-", startingDate.Day, "-", startingDate.Year))
                'End If
                'File.Copy(f.FullName, String.Concat(rootdir, "\", Style, "\", startingDate.Month, "-", startingDate.Day, "-", startingDate.Year, "\", f.Name), True)
                If Not Directory.Exists(String.Concat(rootdir, "\", Style, "\", foldername)) Then
                    Directory.CreateDirectory(String.Concat(rootdir, "\", Style, "\", foldername))
                End If

                Dim fullpath As String = String.Concat(rootdir, "\", Style, "\", foldername, "\", filename)

                newFullPath = fullpath
                Dim i As Integer = 0
                Do While File.Exists((newFullPath & ".pdf"))
                    i += 1
                    newFullPath = String.Format((fullpath & "({0})"), i)
                Loop

                File.Copy(System.Web.HttpContext.Current.Request.MapPath(".") & "/UploadedImages/WebTWAINImage.pdf", String.Concat(newFullPath, ".pdf"))
            Next

            File.Delete(System.Web.HttpContext.Current.Request.MapPath(".") & "/UploadedImages/WebTWAINImage.pdf")
        End If
        If fuChooseFile.HasFile AndAlso ImportorExport.Text = "Document" Then

        End If
        If fuChooseFile.HasFile Then
            didupload = True
            ' Extension of the file you want to upload
            Dim fileExtension As String = Path.GetExtension(fuChooseFile.FileName)
            ' The full path of the file on server without an extension

            ' If there is already a file with the same name on the server, the file will be 
            ' upload with a new name.
            Dim newFullPath As String = String.Empty



            For Each Style As String In Regex.Split(styles, "\r\n")
                If String.IsNullOrEmpty(Style.Trim) Then
                    Continue For
                End If
                foldername = String.Concat(thedate, " ", ImportorExport.Text)
                If Regex.IsMatch(Style, "\(") Then
                    If (ImportorExport.Text = "Export" OrElse ImportorExport.Text = "Document") AndAlso Not String.IsNullOrEmpty(tracking_no) Then
                        filename = String.Concat(tracking_no, " ", " (", Regex.Split(Style, "\(")(1).Trim)
                    Else
                        filename = String.Concat(ImportorExport.Text, " (", Regex.Split(Style, "\(")(1).Trim)
                    End If

                    Style = Regex.Split(Style, "\(")(0).Trim
                Else
                    If (ImportorExport.Text = "Export" OrElse ImportorExport.Text = "Document") AndAlso Not String.IsNullOrEmpty(tracking_no) Then
                        filename = String.Concat(thedate, " ", tracking_no)
                        If ImportorExport.Text = "Document" Then
                            foldername = String.Concat(thedate, " ", tracking_no)
                        End If
                    Else
                        filename = String.Concat(thedate, " ", ImportorExport.Text)
                    End If

                End If
                If Not Directory.Exists(String.Concat(rootdir, "\", Style)) Then
                    Directory.CreateDirectory(String.Concat(rootdir, "\", Style))
                End If
                'If Not Directory.Exists(String.Concat(rootdir, "\", Style, "\", String.Concat(startingDate.Month, "-", startingDate.Day, "-", startingDate.Year))) Then
                '    Directory.CreateDirectory(String.Concat(rootdir, "\", Style, "\", startingDate.Month, "-", startingDate.Day, "-", startingDate.Year))
                'End If
                'File.Copy(f.FullName, String.Concat(rootdir, "\", Style, "\", startingDate.Month, "-", startingDate.Day, "-", startingDate.Year, "\", f.Name), True)
                If Not Directory.Exists(String.Concat(rootdir, "\", Style, "\", foldername)) Then
                    Directory.CreateDirectory(String.Concat(rootdir, "\", Style, "\", foldername))
                End If
                Dim fullpath As String = String.Concat(rootdir, "\", Style, "\", foldername, "\", filename)
                ' fileName = String.Format("{0}{1}", rootdir, fuChooseFile.FileName)


                If ((fileExtension.ToLower = ".exe") OrElse (fileExtension.ToLower = ".msi")) Then
                    lbl.Text = "The file you want to upload cannot be a .exe or .msi file."
                Else
                    newFullPath = fullpath
                    If (fuChooseFile.PostedFile.ContentLength >= &H2800000) Then
                        lbl.Text = "The file you want to upload cannot be larger than 40 MB."
                    Else
                        Try
                            Dim i As Integer = 0
                            Do While File.Exists((newFullPath & fileExtension))
                                i += 1
                                newFullPath = String.Format((fullpath & "({0})"), i)
                            Loop
                            fuChooseFile.SaveAs((newFullPath & fileExtension))
                            lbl.Text = String.Format("The file ""{0}{1}"" was uploaded successfully!", Path.GetFileName(newFullPath), fileExtension)
                        Catch he As HttpException
                            lbl.Text = String.Format("File {0} upload failed because of the following error:{1}.", fuChooseFile.PostedFile.FileName, he.Message)
                        End Try
                    End If
                End If
            Next
        End If
        If Not didupload Then
            Dim f = File.CreateText(String.Concat(rootdir, "Queue\", tracking_no, ".txt"))
            f.Write(String.Concat(styles, "|", ImportorExport.Text, "|", thedate))
            f.Close()
            lbl.Text = "Tracking number and styles put in queue."
        Else
            lbl.Text = "File(s) placed in folders."
        End If
        If FreightCarrier.Text = "Fedex" AndAlso ImportorExport.Text = "Import" Then
            Email.SendEmail(tracking_no, 1)
        End If
        If ImportorExport.Text = "Export" Then
            Email.SendEmail(Regex.Replace(text_style_no.Text, "[\n\r]", " "), 2)
        End If

    End Sub

    Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load
        Dim UserCookie As HttpCookie = Request.Cookies("Edrawbacks_UserInfo")
        If UserCookie Is Nothing OrElse Not Regex.IsMatch(UserCookie("UserName"), "admin", RegexOptions.IgnoreCase) Then
            Response.Redirect("login.aspx")
        End If
        lblLogged.Text = "You are logged in as " & UserCookie("Username")
        ClientScript.RegisterClientScriptBlock(Me.GetType(), "isPostBack", String.Format("var isPostback = {0};", IsPostBack.ToString().ToLower()), True)
        If Not Page.IsPostBack Then
            Dim DataSource As String = ConfigurationManager.AppSettings("DataSource")
            Dim InitialCatalog As String = ConfigurationManager.AppSettings("InitialCatalog")
            Dim UserId As String = ConfigurationManager.AppSettings("UserId")
            Dim Password As String = ConfigurationManager.AppSettings("Password")

            Dim connectionString As String = "Data Source=" & DataSource & ";Initial Catalog=" & InitialCatalog & ";User Id=" & UserId & ";Password=" & Password & ";"
            Dim queryString As String = "Select UserName from Users where username <> 'Admin';"
            Using connection As New SqlConnection(connectionString)
                Dim command As New SqlCommand(queryString, connection)
                Try
                    connection.Open()
                    ddlCompany.DataSource = command.ExecuteReader
                    ddlCompany.DataTextField = "UserName"
                    ddlCompany.DataValueField = "UserName"
                    ddlCompany.DataBind()

                Catch ex As Exception

                End Try

            End Using

        End If

    End Sub
    Protected Sub Page_PreRenderComplete(sender As Object, e As EventArgs) Handles Me.PreRenderComplete
        text_style_no.Text = String.Empty
        text_tracking_no.Text = String.Empty
    End Sub
End Class
