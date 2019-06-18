Imports System.IO
Imports System.Data.SqlClient
Imports System.Data
Imports System.Drawing

Partial Public Class View
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
        View.RootPath = ConfigurationManager.AppSettings.Item("RootPath") & UserCookie("UserName")

        If Not Page.IsPostBack Then
            View.CurrentLocation = View.RootPath
            If Not Directory.Exists(View.RootPath) Then
                Directory.CreateDirectory(View.RootPath)
            End If
            ShowFolderItems()
           

        End If
       
        ShowCurrentLocation()
        lbMessage.Text = String.Empty
        lblLogged.Text = "You are logged in as " & UserCookie("Username")
    End Sub
    Private Sub ShowFolderItems()
        gvFileSystem.AutoGenerateColumns = False
        If View.CurrentLocation = View.RootPath Then
            gvFileSystem.DataSource = OCDIOObject.GetAllItemsInTheDirectory(View.CurrentLocation, txtFilter.Text, Request.Cookies("Edrawbacks_UserInfo")("UserName"))
        Else
            gvFileSystem.DataSource = OCDIOObject.GetAllItemsInTheDirectory(View.CurrentLocation, Request.Cookies("Edrawbacks_UserInfo")("UserName"))
        End If
        gvFileSystem.DataBind()
    End Sub
    Private Sub ShowCurrentLocation()
        Try
            Dim strArrayLocation As String() = View.CurrentLocation.Replace(View.RootPath, "Root").Split(New Char() {"\"c})


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
            Response.Redirect("view.aspx")
        End Try

    End Sub
    Protected Sub lbtnFolder_Click(ByVal sender As Object, ByVal e As EventArgs)
        View.CurrentLocation = DirectCast(sender, LinkButton).ToolTip.Replace("Root", View.RootPath)
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
            DirectCast(e.Row.Cells.Item(6).FindControl("chbx"), CheckBox).Attributes.Add( _
               "onclick", _
               String.Concat( _
                   New String() { _
                       "javascript:alert('Only an Admin can change the status.');return false;"}))
            If Not Regex.IsMatch(DirectCast(e.Row.Cells.Item(0).Controls.Item(0), LinkButton).Text, "[0-9]{4}-[0-9]{2}-[0-9]{2} [Import|Export|Destroyed]") Then
                gvFileSystem.HeaderRow.Cells(6).Visible = False
                e.Row.Cells(6).Visible = False
                gvFileSystem.HeaderRow.Cells(8).Visible = False
                e.Row.Cells(8).Visible = False
            End If

            If DirectCast(e.Row.Cells.Item(6).FindControl("chbx"), CheckBox).Checked Then
                e.Row.BackColor = Color.Gray
            End If
        End If
    End Sub
    Protected Sub gvFileSystem_RowCommand(ByVal sender As Object, _
                                          ByVal e As GridViewCommandEventArgs)
        Dim fileExtension As Integer = Convert.ToInt32(e.CommandArgument)
        View.CurrentLocation = _
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
                View.CurrentLocation = _
                    (View.CurrentLocation & "\" & _
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
            OCDIOObject.GetAllItemsInTheDirectory(View.RootPath, txtFilter.Text, Request.Cookies("Edrawbacks_UserInfo")("UserName"))
        gvFileSystem.DataBind()
    End Sub
    Protected Sub btnClr_Click(sender As Object, e As EventArgs) Handles btnClr.Click
        View.CurrentLocation = View.RootPath
        txtFilter.Text = ""
        ShowFolderItems()

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
End Class
