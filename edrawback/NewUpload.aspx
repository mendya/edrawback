<%@ Page Language="VB" AutoEventWireup="false" CodeFile="NewUpload.aspx.vb" Inherits="NewUpload"  %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jquery/1.11.1/jquery.min.js"></script>
    <script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jqueryui/1.10.4/jquery-ui.min.js"></script>
    <link type="text/css" href="http://ajax.googleapis.com/ajax/libs/jqueryui/1.10.4/themes/smoothness/jquery-ui.css" rel="stylesheet" />
    <script>
        
        
        $(document).ready(function () {
            var wWidth = $(window).width();
            var dWidth = wWidth * 0.49;
            var wHeight = $(window).height();
            var dHeight = wHeight * 0.99;
            $("#dialog-form").dialog({
                autoOpen: false,
                height: dHeight,
                width: dWidth,
                modal: false,
                position: 'left',
                open: function (ev, ui) {
                    
                    $('#myiframe').attr('src', 'http://edrawback.com/docroot/' + $(<%=ddlcompany.ClientID %>).val() + "/" + $(<%=imporexp.ClientID %>).val() + "/" + $(<%=ddlfile.ClientID %>).val() );
                    $(".ui-dialog-titlebar-close", ui.dialog | ui).hide();
                },
                close: function () {
                    /* allFields.val("").removeClass("ui-state-error"); */
                }
            });
            $("#dialog-form2").dialog({
                autoOpen: true,
                height: dHeight,
                width: dWidth,
                modal: false,
                position: 'right',

            });
            //$("#ddlcompany").change(function () {
            //    location.reload();
            //});
            $('#ddlfile').change(function () {
                $('#myiframe').attr('src', 'http://edrawback.com/docroot/' + $(<%=ddlcompany.ClientID %>).val() + "/" + $(<%=imporexp.ClientID %>).val() + "/" + $(<%=ddlfile.ClientID %>).val() );
            });
            $(".datepicker").datepicker();
            $('#<%= lbl.ClientID %>').fadeOut(8000, function () {
                $(this).html(""); //reset the label after fadeout
            });
            $("#dialog-form").dialog("open");
            var availableTags = Tags;
            $('#<%= txtFilter.ClientID %>').autocomplete({
                source: availableTags,
                select: function (event, ui) {
                    //assign value back to the form element
                    if (ui.item) {
                        //$(event.target).val(ui.item.value);   
                        var newline='';
                        if ($('#<%= text_style_no.ClientID %>').val() != '') {
                            newline = '\r\n';
                        }
                        $('#<%= text_style_no.ClientID %>').val($('#<%= text_style_no.ClientID %>').val() + newline + ui.item.value.split(':')[0].trim());
                    }
                    //submit the form                    
                  
                },
                close: function (event, ui) {
                    $('#<%= txtFilter.ClientID %>').val('');
                }
            });
        });
    </script>
    <style>
        .leftside {
            float: left;
            width: 49%;
            border:1px solid black;
            padding:1px;
        }

        .rightside {
            float: right;
            width: 50%;
            border:1px solid black;
            padding-left:15px;
            padding-top: 10px;
        }

    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="leftside" >               
            <div id="dialog-form"><embed style="width:100%;height:100%;" id="myiframe" />  </div>
        </div>
        <div class="rightside">
             <input type="button" value="Go Back to Menu" onclick="location.href = 'Admin.aspx'"  />
            <asp:DropDownList runat="server" ID="ddlcompany" AutoPostBack="true">                
            </asp:DropDownList>
            <asp:DropDownList runat="server" ID="ddlfile" Width="200px" >               
            </asp:DropDownList>
            <asp:Button runat="server" Text="SORT" OnClick="Unnamed_Click" />
            <asp:Button runat="server" Text="SKIP" OnClick="Unnamed1_Click" OnClientClick="return confirm('Are you sure you want to?');" />
            <asp:DropDownList runat="server" ID="imporexp" AutoPostBack="true">
                <asp:ListItem Text="Import" Value="Import"></asp:ListItem>
                <asp:ListItem Text="Export" Value="Export"></asp:ListItem>
            </asp:DropDownList> 
            <br />
            Date of Import/Export <asp:TextBox runat="server" CssClass="datepicker" ID="txtDate"></asp:TextBox>
            
            
            <br />Search for import/export style here.<br /><asp:TextBox runat="server" ID="txtFilter"></asp:TextBox> Click to add to list. <br />
            Enter Styles seperated by new line <br /><asp:TextBox runat="server" CssClass="animated" ID="text_style_no" Width="210px" Height="800px" TextMode="MultiLine" Wrap="False"></asp:TextBox>
            <asp:Button Text="SUMBIT" id="btn" runat="server"/>
            <asp:Label runat="server" ForeColor="Red" Font-Size="1.3em" ID="lbl"></asp:Label>
        </div>
        <asp:HiddenField runat="server" ID="sort" Value="AZ" />
    </form>
</body>
</html>
