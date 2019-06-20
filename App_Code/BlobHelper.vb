Imports System
Imports System.Collections.Generic
Imports System.Diagnostics
Imports System.IO
Imports System.Linq
Imports Microsoft.Azure
Imports Microsoft.WindowsAzure
Imports Microsoft.WindowsAzure.Storage
Imports Microsoft.WindowsAzure.Storage.Blob

Public Class BlobFileInfo
    Public Property FileName As String
    Public Property BlobPath As String
    Public Property BlobFilePath As String
    Public Property Blob As IListBlobItem
End Class

Public Module BlobHelper
    Function GetBlobContainer(ByVal containerName As String) As CloudBlobContainer
        Dim storageAccount = CloudStorageAccount.Parse(CloudConfigurationManager.GetSetting("StorageConnectionString"))
        Dim blobClient = storageAccount.CreateCloudBlobClient()
        Dim container = blobClient.GetContainerReference(containerName)
        Return container
    End Function
    Function ListFolderBlobsNonRecursive(ByVal containerName As String, ByVal directoryName As String) As IEnumerable(Of BlobFileInfo)
        Dim blobContainer = GetBlobContainer(containerName)
        Dim blobDirectory = blobContainer.GetDirectoryReference(directoryName)
        Dim blobInfos = New List(Of BlobFileInfo)()
        Dim blobs = blobDirectory.ListBlobs().ToList()
        For Each bl In blobs
            If TypeOf bl Is CloudBlobDirectory Then
                Dim blobFileName = bl.Uri.Segments.Last().Replace("%20", " ")
                Dim blobFilePath = bl.Uri.AbsolutePath.Replace(bl.Container.Uri.AbsolutePath & "/", "").Replace("%20", " ")
                Dim blobPath = blobFilePath.Replace("/" & blobFileName, "")
                blobInfos.Add(New BlobFileInfo With {
                    .FileName = blobFileName,
                    .BlobPath = blobPath,
                    .BlobFilePath = blobFilePath,
                    .Blob = bl
                })
            End If
        Next
        Return blobInfos
    End Function
    Function ListFileBlobsRecursive(ByVal containerName As String, ByVal directoryName As String) As IEnumerable(Of BlobFileInfo)
        Dim blobContainer = GetBlobContainer(containerName)
        Dim blobDirectory = blobContainer.GetDirectoryReference(directoryName)
        Dim blobInfos = New List(Of BlobFileInfo)()
        Dim blobs = blobDirectory.ListBlobs().ToList()

        For Each bl In blobs

            If TypeOf bl Is CloudBlockBlob Then
                Dim blobFileName = bl.Uri.Segments.Last().Replace("%20", " ")
                Dim blobFilePath = bl.Uri.AbsolutePath.Replace(bl.Container.Uri.AbsolutePath & "/", "").Replace("%20", " ")
                Dim blobPath = blobFilePath.Replace("/" & blobFileName, "")
                blobInfos.Add(New BlobFileInfo With {
                    .FileName = blobFileName,
                    .BlobPath = blobPath,
                    .BlobFilePath = blobFilePath,
                    .Blob = bl
                })
            End If

            If TypeOf bl Is CloudBlobDirectory Then
                Dim blobDir = bl.Uri.OriginalString.Replace(bl.Container.Uri.OriginalString & "/", "")
                blobDir = blobDir.Remove(blobDir.Length - 1)
                Dim subBlobs = ListFileBlobsRecursive(containerName, blobDir)
                blobInfos.AddRange(subBlobs)
            End If
        Next

        Return blobInfos
    End Function
    Function ListFileBlobsNonRecursive(ByVal containerName As String, ByVal directoryName As String) As IEnumerable(Of BlobFileInfo)
        Dim blobContainer = GetBlobContainer(containerName)
        Dim blobDirectory = blobContainer.GetDirectoryReference(directoryName)
        Dim blobInfos = New List(Of BlobFileInfo)()
        Dim blobs = blobDirectory.ListBlobs().ToList()

        For Each bl In blobs

            If TypeOf bl Is CloudBlockBlob Then
                Dim blobFileName = bl.Uri.Segments.Last().Replace("%20", " ")
                Dim blobFilePath = bl.Uri.AbsolutePath.Replace(bl.Container.Uri.AbsolutePath & "/", "").Replace("%20", " ")
                Dim blobPath = blobFilePath.Replace("/" & blobFileName, "")
                blobInfos.Add(New BlobFileInfo With {
                    .FileName = blobFileName,
                    .BlobPath = blobPath,
                    .BlobFilePath = blobFilePath,
                    .Blob = bl
                })
            End If

        Next

        Return blobInfos
    End Function
End Module
