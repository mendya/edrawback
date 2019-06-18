<%@ Page Language="VB" AutoEventWireup="false" CodeFile="UserGuide.aspx.vb" Inherits="UserGuide" MasterPageFile="~/MasterPage.master" %>

<asp:Content runat="server" ID="content1" ContentPlaceHolderID="head"></asp:Content>
<asp:Content runat="server" ID="content2" ContentPlaceHolderID="ContentPlaceHolder1">
    <asp:Label runat="server" ID="lblLogged"></asp:Label>
     &nbsp;  | &nbsp;    
    <a href="javascript:history.go(-1)">Go Back to Main Menu</a>
</asp:Content>
<asp:Content runat="server" ID="content3" ContentPlaceHolderID="ContentPlaceHolder2">
   
    <h2>USERS GUIDE</h2>

    <h3>Storing the import documents:</h3>

    1)	Upon receiving an import from U.P.S.:  The U.P.S. and import buttons should be pressed. Then the U.P.S. Entry Number, style number and date of importation should be entered into the appropriate boxes. The date should be entered by year first then month and then the day (example: 2014-03-23). If the exact date of importation is unknown then please enter the approximate date. When this information is entered the submit button should be pressed. No documents are needed to be attached to this submission.
    <br />
    <br />
    2)	Upon receiving an activity report from FedEx: [The activity report from FedEx is received via email or you may get a hard copy by mail. With the activity report comes the import documents.] The FedEx and import buttons should be pressed and the tracking number, style numbers and date of importation should be copied from the activity report and typed into the appropriate boxes. The activity report should then be up loaded to the system and press submit. If the report is received by mail, it should be scanned into the system and then press submit.

    <h3>Storing the export information:</h3>

    1)	When exporting with U.P.S. or FedEx to countries other than Canada or Mexico; the proper freight carrier and export buttons should be pressed. The tracking number, style number and date of exportation should then be typed into the appropriate boxes. Scan in the commercial invoice and Bill of Lading and press upload.
    <br />
    <br />
    2)	If the export is to Canada or Mexico; the above procedure should be followed with the addition of scanning and uploading the packing list. The Canadian B3 customs form or the Mexican Pedimento de Importation will also need to be sent, this is attainable from your foreign customs broker.   

</asp:Content>
