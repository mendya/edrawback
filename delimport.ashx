<%@ WebHandler Language="VB" Class="delimport" %>

Imports System
Imports System.Web
Imports System.IO
Imports System.Data.SqlClient

Public Class delimport : Implements IHttpHandler
    
    Public Sub ProcessRequest(ByVal context As HttpContext) Implements IHttpHandler.ProcessRequest
        Dim json As String = New StreamReader(context.Request.InputStream).ReadToEnd()
        Dim response As String = String.Empty
        Dim rows As Integer
        
        Dim DataSource As String = ConfigurationManager.AppSettings("DataSource")
        Dim InitialCatalog As String = ConfigurationManager.AppSettings("InitialCatalog")
        Dim UserId As String = ConfigurationManager.AppSettings("UserId")
        Dim Password As String = ConfigurationManager.AppSettings("Password")
        Dim connectionString As String = "Data Source=" & DataSource & ";Initial Catalog=" & InitialCatalog & ";User Id=" & UserId & ";Password=" & Password & ";"
        
        Dim company As String = json.Split("|")(0)
        Dim style As String = json.Split("|")(1)
        Dim importdate As String = json.Split("|")(2)
        Dim sizecolor As String = json.Split("|")(3)
       
        Using connection As New SqlConnection(connectionString)
            Try
                connection.Open()
                Using Command As New SqlCommand("Delete from import where company=@company and style=@style and sizecolor=@sizecolor and import_date=@import_date;", connection)
                    Command.Parameters.AddWithValue("@company", company)
                    Command.Parameters.AddWithValue("@style", style)
                    Command.Parameters.AddWithValue("@sizecolor", sizecolor)
                    Command.Parameters.AddWithValue("@import_date", importdate)
                    rows = Command.ExecuteNonQuery()
                    response = "{ ""response"": """ & sizecolor & " Deleted!" & """ }"
                End Using
            Catch ex As Exception
                response = "{ ""response"": """ & ex.Message & """ }"
            End Try
            
        End Using
       
                
        
            context.Response.ContentType = "text/plain"
        context.Response.Write(response)
    End Sub
 
    Public ReadOnly Property IsReusable() As Boolean Implements IHttpHandler.IsReusable
        Get
            Return False
        End Get
    End Property

End Class