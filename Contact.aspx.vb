Imports Email

Partial Class Contact
    Inherits System.Web.UI.Page

    Protected Sub Unnamed1_Click(sender As Object, e As EventArgs)
        Dim body As StringBuilder = New StringBuilder
        body.Append(txtName.Text & "<br />" & txtContact.Text & "<br />" & txtAddress.Text & "<br />" & txtPhone.Text & "<br />" & txtEmail.Text & "<br /><br />" & txtMessage.Text)
        If Not q1.SelectedIndex = -1 Then
            body.Append("<br /><br />Does your company import merchandise to the United States? " & q1.SelectedValue)
        End If
        If Not String.IsNullOrEmpty(q2.Text) Then
            body.Append("<br /><br />Which import custom brokers does your company use? " & q2.Text)
        End If
        If Not String.IsNullOrEmpty(q3.Text) Then
            body.Append("<br /><br />Approximately what is the import tax rate that your company pays? " & q3.Text)
        End If
        If Not String.IsNullOrEmpty(q4.Text) Then
            body.Append("<br /><br />How much of that duty paid merchandise does your company export? " & q4.Text)
        End If
        If Not q5.SelectedIndex = -1 Then
            body.Append("<br /><br />Does your company export to Canada or Mexico? " & q5.SelectedValue)
        End If
        If Not String.IsNullOrEmpty(q6.Text) Then
            body.Append("<br /><br />Which export custom broker does your company use? " & q6.Text)
        End If

        Dim subject As String = "New Message From Edrawback Customer"

        lblMsg.Text = SendEmail(body.ToString, subject)


    End Sub
End Class
