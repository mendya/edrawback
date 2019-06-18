<%@ WebHandler Language="VB" Class="getexports" %>

Imports System
Imports System.Web
Imports System.IO
Imports System.Data.SqlClient
Imports System.Net

Public Class getexports : Implements IHttpHandler
    
    Public Sub ProcessRequest(ByVal context As HttpContext) Implements IHttpHandler.ProcessRequest
        Dim company As String = context.Request.QueryString("company")
        Dim response As String = String.Empty
        Dim rows As Integer
        
        Dim DataSource As String = ConfigurationManager.AppSettings("DataSource")
        Dim InitialCatalog As String = ConfigurationManager.AppSettings("InitialCatalog")
        Dim UserId As String = ConfigurationManager.AppSettings("UserId")
        Dim Password As String = ConfigurationManager.AppSettings("Password")
        Dim connectionString As String = "Data Source=" & DataSource & ";Initial Catalog=" & InitialCatalog & ";User Id=" & UserId & ";Password=" & Password & ";MultipleActiveResultSets=True" & ";"
        
        Dim sb As StringBuilder = New StringBuilder
        sb.Append("[")
       
        Using connection As New SqlConnection(connectionString)
            Try
                connection.Open()
                Using Command As New SqlCommand("Select * from export where company=@company ", connection)
                    Command.Parameters.AddWithValue("@company", company)

                    Using datareader As SqlDataReader = Command.ExecuteReader
                        If datareader.HasRows Then
                            Do While datareader.Read
                                Using command2 As New SqlCommand("select * from import Where company=@company and style=@style and sizecolor=@sizecolor and import_date=@import_date ;", connection)
                                    command2.Parameters.AddWithValue("@company", company)
                                    command2.Parameters.AddWithValue("@style", datareader("style"))
                                    command2.Parameters.AddWithValue("@sizecolor", datareader("sizecolor"))
                                    command2.Parameters.AddWithValue("@import_date", datareader("import_date"))
                                    Using datareader2 As SqlDataReader = command2.ExecuteReader
                                        If datareader2.HasRows Then
                                            datareader2.Read()
                                            
                                            
                                            sb.Append("{""id"":""" & datareader("style") & """,""sc"":""" & datareader("sizecolor") & """,""7501"":""" & datareader2("s7501") & """,""pc"":""" & datareader2("port_code") & """,""cd"":""" & "N" & """,""imd"":""" & datareader("import_date") & """,""rd"":""" & datareader("import_date") & """,""tn"":""" & datareader2("tarrif1") & """,""qe"":""" & datareader("units") & """,""vp"":""" & datareader2("price") & """,""dr"":""" & datareader("duty") & """,""tr"":""" & (CInt(datareader("units")) * CDbl(datareader("duty")) * 0.99).ToString & """},")
                                        End If
                                    End Using
                                    
                                End Using
                            Loop
                        End If
                        
                    End Using

                End Using
                '               var data = [
                '                   ["", "Maserati", "Mazda", "Mercedes", "Mini", "Mitsubishi"],
                '                   ["2009", 0, 2941, 4303, 354, 5814],
                '                   ["2010", 5, 2905, 2867, 412, 5284],
                '                   ["2011", 4, 2517, 4822, 552, 6127],
                '                   ["2012", 2, 2422, 5399, 776, 4151],
                '];
                
                
                
                response = sb.ToString.TrimEnd(",") & "]"
            Catch ex As Exception
                response = ex.Message
            End Try
            
        End Using
       
                
        
        context.Response.ContentType = "text/plain"
        context.Response.Write(response)
    End Sub
 
    Public ReadOnly Property IsReusable() As Boolean Implements IHttpHandler.IsReusable
        Get
            Return False
        End Get
    End Property







        
        
End Class
