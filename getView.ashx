<%@ WebHandler Language="VB" Class="getView" %>

Imports System
Imports System.Web
Imports System.IO
Imports System.Data.SqlClient

Public Class getView : Implements IHttpHandler

    Public Sub ProcessRequest(ByVal context As HttpContext) Implements IHttpHandler.ProcessRequest
        Dim sb As StringBuilder = New StringBuilder
        Dim sb2 As StringBuilder = New StringBuilder
        Dim response As String = String.Empty
        Dim response2 As String = String.Empty
        Dim direc As String = ConfigurationManager.AppSettings.Item("RootPath") & context.Request.QueryString("company")
        Dim DataSource As String = ConfigurationManager.AppSettings("DataSource")
        Dim InitialCatalog As String = ConfigurationManager.AppSettings("InitialCatalog")
        Dim UserId As String = ConfigurationManager.AppSettings("UserId")
        Dim Password As String = ConfigurationManager.AppSettings("Password")
        Dim Status As Boolean


        Dim connectionString As String = "Data Source=" & DataSource & ";Initial Catalog=" & InitialCatalog & ";User Id=" & UserId & ";Password=" & Password & ";"
        Dim queryString As String
        Using connection As New SqlConnection(connectionString)

            Try
                Dim dt As Date = Now
                If Not String.IsNullOrEmpty(context.Request.QueryString("dt")) Then
                    dt = Date.Parse(context.Request.QueryString("dt"))
                End If
                connection.Open()
                If Not String.IsNullOrEmpty(context.Request.QueryString("dn")) Then
                    If context.Request.QueryString("tftea") = "true" Then
                        queryString = "Select distinct style from export where company= @company and drawback_number= @dn and export_date > dateadd(year,-5,'" + dt + "');"
                    Else
                        queryString = "Select distinct style from export where company= @company and drawback_number= @dn and export_date > dateadd(year,-3,'" + dt + "');"
                    End If

                    Dim command As New SqlCommand(queryString, connection)
                    command.Parameters.AddWithValue("@company", context.Request.QueryString("company"))
                    command.Parameters.AddWithValue("@dn", context.Request.QueryString("dn"))
                    Using datareader As SqlDataReader = command.ExecuteReader
                        If datareader.HasRows Then
                            Do While datareader.Read
                                sb.Append(datareader("style") & "|")
                            Loop
                        End If
                    End Using
                Else
                    Dim h As Hashtable = New Hashtable
                    queryString = "select path,approved from status where username=@username;"
                    Using c As SqlCommand = New SqlCommand(queryString, connection)
                        c.Parameters.AddWithValue("@username", context.Request.QueryString("company"))
                        Using r As SqlDataReader = c.ExecuteReader
                            While r.Read
                                h.Add(r("path").ToString.ToLower, r("approved"))
                            End While
                        End Using
                    End Using
                    For Each stylefolder In Directory.GetDirectories(direc)
                        Dim isPending As Boolean = False
                        Dim Mport As Boolean = False
                        Dim id As Date = DateTime.MinValue, ed As Date = DateTime.MinValue
                        Dim stts As Boolean = False
                        If Regex.IsMatch(context.Request.QueryString("show"), "Pending|Done|Exports") Then
                            If Regex.IsMatch(context.Request.QueryString("show"), "Pending|Exports") Then
                                stts = False
                            Else
                                stts = True
                            End If
                            For Each datefolder In Directory.GetDirectories(stylefolder)
                                Dim datefoldername As String = New DirectoryInfo(datefolder).Name
                                Dim dated = Regex.Match(datefoldername, "[0-9]{4}-[0-9]{2}-[0-9]{2} [Import|Export|Destroyed]").Value
                                Dim imp = Regex.Match(datefoldername, "Import").Value
                                If imp = "Import" Then
                                    Mport = True
                                    id = DateTime.ParseExact(Regex.Match(datefoldername, "[0-9]{4}-[0-9]{2}-[0-9]{2}").Value, "yyyy-MM-dd", System.Globalization.CultureInfo.InvariantCulture)
                                End If
                                'queryString = "Select Approved from Status where Username= @Username and Path= @Path;"
                                'Dim command As New SqlCommand(queryString, connection)
                                'command.Parameters.AddWithValue("@Username", context.Request.QueryString("company"))
                                'command.Parameters.AddWithValue("@Path", datefolder)
                                ' Status =  command.ExecuteScalar
                                ' Much faster                                
                                Status = h(datefolder.ToLower)
                                If Regex.IsMatch(datefoldername, "Export|Destroyed") AndAlso Status = stts Then
                                    ed = DateTime.ParseExact(Regex.Match(datefoldername, "[0-9]{4}-[0-9]{2}-[0-9]{2}").Value, "yyyy-MM-dd", System.Globalization.CultureInfo.InvariantCulture)
                                    If context.Request.QueryString("tftea") = "" Then
                                        If id.AddYears(5) >= dt AndAlso ed.AddYears(5) >= dt Then
                                            isPending = True
                                        End If
                                    Else
                                        If ed.AddYears(3) >= dt AndAlso ed.AddYears(-3) <= id Then
                                            isPending = True
                                        End If
                                    End If


                                End If
                            Next
                            If Regex.IsMatch(context.Request.QueryString("show"), "Exports") Then
                                If isPending = True OrElse ed = DateTime.MinValue OrElse ed.AddYears(3) <= Today Then
                                    Continue For
                                End If
                            Else
                                If isPending = False OrElse Mport = False OrElse (isPending = False AndAlso Mport = False) Then
                                    Continue For
                                End If
                            End If


                            sb.Append(Regex.Match(stylefolder, "[^\\]*(\w+)$").Value & "|")

                        Else
                            sb.Append(Regex.Match(stylefolder, "[^\\]*(\w+)$").Value & "|")
                        End If
                    Next
                End If
                queryString = "Select distinct drawback_number from export where company= @company ;"
                Dim command2 As New SqlCommand(queryString, connection)
                command2.Parameters.AddWithValue("@company", context.Request.QueryString("company"))
                Using datareader As SqlDataReader = command2.ExecuteReader
                    If datareader.HasRows Then
                        Do While datareader.Read
                            sb2.Append(datareader("drawback_number") & "|")
                        Loop
                    End If
                End Using
            Catch ex As Exception

            End Try
        End Using



        response = sb.ToString.TrimEnd("|")
        response2 = sb2.ToString.TrimEnd("|")
        context.Response.ContentType = "text/plain"
        context.Response.Write("{ ""response"": """ + response + """,""response2"": """ + response2 + """ }")
    End Sub

    Public ReadOnly Property IsReusable() As Boolean Implements IHttpHandler.IsReusable
        Get
            Return False
        End Get
    End Property

End Class