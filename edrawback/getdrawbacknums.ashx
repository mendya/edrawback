<%@ WebHandler Language="VB" Class="getdrawbacknums" %>

Imports System
Imports System.Web
Imports System.Data.SqlClient

Public Class getdrawbacknums : Implements IHttpHandler
    
    Public Sub ProcessRequest(ByVal context As HttpContext) Implements IHttpHandler.ProcessRequest
        Dim company As String = context.Request.QueryString("company")
        Dim status As String = context.Request.QueryString("status")
        Dim response As String = String.Empty
        Dim drawback_number As String = String.Empty

        
        Dim DataSource As String = ConfigurationManager.AppSettings("DataSource")
        Dim InitialCatalog As String = ConfigurationManager.AppSettings("InitialCatalog")
        Dim UserId As String = ConfigurationManager.AppSettings("UserId")
        Dim Password As String = ConfigurationManager.AppSettings("Password")
        Dim connectionString As String = "Data Source=" & DataSource & ";Initial Catalog=" & InitialCatalog & ";User Id=" & UserId & ";Password=" & Password & ";MultipleActiveResultSets=True" & ";"
        
        Dim sb As StringBuilder = New StringBuilder
       
        Using connection As New SqlConnection(connectionString)
            Try
                connection.Open()
                Using Command As New SqlCommand("Select distinct e.drawback_number from export e join drawbacks d on e.drawback_number=d.drawback_number where e.company=@company and e.submitted <> 1 and e.drawback_number <> '' and d.status=@status", connection)
                    Command.Parameters.AddWithValue("@company", company)
                    Command.Parameters.AddWithValue("@status", status)
                    Using datareader As SqlDataReader = Command.ExecuteReader
                        If datareader.HasRows Then
                            Do While datareader.Read
                                
                                sb.Append(datareader("drawback_number") & "|")
                            Loop
                        End If
                    End Using
                End Using
              
                  
                        
                               
                                            
                   
                
                response = sb.ToString.TrimEnd("|")
                response = sb.ToString & "unassigned"
            Catch ex As Exception
                response = ex.Message
            End Try
            
        End Using
       
        response = "{ ""response"": """ & response & """ }"
        
        context.Response.ContentType = "text/plain"
        context.Response.Write(response)
    End Sub
 
    Public ReadOnly Property IsReusable() As Boolean Implements IHttpHandler.IsReusable
        Get
            Return False
        End Get
    End Property

End Class