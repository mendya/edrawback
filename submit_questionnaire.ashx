<%@ WebHandler Language="VB" Class="submit_questionnaire" %>

Imports System
Imports System.Web
Imports System.IO
Imports System.Net.Mail

Public Class submit_questionnaire : Implements IHttpHandler
    
    Public Sub ProcessRequest(ByVal context As HttpContext) Implements IHttpHandler.ProcessRequest
        Dim json As String = New StreamReader(context.Request.InputStream).ReadToEnd()
        Dim files = context.Request.Params("files")
        Dim username = context.Request.Params("un")
        '2). 10005736503_01.pdf|1). 10002168412_01.pdf|
        
        Dim mail As New MailMessage()
        mail.From = New MailAddress("info@edrawbacks.com")
        mail.[To].Add("mendya@crotongroup.com")
        mail.CC.Add("shmuelm@edrawbacks.com")
        mail.Subject = "Drawback Questionairre"
        mail.Body = json
        For Each file In files.Split("|")
            If Not String.IsNullOrEmpty(file) Then
                Dim f = file.Substring(4)
                mail.Attachments.Add(New System.Net.Mail.Attachment(ConfigurationManager.AppSettings("UploadPath") + username + "_" + f))
            End If
        Next
        mail.IsBodyHtml = True
        Dim smtp As New SmtpClient()
        smtp.Host = "mail.edrawbacks.com"
        'Or Your SMTP Server Address
        smtp.Credentials = New System.Net.NetworkCredential(ConfigurationManager.AppSettings("Email_User"), ConfigurationManager.AppSettings("Email_Password"))
        'Or your Smtp Email ID and Password
        smtp.EnableSsl = False
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