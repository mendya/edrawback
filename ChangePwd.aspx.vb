Imports System.Data.SqlClient

Partial Class ChangePwd
    Inherits System.Web.UI.Page

    Protected Sub btnSubmit_Click(sender As Object, e As EventArgs) Handles btnSubmit.Click
        If Not newPwd.Text = newPwdConfirm.Text Then
            lblError.Text = "Passwords do not match."
            Exit Sub
        End If
        Dim DataSource As String = ConfigurationManager.AppSettings("DataSource")
        Dim InitialCatalog As String = ConfigurationManager.AppSettings("InitialCatalog")
        Dim UserId As String = ConfigurationManager.AppSettings("UserId")
        Dim Password As String = ConfigurationManager.AppSettings("Password")

        Dim connectionString As String = "Data Source=" & DataSource & ";Initial Catalog=" & InitialCatalog & ";User Id=" & UserId & ";Password=" & Password & ";"
        Dim queryString As String = "Select Password from Users where Username= @Username;"
        Using connection As New SqlConnection(connectionString)
            Dim command As New SqlCommand(queryString, connection)
            Dim UserCookie As HttpCookie = Request.Cookies("Edrawbacks_UserInfo")
            command.Parameters.AddWithValue("@Username", UserCookie("UserName"))
            Try
                connection.Open()
                Password = command.ExecuteScalar
                If Password = oldPwd.Text Then
                    Dim updateString As String = "Update Users Set Password = '" & newPwd.Text & "' where Username = '" & UserCookie("UserName") & "';"
                    command = New SqlCommand(updateString, connection)
                    command.ExecuteNonQuery()
                    lblError.Text = "Password Updated."
                Else
                    lblError.Text = "Invalid Password."
                End If

            Catch ex As Exception
                lblError.Text = ex.Message
            End Try
        End Using
    End Sub

    Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load
        Dim UserCookie As HttpCookie = Request.Cookies("Edrawbacks_UserInfo")
        If UserCookie Is Nothing Then
            Response.Redirect("login.aspx")
        End If
        lblLogged.Text = "You are logged in as " & UserCookie("Username")
    End Sub
End Class
