Imports Microsoft.VisualBasic
Imports System.Net.Mail

Public Class Email

    Public Shared Function SendEmail(ByVal body As String, ByVal subject As String) As String
        Dim mail As New MailMessage()
        mail.From = New MailAddress("info@edrawbacks.com")
        mail.[To].Add("info@edrawbacks.com")
        mail.Subject = subject
        mail.Body = body.ToString
        mail.IsBodyHtml = True
        Dim smtp As New SmtpClient()
        smtp.Host = ConfigurationManager.AppSettings("Email_Host")
        'Or Your SMTP Server Address
        smtp.Credentials = New System.Net.NetworkCredential(ConfigurationManager.AppSettings("Email_User"), ConfigurationManager.AppSettings("Email_Password"))
        'Or your Smtp Email ID and Password
        smtp.EnableSsl = False
        Try
            smtp.Send(mail)
        Catch ex As Exception
            Return ex.Message
        End Try
        Return "Email Sent!"
    End Function
    Public Shared Sub SendEmail(ByVal trackingNo As String, ByVal email As Integer)
        If email = 1 Then
            Dim mail As New MailMessage()
            mail.[To].Add("mendya@crotongroup.com")
            'mail.[To].Add("clearancesupport@ftn.fedex.com")
            ' mail.[To].Add("Another Email ID where you wanna send same email")
            mail.From = New MailAddress("mendya@crotongroup.com")
            mail.Subject = String.Concat("Documents request for tracking # """, trackingNo, """")

            Dim Body As StringBuilder = New StringBuilder
            Body.AppendLine("Hi.")
            Body.AppendLine()
            Body.AppendLine(String.Concat("This is Croton Watch Company, Fedex Account# 136143140, requesting Shipping Documents-7501 Customs Document, the Invoice , and the Packing Slip, be emailed to mendya@crotongroup.com ( or just reply to this email) for tracking number: """, trackingNo, """."))
            Body.AppendLine()
            Body.AppendLine("Thank you very much.")
            mail.Body = Body.ToString

            mail.IsBodyHtml = True
            Dim smtp As New SmtpClient()
            smtp.Host = "smtp.gmail.com"
            'Or Your SMTP Server Address
            smtp.Credentials = New System.Net.NetworkCredential("mendya@crotongroup.com", ConfigurationManager.AppSettings("Email_Password"))
            'Or your Smtp Email ID and Password
            smtp.EnableSsl = True
            Try
                smtp.Send(mail)
            Catch ex As Exception

            End Try
        End If
        If email = 2 Then
            Dim mail As New MailMessage()
            mail.[To].Add("mendya@crotongroup.com")
            'mail.[To].Add("clearancesupport@ftn.fedex.com")
            ' mail.[To].Add("Another Email ID where you wanna send same email")
            mail.From = New MailAddress("mendya@crotongroup.com")
            mail.Subject = String.Concat("Export request From Croton for Style #'s """, trackingNo, """")

            'Dim Body As StringBuilder = New StringBuilder
            'Body.AppendLine("Hi.")
            'Body.AppendLine("<br />")
            'Body.AppendLine(String.Concat("This is Croton Watch Company, Fedex Account# 136143140, requesting Shipping Documents-7501 Customs Document, the Invoice , and the Packing Slip, be emailed to mendya@crotongroup.com ( or just reply to this email) for tracking number: """, trackingNo, """."))
            'Body.AppendLine()
            'Body.AppendLine("Thank you very much.")
            'mail.Body = Body.ToString

            mail.IsBodyHtml = True
            Dim smtp As New SmtpClient()
            smtp.Host = "smtp.gmail.com"
            'Or Your SMTP Server Address
            smtp.Credentials = New System.Net.NetworkCredential("mendya@crotongroup.com", ConfigurationManager.AppSettings("Email_Password"))
            'Or your Smtp Email ID and Password
            smtp.EnableSsl = True
            Try
                smtp.Send(mail)
            Catch ex As Exception

            End Try
        End If
    End Sub
End Class
