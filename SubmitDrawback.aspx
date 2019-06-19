<%@ Page Language="VB" AutoEventWireup="false" CodeFile="SubmitDrawback.aspx.vb" Inherits="SubmitDrawback" MasterPageFile="~/MasterPage.master" %>

<asp:Content runat="server" ID="content1" ContentPlaceHolderID="head">
   <!-- <link rel="stylesheet" media="screen" href="http://handsontable.com/dist/handsontable.full.css" /> -->
    <link rel="stylesheet" href="css/handsontable.full.css" />
    <script src="Scripts/jquery.print.js"></script>
   <!-- <script src="http://handsontable.com/dist/handsontable.full.js"></script> -->
    <script type="text/javascript" src="Scripts/handsontable.full.js" ></script>
    <style>
        @media print {
           thead {display: table-header-group;}
              .break {page-break-before: always}
                  table {  border-collapse: collapse;}
        }
    </style>
</asp:Content>
<asp:Content runat="server" ID="content2" ContentPlaceHolderID="ContentPlaceHolder1">
    <asp:Label runat="server" ID="lblLogged"></asp:Label>
    &nbsp; | &nbsp;    
        <a href="Admin.aspx">Go Back to Main Menu</a>
    <script type="text/javascript">
        

        $(document).ready(function () {
            $(".datepicker").datepicker({
                onSelect: function (dateText) {
                    $('#dbnselect').trigger("change");
                }
            });
            $(".datepicker").datepicker("setDate", new Date());
            $.each(companies.split("|"), function (key, value) {
                $('#cselect')
                     .append($('<option>', { value: value })
                     .text(value));
            });
            
            // http://handsontable.com/
            var data = [];
            var $container = $("#example");
            $container.handsontable({
                data: data,
                minSpareRows: 1,
                colHeaders: ["Import Entry#", "Port Code", "Import Date", "CD", "HTSUS#", "Description", "Qty & UOM", "Value per Unit", "Duty Rate", "99% Duty"],
                contextMenu: true
            });
            var handsontable = $container.data('handsontable');
            $container = $("#example2");
            $container.handsontable({
                data: data,
                minSpareRows: 1,
                colHeaders: ["Date", "Action Code", "Unique Identifier No", "Name of Exporter/Destoryer", "Description of Articles", "Qty and UOM", "Export Dest.", "HTSUS No."],
                contextMenu: true
            });
            var handsontable2 = $container.data('handsontable'); 
            $container = $("#example3");
            $container.handsontable({
                data: data,
                minSpareRows: 1,
                colHeaders: ["Item #", "Import#", "Number of Units", "Individual Value", "Total Value", "Weighted Ratio", "Weighted Ratio/MPF per Line", "99% of MPF per Line"],
                contextMenu: true
            });
            var handsontable3 = $container.data('handsontable');
            $container = $("#example4");
            $container.handsontable({
                data: data,
                minSpareRows: 1,
                colHeaders: ["Item #", "Import#", "Number of Units", "Individual Value", "Total Value", "Weighted Ratio", "Weighted Ratio/HMF per Line", "99% of HMF per Line"],
                contextMenu: true
            });
            var handsontable4 = $container.data('handsontable');
            $container = $("#example5");
            $container.handsontable({
                data: data,
                minSpareRows: 1,
                colHeaders: ["Import Enrty#", "Port", "LIQ-DATE", "DUTY $99%", "MPF 99%", "HMF 99%", "TAXES"],
                contextMenu: true
            });
            var handsontable5 = $container.data('handsontable');
            $("#cselect").change(function () {
                $.cookie("company", $('#cselect').val(), { expires: 100 });
                urlToHandler = 'getdrawbacknums.ashx?company=' + $("#cselect").val() + '&status=' + $("#sselect").val();
                jsonData = '';
                $.ajax({
                    url: urlToHandler,
                    data: jsonData,
                    async: false,
                    dataType: 'json',
                    type: 'POST',
                    contentType: 'application/json',
                    success: function (data) {
                        $('#dbnselect').children().remove();
                        $.each(data.response.split("|"), function (key, value) {
                            $('#dbnselect')
                                 .append($('<option>', { value: value })
                                 .text(value));
                        });
                        $('#dbnselect').trigger("change");
                    },
                    error: function (data, status, jqXHR) {
                        alert('There was an error.');
                        
                    }
                }); // end $.ajax
            });
            var tothmf, totmpf, totdc, irsnumber, fromdate, todate, totduty, totclaim;
            $("#sselect").change(function () {
                $('#cselect').trigger("change");
            });
            $("#dbnselect").change(function () {
                
                urlToHandler = 'dbnchart.ashx?company=' + $("#cselect").val() + '&dbn=' + $("#dbnselect").val() + '&dt=' + $('.datepicker').datepicker({ dateFormat: 'mm/dd/yyyy' }).val();
                jsonData = '';
                $.ajax({
                    url: urlToHandler,
                    data: jsonData,
                    async: false,
                    dataType: 'json',
                    type: 'POST',
                    contentType: 'application/json',
                    success: function (data) {
                       
                        var result = [];
                        

                        var a = data.response.split('|');
                        totdc = a[a.length - 1];
                        if (a.length > 1) {
                            while (a[0]) {
                                result.push(a.splice(0, 10));
                            }
                        }
                        handsontable.loadData(result);
                        var result = [];
                        
                        var a = data.response2.split('|');
                        if (a.length > 1) {
                            while (a[0]) {
                                result.push(a.splice(0, 8));
                            }
                        }
                        handsontable2.loadData(result);
                        fromdate = result[0][0];
                        todate = result.length>1? result[result.length - 2][0]:'';
                        var result = [];

                        var a = data.response3.split('|');
                        totmpf = a[a.length - 1].toString();
                        if (a.length > 1) {
                            while (a[0]) {
                                result.push(a.splice(0, 8));
                            }
                        }
                        handsontable3.loadData(result);
                        var result = [];

                        var a = data.response4.split('|');                        
                        tothmf = a[a.length - 1].toString();
                        if (a.length > 1) {
                            while (a[0]) {
                                result.push(a.splice(0, 8)); 
                            }
                        }
                        handsontable4.loadData(result);
                        var result = [];

                        var a = data.response5.split('|');
                        if (a.length > 1) {
                            while (a[0]) {
                                result.push(a.splice(0, 7)); 
                            }
                        }
                        handsontable5.loadData(result);


                        handsontable.addHook('afterSelectionEnd', function (row, column) {
                            if (column == 0){
                                var current_td = this.getCell(row, column);
                                var ie = 'I';
                                var style = $(current_td).next('td').next('td').next('td').next('td').next('td').html().split(' - ')[0];
                                var id = $(current_td).next('td').next('td').html();
                            }
                           
                        });
                        totduty = data.totduty;
                        totclaim = data.totclaim;
                        $("#btnprint").show();
                        $("#dbn_on_pdf").text($("#dbnselect").val());
                        $("#hmf_on_pdf").text(tothmf);
                        $("#mpf_on_pdf").text(totmpf);
                        $("#dc_on_pdf").text(data.totduty);
                        $("#tdc_on_pdf").text(data.totclaim);
                        $("#fd_on_pdf").text(fromdate);
                        $("#td_on_pdf").text(todate);
                        irsnumber = data.irsnumber;
                        if ($("#sselect").val() == 'FILED') {
                            $("#filed_date").text(data.filed_date);
                        } else {
                            $("#filed_date").text('');
                        }
                        
                        //setAutocompleteData(data.response);
                    },
                    error: function (data, status, jqXHR) {
                        alert('There was an error.');

                    }
                }); // end $.ajax
            });
            var company = $('#cselect').val();
            if ($.cookie("company")) {
                company = $.cookie("company");
            }
            $('#cselect').val(company).change();
            $('#dbnselect').val($('#dbnselect').val()).change();

            $("#btnprint").click(function () {
                var str = '<div style="position:relative">';

                str += "<div style='position:absolute;top:60px;left:395px;font-size:.8em;'>" + $('#dbnselect').val() + "</div>";
                str += "<div style='position:absolute;top:95px;left:995px;font-size:.8em;'>" + totduty + "</div>";
                str += "<div style='position:absolute;top:130px;left:535px;font-size:.8em;'>" + tothmf + "</div>";
                str += "<div style='position:absolute;top:130px;left:635px;font-size:.8em;'>" + totmpf + "</div>";
                str += "<div style='position:absolute;top:135px;left:895px;font-size:.8em;'>" + totclaim + "</div>";
                str += "<div style='position:absolute;top:1000px;left:515px;font-size:.8em;'>" + totmpf + "</div>";
                str += "<div style='position:absolute;top:1000px;left:685px;font-size:.8em;'>" + totmpf + "</div>";

                        //<div id="dbn_on_pdf" style='position:absolute;top:55px;left:395px;'></div>
                        //<div id="dc_on_pdf" style='position:absolute;top:90px;left:995px;'></div>
                        //<div id="mpf_on_pdf" style='position:absolute;top:125px;left:635px; '></div>
                        //<div id="tdc_on_pdf" style='position:absolute;top:130px;left:895px; '></div>
                        //<div id="fd_on_pdf" style='position:absolute;top:1000px;left:515px;'></div>
                        //<div id="td_on_pdf" style='position:absolute;top:1000px;left:685px;'></div> 
                str += '<img src="Croton_7551_Page_1.jpg" /><img src="CBP_Form_7551_Croton_Page_2.jpg" />';
                str += '</div>';
                str += '<div class="break"></div>';
                str += '<h3>Section II - Imported Duty Paid, Designated Merchandise or Drawback Product</h3>';
                // From Firefox Inspect Element.
                str += '<table class="htCore"><colgroup><col style="width: 125px;"><col style="width: 73px;"><col style="width: 86px;"><col style="width: 50px;"><col style="width: 120px;"><col style="width: 250px;"><col style="width: 80px;"><col style="width: 101px;"><col style="width: 73px;"><col style="width: 66px;"></colgroup><thead><tr style="border-bottom: solid 2px black;"><th class=""><div class="relative"><span class="colHeader">Import Entry#</span></div></th><th class=""><div class="relative"><span class="colHeader">Port Code</span></div></th><th class=""><div class="relative"><span class="colHeader">Import Date</span></div></th><th class=""><div class="relative"><span class="colHeader">CD</span></div></th><th class=""><div class="relative"><span class="colHeader">HTSUS#</span></div></th><th class=""><div class="relative"><span class="colHeader">Description</span></div></th><th class=""><div class="relative"><span class="colHeader">Qty &amp; UOM</span></div></th><th class=""><div class="relative"><span class="colHeader">Value per Unit</span></div></th><th class=""><div class="relative"><span class="colHeader">Duty Rate</span></div></th><th class=""><div class="relative"><span class="colHeader">99% Duty</span></div></th></tr></thead><tbody>';
                var hands = handsontable.getData();
                for (i = 0; i < hands.length; i++) {
                    if (hands[i][0] != null) {
                        str += '<tr style="border-bottom: solid 1px black;"><td>' + hands[i][0] + '</td><td>' + hands[i][1] + '</td><td>' + hands[i][2] + '</td><td>' + hands[i][3] + '</td><td>' + hands[i][4] + '</td><td>' + hands[i][5] + '</td><td>' + hands[i][6] + '</td><td>' + hands[i][7] + '</td><td>' + hands[i][8] + '</td><td>' + hands[i][9] + '</td></tr>';
                    }
                }
                str += '</tbody></table>';
                str += '<div class="break"></div>';
                str += '<h3>Section IV - Information on Exported or Destroyed Merchandise</h3>';
                str += '<table class="htCore"><colgroup><col style="width: 73px;"><col style="width: 60px;"><col style="width: 100px;"><col style="width: 190px;"><col style="width: 250px;"><col style="width: 93px;"><col style="width: 90px;"><col style="width: 90px;"></colgroup><thead><tr style="border-bottom: solid 2px black;"><th class=""><div class="relative"><span class="colHeader">Date</span></div></th><th class=""><div class="relative"><span class="colHeader">Action Code</span></div></th><th class=""><div class="relative"><span class="colHeader">Unique Identifier No</span></div></th><th class=""><div class="relative"><span class="colHeader">Name of Exporter/Destoryer</span></div></th><th class=""><div class="relative"><span class="colHeader">Description of Articles</span></div></th><th class=""><div class="relative"><span class="colHeader">Qty and UOM</span></div></th><th class=""><div class="relative"><span class="colHeader">Export Dest.</span></div></th><th class=""><div class="relative"><span class="colHeader">HTSUS No.</span></div></th></tr></thead><tbody>';
                hands = handsontable2.getData();
                for (i = 0; i < hands.length; i++) {
                    if (hands[i][0] != null) {
                        str += '<tr style="border-bottom: solid 1px black;"><td>' + hands[i][0] + '</td><td>' + hands[i][1] + '</td><td>' + hands[i][2] + '</td><td>' + hands[i][3] + '</td><td>' + hands[i][4] + '</td><td>' + hands[i][5] + '</td><td>' + hands[i][6] + '</td><td>' + hands[i][7] + '</td></tr>';
                    }
                }
                str += '</tbody></table>';
                str += '<div class="break"></div>';
                str += '<h3>Merchandise Processing Fee Exhibit</h3>';
                str += '<table class="htCore"><colgroup><col style="width: 151px;"><col style="width: 110px;"><col style="width: 113px;"><col style="width: 110px;"><col style="width: 81px;"><col style="width: 108px;"><col style="width: 197px;"><col style="width: 135px;"></colgroup><thead><tr style="border-bottom: solid 2px black;"><th class=""><div class="relative"><span class="colHeader">Item #</span></div></th><th class=""><div class="relative"><span class="colHeader">Import #</span></div></th><th class=""><div class="relative"><span class="colHeader">Number of Units</span></div></th><th class=""><div class="relative"><span class="colHeader">Individual Value</span></div></th><th class=""><div class="relative"><span class="colHeader">Total Value</span></div></th><th class=""><div class="relative"><span class="colHeader">Weighted Ratio</span></div></th><th class=""><div class="relative"><span class="colHeader">Weighted Ratio/MPF per Line</span></div></th><th class=""><div class="relative"><span class="colHeader">99% of MPF per Line</span></div></th></tr></thead><tbody>';
                hands = handsontable3.getData();
                for (i = 0; i < hands.length; i++) {
                    if (hands[i][0] != null) {
                        str += '<tr style="border-bottom: solid 1px black;text-align:center;"><td>' + hands[i][0] + '</td><td>' + hands[i][1] + '</td><td>' + hands[i][2] + '</td><td>' + hands[i][3] + '</td><td>' + hands[i][4] + '</td><td>' + hands[i][5] + '</td><td>' + hands[i][6] + '</td><td>' + hands[i][7] + '</td></tr>';
                    }
                }

                str += '</tbody></table>';
                str += '<div class="break"></div>';
                str += '<h3>Harbor Maintenance Fee Exhibit</h3>';
                str += '<table class="htCore"><colgroup><col style="width: 151px;"><col style="width: 110px;"><col style="width: 113px;"><col style="width: 110px;"><col style="width: 81px;"><col style="width: 108px;"><col style="width: 197px;"><col style="width: 135px;"></colgroup><thead><tr style="border-bottom: solid 2px black;"><th class=""><div class="relative"><span class="colHeader">Item #</span></div></th><th class=""><div class="relative"><span class="colHeader">Import #</span></div></th><th class=""><div class="relative"><span class="colHeader">Number of Units</span></div></th><th class=""><div class="relative"><span class="colHeader">Individual Value</span></div></th><th class=""><div class="relative"><span class="colHeader">Total Value</span></div></th><th class=""><div class="relative"><span class="colHeader">Weighted Ratio</span></div></th><th class=""><div class="relative"><span class="colHeader">Weighted Ratio/HMF per Line</span></div></th><th class=""><div class="relative"><span class="colHeader">99% of HMF per Line</span></div></th></tr></thead><tbody>';
                hands = handsontable4.getData();
                for (i = 0; i < hands.length; i++) {
                    if (hands[i][0] != null) {
                        str += '<tr style="border-bottom: solid 1px black;text-align:center;"><td>' + hands[i][0] + '</td><td>' + hands[i][1] + '</td><td>' + hands[i][2] + '</td><td>' + hands[i][3] + '</td><td>' + hands[i][4] + '</td><td>' + hands[i][5] + '</td><td>' + hands[i][6] + '</td><td>' + hands[i][7] + '</td></tr>';
                    }
                }
                //str += '</tbody></table>';
                //str += '<div class="break"></div>';
                //str += '<h3>Drawback Code Sheet</h3>';
                //str += '<div>Drawback# ' + $("#dbnselect").val() + '</div>';
                //str += '<div>IRS# ' + irsnumber + '</div>';
                //str += '<div>ENTRY DATE:____/____/____    TYPE:  ____   DRAWBACK SPEC # _____</div>';
                //str += '<div>PRIVILEGES:  ACCEL PAY ___  EXPORT SUMMERY ___  WAIVER OF PRIOR NOT. ___</div>';
                //str += '<div>CM/CD\'S FILED:        YES ___   NO___        </div>';
                //str += '<table class="htCore"><colgroup><col style="width: 97px;"><col style="width: 50px;"><col style="width: 70px;"><col style="width: 76px;"><col style="width: 62px;"><col style="width: 63px;"><col style="width: 50px;"></colgroup><thead><tr style="border-bottom: solid 2px black;"><th class=""><div class="relative"><span class="colHeader">Import Enrty#</span></div></th><th class=""><div class="relative"><span class="colHeader">Port</span></div></th><th class=""><div class="relative"><span class="colHeader">LIQ-DATE</span></div></th><th class=""><div class="relative"><span class="colHeader">DUTY $99%</span></div></th><th class=""><div class="relative"><span class="colHeader">MPF 99%</span></div></th><th class=""><div class="relative"><span class="colHeader">HMF 99%</span></div></th><th class=""><div class="relative"><span class="colHeader">TAXES</span></div></th></tr></thead><tbody>';
                //hands = handsontable4.getData();
                //for (i = 0; i < hands.length; i++) {
                //    if (hands[i][0] != null) {
                //        str += '<tr style="border-bottom: solid 1px black;text-align:center;"><td>' + hands[i][0] + '</td><td>' + hands[i][1] + '</td><td>' + hands[i][2] + '</td><td>' + hands[i][3] + '</td><td>' + hands[i][4] + '</td><td>' + hands[i][5] + '</td><td>' + hands[i][6] + '</td></tr>';
                //    }
                //}

                str += '</tbody></table>';
                $(".printable").append(str);
                $(".printable").print();
                //CallPrint('toprint');
                $(".printable").text('');
            });
        });
        function CallPrint(strid) {
            var headstr = "<html><head><title></title></head><body>";
            var footstr = "</body>";
            var newstr = document.all.item(strid).innerHTML;
            var oldstr = document.body.innerHTML;
            document.body.innerHTML = headstr + newstr + footstr;

            debugger;

            window.print();
            document.body.innerHTML = oldstr;
            return false;
        }
        $(function () {
           

        });
    </script>
