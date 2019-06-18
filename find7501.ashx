<%@ WebHandler Language="VB" Class="Find7501" %>

Imports System
Imports System.Web
Imports System.IO
Imports System.Data.SqlClient

Public Class Find7501 : Implements IHttpHandler
    
    Public Sub ProcessRequest(ByVal context As HttpContext) Implements IHttpHandler.ProcessRequest
        Dim json As String = New StreamReader(context.Request.InputStream).ReadToEnd()
        Dim response As String = String.Empty
        
        Dim DataSource As String = ConfigurationManager.AppSettings("DataSource")
        Dim InitialCatalog As String = ConfigurationManager.AppSettings("InitialCatalog")
        Dim UserId As String = ConfigurationManager.AppSettings("UserId")
        Dim Password As String = ConfigurationManager.AppSettings("Password")
        Dim connectionString As String = "Data Source=" & DataSource & ";Initial Catalog=" & InitialCatalog & ";User Id=" & UserId & ";Password=" & Password & ";"
            '------------
        Using connection As New SqlConnection(connectionString)
            Try
                connection.Open()
                Using Command As New SqlCommand("Select *  From import Where s7501=@s7501;", connection)
                    Command.Parameters.AddWithValue("@s7501", json.Trim)
                    Using datareader As SqlDataReader = Command.ExecuteReader
                        If datareader.HasRows Then
                            datareader.Read()
                            response = datareader("port_code") & "|" & datareader("origin") & "|" & datareader("conversion").ToString & "|" & datareader("tot_val").ToString & "|" & datareader("hmf") & "|" & datareader("mpf").ToString
                        End If
                    End Using
                End Using
                        
               
                                    
            Catch ex As Exception
                response = "{ ""response"": """ & ex.Message & """ }"
            End Try
            
        End Using
       
        context.Response.ContentType = "text/plain"
        context.Response.Write("{ ""response"": """ & response & """ }")
    End Sub
 
    Public ReadOnly Property IsReusable() As Boolean Implements IHttpHandler.IsReusable
        Get
            Return False
        End Get
    End Property

End Class