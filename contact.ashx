<%@ WebHandler Language="VB" Class="contact" %>

Imports System
Imports System.Web
Imports System.IO
Imports System.Net.Mail

Public Class contact : Implements IHttpHandler

    Public Sub ProcessRequest(ByVal context As HttpContext) Implements IHttpHandler.ProcessRequest
        Dim json As String = New StreamReader(context.Request.InputStream).ReadToEnd()
        If Not json.Split("|")(6) = "395783495" Then
            Exit Sub
        End If
        Dim body = "<p>Company Name: " + json.Split("|")(0) + "</p>" + "<p>Contact Name: " + json.Split("|")(1) + "</p>" _
                + "<p>Contact Address: " + json.Split("|")(2) + "</p>" + "<p>Contact Phone: " + json.Split("|")(3) + "</p>" _
                + "<p>Contact Email: " + json.Split("|")(4) + "</p>" + "<p>Contact Message: " + json.Split("|")(5) + "</p>"

        Dim bodywrap = _
            "<html>" + _
                "<head>" + _
                    "<style>" + _
                        "#2col" + _
                        "{" + _
                        "    -webkit-column-count: 2;" + _
                        "    -webkit-column-gap: 10px;" + _
                        "    -moz-column-count: 2;" + _
                        "    -moz-column-gap: 10px;" + _
                        "    column-count:2;" + _
                        "    column-gap:10px;" + _
                        "}" + _
                    "</style>" + _
                "</head>" + _
                "<body>" + _
                    "<div id=2col>" + body + "</div>" + _
                "</body>" + _
            "</html>"

        Dim mail As New MailMessage()
        mail.From = New MailAddress("postmaster@edrawback.com")
        mail.[To].Add("mendya@crotongroup.com")
        'mail.CC.Add("shmuelm@edrawbacks.com")
        mail.Subject = "Drawback Questionairre"
        mail.Body = bodywrap

        mail.IsBodyHtml = True
        Dim smtp As New SmtpClient()
        smtp.Host = "mail.edrawback.com"
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