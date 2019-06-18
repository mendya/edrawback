<%@ Page Language="VB" AutoEventWireup="false" CodeFile="DocumentsAdmin.aspx.vb" Inherits="DocumentsAdmin" MasterPageFile="~/MasterPage.master" %>

<asp:Content runat="server" ID="content1" ContentPlaceHolderID="head">
</asp:Content>
<asp:Content runat="server" ID="content2" ContentPlaceHolderID="ContentPlaceHolder1">
    <asp:Label runat="server" ID="lblLogged"></asp:Label>
     &nbsp; | &nbsp;    
        <a href="Admin.aspx">Go Back to Main Menu</a>
</asp:Content>
<asp:Content runat="server" ID="content3" ContentPlaceHolderID="ContentPlaceHolder2">

    <ul>
        <li><a target="_blank" href="Drawback_Questionnaire.pdf">Drawback Questionnaire</a></li>
        <li><a target="_blank" href="Attachments_to_dbk_applications.pdf">Exhibits for special priveleges</a></li>
        <li><a target="_blank" href="eD_Agreement.docx">eD Agreement</a></li>
		<li><a target="_blank" href="Customs_POA.docx">POA</a></li>
    </ul>
    </asp:Content>

