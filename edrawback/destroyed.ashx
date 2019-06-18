<%@ WebHandler Language="VB" Class="destroyed" %>

Imports System
Imports System.Web
Imports System.IO
Imports GemBox.Spreadsheet
Imports PdfSharp.Pdf
Imports PdfSharp.Drawing
Imports PdfSharp.Drawing.Layout

Public Class destroyed : Implements IHttpHandler
    
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
                    hash.Add(val, New List(Of String))
                    DirectCast(hash(val), List(Of String)).Add(row.AllocatedCells(0).Value & "|" & f & "|" & row.AllocatedCells(5).Value)
                Else
                    DirectCast(hash(val), List(Of String)).Add(row.AllocatedCells(0).Value & "|" & f & "|" & row.AllocatedCells(5).Value)
                End If
            Next
        Next
        
        For Each k In hash.Keys
            If Directory.Exists(rootdir & k) Then
                If Not Directory.Exists(rootdir & k & "\2012-10-29 Destroyed") Then
                    Directory.CreateDirectory(rootdir & k & "\2012-10-29 Destroyed")
                End If
                For Each fi In Directory.GetFiles(rootdir & k & "\2012-10-29 Destroyed")
                    System.IO.File.Delete(fi)
                Next
                
              
                
                Dim sb As StringBuilder = New StringBuilder

                sb.AppendLine(k)
             
                Dim tot As Integer = 0
                For Each i In DirectCast(hash(k), List(Of String))
                    Dim int = 0
                    If Not String.IsNullOrEmpty(i.Split("|")(2)) Then
                        int = CInt(i.Split("|")(2))
                    End If
                    sb.AppendLine("FILE:" & i.Split("|")(1) & "    LINE#" & i.Split("|")(0) & "    QTY " & int.ToString)
                    tot += int

                Next
                sb.AppendLine("Total: " & tot.ToString)
                Dim document As PdfDocument = New PdfDocument()

                Dim page As PdfPage = document.AddPage()
                Dim gfx As XGraphics = XGraphics.FromPdfPage(page)
                Dim font As XFont = New XFont("Times New Roman", 12, XFontStyle.Bold)
                Dim tf As XTextFormatter = New XTextFormatter(gfx)
                Dim rect As XRect = New XRect(40, 100, 350, 220)
                gfx.DrawRectangle(XBrushes.SeaShell, rect)
                tf.DrawString(sb.ToString, font, XBrushes.Black, rect, XStringFormats.TopLeft)
                
                document.Save(rootdir & k & "\2012-10-29 Destroyed\2012-10-29 Destroyed 1.pdf")
            End If
            
           
        Next

        context.Response.ContentType = "text/plain"
        context.Response.Write("Hello World")
    End Sub
 
    Public ReadOnly Property IsReusable() As Boolean Implements IHttpHandler.IsReusable
        Get
            Return False
        End Get
    End Property

End Class