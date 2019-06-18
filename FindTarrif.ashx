<%@ WebHandler Language="VB" Class="FindTarrif" %>

Imports System
Imports System.Web
Imports System.IO
Imports System.Data.SqlClient

Public Class FindTarrif : Implements IHttpHandler
    
    Public Sub ProcessRequest(ByVal context As HttpContext) Implements IHttpHandler.ProcessRequest
        Dim json As String = New StreamReader(context.Request.InputStream).ReadToEnd()
        Dim response As String = String.Empty
        Dim response2 As String = String.Empty
        
        Dim related_tarrifs As String = String.Empty
        
        Dim DataSource As String = ConfigurationManager.AppSettings("DataSource")
        Dim InitialCatalog As String = ConfigurationManager.AppSettings("InitialCatalog")
        Dim UserId As String = ConfigurationManager.AppSettings("UserId")
        Dim Password As String = ConfigurationManager.AppSettings("Password")
        Dim connectionString As String = "Data Source=" & DataSource & ";Initial Catalog=" & InitialCatalog & ";User Id=" & UserId & ";Password=" & Password & ";"
            
        Using connection As New SqlConnection(connectionString)
            Try
                connection.Open()
                Using Command As New SqlCommand("Select *  From Tarrifs Where Tarrif_Code=@Tarrif_Code;", connection)
                    Command.Parameters.AddWithValue("@Tarrif_Code", json)
                    Using datareader As SqlDataReader = Command.ExecuteReader
                        If datareader.HasRows Then
                            datareader.Read()
                            response = datareader("description") & "|" & datareader("percent_rate") & "|" & datareader("piece_rate") & "|" & datareader("kilo_rate")
                            related_tarrifs = datareader("related_tarrifs")
                        End If
                    End Using
                End Using
                        
                For Each Str As String In related_tarrifs.Split("|")
                    If Not String.IsNullOrEmpty(Str) Then
                        Using Command As New SqlCommand("Select *  From Tarrifs Where Tarrif_Code=@Tarrif_Code;", connection)
                            Command.Parameters.AddWithValue("@Tarrif_Code", Str)
                            Using datareader As SqlDataReader = Command.ExecuteReader
                                If datareader.HasRows Then
                                    datareader.Read()
                                    response2 += Str & "|" & datareader("description") & "|" & datareader("percent_rate") & "|" & datareader("piece_rate") & "|" & datareader("kilo_rate") & "|"

                                End If
                            End Using
                        End Using
                    End If
                Next
               
                                    
            Catch ex As Exception
                response = "{ ""response"": """ & ex.Message & """ }"
            End Try
            
        End Using
       
        response2 = Regex.Replace(response2, ".$", "")
        context.Response.ContentType = "text/plain"
        context.Response.Write("{ ""response"": """ & response & """,""response2"": """ + response2 + """ }")
    End Sub
 
    Public ReadOnly Property IsReusable() As Boolean Implements IHttpHandler.IsReusable
        Get
            Return False
        End Get
    End Property

End Class