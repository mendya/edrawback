<%@ Page Language="VB" AutoEventWireup="false" CodeFile="PendingAdmin.aspx.vb" Inherits="PendingAdmin" MaintainScrollPositionOnPostback="true" MasterPageFile="~/MasterPage.master" %>

<script runat="server">


</script>


<asp:Content runat="server" ID="content1" ContentPlaceHolderID="head">


    <style type="text/css">
        .ui-accordion-header {
            margin-bottom: 5px;
        }

            .ui-accordion-header.ui-state-active {
                margin-bottom: 0;
            }

        .ui-accordion-content-active {
            margin-bottom: 5px;
        }

        .displaynone {
            display: none;
        }

        .auto-style1 {
            width: 252px;
        }

        .leftside {
            float: left;
            width: 600px;
        }

        .rightside {
            float: right;
            width: 700px;
        }

        .accordion {
            width: 570px;
            margin: 0px auto;
        }

            .accordion .ui-accordion-content {
                /*width: 100%;*/
                background-color: #f3f3f3;
                color: #777;
                font-size: 10pt;
                line-height: 16pt;
            }
        .content {
            font-size: .9em;
        }
        .label {
            display: inline;
            margin-right: 4px;
            vertical-align: top;
        }
        fieldset .content {
    display: none;
}
    </style>
    <%--    <script type="text/javascript" src="https://ajax.googleapis.com/ajax/libs/jquery/1.5.0/jquery.min.js"></script> --%>
    <script src="Scripts/jquery.gdocsviewer.js" type="text/javascript"></script>


    <script type="text/javascript">
        $(document).ready(function () {
            var lastUpdate = 0;
            var checkInterval = setInterval(function () {
                if (Date().getTime() - lastUpdate > 300000) {
                    clearInterval(checkInterval);
                } else {
                    $.get('/ImStillAlive.action');
                }
            }, 300000); // 5 mins * 60 * 1000

            $(document).keydown(function () {
                lastUpdate = new Date().getTime();
            });
            $('#cleartextboxes').bind('click', function () {
                $('#textboxes input[type=text]').val('');
            });
            $('#cleartextboxes2').bind('click', function () {
                $('#textboxes2 input[type=text]').val('');
            });
        });
        /*<![CDATA[*/
        //$(document).ready(function () {
        //    $('a.embed').gdocsViewer({ width: 600, height: 750 });
        //    $('#embedURL').gdocsViewer();
        //    $('#embedURL2').gdocsViewer();
        //});
        /*]]>*/


    </script>
     <script type="text/javascript">
         var total1;
         var total2;
         var total3;
         var total4;
         var total5;
         var total6;
         var total7;
         var total8;
         var total9;
         var total10;
         $(document).ready(function () {
             $("#<%=btnUpdateImport.ClientID%>").click(function () {
                 var text = new Array();
                 $('#textboxes input[type="text"]').each(function () {
                     text.push($(this).val());
                 });
                 alert(text);
                 return false;

             });
         });
     </script>
    <script type="text/javascript">
        $("input:checkbox").click(function () {
            return this.checked || confirm('Are you sure?');
        });
    </script>
    <script type="text/javascript">
        /* http://techbrij.com/show-modal-popup-edit-aspdotnet-gridview */
        function ShowErrorPopup() {
            $('#mask').show();
            $('#<%=pnlerrorpopup.ClientID%>').show();
        }
        function HideErrorPopup() {
            $('#mask').hide();
            $('#<%=pnlerrorpopup.ClientID %>').hide();
        }
        function ShowPopup() {
            $('#mask').show();
            $('#<%=pnlpopup.ClientID %>').show();
        }
        function HidePopup() {
            $('#mask').hide();
            $('#<%=pnlpopup.ClientID %>').hide();
        }
        $(".btnClose").on('click', function () {
            HidePopup();
        });
        function ShowInfoImportPopup() {
            $('#mask').show();
            $('#<%=pnlinfoimportpopup.ClientID%>').show();
        }
        function HideInfoImportPopup() {
            $('#mask').hide();
            $('#<%=pnlinfoimportpopup.ClientID%>').hide();
        }
        $(".btnCloseInfoImport").on('click', function () {
            HideInfoImportPopup();
        });
        function ShowInfoExportPopup() {
            $('#mask').show();
            $('#<%=pnlinfoexportpopup.ClientID%>').show();
        }
        function HideInfoExportPopup() {
            $('#mask').hide();
            $('#<%=pnlinfoexportpopup.ClientID%>').hide();
        }
        $(".btnCloseInfoExport").on('click', function () {
            HideInfoExportPopup();
        });
    </script>
    <script>
        $(function () {
            $(document).tooltip();
        });
    </script>
    <script>
        $(function () {
            $("#accordion").accordion({
                collapsible: true
            });
        });
        $(function () {
            var availableTags = Tags;
            $("#ContentPlaceHolder2_txtFilter").autocomplete({
                source: availableTags,
                select: function (event, ui) {
                    //assign value back to the form element
                    if (ui.item) {
                        $(event.target).val(ui.item.value);
                    }
                    //submit the form

                    $("#<%= btnSubmit.clientID %>").click();
                }
            });
        });
    </script>
    <script>
        $(document).ready(function () {

            $("#sizecolor").find("input[type=text]").each(function () {
                var elem = $(this);
                // Save current value of element
                elem.data('oldVal', elem.val());

                // Look for changes in the value
                elem.bind("propertychange keyup input paste", function (event) {
                    // If value has changed...
                    if (elem.data('oldVal') != elem.val()) {
                        // Updated stored value
                        elem.data('oldVal', elem.val());

                        // Do action
                        //....
                        var count = 1;
                        var size, color, units, value;
                        alert(count );
                        $("#sizecolor").find("input[type=text]").each(function () {
                            var elem = $(this);
                            
                            if (count % 1 == 0) {
                                size = elem.val();
                                
                            } else if (count == 2) {
                                color = elem.val();
                            } else if (count == 3) {
                                units = elem.val();
                            }
                            count++;
                        });

                        var val1 = Number($('#<%=txtValue1.ClientID%>').val());
                        

                        var total1_1 = (val1 * (percRate1 / 100)) + (fixedRate1 ) + (kiloRate1 * kilos1);
                        var total1_2 = (val2 * (percRate1 / 100)) + (fixedRate1 ) + (kiloRate1 * kilos1);
                        var total1_3 = (val3 * (percRate1 / 100)) + (fixedRate1 ) + (kiloRate1 * kilos1);
                        var total1_4 = (val4 * (percRate1 / 100)) + (fixedRate1 ) + (kiloRate1 * kilos1);
                        var total1_5 = (val5 * (percRate1 / 100)) + (fixedRate1 ) + (kiloRate1 * kilos1);
                        var total1_6 = (val6 * (percRate1 / 100)) + (fixedRate1 ) + (kiloRate1 * kilos1);
                        var total1_7 = (val7 * (percRate1 / 100)) + (fixedRate1 ) + (kiloRate1 * kilos1);
                        var total1_8 = (val8 * (percRate1 / 100)) + (fixedRate1 ) + (kiloRate1 * kilos1);
                        var total1_9 = (val9 * (percRate1 / 100)) + (fixedRate1 ) + (kiloRate1 * kilos1);
                        var total1_10 = (val10 * (percRate1 / 100)) + (fixedRate1 ) + (kiloRate1 * kilos1);
                        //
                        
                        var total2_1 = (val1 * (percRate2 / 100)) + (fixedRate2 ) + (kiloRate2 * kilos2);
                        var total2_2 = (val2 * (percRate2 / 100)) + (fixedRate2 ) + (kiloRate2 * kilos2);
                        var total2_3 = (val3 * (percRate2 / 100)) + (fixedRate2 ) + (kiloRate2 * kilos2);
                        var total2_4 = (val4 * (percRate2 / 100)) + (fixedRate2 ) + (kiloRate2 * kilos2);
                        var total2_5 = (val5 * (percRate2 / 100)) + (fixedRate2 ) + (kiloRate2 * kilos2);
                        var total2_6 = (val6 * (percRate2 / 100)) + (fixedRate2 ) + (kiloRate2 * kilos2);
                        var total2_7 = (val7 * (percRate2 / 100)) + (fixedRate2 ) + (kiloRate2 * kilos2);
                        var total2_8 = (val8 * (percRate2 / 100)) + (fixedRate2 ) + (kiloRate2 * kilos2);
                        var total2_9 = (val9 * (percRate2 / 100)) + (fixedRate2 ) + (kiloRate2 * kilos2);
                        var total2_10 = (val10 * (percRate2 / 100)) + (fixedRate2 ) + (kiloRate2 * kilos2);
                        //
                        
                        var total3_1 = (val1 * (percRate3 / 100)) + (fixedRate3 ) + (kiloRate3 * kilos3);
                        var total3_2 = (val2 * (percRate3 / 100)) + (fixedRate3 ) + (kiloRate3 * kilos3);
                        var total3_3 = (val3 * (percRate3 / 100)) + (fixedRate3 ) + (kiloRate3 * kilos3);
                        var total3_4 = (val4 * (percRate3 / 100)) + (fixedRate3 ) + (kiloRate3 * kilos3);
                        var total3_5 = (val5 * (percRate3 / 100)) + (fixedRate3 ) + (kiloRate3 * kilos3);
                        var total3_6 = (val6 * (percRate3 / 100)) + (fixedRate3 ) + (kiloRate3 * kilos3);
                        var total3_7 = (val7 * (percRate3 / 100)) + (fixedRate3 ) + (kiloRate3 * kilos3);
                        var total3_8 = (val8 * (percRate3 / 100)) + (fixedRate3 ) + (kiloRate3 * kilos3);
                        var total3_9 = (val9 * (percRate3 / 100)) + (fixedRate3 ) + (kiloRate3 * kilos3);
                        var total3_10 = (val10 * (percRate3 / 100)) + (fixedRate3 ) + (kiloRate3 * kilos3);
                        //
                        
                        var total4_1 = (val1 * (percRate4 / 100)) + (fixedRate4 ) + (kiloRate4 * kilos4);
                        var total4_2 = (val2 * (percRate4 / 100)) + (fixedRate4 ) + (kiloRate4 * kilos4);
                        var total4_3 = (val3 * (percRate4 / 100)) + (fixedRate4 ) + (kiloRate4 * kilos4);
                        var total4_4 = (val4 * (percRate4 / 100)) + (fixedRate4 ) + (kiloRate4 * kilos4);
                        var total4_5 = (val5 * (percRate4 / 100)) + (fixedRate4 ) + (kiloRate4 * kilos4);
                        var total4_6 = (val6 * (percRate4 / 100)) + (fixedRate4 ) + (kiloRate4 * kilos4);
                        var total4_7 = (val7 * (percRate4 / 100)) + (fixedRate4 ) + (kiloRate4 * kilos4);
                        var total4_8 = (val8 * (percRate4 / 100)) + (fixedRate4 ) + (kiloRate4 * kilos4);
                        var total4_9 = (val9 * (percRate4 / 100)) + (fixedRate4 ) + (kiloRate4 * kilos4);
                        var total4_10 = (val10 * (percRate4 / 100)) + (fixedRate4 ) + (kiloRate4 * kilos4);
                        //
                        var convRate = Number($('#<%=txtConversion.ClientID%>').val()); //
                        //
                         total1 = (total1_1 + total2_1 + total3_1 + total4_1) * convRate;
                         total2 = (total1_2 + total2_2 + total3_2 + total4_2) * convRate;
                         total3 = (total1_3 + total2_3 + total3_3 + total4_3) * convRate;
                         total4 = (total1_4 + total2_4 + total3_4 + total4_4) * convRate;
                         total5 = (total1_5 + total2_5 + total3_5 + total4_5) * convRate;
                         total6 = (total1_6 + total2_6 + total3_6 + total4_6) * convRate;
                         total7 = (total1_7 + total2_7 + total3_7 + total4_7) * convRate;
                         total8 = (total1_8 + total2_8 + total3_8 + total4_8) * convRate;
                         total9 = (total1_9 + total2_9 + total3_9 + total4_9) * convRate;
                         total10 = (total1_10 + total2_10 + total3_10 + total4_10) * convRate;

                        if ($("#<%= txtSize.ClientID%>").val().length > 0 || $("#<%= txtColor.ClientID%>").val().length > 0) {
                            $("#totals").html( $("#<%= txtSize.ClientID%>").val() + " " + $("#<%= txtColor.ClientID%>").val() + " - " + "$" + total1.toFixed(2));
                        }
                       
                        alert('hi');
                    }
                });
            });
        });

    </script>
    <script>
        $(document).ready(function () {

            $("#addsc2").click(function () {
                $("#textboxes").clone().insertAfter($("#textboxes"));
                $("#textboxes").find("input[type=text]").each(function () {
                    var elem = $(this);
                    // Save current value of element
                    elem.data('oldVal', elem.val());

                    // Look for changes in the value
                    elem.bind("propertychange keyup input paste", function (event) {
                        // If value has changed...
                        if (elem.data('oldVal') != elem.val()) {
                            // Updated stored value
                            elem.data('oldVal', elem.val());

                            // Do action
                            //....
                            var count = 1;
                            var size, color, units, value;
                            $("#textboxes").find("input[type=text]").each(function () {
                                var elem = $(this);
                                alert(count % 33);
                                if (count % 33 == 0) {
                                    size = elem.val();

                                } else if (count == 2) {
                                    color = elem.val();
                                } else if (count == 3) {
                                    units = elem.val();
                                }
                                count++;
                            });
                        }
                    });
                });
                //$("#sc2").show();
                //$("#addsc2").hide();
            });
        });
    </script>
    <style>
        label {
            display: inline-block;
            width: 5em;
        }
    </style>
