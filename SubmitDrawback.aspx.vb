Imports System.Data.SqlClient

Partial Class SubmitDrawback
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load
        Dim UserCookie As HttpCookie = Request.Cookies("Edrawbacks_UserInfo")
        If UserCookie Is Nothing Then
            Response.Redirect("login.aspx")
        End If
        lblLogged.Text = "You are logged in as " & UserCookie("Username")
        Dim sb As StringBuilder = New StringBuilder

        If Not Page.IsPostBack Then
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
                                sb.Append(dr("username") & "|")
                            End While
                        End If
                    End Using
                End Using

            End Using

        End If
        Dim str = "<script>var companies = '" & sb.ToString.TrimEnd("|") & "';</script>"

        ClientScript.RegisterStartupScript(Me.GetType(), "key", Str)
    End Sub


End Class
