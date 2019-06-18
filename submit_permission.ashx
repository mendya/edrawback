<%@ WebHandler Language="VB" Class="submit_permission" %>

Imports System
Imports System.Web
Imports System.IO
Imports System.Net.Mail

Public Class submit_permission : Implements IHttpHandler
    
    
    Public Sub ProcessRequest(ByVal context As HttpContext) Implements IHttpHandler.ProcessRequest
        Dim json As String = New StreamReader(context.Request.InputStream).ReadToEnd()
        Dim mail As New MailMessage()
        mail.From = New MailAddress(ConfigurationManager.AppSettings("Email_User"), json.Split("|")(4))
        mail.[To].Add(json.Split("|")(3))
        mail.[CC].Add("shmuelm@edrawbacks.com")
        mail.[CC].Add("mendya@edrawbacks.com")
        mail.Subject = "Drawback Claims"
        mail.Body = "<h4>" & json.Split("|")(0) & "</h4>" & json.Split("|")(1) & json.Split("|")(4)
        mail.IsBodyHtml = True
        Dim smtp As New SmtpClient()
        smtp.Host = "mail.edrawbacks.com"
        'Or Your SMTP Server Address
        smtp.Credentials = New System.Net.NetworkCredential(ConfigurationManager.AppSettings("Email_User"), ConfigurationManager.AppSettings("Email_Password"))
        'Or your Smtp Email ID and Password
        smtp.EnableSsl = False
        smtp.Port = 587
        Try
            smtp.Send(mail)
        Catch ex As Exception
           
        End Try
        Dim response As String
        response = "{ ""response"": """ & "Hello" & """ }"
        
        context.Response.ContentType = "text/plain"
        context.Response.Write(response)
    End Sub
 
    Public ReadOnly Property IsReusable() As Boolean Implements IHttpHandler.IsReusable
        Get
            Return False
        End Get
    End Property

End Class