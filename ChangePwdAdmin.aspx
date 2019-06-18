<%@ Page Language="VB" AutoEventWireup="false" CodeFile="ChangePwdAdmin.aspx.vb" Inherits="ChangePwdAdmin" MasterPageFile="~/MasterPage.master" %>

<asp:Content runat="server" ID="content1" ContentPlaceHolderID="head">
</asp:Content>
<asp:Content runat="server" ID="content2" ContentPlaceHolderID="ContentPlaceHolder1">
    <asp:Label runat="server" ID="lblLogged"  ></asp:Label>
     &nbsp;|&nbsp;
        <a href="Admin.aspx">Go Back to Main Menu</a>
    
</asp:Content>
<asp:Content runat="server" ID="content3" ContentPlaceHolderID="ContentPlaceHolder2" >
    <div id="center">
                <table id="box">
            <tr>
                <td>
                    Old Password:
                </td>
                <td>
                    <asp:TextBox ID="oldPwd" TextMode="Password" runat="server"></asp:TextBox>
                </td>
            </tr>
            <tr>
                <td>
                    New Password:
                </td>
                <td>
                    <asp:TextBox ID="newPwd" TextMode="Password" runat="server"></asp:TextBox>
                </td>
            </tr>
            <tr>
                <td>
                    Confirm New Password:
                </td>
                <td>
                    <asp:TextBox ID="newPwdConfirm" TextMode="Password" runat="server"></asp:TextBox>
                </td>
            </tr>
            <tr>
                <td colspan="2">
                    <asp:Button runat="server" ID="btnSubmit" Text="Submit" Width="279px" />
                </td>
            </tr>
            <tr>
                <td>
                    <asp:Label runat="server" ForeColor="Red" Font-Bold="true" ID="lblError"></asp:Label>
                </td>
            </tr>
        </table>

    </div>
</asp:Content>
       