<%@ Page Language="VB" AutoEventWireup="false" CodeFile="Admin.aspx.vb" Inherits="Admin" MasterPageFile="~/MasterPage.master" %>

<asp:Content runat="server" ID="content1" ContentPlaceHolderID="head">
</asp:Content>
<asp:Content runat="server" ID="content2" ContentPlaceHolderID="ContentPlaceHolder1">
    <asp:Label runat="server" ID="lblLogged"></asp:Label>

</asp:Content>
<asp:Content runat="server" ID="content3" ContentPlaceHolderID="ContentPlaceHolder2">
    <div id="center">
        <table>
            <tr>
                <td>
                    <ul>
                        <li><a href="newUpload.aspx">Upload Documents</a></li>                       
                        <li><a href="ViewAdminNew.aspx">Pending/View</a></li>
                        <li><a href="SubmitDrawback.aspx">Submit DrawBack</a></li>
                        <li><a href="UserGuide.aspx">Users Guide</a></li>
                        <li><a href="InfoAdmin.aspx">Company Information</a></li>
                        <li><a href="DocumentsAdmin.aspx">Documents</a></li>
                        <li><a href="ChangePwdAdmin.aspx">Change Password</a></li>
                        <li><a href="index.html">Log Off</a></li>

                    </ul>
                </td>
            </tr>
        </table>
    </div>
</asp:Content>
