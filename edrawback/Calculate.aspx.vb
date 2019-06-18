Imports System.Text.RegularExpressions
Partial Class Calculate
    Inherits System.Web.UI.Page

    Protected Sub btnSubmit_Click(sender As Object, e As EventArgs) Handles btnSubmit.Click
        If Not IsNumeric(ExportPerYear.Text) OrElse Not IsNumeric(TaxRate.Text.Replace("%", "")) Then
            lblMsg.Text = "Please enter valid values for Export Per Year and Tax Rate."
            Exit Sub
        End If
        Dim exPrYr As Decimal = Regex.Replace(ExportPerYear.Text, "[^.0-9]", "")
        Dim txRt As Decimal = Regex.Replace(TaxRate.Text, "[^.0-9]", "")
        lblMsg.Text = "You are entitled to $" & exPrYr * (txRt / 100) * 0.99 & " back."
    End Sub

    Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load
       
    End Sub
End Class
