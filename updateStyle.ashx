<%@ WebHandler Language="VB" Class="updateStyle" %>

Imports System
Imports System.Web
Imports System.IO
Imports System.Data.SqlClient
Imports Newtonsoft.Json
Imports System.Data.Entity
Imports Microsoft.VisualBasic.FileIO


Public Class updateStyle : Implements IHttpHandler

    Public Sub ProcessRequest(ByVal context As HttpContext) Implements IHttpHandler.ProcessRequest
        Try
            Dim sb As StringBuilder = New StringBuilder
            Dim response As String = String.Empty
            Dim company = context.Request.QueryString("company")
            Dim style = context.Request.QueryString("style")
            Dim nstyle = context.Request.QueryString("nstyle")

            Dim direc As String = ConfigurationManager.AppSettings.Item("RootPath") & company & "\" & style
            Try
                Directory.Move(direc, direc.Replace(style, nstyle))
            Catch ex As Exception
                'TODO
                FileSystem.MoveDirectory(direc, direc.Replace(style, nstyle))
                'response = "True" 'Directory exists.
                'Exit Sub
            End Try


            Dim dbContext As New DB_9AA143_mendyaModel.DB_9AA143_mendyaEntities
            Dim statuses = dbContext.Status.Where(Function(s) s.Path.Contains("\" + style + "\")).ToList
            For Each st In statuses
                st.Path = st.Path.Replace("\" + style + "\", "\" + nstyle + "\")
            Next

            Dim t_imports = dbContext.Imports.Where(Function(s) s.style = style AndAlso s.company = company)

            For Each im In t_imports.AsNoTracking
                dbContext.Detach(im)
                im.style = nstyle
                dbContext.AddToImports(im)
            Next
            For Each im In t_imports
                dbContext.DeleteObject(im)
            Next

            Dim t_exports = dbContext.Exports.Where(Function(s) s.Style = style AndAlso s.Company = company)
            For Each ex In t_exports.AsNoTracking
                dbContext.Detach(ex)
                ex.Style = nstyle
                dbContext.AddToExports(ex)
            Next
            For Each ex In t_exports
                dbContext.DeleteObject(ex)
            Next

            dbContext.SaveChanges()



            context.Response.ContentType = "text/plain"
            context.Response.Write("{ ""response"": """ + response + """ }")

        Catch ex As Exception
            File.WriteAllText(ConfigurationManager.AppSettings.Item("RootPath") & "error.log", ex.Message)
        End Try

    End Sub

    Public ReadOnly Property IsReusable() As Boolean Implements IHttpHandler.IsReusable
        Get
            Return False
        End Get
    End Property



End Class