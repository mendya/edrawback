<%@ Page Language="VB" AutoEventWireup="false" CodeFile="NewDrawback.aspx.vb" Inherits="NewDrawback"  MasterPageFile="~/MasterPage.master"%>

<asp:Content runat="server" ID="content1" ContentPlaceHolderID="head">
    <script type="text/javascript">
        $.jgrid.no_legacy_api = true;
        $.jgrid.useJSON = true;
</script>
<script src="scripts/ui.multiselect.js" type="text/javascript"></script>
<script src="scripts/jquery.jqGrid.min.js" type="text/javascript"></script>
<script src="scripts/jquery.tablednd.js" type="text/javascript"></script>
<script src="scripts/jquery.contextmenu.js" type="text/javascript"></script>
    <link rel="stylesheet" type="text/css" media="screen" href="styles/ui.jqgrid.css" />
<link rel="stylesheet" type="text/css" media="screen" href="styles/ui.multiselect.css" />
    <script type="text/javascript">
        $(document).ready(function () {

            jQuery("#list9").jqGrid({
                url: 'get_exports.ashx?company=' + $('#<%= ddlCompany.ClientID%>').val(),
                datatype: "json",
                colNames: ['Style', 'Size/Color', '7501', 'Port Code', 'CD', 'Import Date', 'Received Date', 'Tarrif No', 'Qty Exported', 'Value of Product', 'Duty Rate', 'Total Request'],
                colModel: [{ name: 'id', index: 'id', width: 30 }, { name: 'sc', index: 'sc', width: 55 }, { name: '7501', index: '7501', width: 90 }, { name: 'pc', index: 'pc', width: 100 }, { name: 'cd', index: 'cd', width: 80, align: "right" }, { name: 'imd', index: 'imd', width: 80, align: "right" }, { name: 'rd', index: 'rd', width: 80, align: "right" }, { name: 'tn', index: 'tn', width: 150, sortable: false }, { name: 'qe', index: 'qe', width: 150, sortable: false }, { name: 'vp', index: 'vp', width: 150, sortable: false }, { name: 'dr', index: 'dr', width: 150, sortable: false }, { name: 'tr', index: 'tr', width: 150, sortable: false }],
                rowNum: 10,
                rowList: [10, 20, 30],
                pager: '#pager9',
                sortname: 'sc',
                recordpos: 'left',
                viewrecords: true,
                sortorder: "desc",
                multiselect: true,
                caption: "List of Exports"
            });
            jQuery("#list9").jqGrid('navGrid', '#pager9', { add: false, del: false, edit: false, position: 'right' });
            jQuery("#m1").click(function () {
                var s; s = jQuery("#list9").jqGrid('getGridParam', 'selarrrow'); alert(s);
            });
            jQuery("#m1s").click(function () { jQuery("#list9").jqGrid('setSelection', "13"); });
        });

    </script>
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
                    <span style="font-size: 1.5em;">Company:</span>
                    
                    <asp:DropDownList Font-Size="1.5em" runat="server" ID="ddlCompany"> </asp:DropDownList>
                    <br />

                   <span style="font-size:1.4em;font-weight:bold;padding-right:10px;">Drawback #</span>
                    <span id="dn" style="color:blue;font-size:1.4em;">8230000011</span>
                    <table id="list9"></table> <div id="pager9"></div> <br /> 
                    <a href="javascript:void(0)" id="m1">Get Selected id's</a> 
                    <a href="javascript:void(0)" id="m1s">Select(Unselect) row 13</a> 
                </td>
            </tr>
        </table>
    </div>
</asp:Content>
