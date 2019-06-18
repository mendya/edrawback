Imports System.IO

Partial Class CheckQueue
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load
        If (Request.Cookies("Edrawbacks_UserInfo") Is Nothing) Then
            Response.Redirect("Login.aspx", False)
        End If
        Dim rootdir As String = ConfigurationManager.AppSettings("RootPath") & Request.Cookies("Edrawbacks_UserInfo")("UserName") & "\"
        Dim dirinfo As DirectoryInfo = New DirectoryInfo(rootdir + "Queue")
        Dim searchPattern As String = "*"
        Dim fi As FileInfo() = dirinfo.GetFiles(searchPattern)

        For Each f As FileInfo In fi

            dirinfo = New DirectoryInfo(rootdir + "AllFiles")
            searchPattern = String.Concat("*", f.Name.Split(".")(0), "*")


            Dim fi2 As FileInfo() = dirinfo.GetFiles(searchPattern)
            For Each f2 As FileInfo In fi2
                Dim alltext As String = File.ReadAllText(f.FullName)
                Dim styles = alltext.Split("|")(0)
                Dim importexport As String = alltext.Split("|")(1)
                Dim dateOfIE As String = alltext.Split("|")(2)
                For Each Style As String In styles.Split(",")
                    If Not Directory.Exists(String.Concat(rootdir, Style)) Then
                        Directory.CreateDirectory(String.Concat(rootdir, Style))
                    End If
                    If Not Directory.Exists(String.Concat(rootdir, Style, "\", dateOfIE, " ", importexport)) Then
                        Directory.CreateDirectory(String.Concat(rootdir, Style, "\", dateOfIE, " ", importexport))
                    End If
                    File.Copy(f2.FullName, String.Concat(rootdir, Style, "\", dateOfIE, " ", importexport, "\", f2.Name), True)
                Next
                File.Delete(f.FullName)
            Next

        Next
    End Sub
End Class
