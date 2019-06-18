Imports System.IO

Partial Class test
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load
        Using File.Open("c:\test.txt", FileMode.Create)

        End Using
    End Sub
End Class
