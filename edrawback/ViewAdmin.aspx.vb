Imports System.IO
Imports System.Data.SqlClient
Imports System.Data
Imports System.Drawing
Imports System.Net.Mail

Partial Class ViewAdmin
    Inherits System.Web.UI.Page

    'The root path on the server
    Public Shared RootPath As String

    'The current operation path
    Public Shared CurrentLocation As String

    Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load
        Dim UserCookie As HttpCookie = Request.Cookies("Edrawbacks_UserInfo")
        If UserCookie Is Nothing Then
            Response.Redirect("login.aspx")
        End If
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


        RootPath = ConfigurationManager.AppSettings.Item("RootPath") & ddlCompany.SelectedValue

        If Not Page.IsPostBack Then
            CurrentLocation = RootPath
            If Not Directory.Exists(RootPath) Then
                Directory.CreateDirectory(RootPath)
            End If
            ShowFolderItems()
        End If

        ShowCurrentLocation()
        lbMessage.Text = String.Empty
        lblLogged.Text = "You are logged in as " & UserCookie("Username")
    End Sub

    Private Sub ShowFolderItems()
        gvFileSystem.AutoGenerateColumns = False
        gvFileSystem.DataSource = OCDIOObject.GetAllItemsInTheDirectory(CurrentLocation, ddlCompany.SelectedValue)
        gvFileSystem.DataBind()
    End Sub
    Private Sub ShowCurrentLocation()
        Try
            Dim strArrayLocation As String() = CurrentLocation.Replace(RootPath, "Root").Split(New Char() {"\"c})
            'http://weblog.west-wind.com/posts/2006/Apr/09/ASPNET-20-MasterPages-and-FindControl
            Dim panelCurrentLocation As Panel = DirectCast(Master.FindControl("ContentPlaceHolder2").FindControl("pnlCurrentLocation"), Panel)
            Dim panelGoBack As Panel = DirectCast(Master.FindControl("ContentPlaceHolder2").FindControl("pnlGoBack"), Panel)

            panelCurrentLocation.Controls.Clear()
            panelGoBack.Controls.Clear()

            Dim i As Integer
            For i = 0 To strArrayLocation.Length - 1
                Dim lbtnFolder As New LinkButton With { _
                    .Text = strArrayLocation(i), _
                    .ID = ("lbtnFolder" & i.ToString) _
                }
                AddHandler lbtnFolder.Click, New EventHandler(AddressOf lbtnFolder_Click)
                Dim path As String = strArrayLocation(0)
                Dim j As Integer = 1
                Do While (j <= i)
                    path = (path & "\" & strArrayLocation(j))
                    j += 1
                Loop
                lbtnFolder.ToolTip = path
                panelCurrentLocation.Controls.Add(lbtnFolder)
                Dim lbFolder As New Label With { _
                    .Text = " \ " _
                }
                panelCurrentLocation.Controls.Add(lbFolder)
                If i = strArrayLocation.Length - 2 Then
                    Dim lbtnGoBack As New LinkButton With { _
                        .Text = "Go Back", _
                        .ID = ("lbtnGoBack" & i.ToString) _
                    }
                    AddHandler lbtnGoBack.Click, New EventHandler(AddressOf lbtnFolder_Click)
                    path = strArrayLocation(0)
                    j = 1
                    Do While (j <= i)
                        path = (path & "\" & strArrayLocation(j))
                        j += 1
                    Loop
                    lbtnGoBack.ToolTip = path
                    panelGoBack.Controls.Add(lbtnGoBack)
                End If
            Next i
        Catch ex As Exception
            Response.Redirect("viewAdmin.aspx")
        End Try

    End Sub
    Protected Sub lbtnFolder_Click(ByVal sender As Object, ByVal e As EventArgs)
        CurrentLocation = DirectCast(sender, LinkButton).ToolTip.Replace("Root", RootPath)
        AddHandler MyBase.Init, New EventHandler(AddressOf lbtnFolder_Click)

        ShowFolderItems()
        ShowCurrentLocation()
    End Sub
    Protected Sub gvFileSystem_RowDataBound(ByVal sender As Object, _
                                            ByVal e As GridViewRowEventArgs)
        If ((e.Row.RowType = DataControlRowType.DataRow) AndAlso ( _
            (e.Row.RowState = DataControlRowState.Normal) OrElse ( _
                e.Row.RowState = DataControlRowState.Alternate))) Then
            DirectCast(e.Row.Cells.Item(4).Controls.Item(0), LinkButton).Attributes.Add( _
                "onclick", _
                String.Concat( _
                    New String() { _
                        "javascript:return confirm('Are you sure you want to delete the ", _
                        IIf((e.Row.Cells.Item(3).Text = "Folder"), "Folder", "File"), _
                        " " & ChrW(65306) & """", _
                        DirectCast(e.Row.Cells.Item(0).Controls.Item(0),  _
                    LinkButton).Text, """?')"}))
            If Not Regex.IsMatch(DirectCast(e.Row.Cells.Item(0).Controls.Item(0), LinkButton).Text, "^[0-9]{4}-[0-9]{2}-[0-9]{2} [Import|Export|Destroyed]") Then
                gvFileSystem.HeaderRow.Cells(6).Visible = False
                e.Row.Cells(6).Visible = False
                gvFileSystem.HeaderRow.Cells(8).Visible = False
                e.Row.Cells(8).Visible = False
                gvFileSystem.HeaderRow.Cells(9).Visible = False
                e.Row.Cells(9).Visible = False
            End If
            If DirectCast(e.Row.Cells.Item(6).FindControl("chbx"), CheckBox).Checked Then
                e.Row.BackColor = Color.Gray
            End If
        End If
    End Sub
    Protected Sub gvFileSystem_RowCommand(ByVal sender As Object, _
                                          ByVal e As GridViewCommandEventArgs)
        Dim fileExtension As Integer = Convert.ToInt32(e.CommandArgument)
        CurrentLocation = _
            gvFileSystem.DataKeys.Item(0).Values.Item(2).ToString

        lbMessage.Text = ""

        ' Delete the file or folder
        If (e.CommandName = "DeleteFileOrFolder") Then
            If (gvFileSystem.DataKeys.Item(fileExtension).Values.Item(0).ToString = _
                "Folder") Then
                lbMessage.Text = OCDIOObject.DeleteFolder( _
                    gvFileSystem.DataKeys.Item(fileExtension).Values.Item(1).ToString, RootPath)
            Else
                lbMessage.Text = OCDIOObject.DeleteFile( _
                    gvFileSystem.DataKeys.Item(fileExtension).Values.Item(1).ToString)
            End If

            ShowFolderItems()
            ShowCurrentLocation()
        End If

        ' Open the folder or download the file
        If (e.CommandName = "Open") Then
            If (gvFileSystem.DataKeys.Item(fileExtension).Values.Item(0).ToString = _
                "Folder") Then
                CurrentLocation = _
                    (CurrentLocation & "\" & _
                     gvFileSystem.DataKeys.Item(fileExtension).Values.Item(3).ToString)

                ShowFolderItems()
                ShowCurrentLocation()
            Else
                OCDIOObject.DownloadFile( _
                    gvFileSystem.DataKeys.Item(fileExtension).Values.Item(1).ToString)
            End If
        End If

        ' Rename the file or folder
        If (e.CommandName = "Rename") Then
            pnlRename.Visible = True
            lbOldName.Text = _
                gvFileSystem.DataKeys.Item(fileExtension).Values.Item(3).ToString
            lbOldName.ToolTip = _
                gvFileSystem.DataKeys.Item(fileExtension).Values.Item(1).ToString
            pnlRename.ToolTip = _
                gvFileSystem.DataKeys.Item(fileExtension).Values.Item(0).ToString
            tbNewName.Focus()
        End If
        If (e.CommandName = "ShowPopup") Then
            txtComments.Text = DirectCast(DirectCast(DirectCast(e.CommandSource, System.Web.UI.WebControls.LinkButton).NamingContainer, System.Web.UI.WebControls.GridViewRow).FindControl("clbl"), System.Web.UI.WebControls.Label).Text
            hdnFull.Value = gvFileSystem.DataKeys.Item(fileExtension).Values.Item(1).ToString
            hdnStatus.Value = DirectCast(DirectCast(DirectCast(e.CommandSource, System.Web.UI.WebControls.LinkButton).NamingContainer, System.Web.UI.WebControls.GridViewRow).FindControl("chbx"), System.Web.UI.WebControls.CheckBox).Checked
            Popup(True)
        End If
    End Sub
    Sub Popup(isDisplay As Boolean)

        Dim builder As StringBuilder = New StringBuilder()
        If (isDisplay) Then

            builder.Append("<script language=JavaScript> ShowPopup(); </script>\n")
            Page.ClientScript.RegisterStartupScript(GetType(ViewAdmin), "ShowPopup", builder.ToString())

        Else

            builder.Append("<script language=JavaScript> HidePopup(); </script>\n")
            Page.ClientScript.RegisterStartupScript(GetType(ViewAdmin), "HidePopup", builder.ToString())
        End If
    End Sub

    Protected Sub btnCancle_Click(ByVal sender As Object, ByVal e As EventArgs)
        pnlRename.Visible = False
        lbMessage.Text = ""
    End Sub
    Protected Sub btnRename_Click(ByVal sender As Object, ByVal e As EventArgs)
        If (tbNewName.Text = "") Then
            lbMessage.Text = "Please input the new name of the file or folder."
        Else
            If (pnlRename.ToolTip = "Folder") Then
                lbMessage.Text = _
                    OCDIOObject.RenameFolder(lbOldName.ToolTip, tbNewName.Text, RootPath)
            Else
                lbMessage.Text = _
                    OCDIOObject.RenameFile(lbOldName.ToolTip, tbNewName.Text, RootPath)
            End If

            tbNewName.Text = ""
            pnlRename.Visible = False

            ShowFolderItems()
        End If
    End Sub
    ''' <summary>
    ''' This handles the style filter
    ''' </summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    ''' <remarks></remarks>
    Protected Sub btnSubmit_Click(sender As Object, e As EventArgs) Handles btnSubmit.Click
        gvFileSystem.AutoGenerateColumns = False
        gvFileSystem.DataSource = _
            OCDIOObject.GetAllItemsInTheDirectory(RootPath, txtFilter.Text, Request.Cookies("Edrawbacks_UserInfo")("UserName"))
        gvFileSystem.DataBind()
    End Sub
    Protected Sub btnClr_Click(sender As Object, e As EventArgs) Handles btnClr.Click
        CurrentLocation = RootPath
        ShowFolderItems()
        txtFilter.Text = ""
    End Sub
    Protected Sub Update_Comments()
        Dim DataSource As String = ConfigurationManager.AppSettings("DataSource")
        Dim InitialCatalog As String = ConfigurationManager.AppSettings("InitialCatalog")
        Dim UserId As String = ConfigurationManager.AppSettings("UserId")
        Dim Password As String = ConfigurationManager.AppSettings("Password")
        Dim connectionString As String = "Data Source=" & DataSource & ";Initial Catalog=" & InitialCatalog & ";User Id=" & UserId & ";Password=" & Password & ";"
        '
        Dim status As Boolean = IIf(hdnStatus.Value = "True", 1, 0)
        Dim fullpath As String = hdnFull.Value
        Dim rows As Integer
        Dim sqlString As String = String.Empty
        Dim command As SqlCommand
        '-------------------------------------------------------
        If status = False AndAlso String.IsNullOrEmpty(txtComments.Text) Then
            sqlString = "Delete from Status where Username= @Username and Path= @Path;"
            Using connection As New SqlConnection(connectionString)
                command = New SqlCommand(sqlString, connection)
                command.Parameters.AddWithValue("@Username", ddlCompany.SelectedValue)
                command.Parameters.AddWithValue("@Path", fullpath)
                Try
                    connection.Open()
                    rows = command.ExecuteNonQuery


                Catch ex As Exception

                End Try
            End Using
        Else
            sqlString = "Select Count(*) From Status Where UserName=@Username and Path=@Path;"
            Using connection As New SqlConnection(connectionString)
                command = New SqlCommand(sqlString, connection)
                command.Parameters.AddWithValue("@Username", ddlCompany.SelectedValue)
                command.Parameters.AddWithValue("@Path", fullpath)
                Try
                    connection.Open()
                    rows = command.ExecuteScalar

                Catch ex As Exception

                End Try
            End Using
            If rows = 1 Then
                sqlString = "Update Status Set Approved=@Approved,Comments=@Comments Where Username=@Username and Path=@Path;"
                Using connection As New SqlConnection(connectionString)
                    command = New SqlCommand(sqlString, connection)
                    command.Parameters.AddWithValue("@Username", ddlCompany.SelectedValue)
                    command.Parameters.AddWithValue("@Path", fullpath)
                    command.Parameters.AddWithValue("@Approved", status)
                    command.Parameters.AddWithValue("@Comments", txtComments.Text)
                    Try
                        connection.Open()
                        rows = command.ExecuteNonQuery


                    Catch ex As Exception

                    End Try
                End Using
            Else
                sqlString = "Insert into Status(UserName,Path,Approved,Comments) Values(@Username,@Path,@Approved,@Comments);"
                Using connection As New SqlConnection(connectionString)
                    command = New SqlCommand(sqlString, connection)
                    command.Parameters.AddWithValue("@Username", ddlCompany.SelectedValue)
                    command.Parameters.AddWithValue("@Path", fullpath)
                    command.Parameters.AddWithValue("@Approved", status)
                    command.Parameters.AddWithValue("@Comments", txtComments.Text)
                    Try
                        connection.Open()
                        rows = command.ExecuteNonQuery

                    Catch ex As Exception

                    End Try
                End Using
            End If


        End If



        ShowFolderItems()
    End Sub
    Protected Sub btnUpdate_Click(sender As Object, e As EventArgs)
        Update_Comments()

    End Sub

    Protected Sub Unnamed_CheckedChanged(sender As Object, e As EventArgs)
        Dim DataSource As String = ConfigurationManager.AppSettings("DataSource")
        Dim InitialCatalog As String = ConfigurationManager.AppSettings("InitialCatalog")
        Dim UserId As String = ConfigurationManager.AppSettings("UserId")
        Dim Password As String = ConfigurationManager.AppSettings("Password")
        Dim connectionString As String = "Data Source=" & DataSource & ";Initial Catalog=" & InitialCatalog & ";User Id=" & UserId & ";Password=" & Password & ";"
        '
        Dim chkStatus As CheckBox = DirectCast(sender, CheckBox)
        Dim row As GridViewRow = DirectCast(chkStatus.NamingContainer, GridViewRow)
        Dim status As Boolean = chkStatus.Checked
        Dim fullpath As String = row.Cells(7).Text
        Dim rows As Integer
        Dim sqlString As String = String.Empty
        Dim command As SqlCommand
        '-------------------------------------------------------
        If status = False AndAlso String.IsNullOrEmpty(DirectCast(row.Cells(8).FindControl("clbl"), Label).Text) Then
            sqlString = "Delete from Status where Username= @Username and Path= @Path;"
            Using connection As New SqlConnection(connectionString)
                command = New SqlCommand(sqlString, connection)
                command.Parameters.AddWithValue("@Username", ddlCompany.SelectedValue)
                command.Parameters.AddWithValue("@Path", fullpath)
                Try
                    connection.Open()
                    rows = command.ExecuteNonQuery
                    Dim clr As Color = Color.FromArgb(Int32.Parse("EFF3FB", Globalization.NumberStyles.HexNumber))
                    If row.DataItemIndex = 0 Then
                        row.BackColor = clr
                    Else
                        row.BackColor = IIf(gvFileSystem.Rows(row.DataItemIndex - 1).BackColor = Color.White, clr, Color.White)
                    End If

                Catch ex As Exception

                End Try
            End Using
        Else
            sqlString = "Select Count(*) From Status Where UserName=@Username and Path=@Path;"
            Using connection As New SqlConnection(connectionString)
                command = New SqlCommand(sqlString, connection)
                command.Parameters.AddWithValue("@Username", ddlCompany.SelectedValue)
                command.Parameters.AddWithValue("@Path", fullpath)
                Try
                    connection.Open()
                    rows = command.ExecuteScalar

                Catch ex As Exception

                End Try
            End Using
            If rows = 1 Then
                sqlString = "Update Status Set Approved=@Approved,Comments=@Comments Where Username=@Username and Path=@Path;"
                Using connection As New SqlConnection(connectionString)
                    command = New SqlCommand(sqlString, connection)
                    command.Parameters.AddWithValue("@Username", ddlCompany.SelectedValue)
                    command.Parameters.AddWithValue("@Path", fullpath)
                    command.Parameters.AddWithValue("@Approved", status)
                    command.Parameters.AddWithValue("@Comments", DirectCast(row.Cells(8).FindControl("clbl"), Label).Text)
                    Try
                        connection.Open()
                        rows = command.ExecuteNonQuery

                        row.BackColor = Drawing.Color.Gray
                    Catch ex As Exception

                    End Try
                End Using
            Else
                sqlString = "Insert into Status(UserName,Path,Approved,Comments) Values(@Username,@Path,@Approved,@Comments);"
                Using connection As New SqlConnection(connectionString)
                    command = New SqlCommand(sqlString, connection)
                    command.Parameters.AddWithValue("@Username", ddlCompany.SelectedValue)
                    command.Parameters.AddWithValue("@Path", fullpath)
                    command.Parameters.AddWithValue("@Approved", status)
                    command.Parameters.AddWithValue("@Comments", DirectCast(row.Cells(8).FindControl("clbl"), Label).Text)
                    Try
                        connection.Open()
                        rows = command.ExecuteNonQuery

                    Catch ex As Exception

                    End Try
                End Using
            End If
            Dim clr As Color = Color.FromArgb(Int32.Parse("EFF3FB", Globalization.NumberStyles.HexNumber))
            If status = False Then
                If row.DataItemIndex = 0 Then
                    row.BackColor = clr
                Else
                    row.BackColor = IIf(gvFileSystem.Rows(row.DataItemIndex - 1).BackColor = Color.White, clr, Color.White)
                End If
            Else
                row.BackColor = Color.Gray
            End If

        End If



        ShowFolderItems()
    End Sub

    Protected Sub ddlCompany_SelectedIndexChanged(sender As Object, e As EventArgs)
        RootPath = ConfigurationManager.AppSettings.Item("RootPath") & ddlCompany.SelectedValue
        CurrentLocation = RootPath
        If Not Directory.Exists(RootPath) Then
            Directory.CreateDirectory(RootPath)
        End If
        ShowFolderItems()
        ShowCurrentLocation()
    End Sub
    Protected Sub Page_PreRenderComplete(sender As Object, e As EventArgs) Handles Me.PreRenderComplete
        Dim sb As StringBuilder = New StringBuilder
        sb.Append("<script>var Tags = [")
        For Each row As GridViewRow In gvFileSystem.Rows
            If row.RowType = DataControlRowType.DataRow Then
                If row.RowIndex = gvFileSystem.Rows.Count - 1 Then
                    sb.Append("""" & DirectCast(row.Cells.Item(0).Controls(0), LinkButton).Text & """")
                Else
                    sb.Append("""" & DirectCast(row.Cells.Item(0).Controls(0), LinkButton).Text & """" & ",")
                End If
            End If


        Next
        sb.Append(" ];</script>")

        ClientScript.RegisterStartupScript(Me.GetType(), "key", sb.ToString)
    End Sub

    Protected Sub btnUpdateEmail_Click(sender As Object, e As EventArgs)
        Update_Comments()
        sendemail()
    End Sub
    Protected Sub sendemail()
        Dim DataSource As String = ConfigurationManager.AppSettings("DataSource")
        Dim InitialCatalog As String = ConfigurationManager.AppSettings("InitialCatalog")
        Dim UserId As String = ConfigurationManager.AppSettings("UserId")
        Dim Password As String = ConfigurationManager.AppSettings("Password")
        Dim connectionString As String = "Data Source=" & DataSource & ";Initial Catalog=" & InitialCatalog & ";User Id=" & UserId & ";Password=" & Password & ";"
        '

        Dim retVal As String = String.Empty
        Dim sqlString As String = "Select Email From Users Where UserName=@Username;"
        Using connection As New SqlConnection(connectionString)
            Dim command As SqlCommand = New SqlCommand(sqlString, connection)
            command.Parameters.AddWithValue("@Username", ddlCompany.SelectedValue)
            Try
                connection.Open()
                retVal = command.ExecuteScalar

            Catch ex As Exception

            End Try
        End Using
        If String.IsNullOrEmpty(retVal) Then
            Return
        End If
        Dim mail As New MailMessage
        mail.From = New MailAddress("administrator@edrawbacks.com")
        mail.[To].Add(retVal)
        mail.Subject = "New Message From EDRAWBACKS for Style """ & Regex.Match(CurrentLocation, "\\(.+\\)*(.+)").Groups(2).Value & """ and Folder """ & Regex.Match(hdnFull.Value, "\\(.+\\)*(.+)").Groups(2).Value & """"
        mail.Body = Regex.Replace(txtComments.Text, "\r\n", "<br />")
        mail.IsBodyHtml = True
        ' Dim attachemnt As System.Net.Mail.Attachment = New System.Net.Mail.Attachment(hdnFull.Value)
        ' mail.Attachments.Add(attachemnt)
        Dim smtp As New SmtpClient()
        smtp.Host = "smtp.gmail.com"
        smtp.Port = 587
        'Or Your SMTP Server Address
        smtp.Credentials = New System.Net.NetworkCredential("mendya@crotongroup.com", ConfigurationManager.AppSettings("Email_Password"))
        'Or your Smtp Email ID and Password
        smtp.EnableSsl = True
        Try
            smtp.Send(mail)
        Catch ex As Exception

        End Try

    End Sub

End Class
