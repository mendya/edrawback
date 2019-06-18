<%@ WebHandler Language="VB" Class="Getdrawbacks" %>

Imports System
Imports System.Web
Imports System.Data.SqlClient

Public Class Getdrawbacks : Implements IHttpHandler
    
    Public Sub ProcessRequest(ByVal context As HttpContext) Implements IHttpHandler.ProcessRequest
        Dim company As String = context.Request.QueryString("company")
        Dim response As String = String.Empty
        Dim drawback_number As String = String.Empty
        'Dim st As String = "9AE"
        'Dim cd As String = "2"
        
        Dim DataSource As String = ConfigurationManager.AppSettings("DataSource")
        Dim InitialCatalog As String = ConfigurationManager.AppSettings("InitialCatalog")
        Dim UserId As String = ConfigurationManager.AppSettings("UserId")
        Dim Password As String = ConfigurationManager.AppSettings("Password")
        Dim connectionString As String = "Data Source=" & DataSource & ";Initial Catalog=" & InitialCatalog & ";User Id=" & UserId & ";Password=" & Password & ";MultipleActiveResultSets=True" & ";"
        
        Dim sb As StringBuilder = New StringBuilder
        Dim filerno As String = String.Empty
        Dim filercode As String = String.Empty
        Dim result As Object = Nothing
        
        Using connection As New SqlConnection(connectionString)
            Try
                connection.Open()
                Using Command As New SqlCommand("Select distinct e.drawback_number from export e join drawbacks d on e.drawback_number=d.drawback_number where e.company=@company and e.submitted <> 1 and e.drawback_number <> '' and d.status='PENDING' ", connection)
                    Command.Parameters.AddWithValue("@company", company)

                    Using datareader As SqlDataReader = Command.ExecuteReader
                        If datareader.HasRows Then
                            Do While datareader.Read
                                
                                sb.Append(datareader("drawback_number") & "|")
                            Loop
                            'Else
                            '    Using command2 As New SqlCommand("select max(drawback_number) as m from export where company=@company", connection)
                            '        command2.Parameters.AddWithValue("@company", company)
                            '        Dim result = command2.ExecuteScalar
                            '        If result Is DBNull.Value Then
                            '            drawback_number = st & "1".PadLeft(7, "0") & cd
                            '        Else
                            '            drawback_number = datareader("m")
                            '        End If
                            '        response = drawback_number
                            '    End Using
                        End If
                    End Using
                End Using
                Using Command As New SqlCommand("Select filerno + '|' + filercode from users where username=@company;", connection)
                    Command.Parameters.AddWithValue("@company", company)
                    result = Command.ExecuteScalar
                    filerno = result.ToString.Split("|")(0)
                    filercode = result.ToString.Split("|")(1)
                End Using
              
                  
                        
                               
                                            
                   
                
                response = sb.ToString.TrimEnd("|")
            Catch ex As Exception
                response = ex.Message
            End Try
            
        End Using
       
        response = "{ ""response"": """ & response & """,""filerno"": """ + filerno.Trim + """,""filercode"": """ + filercode.trim + """ }"
        
        context.Response.ContentType = "text/plain"
        context.Response.Write(response)
    End Sub
 
    Public ReadOnly Property IsReusable() As Boolean Implements IHttpHandler.IsReusable
        Get
            Return False
        End Get
    End Property

End Class