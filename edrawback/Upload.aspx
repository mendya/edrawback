<%@ Page Language="VB" AutoEventWireup="false" CodeFile="Upload.aspx.vb" Inherits="Upload" MasterPageFile="~/MasterPage.master" MaintainScrollPositionOnPostback="true" %>

<asp:Content runat="server" ID="content1" ContentPlaceHolderID="head">
    <style type="text/css">
        .auto-style1 {
            width: 10px;
        }

        #dialog-form {
            background-color: white;
            border: 3px solid black;
        }
        .animated {}
    </style>
    <script src='scripts/jquery.autosize.js'></script>
    <script>
        $(document).ready(function () {

            var $editor = $('#<%=text_style_no.ClientID%>');
           // var $clipboard = $('<input type="text" />').insertAfter($editor);



            $editor.on('paste', function () {
                var $self = $(this);
                setTimeout(function () {
                    var $content = $self.val();
                    $editor.val($content + "\r\n");
                }, 100);
            });

        });

        // http://www.jacklmoore.com/autosize/
        $(function () {
            $('.normal').autosize();
            $('.animated').autosize();
        });
        /* http://jqueryui.com/datepicker/ */
        /* http://forums.asp.net/t/1631725.aspx?how+to+add+jquery+Datepicker+in+code+behind  */
        /* http://stackoverflow.com/questions/233553/how-do-i-pre-populate-a-jquery-datepicker-textbox-with-todays-date */
       
        $(function () {
            $(".datepicker").datepicker();
            if (!isPostback) {
                //$(".datepicker").datepicker("setDate", new Date());
            }

        });

        $(document).ready(function () {
            $('#<%= lbl.ClientID %>').fadeOut(5000, function () {
                 $(this).html(""); //reset the label after fadeout
             });
         });
    </script>
    <script>
        /* https://jqueryui.com/dialog/#modal-form  */
        $(function () {
            $("#dialog-form").dialog({
                autoOpen: false,
                height: 400,
                width: 450,
                modal: false,
                close: function () {
                    /* allFields.val("").removeClass("ui-state-error"); */
                }
            });
            $("#User-Guide")
               .button()
               .click(function () {
                   $("#dialog-form").dialog("open");
               });
            /*
            $("#zoom_form").dialog({
                autoOpen: false,
                height: 700,
                width: 600,
                modal: true,
                close: function () {
                }
            });
            $("#zoom_button")
                .button()
                .click(function () {
                    $("#zoom_form").dialog("open");
                });
                */
        });

        handleNewSelection_FC = function () {
            switch ($(this).val()) {
                case 'Fedex':
                case 'Sobel':

                    if ($("#<%= ImportorExport.ClientID %>").val() == 'Import') {
                        $("#tOReB").hide();
                    } else {
                        $("#tOReB").show();
                        $("#tORb").html('FEDEX Tracking Number');
                    }
                    break;
                case 'UPS':
                    $("#tOReB").show();
                    if ($("#<%= ImportorExport.ClientID %>").val() == 'Import') {
                        $("#tORb").html('UPS Entry Number');
                    } else {
                        $("#tORb").html('UPS Tracking Number');
                    }
                    break;
            }
        };
        handleNewSelection_IE = function () {
            $("#fc").show();
            $("#tOReB").hide();
            switch ($(this).val()) {
                case 'Import':
                    if ($("#<%= FreightCarrier.ClientID%>").val() == 'UPS') {
                        $("#tOReB").show();
                        $("#tORb").html('UPS Entry Number');
                    } else {
                        $("#tOReB").hide();
                        
                    }
                    break;
                case 'Export':
                    $("#fc").show();
                    $("#tOReB").show();
                    if ($("#<%= FreightCarrier.ClientID %>").val() == 'Fedex' ) {
                        $("#tORb").html('FEDEX Tracking Number');
                    } else {
                        $("#tORb").html('UPS Tracking Number');
                    }
                    break;
                case 'Destroyed':
                    $("#fc").hide();
                    $("#tOReB").hide();
                    break;
                case 'Document':
                    $("#tOReB").show();
                    $("#fc").hide();
                    $("#tORb").html('Document Type');
                    break;
            }
        };
        $(document).ready(function () {

            $("#<%= FreightCarrier.ClientID %>").change(handleNewSelection_FC);
            $("#<%= ImportorExport.ClientID%>").change(handleNewSelection_IE);
            // Run the event handler once now to ensure everything is as it should be
            handleNewSelection_FC.apply($("#<%= FreightCarrier.ClientID %>"));
            handleNewSelection_IE.apply($("#<%= ImportorExport.ClientID %>"));
        });
        //function zoomin() {
        //    var DWObject = .getInstance();
        //    DWObject.style.width = "500px";
        //    DWObject.style.height = "600px";
        //}
        //function zoomout() {
        //    var DWObject = gWebTwain.getInstance();
        //    DWObject.style.width = "240px";
        //    DWObject.style.height = "300px";
        //}

       
    
    </script>

       <script type="text/javascript">
           Dynamsoft.WebTwainEnv.RegisterEvent('OnWebTwainReady', Dynamsoft_OnReady); // Register OnWebTwainReady event. This event fires as soon as Dynamic Web TWAIN is initialized and ready to be used

           var DWObject;

           function Dynamsoft_OnReady() {
               DWObject = Dynamsoft.WebTwainEnv.GetWebTwain('dwtcontrolContainer'); // Get the Dynamic Web TWAIN object that is embeded in the div with id 'dwtcontrolContainer'
           }

           function AcquireImage() {
               if (DWObject) {
                   DWObject.SelectSource();
                   DWObject.OpenSource();
                   DWObject.IfShowUI = false;//Disable scanner UI.
                   DWObject.IfDisableSourceAfterAcquire = true;//Scanner source will be disabled automatically after scan.
                   //if (document.getElementById("ADF").checked)//Use auto feeder or use the flatbed
                   //    DWObject.IfFeederEnabled = true;//Enbale Document Feeder
                   //else
                   //    DWObject.IfFeederEnabled = false;//Disable Document Feeder

                   //if (document.getElementById("ADF").checked && DWObject.IfFeederEnabled == true)  // if paper is NOT loaded on the feeder
                   //{
                   //    if (DWObject.IfFeederLoaded != true && DWObject.ErrorCode == 0) {
                   //        alert("No paper detected! Please load papers and try again!");
                   //        return;
                   //    }
                   //}

                   DWObject.AcquireImage();
                   
               }
           }
           function UploadImage() {
               if (DWObject) {
                   // If no image in buffer, return the function
                   if (DWObject.HowManyImagesInBuffer == 0)
                       return;

                   var strHTTPServer = location.hostname; //The name of the HTTP server. For example: "www.dynamsoft.com";
                   var CurrentPathName = unescape(location.pathname);
                   var CurrentPath = CurrentPathName.substring(0, CurrentPathName.lastIndexOf("/") + 1);
                   var strActionPage = CurrentPath + "SaveToFile.aspx";
                   DWObject.IfSSL = false; // Set whether SSL is used
                   DWObject.HTTPPort = location.port == "" ? 80 : location.port;

                   var Digital = new Date();
                   var uploadfilename = Digital.getMilliseconds(); // Uses milliseconds according to local time as the file name
                   //'Force name to be WebTWAINImage
                   uploadfilename = 'WebTWAINImage';
                   // Upload the image(s) to the server asynchronously
                       DWObject.HTTPUploadAllThroughPostAsPDF(strHTTPServer, strActionPage, uploadfilename + ".pdf", OnHttpUploadSuccess, OnHttpUploadFailure);

               }
           }
           function OnHttpUploadSuccess() {
               alert('successful ');
               $('[id*=specialId]').trigger("click");
               
           }

           function OnHttpUploadFailure(errorCode, errorString, sHttpResponse) {
               alert(errorString + sHttpResponse);
           }
           function btnUpload_onclick() {
               UploadImage();
           }
    </script>
