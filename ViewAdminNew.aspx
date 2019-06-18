<%@ Page Language="VB" AutoEventWireup="false" CodeFile="ViewAdminNew.aspx.vb" Inherits="ViewAdminNew"  MasterPageFile="~/MasterPage.master" MaintainScrollPositionOnPostback="true" %>


<asp:Content runat="server" ID="content1" ContentPlaceHolderID="head">
    <style type="text/css">
        [class*='col-'] {
            float: left;
        }
        .col-left {
            /*max-height: 300px; overflow:auto;*/
            
            /*width: 33.33%;*/
        }
        .col-right {
            /*width: 66.66%;*/
        }
        .col-right2 {
            /*width: 66.66%;*/
            float:right;
        }
        .grid:after {
            content: "";
            display: table;
            clear: both;
        }
        #example {
             
        }
        #content {
            width:750px;
        }
       .white-popup {
            position: relative;
            background: #FFF;
            padding: 0px;
            width: 100%;
            height: 900px;
            margin: 0px auto;
            text-align: center;
            top:-20px
        }


    </style>
    <script src="Scripts/handsontable.full.js"></script>
    <link href="Styles/handsontable.full.css" rel="stylesheet" />
   
    <link rel="stylesheet" href="Styles/magnific-popup.css" />
    <script src="Scripts/jquery.magnific-popup.js"></script>
    <script type="text/javascript">
        $(document).ready(function () {
            $("#odate").datepicker();
            var element = $('.col-right'),
    originalY = element.offset().top;

            // Space between element and top of screen (when scrolling)
            var topMargin = 20;

            // Should probably be set in CSS; but here just for emphasis
            element.css('position', 'relative');

            $(window).on('scroll', function (event) {
                var scrollTop = $(window).scrollTop();

                element.stop(false, false).animate({
                    top: scrollTop < originalY
                            ? 0
                            : scrollTop - originalY + topMargin + 200
                }, 300);
            });
            var selectedstyle;
            $("#header").hide();
            $.each(companies.split("|"), function (key, value) {
                $('#cselect')
                     .append($('<option>', { value: value })
                     .text(value));
            });
            $('#shselect').append($('<option>', { value: 'Pending' }).text('Pending'));
            $('#shselect').append($('<option>', { value: 'All' }).text('All'));
            $('#shselect').append($('<option>', { value: 'Done' }).text('Done'));
            $('#shselect').append($('<option>', { value: 'Exports' }).text('Exports with no matching Import'));
            var company = $('#cselect').val();
            if ($.cookie("company")) {
                company = $.cookie("company");
            }

            var data = [];
            var result = [];
            var $container = $("#example");
            $container.handsontable({
                data: data,
                minSpareRows: 0,
                colHeaders: ["Style"],
                colWidths: [200],
                contextMenu: true,
                outsideClickDeselects: false
            });

            var handsontable = $container.data('handsontable');
            var $container = $("#example2");
            $container.handsontable({
                data: data,
                minSpareRows: 0,
                colHeaders: ["Dates", "Status", "Comments", "Info"],
                colWidths: [145,47,135,45],
                contextMenu: true,
                columns: [
                    {},
                    {
                        type: 'checkbox',
                        checkedTemplate: 'true',
                        uncheckedTemplate: 'false'
                    },
                    {},
                    {}
                ],
                outsideClickDeselects: false
            });
            var handsontable2 = $container.data('handsontable');
            $("#cselect").change(function () {
                var result = [];
                handsontable2.loadData(result);
                $("#search").val('');
                $("#dbselect").val('');
                $.cookie("company", $('#cselect').val(), { expires: 100 });
                get_styles();
            });
            $("#odate").blur(function () {
                $("#search").val('');
                $("#dbselect").val('');
                var result = [];
                handsontable2.loadData(result);
                get_styles();
            });
            $("#tftea").change(function () {
                var result = [];
                handsontable2.loadData(result);
                get_styles();
            });
            $("#shselect").change(function () {
                $("#search").val('');
                $("#dbselect").val('');
                var result = [];
                handsontable2.loadData(result);
                get_styles();
            });
            function get_styles() {
                var result = [];
                handsontable2.loadData(result);
                urlToHandler = 'getView.ashx?company=' + $("#cselect").val() + '&show=' + $("#shselect").val() + "&dn=" + $("#dbselect").val() + "&dt=" + $("#odate").val() + "&tftea=" + $("#tftea").is(':checked');
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
                        
                        
                        if (a.length >= 1) {
                            while (a[0]) {
                                result.push(a.splice(0, 1));
                            }
                        }
                        handsontable.loadData(result);
                        var b = [];
                        b = data.response.split('|');
                        if (b.length == 1) {
                            get_dates(b[0]);
                        }
                        var c = [];
                        c = data.response2.split('|');
                        $("#dbselect").autocomplete({
                            source: c,
                            select: function (event, ui) {
                                //assign value back to the form element
                                if (ui.item) {
                                    $(event.target).val(ui.item.value);
                                }
                                //submit the form
                                $("#search").val('');
                                get_styles();
                            }
                        });
                        
                        $("#search").autocomplete({
                            source: b,
                            select: function (event, ui) {
                                //assign value back to the form element
                                if (ui.item) {
                                    $(event.target).val(ui.item.value);
                                }
                                //submit the form
                                $("#dbselect").val('');
                                result2 = []; b = [];
                                b.push($("#search").val());
                                if (b.length >= 1) {
                                    while (b[0]) {
                                        result2.push(b.splice(0, 1));
                                    }
                                }
                                handsontable.loadData(result2);
                                get_dates($("#search").val());
                            }
                        });
                        //setAutocompleteData(data.response);
                    },
                    error: function (data, status, jqXHR) {
                        alert('There was an error.');

                    }
                }); // end $.ajax
            }
            function get_dates(style) {
                selectedstyle = style;
                var result = [];
                handsontable2.loadData(result);
                if (style.length == 0)
                    return;
                urlToHandler = 'getViewDates.ashx?company=' + $("#cselect").val() + '&style=' + style + "&dn=" + $("#dbselect").val();
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
                        if (a.length >= 1) {
                            while (a[0]) {
                                result.push(a.splice(0, 4));
                            }
                        }
                        handsontable2.loadData(result);
                       
                        //setAutocompleteData(data.response);
                    },
                    error: function (data, status, jqXHR) {
                        alert('There was an error.');

                    }
                }); // end $.ajax
            }
            handsontable.addHook('afterSelectionEnd', function (row, column) {
                var current_td = this.getCell(row, column);
                get_dates($(current_td).html());
                selectedstyle = $(current_td).html();
            });
            handsontable2.addHook('afterSelectionEnd', function (row, column) {
                if (column == 3) {
                    var current_td = this.getCell(row, column);
                    date = $(current_td).closest('td').prev('td').prev('td').prev('td').html();
                    var expimp = date.match(/Import|Export/);
                    var destroyed = date.match(/Destroyed/);
                    if (destroyed != null)
                        expimp = "Export";
                    if (date.match(/Import|Export|Destroyed/) == null)
                    {
                        expimp = "ViewDoc"
                    }
                    //location.href = expimp + ".aspx?company=" + $("#cselect").val() + "&style=" + selectedstyle + "&date=" + date.split(' ')[0];
                    $.magnificPopup.open({
                        items: {
                            src: '<div class="white-popup"><a style="font-size:2em;" href="javascript:$.magnificPopup.close();">CLOSE WINDOW</a><br /><iframe style="width:100%;height:100%;" src="' + expimp + ".aspx?company=" + $("#cselect").val() + "&style=" + selectedstyle + "&date=" + date.split(" ")[0] + "&destroyed=" + destroyed + "&fullfile=" + date + '">;</div>',
                            type: 'inline'
                        }
                    });
                }               

            });
            handsontable2.addHook('beforeChange', function (changes, source) {
                if (source === 'loadData') {
                    return; //don't do anything as this is called when table is loaded
                }
                var row = changes.toString().split(',')[0];
                var col = changes.toString().split(',')[1];
                var newCellValue = changes.toString().split(',')[3];
                if (col == 0) {
                    if (!newCellValue.match(/[0-9]{4}-[0-9]{2}-[0-9]{2} (Import|Export|Destroyed)/)) {
                        return false;
                    }
                }
            });
            handsontable.addHook('afterChange', function (changes, source) {
                if (source === 'loadData') {
                    return; //don't do anything as this is called when table is loaded
                }
                var row = changes.toString().split(',')[0];
                var col = changes.toString().split(',')[1];
                var oldCellValue = changes.toString().split(',')[2];
                var newCellValue = changes.toString().split(',')[3];
                var cell = handsontable.getCell(row, col);
                var date, stat, comment, cd = '';
                
                   
                
                urlToHandler = 'updateStyle.ashx?company=' + $("#cselect").val() + "&style=" + oldCellValue + "&nstyle=" + newCellValue;
                jsonData = '';
                $.ajax({
                    url: urlToHandler,
                    data: jsonData,
                    async: false,
                    dataType: 'json',
                    type: 'POST',
                    contentType: 'application/json',
                    success: function (data) {
                        if (data.response == 'True') {
                            alert("Cannot rename. Date already exists.")
                        }
                        //setAutocompleteData(data.response);
                    },
                    error: function (data, status, jqXHR) {
                        alert('There was an error.');

                    }
                }); // end $.ajax
            });
            handsontable2.addHook('afterChange', function (changes, source) {
                if (source === 'loadData') {
                    return; //don't do anything as this is called when table is loaded
                }
                var row = Number( changes.toString().split(',')[0]);
                var col = Number(changes.toString().split(',')[1]);
                var oldCellValue = changes.toString().split(',')[2];
                var newCellValue = changes.toString().split(',')[3];
                var cell = handsontable2.getCell(row, col,true);
                var date, stat, comment, cd='';
                if (col == 0) {          
                    cd = oldCellValue;
                    date = newCellValue;
                    stat = $(cell).closest('td').next('td').find(":checkbox").is(":checked");
                    comment = $(cell).closest('td').next('td').next('td').html();
                } else if (col == 1) {                    
                    date = $(cell).closest('td').prev('td').html();
                    stat = newCellValue;
                    comment = $(cell).closest('td').next('td').html();
                } else if (col == 2) {
                    date = $(cell).closest('td').prev('td').prev('td').html();
                    stat = $(cell).closest('td').prev('td').find(":checkbox").is(":checked");
                    comment = newCellValue;
                } 
                urlToHandler = 'updateStatus.ashx?company=' + $("#cselect").val() + "&style=" + selectedstyle + "&date=" + date + "&checked=" + stat + "&comments=" + comment + "&cd=" + cd;
                jsonData = '';
                $.ajax({
                    url: urlToHandler,
                    data: jsonData,
                    async: false,
                    dataType: 'json',
                    type: 'POST',
                    contentType: 'application/json',
                    success: function (data) {
                        //if (data.response == 'True') {
                        //    alert("Cannot rename. Date already exists.")
                        //}
                        //setAutocompleteData(data.response);
                    },
                    error: function (data, status, jqXHR) {
                        alert('There was an error.');

                    }
                }); // end $.ajax
            });

            $('#cselect').val(company).change();            
            $("#search").keydown(function (event) {
                if (event.which == 8 || event.which == 46) {
                    //  alert('backspace pressed');
                    $("#search").val('');
                    get_styles();
                }
            });
            $("#dbselect").keydown(function (event) {
                if (event.which == 8 || event.which == 46) {
                    //  alert('backspace pressed');
                    $("#dbselect").val('');
                    get_styles();
                }
            });
        });
        
      
    </script>
    </asp:Content>

<asp:Content runat="server" ID="content2" ContentPlaceHolderID="ContentPlaceHolder1">
   
        <asp:Label runat="server" ID="lblLogged"></asp:Label>
         &nbsp; | &nbsp;    
        <a href="Admin.aspx">Go Back to Main Menu</a>
    
</asp:Content>
<asp:Content runat="server" ID="content3" ContentPlaceHolderID="ContentPlaceHolder2">
    Company: <select id="cselect"></select><span style="margin-left:10px;">Show: <select id="shselect"></select></span><span style="margin-left:10px;">Date: <input size="5" id="odate" /></span><input type="checkbox" id="tftea" /> <span style="float:right;">Search: <input  id="search" style="width:100px;"  type="text" /></span> 

    <br />
    <div class="grid">
        <div class="col-left">
            <div class="handsontable" id="example"></div>
        </div>
        <div class="col-right">
            <div class="handsontable" id="example2"></div>
              
        </div>
        <div class="col-right2">
            Dback#: <input id="dbselect" style="width:100px;" />
        </div>
    </div>
    
</asp:Content>
