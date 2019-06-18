<%@ WebHandler Language="VB" Class="updatedrawbacknumber" %>

Imports System
Imports System.Web
Imports System.Data.SqlClient

Public Class updatedrawbacknumber : Implements IHttpHandler
    
    Public Sub ProcessRequest(ByVal context As HttpContext) Implements IHttpHandler.ProcessRequest
        Dim company As String = context.Request.QueryString("company")
        Dim style As String = context.Request.QueryString("style")
        Dim exportdate As String = context.Request.QueryString("exportdate")
        Dim drawbacknumber As String = context.Request.QueryString("drawbacknumber")
        Dim response As String = String.Empty
      
        Dim DataSource As String = ConfigurationManager.AppSettings("DataSource")
        Dim InitialCatalog As String = ConfigurationManager.AppSettings("InitialCatalog")
        Dim UserId As String = ConfigurationManager.AppSettings("UserId")
        Dim Password As String = ConfigurationManager.AppSettings("Password")
        Dim connectionString As String = "Data Source=" & DataSource & ";Initial Catalog=" & InitialCatalog & ";User Id=" & UserId & ";Password=" & Password & ";MultipleActiveResultSets=True" & ";"
        
        Dim sb As StringBuilder = New StringBuilder
       
        Using connection As New SqlConnection(connectionString)
            Try
                connection.Open()
                Using Command As New SqlCommand("select drawback_number from drawbacks where drawback_number=@drawback_number", connection)
                    Command.Parameters.AddWithValue("@drawback_number", drawbacknumber)
                    Dim result = Command.ExecuteScalar()
                    If result Is DBNull.Value OrElse result Is Nothing Then
                        Using c As New SqlCommand("insert into drawbacks(drawback_number,status,filed_date)values(@drawback_number,'PENDING','" + Now.ToShortDateString + "')", connection)
                            c.Parameters.AddWithValue("@drawback_number", drawbacknumber)
                            c.ExecuteNonQuery()
                        End Using
                    End If
                End Using
                    
                    
                Using Command As New SqlCommand("Update export set drawback_number=@drawback_number where company=@company and style=@style and export_date=@export_date", connection)
                    Command.Parameters.AddWithValue("@company", company)
                    Command.Parameters.AddWithValue("@style", style)
                    Command.Parameters.AddWithValue("@export_date", exportdate)
                    Command.Parameters.AddWithValue("@drawback_number", drawbacknumber)
                    response = drawbacknumber
                    Command.ExecuteNonQuery()
                End Using
            Catch ex As Exception

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