<%@ Page Language="VB" AutoEventWireup="false" CodeFile="Default2.aspx.vb" Inherits="Default2" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <%--<script src="//code.jquery.com/jquery-1.10.0.js"></script>--%>
    <script src="Scripts/jquery-git.js"></script>
    <script src="Scripts/jspdf.debug.js"></script>
    <script src="Scripts/bootstrap.min.js"></script>
    <%--<script src="Scripts/jspdf.plugin.table.js"></script>--%>
    <link href="Styles/bootstrap.min.css" rel="stylesheet" />
<%--    <script src="Scripts/jquery-1.7.2.min.js"></script>
    <script src="Scripts/jspdf.js"></script>
    <script src="Scripts/jspdf.plugin.javascript.js"></script>
    <script src="Scripts/jspdf.PLUGINTEMPLATE.js"></script>
    <script src="Scripts/jspdf.plugin.from_html.js"></script>
    <script src="Scripts/jspdf.plugin.standard_fonts_metrics.js"></script>
    <script src="Scripts/jspdf.plugin.split_text_to_size.js"></script>
    <script src="Scripts/FileSaver.js"></script>
    <script src="Scripts/FileSaver.min.js"></script>--%>
    <script type="text/javascript">


        function tableToJson(table) {
            var data = [];

            // first row needs to be headers
            var headers = [];
            for (var i = 0; i < table.rows[0].cells.length; i++) {
                headers[i] = table.rows[0].cells[i].innerHTML.toLowerCase().replace(/ /gi, '');
            }

            // go through cells
            for (var i = 0; i < table.rows.length; i++) {

                var tableRow = table.rows[i];
                var rowData = {};

                for (var j = 0; j < tableRow.cells.length; j++) {

                    rowData[headers[j]] = tableRow.cells[j].innerHTML;

                }

                data.push(rowData);
            }

            return data;
        }


        $(document).ready(function () {

            $("#print").click(function () {

                var doc = new jsPDF('landscape', 'pt', 'letter');
                doc.setFontSize(12);
                // We'll make our own renderer to skip this editor
                var specialElementHandlers = {
                    '#editor': function (element, renderer) {
                        
                        return true;
                    }
                };
                var table1 =
        tableToJson($('#mytable').get(0)),
        cellWidth = 50,
        rowCount = 0,
        cellContents,
        leftMargin = 2,
        topMargin = 12,
        topMarginTable = 55,
        headerRowHeight = 28,
        rowHeight = 9,

         l = {
             orientation: 'l',
             unit: 'mm',
             format: 'a3',
             compress: true,
             fontSize: 8,
             lineHeight: 1,
             autoSize: false,
             printHeaders: true
         };

                doc.cellInitialize();

                $.each(table1, function (i, row) {

                    rowCount++;

                    $.each(row, function (j, cellContent) {

                        if (rowCount == 1) {
                            doc.margins = 1;
                            doc.setFont("helvetica");
                            doc.setFontType("bold");
                            doc.setFontSize(9);

                            doc.cell(leftMargin, topMargin, 75, headerRowHeight, cellContent, i)
                        }
                        else if (rowCount == 2) {
                            doc.margins = 1;
                            //doc.setFont("times ");
                            doc.setFontType("italic");  // or for normal font type use ------ doc.setFontType("normal");
                            doc.setFontSize(8);

                            doc.cell(leftMargin, topMargin, cellWidth, rowHeight, cellContent, i);
                        }
                        else {

                            doc.margins = 1;
                            //doc.setFont("courier ");
                            //doc.setFontType("bolditalic ");
                            doc.setFontSize(6.5);

                            doc.cell(leftMargin, topMargin, cellWidth, rowHeight, cellContent, i);  // 1st=left margin    2nd parameter=top margin,     3rd=row cell width      4th=Row height
                        }
                    })
                })
                //var data = tableToJson(document.getElementById('mytable'));
                //height = doc.drawTable(data, { xstart: 10, ystart: 10, tablestart: 70, marginleft: 50 });
                // All units are in the set measurement for the document
                // This can be changed to "pt" (points), "mm" (Default), "cm", "in"

                //doc.fromHTML($('#printme').get(0), 20, 20, {
                //    'width': 450,
                //    'elementHandlers': specialElementHandlers
                //});
                doc.save("Test.pdf")
            });
        });        
    </script>
    <style type="text/css">
        
        body {
            width: 98%;
            margin-left: auto;
            margin-right: auto;
             word-wrap: break-word;
             
        }
        br {
           display: block;
           margin: 10px 0;
        }
        h1 {text-align: center;font-size:1.3em;font-weight:bold;}
        .right {
            float: right;
        }
        .left {
            float: left;
        }
        .clear {
            clear: right;
            height:1px;
        }
        .solidline {
            border-bottom: 1px solid black;
        }
        .dashline {
            border-bottom: 1px dashed black;
        }
        table {
  border-collapse: collapse;
}
        
    </style>
    <title></title>
