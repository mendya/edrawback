<%@ WebHandler Language="VB" Class="getViewDates" %>

Imports System
Imports System.Web
Imports System.IO
Imports System.Data.SqlClient

Public Class getViewDates : Implements IHttpHandler

    Public Sub ProcessRequest(ByVal context As HttpContext) Implements IHttpHandler.ProcessRequest
        Dim sb As StringBuilder = New StringBuilder
        Dim response As String = String.Empty
        Dim company = context.Request.QueryString("company")
        Dim style = context.Request.QueryString("style")
        Dim date_and_type = context.Request.QueryString("date")
        Dim only_date = date_and_type.Split(" ")(0)
        Dim impexpdes = context.Request.QueryString("date").Split(" ")(1)
        Dim checked = context.Request.QueryString("checked")
        Dim comments = context.Request.QueryString("comments")
        Dim od = context.Request.QueryString("cd")

        Dim DataSource As String = ConfigurationManager.AppSettings("DataSource")
        Dim InitialCatalog As String = ConfigurationManager.AppSettings("InitialCatalog")
        Dim UserId As String = ConfigurationManager.AppSettings("UserId")
        Dim Password As String = ConfigurationManager.AppSettings("Password")
        Dim connectionString As String = "Data Source=" & DataSource & ";Initial Catalog=" & InitialCatalog & ";User Id=" & UserId & ";Password=" & Password & ";MultipleActiveResultSets=True" & ";"
        Dim errr As Boolean = False
        Dim res As Object
        Using connection As New SqlConnection(connectionString)
            connection.Open()
            Dim ipath As String = company & "/" & style & "/"
            Dim path As String = company & "/" & style & "/" & date_and_type
            Dim oldpath = path
            If (Not String.IsNullOrEmpty(od) AndAlso Not date_and_type = od) Then
                Try
                    oldpath = ipath & od
                    BlobHelper.RenameBlob(oldpath, path, "docroot")
                    'Directory.Move(ipath & od, path)
                    Dim sql As String = String.Empty
                    If impexpdes = "Import" Then
                        sql = "update import set import_date=@date where company=@company and style=@style and import_date=@old_date;update export set import_date=@date where company=@company and style=@style and import_date=@old_date"
                    Else
                        sql = "update export set export_date=@date where company=@company and style=@style and export_date=@old_date;"
                    End If
                    Using Command As New SqlCommand(sql, connection)
                        Command.Parameters.AddWithValue("@company", company)
                        Command.Parameters.AddWithValue("@style", style)
                        Command.Parameters.AddWithValue("@date", only_date)
                        Command.Parameters.AddWithValue("@old_date", od.Split(" ")(0))
                        Command.ExecuteNonQuery()
                    End Using

                Catch ex As Exception
                    errr = True
                End Try

            End If



            Using Command As New SqlCommand("update status set path=@path, approved=@approved,comments=@comments where username=@company and path=@oldpath;", connection)
                Command.Parameters.AddWithValue("@company", company)
                Command.Parameters.AddWithValue("@path", path)
                Command.Parameters.AddWithValue("@oldpath", oldpath)
                Command.Parameters.AddWithValue("@approved", IIf(checked = "true", 1, 0))
                Command.Parameters.AddWithValue("@comments", comments)
                res = Command.ExecuteNonQuery

            End Using
            If res = 0 Then
                Using Command As New SqlCommand("insert into status(username,path,approved,comments)values(@company,@path,@approved,@comments);", connection)
                    Command.Parameters.AddWithValue("@company", company)
                    Command.Parameters.AddWithValue("@path", path)
                    Command.Parameters.AddWithValue("@approved", IIf(checked = "true", 1, 0))
                    Command.Parameters.AddWithValue("@comments", comments)
                    res = Command.ExecuteNonQuery
                End Using
            End If

        End Using



        response = sb.ToString.TrimEnd("|")
        context.Response.ContentType = "text/plain"
        context.Response.Write("{ ""response"": """ + errr.ToString + """ }")
    End Sub

    Public ReadOnly Property IsReusable() As Boolean Implements IHttpHandler.IsReusable
        Get
            Return False
        End Get
    End Property

End Class