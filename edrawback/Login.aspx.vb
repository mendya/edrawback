Imports System.Data.SqlClient

Partial Class Login
    Inherits System.Web.UI.Page

    Protected Sub btnSubmit_Click(sender As Object, e As EventArgs) Handles btnSubmit.Click

       
    End Sub

    Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load
        If (Not Request.Cookies("Edrawbacks_UserInfo") Is Nothing) Then
            Dim myCookie As HttpCookie
            myCookie = New HttpCookie("Edrawbacks_UserInfo")
            myCookie.Expires = DateTime.Now.AddDays(-1D)
            Response.Cookies.Add(myCookie)
        End If
        Dim DataSource As String = ConfigurationManager.AppSettings("DataSource")
        Dim InitialCatalog As String = ConfigurationManager.AppSettings("InitialCatalog")
        Dim UserId As String = ConfigurationManager.AppSettings("UserId")
        Dim Pssword As String = ConfigurationManager.AppSettings("Password")
        Dim username As String = Context.Request.QueryString("username")
        Dim password As String = Context.Request.QueryString("password")
        Dim connectionString As String = "Data Source=" & DataSource & ";Initial Catalog=" & InitialCatalog & ";User Id=" & UserId & ";Password=" & Pssword & ";"
        Dim queryString As String = "Select Password from Users where Username= @Username;"
        Using connection As New SqlConnection(connectionString)
            Dim command As New SqlCommand(queryString, connection)
            command.Parameters.AddWithValue("@Username", username)
            Try
                connection.Open()
                Dim rslt = command.ExecuteScalar
                If password = rslt AndAlso Not String.IsNullOrEmpty(password) Then
                    Dim UserCookie As HttpCookie = New HttpCookie("Edrawbacks_UserInfo")
                    UserCookie("UserName") = username
                    Response.Cookies.Add(UserCookie)
                    If UserCookie("UserName").ToLower = "Admin".ToLower Then
                        Response.Redirect("Admin.aspx")
                    Else
                        Response.Redirect("User.aspx")
                    End If

                    'Response.Redirect("http://" & txtName.Text & ".edrawbacks.com")
                Else
                    lblerror.Text = "Invalid Username and/or Password."
                End If

            Catch ex As Exception
                lblerror.Text = ex.Message
            End Try
        End Using
    End Sub
End Class