</head>
<body>
    <form id="form1" runat="server">

    <div id="printme">
        <h1>Imported Duty Paid Merchandise Calculation - Sorted by 7501</h1>
        <div class="left">
            Prepared By: Alba
        </div>        
        <div class="right">
            September 15,2014
        </div>
        <div class="clear"></div>
        <div class="left">
            Prepared For: Croton
        </div>
        <div class="right">
            Page 1 of 1
        </div>
        <div class="clear"></div>
        <div class="left">
            Claim Number: <b>82045757463</b>
        </div>
        <br /><br /><br />
        <table id="tab_customers" class="table table-striped" style="font-size:.4em;">
        <colgroup>
            <col width="10%">
                <col width="10%">
                    <col width="10%">
                        <col width="10%">
        </colgroup>
        <thead>
            <tr class='warning' style="width:20px;max-width:20px;">
                <th>Import / CM Entry / No.</th>
                <th>Population</th>
                <th>Date</th>
                <th>Age</th>
            </tr>
        </thead>
        <tbody>
            <tr>
                <td>Chinna</td>
                <td>1,363,480,000</td>
                <td>March 24, 2014</td>
                <td>19.1</td>
            </tr>
            <tr>
                <td>India</td>
                <td>1,241,900,000</td>
                <td>March 24, 2014</td>
                <td>17.4</td>
            </tr>
            <tr>
                <td>United States</td>
                <td>317,746,000</td>
                <td>March 24, 2014</td>
                <td>4.44</td>
            </tr>
            <tr>
                <td>Indonesia</td>
                <td>249,866,000</td>
                <td>July 1, 2013</td>
                <td>3.49</td>
            </tr>
            <tr>
                <td>Brazil</td>
                <td>201,032,714</td>
                <td>July 1, 2013</td>
                <td>2.81</td>
            </tr>
        </tbody>
    </table>
        <table id="mytable" >
            <tr class="solidline">
                <td style="width:110px;max-width:110px;">Import No.
                </td>
                <td style="width:50px;max-width:50px;">Port Code
                </td>
                <td style="width:65px;max-width:65px;">Import Date
                </td>
                <td style="width:35px;max-width:35px;">CD
                </td>
                <td style="width:100px;max-width:100px;">Date Rcvd/Used
                </td>
                <td style="width:100px;max-width:100px;">HTS
                </td>
                <td style="width:240px;max-width:240px;">Description of Merchandise
                </td>
                <td style="width:100px;max-width:90px;">Quantity/Unit of Measure
                </td>
                <td style="width:70px;max-width:70px;">Unit Value
                </td>
                <td style="width:70px;max-width:70px;">Duty Rate
                </td>
                <td>99% Duty Tax
                </td>
            </tr>
            <tr class="dashline">
                <td>82009154335</td>
                <td>4701</td>
                <td>01/13/13</td>
                <td>N</td>
                <td>01/01/13</td>
                <td>5209416020</td>
                <td>22106 BLACK - COTTON FABRIC</td>
                <td>441.00 EA</td>
                <td>12.06</td>
                <td>7.5%</td>
                <td>$394.89</td>
            </tr>
        </table>
        <input type="button" value="Print" id="print" />
    </div>
    </form>
</body>
</html>