</asp:Content>
<asp:Content runat="server" ID="content2" ContentPlaceHolderID="ContentPlaceHolder1">

    <asp:Label runat="server" ID="lblLogged"></asp:Label>
    &nbsp; | &nbsp;    
        <a href="Admin.aspx">Go Back to Main Menu</a>

</asp:Content>
<asp:Content runat="server" ID="content3" ContentPlaceHolderID="ContentPlaceHolder2">


    <table id="center">
        <tr>
            <td>
                <div>
                    <asp:Label ID="lbMessage" runat="server" ForeColor="Red"></asp:Label>
                </div>
                <asp:Panel ID="pnlRename" runat="server" Visible="false">
                    <table style="width: 100%;">
                        <tr>
                            <td align="center" colspan="3">&nbsp;</td>
                        </tr>
                        <tr>
                            <td class="style1">&nbsp; Old Name:
                            </td>
                            <td class="style2">&nbsp;<asp:Label ID="lbOldName" runat="server"></asp:Label>
                                &nbsp;</td>
                            <td>&nbsp;
                            </td>
                        </tr>
                        <tr>
                            <td class="style1">&nbsp; New Name:</td>
                            <td class="style2">&nbsp;<asp:TextBox ID="tbNewName" runat="server" Width="300px"></asp:TextBox>
                            </td>
                            <td>&nbsp;
                            </td>
                        </tr>
                        <tr>
                            <td class="style1">&nbsp;</td>
                            <td class="style2">
                                <asp:Button ID="btnCancle" runat="server" Height="23px"
                                    OnClick="btnCancle_Click" Text="Cancel" Width="100px" />
                                &nbsp;&nbsp;
                        <asp:Button ID="btnRename" runat="server" Height="23px"
                            OnClick="btnRename_Click" Text="Rename" Width="100px" />
                            </td>
                            <td>&nbsp;</td>
                        </tr>
                    </table>
                </asp:Panel>

                <div id="left">
                    <span style="font-size: 1.5em;">Company:</span>
                    <asp:DropDownList Font-Size="1.5em" runat="server" ID="ddlCompany" AutoPostBack="true" OnSelectedIndexChanged="ddlCompany_SelectedIndexChanged"></asp:DropDownList>
                    <br />
                    Current Location:
                    <asp:Panel ID="pnlCurrentLocation" runat="server" Style="margin-left: 0px">
                    </asp:Panel>

                </div>
                <div>
                    Filter by Style:
                                <asp:TextBox runat="server" ID="txtFilter"></asp:TextBox><asp:Button runat="server" ID="btnSubmit" Text="Submit" /><asp:Button runat="server" ID="btnClr" Text="Clear" />
                    <asp:DropDownList AutoPostBack="true" runat="server" ID="ddlstatus" OnSelectedIndexChanged="ddlstatus_SelectedIndexChanged">
                        <asp:ListItem Text="Not Completed" Value="Not Completed"></asp:ListItem>
                        <asp:ListItem Text="Completed" Value="Completed"></asp:ListItem>
                        <asp:ListItem Text="All" Value="All" Selected="True"></asp:ListItem>
                    </asp:DropDownList>
                </div>
                <div id="scroll">
                    <asp:GridView ID="gvFileSystem" runat="server" AutoGenerateColumns="False"
                        CellPadding="4" DataKeyNames="Type,FullPath,Location,Name" Font-Size="Small"
                        ForeColor="#333333" GridLines="None" OnRowCommand="gvFileSystem_RowCommand"
                        OnRowDataBound="gvFileSystem_RowDataBound" Width="688px">
                        <AlternatingRowStyle BackColor="White" />
                        <Columns>
                            <asp:ButtonField CommandName="Open" DataTextField="Name" ItemStyle-Width="200px" HeaderText="Name">
                                <HeaderStyle HorizontalAlign="Left" Width="200px" />
                            </asp:ButtonField>
                            <asp:BoundField DataField="Size" HeaderText="Size" Visible="false">
                                <HeaderStyle HorizontalAlign="Left" Width="80px" />
                            </asp:BoundField>
                            <asp:BoundField DataField="UploadTime" HeaderText="Upload Time" Visible="false">
                                <HeaderStyle HorizontalAlign="Left" Width="140px" />
                            </asp:BoundField>
                            <asp:BoundField DataField="Type" HeaderText="Type">
                                <HeaderStyle HorizontalAlign="Left" Width="70px" />
                            </asp:BoundField>
                            <asp:ButtonField CommandName="DeleteFileOrFolder" DataTextField="FullPath"
                                DataTextFormatString="Delete" HeaderText="Delete">
                                <HeaderStyle Width="50px" HorizontalAlign="Left" />
                                <ItemStyle Width="50px" />
                            </asp:ButtonField>
                            <asp:ButtonField CommandName="Rename" DataTextField="FullPath"
                                DataTextFormatString="Rename" Text="ButtonField" HeaderText="Rename" />
                            <asp:TemplateField HeaderText="Status">
                                <ItemTemplate>
                                    <asp:CheckBox ID="chbx" runat="server" CssClass="chkbx" Enabled="true" AutoPostBack="true" OnCheckedChanged="Unnamed_CheckedChanged" Checked='<%# Convert.ToBoolean(Eval("Approved")) %>' />
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:BoundField DataField="FullPath" HeaderStyle-CssClass="displaynone" ItemStyle-CssClass="displaynone" Visible="true" />
                            <asp:TemplateField HeaderText="Comments">
                                <ItemTemplate>
                                    <asp:Label ID="clbl" runat="server" Text='<%# Eval("Comments")%>'></asp:Label>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="" SortExpression="">
                                <ItemTemplate>
                                    <asp:LinkButton ID="LinkButtonEdit" runat="server" CommandName="ShowPopup" CommandArgument="<%# CType(Container, GridViewRow).RowIndex %>">Edit</asp:LinkButton>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="" SortExpression="">
                                <ItemTemplate>
                                    <asp:LinkButton ID="LinkButtonInfoPage" runat="server" CommandName="ShowInfoPopup" CommandArgument="<%# CType(Container, GridViewRow).RowIndex%>">Info</asp:LinkButton>
                                </ItemTemplate>
                            </asp:TemplateField>

                            <%-- <asp:BoundField DataField="Comments" HeaderText="Comments"  HeaderStyle-HorizontalAlign="Left"  />--%>
                        </Columns>
                        <EditRowStyle BackColor="#2461BF" />
                        <FooterStyle BackColor="#507CD1" Font-Bold="True" ForeColor="White" />
                        <HeaderStyle BackColor="#507CD1" Font-Bold="True" ForeColor="White"
                            Height="18px" />
                        <PagerStyle BackColor="#2461BF" ForeColor="White" HorizontalAlign="Center" />
                        <RowStyle BackColor="#EFF3FB" Height="16px" />
                        <SelectedRowStyle BackColor="#D1DDF1" Font-Bold="True" ForeColor="#333333" />

                    </asp:GridView>
                    <asp:Panel runat="server" ID="pnlGoBack"></asp:Panel>
                </div>

            </td>
        </tr>
    </table>
    <div id="mask">
    </div>
    <asp:Panel ID="pnlpopup" runat="server" BackColor="White" Height="175px"
        Width="300px" Style="z-index: 111; background-color: White; position: absolute; left: 35%; top: 42%; border: outset 2px gray; padding: 5px; display: none">
        <table width="100%" style="width: 100%; height: 100%;" cellpadding="0" cellspacing="5">
            <tr style="background-color: #0924BC">
                <td colspan="2" style="color: White; font-weight: bold; font-size: 1.2em; padding: 3px"
                    align="center">Edit Comments <a id="closebtn" style="color: white; float: right; text-decoration: none" onclick="HidePopup()" class="btnClose" href="#">X</a>
                </td>
            </tr>
            <tr>
                <td>
                    <asp:TextBox ID="txtComments" TextMode="MultiLine" runat="server"></asp:TextBox>
                </td>
            </tr>
            <tr>
                <td>
                    <asp:Button ID="btnUpdate" CommandName="Update" runat="server" Text="Update" OnClick="btnUpdate_Click" />
                    <asp:Button ID="btnUpdateEmail" CommandName="UpdateEmail" runat="server" Text="Update & Email" OnClick="btnUpdateEmail_Click" />
                    <input type="button" class="btnClose" onclick="HidePopup()" value="Cancel" />
                </td>

            </tr>
            <tr>
                <td>
                    <asp:HiddenField runat="server" ID="hdnFull" />
                    <asp:HiddenField runat="server" ID="hdnStatus" />
                    <asp:HiddenField runat="server" ID="hdnImportDate" />
                    <asp:HiddenField runat="server" ID="hdnStyle" />
                </td>
            </tr>
        </table>

    </asp:Panel>
    <asp:Panel ID="pnlinfoimportpopup" runat="server" BackColor="White" Height="2800px"
        Width="1320px" Style="z-index: 111; background-color: White; position: absolute; left: 1%; top: 2%; border: outset 2px gray; padding: 5px; display: none">
        <table width="100%">
            <tr style="background-color: #0924BC; height: 12px">
                <td colspan="2" style="color: White; font-weight: bold; font-size: 1.2em; padding: 3px"
                    align="center">Import Information Page <a id="A1" style="color: white; float: right; text-decoration: none" onclick="HideInfoImportPopup()" class="btnCloseInfoImport" href="#">X</a>
                </td>
            </tr>
        </table>
        <div class="leftside">
            <table width="100%" style="width: 100%; height: 100%;" cellpadding="0" cellspacing="5">

                <tr style="height: 15px;">
                    <td>
                        <asp:DropDownList runat="server" ID="ddlinfoimport" AutoPostBack="true" OnSelectedIndexChanged="ddlinfoimport_SelectedIndexChanged"></asp:DropDownList>
                    </td>

                </tr>
                <tr>
                    <td style="vertical-align: top;">
                        <a href="http://www.edrawbacks.com/pdf.pdf" id="embedURL">Download file</a>

                    </td>
                </tr>
                <tr>
                    <td style="vertical-align: top;"></td>

                </tr>
                <tr>
                    <td></td>
                </tr>
            </table>
        </div>
        <div class="rightside">
            <div style="float: left">
                <fieldset>
                    <legend>Duty Rates Per Piece</legend>
                        <div id="totals">

                        </div>
                </fieldset>

                   
                
            </div>
            <div style="float: right;">
                <asp:Button runat="server" ID="btnUpdateImport" Text="Update" OnClick="btnUpdateImport_Click" />
                <asp:Button ID="btnUpdateImportnClose" runat="server" Text="Update & Close" OnClick="btnUpdateImportnClose_Click" />
                <input type="button" class="btnCloseInfoImport" onclick="HideInfoImportPopup()" value="Cancel" />
                <input type="button" id="cleartextboxes" value="Clear" />

            </div>
            

                <div style="clear: both; height: 10px;"></div>
                <div style="float: left; width: 85px; height: 30px; padding-right: 10px;">
                    <div style="text-align: right;" title="box 1">7501 Number</div>
                </div>
                <div style="float: left; width: 175px; height: 30px;">
                    <input  ID="txt7501num"style="font-size:.9em;" type="text"  />
                </div>
                <div style="float: left; width: 90px; height: 30px; padding-right: 10px;">
                    <div style="text-align: right;" title="box 6">Port Code</div>
                </div>
                <div style="float: left; width: 175px; height: 30px;">
                    <asp:TextBox runat="server" ID="txtPortCode" Font-Size=".9em"></asp:TextBox>
                </div>
                <%-- ----------------------------------------------------------------------- --%>
                <div style="clear: both; height: 10px;"></div>
                <div style="float: left; width: 85px; height: 30px; padding-right: 10px;">
                    <div style="text-align: right; line-height:.78em;" title="box 10">Country of Origin</div>
                </div>
                <div style="float: left; width: 175px; height: 30px;">
                    <asp:TextBox runat="server" ID="txtCntryOrigin" Font-Size=".9em"></asp:TextBox>
                </div>
                <div style="float: left; width: 90px; height: 30px; padding-right: 10px;">
                    <div style="text-align: right;" title="box 11">Import Date</div>
                </div>
                <div style="float: left; width: 175px; height: 30px;">
                    <asp:TextBox runat="server" ID="txtImportDate" Font-Size=".9em"></asp:TextBox>
                </div>
                <%-- ----------------------------------------------------------------------- --%>
                <div style="clear: both; height: 10px;"></div>
                <div style="float: left; width: 85px; height: 30px; padding-right: 10px;">
                    <div style="text-align: right;" title="">Style</div>
                </div>
                <div style="float: left; width: 175px; height: 30px;">
                    <asp:TextBox runat="server" ReadOnly="true" ID="txtStyle" Font-Size=".9em"></asp:TextBox>
                </div>
                <div style="float: left; width: 90px; height: 30px; padding-right: 10px;">
                    <div style="text-align: right;line-height:.78em;" title="">Conversion Rate</div>
                </div>
                <div style="float: left; width: 175px; height: 30px;">
                    <asp:TextBox runat="server" ID="txtConversion" Font-Size=".9em"></asp:TextBox>
                </div>
                <div style="clear: both; height: 10px;"></div>
                <div style="float: left; width: 65px; height: 30px; padding-right: 10px;">
                    <div style="text-align: right;line-height:.77em;" title="box 35">Total Value</div>
                </div>
                <div style="float: left; width: 105px; height: 30px;">
                    <asp:TextBox runat="server" ID="txtTotalVal" Font-Size=".9em"></asp:TextBox>
                </div>
                <div style="float: left; width: 80px; height: 30px; padding-right: 10px;">
                    <div style="text-align: right;" title="box labeled 'other fee summary for block 39'">HMF</div>
                </div>
                <div style="float: left; width: 45px; height: 30px;">
                    <asp:DropDownList runat="server" ID="ddlHMF">
                        <asp:ListItem Text="YES" Value="YES"></asp:ListItem>
                        <asp:ListItem Text="NO" Value="NO"></asp:ListItem>
                    </asp:DropDownList>
                </div>
                <%-- ----------------------------------------------------------------------- --%>
                
                <div style="float: left; width: 85px; height: 30px; padding-right: 10px;">
                    <div style="text-align: right;" title="box labeled 'other fee summary'">MFP</div>
                </div>
                <div style="float: left; width: 175px; height: 30px;">
                    <asp:TextBox runat="server" ID="txtMFP" Font-Size=".9em"></asp:TextBox>
                </div>
                <div style="clear: both; height: 10px;"></div>
                <%-- ----------------------------------------------------------------------- --%>
            <div id="sizecolor">
                <div id="textboxes">
                <fieldset id="fs" class="collapsible" style="cursor:pointer;">
                    <legend>Size/Color 1
                    </legend>
                    <div style="float: left; width: 45px; height: 30px; padding-right: 10px;">
                        <div style="text-align: right;" title="">Size</div>
                    </div> 
                    <div style="float: left; width: 80px; height: 30px;">
                        <asp:TextBox runat="server" ID="txtSize" Font-Size=".9em" Width="70px"></asp:TextBox>
                    </div>
                    <div style="float: left; width: 45px; height: 30px; padding-right: 10px;">
                        <div style="text-align: right;" title="">Color</div>
                    </div> 
                   <div style="float: left; width: 80px; height: 30px;">
                        <asp:TextBox runat="server" ID="txtColor" Font-Size=".9em" Width="70px"></asp:TextBox>
                    </div>
                    <div style="float: left; width: 45px; height: 30px; padding-right: 10px;">
                        <div style="text-align: right;" title="">Units</div>
                    </div>
                    <div style="float: left; width: 80px; height: 30px;">
                        <asp:TextBox runat="server" ID="txtUnits" Font-Size=".9em" Width="70px"></asp:TextBox>
                    </div>
                    <div style="float: left; width: 40px; height: 30px; padding-right: 10px;">
                        <div style="text-align: right;" title="">Value</div>
                    </div>
                    <div style="float: left; width: 85px; height: 30px;">
                        <asp:TextBox runat="server" ID="txtValue1" Font-Size=".9em" Width="70px"></asp:TextBox>
                    </div>
                    <div style="clear: both; height: 8px;"></div>
                    <%-- --%>
                   
                   
                    <div style="float: left; width: 40px; height: 30px; padding-right: 10px;">
                        <div style="text-align: right;font-size:.7em;" title="">Tarrif 1</div>
                    </div> 
                    <div style="float: left; width: 50px; height: 30px;">
                        <asp:TextBox runat="server" ID="txtTarrif1" Font-Size=".8em" Width="50px"></asp:TextBox>
                    </div>
                    <div style="float: left; width: 35px; height: 30px; padding-right: 10px;">
                        <div style="text-align: right;font-size:.7em;" title="">Descr.</div>
                    </div> 
                   <div style="float: left; width: 50px; height: 30px;">
                        <asp:TextBox runat="server" ID="txtDescription1" Font-Size=".8em" Width="50px"></asp:TextBox>
                    </div>
                    <div style="float: left; width: 40px; height: 30px; padding-right: 10px;">
                        <div style="text-align: right;font-size:.7em;" title="">% Rate</div>
                    </div>
                    <div style="float: left; width: 40px; height: 30px;">
                        <asp:TextBox runat="server" ID="txtPercDutyRate1" Font-Size=".9em" Width="30px"></asp:TextBox>
                    </div>
                    <div style="float: left; width: 40px; height: 30px; padding-right: 10px;">
                        <div style="text-align: right;font-size:.7em;" title="">Pc Rate</div>
                    </div>
                    <div style="float: left; width: 40px; height: 30px;">
                        <asp:TextBox runat="server" ID="txtPerPieceRate1" Font-Size=".9em" Width="30px"></asp:TextBox>
                    </div>
                    
                    <div style="float: left; width: 40px; height: 30px; padding-right: 10px;">
                        <div style="text-align: right;font-size:.7em; " title="">Kilo Rate</div>
                    </div> 
                    <div style="float: left; width: 41px; height: 30px;">
                        <asp:TextBox runat="server" ID="txtPerKiloRate1" Font-Size=".9em" Width="40px"></asp:TextBox>
                    </div>
                    <div style="float: left; width: 40px; height: 30px; padding-right: 10px;">
                        <div style="text-align: right;font-size:.7em;" title="">Kilos</div>
                    </div> 
                   <div style="float: left; width: 41px; height: 30px;">
                        <asp:TextBox runat="server" ID="txtKilos1" Font-Size=".9em" Width="40px"></asp:TextBox>
                    </div>
                   <div style="float: left; width: 40px; height: 30px; padding-right: 10px;">
                        <div style="text-align: right;font-size:.7em;" title="">Value</div>
                    </div> 
                   <div style="float: left; width: 41px; height: 30px;">
                        <asp:TextBox runat="server" ID="txtval1" Font-Size=".9em" Width="40px"></asp:TextBox>
                    </div>
                   <div style="clear: both; height: 10px;"></div>
                     <div style="float: left; width: 40px; height: 30px; padding-right: 10px;">
                        <div style="text-align: right;font-size:.7em;" title="">Tarrif 2</div>
                    </div> 
                    <div style="float: left; width: 50px; height: 30px;">
                        <asp:TextBox runat="server" ID="TextBox2" Font-Size=".8em" Width="50px"></asp:TextBox>
                    </div>
                    <div style="float: left; width: 35px; height: 30px; padding-right: 10px;">
                        <div style="text-align: right;font-size:.7em;" title="">Descr.</div>
                    </div> 
                   <div style="float: left; width: 50px; height: 30px;">
                        <asp:TextBox runat="server" ID="TextBox3" Font-Size=".8em" Width="50px"></asp:TextBox>
                    </div>
                    <div style="float: left; width: 40px; height: 30px; padding-right: 10px;">
                        <div style="text-align: right;font-size:.7em;" title="">% Rate</div>
                    </div>
                    <div style="float: left; width: 40px; height: 30px;">
                        <asp:TextBox runat="server" ID="TextBox4" Font-Size=".9em" Width="30px"></asp:TextBox>
                    </div>
                    <div style="float: left; width: 40px; height: 30px; padding-right: 10px;">
                        <div style="text-align: right;font-size:.7em;" title="">Pc Rate</div>
                    </div>
                    <div style="float: left; width: 40px; height: 30px;">
                        <asp:TextBox runat="server" ID="TextBox5" Font-Size=".9em" Width="30px"></asp:TextBox>
                    </div>
                    
                    <div style="float: left; width: 40px; height: 30px; padding-right: 10px;">
                        <div style="text-align: right;font-size:.7em; " title="">Kilo Rate</div>
                    </div> 
                    <div style="float: left; width: 41px; height: 30px;">
                        <asp:TextBox runat="server" ID="TextBox6" Font-Size=".9em" Width="40px"></asp:TextBox>
                    </div>
                    <div style="float: left; width: 40px; height: 30px; padding-right: 10px;">
                        <div style="text-align: right;font-size:.7em;" title="">Kilos</div>
                    </div> 
                   <div style="float: left; width: 41px; height: 30px;">
                        <asp:TextBox runat="server" ID="TextBox7" Font-Size=".9em" Width="40px"></asp:TextBox>
                    </div>
                   <div style="float: left; width: 40px; height: 30px; padding-right: 10px;">
                        <div style="text-align: right;font-size:.7em;" title="">Value</div>
                    </div> 
                   <div style="float: left; width: 41px; height: 30px;">
                        <asp:TextBox runat="server" ID="TextBox8" Font-Size=".9em" Width="40px"></asp:TextBox>
                    </div>
                   <div style="clear: both; height: 10px;"></div>
                     <div style="float: left; width: 40px; height: 30px; padding-right: 10px;">
                        <div style="text-align: right;font-size:.7em;" title="">Tarrif 3</div>
                    </div> 
                    <div style="float: left; width: 50px; height: 30px;">
                        <asp:TextBox runat="server" ID="TextBox9" Font-Size=".8em" Width="50px"></asp:TextBox>
                    </div>
                    <div style="float: left; width: 35px; height: 30px; padding-right: 10px;">
                        <div style="text-align: right;font-size:.7em;" title="">Descr.</div>
                    </div> 
                   <div style="float: left; width: 50px; height: 30px;">
                        <asp:TextBox runat="server" ID="TextBox10" Font-Size=".8em" Width="50px"></asp:TextBox>
                    </div>
                    <div style="float: left; width: 40px; height: 30px; padding-right: 10px;">
                        <div style="text-align: right;font-size:.7em;" title="">% Rate</div>
                    </div>
                    <div style="float: left; width: 40px; height: 30px;">
                        <asp:TextBox runat="server" ID="TextBox11" Font-Size=".9em" Width="30px"></asp:TextBox>
                    </div>
                    <div style="float: left; width: 40px; height: 30px; padding-right: 10px;">
                        <div style="text-align: right;font-size:.7em;" title="">Pc Rate</div>
                    </div>
                    <div style="float: left; width: 40px; height: 30px;">
                        <asp:TextBox runat="server" ID="TextBox12" Font-Size=".9em" Width="30px"></asp:TextBox>
                    </div>
                    
                    <div style="float: left; width: 40px; height: 30px; padding-right: 10px;">
                        <div style="text-align: right;font-size:.7em; " title="">Kilo Rate</div>
                    </div> 
                    <div style="float: left; width: 41px; height: 30px;">
                        <asp:TextBox runat="server" ID="TextBox13" Font-Size=".9em" Width="40px"></asp:TextBox>
                    </div>
                    <div style="float: left; width: 40px; height: 30px; padding-right: 10px;">
                        <div style="text-align: right;font-size:.7em;" title="">Kilos</div>
                    </div> 
                   <div style="float: left; width: 41px; height: 30px;">
                        <asp:TextBox runat="server" ID="TextBox14" Font-Size=".9em" Width="40px"></asp:TextBox>
                    </div>
                   <div style="float: left; width: 40px; height: 30px; padding-right: 10px;">
                        <div style="text-align: right;font-size:.7em;" title="">Value</div>
                    </div> 
                   <div style="float: left; width: 41px; height: 30px;">
                        <asp:TextBox runat="server" ID="TextBox15" Font-Size=".9em" Width="40px"></asp:TextBox>
                    </div>
                   <div style="clear: both; height: 10px;"></div>
                     <div style="float: left; width: 40px; height: 30px; padding-right: 10px;">
                        <div style="text-align: right;font-size:.7em;" title="">Tarrif 4</div>
                    </div> 
                    <div style="float: left; width: 50px; height: 30px;">
                        <asp:TextBox runat="server" ID="TextBox16" Font-Size=".8em" Width="50px"></asp:TextBox>
                    </div>
                    <div style="float: left; width: 35px; height: 30px; padding-right: 10px;">
                        <div style="text-align: right;font-size:.7em;" title="">Descr.</div>
                    </div> 
                   <div style="float: left; width: 50px; height: 30px;">
                        <asp:TextBox runat="server" ID="TextBox17" Font-Size=".8em" Width="50px"></asp:TextBox>
                    </div>
                    <div style="float: left; width: 40px; height: 30px; padding-right: 10px;">
                        <div style="text-align: right;font-size:.7em;" title="">% Rate</div>
                    </div>
                    <div style="float: left; width: 40px; height: 30px;">
                        <asp:TextBox runat="server" ID="TextBox18" Font-Size=".9em" Width="30px"></asp:TextBox>
                    </div>
                    <div style="float: left; width: 40px; height: 30px; padding-right: 10px;">
                        <div style="text-align: right;font-size:.7em;" title="">Pc Rate</div>
                    </div>
                    <div style="float: left; width: 40px; height: 30px;">
                        <asp:TextBox runat="server" ID="TextBox19" Font-Size=".9em" Width="30px"></asp:TextBox>
                    </div>
                    
                    <div style="float: left; width: 40px; height: 30px; padding-right: 10px;">
                        <div style="text-align: right;font-size:.7em; " title="">Kilo Rate</div>
                    </div> 
                    <div style="float: left; width: 41px; height: 30px;">
                        <asp:TextBox runat="server" ID="TextBox20" Font-Size=".9em" Width="40px"></asp:TextBox>
                    </div>
                    <div style="float: left; width: 40px; height: 30px; padding-right: 10px;">
                        <div style="text-align: right;font-size:.7em;" title="">Kilos</div>
                    </div> 
                   <div style="float: left; width: 41px; height: 30px;">
                        <asp:TextBox runat="server" ID="TextBox21" Font-Size=".9em" Width="40px"></asp:TextBox>
                    </div>
                   <div style="float: left; width: 40px; height: 30px; padding-right: 10px;">
                        <div style="text-align: right;font-size:.7em;" title="">Value</div>
                    </div> 
                   <div style="float: left; width: 41px; height: 30px;">
                        <asp:TextBox runat="server" ID="TextBox22" Font-Size=".9em" Width="40px"></asp:TextBox>
                    </div>
                   <div style="clear: both; height: 20px;"></div>
                </fieldset>
                </div>
                <input type="button" id="addsc2" value="Add another size/color" />
                 <%-- ----------------------------------------------------------------------- --%>
                <%-- ----------------------------------------------------------------------- --%>
                <div style="clear: both; height: 20px;"></div>
                <%-- ----------------------------------------------------------------------- --%>
                <%-- ----------------------------------------------------------------------- --%>
                </div>

        </div>
        <asp:HiddenField ID="hdntotal1" runat="server" />
        <asp:HiddenField ID="hdntotal2" runat="server" />
        <asp:HiddenField ID="hdntotal3" runat="server" />
        <asp:HiddenField ID="hdntotal4" runat="server" />
        <asp:HiddenField ID="hdntotal5" runat="server" />
        <asp:HiddenField ID="hdntotal6" runat="server" />
        <asp:HiddenField ID="hdntotal7" runat="server" />
        <asp:HiddenField ID="hdntotal8" runat="server" />
        <asp:HiddenField ID="hdntotal9" runat="server" />
        <asp:HiddenField ID="hdntotal10" runat="server" />

    </asp:Panel>
    <asp:Panel ID="pnlinfoexportpopup" runat="server" BackColor="White" Height="1000px"
        Width="1200px" Style="z-index: 111; background-color: White; position: absolute; left: 5%; top: 2%; border: outset 2px gray; padding: 5px; display: none">
        <table width="100%">
            <tr style="background-color: #0924BC; height: 12px">
                <td colspan="2" style="color: White; font-weight: bold; font-size: 1.2em; padding: 3px"
                    align="center">Export Information Page <a id="A4" style="color: white; float: right; text-decoration: none" onclick="HideInfoExportPopup()" class="btnCloseInfoExport" href="#">X</a>
                </td>
            </tr>
        </table>
        <div class="leftside">
            <table width="100%" style="width: 100%; height: 100%;" cellpadding="0" cellspacing="5">

                <tr style="height: 15px;">
                    <td>
                        <asp:DropDownList runat="server" ID="ddlinfoexport" AutoPostBack="true" OnSelectedIndexChanged="ddlinfoexport_SelectedIndexChanged"></asp:DropDownList>
                    </td>

                </tr>
                <tr>
                    <td style="vertical-align: top;">
                        <a href="http://www.edrawbacks.com/pdf.pdf" id="embedURL2">Download file</a>

                    </td>
                </tr>
                <tr>
                    <td style="vertical-align: top;"></td>

                </tr>
                <tr>
                    <td></td>
                </tr>
            </table>
        </div>
        <div class="rightside">
            <div style="float: left">
                <span style="color: red">Total Duty:</span>
                <asp:TextBox runat="server" ID="TextBox1" ReadOnly="false" ForeColor="Red"></asp:TextBox>
            </div>
            <div style="float: right;">
                <asp:Button runat="server" ID="btnUpdateExport" Text="Update" OnClick="btnUpdateExport_Click" />
                <asp:Button ID="btnUpdateExportnClose" runat="server" Text="Update & Close" OnClick="btnUpdateExportnClose_Click" />
                <input type="button" class="btnCloseInfoExport" onclick="HideInfoExportPopup()" value="Cancel" />
                <input type="button" id="cleartextboxes2" value="Clear" />

            </div>
            <div id="textboxes2">
                <div style="clear: both; height: 20px;"></div>
                <div style="float: left; width: 85px; height: 30px; padding-right: 10px;">
                    <div style="text-align: right;" >Drawback #</div>
                </div>
                <div style="float: left; width: 175px; height: 30px;">
                    <asp:TextBox runat="server" ID="txtDrawbackNum" Font-Size=".9em"></asp:TextBox>
                </div>
                <div style="float: left; width: 90px; height: 30px; padding-right: 10px;">
                    <div style="text-align: right;" >Exportation Date</div>
                </div>
                <div style="float: left; width: 175px; height: 30px;">
                    <asp:TextBox runat="server" ID="txtExpDate" Font-Size=".9em"></asp:TextBox>
                </div>
                <%-- ----------------------------------------------------------------------- --%>
                <div style="clear: both; height: 20px;"></div>
                <div style="float: left; width: 85px; height: 30px; padding-right: 10px;">
                    <div style="text-align: right;" >Freight Carrier</div>
                </div>
                <div style="float: left; width: 175px; height: 30px;">
                    <asp:TextBox runat="server" ID="txtFreightCarrier" Font-Size=".9em"></asp:TextBox>
                </div>
                <div style="float: left; width: 90px; height: 30px; padding-right: 10px;">
                    <div style="text-align: right;">Reference #</div>
                </div>
                <div style="float: left; width: 175px; height: 30px;">
                    <asp:TextBox runat="server" ID="txtRefNo" Font-Size=".9em"></asp:TextBox>
                </div>
                <%-- ----------------------------------------------------------------------- --%>
                <div style="clear: both; height: 20px;"></div>
                <div style="float: left; width: 85px; height: 30px; padding-right: 10px;">
                    <div style="text-align: right;" title="">Style</div>
                </div>
                <div style="float: left; width: 175px; height: 30px;">
                    <asp:TextBox runat="server" ReadOnly="true" ID="txtStyleExp" Font-Size=".9em"></asp:TextBox>
                </div>
                <div style="float: left; width: 90px; height: 30px; padding-right: 10px;">
                    <div style="text-align: right;" title="">Size</div>
                </div>
                <div style="float: left; width: 175px; height: 30px;">
                    <asp:TextBox runat="server" ID="txtSizeExp" Font-Size=".9em"></asp:TextBox>
                </div>
                <%-- ----------------------------------------------------------------------- --%>
                <div style="clear: both; height: 20px;"></div>
                <div style="float: left; width: 85px; height: 30px; padding-right: 10px;">
                    <div style="text-align: right;" title="">Color</div>
                </div>
                <div style="float: left; width: 175px; height: 30px;">
                    <asp:TextBox runat="server" ID="txtColorExp" Font-Size=".9em"></asp:TextBox>
                </div>
                <div style="float: left; width: 90px; height: 30px; padding-right: 10px;">
                    <div style="text-align: right;" title="">Export Country</div>
                </div>
                <div style="float: left; width: 175px; height: 30px;">
                    <asp:TextBox runat="server" ID="txtExpCntry" Font-Size=".9em"></asp:TextBox>
                </div>
                <%-- ----------------------------------------------------------------------- --%>
                <div style="clear: both; height: 20px;"></div>
                <div style="float: left; width: 85px; height: 30px; padding-right: 10px;">
                    <div style="text-align: right;" title="">Units</div>
                </div>
                <div style="float: left; width: 175px; height: 30px;">
                    <asp:TextBox runat="server" ID="txtUnitsExp" Font-Size=".9em"></asp:TextBox>
                </div>
                <%-- ----------------------------------------------------------------------- --%>
                <div style="clear: both; height: 20px;"></div>

            </div>
        </div>
    </asp:Panel>

    <asp:Panel ID="pnlerrorpopup" runat="server" BackColor="White" Height="175px"
        Width="300px" Style="z-index: 111; background-color: White; position: absolute; left: 35%; top: 42%; border: outset 2px gray; padding: 5px; display: none">
        <table width="100%" style="width: 100%; height: 100%;" cellpadding="0" cellspacing="5">
            <tr style="background-color: #0924BC">
                <td colspan="2" style="color: White; font-weight: bold; font-size: 1.2em; padding: 3px"
                    align="center">ERROR MESSAGE <a id="A3" style="color: white; float: right; text-decoration: none" onclick="HidePopup()" class="btnClose" href="#">X</a>
                </td>
            </tr>
            <tr>
                <td>
                    <asp:TextBox ID="txterror" TextMode="MultiLine" runat="server"></asp:TextBox>
                </td>
            </tr>
            <tr>
                <td>
                    <input type="button" class="btnClose" onclick="HideErrorPopup()" value="Cancel" />
                </td>

            </tr>
            <tr>
                <td>
                    <asp:HiddenField runat="server" ID="HiddenField1" />
                    <asp:HiddenField runat="server" ID="HiddenField2" />
                </td>
            </tr>
        </table>
    </asp:Panel>

</asp:Content>


