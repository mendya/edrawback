<%@ WebHandler Language="VB" Class="TrackingConfirmation" %>

Imports System
Imports System.Web




Public Class TrackingConfirmation : Implements IHttpHandler
    
    Public Sub ProcessRequest(ByVal context As HttpContext) Implements IHttpHandler.ProcessRequest
        
        Dim w As WebsiteToImage = New WebsiteToImage("https://www.fedex.com/apps/fedextrack/?tracknumbers=859304676010&cntry_code=us", "C:\Test\Test.jpg")
        w.Generate()
        
        
    End Sub
   
    Public ReadOnly Property IsReusable() As Boolean Implements IHttpHandler.IsReusable
        Get
            Return False
        End Get
    End Property

End Class