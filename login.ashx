<%@ WebHandler Language="VB" Class="login" %>

Imports System
Imports System.Web
Imports System.IO
Imports System.Data.SqlClient

Public Class login : Implements IHttpHandler
    
    Public Sub ProcessRequest(ByVal context As HttpContext) Implements IHttpHandler.ProcessRequest
        Dim json As String = New StreamReader(context.Request.InputStream).ReadToEnd()
        Dim username As String = context.Request.QueryString("username")
        Dim password As String = context.Request.QueryString("password")
        
        Dim response As String = String.Empty
        Dim DataSource As String = ConfigurationManager.AppSettings("DataSource")
        Dim InitialCatalog As String = ConfigurationManager.AppSettings("InitialCatalog")
        Dim UserId As String = ConfigurationManager.AppSettings("UserId")
        Dim Pssword As String = ConfigurationManager.AppSettings("Password")

        Dim connectionString As String = "Data Source=" & DataSource & ";Initial Catalog=" & InitialCatalog & ";User Id=" & UserId & ";Password=" & Pssword & ";"
        Dim queryString As String = "Select Password from Users where Username= @Username;"
        Using connection As New SqlConnection(connectionString)
            Dim command As New SqlCommand(queryString, connection)
            command.Parameters.AddWithValue("@Username", username)
            Try
                connection.Open()
                Dim rslt = command.ExecuteScalar
                If rslt = password AndAlso Not String.IsNullOrEmpty(password) Then
                    response = "OK"
                   

                  
                Else
                    response = "BAD"
                End If

            Catch ex As Exception
              
            End Try
        End Using
       
        context.Response.Write(response)
    End Sub
 
    Public ReadOnly Property IsReusable() As Boolean Implements IHttpHandler.IsReusable
        Get
            Return False
        End Get
    End Property







        
        
End Class
