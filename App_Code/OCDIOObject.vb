'****************************** Module Header ******************************\
' Module Name:  OCDIOObject.vb
' Project:	    VBASPNETOnlineFileSystem
' Copyright (c) Microsoft Corporation.
' 
' The class OCDIOObject supplies following features:
' 1. Create a folder
' 2. Delete a folder  
' 3. Rename a folder
' 4. Delete a file
' 5. Rename a file
' 6. Download a file
' 7. Get all files and subfolders in a folder
' 
' This source is subject to the Microsoft Public License.
' See http://www.microsoft.com/en-us/openness/licenses.aspx.
' All other rights reserved.
' 
' http://code.msdn.microsoft.com/VBASPNETOnlineFileSystem-c29ab7f2
' THIS CODE AND INFORMATION IS PROVIDED "AS IS" WITHOUT WARRANTY OF ANY KIND, 
' EITHER EXPRESSED OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE IMPLIED 
' WARRANTIES OF MERCHANTABILITY AND/OR FITNESS FOR A PARTICULAR PURPOSE.
'***************************************************************************/

Imports System
Imports System.IO
Imports System.Data
Imports System.Data.SqlClient

Public Class OCDIOObject

    Private Shared DirInformation As DirectoryInfo
    Private Shared FileInformation As FileInfo



    ''' <summary>
    ''' Create a folder
    ''' </summary>
    ''' <param name="folderPath">The name of folder you want to create</param>
    ''' <returns>The result of the create folder operation</returns>
    ''' <remarks></remarks>
    Public Shared Function CreateFolder(ByVal folderPath As String, ByVal RootPath As String) As String
        Dim folderName As String = String.Empty

        Try
            OCDIOObject.DirInformation = New DirectoryInfo(folderPath)
            folderName = OCDIOObject.DirInformation.Name
            Dim folderLocation As String = _
                folderPath.Substring(0, (folderPath.LastIndexOf("\"c) + 1))

            If Directory.Exists(folderPath) Then
                Return String.Format( _
                    "There is already a folder with the name ""{0}"" in the location ""{1}"".", _
                    folderName, _
                    folderLocation.Replace(RootPath, "FileServerRoot"))
            End If

            Directory.CreateDirectory(folderPath)
        Catch agEx As System.ArgumentException
            Return String.Format( _
                "Failed to create the folder, because of the following error: <br>{0}", _
                agEx.Message)
        Catch ptlEx As PathTooLongException
            Return String.Format( _
                "Failed to create the folder, because of the following error: <br>{0}", _
                ptlEx.Message)
        Catch dnfEx As DirectoryNotFoundException
            Return String.Format( _
                "Failed to create the folder, because of the following error: <br>{0}", _
                dnfEx.Message)
        End Try

        Return String.Format("The folder ""{0}"" was created successfully!", folderName)
    End Function

    ''' <summary>
    ''' Delete a folder
    ''' </summary>
    ''' <param name="folderPath">The full path of the folder you want to delete</param>
    ''' <returns>The result of the delete folder operation</returns>
    ''' <remarks></remarks>
    Public Shared Function DeleteFolder(ByVal folderPath As String, ByVal RootPath As String) As String
        Dim folderName As String = String.Empty

        Try
            OCDIOObject.DirInformation = New DirectoryInfo(folderPath)
            folderName = OCDIOObject.DirInformation.Name
            Dim folderLocation As String = _
                folderPath.Substring(0, (folderPath.LastIndexOf("\"c) + 1))

            If Not Directory.Exists(folderPath) Then
                Return String.Format( _
                    "There is no folder with the name ""{0}"" in the location ""{1}"".", _
                    folderName, _
                    folderLocation.Replace(RootPath, "FileServerRoot"))
            End If

            Directory.Delete(folderPath, True)
        Catch dnfEx As DirectoryNotFoundException
            Return String.Format( _
                "Failed to delete the folder, because of the following error: <br>{0}", _
                dnfEx.Message)
        End Try
        Return String.Format("The folder ""{0}"" was deleted successfully!", folderName)

    End Function

    ''' <summary>
    ''' Rename a folder
    ''' </summary>
    ''' <param name="folderPath">The full path of the folder</param>
    ''' <param name="newName">The new name of the foder</param>
    ''' <returns>The result of the rename operatio</returns>
    ''' <remarks></remarks>
    Public Shared Function RenameFolder(ByVal folderPath As String, _
                                        ByVal newName As String, _
                                        ByVal RootPath As String) As String
        Dim folderName As String = String.Empty
        Dim newFolderPath As String = String.Empty
        Dim folderLocation As String = String.Empty

        Try
            OCDIOObject.DirInformation = New DirectoryInfo(folderPath)
            folderName = OCDIOObject.DirInformation.Name
            newFolderPath = _
                (folderPath.Substring(0, (folderPath.LastIndexOf("\"c) + 1)) & newName)
            folderLocation = folderPath.Substring(0, (folderPath.LastIndexOf("\"c) + 1))

            If Not Directory.Exists(folderPath) Then
                Return String.Format( _
                    "There is no folder with the name ""{0}"" in the location ""{1}"".", _
                    folderName, _
                    folderLocation.Replace(RootPath, "FileServerRoot"))
            End If

            If (folderName.Equals(newName, StringComparison.OrdinalIgnoreCase)) Then
                Return "The new folder name you input is same with the old one(The folder name is not case sensitive)."
            End If

            If Directory.Exists(newFolderPath) Then
                Return String.Format( _
                    "There is already a folder with the name ""{0}"" in the location ""{1}"".", _
                    newName, folderLocation.Replace(RootPath, "FileServerRoot"))
            End If

            Directory.Move(folderPath, _
                           (folderPath.Substring(0, (folderPath.LastIndexOf("\"c) + 1)) & newName))
        Catch agEx As System.ArgumentException
            Return String.Format( _
                "Failed to rename the folder, because of the following error: <br>{0}", _
                agEx.Message)
        Catch ptlEx As PathTooLongException
            Return String.Format( _
                "Failed to rename the folder, because of the following error: <br>{0}", _
                ptlEx.Message)
        Catch dnfEx As DirectoryNotFoundException
            Return String.Format( _
                "Failed to rename the folder, because of the following error: <br>{0}", _
                dnfEx.Message)
        End Try
        Return String.Format( _
            "The folder ""{0}"" was renamed to ""{1}"" successfully!", _
            folderName, newName)
    End Function

    ''' <summary>
    ''' Delete a file
    ''' </summary>
    ''' <param name="filePath">The name of the folder you want to delete</param>
    ''' <returns>The result of deete file operation</returns>
    ''' <remarks></remarks>
    Public Shared Function DeleteFile(ByVal filePath As String) As String
        Dim fileName As String = String.Empty
        Dim fileLocation As String = String.Empty

        Try
            OCDIOObject.FileInformation = New FileInfo(filePath)
            fileName = OCDIOObject.FileInformation.Name
            fileLocation = filePath.Substring(0, (filePath.LastIndexOf("\"c) + 1))
            If Not File.Exists(filePath) Then
                Return String.Format( _
                    "There is not a file with the name ""{0}"" in the location ""{1}"".", _
                    fileName, fileLocation)
            End If
            File.Delete(filePath)
        Catch dnfEx As DirectoryNotFoundException
            Return String.Format( _
                "Failed to delete the file, because of the following error: <br>{0}", _
                dnfEx.Message)
        End Try

        Return String.Format("The file ""{0}"" was deleted successfully!", _
                             OCDIOObject.FileInformation.Name)

    End Function

    ''' <summary>
    ''' Rename a file
    ''' </summary>
    ''' <param name="filePath">The full path of the file</param>
    ''' <param name="newName">The new name of the file</param>
    ''' <returns>The result of the renaem operation</returns>
    ''' <remarks></remarks>
    Public Shared Function RenameFile(ByVal filePath As String, _
                                      ByVal newName As String, _
                                      ByVal RootPath As String) As String
        Dim fileName As String = String.Empty
        Dim fileExtension As String = String.Empty
        Dim newFilePath As String = String.Empty
        Dim fileLocation As String = String.Empty

        Try
            OCDIOObject.FileInformation = New FileInfo(filePath)
            fileName = OCDIOObject.FileInformation.Name
            fileExtension = OCDIOObject.FileInformation.Extension
            newFilePath = _
                (filePath.Substring(0, (filePath.LastIndexOf("\"c) + 1)) & newName & fileExtension)
            fileLocation = filePath.Substring(0, (filePath.LastIndexOf("\"c) + 1))

            If Not File.Exists(filePath) Then
                Return String.Format( _
                    "There is not a file with the name  ""{0}"" in the location ""{1}"".", _
                    fileName, fileLocation.Replace(RootPath, "FileServerRoot"))
            End If

            If (fileName.Equals(newName, StringComparison.OrdinalIgnoreCase)) Then
                Return "The new file name you input is same with the old one(The file name is not case sensitive)."
            End If

            If File.Exists(newFilePath) Then
                Return String.Format( _
                    "There is already a file with the name ""{0}"" in the location ""{1}"".", _
                    newName, fileLocation.Replace(RootPath, "FileServerRoot"))
            End If

            File.Move(filePath, (filePath.Substring(0, (filePath.LastIndexOf("\"c) + 1)) & _
                                 newName & fileExtension))
        Catch agEx As System.ArgumentException
            Return String.Format( _
                "Failed to rename the file, because of the following error: <br>{0}", _
                agEx.Message)
        Catch dnfEx As DirectoryNotFoundException
            Return String.Format( _
                "Failed to rename the file, because of the following error: <br>{0}", _
                dnfEx.Message)
        Catch ptlEx As PathTooLongException
            Return String.Format( _
                "Failed to rename the file, because of the following error: <br>{0}", _
                ptlEx.Message)
        End Try

        Return String.Format("The file ""{0}"" was renamed to ""{1}"" successfully!", _
                             OCDIOObject.FileInformation.Name, newName)

    End Function

    ''' <summary>
    ''' Download a file from the server
    ''' </summary>
    ''' <param name="filePath">The full path of the file on the server</param>
    ''' <remarks></remarks>
    Public Shared Sub DownloadFile(ByVal filePath As String)
        OCDIOObject.FileInformation = New FileInfo(filePath)
        Dim response As HttpResponse = HttpContext.Current.Response
        response.ClearContent()
        response.Clear()
        response.ContentType = "application/octet-stream"
        response.AddHeader("Content-Disposition", _
                            ("attachment; filename=" & _
                            OCDIOObject.FileInformation.Name & ";"))
        response.TransmitFile(filePath)
        response.Flush()
        response.End()
    End Sub

    ''' <summary>
    ''' Get all files and folders in a folder
    ''' </summary>
    ''' <param name="folderPath">The full path of a folder</param>
    ''' <param name="Username">The Username - Used for the checkbox</param>
    ''' <returns>All files and folders in the folder</returns>
    ''' <remarks></remarks>
    Public Shared Function GetAllItemsInTheDirectory( _
                                                ByVal folderPath As String, ByVal Username As String) As DataTable
        Dim dtAllItems As New DataTable
        dtAllItems.Columns.Add("Type")
        dtAllItems.Columns.Add("Name")
        dtAllItems.Columns.Add("Size")
        dtAllItems.Columns.Add("UploadTime")
        dtAllItems.Columns.Add("Location")
        dtAllItems.Columns.Add("FullPath")
        dtAllItems.Columns.Add("Approved")
        dtAllItems.Columns.Add("Comments")

        Dim subFolders As String() = Directory.GetDirectories(folderPath)
        Dim subFolderPath As String

        For Each subFolderPath In subFolders
            Dim subFolder As New DirectoryInfo(subFolderPath)
            dtAllItems.Rows.Add( _
                New Object() {"Folder", _
                              subFolder.Name, _
                              "", _
                              subFolder.CreationTime.ToString, _
                              subFolder.Parent.FullName, _
                              subFolder.FullName, _
                              GetApproved(subFolderPath, Username), _
                              GetComments(subFolderPath, Username)})
        Next

        Dim files As String() = Directory.GetFiles(folderPath)
        Dim filePath As String

        For Each filePath In files
            Dim file As New FileInfo(filePath)
            dtAllItems.Rows.Add( _
                New Object() { _
                    Path.GetExtension(file.Name), _
                    file.Name, _
                    CommonUse.FormatFileSize(file.Length), _
                    file.CreationTime.ToString, _
                    file.DirectoryName, _
                    file.FullName, _
                    GetApproved(filePath, Username)})
        Next
        Return dtAllItems

    End Function

    ''' <summary>
    ''' Get all files and folders in a folder
    ''' </summary>
    ''' <param name="folderPath">The full path of a folder</param>
    ''' <param name="name">The name to filter for</param>
    ''' <param name="Username">The username used for the checkbox</param>
    ''' <returns>All files and folders in the folder</returns>
    ''' <remarks></remarks>
    Public Shared Function GetAllItemsInTheDirectory( _
                                            ByVal folderPath As String, ByVal name As String, ByVal Username As String) As DataTable
        Dim dtAllItems As New DataTable
        dtAllItems.Columns.Add("Type")
        dtAllItems.Columns.Add("Name")
        dtAllItems.Columns.Add("Size")
        dtAllItems.Columns.Add("UploadTime")
        dtAllItems.Columns.Add("Location")
        dtAllItems.Columns.Add("FullPath")
        dtAllItems.Columns.Add("Approved")
        dtAllItems.Columns.Add("Comments")

        Dim subFolders As String() = Directory.GetDirectories(folderPath)
        Dim subFolderPath As String

        For Each subFolderPath In subFolders
            Dim subFolder As New DirectoryInfo(subFolderPath)
            If Regex.IsMatch(subFolder.Name, name, RegexOptions.IgnoreCase) Then

                dtAllItems.Rows.Add( _
                               New Object() {"Folder", _
                                             subFolder.Name, _
                                             "", _
                                             subFolder.CreationTime.ToString, _
                                             subFolder.Parent.FullName, _
                                             subFolder.FullName, _
                                             GetApproved(subFolderPath, Username), _
                                             GetComments(subFolderPath, Username)})
            End If

        Next

        Dim files As String() = Directory.GetFiles(folderPath)
        Dim filePath As String

        For Each filePath In files
            Dim file As New FileInfo(filePath)

            dtAllItems.Rows.Add( _
                            New Object() { _
                                Path.GetExtension(file.Name), _
                                file.Name, _
                                CommonUse.FormatFileSize(file.Length), _
                                file.CreationTime.ToString, _
                                file.DirectoryName, _
                                file.FullName, _
                                GetApproved(filePath, Username)})

        Next
        Return dtAllItems

    End Function
    ''' <summary>
    ''' Get all files and folders in a folder
    ''' </summary>
    ''' <param name="folderPath">The full path of a folder</param>
    ''' <param name="Username">The Username - Used for the checkbox</param>
    ''' <returns>All files and folders in the folder</returns>
    ''' <remarks></remarks>
    Public Shared Function GetAllPendingItemsInTheDirectory( _
                                                ByVal folderPath As String, ByVal Username As String) As DataTable
        Dim dtAllItems As New DataTable
        dtAllItems.Columns.Add("Type")
        dtAllItems.Columns.Add("Name")
        dtAllItems.Columns.Add("Size")
        dtAllItems.Columns.Add("UploadTime")
        dtAllItems.Columns.Add("Location")
        dtAllItems.Columns.Add("FullPath")
        dtAllItems.Columns.Add("Approved")
        dtAllItems.Columns.Add("Comments")

        Dim subFolders As String() = Directory.GetDirectories(folderPath)
        Dim subFolderPath As String

        For Each subFolderPath In subFolders
            '------------------------ Added Code --------------------
            If Regex.IsMatch(subFolderPath, "Queue$|AllFiles$", RegexOptions.Compiled Or RegexOptions.IgnoreCase) Then
                Continue For
            End If
            Dim subsubFolders As String() = Directory.GetDirectories(subFolderPath)
            Dim isPending As Boolean = False
            Dim Mport As Boolean = False
            If subsubFolders.Length = 0 Then
                isPending = True
                Mport = True
            Else
                Dim id As Date, ed As Date
                For Each subsubFolderPath In subsubFolders
                    Dim subsubFolder As New DirectoryInfo(subsubFolderPath)
                    Dim dated = Regex.Match(subsubFolder.Name, "[0-9]{4}-[0-9]{2}-[0-9]{2} [Import|Export|Destroyed]").Value
                    'If String.IsNullOrEmpty(dated) Then
                    '    isPending = True
                    '    Mport = True
                    'Else
                    Dim imp = Regex.Match(subsubFolder.Name, "Import").Value
                    If imp = "Import" Then
                        Mport = True
                        id = DateTime.ParseExact(Regex.Match(subsubFolder.Name, "[0-9]{4}-[0-9]{2}-[0-9]{2}").Value, "yyyy-MM-dd", System.Globalization.CultureInfo.InvariantCulture)
                    End If
                    If Regex.IsMatch(subsubFolder.Name, "Export|Destroyed") AndAlso Not GetApproved(subsubFolderPath, Username) Then
                        ed = DateTime.ParseExact(Regex.Match(subsubFolder.Name, "[0-9]{4}-[0-9]{2}-[0-9]{2}").Value, "yyyy-MM-dd", System.Globalization.CultureInfo.InvariantCulture)
                        If ed.AddYears(3) >= Today AndAlso ed.AddYears(-3) <= id Then
                            isPending = True
                        End If


                        'End If
                    End If

                Next

            End If

            If isPending = False OrElse Mport = False OrElse (isPending = False AndAlso Mport = False) Then
                Continue For
            End If

            '------------------------ Added Code ---------------------
            Dim subFolder As New DirectoryInfo(subFolderPath)
            dtAllItems.Rows.Add( _
                New Object() {"Folder", _
                              subFolder.Name, _
                              "", _
                              subFolder.CreationTime.ToString, _
                              subFolder.Parent.FullName, _
                              subFolder.FullName, _
                              GetApproved(subFolderPath, Username), _
                              GetComments(subFolderPath, Username)})
        Next

        Dim files As String() = Directory.GetFiles(folderPath)
        Dim filePath As String

        For Each filePath In files
            Dim file As New FileInfo(filePath)
            dtAllItems.Rows.Add( _
                New Object() { _
                    Path.GetExtension(file.Name), _
                    file.Name, _
                    CommonUse.FormatFileSize(file.Length), _
                    file.CreationTime.ToString, _
                    file.DirectoryName, _
                    file.FullName, _
                    GetApproved(filePath, Username)})
        Next
        Return dtAllItems

    End Function
    ''' <summary>
    ''' Get all files and folders in a folder
    ''' </summary>
    ''' <param name="folderPath">The full path of a folder</param>
    ''' <param name="name">The name to filter for</param>
    ''' <param name="Username">The username used for the checkbox</param>
    ''' <returns>All files and folders in the folder</returns>
    ''' <remarks></remarks>
    Public Shared Function GetAllPendingItemsInTheDirectory( _
                                            ByVal folderPath As String, ByVal name As String, ByVal Username As String) As DataTable
        Dim dtAllItems As New DataTable
        dtAllItems.Columns.Add("Type")
        dtAllItems.Columns.Add("Name")
        dtAllItems.Columns.Add("Size")
        dtAllItems.Columns.Add("UploadTime")
        dtAllItems.Columns.Add("Location")
        dtAllItems.Columns.Add("FullPath")
        dtAllItems.Columns.Add("Approved")
        dtAllItems.Columns.Add("Comments")

        Dim subFolders As String() = Directory.GetDirectories(folderPath)
        Dim subFolderPath As String

        For Each subFolderPath In subFolders
            Dim subFolder As New DirectoryInfo(subFolderPath)
            If Regex.IsMatch(subFolder.Name, name, RegexOptions.IgnoreCase) Then

                dtAllItems.Rows.Add( _
                               New Object() {"Folder", _
                                             subFolder.Name, _
                                             "", _
                                             subFolder.CreationTime.ToString, _
                                             subFolder.Parent.FullName, _
                                             subFolder.FullName, _
                                             GetApproved(subFolderPath, Username), _
                                             GetComments(subFolderPath, Username)})
            End If

        Next

        Dim files As String() = Directory.GetFiles(folderPath)
        Dim filePath As String

        For Each filePath In files
            Dim file As New FileInfo(filePath)

            dtAllItems.Rows.Add( _
                            New Object() { _
                                Path.GetExtension(file.Name), _
                                file.Name, _
                                CommonUse.FormatFileSize(file.Length), _
                                file.CreationTime.ToString, _
                                file.DirectoryName, _
                                file.FullName, _
                                GetApproved(filePath, Username)})

        Next
        Return dtAllItems

    End Function


    Public Shared Function GetApproved(ByVal fullpath As String, ByVal UserName As String) As Boolean
        Dim DataSource As String = ConfigurationManager.AppSettings("DataSource")
        Dim InitialCatalog As String = ConfigurationManager.AppSettings("InitialCatalog")
        Dim UserId As String = ConfigurationManager.AppSettings("UserId")
        Dim Password As String = ConfigurationManager.AppSettings("Password")
        Dim Status As Boolean

        Dim connectionString As String = "Data Source=" & DataSource & ";Initial Catalog=" & InitialCatalog & ";User Id=" & UserId & ";Password=" & Password & ";"
        Dim queryString As String = "Select Approved from Status where Username= @Username and Path= @Path;"
        Using connection As New SqlConnection(connectionString)
            Dim command As New SqlCommand(queryString, connection)

            command.Parameters.AddWithValue("@Username", UserName)
            command.Parameters.AddWithValue("@Path", fullpath)
            Try
                connection.Open()
                Status = command.ExecuteScalar
                Return Status
            Catch ex As Exception
                Return 0
            End Try
        End Using

    End Function

    Private Shared Function GetComments(fullpath As String, Username As String) As String
        Dim DataSource As String = ConfigurationManager.AppSettings("DataSource")
        Dim InitialCatalog As String = ConfigurationManager.AppSettings("InitialCatalog")
        Dim UserId As String = ConfigurationManager.AppSettings("UserId")
        Dim Password As String = ConfigurationManager.AppSettings("Password")
        Dim Comments As String

        Dim connectionString As String = "Data Source=" & DataSource & ";Initial Catalog=" & InitialCatalog & ";User Id=" & UserId & ";Password=" & Password & ";"
        Dim queryString As String = "Select Comments from Status where Username= @Username and Path= @Path;"
        Using connection As New SqlConnection(connectionString)
            Dim command As New SqlCommand(queryString, connection)

            command.Parameters.AddWithValue("@Username", Username)
            command.Parameters.AddWithValue("@Path", fullpath)
            Try
                connection.Open()
                Comments = command.ExecuteScalar
                Return Comments
            Catch ex As Exception
                Return String.Empty
            End Try
        End Using
    End Function

End Class
