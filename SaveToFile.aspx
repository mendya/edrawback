<%@ Page Language="vb" AutoEventWireup="false"%>
<%
	Dim files As HttpFileCollection = HttpContext.Current.Request.Files
    Dim uploadfile As HttpPostedFile = files("RemoteFile")
    
    Dim filePath As String
    filePath = System.Web.HttpContext.Current.Request.MapPath(".") & "/UploadedImages/" 
    
    If Not System.IO.Directory.Exists(filePath) Then
      System.IO.Directory.CreateDirectory(filePath)
    End If
    filePath = filePath & uploadfile.FileName
    
    uploadfile.SaveAs(filePath)
%>