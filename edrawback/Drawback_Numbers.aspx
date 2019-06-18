<%@ Page Language="VB" AutoEventWireup="false" CodeFile="Drawback_Numbers.aspx.vb" Inherits="Drawback_Numbers" MasterPageFile="~/MasterPage.master" %>

<asp:Content runat="server" ID="content1" ContentPlaceHolderID="head">
</asp:Content>
<asp:Content runat="server" ID="content2" ContentPlaceHolderID="ContentPlaceHolder1">
     <asp:Label runat="server" ID="lblLogged"></asp:Label>
         &nbsp; | &nbsp;    
        <a href="Admin.aspx">Go Back to Main Menu</a>

</asp:Content>
<asp:Content runat="server" ID="content3" ContentPlaceHolderID="ContentPlaceHolder2">
    <div id="center">
        <table>
            <tr>
                <td>
                    <ul>
                        <li><a href="NewDrawback.aspx">New Drawback Number</a></li>
                        <li><a href="ExistingDrawback.aspx">View Existing Drawback Numbers</a></li>
                    </ul>
                </td>
            </tr>
        </table>
    </div>
</asp:Content>
