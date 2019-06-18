<%@ WebHandler Language="VB" Class="dbnchart" %>

Imports System
Imports System.Web
Imports System.Data.SqlClient
Imports System.IO

Public Class dbnchart : Implements IHttpHandler
    Public Class s7501
        Public num As String
        Public port As String
        Public duty As Decimal
        Public mpf As Decimal
        Public hmf As Decimal
    End Class
    Public Sub ProcessRequest(ByVal context As HttpContext) Implements IHttpHandler.ProcessRequest

        Dim company As String = context.Request.QueryString("company")
        Dim dbn As String = IIf(context.Request.QueryString("dbn") = "unassigned", "", context.Request.QueryString("dbn"))
        Dim dt As String = context.Request.QueryString("dt")
        Dim response As String = String.Empty
        Dim response2 As String = String.Empty
        Dim response3 As String = String.Empty
        Dim response4 As String = String.Empty
        Dim response5 As String = String.Empty
        
        Dim companyname As String = String.Empty
        Dim irsnumber As String = String.Empty
        Dim firstdate As String = String.Empty
        Dim lastdate As String = String.Empty
        Dim sum As Decimal = 0.0

        
        Dim DataSource As String = ConfigurationManager.AppSettings("DataSource")
        Dim InitialCatalog As String = ConfigurationManager.AppSettings("InitialCatalog")
        Dim UserId As String = ConfigurationManager.AppSettings("UserId")
        Dim Password As String = ConfigurationManager.AppSettings("Password")
        Dim connectionString As String = "Data Source=" & DataSource & ";Initial Catalog=" & InitialCatalog & ";User Id=" & UserId & ";Password=" & Password & ";MultipleActiveResultSets=True" & ";"
        'sb.Append("Drawback# | Style | Size/Color| 7501#| Port Code| CD| Import Date| Received Date| Tarrif#| Qty | Value | Duty Rate| Total Request|")
        
        Dim sb As StringBuilder = New StringBuilder
        Dim sb2 As StringBuilder = New StringBuilder
        Dim sb3 As StringBuilder = New StringBuilder
        Dim sb4 As StringBuilder = New StringBuilder
        Dim sb5 As StringBuilder = New StringBuilder
        Dim s7501list As Hashtable = New Hashtable
       
        Dim filed_date As Date
        
        '                                                          colHeaders: ["Import Entry#", "Port Code", "Import Date", "CD", "HTSUS#", "Description", "Qty & UOM", "Value per Unit", "Duty Rate", "99% Duty"],
        Dim filercode As String = String.Empty
        Dim sumtvmpf As Decimal = 0
        Dim sumtvhmf As Decimal = 0
        Dim sumwrmpf As Decimal = 0
        Dim sumwrhmf As Decimal = 0
        Dim sumwrmpl As Decimal = 0
        Dim sumwrmpl99 As Decimal = 0
        Dim sumwrhml As Decimal = 0
        Dim sumwrhml99 As Decimal = 0
        Dim totduty As Decimal = 0
        Dim totclaim As Decimal = 0
        
        Using connection As New SqlConnection(connectionString)            
            connection.Open()
            Using Command As New SqlCommand("select filercode + '|' + irsnumber from users where username=@company;", connection)
                Command.Parameters.AddWithValue("@company", company)
                Dim res = Command.ExecuteScalar
                filercode = res.ToString.Split("|")(0)
                irsnumber = res.ToString.Split("|")(1)
            End Using
            Using Command As New SqlCommand("Select sum(e.units) as units,e.style,e.sizecolor,e.import_date,d.filed_date from export e join drawbacks d on e.drawback_number=d.drawback_number where e.company=@company and e.drawback_number=@drawback_number and (e.export_date > dateadd(year,-3,'" & dt & "') ) group by e.company,e.drawback_number,e.style,e.sizecolor,e.import_date,d.filed_date;", connection)
                Command.Parameters.AddWithValue("@company", company)
                Command.Parameters.AddWithValue("@drawback_number", dbn)
                Using datareader As SqlDataReader = Command.ExecuteReader
                    If datareader.HasRows Then
                        Do While datareader.Read
                            filed_date = datareader("filed_date")
                            Using command2 As New SqlCommand("select * from import Where company=@company and style=@style and sizecolor=@sizecolor and import_date=@import_date;", connection)
                                command2.Parameters.AddWithValue("@company", company)
                                command2.Parameters.AddWithValue("@style", datareader("style"))
                                command2.Parameters.AddWithValue("@sizecolor", datareader("sizecolor"))
                                command2.Parameters.AddWithValue("@import_date", datareader("import_date"))
                                Using datareader2 As SqlDataReader = command2.ExecuteReader
                                    If datareader2.HasRows Then
                                        datareader2.Read()
                                        If Not s7501list.Contains(datareader2("s7501")) Then
                                            s7501list.Add(datareader2("s7501"), New s7501)
                                            DirectCast(s7501list(datareader2("s7501")), s7501).num = datareader2("s7501")
                                            DirectCast(s7501list(datareader2("s7501")), s7501).port = datareader2("port_code")
                                        End If
                                        Dim iv As Decimal = CDec(datareader2("value1")) + CDec(datareader2("value2")) + CDec(datareader2("value3")) + CDec(datareader2("value4")) 'Individual Value of Line ' I could have used 'price' field!!
                                        Dim tv As Decimal = iv * datareader("units")
                                        Dim wr As Decimal = tv / datareader2("tot_val") 'Weighted Ratio
                                        Dim mpfpl = wr * datareader2("mpf") 'MPF Per Line
                                        Dim hmfpl = wr * datareader2("hmf") 'HMF Per Line 
                                        If datareader2("mpf") > 0 Then
                                            sb3.Append(datareader2("style") & " - " & datareader2("sizecolor") & "|" & datareader2("s7501") & "|" & datareader("units") & "|" & String.Format("{0:N2}", iv) & "|" & String.Format("{0:N2}", tv) & "|" & String.Format("{0:N6}", wr) & "|" & String.Format("{0:N6}", mpfpl) & "|" & String.Format("{0:N6}", mpfpl * 0.99) & "|")
                                            sumtvmpf += tv
                                            sumwrmpl += mpfpl
                                            sumwrmpl99 += mpfpl * 0.99
                                        End If
                                        If datareader2("hmf") > 0 Then
                                            sb4.Append(datareader2("style") & " - " & datareader2("sizecolor") & "|" & datareader2("s7501") & "|" & datareader("units") & "|" & String.Format("{0:N2}", iv) & "|" & String.Format("{0:N2}", tv) & "|" & String.Format("{0:N6}", wr) & "|" & String.Format("{0:N6}", hmfpl) & "|" & String.Format("{0:N6}", hmfpl * 0.99) & "|")
                                            sumwrhmf += wr
                                            sumwrhml += hmfpl
                                            sumwrhml99 += hmfpl * 0.99

                                        End If
                                        '["Item #", "Number of Units", "Individual Value", "Total Value", "Weighted Ratio", "Weighted Ratio/MPF per Line", "99% of MPF per Line"]
                                        DirectCast(s7501list(datareader2("s7501")), s7501).mpf += mpfpl ' * 0.99
                                        DirectCast(s7501list(datareader2("s7501")), s7501).hmf += hmfpl ' * 0.99
                                        Dim t1 = datareader2("tarrif1"), t2 = datareader2("tarrif2"), t3 = datareader2("tarrif3"), t4 = datareader2("tarrif4")
                                        Dim t As String = t1 + IIf(String.IsNullOrEmpty(t2), "", "," + t2) + IIf(String.IsNullOrEmpty(t3), "", "," + t3) + IIf(String.IsNullOrEmpty(t4), "", "," + t4)
                                        Dim i As Int16 = 1
                                        For Each duty As String In t.Split(",")
                                            Using command3 As New SqlCommand("select * from tarrifs where tarrif_code=@tarrif_code;", connection)
                                                command3.Parameters.AddWithValue("@tarrif_code", duty)
                                                Using datareader3 As SqlDataReader = command3.ExecuteReader
                                                    If datareader3.HasRows Then
                                                        datareader3.Read()
                                                        Dim dr As String, dt1 As Decimal
                                                        If IsNumeric(datareader3("percent_rate")) Then
                                                            dr = datareader3("percent_rate") & "%"
                                                            dt1 = datareader2("value" & i.ToString) * (datareader3("percent_rate") / 100) * datareader("units")
                                                        ElseIf IsNumeric(datareader3("piece_rate")) Then
                                                            dr = datareader3("piece_rate") & " /NO"
                                                            dt1 = datareader3("piece_rate") * datareader("units")
                                                        Else
                                                            dr = Nothing
                                                            dt1 = Nothing
                                                        End If
                                                            
                                                        'colHeaders: ["Import Entry#", "Port Code", "Import Date", "CD", "HTSUS#", "Description", "Qty & UOM", "Value per Unit", "Duty Rate", "99% Duty"],

                                                        'If datareader3("tarrif_code") = datareader2("tarrif1") Then
                                                        sb.Append(datareader2("s7501") & "|" & datareader2("port_code") & "|" & datareader2("import_date") & "|N|")
                                                        'Else
                                                        ' sb.Append("-|-|-|-|")
                                                               
                                                        ' End If
                                                        sum += dt1
                                                        sb.Append(datareader2("tarrif" & i.ToString) & "|" & datareader("style") & " - " & datareader("sizecolor") & "  " & datareader3("description") & "|" & datareader("units") & " " & datareader2("unitstype") & "|" & datareader2("value" & i.ToString) & "|" & dr & "|" & String.Format("{0:N2}", dt1 * 0.99) & "|")
                                                        DirectCast(s7501list(datareader2("s7501")), s7501).duty += dt1
                                                    End If
                                                End Using
                                            End Using
                                            i += 1
                                                
                                        Next
                                    End If

                                End Using
                                    
                                    
                            End Using
                        Loop
                    End If
                        
                End Using
            End Using
            sb.Append("-|-|-|-|-|-|-|-|TOTAL|" & String.Format("{0:N2}", (sum * 0.99)) & "|")
            sb3.Append("-|-|-|TOTAL|" & String.Format("{0:N2}", sumtvmpf) & "|" & String.Format("{0:N6}", sumwrmpf) & "|" & String.Format("{0:N6}", sumwrmpl) & "|" & String.Format("{0:N6}", sumwrmpl99) & "|")
            sb4.Append("-|-|-|TOTAL|" & String.Format("{0:N2}", sumtvhmf) & "|" & String.Format("{0:N6}", sumwrhmf) & "|" & String.Format("{0:N6}", sumwrhml) & "|" & String.Format("{0:N6}", sumwrhml99) & "|")
            For Each val As s7501 In s7501list.Values
                sb5.Append(val.num & "|" & val.port & "|-|" & String.Format("{0:N6}", val.duty * 0.99) & "|" & String.Format("{0:N2}", val.mpf * 0.99) & "|" & String.Format("{0:N2}", val.hmf * 0.99) & "|$|") '
                totduty += val.duty * 0.99
                totclaim += (val.duty * 0.99) + (val.hmf * 0.99) + (val.mpf * 0.99)
            Next
            Using command As New SqlCommand("select company from users where username=@username;", connection)
                command.Parameters.AddWithValue("@username", company)
                companyname = command.ExecuteScalar
            End Using
                
                    
            Using Command As New SqlCommand("Select e.style,e.sizecolor,e.export_date,e.destroyed,e.invoice_no,e.export_country,sum(e.units) as units from export e join drawbacks d on e.drawback_number=d.drawback_number where e.company=@company and e.drawback_number=@drawback_number and ( e.export_date > dateadd(year,-3, '" & dt & "') ) group by e.style,e.sizecolor,e.export_date,e.destroyed,e.invoice_no,e.export_country  order by e.export_date,e.style,e.sizecolor", connection)
                Command.Parameters.AddWithValue("@company", company)
                Command.Parameters.AddWithValue("@drawback_number", dbn)
                Using datareader As SqlDataReader = Command.ExecuteReader
                    If datareader.HasRows Then
                        Do While datareader.Read
                            Using command2 As New SqlCommand("select * from import where company=@company and style=@style and sizecolor=@sizecolor", connection)
                                command2.Parameters.AddWithValue("@company", company)
                                command2.Parameters.AddWithValue("@style", datareader("style"))
                                command2.Parameters.AddWithValue("@sizecolor", datareader("sizecolor"))
                                Using datareader2 As SqlDataReader = command2.ExecuteReader
                                    If datareader2.HasRows Then
                                        datareader2.Read()
                                        Dim t1 = datareader2("tarrif1"), t2 = datareader2("tarrif2"), t3 = datareader2("tarrif3"), t4 = datareader2("tarrif4")
                                        Dim t As String = t1 + IIf(String.IsNullOrEmpty(t2), "", "," + t2) + IIf(String.IsNullOrEmpty(t3), "", "," + t3) + IIf(String.IsNullOrEmpty(t4), "", "," + t4)
                                        Dim i As Int16 = 1
                                        For Each duty As String In t.Split(",")
                                            Using command3 As New SqlCommand("select * from tarrifs where tarrif_code=@tarrif_code;", connection)
                                                command3.Parameters.AddWithValue("@tarrif_code", duty)
                                                Using datareader3 As SqlDataReader = command3.ExecuteReader
                                                    If datareader3.HasRows Then
                                                        datareader3.Read()
                                                            
                                                        sb2.Append(datareader("export_date") & "|" & IIf(datareader("destroyed"), "D", "-") & "|" & IIf(String.IsNullOrEmpty(datareader("invoice_no")), "-", datareader("invoice_no")) & "|" & companyname & "|" & datareader("style") & " " & datareader("sizecolor") & " " & datareader3("description") & "|" & datareader("units") & " " & datareader2("unitstype") & "|" & datareader("export_country") & "|" & datareader3("tarrif_code") & "|")
                                                        'colHeaders: ["Date", "Action Code", "Unique Identifier No", "Name of Exporter/Destoryer", "Description of Articles", "Qty and UOM", "Export Dest.", "HTSUS No."],
                                                                                                                        
                                                    End If
                                                End Using
                                            End Using
                                        Next
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
            response2 = sb2.ToString.TrimEnd("|")
            response3 = sb3.ToString.TrimEnd("|")
            response4 = sb4.ToString.TrimEnd("|")
            response5 = sb5.ToString.TrimEnd("|")
           
            
            
        End Using
                
        
        context.Response.ContentType = "text/plain"
        response = "{ ""response"": """ + response + """,""response2"": """ + response2 + """,""response3"": """ + response3 + """,""response4"": """ + response4 + """,""response5"": """ + response5 + """,""irsnumber"": """ + irsnumber + """,""totduty"": """ + String.Format("{0:N2}", totduty) + """,""totclaim"": """ + String.Format("{0:N2}", totclaim) + """,""filed_date"": """ + filed_date + """ }"
        context.Response.Write(response)
    End Sub
 
    Public ReadOnly Property IsReusable() As Boolean Implements IHttpHandler.IsReusable
        Get
            Return False
        End Get
    End Property

End Class