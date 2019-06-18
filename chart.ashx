<%@ WebHandler Language="VB" Class="chart" %>

Imports System
Imports System.Web
Imports System.Data.SqlClient
Imports System.IO

Public Class chart : Implements IHttpHandler

    Public Sub ProcessRequest(ByVal context As HttpContext) Implements IHttpHandler.ProcessRequest
        Dim exportdate As String = context.Request.QueryString("exportdate")
        Dim company As String = context.Request.QueryString("company")
        Dim style As String = context.Request.QueryString("style")
        Dim response As String = String.Empty
        Dim rows As Integer

        Dim DataSource As String = ConfigurationManager.AppSettings("DataSource")
        Dim InitialCatalog As String = ConfigurationManager.AppSettings("InitialCatalog")
        Dim UserId As String = ConfigurationManager.AppSettings("UserId")
        Dim Password As String = ConfigurationManager.AppSettings("Password")
        Dim connectionString As String = "Data Source=" & DataSource & ";Initial Catalog=" & InitialCatalog & ";User Id=" & UserId & ";Password=" & Password & ";MultipleActiveResultSets=True" & ";"

        Dim sb As StringBuilder = New StringBuilder
        sb.Append("Drawback# | Size/Color| 7501#| Port Code| CD| Import Date| Received Date| Tarrif#| Qty | Value | Duty Rate| Total Request|")

        Using connection As New SqlConnection(connectionString)
            Try
                connection.Open()
                Using Command As New SqlCommand("Select * from export where company=@company and style=@style and export_date=@export_date;", connection)
                    Command.Parameters.AddWithValue("@company", company)
                    Command.Parameters.AddWithValue("@style", style)
                    Command.Parameters.AddWithValue("@export_date", exportdate)
                    Using datareader As SqlDataReader = Command.ExecuteReader
                        If datareader.HasRows Then
                            Do While datareader.Read
                                Using command2 As New SqlCommand("select * from import Where company=@company and style=@style and sizecolor=@sizecolor and import_date=@import_date ;", connection)
                                    command2.Parameters.AddWithValue("@company", company)
                                    command2.Parameters.AddWithValue("@style", style)
                                    command2.Parameters.AddWithValue("@sizecolor", datareader("sizecolor"))
                                    command2.Parameters.AddWithValue("@import_date", datareader("import_date"))
                                    Using datareader2 As SqlDataReader = command2.ExecuteReader
                                        If datareader2.HasRows Then
                                            datareader2.Read()
                                            Dim t1 = datareader2("tarrif1"), t2 = datareader2("tarrif2"), t3 = datareader2("tarrif3"), t4 = datareader2("tarrif4")
                                            Dim t = t1 + IIf(String.IsNullOrEmpty(t2), "", "," + t2) + IIf(String.IsNullOrEmpty(t3), "", "," + t3) + IIf(String.IsNullOrEmpty(t4), "", "," + t4)
                                            Dim d = IIf(String.IsNullOrEmpty(datareader("drawback_number")), "-", datareader("drawback_number"))
                                            sb.Append(d & "|" & datareader("sizecolor") & "|" & datareader2("s7501") & "|" & datareader2("port_code") & "|N| " & datareader("import_date") & "|" & datareader("import_date") & "|" & datareader2("tarrif1") & "|" & datareader("units") & "|" & datareader2("price") & "|" & datareader("duty") & "|" & Decimal.Round((CInt(datareader("units")) * CDec(datareader("duty")) * CDec(0.99)), 2).ToString & "|")
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



                response = sb.ToString.TrimEnd("|")
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