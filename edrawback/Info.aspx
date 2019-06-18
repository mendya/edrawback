<%@ Page Language="VB" AutoEventWireup="false" CodeFile="Info.aspx.vb" Inherits="Info" MasterPageFile="~/MasterPage.master" %>

<asp:Content runat="server" ID="content1" ContentPlaceHolderID="head">
    <style type="text/css" media="screen">
        table {
            border-collapse: collapse;
            border: 1px solid #FF0000;
        }

            table td {
                border: 1px solid #FF0000;
                min-width: 120px;
            }
    </style>
</asp:Content>
<asp:Content runat="server" ID="content2" ContentPlaceHolderID="ContentPlaceHolder1">
    <asp:Label runat="server" ID="lblLogged"></asp:Label>
    &nbsp; | &nbsp;    
        <a href="User.aspx">Go Back to Main Menu</a>
</asp:Content>
<asp:Content runat="server" ID="content3" ContentPlaceHolderID="ContentPlaceHolder2">
    <div id="center">
        <table>
            <tr>
                <td>Company Name:
                </td>
                <td>
                    <asp:Label runat="server" ID="lblCompanyName"></asp:Label>
                </td>
            </tr>
            <tr>
                <td>Contact:
                </td>
                <td>
                    <asp:Label runat="server" ID="lblContact"></asp:Label>
                </td>
            </tr>
            <tr>
                <td>Address:
                </td>
                <td>
                    <asp:Label runat="server" ID="lblAddress"></asp:Label>
                </td>
            </tr>
            <tr>
                <td>Phone:
                </td>
                <td>
                    <asp:Label runat="server" ID="lblPhone"></asp:Label>
                </td>
            </tr>
            <tr>
                <td>Email:
                </td>
                <td>
                    <asp:Label runat="server" ID="lblEmail"></asp:Label>
                </td>
            </tr>
            <tr>
                <td>Exp. Date:
                </td>
                <td>
                    <asp:Label runat="server" ID="lblExpDate"></asp:Label>
                </td>
            </tr>
        </table>
        <a href="EditInfo.aspx">Edit</a>
    </div>
</asp:Content>
