Imports System.Drawing
Imports System.Drawing.Imaging
Imports System.IO
Imports System.Threading
Imports System.Windows.Forms

Public Class WebsiteToImage
    Private m_Bitmap As Bitmap
    Private m_Url As String
    Private m_FileName As String = String.Empty

    Public Sub New(url As String)
        ' Without file
        m_Url = url
    End Sub

    Public Sub New(url As String, fileName As String)
        ' With file
        m_Url = url
        m_FileName = fileName
    End Sub

    Public Function Generate() As Bitmap
        ' Thread
        Dim m_thread = New Thread(AddressOf _Generate)
        m_thread.SetApartmentState(ApartmentState.STA)
        m_thread.Start()
        m_thread.Join()
        Return m_Bitmap
    End Function

    Private Sub _Generate()
        Dim browser = New WebBrowser() With { _
            .ScrollBarsEnabled = False _
        }
        browser.Navigate(m_Url)
        AddHandler browser.DocumentCompleted, AddressOf WebBrowser_DocumentCompleted

        While browser.ReadyState <> WebBrowserReadyState.Complete
            Application.DoEvents()
        End While

        browser.Dispose()
    End Sub

    Private Sub WebBrowser_DocumentCompleted(sender As Object, e As WebBrowserDocumentCompletedEventArgs)
        ' Capture
        Dim browser = DirectCast(sender, WebBrowser)
        browser.ClientSize = New Size(3000, browser.Document.Body.ScrollRectangle.Bottom)
        browser.ScrollBarsEnabled = False
        m_Bitmap = New Bitmap(browser.Document.Body.ScrollRectangle.Width, browser.Document.Body.ScrollRectangle.Bottom)
        browser.BringToFront()
        browser.DrawToBitmap(m_Bitmap, browser.Bounds)

        ' Save as file?
        If m_FileName.Length > 0 Then
            ' Save
            m_Bitmap.SaveJPG100(m_FileName)
        End If
    End Sub
End Class
Module bitmapExtensions


    Sub New()
    End Sub

    <System.Runtime.CompilerServices.Extension> _
    Public Sub SaveJPG100(bmp As Bitmap, filename As String)
        Dim encoderParameters = New EncoderParameters(1)
        encoderParameters.Param(0) = New EncoderParameter(System.Drawing.Imaging.Encoder.Quality, 100L)
        bmp.Save(filename, GetEncoder(ImageFormat.Jpeg), encoderParameters)
    End Sub

    <System.Runtime.CompilerServices.Extension> _
    Public Sub SaveJPG100(bmp As Bitmap, stream As Stream)
        Dim encoderParameters = New EncoderParameters(1)
        encoderParameters.Param(0) = New EncoderParameter(System.Drawing.Imaging.Encoder.Quality, 100L)
        bmp.Save(stream, GetEncoder(ImageFormat.Jpeg), encoderParameters)
    End Sub

    Public Function GetEncoder(format As ImageFormat) As ImageCodecInfo
        Dim codecs = ImageCodecInfo.GetImageDecoders()

        For Each codec In codecs
            If codec.FormatID = format.Guid Then
                Return codec
            End If
        Next

        ' Return
        Return Nothing
    End Function
End Module