</asp:Content>
<asp:Content runat="server" ID="content2" ContentPlaceHolderID="ContentPlaceHolder1">

    <asp:Label runat="server" ID="lblLogged"></asp:Label>
    &nbsp; | &nbsp;    
        <a href="User.aspx">Go Back to Main Menu</a>

</asp:Content>
<asp:Content runat="server" ID="content3" ContentPlaceHolderID="ContentPlaceHolder2">
    <div id="dialog-form" title="User Guide">
        <h2>USERS GUIDE</h2>

        <h3>Storing the import documents:</h3>

        1)	Upon receiving an import from U.P.S.:  The U.P.S. and import buttons should be pressed. Then the U.P.S. Entry Number, style number and date of importation should be entered into the appropriate boxes. The date should be entered next. If the exact date of importation is unknown then please enter the approximate date. When this information is entered the submit button should be pressed. No documents are needed to be attached to this submission.
    <br />
        <br />
        2)	Upon receiving an activity report from FedEx: [The activity report from FedEx is received via email or you may get a hard copy by mail. With the activity report comes the import documents.] The FedEx and import buttons should be pressed and the style numbers and date of importation should be copied from the activity report and typed into the appropriate boxes. The activity report should then be up loaded to the system and press submit. If the report is received by mail, it should be scanned into the system and then press submit.

    <h3>Storing the export information:</h3>

        1)	When exporting with U.P.S. or FedEx to countries other than Canada or Mexico; the proper freight carrier and export buttons should be pressed. The tracking number, style number and date of exportation should then be typed into the appropriate boxes. Scan in the commercial invoice and press upload.
    <br />
        <br />
        2)	If the export is to Canada or Mexico; the above procedure should be followed with the addition of scanning and uploading the packing list. The Canadian B3 customs form or the Mexican Pedimento de Importation will also need to be sent, this is attainable from your foreign customs broker.   

    </div>
    <div id="Div1">
        <a href="#anchor" id="User-Guide">Users Guide</a>
        <table>
            <tr>
                <td>Import or Export or Document
                </td>
                <td class="auto-style1">
                    <asp:DropDownList runat="server" ID="ImportorExport">
                        <asp:ListItem Text="" Selected="True"></asp:ListItem>
                        <asp:ListItem Text="Import" Value="Import"></asp:ListItem>
                        <asp:ListItem Text="Export" Value="Export"></asp:ListItem>
                        <asp:ListItem Text="Destroyed" Value="Destroyed"></asp:ListItem>
                        <asp:ListItem Text="Document" Value="Document"></asp:ListItem>
                    </asp:DropDownList>
                </td>

            </tr>
            <tr id="fc">
                <td>Freight Carrier
                </td>
                <td >
                    <asp:DropDownList runat="server" ID="FreightCarrier">
                        <asp:ListItem Text="" Selected="True"></asp:ListItem>
                        <asp:ListItem Text="Fedex" Value="Fedex"></asp:ListItem>                                                
                        <asp:ListItem Text="Sobel" Value="Sobel"></asp:ListItem>
                        <asp:ListItem Text="UPS" Value="UPS"></asp:ListItem>
                    </asp:DropDownList>
                </td>

            </tr>
            
            <tr id="tOReB">
                <td><span id="tORb">Tracking Number</span> 
                </td>
                <td class="auto-style1">
                    <asp:TextBox runat="server" ID="text_tracking_no" Width="210px"></asp:TextBox>
                </td>

            </tr>
            <tr>
                <td>Style Number(s)
                    <br /><span style="font-size:.8em;line-height:1.1em;display:block;">
                    One style per line.<br />You may also enter any information in parenthesis after the style name on the same line</span></td>
                <td class="auto-style1">
                    <asp:TextBox TextMode="MultiLine" CssClass="animated" runat="server" ID="text_style_no" Width="211px" Height="111px" Wrap="False"></asp:TextBox>
                </td>
            </tr>
            <tr>
                <td>Date of Import/Export:
                </td>
                <td class="auto-style1">
                    <asp:TextBox runat="server" CssClass="datepicker" ID="txtDate"></asp:TextBox>
                </td>
            </tr>
            <tr>
                <td>Upload File
                </td>
                <td>
                    <asp:FileUpload ID="fuChooseFile" runat="server" Width="200px" />
                </td>
            </tr>


            <tr>
                <td colspan="2">
                    <input value="Submit" onclick="btnUpload_onclick()" style="width:308px" />
                    <asp:Button runat="server" Visible="true" ID="specialId" />
                    &nbsp;</td>
            </tr>
            <tr>
                <td colspan="4">
                    <asp:Label runat="server" ForeColor="Red" Font-Size="1.3em" ID="lbl"></asp:Label>
                </td>
            </tr>
        </table>

    </div>


</asp:Content>
<asp:Content runat="server" ContentPlaceHolderID="ContentPlaceHolder3">
    <input type="button" value="Scan" onclick="AcquireImage();" style="width: 133px" /><br />
     <a href="#anchor" id="zoom_button">Zoom</a>
    <table id="zoom_form">
        <tr>



            <td rowspan="2" style="border: 1px solid black;">
                <div id="dwtcontrolContainer" class="DWTContainer"></div>
            </td>
        </tr>

    </table>
    <script src="Scripts/dynamsoft.webtwain.config.js"></script>
    <script src="Scripts/dynamsoft.webtwain.initiate.js"></script>

</asp:Content>
