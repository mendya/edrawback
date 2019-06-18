<%@ WebHandler Language="VB" Class="import" %>

Imports System
Imports System.Web
Imports System.IO
Imports System.Data.SqlClient

Public Class import : Implements IHttpHandler

    Public Sub ProcessRequest(ByVal context As HttpContext) Implements IHttpHandler.ProcessRequest
        Dim json As String = New StreamReader(context.Request.InputStream).ReadToEnd()
        Dim response As String = String.Empty
        Dim company As String = String.Empty
        Dim style As String = String.Empty
        Dim svn501 As String = String.Empty
        Dim portcode As String = String.Empty
        Dim country As String = String.Empty
        Dim importdate As String = String.Empty
        Dim oldimportdate As String = String.Empty
        Dim conversion As String = String.Empty
        Dim totalval As String = String.Empty
        Dim hmf As String = String.Empty
        Dim mpf As String = String.Empty
        Dim sizecolor As String = String.Empty
        Dim dutyperpiece As String = String.Empty
        Dim units As String = String.Empty
        Dim unitstype As String = String.Empty
        Dim line As String = String.Empty
        Dim price As String = String.Empty
        Dim tarrif1 As String = String.Empty
        Dim desc1 As String = String.Empty
        Dim perc1 As String = String.Empty
        Dim piece1 As String = String.Empty
        Dim val1 As String = String.Empty
        Dim tarrif2 As String = String.Empty
        Dim desc2 As String = String.Empty
        Dim perc2 As String = String.Empty
        Dim piece2 As String = String.Empty
        Dim val2 As String = String.Empty
        Dim tarrif3 As String = String.Empty
        Dim desc3 As String = String.Empty
        Dim perc3 As String = String.Empty
        Dim piece3 As String = String.Empty
        Dim val3 As String = String.Empty
        Dim tarrif4 As String = String.Empty
        Dim desc4 As String = String.Empty
        Dim perc4 As String = String.Empty
        Dim piece4 As String = String.Empty
        Dim val4 As String = String.Empty
        Dim i As Integer = 0, j As Integer = 10000

        Dim DataSource As String = ConfigurationManager.AppSettings("DataSource")
        Dim InitialCatalog As String = ConfigurationManager.AppSettings("InitialCatalog")
        Dim UserId As String = ConfigurationManager.AppSettings("UserId")
        Dim Password As String = ConfigurationManager.AppSettings("Password")
        Dim connectionString As String = "Data Source=" & DataSource & ";Initial Catalog=" & InitialCatalog & ";User Id=" & UserId & ";Password=" & Password & ";"



        For Each var As String In json.Split("|")


            Select Case i
                Case 0
                    company = var
                Case 1
                    style = var
                Case 2
                    svn501 = var
                Case 3
                    portcode = var
                Case 4
                    country = var
                Case 5
                    importdate = var
                Case 6
                    oldimportdate = var
                    'If Not oldimportdate = Convert.ToDateTime(importdate).ToString("yyyy-MM-dd") Then
                    'Directory.Move(ConfigurationManager.AppSettings("RootPath") & company & "\" & style & "\" & oldimportdate & " Import", ConfigurationManager.AppSettings("RootPath") & company & "\" & style & "\" & Convert.ToDateTime(importdate).ToString("yyyy-MM-dd") & " Import")
                   ' End If
                Case 7
                    conversion = var
                Case 8
                    totalval = var
                Case 9
                    hmf = var
                Case 10
                    mpf = var
                    j = -1
            End Select
            Select Case j
                Case 0
                    sizecolor = var
                Case 1
                    dutyperpiece = var
                Case 2
                    units = var
                Case 3
                    unitstype = var
                Case 4
                    line = var
                Case 5
                    price = var
                Case 6
                    tarrif1 = var
                Case 7
                    desc1 = var
                Case 8
                    perc1 = var
                Case 9
                    piece1 = var
                Case 10
                    val1 = var
                Case 11
                    tarrif2 = var
                Case 12
                    desc2 = var
                Case 13
                    perc2 = var
                Case 14
                    piece2 = var
                Case 15
                    val2 = var
                Case 16
                    tarrif3 = var
                Case 17
                    desc3 = var
                Case 18
                    perc3 = var
                Case 19
                    piece3 = var
                Case 20
                    val3 = var
                Case 21
                    tarrif4 = var
                Case 22
                    desc4 = var
                Case 23
                    perc4 = var
                Case 24
                    piece4 = var
                Case 25
                    val4 = var
                    j = -1
                    ' Insert the Tarrifs If not in already
                    Dim row As Integer
                    Using connection As New SqlConnection(connectionString)
                        Try
                            connection.Open()
                            ' Insert any new Tarrifs
                            Dim index As Int16 = 0
                            Dim related_tarrifs As String = String.Empty
                            For Each str As String In New String() {tarrif1 & "|" & desc1 & "|" & perc1 & "|" & piece1, tarrif2 & "|" & desc2 & "|" & perc2 & "|" & piece2, tarrif3 & "|" & desc3 & "|" & perc3 & "|" & piece3, tarrif4 & "|" & desc4 & "|" & perc4 & "|" & piece4}
                                If String.IsNullOrEmpty(str.Split("|")(0)) Then
                                    Continue For
                                End If
                                If index = 0 Then
                                    related_tarrifs = tarrif2 + "|" + tarrif3 + "|" + tarrif4
                                Else
                                    related_tarrifs = String.Empty
                                End If
                                Using Command As New SqlCommand("Select 1  From Tarrifs Where Tarrif_Code=@Tarrif_Code;", connection)
                                    Command.Parameters.AddWithValue("@Tarrif_Code", str.Split("|")(0))
                                    row = Command.ExecuteScalar
                                    If row <= 0 Then

                                        Using command2 As New SqlCommand("insert into tarrifs(tarrif_code,description,percent_rate,piece_rate,related_tarrifs)values(@Tarrif_Code,@Description,@Percent_Rate,@Piece_Rate,@related_tarrifs);", connection)
                                            command2.Parameters.AddWithValue("@Tarrif_Code", str.Split("|")(0))
                                            command2.Parameters.AddWithValue("@Description", str.Split("|")(1))
                                            command2.Parameters.AddWithValue("@Percent_Rate", str.Split("|")(2))
                                            command2.Parameters.AddWithValue("@Piece_Rate", str.Split("|")(3))
                                            command2.Parameters.AddWithValue("@related_tarrifs", related_tarrifs)
                                            row = command2.ExecuteNonQuery

                                        End Using
                                    Else
                                        Using command2 As New SqlCommand("update tarrifs set description=@description,percent_rate=@percent_rate,piece_rate=@piece_rate,related_tarrifs=@related_tarrifs where tarrif_code=@tarrif_code;", connection)
                                            command2.Parameters.AddWithValue("@Tarrif_Code", str.Split("|")(0))
                                            command2.Parameters.AddWithValue("@Description", str.Split("|")(1))
                                            command2.Parameters.AddWithValue("@Percent_Rate", str.Split("|")(2))
                                            command2.Parameters.AddWithValue("@Piece_Rate", str.Split("|")(3))
                                            command2.Parameters.AddWithValue("@related_tarrifs", related_tarrifs)
                                            row = command2.ExecuteNonQuery
                                        End Using
                                    End If

                                End Using
                                index += 1
                            Next

                            Using command As New SqlCommand("Delete from Import Where company=@company and style=@style and sizecolor=@sizecolor and import_date in (@import_date);", connection)
                                command.Parameters.AddWithValue("@company", company)
                                command.Parameters.AddWithValue("@style", style)
                                command.Parameters.AddWithValue("@sizecolor", sizecolor)
                                command.Parameters.AddWithValue("@import_date", importdate)
                                'command.Parameters.AddWithValue("@old_import_date", oldimportdate)
                                row = command.ExecuteNonQuery
                            End Using
                            Using command As New SqlCommand("insert into import(company,style,sizecolor,s7501,port_code,origin,import_date,conversion,tot_val,hmf,mpf,units,unitstype,price,tarrif1,value1,tarrif2,value2,tarrif3,value3,tarrif4,value4,duty_per_piece) values ( @company,@style,@sizecolor,@s7501,@port_code,@origin,@import_date,@conversion,@tot_val,@hmf,@mpf,@units,@unitstype,@price,@tarrif1,@value1,@tarrif2,@value2,@tarrif3,@value3,@tarrif4,@value4,@duty_per_piece);", connection)
                                command.Parameters.AddWithValue("@company", company)
                                command.Parameters.AddWithValue("@style", style)
                                command.Parameters.AddWithValue("@sizecolor", sizecolor)
                                command.Parameters.AddWithValue("@s7501", svn501)
                                command.Parameters.AddWithValue("@port_code", portcode)
                                command.Parameters.AddWithValue("@origin", country)
                                command.Parameters.AddWithValue("@import_date", importdate)
                                Dim result As Decimal = 0.0
                                Decimal.TryParse(conversion, result)
                                command.Parameters.AddWithValue("@conversion", result)
                                Decimal.TryParse(totalval, result)
                                command.Parameters.AddWithValue("@tot_val", result)
                                Decimal.TryParse(hmf, result)
                                command.Parameters.AddWithValue("@hmf", result)
                                Decimal.TryParse(mpf, result)
                                command.Parameters.AddWithValue("@mpf", result)
                                command.Parameters.AddWithValue("@units", units)
                                command.Parameters.AddWithValue("@unitstype", unitstype)
                                Decimal.TryParse(price, result)
                                command.Parameters.AddWithValue("@price", result)
                                command.Parameters.AddWithValue("@tarrif1", tarrif1)
                                Decimal.TryParse(val1, result)
                                command.Parameters.AddWithValue("@value1", result)
                                command.Parameters.AddWithValue("@tarrif2", tarrif2)
                                Decimal.TryParse(val2, result)
                                command.Parameters.AddWithValue("@value2", result)
                                command.Parameters.AddWithValue("@tarrif3", tarrif3)
                                Decimal.TryParse(val3, result)
                                command.Parameters.AddWithValue("@value3", result)
                                command.Parameters.AddWithValue("@tarrif4", tarrif4)
                                Decimal.TryParse(val4, result)
                                command.Parameters.AddWithValue("@value4", result)
                                command.Parameters.AddWithValue("@duty_per_piece", dutyperpiece)
                                row = command.ExecuteNonQuery
                            End Using
                        Catch ex As Exception
                            response = "{ ""response"": """ & ex.Message & """ }"
                        End Try
                    End Using

            End Select
            i += 1
            j += 1

        Next



        If String.IsNullOrEmpty(response) Then
            response = "{ ""response"": ""SAVED!!"",""importdate"": """ & importdate & """ }"
        End If

        context.Response.Write(response)
    End Sub

    Public ReadOnly Property IsReusable() As Boolean Implements IHttpHandler.IsReusable
        Get
            Return False
        End Get
    End Property









End Class
