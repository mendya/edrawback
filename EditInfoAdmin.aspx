<%@ Page Language="VB" AutoEventWireup="false" CodeFile="EditInfoAdmin.aspx.vb" Inherits="EditInfoAdmin" MasterPageFile="~/MasterPage.master" %>

<asp:Content runat="server" ID="content1" ContentPlaceHolderID="head">
</asp:Content>
<asp:Content runat="server" ID="content2" ContentPlaceHolderID="ContentPlaceHolder1">
     <asp:Label runat="server" ID="lblLogged"  ></asp:Label>
      &nbsp; | &nbsp;    
        <a href="InfoAdmin.aspx">Go Back</a>
</asp:Content>
<asp:Content runat="server" ID="content3" ContentPlaceHolderID="ContentPlaceHolder2" >
    <div id="center">
        <table>
            <tr>
                <td>
                    Company Name:
                </td>
                <td>
                    <asp:TextBox runat="server" ID="txtbxCompanyName" Width="222px" ></asp:TextBox>
                </td>
            </tr>
            <tr>
                <td>
                    Contact:
                </td>
                <td>
                    <asp:TextBox runat="server" ID="txtbxContact" Width="222px"></asp:TextBox>
                </td>
            </tr>
            <tr>
                <td>
                    Address:
                </td>
                <td>
                    <asp:TextBox runat="server" ID="txtbxAddress" Width="222px"></asp:TextBox>
                </td>
            </tr>
            <tr>
                <td>
                    Phone:
                </td>
                <td>
                    <asp:TextBox runat="server" ID="txtbxPhone" Width="222px"></asp:TextBox>
                </td>
            </tr>
            <tr>
                <td>
                    Email:
                </td>
                <td>
                    <asp:TextBox runat="server" ID="txtbxEmail" Width="222px"></asp:TextBox>
                </td>
            </tr>
            <tr>
                <td>
                    Bonded By:
                </td>
                <td>
                    <asp:TextBox runat="server" ID="txtbxBondedBy" Width="222px"></asp:TextBox>
                </td>
            </tr>
            <tr>
                <td>
                    How Much:
                </td>
                <td>
                    <asp:TextBox runat="server" ID="txtbxHowMuch" Width="222px"></asp:TextBox>
                </td>
            </tr>
            <tr>
                <td>
                    Exp. Date:
                </td>
                <td>
                    <asp:TextBox runat="server" ID="txtbxExpDate" Width="222px"></asp:TextBox>
                </td>
            </tr>
            <tr>
                <td colspan="2">
                    <asp:button runat="server" ID="btnSubmit" Text="Submit" />
                </td>
            </tr>
        </table>
        <asp:Label runat="server" ForeColor="Red" ID="lblMsg"></asp:Label>
    </div>
</asp:Content>
