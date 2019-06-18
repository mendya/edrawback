<%@ WebHandler Language="VB" Class="export" %>

Imports System
Imports System.Web
Imports System.IO
Imports System.Data.SqlClient
Imports System.Net

Public Class export : Implements IHttpHandler
        
    Public Sub ProcessRequest(ByVal context As HttpContext) Implements IHttpHandler.ProcessRequest
        Dim json As String = New StreamReader(context.Request.InputStream).ReadToEnd()
        Dim response As String = String.Empty
        Dim company As String = String.Empty
        Dim style As String = String.Empty
        Dim carrier As String = String.Empty
        Dim rnumber As String = String.Empty
        Dim country As String = String.Empty
        Dim exportdate As String = String.Empty
        Dim invoice_no As String = String.Empty
        Dim destroyed As Boolean = False
        Dim sizecolor As String = String.Empty
        Dim dutyperpiece As String = String.Empty
        Dim units As Integer = 0
        Dim dpp As Decimal = 0.0
        Dim text As String = String.Empty
        Dim drawback_number As String = String.Empty
        Dim submitted As Boolean = 0
        
        Dim i As Integer = 0, j As Integer = 10000
        
        Dim DataSource As String = ConfigurationManager.AppSettings("DataSource")
        Dim InitialCatalog As String = ConfigurationManager.AppSettings("InitialCatalog")
        Dim UserId As String = ConfigurationManager.AppSettings("UserId")
        Dim Password As String = ConfigurationManager.AppSettings("Password")
        Dim connectionString As String = "Data Source=" & DataSource & ";Initial Catalog=" & InitialCatalog & ";User Id=" & UserId & ";Password=" & Password & ";MultipleActiveResultSets=True" & ";"


        
        For Each var As String In json.Split("|")
           

            Select Case i
                Case 0
                    company = var
                Case 1
                    style = var
                Case 2
                    carrier = var
                Case 3
                    rnumber = var
                Case 4
                    country = var
                Case 5
                    exportdate = var
                Case 6
                    invoice_no = var
                Case 7
                    destroyed = var
                    j = -1
            End Select
            Select Case j
                Case 0
                    sizecolor = var
                Case 1
                    dutyperpiece = var
                Case 2
                    units = IIf(var = "", 0, var)
                    j = -1
                       
                        Dim row As Object, total As Decimal = 0.0
                        Using connection As New SqlConnection(connectionString)
                            Try
                                connection.Open()
                                Using Command As New SqlCommand("select import_date,sum(units) as units from import where company=@company and style=@style and sizecolor=@sizecolor group by import_date,duty_per_piece having import_date < @export_date and import_date > DATEADD(year, -3, @export_date) order by duty_per_piece asc, import_date asc;", connection)
                                    Command.Parameters.AddWithValue("@company", company)
                                    Command.Parameters.AddWithValue("@style", style)
                                    Command.Parameters.AddWithValue("@sizecolor", sizecolor)
                                    Command.Parameters.AddWithValue("@export_date", exportdate)
                                    Using datareader As SqlDataReader = Command.ExecuteReader
                                        If datareader.HasRows Then
                                            Do While datareader.Read

                                                Dim exportunits As Object, importunits As Integer = 0, available As Integer = 0, toinsert As Integer = 0
                                                importunits = datareader("units")
                                                Using command2 As New SqlCommand("select sum(units) from Export Where company=@company and style=@style and sizecolor=@sizecolor and import_date=@import_date and export_date <> @export_date;", connection)
                                                    command2.Parameters.AddWithValue("@company", company)
                                                    command2.Parameters.AddWithValue("@style", style)
                                                    command2.Parameters.AddWithValue("@sizecolor", sizecolor)
                                                    command2.Parameters.AddWithValue("@import_date", datareader("import_date"))
                                                    command2.Parameters.AddWithValue("@export_date", exportdate)
                                                    exportunits = command2.ExecuteScalar
                                                    If Not Convert.IsDBNull(exportunits) Then

                                                        available = importunits - exportunits
                                                        If available <= 0 Then
                                                            Continue Do
                                                        End If
                                                    Else
                                                        available = importunits
                                                    End If
                                                    toinsert = Math.Min(units, available)
                                                    units -= toinsert
                                                
                                                End Using
                                                Using command2 As New SqlCommand("select duty_per_piece from import Where company=@company and style=@style and sizecolor=@sizecolor and import_date=@import_date ;", connection)
                                                    command2.Parameters.AddWithValue("@company", company)
                                                    command2.Parameters.AddWithValue("@style", style)
                                                    command2.Parameters.AddWithValue("@sizecolor", sizecolor)
                                                    command2.Parameters.AddWithValue("@import_date", datareader("import_date"))
                                                    dutyperpiece = command2.ExecuteScalar
                                            End Using
                                            Using command2 As New SqlCommand("select drawback_number,submitted from export Where company=@company and style=@style and sizecolor=@sizecolor and import_date=@import_date and export_date=@export_date;", connection)
                                                command2.Parameters.AddWithValue("@company", company)
                                                command2.Parameters.AddWithValue("@style", style)
                                                command2.Parameters.AddWithValue("@sizecolor", sizecolor)
                                                command2.Parameters.AddWithValue("@export_date", exportdate)
                                                command2.Parameters.AddWithValue("@import_date", datareader("import_date"))
                                                Using datareader2 As SqlDataReader = command2.ExecuteReader
                                                    If datareader2.HasRows Then
                                                        datareader2.Read()
                                                        drawback_number = datareader2("drawback_number")
                                                        submitted = datareader2("submitted")
                                                    End If
                                                End Using
                                                
                                                
                                            End Using
                                            Using command2 As New SqlCommand("Delete from Export Where company=@company and style=@style and sizecolor=@sizecolor and import_date=@import_date and export_date=@export_date;", connection)
                                                command2.Parameters.AddWithValue("@company", company)
                                                command2.Parameters.AddWithValue("@style", style)
                                                command2.Parameters.AddWithValue("@sizecolor", sizecolor)
                                                command2.Parameters.AddWithValue("@export_date", exportdate)
                                                command2.Parameters.AddWithValue("@import_date", datareader("import_date"))
                                                row = command2.ExecuteNonQuery
                                            End Using
                                            If toinsert Then
                                                Using command2 As New SqlCommand("insert into Export(company,style,sizecolor,export_date,Freight_carrier,Reference_number,Export_Country,Import_Date,Units,Duty,drawback_number,submitted,destroyed,invoice_no) values ( @company,@style,@sizecolor,@Export_Date,@Freight_carrier,@Reference_number,@Export_Country,@Import_Date,@Units,@Duty,@drawback_number,@submitted,@destroyed,@invoice_no);", connection)
                                                    command2.Parameters.AddWithValue("@company", company)
                                                    command2.Parameters.AddWithValue("@style", style)
                                                    command2.Parameters.AddWithValue("@sizecolor", sizecolor)
                                                    command2.Parameters.AddWithValue("@Export_Date", exportdate)
                                                    command2.Parameters.AddWithValue("@Freight_carrier", carrier)
                                                    command2.Parameters.AddWithValue("@Reference_number", rnumber)
                                                    command2.Parameters.AddWithValue("@Export_Country", country)
                                                    command2.Parameters.AddWithValue("@Import_Date", datareader("import_date"))
                                                    command2.Parameters.AddWithValue("@Units", toinsert)
                                                    command2.Parameters.AddWithValue("@Duty", dutyperpiece)
                                                    command2.Parameters.AddWithValue("@drawback_number", drawback_number)
                                                    command2.Parameters.AddWithValue("@Submitted", submitted)
                                                    command2.Parameters.AddWithValue("@Destroyed", destroyed)
                                                    command2.Parameters.AddWithValue("@Invoice_No", invoice_no)
                   
                                                    row = command2.ExecuteNonQuery
                                                End Using
                                            End If
                                                
                                        Loop
                                            
                                        End If
                                    End Using
                                End Using
                            
                           
                           
                           
                            Catch ex As Exception
                                response = "{ ""response"": """ & ex.Message & """ }"
                            End Try
                        End Using


            End Select
            i += 1
            j += 1
            
        Next
        Dim client As WebClient = New WebClient
        text = client.DownloadString(context.Request.Url.ToString.Replace("export", "chart") + "?exportdate=" + exportdate + "&company=" + company + "&style=" + style)
                            
      
        
        If String.IsNullOrEmpty(response) Then
            response = "{ ""response"": ""SAVED!!"",""thedata"": """ + text + """ }"
        End If
        
        context.Response.Write(response)
    End Sub
 
    Public ReadOnly Property IsReusable() As Boolean Implements IHttpHandler.IsReusable
        Get
            Return False
        End Get
    End Property







        
        
End Class