</asp:Content>


<asp:Content runat="server" ID="content3" ContentPlaceHolderID="ContentPlaceHolder2">
    <div id="center">
        <table>
            <tr>
                <td>
                    <span style="font-size: 1.5em;">Company:</span>
                    <select id="cselect"></select>
                    <br />
                    <span style="font-size: 1.5em;">Drawback #:</span>
                    <select id="dbnselect"></select>
                    <br />
                    <span style="font-size: 1.5em;">Status:</span>
                    <select id="sselect"><option value="FILED">FILED</option><option selected="selected" value="PENDING">PENDING</option></select>
                    <span id="filed_date" style="padding-left:10px;"></span>
                    <br />
                    <span style="font-size: 1.5em;">Date Filing:</span>
                    <input class="datepicker" id="datefiling" />
                    <div style="position:relative;" id="toprint">
                        <div id="dbn_on_pdf" style='position:absolute;top:55px;left:395px;'></div>
                        <div id="dc_on_pdf" style='position:absolute;top:90px;left:995px;'></div>
                        <div id="hmf_on_pdf" style='position:absolute;top:125px;left:535px;'></div>
                        <div id="mpf_on_pdf" style='position:absolute;top:125px;left:635px;'></div>
                        <div id="tdc_on_pdf" style='position:absolute;top:130px;left:895px;'></div>
                        <div id="fd_on_pdf" style='position:absolute;top:1040px;left:515px;'></div>
                        <div id="td_on_pdf" style='position:absolute;top:1040px;left:685px;'></div> 



                        <img src="Croton_7551_Page_1.jpg" />
                        <img src="CBP_Form_7551_Croton_Page_2.jpg" />
                        <h2>Section II - Imported Duty Paid, Designated Merchandise or Drawback Product</h2>
                        <div class="handsontable" id="example"></div>
                        <h2>Section IV - Information on Exported or Destroyed Merchandise</h2>
                        <div class="handsontable" id="example2"></div>
                        <h2>Merchandise Processing Fee Exhibit</h2>
                        <div class="handsontable" id="example3"></div>
                        <h2>Harbor Maintenance Fee Exhibit</h2>
                        <div class="handsontable" id="example4"></div>
                        <h2>Drawback Code Sheet</h2>
                        <div class="handsontable" id="example5"></div>
                        <input type="button" value="print" id="btnprint" style="display:none;" />
                    </div>                    
                </td>
            </tr>
        </table>
        <div class="printable"></div>
    </div>
    <asp:HiddenField ID="hdncompany" runat="server" />
</asp:Content>
