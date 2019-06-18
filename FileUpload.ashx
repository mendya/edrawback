<%@ WebHandler Language="VB" Class="Handler" %>

Imports System
Imports System.Web
Imports System.Xml
Imports Newtonsoft.Json

Public Class Handler : Implements IHttpHandler
    
    Public Sub ProcessRequest(ByVal context As HttpContext) Implements IHttpHandler.ProcessRequest
        context.Response.ContentType = "text/plain"
        '"application/json";
        Dim r = New System.Collections.Generic.List(Of ViewDataUploadFilesResult)()


        For x As Integer = 0 To context.Request.Files.Count - 1
            Dim hpf As HttpPostedFile = TryCast(context.Request.Files(x), HttpPostedFile)
            Dim FileName As String = String.Empty
            If HttpContext.Current.Request.Browser.Browser.ToUpper() = "IE" Then
                Dim files As String() = hpf.FileName.Split(New Char() {"\"c})
                FileName = files(files.Length - 1)
            Else
                FileName = hpf.FileName
            End If
            If hpf.ContentLength = 0 Then
                Continue For
            End If
            Dim savedFileName As String = context.Server.MapPath(Convert.ToString("~/Uploads/") & context.Request.Form.ToString.Split("=")(0) & "_" & FileName)
            Try
                hpf.SaveAs(savedFileName)

            Catch ex As Exception
            End Try
            


            r.Add(New ViewDataUploadFilesResult() With { _
                 .thumbnailUrl = savedFileName, _
                 .name = FileName, _
                 .length = hpf.ContentLength, _
                 .type = hpf.ContentType, _
                 .url = String.Format("/Uploads/{0}", FileName), _
                 .deleteUrl = String.Format("/Uploads/{0}", FileName) _
            })
            Dim uploadedFiles = New With { _
                Key .files = r.ToArray() _
            }

            'was returning a new json string everytime, so then duplicating if 
            'sending multiple files. Example, file 1 was in first position,
            'then file 1 & 2 in second position, and so on. So, I only grab,
            'the last JSON instance to get all files.
            If x = (context.Request.Files.Count - 1) Then
                Dim jsonObj = JsonConvert.SerializeObject(uploadedFiles, System.Xml.Formatting.Indented)
                Dim jsonHttpOutputStream As String = jsonObj.ToString()

                context.Response.Write(jsonHttpOutputStream)
            End If
        Next
    End Sub
 
    Public ReadOnly Property IsReusable() As Boolean Implements IHttpHandler.IsReusable
        Get
            Return False
        End Get
    End Property
    Public Class ViewDataUploadFilesResult
        Public Property thumbnailUrl() As String
            Get
                Return m_thumbnailUrl
            End Get
            Set(value As String)
                m_thumbnailUrl = value
            End Set
        End Property
        Private m_thumbnailUrl As String
        Public Property name() As String
            Get
                Return m_name
            End Get
            Set(value As String)
                m_name = value
            End Set
        End Property
        Private m_name As String
        Public Property length() As Integer
            Get
                Return m_length
            End Get
            Set(value As Integer)
                m_length = value
            End Set
        End Property
        Private m_length As Integer
        Public Property type() As String
            Get
                Return m_type
            End Get
            Set(value As String)
                m_type = value
            End Set
        End Property
        Private m_type As String
        Public Property url() As String
            Get
                Return m_url
            End Get
            Set(value As String)
                m_url = value
            End Set
        End Property
        Private m_url As String
        Public Property deleteUrl() As String
            Get
                Return m_deleteUrl
            End Get
            Set(value As String)
                m_deleteUrl = value
            End Set
        End Property
        Private m_deleteUrl As String
    End Class
End Class