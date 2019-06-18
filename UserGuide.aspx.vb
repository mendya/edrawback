
Partial Class UserGuide
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load
        Dim UserCookie As HttpCookie = Request.Cookies("Edrawbacks_UserInfo")
        If UserCookie Is Nothing Then
            Response.Redirect("login.aspx")
        End If
        lblLogged.Text = "You are logged in as " & UserCookie("Username")
    End Sub
End Class
