<%@ WebHandler Language="VB" Class="getViewDates" %>

Imports System
Imports System.Web
Imports System.IO
Imports System.Data.SqlClient

Public Class getViewDates : Implements IHttpHandler

    Public Sub ProcessRequest(ByVal context As HttpContext) Implements IHttpHandler.ProcessRequest
        Dim sb As StringBuilder = New StringBuilder
        Dim response As String = String.Empty
        Dim dn = context.Request.QueryString("dn")
        Dim company = context.Request.QueryString("company")
        Dim style = context.Request.QueryString("style")
        Dim direc As String = ConfigurationManager.AppSettings.Item("RootPath") & company & "\" & style

        Dim DataSource As String = ConfigurationManager.AppSettings("DataSource")
        Dim InitialCatalog As String = ConfigurationManager.AppSettings("InitialCatalog")
        Dim UserId As String = ConfigurationManager.AppSettings("UserId")
        Dim Password As String = ConfigurationManager.AppSettings("Password")
        Dim connectionString As String = "Data Source=" & DataSource & ";Initial Catalog=" & InitialCatalog & ";User Id=" & UserId & ";Password=" & Password & ";MultipleActiveResultSets=True" & ";"
        Using connection As New SqlConnection(connectionString)
            connection.Open()
            'If Not String.IsNullOrEmpty(dn) Then
            '    Using command As New SqlCommand("select import_date,export_date,destroyed from export where company=@company and style=@style and drawback_number=@dn and export_date > dateadd(year,-3,getdate()) ;", connection)
            '        command.Parameters.AddWithValue("@company", context.Request.QueryString("company"))
            '        command.Parameters.AddWithValue("@style", style)
            '        command.Parameters.AddWithValue("@dn", dn)
            '        Using datareader As SqlDataReader = command.ExecuteReader
            '            If datareader.HasRows Then
            '                Dim list As List(Of String) = New List(Of String)

            '                While datareader.Read
            '                    If Not list.Contains(CDate(datareader("import_date")).ToString("yyyy-MM-dd") & " Import") Then
            '                        list.Add(CDate(datareader("import_date")).ToString("yyyy-MM-dd") & " Import")
            '                    End If
            '                    If Not list.Contains(CDate(datareader("export_date")).ToString("yyyy-MM-dd") & " Export") Then
            '                        list.Add(CDate(datareader("export_date")).ToString("yyyy-MM-dd") & IIf(datareader("destroyed") = "true", " Destroyed", " Export"))
            '                    End If
            '                End While
            '                list.Sort()
            '                For Each item In list
            '                    Using Command2 As New SqlCommand("select approved , comments from status where username=@company and path=@path;", connection)
            '                        Command2.Parameters.AddWithValue("@company", context.Request.QueryString("company"))
            '                        Command2.Parameters.AddWithValue("@path", direc & "\" & item)
            '                        Using datareader2 As SqlDataReader = Command2.ExecuteReader
            '                            If datareader2.HasRows Then
            '                                datareader2.Read()
            '                                sb.Append(item & "|" & IIf(datareader2("approved"), "true", "false") & "|" & datareader2("comments") & "|info|")

            '                            Else
            '                                sb.Append(item & "|false||info|")
            '                            End If
            '                        End Using

            '                    End Using
            '                Next
            '            End If
            '        End Using
            '    End Using
            ' Else

            For Each f In BlobHelper.ListFolderBlobsNonRecursive("docroot", company & "/" & style)
                Dim file = f.FileName.Replace("/", "")
                Dim fullpath = Regex.Replace(f.BlobFilePath, "/$", "")
                Dim r As String = Regex.Match(File, "[^\\]*(\w+)$").Value
                Dim x As String = IIf(Regex.IsMatch(r, "Import|Export|Destroyed"), "info", "view")
                Dim doit As Boolean = True
                If Not String.IsNullOrEmpty(dn) Then
                    If Regex.IsMatch(File, "Import") Then
                        Using Command As New SqlCommand("select drawback_number from export where drawback_number=@dn and company=@company and style=@style and import_date=@import_date; ", connection)
                            Command.Parameters.AddWithValue("@company", company)
                            Command.Parameters.AddWithValue("@style", style)
                            Command.Parameters.AddWithValue("@import_date", Regex.Replace(Regex.Match(File, "[^\\]*(\w+)$").Value, " Import", ""))
                            Command.Parameters.AddWithValue("@dn", dn)
                            Dim res = Command.ExecuteScalar
                            If String.IsNullOrEmpty(res) Then
                                doit = False
                            End If
                        End Using
                    ElseIf Regex.IsMatch(File, "Export|Destroyed") Then
                        Using Command As New SqlCommand("select drawback_number from export where drawback_number=@dn and company=@company and style=@style and export_date=@export_date; ", connection)
                            Command.Parameters.AddWithValue("@company", company)
                            Command.Parameters.AddWithValue("@style", style)
                            Command.Parameters.AddWithValue("@export_date", Regex.Replace(Regex.Match(File, "[^\\]*(\w+)$").Value, " Export| Destroyed", ""))
                            Command.Parameters.AddWithValue("@dn", dn)
                            Dim res = Command.ExecuteScalar
                            If String.IsNullOrEmpty(res) Then
                                doit = False
                            End If
                        End Using
                    End If

                End If
                If doit Then
                    Using Command As New SqlCommand("select approved , comments from status where username=@company and path=@path;", connection)
                        Command.Parameters.AddWithValue("@company", context.Request.QueryString("company"))
                        Command.Parameters.AddWithValue("@path", fullpath)
                        Using datareader As SqlDataReader = Command.ExecuteReader
                            If datareader.HasRows Then
                                datareader.Read()
                                sb.Append(r & "|" & IIf(datareader("approved"), "true", "false") & "|" & datareader("comments") & "|" & x & "|")

                            Else
                                sb.Append(r & "|false||" & x & "|")
                            End If
                        End Using

                    End Using
                End If



            Next
            '  End If

        End Using



        response = sb.ToString.TrimEnd("|")
        context.Response.ContentType = "text/plain"
        context.Response.Write("{ ""response"": """ + response + """ }")
    End Sub

    Public ReadOnly Property IsReusable() As Boolean Implements IHttpHandler.IsReusable
        Get
            Return False
        End Get
    End Property

End Class