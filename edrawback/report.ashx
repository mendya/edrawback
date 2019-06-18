<%@ WebHandler Language="VB" Class="report" %>

Imports System
Imports System.Web
Imports System.IO
Imports GemBox.Spreadsheet
Imports PdfSharp.Pdf
Imports PdfSharp.Drawing
Imports PdfSharp.Drawing.Layout
Imports System.Data.SqlClient

Public Class report : Implements IHttpHandler
    
    Public Sub ProcessRequest(ByVal context As HttpContext) Implements IHttpHandler.ProcessRequest
        
        Dim rootdir As String = ConfigurationManager.AppSettings("RootPath") & "tball\"
        Dim hash As Hashtable = New Hashtable
        SpreadsheetInfo.SetLicense("ECC6-MHSE-9M84-67JV")
        Dim file As New ExcelFile
        For Each f As String In "interior2-GOOD.xlsx,List of Exterior 1-GOOD.xlsx,SALVAGEC-GOOD.xlsx".Split(",")
            file.LoadXlsx(ConfigurationManager.AppSettings("RootPath") & "tball\" & f, XlsxOptions.None)
            For i As Int16 = 1 To file.Worksheets.ActiveWorksheet.Rows.Count - 1

                Dim row As ExcelRow = file.Worksheets.ActiveWorksheet.Rows(i)
                Dim val = (row.AllocatedCells(2).Value & row.AllocatedCells(3).Value).ToString.Replace(" ", "").ToLower
                If Not hash.ContainsKey(val) Then
                    hash.Add(val, New Integer)
                    hash(val) = CInt(row.AllocatedCells(5).Value)
                Else
                    hash(val) += CInt(row.AllocatedCells(5).Value)
                End If
            Next
        Next
        Dim nf As ExcelFile = New ExcelFile
        nf.Worksheets.Add("sheet1")
        Dim ws = nf.Worksheets(0)
        ws.Cells(0, 0).Value = "Style"
        ws.Cells(0, 1).Value = "Total Destroyed"
        ws.Cells(0, 2).Value = "Total Imports Found"
        ws.Cells(0, 3).Value = "Total Destroyed Claimed"
        ws.Cells(0, 4).Value = "Total Destroyed To Be Claimed"
        Dim idx As Integer = 1
        For Each k In hash.Keys
            ws.Cells(idx, 0).Value = k 'style
            ws.Cells(idx, 1).Value = hash(k) 'total destroyed
            ws.Cells(idx, 2).Value = 0
            ws.Cells(idx, 3).Value = 0
            ws.Cells(idx, 4).Value = 0
            If Directory.Exists(rootdir & k) Then
                             
                Dim DataSource As String = ConfigurationManager.AppSettings("DataSource")
                Dim InitialCatalog As String = ConfigurationManager.AppSettings("InitialCatalog")
                Dim UserId As String = ConfigurationManager.AppSettings("UserId")
                Dim Password As String = ConfigurationManager.AppSettings("Password")
                Dim connectionString As String = "Data Source=" & DataSource & ";Initial Catalog=" & InitialCatalog & ";User Id=" & UserId & ";Password=" & Password & ";MultipleActiveResultSets=True" & ";"
                Using connection As New SqlConnection(connectionString)
                    connection.Open()
                    Using Command As New SqlCommand("select sum(units) as s from import where company='tball' and style=@style;", connection)
                        Command.Parameters.AddWithValue("@style", k)
                        Dim res = Command.ExecuteScalar
                        ws.Cells(idx, 2).Value = IIf(res Is DBNull.Value, 0, res) 'Total imports found
                    End Using
                    Using Command As New SqlCommand("select sum(units) as s from export where company='tball' and style=@style;",connection)
                        Command.Parameters.AddWithValue("@style", k)
                        Dim res = Command.ExecuteScalar
                        ws.Cells(idx, 3).Value = IIf(res Is DBNull.Value, 0, res) 'Total exports found
                    End Using
                End Using
               
               
            End If
            ws.Cells(idx, 4).Value = ws.Cells(idx, 1).Value - ws.Cells(idx, 3).Value
            idx += 1
        Next
        nf.SaveXlsx(rootdir & "report.xlsx")
        
        context.Response.ContentType = "text/plain"
        context.Response.Write("Hello World")
    End Sub
 
    Public ReadOnly Property IsReusable() As Boolean Implements IHttpHandler.IsReusable
        Get
            Return False
        End Get
    End Property

End Class