
Partial Class DocumentsAdmin
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load
        If (Request.Cookies("Edrawbacks_UserInfo") Is Nothing) Then
            Response.Redirect("Login.aspx", False)
        End If
        Dim UserCookie As HttpCookie = Request.Cookies("Edrawbacks_UserInfo")
        lblLogged.Text = "You are logged in as " & UserCookie("Username")
    End Sub
End Class
