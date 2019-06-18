<%@ Page Language="VB" AutoEventWireup="false" CodeFile="Import.aspx.vb" Inherits="PA" %>

<!-- Revised from demo code on http://jqueryui.com/ -->
<!doctype html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <title>Import Information Page</title>
    
    <script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jquery/1.11.1/jquery.min.js"></script>
    <script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jqueryui/1.10.4/jquery-ui.min.js"></script>
    <link type="text/css" href="http://ajax.googleapis.com/ajax/libs/jqueryui/1.10.4/themes/smoothness/jquery-ui.css" rel="stylesheet" />
<%--    <script src="Scripts/jquery.gdocsviewer.js" type="text/javascript"></script>--%>
    <style>
        body {
            width: 95%;
            height:500px;
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
                    form[0].reset();
                }
            });

            // addTab form: calls addTab function on submit and closes the dialog
            var form = dialog.find("form").submit(function (event) {
                addTab();
                dialog.dialog("close");
                event.preventDefault();
            });
            tabContentHtml = "<div id='forcopy'><div style='float:left;margin-right:10px;><label for='units'>Units</label> <input id='units' type='text' style='width:90px;padding:2px;' /></div><div style='float:left;margin-right:10px;><label for='unitstype'>Type</label> <input id='unitstype' type='text' style='width:40px;padding:2px;' /></div><div style='float:left;margin-right:10px;><label for='line'>Line #</label> <input id='line' type='text' style='width:40px;padding:2px;' /></div><div style='float:left;margin-right:10px;><label for='price'>Total Value Per Piece</label> <input id='price' type='text' disabled style='width:90px;padding:2px;' /></div><div style='clear:both;'></div>" +
                    "<fieldset><legend>Tarrif 1</legend>" +
                    "<div style='float:left;margin-right:10px;><label for='Tarrif1'>Tarrif Code</label> <input id='Tarrif1' type='text' style='width:80px;padding:2px;' /></div> " +
                    "<div style='float:left;margin-right:10px;><label for='Description1'>Description</label> <input id='Description1' type='text' style='width:90px;padding:2px;' /></div>  " +
                    "<div style='float:left;margin-right:10px;><label for='Perc_Rate1'>Percent Rate</label> <input id='Perc_Rate1' type='text' style='width:60px;padding:2px;' /></div>  " +
                    "<div style='float:left;margin-right:10px;><label for='Piece_Rate1'>Piece Rate</label> <input id='Piece_Rate1' type='text' style='width:60px;padding:2px;' /></div>  " +
                    "<div style='float:left;margin-right:10px;><label for='TValue1'>Value</label> <input id='TValue1' type='text' style='width:60px;padding:2px;' /></div><br /><br /></fieldset> " +                    
                    "<fieldset><legend>Tarrif 2</legend>" +
                    "<div style='float:left;margin-right:10px;><label for='Tarrif2'>Tarrif Code</label> <input id='Tarrif2' type='text' style='width:80px;padding:2px;' /></div> " +
                    "<div style='float:left;margin-right:10px;><label for='Description2'>Description</label> <input id='Description2' type='text' style='width:90px;padding:2px;' /></div> " +
                    "<div style='float:left;margin-right:10px;><label for='Perc_Rate2'>Percent Rate</label> <input id='Perc_Rate2' type='text' style='width:60px;padding:2px;' /></div> " +
                    "<div style='float:left;margin-right:10px;><label for='Piece_Rate2'>Piece Rate</label> <input id='Piece_Rate2' type='text' style='width:60px;padding:2px;' /></div>" +
                    "<div style='float:left;margin-right:10px;><label for='TValue2'>Value</label> <input id='TValue2' type='text' style='width:60px;padding:2px;' /></div><br /><br /></fieldset> " +
                    "<fieldset><legend>Tarrif 3</legend>" +
                    "<div style='float:left;margin-right:10px;><label for='Tarrif3'>Tarrif Code</label> <input id='Tarrif3' type='text' style='width:80px;padding:2px;' /></div> " +
                    "<div style='float:left;margin-right:10px;><label for='Description3'>Description</label> <input id='Description3' type='text' style='width:90px;padding:2px;' /></div> " +
                    "<div style='float:left;margin-right:10px;><label for='Perc_Rate3'>Percent Rate</label> <input id='Perc_Rate3' type='text' style='width:60px;padding:2px;' /></div> " +
                    "<div style='float:left;margin-right:10px;><label for='Piece_Rate3'>Piece Rate</label> <input id='Piece_Rate3' type='text' style='width:60px;padding:2px;' /> </div>" +
                    "<div style='float:left;margin-right:10px;><label for='TValue3'>Value</label> <input id='TValue3' type='text' style='width:60px;padding:2px;' /></div><br /><br /></fieldset> " +
                    "<fieldset><legend>Tarrif 4</legend>" +
                    "<div style='float:left;margin-right:10px;><label for='Tarrif4'>Tarrif Code</label> <input id='Tarrif4' type='text' style='width:80px;padding:2px;' /> </div>" +
                    "<div style='float:left;margin-right:10px;><label for='Description4'>Description</label> <input id='Description4' type='text' style='width:90px;padding:2px;' /></div> " +
                    "<div style='float:left;margin-right:10px;><label for='Perc_Rate4'>Percent Rate</label> <input id='Perc_Rate4' type='text' style='width:60px;padding:2px;' /></div> " +
                    "<div style='float:left;margin-right:10px;><label for='Piece_Rate4'>Piece Rate</label> <input id='Piece_Rate4' type='text' style='width:60px;padding:2px;' /></div> " +
                    "<div style='float:left;margin-right:10px;><label for='TValue4'>Value</label> <input id='TValue4' type='text' style='width:60px;padding:2px;' /></div><br /><br /></fieldset> " 
            // On page.load
            $("#mpf").on("blur", function (event) {
                if (($("#mpf").val() < 25 || $("#mpf").val() > 485) && $("#mpf").val() != 0) {
                    alert('MPF needs to be between 25 and 485!');
                    setTimeout(function () {
                        $("#mpf").focus();
                    }, 0);
                }
            });
            $("#country").on("blur", function (event) {
                if ($("#country").val().length != 2 && $("#country").val().length > 0) {
                    alert('Country of Origin needs to be 2 letters!');
                    setTimeout(function () {
                        $("#country").focus();
                    }, 0);
                }
            });
            $("#portcode").on("blur", function (event) {
                if ($("#portcode").val().length != 4 && $("#portcode").val().length > 0) {
                    alert('Port Code needs to be 4 characters!');
                    setTimeout(function () {
                        $("#portcode").focus();
                    }, 0);
                }
            });
            $("#s7501").on("blur", function (event) {
                if ($("#s7501").val().length != 11 && $("#s7501").val().length > 0) {
                    alert('7501 needs to be 11 characters!');
                    setTimeout(function () {
                        $("#s7501").focus();
                    }, 0);
                } else {
                    urlToHandler = 'find7501.ashx';
                    jsonData = $("#s7501").val();
                    $.ajax({
                        url: urlToHandler,
                        data: jsonData,
                        dataType: 'json',
                        type: 'POST',
                        contentType: 'application/json',
                        success: function (data) {
                            var a = data.response;
                            if (a.split('|').length > 1) {

                                $("#portcode").val(a.split('|')[0]);
                                $("#country").val(a.split('|')[1]);
                                $("#conversion").val(a.split('|')[2]);
                                $("#totalval").val(a.split('|')[3]);
                                $("#hmf").val(a.split('|')[4]);
                                $("#mpf").val(a.split('|')[5]);
                            }
                        },
                        error: function (data, status, jqXHR) {
                            alert('There was an error.');
                        }
                    }); // end $.ajax
                }
                    
                });
            
            $(a).each(function (index) {
                var label = a[index] || "",
                id = "tabs-" + tabCounter,
                li = $(tabTemplate.replace(/#\{href\}/g, "#" + id).replace(/#\{label\}/g, label + '<span id="dpi-' + tabCounter + '" style="color:red;font-weight:bold;font-size:.6em;padding-left:3px;"></span>'));
                //tabContentHtml = tabContent.val() || "Tab " + tabCounter + " content.";

                tabs.find(".ui-tabs-nav").append(li);
                var sizecolor = "<input id='size' type='text' style='display:none;' value='" + a[index] + "' />";
                var tdpp = "<input id='tdpp' type='text' style='display:none;' value='' />";
                tabs.append("<div id='" + id + "' style='font-size:.6em;line-height:.88em;'><p style='padding:2;margin:2;'>" + sizecolor + tdpp +  "</p>"  + b[index] + "</div>");
                tabs.tabs("refresh");
                tabCounter++;
                
                $("#" + id).find("input[type=text]").each(function () {
                    var elem = $(this);

                    
                    var num = elem.attr('id').substr(elem.attr('id').length - 1);
                    if (elem.attr('id') == 'Tarrif' + num) {
                        elem.bind("blur", function (event) {
                            if (elem.val().length != 10 && elem.val().length > 0) {
                                alert('Tarrif Code needs to be 10 characters!');
                                setTimeout(function () {
                                    elem.focus();
                                }, 0);
                            } else {
                                urlToHandler = 'findtarrif.ashx';
                                jsonData = elem.val();
                                $.ajax({
                                    url: urlToHandler,
                                    data: jsonData,
                                    dataType: 'json',
                                    type: 'POST',
                                    contentType: 'application/json',
                                    success: function (data) {
                                        if (data.response.split("|").length == 1) {
                                            $("#lbl").html(data.response);
                                        } else {
                                            $("#" + id).find("#Description" + num).val(data.response.split("|")[0]);
                                            $("#" + id).find("#Perc_Rate" + num).val(data.response.split("|")[1]);
                                            $("#" + id).find("#Piece_Rate" + num).val(data.response.split("|")[2]);
                                        }

                                        if (data.response2.length > 0) {
                                            var a = data.response2.split('|');
                                            var i = 1;

                                            while (a[0]) {
                                                var b = a.splice(0, 5);
                                                $("#" + id).find("#Tarrif" + (parseInt(num) + i).toString()).val(b[0]);
                                                $("#" + id).find("#Description" + (parseInt(num) + i).toString()).val(b[1]);
                                                $("#" + id).find("#Perc_Rate" + (parseInt(num) + i).toString()).val(b[2]);
                                                $("#" + id).find("#Piece_Rate" + (parseInt(num) + i).toString()).val(b[3]);
                                                i++;
                                            }
                                        }
                                        //
                                        //setAutocompleteData(data.response);
                                    },
                                    error: function (data, status, jqXHR) {
                                        alert('There was an error.');
                                    }
                                }); // end $.ajax
                            }
                            
                        });
                    }

                    elem.data('oldVal', elem.val());
                    // Look for changes in the value
                    elem.bind("propertychange keyup input paste", function (event) {
                        // If value has changed...
                        if (elem.data('oldVal') != elem.val()) {
                            // Updated stored value
                            elem.data('oldVal', elem.val());

                            
                            // Do action
                            //....
                            var Perc_Rate1 = 0, Piece_Rate = 0, TValue = 0;
                            var Perc_Rate2 = 0.0, Piece_Rate2 = 0.0, TValue2 = 0.0;
                            var Perc_Rate3 = 0.0, Piece_Rate3 = 0.0, TValue3 = 0.0;
                            var Perc_Rate4 = 0.0, Piece_Rate4 = 0.0, TValue4 = 0.0;
                            var pp1 = 0.0, pp2 = 0.0, pp3 = 0.0, pp4 = 0.0, tot = 0.0;


                            $("#" + id).find("input[type=text]").each(function () {
                                var elem = $(this);
                                if (elem.attr('id') == 'Perc_Rate1') {
                                    Perc_Rate1 = parseFloat(elem.val() || 0.0);
                                } else if (elem.attr('id') == 'Piece_Rate1') {
                                    Piece_Rate = parseFloat(elem.val() || 0.0);
                                } else if (elem.attr('id') == 'TValue1') {
                                    TValue = parseFloat(elem.val() || 0.0);
                                } if (elem.attr('id') == 'Perc_Rate2') {
                                    Perc_Rate2 = parseFloat(elem.val() || 0.0);
                                } else if (elem.attr('id') == 'Piece_Rate2') {
                                    Piece_Rate2 = parseFloat(elem.val() || 0.0);
                                } else if (elem.attr('id') == 'TValue2') {
                                    TValue2 = parseFloat(elem.val() || 0.0);
                                } else if (elem.attr('id') == 'Perc_Rate3') {
                                    Perc_Rate3 = parseFloat(elem.val() || 0.0);
                                } else if (elem.attr('id') == 'Piece_Rate3') {
                                    Piece_Rate3 = parseFloat(elem.val() || 0.0);
                                } else if (elem.attr('id') == 'TValue3') {
                                    TValue3 = parseFloat(elem.val() || 0.0);
                                } else if (elem.attr('id') == 'Perc_Rate4') {
                                    Perc_Rate4 = parseFloat(elem.val() || 0.0);
                                } else if (elem.attr('id') == 'Piece_Rate4') {
                                    Piece_Rate4 = parseFloat(elem.val() || 0.0);
                                } else if (elem.attr('id') == 'TValue4') {
                                    TValue4 = parseFloat(elem.val() || 0.0);
                                }
                            });
                            pp1 = ((Perc_Rate1 / 100) * TValue) + Piece_Rate ;
                            pp2 = ((Perc_Rate2 / 100) * TValue2) + Piece_Rate2 ;
                            pp3 = ((Perc_Rate3 / 100) * TValue3) + Piece_Rate3 ;
                            pp4 = ((Perc_Rate4 / 100) * TValue4) + Piece_Rate4 ;
                            tot = (parseFloat(pp1) + parseFloat(pp2) + parseFloat(pp3) + parseFloat(pp4));
                            $("#dpi-" + id.match(/\d+/)).html('(' + tot.toFixed(2) + ')');
                            $("#" + id).find("#tdpp").val(tot.toFixed(2));
                            $("#" + id).find("#price").val((TValue + TValue2 + TValue3 + TValue4).toFixed(2));
                        }
                    });
                    
                });
            });
            // Initialize the Duty Per Piece 
            
            for (var i = 0; i < tabCounter; i++) {

                var Perc_Rate1 = 0.0, Piece_Rate = 0.0,   TValue = 0.0;
                var Perc_Rate2 = 0.0, Piece_Rate2 = 0.0,  TValue2 = 0.0;
                var Perc_Rate3 = 0.0, Piece_Rate3 = 0.0,  TValue3 = 0.0;
                var Perc_Rate4 = 0.0, Piece_Rate4 = 0.0,  TValue4 = 0.0;
                var pp1 = 0.0, pp2 = 0.0, pp3 = 0.0, pp4 = 0.0, tot = 0.0;
                $("#tabs-" + i).find("input[type=text]").each(function () {
                    var elem = $(this);
                    if (elem.attr('id') == 'Perc_Rate1') {
                        Perc_Rate1 = parseFloat(elem.val() || 0.0);
                    } else if (elem.attr('id') == 'Piece_Rate1') {
                        Piece_Rate = parseFloat(elem.val() || 0.0);
                    } else if (elem.attr('id') == 'TValue1') {
                        TValue = parseFloat(elem.val() || 0.0);
                    } if (elem.attr('id') == 'Perc_Rate2') {
                        Perc_Rate2 = parseFloat(elem.val() || 0.0);
                    } else if (elem.attr('id') == 'Piece_Rate2') {
                        Piece_Rate2 = parseFloat(elem.val() || 0.0);
                    } else if (elem.attr('id') == 'TValue2') {
                        TValue2 = parseFloat(elem.val() || 0.0);
                    } else if (elem.attr('id') == 'Perc_Rate3') {
                        Perc_Rate3 = parseFloat(elem.val() || 0.0);
                    } else if (elem.attr('id') == 'Piece_Rate3') {
                        Piece_Rate3 = parseFloat(elem.val() || 0.0);
                    } else if (elem.attr('id') == 'TValue3') {
                        TValue3 = parseFloat(elem.val() || 0.0);
                    } else if (elem.attr('id') == 'Perc_Rate4') {
                        Perc_Rate4 = parseFloat(elem.val() || 0.0);
                    } else if (elem.attr('id') == 'Piece_Rate4') {
                        Piece_Rate4 = parseFloat(elem.val() || 0.0);
                    } else if (elem.attr('id') == 'TValue4') {
                        TValue4 = parseFloat(elem.val() || 0.0);
                    }
                });
               
                pp1 = ((Perc_Rate1 / 100) * TValue) + Piece_Rate   ;
                pp2 = ((Perc_Rate2 / 100) * TValue2) + Piece_Rate2 ;
                pp3 = ((Perc_Rate3 / 100) * TValue3) + Piece_Rate3 ;
                pp4 = ((Perc_Rate4 / 100) * TValue4) + Piece_Rate4 ;
                tot = (parseFloat(pp1) + parseFloat(pp2) + parseFloat(pp3) + parseFloat(pp4));

                $("#dpi-" + i).html('(' + tot.toFixed(2) + ')');
                $("#tabs-" + i).find("#tdpp").val(tot.toFixed(2));
                $("#tabs-" + i).find("#price").val((TValue + TValue2 + TValue3 + TValue4).toFixed(2));
            }
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
                var label = tabTitle.val() + tabContent.val() || "",
                id = "tabs-" + tabCounter,
                li = $(tabTemplate.replace(/#\{href\}/g, "#" + id).replace(/#\{label\}/g, label + '<span id="dpi-' + tabCounter + '" style="color:red;font-weight:bold;font-size:.6em;padding-left:3px;">' + $('#dpi-2').text() +  '</span>'));
                //tabContentHtml = tabContent.val() || "Tab " + tabCounter + " content.";
                var sizecolor = "<input id='size' type='text' style='display:none;' value='" + label + "' />";
                var tdpp = "<input id='tdpp' type='text' style='display:none;' value='" + $('#tdpp').val() + "' />";
                tabs.find(".ui-tabs-nav").append(li);

               
                if ($("#forcopy").length > 0) {
                    $("#forcopy input").each(function () {
                        $(this).attr("value", $(this).val());
                    });
                    tabContentHtml = $("#forcopy").html();
                   
                } 
                tabs.append("<div id='" + id + "'  style='font-size:.6em;line-height:.88em;'><p style='padding:2;margin:2;'>" + sizecolor + tdpp + "</p>" + tabContentHtml + "</div>");
                tabs.tabs("refresh");
                

                //$("#" + id).find("input[type=text]").each(function () {
                //    var elem = $(this);
                //    var oldelem = $("#tabs-" + tabCounter - 1).find(elem.attr('id'));
                //    elem.val(oldelem.val());
                   
                //});
                $("#" + id).find("#units").text('');
                tabCounter++;

                $("#" + id).find("input[type=text]").each(function () {
                    var elem = $(this);
                    var num = elem.attr('id').substr(elem.attr('id').length - 1);
                    if (elem.attr('id') == 'Tarrif' + num) {
                        elem.bind("blur", function (event) {
                            if (elem.val().length != 10 && elem.val().length > 0) {
                                alert('Tarrif Code needs to be 10 characters!');
                                setTimeout(function () {
                                    elem.focus();
                                }, 0);
                            } else {
                                urlToHandler = 'findtarrif.ashx';
                                jsonData = elem.val();
                                $.ajax({
                                    url: urlToHandler,
                                    data: jsonData,
                                    dataType: 'json',
                                    type: 'POST',
                                    contentType: 'application/json',
                                    success: function (data) {
                                        if (data.response.split("|").length == 1) {
                                            $("#lbl").html(data.response);
                                        } else {
                                            $("#" + id).find("#Description" + num).val(data.response.split("|")[0]);
                                            $("#" + id).find("#Perc_Rate" + num).val(data.response.split("|")[1]);
                                            $("#" + id).find("#Piece_Rate" + num).val(data.response.split("|")[2]);
                                        }
                                        if (data.response2.length > 0) {
                                            var a = data.response2.split('|');
                                            var i = 1;

                                            while (a[0]) {
                                                var b = a.splice(0, 5);
                                                $("#" + id).find("#Tarrif" + (parseInt(num) + i).toString()).val(b[0]);
                                                $("#" + id).find("#Description" + (parseInt(num) + i).toString()).val(b[1]);
                                                $("#" + id).find("#Perc_Rate" + (parseInt(num) + i).toString()).val(b[2]);
                                                $("#" + id).find("#Piece_Rate" + (parseInt(num) + i).toString()).val(b[3]);
                                                i++;
                                            }
                                        }
                                        //
                                        //setAutocompleteData(data.response);
                                    },
                                    error: function (data, status, jqXHR) {
                                        alert('There was an error.');
                                    }
                                }); // end $.ajax
                            }
                            
                        });
                    }
                    
                    elem.data('oldVal', elem.val());
                    // Look for changes in the value
                    elem.bind("propertychange keyup input paste blur", function (event) {
                        // If value has changed...
                        if (elem.data('oldVal') != elem.val()) {
                            // Updated stored value
                            elem.data('oldVal', elem.val());
                            
                            
                            // Do action
                            //....
                            var Perc_Rate1=0.0, Piece_Rate1=0.0, TValue1=0.0;
                            var Perc_Rate2 = 0.0, Piece_Rate2 = 0.0, TValue2 = 0.0;
                            var Perc_Rate3 = 0.0, Piece_Rate3 = 0.0, TValue3 = 0.0;
                            var Perc_Rate4 = 0.0, Piece_Rate4 = 0.0, TValue4 = 0.0;
                            var pp1 = 0.0, pp2 = 0.0, pp3 = 0.0, pp4 = 0.0, tot = 0.0;


                            $("#" + id).find("input[type=text]").each(function () {
                                var elem = $(this);
                                if (elem.attr('id') == 'Perc_Rate1') {
                                    Perc_Rate1 = parseFloat( elem.val() || 0.0);
                                } else if (elem.attr('id') == 'Piece_Rate1') {
                                    Piece_Rate1 = parseFloat( elem.val() || 0.0);
                                } else if (elem.attr('id') == 'TValue1') {
                                    TValue1 = parseFloat( elem.val() || 0.0);
                                } if (elem.attr('id') == 'Perc_Rate2') {
                                    Perc_Rate2 = parseFloat( elem.val() || 0.0);
                                } else if (elem.attr('id') == 'Piece_Rate2') {
                                    Piece_Rate2 = parseFloat( elem.val() || 0.0);
                                } else if (elem.attr('id') == 'TValue2') {
                                    TValue2 = parseFloat( elem.val() || 0.0);
                                } else if (elem.attr('id') == 'Perc_Rate3') {
                                    Perc_Rate3 = parseFloat( elem.val() || 0.0);
                                } else if (elem.attr('id') == 'Piece_Rate3') {
                                    Piece_Rate3 = parseFloat( elem.val() || 0.0);
                                } else if (elem.attr('id') == 'TValue3') {
                                    TValue3 = parseFloat( elem.val() || 0.0);
                                } else if (elem.attr('id') == 'Perc_Rate4') {
                                    Perc_Rate4 = parseFloat( elem.val() || 0.0);
                                } else if (elem.attr('id') == 'Piece_Rate4') {
                                    Piece_Rate4 = parseFloat( elem.val() || 0.0);
                                } else if (elem.attr('id') == 'TValue4') {
                                    TValue4 = parseFloat( elem.val() || 0.0);
                                }    
                            });
                            pp1 = ((Perc_Rate1/100) * TValue1) + Piece_Rate1;
                            pp2 = ((Perc_Rate2/100) * TValue2) + Piece_Rate2;
                            pp3 = ((Perc_Rate3/100) * TValue3) + Piece_Rate3;
                            pp4 = ((Perc_Rate4/100) * TValue4) + Piece_Rate4;
                            tot = (parseFloat(pp1) + parseFloat(pp2) + parseFloat(pp3) + parseFloat(pp4));

                            $("#dpi-" + id.match(/\d+/)).html('(' + tot.toFixed(2) + ')');
                            $("#" + id).find("#tdpp").val(tot.toFixed(2));
                            $("#tabs-" + id.match(/\d+/)).find("#price").val((TValue1 + TValue2 + TValue3 + TValue4).toFixed(2));
                            
                        }
                    });

                });
                var z = parseInt(tabCounter) - 3;
                $("#tabs").tabs({ active: z });

            }

            // update click
            $("#updatebtn").click(function () {
                $("#updatebtn").prop("disabled", true);
                $("#lbl").html('');
                var data = $("#<%= hdnCompany.ClientID%>").val() + "|" + $("#<%= hdnStyle.ClientID%>").val() + "|" + $("#s7501").val() + "|" + $("#portcode").val() + "|" + $("#country").val() + "|" + $("#importdate").val() + "|" + $("#<%= hdnImportDate.ClientID%>").val() + "|" + $("#conversion").val() + "|" + $("#totalval").val() + "|" + $("#hmf").val() + "|" + $("#mpf").val();
                
                $("#tabs").find("input[type=text]").each(function () {
                    var elem = $(this);
                    data = data + "|" + elem.val();
                });
                //alert(data);
                urlToHandler = 'import.ashx';
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
                        $("#<%= hdnImportDate.ClientID%>").val(data.importdate);
                        //setAutocompleteData(data.response);
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
                    var data = $("#<%= hdnCompany.ClientID%>").val() + "|" + $("#<%= hdnStyle.ClientID%>").val() + "|" + $("#<%= hdnImportDate.ClientID%>").val() + "|" + sizecolor;
                    urlToHandler = 'delimport.ashx';
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
           // $("#embedtd").replaceWith("<td id='embedtd'><iframe id='embed' src='http://docs.google.com/gview?url=" + 'http://www.edrawback.com/docroot/' + '<%= hdnCompany.Value%>' + '/' + '<%= hdnStyle.Value%>' + '/' + '<%= importdate.Text%>' + ' Import/' + ($("[id*='ddlinfoimport'] :selected").text()).toString().trim() + "&embedded=true' width='100%' height='780' type='application/pdf'></td>");
            $("#ddlinfoimport").change(function () {
                $('#myiframe').attr('src', 'http://edrawback.com/docroot/' + '<%= hdnCompany.Value%>' + '/' + '<%= hdnStyle.Value%>' + '/' + '<%= importdate.Text%>' + ' Import/' + ($("[id*='ddlinfoimport'] :selected").text()).toString().trim());
            });
            var wWidth = $(window).width();
            var dWidth = wWidth * 0.46;
            var wHeight = $(window).height();
            var dHeight = wHeight * 0.96;
            $("#dialog-form").dialog({
                autoOpen: false,
                height: dHeight,
                width: dWidth,
                modal: false,
                position: 'left',
                open: function (ev, ui) {

                    $('#myiframe').attr('src', 'http://edrawback.com/docroot/' + '<%= hdnCompany.Value%>' + '/' + '<%= hdnStyle.Value%>' + '/' + '<%= importdate.Text%>' + ' Import/' + ($("[id*='ddlinfoimport'] :selected").text()).toString().trim());
                    $(".ui-dialog-titlebar-close", ui.dialog | ui).hide();
                },
                close: function () {
                    /* allFields.val("").removeClass("ui-state-error"); */
                }
             });
            $("#dialog-form").dialog("open");
        });
        /*]]>*/
        

    </script>

</head>
<body>
    <table width="100%">
        <tr style="background-color: #0924BC; height: 12px">
            <td colspan="2" style="color: White; font-weight: bold; font-size: 1.2em; padding: 3px"
                align="center">Import Information Page 
            </td>
        </tr>
    </table>
    <div id="dialog" title="Size / Color">
        <form>
            <fieldset class="ui-helper-reset">
                <label for="tab_title">Size</label>
                <input type="text" name="tab_title" id="tab_title" value="" class="ui-widget-content ui-corner-all" />
                <label for="tab_content">Color</label>
                <input name="tab_content" id="tab_content" class="ui-widget-content ui-corner-all" />
            </fieldset>
        </form>
    </div>
    <form runat="server" id="form1">
        <div class="leftside">

            <table width="100%" style="width: 100%; height: 100%;" cellpadding="0" cellspacing="5">

                <tr style="height: 15px;">
                    <td>
                        <asp:DropDownList runat="server" ID="ddlinfoimport" ></asp:DropDownList>
                    </td>
                </tr>
                <tr>
                    <td>
                    <div id="dialog-form"><embed style="width:100%;height:100%;" id="myiframe" />  </div>
                   <%-- <td id="embedtd" style="vertical-align: top;">
                        <a href="http://www.edrawbacks.com/pdf.pdf" id="embedURL2">Download file</a>--%>
<%--                        <embed id="embed" src="http://www.edrawbacks.com/pdf.pdf" width="600" height="480" type="application/pdf">--%>
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
           
            <div style="float: right">
                <button type="button" value="Update" id="updatebtn">SAVE</button>
                <%--<button type="button" value="Update" onclick="javascript:history.go(-1)">BACK</button>--%>
                </div>
                 <div style="float: right">
                <label style="color: red; font-weight: bold; font-size: 1.2em;" id="lbl"></label>
                     </div>
            
            <div style="float: left">

                <div style='font-size: .8em;'>
                    <div style="float: left;">
                        <label for="s7501">7501 Number</label>
                        <asp:textbox runat="server"  id="s7501" style="width: 90px;" />
                    </div>
                    <div style="float: left;">
                        <label for="portcode">Port Code</label>
                        <asp:textbox runat="server"  id="portcode" style="width: 80px;" />
                    </div>
                    <div style="float: left;">
                        <label for="country">Country Origin</label>
                        <asp:textbox runat="server"  id="country" style="width: 80px;" />
                    </div>
                    <div style="float: left;">
                        <label for="importdate">Import Date</label>
                        <asp:textbox runat="server"  ReadOnly="true" id="importdate" style="width: 80px;" />
                    </div>
                    <div style="float: left;">
                        <label for="conversion">Conversion</label>
                        <asp:textbox runat="server"  id="conversion" style="width: 50px;" />
                    </div>
                    <div style="float: left;">
                        <label for="totalval">Total Value</label>
                        <asp:textbox runat="server"  id="totalval" style="width: 80px;" />
                    </div>
                    <div style="float: left;">
                        <label for="hmf">HMF</label>
                        <asp:textbox runat="server"  id="hmf" style="width: 50px;" />
                    </div>
                    <div style="float: left;">
                        <label for="mpf">MPF</label>
                        <asp:textbox runat="server"  id="mpf" style="width: 50px;" />
                    </div>
                </div>
            </div>

            <div style="clear: both; height: 10px;"></div>
            <button id="add_tab">Add Size/Color</button>

            <div id="tabs">
                <ul>
                </ul>
                <div id="tabs-1">
                </div>
            </div>

            <asp:HiddenField ID="hdnCompany" runat="server" />
            <asp:HiddenField ID="hdnFull" runat="server" />
            <asp:HiddenField ID="hdnStatus" runat="server" />
            <asp:HiddenField ID="hdnImportDate" runat="server" />
            <asp:HiddenField ID="hdnStyle" runat="server" />
            <asp:HiddenField ID="hdnlabel" runat="server" />

            
        </div>
    </form>
</body>
</html>



