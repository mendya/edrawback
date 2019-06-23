Imports System.IO
Imports System.Data.SqlClient
Imports PdfViewer

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
                'hdnFull.Value = Session("hdnFull")
                'hdnStatus.Value = Session("hdnStatus")
                hdnImportDate.Value = Context.Request.QueryString("date")
                LblStyle.Text = hdnStyle.Value
                mpf.Text = "0"
                hmf.Text = "0"
                conversion.Text = "1"
                importdate.Text = hdnImportDate.Value
                For Each k In BlobHelper.ListFileBlobsNonRecursive("docroot", hdnCompany.Value & "/" & hdnStyle.Value & "/" & hdnImportDate.Value & " Import")
                    ddlinfoimport.Items.Add(New ListItem(Regex.Replace(k.FileName, " ", "%20")))
                Next
                'For Each f In Directory.GetFiles(ConfigurationManager.AppSettings.Item("RootPath") & hdnCompany.Value & "\" & hdnStyle.Value & "\" & hdnImportDate.Value & " Import")
                '    ddlinfoimport.Items.Add(New ListItem(Path.GetFileName(f), f))
                'Next
                ddlinfoimport.DataBind()
                'Try
                '    File.Copy(ddlinfoimport.SelectedValue, String.Concat(Regex.Replace(ConfigurationManager.AppSettings.Item("RootPath"), "[^\\]+\\?$", ""), "pdf.pdf"), True)

                'Catch ex As Exception

                'End Try


                'Dim a = New PdfViewer.ShowPdf
                'a.FilePath = ""


            Catch ex As Exception
                Response.Redirect("pendingadmin.aspx", False)
            End Try

        End If
        Dim DataSource As String = ConfigurationManager.AppSettings("DataSource")
        Dim InitialCatalog As String = ConfigurationManager.AppSettings("InitialCatalog")
        Dim UserId As String = ConfigurationManager.AppSettings("UserId")
        Dim Password As String = ConfigurationManager.AppSettings("Password")
        Dim connectionString As String = "Data Source=" & DataSource & ";Initial Catalog=" & InitialCatalog & ";User Id=" & UserId & ";Password=" & Password & ";MultipleActiveResultSets=True" & ";"
        Dim sc As StringBuilder = New StringBuilder
        sc.Append("<script>var a = [")
        Dim html As StringBuilder = New StringBuilder
        html.Append("<script>var b = [")
        Using connection As New SqlConnection(connectionString)
            Try
                connection.Open()
                Using Command As New SqlCommand("select * from import where company=@company and style=@style and import_date=@import_date;", connection)
                    Command.Parameters.AddWithValue("@company", hdnCompany.Value)
                    Command.Parameters.AddWithValue("@style", hdnStyle.Value)
                    Command.Parameters.AddWithValue("@import_date", hdnImportDate.Value)
                    Using datareader As SqlDataReader = Command.ExecuteReader
                        If datareader.HasRows Then





                            Do While datareader.Read
                                sc.Append("""" & datareader("sizecolor") & """" & ",")
                                s7501.Text = datareader("s7501")
                                portcode.Text = datareader("port_code")
                                country.Text = datareader("Origin")
                                'importdate.Text = datareader("import_date")
                                conversion.Text = datareader("conversion")
                                totalval.Text = datareader("tot_val")
                                hmf.Text = datareader("hmf")
                                mpf.Text = datareader("mpf")

                                html.Append("""<div id='forcopy'><div style='float:left;margin-right:10px;><label for='units'>Units</label> <input id='units' type='text' style='width:90px;padding:2px;' value='" & datareader("units") & "' /></div>" & "<div style='float:left;margin-right:10px;><label for='unitstype'>Type</label> <input id='unitstype' type='text' style='width:30px;padding:2px;' value='" & datareader("unitstype") & "' /></div>" & "<div style='float:left;margin-right:10px;><label for='line'>Line #</label> <input id='line' type='text' style='width:30px;padding:2px;' value='" & datareader("Line") & "' /></div><div style='float:left;margin-right:10px;><label for='price'>Total Value Per Piece</label> <input id='price' type='text' disabled style='width:90px;padding:2px;' value='" & datareader("price") & "' /></div><div style='clear:both;'></div>")
                                Dim lst As String() = {1, 2, 3, 4}
                                For Each itm As String In lst
                                    Dim aa As String = String.Empty
                                    Dim bb As String = String.Empty
                                    Dim cc As String = String.Empty
                                    Dim dd As String = String.Empty
                                    Dim ee As String = String.Empty
                                    Dim ff As String = String.Empty

                                    Using command2 As New SqlCommand("select * from tarrifs where tarrif_code=@tarrif_code;", connection)
                                        command2.Parameters.AddWithValue("@tarrif_code", datareader("tarrif" + itm))
                                        Using datareader2 As SqlDataReader = command2.ExecuteReader
                                            If datareader2.HasRows Then
                                                Do While datareader2.Read
                                                    aa = datareader2("tarrif_code")
                                                    bb = datareader2("description")
                                                    cc = datareader2("percent_rate")
                                                    dd = datareader2("piece_rate")
                                                Loop
                                            End If
                                        End Using
                                    End Using
                                    html.Append("<fieldset><legend>Tarrif " + itm + "</legend>" +
"<div style='float:left;margin-right:10px;><label for='Tarrif" + itm + "'>Tarrif Code</label> <input id='Tarrif" + itm + "' type='text' style='width:80px;padding:2px;' value='" + aa + "' /></div> " +
"<div style='float:left;margin-right:10px;><label for='Description" + itm + "'>Description</label> <input id='Description" + itm + "' type='text' style='width:90px;padding:2px;' value='" + bb + "' /></div>  " +
"<div style='float:left;margin-right:10px;><label for='Perc_Rate" + itm + "'>Percent Rate</label> <input id='Perc_Rate" + itm + "' type='text' style='width:60px;padding:2px;' value='" + cc + "' /></div>  " +
"<div style='float:left;margin-right:10px;><label for='Piece_Rate" + itm + "'>Piece Rate</label> <input id='Piece_Rate" + itm + "' type='text' style='width:60px;padding:2px;' value='" + dd + "' /></div>  " +
"<div style='float:left;margin-right:10px;><label for='TValue" + itm + "'>Value</label> <input id='TValue" + itm + "' type='text' style='width:60px;padding:2px;'  value='" + datareader("value" + itm).ToString + "' /> " + "<br /><br /></fieldset>")
                                Next
                                html.Append("</div>"",")
                            Loop
                            Dim result = sc.ToString.Trim(",") & " ];</script>"
                            ClientScript.RegisterStartupScript(Me.GetType(), "key", result)
                            result = html.ToString.Trim(",") & " ];</script>"
                            ClientScript.RegisterStartupScript(Me.GetType(), "key2", result)
                        Else
                            ClientScript.RegisterStartupScript(Me.GetType(), "key", "<script>var a = [];</script>")
                            ClientScript.RegisterStartupScript(Me.GetType(), "key2", "<script>var b = [];</script>")
                        End If
                    End Using
                End Using

            Catch ex As Exception
                Response.Redirect("pendingadmin.aspx", False)
            End Try
        End Using
    End Sub
End Class
