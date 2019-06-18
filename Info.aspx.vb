Imports System.Data.SqlClient

Partial Class Info
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load
        Dim UserCookie As HttpCookie = Request.Cookies("Edrawbacks_UserInfo")
        If UserCookie Is Nothing Then
            Response.Redirect("login.aspx")
        End If
        lblLogged.Text = "You are logged in as " & UserCookie("Username")

        Dim DataSource As String = ConfigurationManager.AppSettings("DataSource")
        Dim InitialCatalog As String = ConfigurationManager.AppSettings("InitialCatalog")
        Dim UserId As String = ConfigurationManager.AppSettings("UserId")
        Dim Password As String = ConfigurationManager.AppSettings("Password")
        Dim connectionString As String = "Data Source=" & DataSource & ";Initial Catalog=" & InitialCatalog & ";User Id=" & UserId & ";Password=" & Password & ";"

        Dim selectString As String = "Select Company,Contact,Address,Phone,Email,BondedBy,HowMuch,ExpDate from Users Where username=@Username;"
        Using connection As New SqlConnection(connectionString)
            Dim command As New SqlCommand(selectString, connection)
            command.Parameters.AddWithValue("@Username", Request.Cookies("Edrawbacks_UserInfo")("UserName"))
            Try
                connection.Open()
                Dim DataReader As SqlDataReader = command.ExecuteReader
                If DataReader.HasRows Then
                    Do While DataReader.Read
                        lblCompanyName.Text = DataReader("Company")
                        lblContact.Text = DataReader("Contact")
                        lblAddress.Text = DataReader("Address")
                        lblPhone.Text = DataReader("Phone")
                        lblEmail.Text = DataReader("Email")
                        lblExpDate.Text = DataReader("ExpDate")
                    Loop
                End If

            Catch ex As Exception

            End Try
        End Using

    End Sub
End Class
