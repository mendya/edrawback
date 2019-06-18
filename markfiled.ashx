<%@ WebHandler Language="VB" Class="markfiled" %>

Imports System
Imports System.Web
Imports System.Data.SqlClient
Imports System.IO

Public Class markfiled : Implements IHttpHandler
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

        Dim DataSource As String = ConfigurationManager.AppSettings("DataSource")
        Dim InitialCatalog As String = ConfigurationManager.AppSettings("InitialCatalog")
        Dim UserId As String = ConfigurationManager.AppSettings("UserId")
        Dim Password As String = ConfigurationManager.AppSettings("Password")
        Dim connectionString As String = "Data Source=" & DataSource & ";Initial Catalog=" & InitialCatalog & ";User Id=" & UserId & ";Password=" & Password & ";MultipleActiveResultSets=True" & ";"


        Using connection As New SqlConnection(connectionString)
            connection.Open()
            Using Command As New SqlCommand("update drawbacks set status='FILED',filed_date=@dt where drawback_number=@dbn;", connection)
                Command.Parameters.AddWithValue("@dt", dt)
                Command.Parameters.AddWithValue("@dbn", dbn)
                Dim res = Command.ExecuteNonQuery()
            End Using
        End Using

        context.Response.ContentType = "text/plain"
        context.Response.Write(response)
    End Sub

    Public ReadOnly Property IsReusable() As Boolean Implements IHttpHandler.IsReusable
        Get
            Return False
        End Get
    End Property

End Class