<%@ Page Language="VB" AutoEventWireup="false" CodeFile="User.aspx.vb" Inherits="User" MasterPageFile="~/MasterPage.master" MaintainScrollPositionOnPostback="true" %>
<asp:Content runat="server" ID="content1" ContentPlaceHolderID="head">
    
    <script type="text/javascript">
        $(document).ready(function () {
            $("#header").hide();
        });
    </script>
</asp:Content>
<asp:Content runat="server" ID="content2" ContentPlaceHolderID="ContentPlaceHolder1">
     <asp:Label runat="server" ID="lblLogged"  ></asp:Label>
     
</asp:Content>
<asp:Content runat="server" ID="content3" ContentPlaceHolderID="ContentPlaceHolder2" >
    <div id="center">
                <table>
                    <tr>
                        <td>
                            <ul>                                
                                <li><a href="Upload.aspx">Upload Documents</a></li>
                                <li><a href="View.aspx">View Documents</a></li>
                                <li><a href="Pending.aspx">Pending Drawbacks</a></li>
                                <li><a href="UserGuide.aspx">Users Guide</a></li>
                                <li><a href="documents.aspx">New Client Information</a></li>
                                <li><a href="ChangePwd.aspx">Change Password</a></li>
                                <li><a href="Login.aspx">Log Off</a></li>
                            </ul>
                        </td>
                    </tr>
                </table>

    </div>
</asp:Content>