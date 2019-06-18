<%@ Page Language="VB" AutoEventWireup="false" CodeFile="Export.aspx.vb" Inherits="PA" %>

<!-- Revised from demo code on http://jqueryui.com/ -->
<!doctype html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <title>Export Information Page</title>
    <script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jquery/1.11.1/jquery.min.js"></script>
    <script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jqueryui/1.10.4/jquery-ui.min.js"></script>
    <link type="text/css" href="http://ajax.googleapis.com/ajax/libs/jqueryui/1.10.4/themes/smoothness/jquery-ui.css" rel="stylesheet" />
<%--    <script src="Scripts/jquery.gdocsviewer.js" type="text/javascript"></script>--%>
    <link rel="stylesheet" media="screen" href="http://handsontable.com/dist/handsontable.full.css">
    <script src="http://handsontable.com/dist/handsontable.full.js"></script>
    <script src="Scripts/jquery.magnific-popup.js"></script>
   <link rel="stylesheet" href="Styles/magnific-popup.css" />
    <style>
        body {
            width: 95%;
			height:500px;
        }
         .white-popup {
            position: relative;
            background: #FFF;
            padding: 40px;
            width: 40%;
            height: 500px;
            margin: 20px auto;
            text-align: center;
        }
        #dialog label, #dialog input {
            display: block;
        }

        #dialog label {
            margin-top: 0.5em;
        }

        #dialog input, #dialog textarea {
            width: 95%;
        }

        #tabs {
            margin-top: 1em;
        }

            #tabs li .ui-icon-close {
                float: left;
                margin: 0.4em 0.2em 0 0;
                cursor: pointer;
            }

        #add_tab {
            cursor: pointer;
        }

        .leftside {
            float: left;
            width: 50%;
        }

        .rightside {
            float: left;
            width: 50%;
        }
        /* http://stackoverflow.com/questions/1409649/how-to-change-the-height-of-a-br */
        br {
            display: block;
            margin: 4px 0;
        }
        /* http://stackoverflow.com/questions/6046110/styling-form-with-label-above-inputs */
        input, label {
            display: block;
        }
        .ui-tabs .ui-tabs-nav li {height: 32px; font-size:15px; }
        .ui-button .ui-button-text{ line-height: 1.0;}
    </style>
    <script>
        $(function () {
            var tabTitle = $("#tab_title"),
            tabContent = $("#tab_content"),
            tabTemplate = "<li><a href='#{href}'>#{label}</a> <span class='ui-icon ui-icon-close' role='presentation'>Remove Tab</span></li>",
            tabCounter = 2;

            var tabs = $("#tabs").tabs();

            // modal dialog init: custom buttons and a "close" callback resetting the form inside
            var dialog = $("#dialog").dialog({
                autoOpen: false,
                modal: true,
                buttons: {
                    Add: function () {
                        addTab();
                        $(this).dialog("close");
                    },
                    Cancel: function () {
                        $(this).dialog("close");
                    }
                },
                close: function () {
                    $("#form0")[0].reset();
                }
            });

            // addTab form: calls addTab function on submit and closes the dialog
            var form = dialog.find("form").submit(function (event) {
                addTab();
                dialog.dialog("close");
                event.preventDefault();
            });

            // http://handsontable.com/
            var data = [];
            var $container = $("#example");
            $container.handsontable({
                data: data,
                minSpareRows: 1,
                colHeaders: true,
                contextMenu: true
            });
            var handsontable = $container.data('handsontable');

            //$("#fcarrier").val("<%=hdnfcarrier.Value%>");
            //$("#rnumber").val("<%=hdnreferenceno.Value%>");
            //$("#country").val("<%=hdnexpcountry.Value%>");

            if ("<%=hdnDestroyed.Value%>" == "1") {
                $("#exordes").html("Destroyed");
                $("#expordesdate").html("Destruction");
                $("#carorcod").html("Cause of Destruction");
                $("#countrydiv").hide();
            } else {
                $("#exordes").html("Export");
                $("#expordesdate").html("Export");
                $("#carorcod").html("Freight Carrier");
                $("#countrydiv").show();
            }


            // On page.load
            if ($("#<%=hdnlabel.clientid%>").val().length > 0) {
                $("#lbl").html($("#<%=hdnlabel.clientid%>").val());
            }
           
            $.each(selectValues, function (key, value) {
                $('#selsc')
                     .append($('<option>', { value: key })
                     .text(value));
            });
            $("#selsc > option").each(function () {
                var label = this.value.split("|")[0],
                id = "tabs-" + tabCounter,
                li = $(tabTemplate.replace(/#\{href\}/g, "#" + id).replace(/#\{label\}/g, label + '<span id="dpi-' + tabCounter + '" style="color:red;font-weight:bold;font-size:.6em;padding-left:3px;"></span>'));
                var sizecolor = "<input id='sizecolor' type='text' style='display:none;' value='" + label + "' />"
                var tdpp = "<input id='tdpp' type='text' style='display:none;' value='' />";
                var html = "";
                

                $.each(this.value.split("@"), function (index, chunk) {
                    if (chunk != "") {
                        var a;
                      
                        html += "<div id='uafx" + index + "'><span id='uastay" + index + "' style='display:none;'>" + chunk.split("|")[1].toString() + "</span><span id='ua" + index + "'>" + chunk.split("|")[1].toString() + "</span> units at " + chunk.split("|")[2].toString() + " per piece from import date: " + chunk.split("|")[3].toString() + "</div><br />";
                    }
                });
                var expunits = this.value.split("|")[4].split("@")[0] == "0" ? '' : this.value.split("|")[4].split("@")[0];
                tabContentHtml = "<label for='expunits'>Units to Export</label><input id='expunits' type='text' value='" + expunits + "' /> <br />"
                if (expunits != "0") {

                }
                tabContentHtml += "<fieldset style='color:red';font-size:1.4em;font-weight:bold;'><legend> Units Available for export </legend><br />" + html + "</fieldset>";
                tabs.find(".ui-tabs-nav").append(li);
                tabs.append("<div id='" + id + "'  style='font-size:.6em;line-height:.88em;'><p style='padding:2;margin:2;'>" + sizecolor + tdpp + "</p>" + tabContentHtml + "</div>");
                tabs.tabs("refresh");

                tabCounter++;


                var unitstoexport = expunits;
                var total = 0.0;
                $("#selsc > option").each(function () {
                    if (this.value.split("|")[0] == label) {
                        $.each(this.value.split("@"), function (index, value) {
                            if (value.length > 0) {
                                var units = parseInt(value.split("|")[1]);
                                var duty = parseFloat(value.split("|")[2]);
                                total += Math.min(units, unitstoexport) * duty;

                                if (unitstoexport <= units) {
                                    return false;
                                }
                                unitstoexport -= units;
                            }

                        });



                    }
                });
                $("#dpi-" + id.match(/\d+$/)).html('(' + total.toFixed(2) + ')');
                $("#" + id).find("#tdpp").val(total.toFixed(2));

                var UnitsToExport = parseInt($("#" + id).find("#expunits").val()) || 0;
                var oUTE = UnitsToExport;
                $("#" + id).find("[id^=uafx]").each(function (index) {
                    var uastay = parseInt($("#" + id).find("#uastay" + index).text());
                    var res = uastay - UnitsToExport;
                    $("#" + id).find("#ua" + index).text(res >= 0 ? res : 0);
                    UnitsToExport = res >= 0 ? 0 : Math.abs(res);
                });

                $("#" + id).find("#expunits").bind("propertychange keyup input paste", function (event) {

                    var elem = $(this);
                    var unitstoexport = parseInt(elem.val()) || 0;
                    var total = 0.0;


                    $("#selsc > option").each(function () {
                        if (this.value.split("|")[0] == label) {

                            $.each(this.value.split("@"), function (index, value) {
                                if (value.length > 0) {
                                    var units = parseInt(value.split("|")[1]);
                                    var duty = parseFloat(value.split("|")[2]);
                                    total += Math.min(units, unitstoexport) * duty;

                                    if (unitstoexport <= units) {
                                        return false;
                                    }
                                    unitstoexport -= units;
                                }

                            });



                        }
                    });
                    $("#dpi-" + id.match(/\d+$/)).html('(' + total.toFixed(2) + ')');
                    $("#" + id).find("#tdpp").val(total.toFixed(2));
                    var UnitsToExport = parseInt($("#" + id).find("#expunits").val()) || 0;
                    var oUTE = UnitsToExport;
                    $("#" + id).find("[id^=uafx]").each(function (index) {
                        var uastay = parseInt($("#" + id).find("#uastay" + index).text());
                        var res = uastay - UnitsToExport;
                        $("#" + id).find("#ua" + index).text(res >= 0 ? res : 0);
                        UnitsToExport = res >= 0 ? 0 : Math.abs(res);
                        
                       
                    });



                });

            });

            $("#tabs").tabs({ active: 0 });
            $(document).ready(function () {
                $("#tabs").tabs({
                    activate: function (event, ui) {
                        $("#lbl").hide();
                    }
                });
            });
            // actual addTab function: adds new tab using the input from the form above
            function addTab() {
                var label = $("#selsc :selected").text() ,
                id = "tabs-" + tabCounter,
                li = $(tabTemplate.replace(/#\{href\}/g, "#" + id).replace(/#\{label\}/g, label + '<span id="dpi-' + tabCounter + '" style="color:red;font-weight:bold;font-size:.6em;padding-left:3px;">(0.00)</span>'));
                //tabContentHtml = tabContent.val() || "Tab " + tabCounter + " content.";
                var sizecolor = "<input id='sizecolor' type='text' style='display:none;' value='" + label + "' />"
                var tdpp = "<input id='tdpp' type='text' style='display:none;' value='' />";
                var html="";
                $.each($("#selsc").val().split("@"), function (index, chunk) {
                    if (chunk != "") {
                        html += "<div id='uafx" + index + "'><span id='uastay" + index + "' style='display:none;'>" + chunk.split("|")[1].toString() + "</span><span id='ua" + index + "'>" + chunk.split("|")[1].toString() + "</span> units at " + chunk.split("|")[2].toString() + " per piece from import date: " + chunk.split("|")[3].toString() + "</div><br />";
                    }
                });
                
                tabContentHtml = "<label for='expunits'>Units to Export</label><input id='expunits' type='text' /> <br /><fieldset style='color:red';font-size:1.4em;font-weight:bold;height:250px;'><legend> Units Available for export </legend><br />" + html + "</fieldset>";
                tabs.find(".ui-tabs-nav").append(li);
                tabs.append("<div id='" + id + "'  style='font-size:.6em;line-height:.88em;'><p style='padding:2;margin:2;'>" + sizecolor + tdpp + "</p>" + tabContentHtml + "</div>");  
                tabs.tabs("refresh");
                
                tabCounter++;
                //$("#selsc option[value='" + $("#selsc").val() + "']").remove();

                $("#" + id).find("#expunits").bind("propertychange keyup input paste", function (event) {
                    
                    var elem = $(this);
                    var unitstoexport = parseInt(elem.val()) || 0;
                    var total = 0.0;
                    
                   
                    $("#selsc > option").each(function() {
                        if (this.value.split("|")[0] == label) {

                            $.each(this.value.split("@"), function (index, value) {
                                if (value.length > 0) {
                                    var units = parseInt(value.split("|")[1]);
                                    var duty = parseFloat(value.split("|")[2]);
                                    total += Math.min(units, unitstoexport) * duty;

                                    if (unitstoexport <= units) {
                                        return false;
                                    }
                                    unitstoexport -= units;
                                }
                                
                            });
                           
                            
                            
                        }
                    });
                    $("#dpi-" + id.substring(id.length - 1)).html('(' + total.toFixed(2) + ')');
                    $("#" + id).find("#tdpp").val(total.toFixed(2));
                    var UnitsToExport = parseInt($("#" + id).find("#expunits").val()) || 0;
                    var oUTE = UnitsToExport;
                    $("#" + id).find("[id^=uafx]").each(function (index) {
                        var uastay = parseInt($("#uastay" + index).text());
                        var res = UnitsToExport - uastay;
                        if (res >= 0) {

                            $("#" + id).find("#ua" + index).text('0');
                            UnitsToExport = res;
                        } else {
                            $("#" + id).find("#ua" + index).text(Math.abs(res));
                            UnitsToExport -= oUTE;
                        }
                    });
                                   
                });

                var z = parseInt(tabCounter -3) ;
                $("#tabs").tabs({ active: z });
            }

            // update click
            $("#updatebtn").click(function () {
                $("#updatebtn").prop("disabled", true);
                $("#lbl").html('');
                var data = $("#<%= hdnCompany.ClientID%>").val() + "|" + $("#<%= hdnStyle.ClientID%>").val() + "|" + $("#<%= fcarrier.ClientID%>").val() + "|" + $("#<%= rnumber.ClientID%>").val() + "|" + $("#<%= country.ClientID%>").val() + "|" + $("#<%= exportdate.ClientID%>").val() + "|" + $("#<%= invoicenumber.ClientID%>").val() + "|" + $("#<%= hdnDestroyed.ClientID%>").val();
                $("#tabs").find("input[type=text]").each(function () {
                    var elem = $(this);
                    data = data + "|" + elem.val();
                });
                urlToHandler = 'export.ashx';
                jsonData = data;
                $.ajax({
                    url: urlToHandler,
                    data: jsonData,
                    dataType: 'json',
                    type: 'POST',
                    contentType: 'application/json',
                    success: function (data) {                        
                        $("#lbl").html(data.response);
                        $("#lbl").show();
                        $("#updatebtn").prop("disabled", false);
                        var result = [];

                        a = data.thedata.split('|');
                        while (a[0]) {
                            result.push(a.splice(0, 12));
                        }
                                            
                        handsontable.loadData(result);
                        $("#btnsubmit").show();
                        //setAutocompleteData(data.response);
                    },
                    error: function (data, status, jqXHR) {
                        alert('There was an error.');
                        $("#updatebtn").prop("disabled", false);
                    }
                }); // end $.ajax
                
            });
            $("#btnsubmit").click(function () {                
                urlToHandler = 'getdrawbacks.ashx?company='+ $("#<%= hdnCompany.ClientID%>").val();
                $.ajax({
                    url: urlToHandler,
                    data: '',
                    dataType: 'json',
                    type: 'POST',
                    contentType: 'application/json',
                    success: function (data) {
                        var filerno = data.filerno.trim();
                        var filercode = data.filercode.trim();
                        var str = "<select id='dbselect'>";
                        var array = data.response.split("|");
                        $.each(array, function (i) {
                            str += '<option value=' + array[i] + '>' + array[i] + '</option>';
                        });
                        $.magnificPopup.open({
                            items: {
                                src: $('<div class="white-popup">' +                                    
                                    '<h4>Choose Drawback #</h4>' +
                                    str +
                                    '<input type="button" id="chosedrn" value="Submit">' +
                                    '<input type="button" onclick="$.magnificPopup.close();" value="Cancel">' +
                                    '<input type="button" id="generatenew" value="Generate New Number">' +
                                    '<div id="errors" style="position:relative;top:340px;"></div>' +
                                    '</div>')
                            },
                            type: 'inline',
                            closeBtnInside: true

                            // You may add options here, they're exactly the same as for $.fn.magnificPopup call
                            // Note that some settings that rely on click event (like disableOn or midClick) will not work here
                        }, 0);
                        //setAutocompleteData(data.response);
                        $('#chosedrn').click(function () {                            
                            urlToHandler = 'updatedrawbacknumber.ashx?company=' + $("#<%= hdnCompany.ClientID%>").val() + '&style=' + $("#<%= hdnStyle.ClientID%>").val() + '&exportdate=' + $("#<%= hdnExportDate.ClientID%>").val() + '&drawbacknumber=' + $("#dbselect").val();
                            jsonData = data;
                            $.ajax({
                                url: urlToHandler,
                                data: jsonData,
                                dataType: 'json',
                                type: 'POST',
                                contentType: 'application/json',
                                success: function (data) {
                                    $("#updatebtn").trigger("click");
                                    $.magnificPopup.close();
                                    //setAutocompleteData(data.response);
                                },
                                error: function (data, status, jqXHR) {
                                    alert('There was an error.');
                                }
                            }); // end $.ajax
                        });
                        $('#generatenew').click(function () {
                            function pad (str, max) {
                                str = str.toString();
                                return str.length < max ? pad("0" + str, max) : str;
                            }
                            var ldn = $('#dbselect option:last-child').val(); // last drawback number
                            var enc = ""; //entry number count
                            if (ldn.length > 0) {
                                enc = (parseInt(ldn.slice(3, 10)) + 1).toString();
                            }
                            var cd; // check digit                            
                            var dn = filerno + pad(enc, 7);
                            var sum = 0;
                            $.each(dn.split('').reverse(), function (i, v) {
                                if ((i + 1) % 2 == 1) {
                                    res = parseInt(v) * 2;
                                    if (res >= 10) {
                                        sum += (res + 1) % 10;
                                    } else {
                                        sum += res;
                                    }
                                } else {
                                    sum += parseInt(v);
                                }
                            });                            
                            sum = 10 - ((sum % 10) == 0 ? 10 : (sum % 10));
                            dn = filercode + pad(enc, 7) + sum.toString();
                            //dn = dn + sum.toString();
                            $("#dbselect")
                                .append($('<option>', { value: dn })
                                .text(dn));
                            $("#dbselect").val(dn);
                            $("#chosedrn").trigger("click");
                        });
                    },
                    error: function (data, status, jqXHR) {
                        alert('There was an error.');
                        $("#updatebtn").prop("disabled", false);
                    }
                }); // end $.ajax
                
            });

            // addTab button: just opens the dialog
            $("#add_tab")
            .click(function () {
                dialog.dialog("open");
                return false;
            });

            // close icon: removing the tab on click
            tabs.delegate("span.ui-icon-close", "click", function () {
                var sizecolor = $(this).prev('a').text().split("(")[0];
                
                if (confirm("Are you sure you want to delete " + sizecolor + "?")) {
                    var data = $("#<%= hdnCompany.ClientID%>").val() + "|" + $("#<%= hdnStyle.ClientID%>").val() + "|" + $("#<%= hdnExportDate.ClientID%>").val() + "|" + sizecolor;
                    urlToHandler = 'delexport.ashx';
                    jsonData = data;
                    $.ajax({
                        url: urlToHandler,
                        data: jsonData,
                        dataType: 'json',
                        type: 'POST',
                        contentType: 'application/json',
                        success: function (data) {
                            $("#lbl").html(data.response);

                            //setAutocompleteData(data.response);
                        },
                        error: function (data, status, jqXHR) {
                            alert('There was an error.');
                        }
                    }); // end $.ajax
                    var panelId = $(this).closest("li").remove().attr("aria-controls");
                    $("#" + panelId).remove();
                    tabs.tabs("refresh");
                    tabCounter--;
                }
            });

            tabs.bind("keyup", function (event) {
                if (event.altKey && event.keyCode === $.ui.keyCode.BACKSPACE) {
                    var panelId = tabs.find(".ui-tabs-active").remove().attr("aria-controls");
                    $("#" + panelId).remove();
                    tabs.tabs("refresh");
                }
            });

        });
    </script>
    <script>
        /*<![CDATA[*/
        $(document).ready(function () {
            //$('#embedURL2').gdocsViewer();
            // $("#embed").attr("src", "http://www.edrawbacks.com/pdf.pdf?rand=" + Math.floor(Math.random() * 100001));
            $("#embedtd").replaceWith("<td id='embedtd'><iframe id='embed' src='http://docs.google.com/gview?url=" + 'http://www.edrawback.com/docroot/' + '<%= hdnCompany.Value%>' + '/' + '<%= hdnStyle.Value%>' + '/' + '<%= exportdate.Text%>' + ' Export/' + ($("[id*='ddlinfoimport'] :selected").text()).toString().trim() + "&embedded=true' width='100%' height='780' type='application/pdf'></td>");
            $("#ddlinfoimport").change(function () {
                $("#embedtd").replaceWith("<td id='embedtd'><iframe id='embed' src='http://docs.google.com/gview?url=" + 'http://www.edrawback.com/docroot/' + '<%= hdnCompany.Value%>' + '/' + '<%= hdnStyle.Value%>' + '/' + '<%= exportdate.Text%>' + ' Export/' + ($("[id*='ddlinfoimport'] :selected").text()).toString().trim() + "&embedded=true' width='100%' height='780' type='application/pdf'></td>");
            });



        });
        /*]]>*/


    </script>
</head>
<body>
    <table width="100%">
        <tr style="background-color: #0924BC; height: 12px">
            <td colspan="2" style="color: White; font-weight: bold; font-size: 1.2em; padding: 3px"
                align="center"><span id='exordes'>Export</span> Information Page 
            </td>
        </tr>
    </table>
    
     <div id="dialog" title="Size / Color">
            <form id="form0">
                <fieldset class="ui-helper-reset">
                    <legend></legend>
                    <label for="tab_title">Size/Color</label>

                    <select id="selsc" style="font-size:20px;">
                        
                    </select>
                </fieldset>
            </form>
        </div>
    <form runat="server" id="form1">
       
        <div class="leftside">

            <table width="100%" style="width: 100%; height: 100%;" cellpadding="0" cellspacing="5">

                <tr style="height: 15px;">
                    <td>
                        <asp:DropDownList runat="server" ID="ddlinfoimport"  ></asp:DropDownList>
                    </td>

                </tr>
                <tr>
                    <td id="embedtd" style="vertical-align: top;">

<%--                         <embed id="embed" src="http://www.edrawbacks.com/pdf.pdf" width="600" height="480" type="application/pdf">--%>
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
                    <legend>Style Number</legend>
                    <asp:Label Font-Size="2em" runat="server" ID="LblStyle"></asp:Label>
                </fieldset>
            </div>
           
            <div style="float: left; padding-right:80px;">
                <button type="button" value="Update" id="updatebtn">SAVE</button>
                <%--<button type="button" value="Update" onclick="javascript:history.go(-1)">BACK</button>--%>
                <br />
                 <label style="color: red; font-weight: bold; font-size: 1.2em;" id="lbl"></label>
            </div>
            

            <br />
            <div style="float: left">

                <div style='font-size: .8em;'>
                    <div style="float: left;">
                        <label for="s7501" style="width:100px;word-wrap: break-word;"><span id='carorcod'>Freight Carrier</span></label>
                        <asp:textbox runat="server"  id="fcarrier" style="width: 80px;" />
                    </div>
                    <div style="float: left;">
                        <label for="rnumber" style="width:100px;word-wrap: break-word;">Reference #</label>
                        <asp:textbox runat="server"  id="rnumber" style="width: 110px;" />
                    </div>
                    <div id="countrydiv" style="float: left;">
                        <label for="country" style="width:100px;word-wrap: break-word;">Export Country</label>
                        <asp:textbox runat="server"  id="country" style="width: 80px;" />
                    </div>
                    <div style="float: left;width:100px;word-wrap: break-word; ">
                        <label for="importdate"><span id='expordesdate'>Export</span> Date</label>
                        <asp:textbox runat="server" ReadOnly="true"  id="exportdate" style="width: 80px;" />
                    </div>
                    <div style="float:left;width:100px;word-wrap: break-word; ">
                        <label for="invoicenumber">Unique ID #</label>
                        <asp:TextBox runat="server" ID="invoicenumber" style="width: 80px;" />
                    </div>
                   
                </div>
            </div>

            <div style="clear: both; height: 10px;"></div>
            <button id="add_tab" style="display:none;">Add Size/Color</button>

            <div id="tabs">
                <ul>
                </ul>
                <div id="tabs-1">
                </div>
            </div>
            <div class="handsontable" id="example"></div>
            <input type="button" value="Create/Add Drawback" id="btnsubmit" style="display:none;" />
            <asp:HiddenField ID="hdnCompany" runat="server" />
            <asp:HiddenField ID="hdnFull" runat="server" />
            <asp:HiddenField ID="hdnStatus" runat="server" />
            <asp:HiddenField ID="hdnExportDate" runat="server" />
            <asp:HiddenField ID="hdnStyle" runat="server" />
            <asp:HiddenField ID="hdnlabel" runat="server" />
            <asp:HiddenField ID="hdnfcarrier" runat="server" />
            <asp:HiddenField ID="hdnreferenceno" runat="server" />
            <asp:HiddenField ID="hdnexpcountry" runat="server" />
            <asp:HiddenField ID="hdnDestroyed" runat="server" />

        </div>
    </form>
</body>
</html>



