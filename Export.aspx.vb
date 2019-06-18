Imports System.IO
Imports System.Data.SqlClient

Partial Class PA
    Inherits System.Web.UI.Page
    Protected Sub ddlinfoimport_SelectedIndexChanged(sender As Object, e As EventArgs)
        File.Copy(ddlinfoimport.SelectedValue, String.Concat(Regex.Replace(ConfigurationManager.AppSettings.Item("RootPath"), "[^\\]+\\?$", ""), "pdf.pdf"), True)
    End Sub

    Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load

        If Not Page.IsPostBack Then
            Try
                hdnCompany.Value = Context.Request.QueryString("company")
                hdnStyle.Value = Context.Request.QueryString("style")

                ' hdnFull.Value = Session("hdnFull")
                'hdnStatus.Value = Session("hdnStatus")
                hdnExportDate.Value = Context.Request.QueryString("date")

                hdnDestroyed.Value = IIf(Context.Request.QueryString("destroyed") = "null", 0, 1)

                LblStyle.Text = hdnStyle.Value
                exportdate.Text = hdnExportDate.Value
                For Each f In Directory.GetFiles(ConfigurationManager.AppSettings.Item("RootPath") & hdnCompany.Value & "\" & hdnStyle.Value & "\" & hdnExportDate.Value & " " & IIf(hdnDestroyed.Value = 1, "Destroyed", "Export"))  '
                    ddlinfoimport.Items.Add(New ListItem(Path.GetFileName(f), f))
                Next
                ddlinfoimport.DataBind()
                'If Regex.IsMatch(ddlinfoimport.SelectedValue, ".pdf") Then
                '    File.Copy(ddlinfoimport.SelectedValue, String.Concat(Regex.Replace(ConfigurationManager.AppSettings.Item("RootPath"), "[^\\]+\\?$", ""), "pdf.pdf"), True)
                'Else
                '    File.Delete(ConfigurationManager.AppSettings.Item("RootPath") & "pdf.pdf")
                'End If

                Dim DataSource As String = ConfigurationManager.AppSettings("DataSource")
                Dim InitialCatalog As String = ConfigurationManager.AppSettings("InitialCatalog")
                Dim UserId As String = ConfigurationManager.AppSettings("UserId")
                Dim Password As String = ConfigurationManager.AppSettings("Password")
                Dim connectionString As String = "Data Source=" & DataSource & ";Initial Catalog=" & InitialCatalog & ";User Id=" & UserId & ";Password=" & Password & ";MultipleActiveResultSets=True" & ";"
                Dim a As StringBuilder = New StringBuilder
                a.Append("<script>var a = [")
                Dim selsc As StringBuilder = New StringBuilder
                selsc.Append("<script>var selectValues = {")
                Using connection As New SqlConnection(connectionString)
                    Try
                        connection.Open()
                        Using Command As New SqlCommand("select * from import where company=@company and style=@style and import_date < @export_date and import_date > DATEADD(year, -3, @export_date) order by duty_per_piece asc, import_date asc;", connection)
                            Command.Parameters.AddWithValue("@company", hdnCompany.Value)
                            Command.Parameters.AddWithValue("@style", hdnStyle.Value)
                            Command.Parameters.AddWithValue("@export_date", hdnExportDate.Value)
                            Using datareader As SqlDataReader = Command.ExecuteReader
                                If datareader.HasRows Then
                                    Dim schash As Hashtable = New Hashtable
                                    Dim rows As Object
                                    Dim units As Integer = 0

                                    Do While datareader.Read
                                        Dim expunits As Integer = 0
                                        Using command2 As New SqlCommand("select sum(units) as units from export where company=@company and style=@style and import_date=@import_date and sizecolor=@sizecolor and export_date <> @export_date;", connection)
                                            command2.Parameters.AddWithValue("@company", hdnCompany.Value)
                                            command2.Parameters.AddWithValue("@style", hdnStyle.Value)
                                            command2.Parameters.AddWithValue("@import_date", datareader("import_date"))
                                            command2.Parameters.AddWithValue("@export_date", hdnExportDate.Value)
                                            command2.Parameters.AddWithValue("@sizecolor", datareader("sizecolor"))
                                            rows = command2.ExecuteScalar
                                            If Not Convert.IsDBNull(rows) Then
                                                units = CInt(datareader("units")) - rows
                                                'If units <= 0 Then
                                                '    Continue Do
                                                'End If
                                            Else
                                                units = datareader("units")

                                            End If

                                        End Using
                                        Using command2 As New SqlCommand("select sum(units) as units,freight_carrier,reference_number,export_country,invoice_no from export where company=@company and style=@style and sizecolor=@sizecolor and export_date=@export_date group by freight_carrier,reference_number,export_country,invoice_no;", connection)
                                            command2.Parameters.AddWithValue("@company", hdnCompany.Value)
                                            command2.Parameters.AddWithValue("@style", hdnStyle.Value)
                                            command2.Parameters.AddWithValue("@sizecolor", datareader("sizecolor"))
                                            command2.Parameters.AddWithValue("@export_date", hdnExportDate.Value)
                                            Using datareader2 As SqlDataReader = command2.ExecuteReader
                                                If datareader2.HasRows Then
                                                    datareader2.Read()
                                                    expunits = datareader2("units")
                                                    fcarrier.Text = datareader2("freight_carrier")
                                                    rnumber.Text = datareader2("reference_number")
                                                    country.Text = datareader2("export_country")
                                                    invoicenumber.Text = datareader2("invoice_no")
                                                End If
                                            End Using


                                        End Using
                                        If schash.ContainsKey(datareader("sizecolor")) Then
                                            schash(datareader("sizecolor")) = schash(datareader("sizecolor")) & datareader("sizecolor") & "|" & units & "|" & datareader("duty_per_piece") & "|" & datareader("import_date") & "|" & expunits & "@"
                                        Else
                                            schash.Add(datareader("sizecolor"), datareader("sizecolor") & "|" & units & "|" & datareader("duty_per_piece") & "|" & datareader("import_date") & "|" & expunits & "@")
                                        End If


                                    Loop
                                    For Each key As String In schash.Keys
                                        selsc.Append("""" & schash(key) & """: """ & key & """,")
                                    Next


                                    Dim result = selsc.ToString.Trim(",") & " };</script>"
                                    ClientScript.RegisterStartupScript(Me.GetType(), "key3", result)
                                    ClientScript.RegisterStartupScript(Me.GetType(), "key", "<script>var a = [];</script>")
                                Else
                                    ClientScript.RegisterStartupScript(Me.GetType(), "key3", "<script>var selectValues = [];</script>")
                                    ClientScript.RegisterStartupScript(Me.GetType(), "key", "<script>var a = [];</script>")
                                End If


                            End Using

                        End Using



                    Catch ex As Exception
                        hdnlabel.Value = ex.Message
                    End Try
                End Using



            Catch ex As Exception
                Response.Redirect("pendingadmin.aspx", False)
            End Try

        End If

    End Sub
End Class
