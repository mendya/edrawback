Imports System.Data.SqlClient

Partial Class EditInfo
    Inherits System.Web.UI.Page
    Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load
        Dim UserCookie As HttpCookie = Request.Cookies("Edrawbacks_UserInfo")
        If UserCookie Is Nothing Then
            Response.Redirect("login.aspx")
        End If
        lblLogged.Text = "You are logged in as " & UserCookie("Username")

        If Not Page.IsPostBack Then
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
                            txtbxCompanyName.Text = DataReader("Company")
                            txtbxContact.Text = DataReader("Contact")
                            txtbxAddress.Text = DataReader("Address")
                            txtbxPhone.Text = DataReader("Phone")
                            txtbxEmail.Text = DataReader("Email")
                            txtbxBondedBy.Text = DataReader("BondedBy")
                            txtbxHowMuch.Text = DataReader("HowMuch")
                            txtbxExpDate.Text = DataReader("ExpDate")
                        Loop
                    End If

                Catch ex As Exception

                End Try
            End Using

        End If
    End Sub

    Protected Sub btnSubmit_Click(sender As Object, e As EventArgs) Handles btnSubmit.Click
        Dim DataSource As String = ConfigurationManager.AppSettings("DataSource")
        Dim InitialCatalog As String = ConfigurationManager.AppSettings("InitialCatalog")
        Dim UserId As String = ConfigurationManager.AppSettings("UserId")
        Dim Password As String = ConfigurationManager.AppSettings("Password")
        Dim connectionString As String = "Data Source=" & DataSource & ";Initial Catalog=" & InitialCatalog & ";User Id=" & UserId & ";Password=" & Password & ";"

        Dim updateString As String = "Update Users set Company=@Company,Contact=@Contact,Address=@Address,Phone=@Phone,Email=@Email,BondedBy=@BondedBy,HowMuch=@HowMuch,ExpDate=@ExpDate where Username= @Username;"
        Using connection As New SqlConnection(connectionString)
            Dim command As New SqlCommand(updateString, connection)

            command.Parameters.AddWithValue("@Username", Request.Cookies("Edrawbacks_UserInfo")("UserName"))
            command.Parameters.AddWithValue("@Company", txtbxCompanyName.Text)
            command.Parameters.AddWithValue("@Contact", txtbxContact.Text)
            command.Parameters.AddWithValue("@Address", txtbxAddress.Text)
            command.Parameters.AddWithValue("@Phone", txtbxPhone.Text)
            command.Parameters.AddWithValue("@Email", txtbxEmail.Text)
            command.Parameters.AddWithValue("@BondedBy", txtbxBondedBy.Text)
            command.Parameters.AddWithValue("@HowMuch", txtbxHowMuch.Text)
            command.Parameters.AddWithValue("@ExpDate", txtbxExpDate.Text)
            Try
                connection.Open()
                command.ExecuteNonQuery()
                lblMsg.Text = "Information Updated."
            Catch ex As Exception
                lblMsg.Text = ex.Message
            End Try
        End Using
    End Sub
End Class
