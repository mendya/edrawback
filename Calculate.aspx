<%@ Page Language="VB" AutoEventWireup="false" CodeFile="Calculate.aspx.vb" Inherits="Calculate" MasterPageFile="~/MasterPage.master" MaintainScrollPositionOnPostback="true" %>

<asp:Content runat="server" ID="content1" ContentPlaceHolderID="head">
    <style type="text/css" media="screen">
        table {
            border-collapse: collapse;
            border: 1px solid black;
        }

            table td {
                border: 1px solid black;
                min-width: 120px;
            }
    </style>
</asp:Content>
<asp:Content runat="server" ID="content2" ContentPlaceHolderID="ContentPlaceHolder1">
</asp:Content>
<asp:Content runat="server" ID="content3" ContentPlaceHolderID="ContentPlaceHolder2">

    <h3>Calculate Your Drawback</h3>
    <div class="clear" style="height: 10px;"></div>
    <div class="yorn">
        
            Approximately how much do you export per year?<br />
             <span style="font-size: .8em;">(Cost of merchandise upon importation, not re-sale price.)</span>
       

    </div>
    <asp:TextBox runat="server" ID="ExportPerYear" Width="100px"></asp:TextBox>
    <div class="clear"></div>

    <div class="clear" style="height: 10px;"></div>
    <div class="yorn">
       
            What was the Tax Rate that you paid?<br />
             <span style="font-size: .8em;">(If you don’t know your tax rate then Enter 5% or visit <a href="http://hts.usitc.gov/" target="_blank">http://hts.usitc.gov/</a> for an exact rate. )</span>
        

    </div>
    <asp:TextBox runat="server" ID="TaxRate" Width="100px"></asp:TextBox>
    <div class="clear"></div>
    <div class="clear" style="height: 10px;"></div>


    <p>
        <asp:Button runat="server" ID="btnSubmit" Text="Submit" /></p>
    <div class="clear" style="height: 10px;"></div>

    <p>
        <asp:Label runat="server" ID="lblMsg" ForeColor="Red"></asp:Label></p>

</asp:Content>
