<%@ Page Language="VB" AutoEventWireup="false" CodeFile="Login.aspx.vb" Inherits="Login" MasterPageFile="~/MasterPage.master" %>
<asp:Content runat="server" ID="content1" ContentPlaceHolderID="head">
</asp:Content>
<asp:Content runat="server" ID="content2" ContentPlaceHolderID="ContentPlaceHolder1">
   Enter your login information.
</asp:Content>
<asp:Content runat="server" ID="content3" ContentPlaceHolderID="ContentPlaceHolder2" >

    <div id="center">
                <table>
                    <tr>
                        <td>
                            <strong>Enter username: </strong>
                        </td>
                        <td>
                            <asp:TextBox runat="server" ID="txtName"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <strong>Enter password: </strong>
                        </td>
                        <td>
                            <asp:TextBox runat="server" ID="txtPwd" TextMode="Password"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <asp:Button runat="server" ID="btnSubmit" Text="Submit" />
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2">
                            <asp:Label runat="server" ID="lblerror" ForeColor="Red"></asp:Label>
                        </td>
                    </tr>
                </table>
        </div>
</asp:Content>