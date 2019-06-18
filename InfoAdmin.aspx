<%@ Page Language="VB" AutoEventWireup="false" CodeFile="InfoAdmin.aspx.vb" Inherits="InfoAdmin" MasterPageFile="~/MasterPage.master" MaintainScrollPositionOnPostback="true" %>

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
        <a href="Admin.aspx">Go Back to Main Menu</a>
</asp:Content>
<asp:Content runat="server" ID="content3" ContentPlaceHolderID="ContentPlaceHolder2">
    <div id="center">
       <span style="font-size:1.5em;">Company:</span>   <asp:DropDownList Font-Size="1.5em" runat="server" ID="ddlCompany" AutoPostBack="true" OnSelectedIndexChanged="ddlCompany_SelectedIndexChanged"></asp:DropDownList>

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
        <asp:HyperLink runat="server" ID="hlEdit" Text="Edit" ></asp:HyperLink>
        
    </div>
</asp:Content>

