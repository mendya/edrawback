<%@ Page Language="VB" AutoEventWireup="false" CodeFile="Documents.aspx.vb" Inherits="Documents" MasterPageFile="~/MasterPage.master" %>

<asp:Content runat="server" ID="content1" ContentPlaceHolderID="head">
    <script src="Scripts/jquery.autogrow-textarea.js"></script>
    <script src="Scripts/jquery.leanModal.min.js"></script>
    <script src="Scripts/jquery.uploadfile.min.js"></script>
    <link href="Styles/uploadfile.min.css" rel="stylesheet" />
    <script type="text/javascript">


        $(document).ready(function () {
            $("#header").hide();
            $('textarea').autogrow({ onInitialize: true });
            $(function () {
                $("#Permission_Letter_trigger").click(function (e) {
                    $("#Permission_Letter_btn_submit").show();
                    $("#Permission_Letter_btn_cancel").prop('value', 'Cancel');
                    $("#Permission_Letter_msg").html('');
                });
                $("#Drawback_Questionnaire_trigger").click(function (e) {
                    $("#Drawback_Questionnaire_btn_submit").show();
                    $("#Drawback_Questionnaire_btn_cancel").prop('value', 'Cancel');
                    $("#Drawback_Questionnaire_msg").html('');
                });
                $('#Permission_Letter_btn_submit').click(function (e) {
                    $("input,textarea").each(function () {
                        $(this).attr("value", $(this).val());
                    });

                    urlToHandler = 'submit_permission.ashx';
                    $.ajax({
                        url: urlToHandler,
                        data: $("#p_to").val() + "|" + $("#p_body").html() + "|" + $("#p_emailaddr_from").val() + "|" + $("#p_emailaddr_to").val() + "|" + $("#yname").val(),
                        async: true,
                        dataType: 'json',
                        type: 'POST',
                        contentType: 'application/json',
                        success: function (data) {
                            $("#Permission_Letter_msg").html('Email Sent!');
                            $("#Permission_Letter_btn_submit").hide();
                            $("#Permission_Letter_btn_cancel").prop('value', 'Close');
                            
                        },
                        error: function (data, status, jqXHR) {
                            alert('There was an error.');

                        }
                    }); // end $.ajax
                    return false;
                });
                $('#Drawback_Questionnaire_btn_submit').click(function (e) {

                    $("#Drawback_Questionnaire :input,#Drawback_Questionnaire textarea").replaceWith(function () {
                        return '<span style="font-weight:bold;" class=' + this.classname + '>' + this.value + '</span></br>'
                    });
                    var filenames = "",f = "";
                    $(".ajax-file-upload-filename").each(function () {
                        filenames += $(this).html() + "|";
                    });
                    urlToHandler = 'submit_questionnaire.ashx?files=' + filenames + '&un=' + username;
                    $.ajax({
                        url: urlToHandler,
                        data: $("#Drawback_Questionnaire").html(),
                        async: true,
                        dataType: 'json',
                        type: 'POST',
                        contentType: 'application/json',
                        success: function (data) {
                            $("#Drawback_Questionnaire_msg").html('Email Sent!');
                            $("#Drawback_Questionnaire_btn_submit").hide();
                            $("#Drawback_Questionnaire_btn_cancel").prop('value', 'Close');
                            $("#Drawback_Questionnaire").animate({ scrollTop: $(document).height() }, "slow");
                        },
                        error: function (data, status, jqXHR) {
                            alert('There was an error.');

                        }
                    }); // end $.ajax
                    return false;
                });

                $('#Drawback_Questionnaire_trigger').leanModal({ top: 110, overlay: 0.45, closeButton: ".hidemodal" });
                $('#Permission_Letter_btn_submit').click(function (e) {

                    return false;
                });

                $('#Permission_Letter_trigger').leanModal({ top: 110, overlay: 0.45, closeButton: ".hidemodal" });
                $('#Exhibit_btn_submit').click(function (e) {

                    return false;
                });

                $('#Exhibits_trigger').leanModal({ top: 110, overlay: 0.45, closeButton: ".hidemodal" });
                $('#EDAgreement_btn_submit').click(function (e) {

                    return false;
                });

                $('#EDAgreement_trigger').leanModal({ top: 110, overlay: 0.45, closeButton: ".hidemodal" });
            });
            
            $("#singleupload").uploadFile({
                url: "http://www.edrawbacks.com/fileupload.ashx",
                allowedTypes: "pdf,doc,docx",
                fileName: "myfile",
                formData: username,
                onSuccess: function (files, data, xhr)                    
                {
                    $.each(files, function (index, file) {
                        //alert(file);
                    });
                }
            });
            $("#singleupload2").uploadFile({
                url: "http://www.edrawbacks.com/fileupload.ashx",
                allowedTypes: "pdf,doc,docx",
                fileName: "myfile",
                formData: username
            });
            $("#singleupload3").uploadFile({
                url: "http://www.edrawbacks.com/fileupload.ashx",
                allowedTypes: "pdf,doc,docx",
                fileName: "myfile",
                formData: username
            });
            $("#singleupload4").uploadFile({
                url: "http://www.edrawbacks.com/fileupload.ashx",
                allowedTypes: "pdf,doc,docx",
                fileName: "myfile",
                formData: username
            });
        });
    </script>
    <link href="Styles/leanmodal.css" rel="stylesheet" />
    <style type="text/css">
        .checkmark {
            display: inline-block;
            width: 22px;
            height: 22px;
            -ms-transform: rotate(45deg); /* IE 9 */
            -webkit-transform: rotate(45deg); /* Chrome, Safari, Opera */
            transform: rotate(45deg);
        }

        .checkmark_circle {
            position: absolute;
            width: 22px;
            height: 22px;
            background-color: green;
            border-radius: 11px;
            left: 0;
            top: 0;
        }

        .checkmark_stem {
            position: absolute;
            width: 3px;
            height: 9px;
            background-color: #fff;
            left: 11px;
            top: 6px;
        }

        .checkmark_kick {
            position: absolute;
            width: 3px;
            height: 3px;
            background-color: #fff;
            left: 8px;
            top: 12px;
        }
        .h1 {
            font-size:1.3em;
            font-weight:bold;
        }
        textarea { outline: none; }
        .bold {
            font-weight:bold;
        }
    </style>
</asp:Content>
<asp:Content runat="server" ID="content2" ContentPlaceHolderID="ContentPlaceHolder1">
    <asp:Label runat="server" ID="lblLogged"></asp:Label>
    &nbsp; | &nbsp;    
        <a href="user.aspx">Go Back to Main Menu</a>
</asp:Content>
<asp:Content runat="server" ID="content3" ContentPlaceHolderID="ContentPlaceHolder2">
    <div>
        In order to startup your company, you will need to complete the following things:
    </div>
    <span class="checkmark">
        <div class="checkmark_circle"></div>
        <div class="checkmark_stem"></div>
        <div class="checkmark_kick"></div>
    </span>
    <a href="#EDAgreement" id="EDAgreement_trigger">eD Agreement</a><br />    
    <span class="checkmark">
        <div class="checkmark_circle"></div>
        <div class="checkmark_stem"></div>
        <div class="checkmark_kick"></div>
    </span>
    <a href="#Permission_Letter" id="Permission_Letter_trigger">Permission Letter for Importer/Broker</a><br />        
    <span class="checkmark">
        <div class="checkmark_circle"></div>
        <div class="checkmark_stem"></div>
        <div class="checkmark_kick"></div>
    </span>
    <a href="#Drawback_Questionnaire"  id="Drawback_Questionnaire_trigger">Drawback Questionnaire</a><br />    
    <span class="checkmark">
        <div class="checkmark_circle"></div>
        <div class="checkmark_stem"></div>
        <div class="checkmark_kick"></div>
    </span>
    <a href="#Exhibits" id="Exhibits_trigger">Exhibits for special priveleges</a><br />
    <div id="EDAgreement" style="display:none;">
        <h4>Please download the ED Agreement, fill out sign and upload back to us.</h4><h4><a href="ed_agreement.docx" target="_blank">Click here to download.</a> </h4>
         
        <div id="singleupload3">Upload</div>
    </div>
    <div id="Exhibits" style="display: none;">
        <div style="height: 500px; overflow: scroll;">
            <h4>The customs wants to see that you can track your documents from the time you order<br />
                from your supplier until the time you export it to your client.
                <br />
                It may be easier to find all these documents after you uploaded all your documents onto our system.</h4>
            <h4>Please upload the following list of documents for any one style number.</h4>
            <ol style="list-style-type: decimal">
                <li>Your company’s purchase order, indicating the item, and your supplier</li>
                <li>Shipper’s invoice and packing list</li>
                <li>Import bill of lading</li>
                <li>Import customs entry</li>
                <li>Receiving report</li>
                <li>Inventory report, showing that the item is in inventory</li>
                <li>Purchase order from your customer</li>
                <li>Your export invoice and packing list</li>
                <li>Export bill of lading (master) with original signature from the airline or steamship line</li>
                <li>Inventory report showing the item is withdrawn from inventory</li>
                <li>If shipment is to Canada, the Canadian B3 customs entry</li>

            </ol>
            <div id="singleupload2">Upload</div>

            <h4>Once you have received the permission letter please upload here</h4>
            <div id="singleupload4">Upload</div>
        </div>
    </div>
    <div id="Permission_Letter" style="display:none;">
        To:  <input type="text" size="30" value="Customhouse Brokers" id="p_to" /> <br />


        <div id="p_body">
            We have arranged with eDrawback LLC to prepare documents and drawback entries on our behalf.<br />
            Our contact at eDrawback is Shmuel Mermelstein, email address: shmuelm@edrawbacks.com 
        <br />
            Please send him the following documents for the past 2.5 years.
        <ul>
            <li>The shipper's invoices</li>
            <li>Packing lists</li>
            <li>The corresponding CBP7501's</li>
        </ul>




            Thank you.<br />

            
        </div>
        Your Name: <input type="text" id="yname" />
        <h4>Email address to send from : <input size="35" type="text" id="p_emailaddr_from" /></h4>
        <h4>Email address(es) to send to : <input size="35" type="text" id="p_emailaddr_to" /></h4>
                    <div class="center">
                <input type="button" name="Permission_Letter_btn_submit" id="Permission_Letter_btn_submit" class="flatbtn-blu " value="Submit" tabindex="3" />
                <input type="button"  class="flatbtn-blu hidemodal" value="Cancel" tabindex="3" id="Permission_Letter_btn_cancel" />
                        <h1 style="color:red;font-weight:bold;" id="Permission_Letter_msg"></h1>
            </div>

    </div>
    <div id="Drawback_Questionnaire" style="display: none;">
        <div style="height:500px;overflow:scroll;">
            <h1>Drawback Questionnaire</h1>
            <label for="companyname">Name of company applying for Drawback:</label>
            <input type="text" name="companyname" id="companyname" class="txtfield" tabindex="1" />

            <label for="corporateaddress">Corporate address:</label>
            <textarea name="corporateaddress" id="corporateaddress" class="txtfield" tabindex="2" ></textarea>

            <label for="einnumber">EIN Number:</label>
            <input type="text" name="einnumber" id="einnumber" class="txtfield" tabindex="2" />

            <h1>Main company contact for Drawback:</h1>

            <label for="contactname">Name</label>
            <input type="text" name="contactname" id="contactname" class="txtfield" tabindex="2" />

            <label for="password">Title</label>
            <input type="text" name="contacttitle" id="contacttitle" class="txtfield" tabindex="2" />

            <label for="password">Address (if different then above)</label>
            <textarea name="contactaddress" id="contactaddress" class="txtfield" tabindex="2" ></textarea>

            <label for="password">Phone</label>
            <input type="text" name="contactphone" id="contactphone" class="txtfield" tabindex="2" />

            <label for="contactdescribe">Describe the nature of your business<br /> with specific reference to claims for the drawback.<br />(Example: We import shirts from china and export to brazil)</label>
            <textarea name="contactdescribe" id="contactdescribe" class="txtfield" tabindex="2" ></textarea>

            <label for="contactwhere">Where and how will the records to support<br /> the drawback claims be maintained?</label>
            <textarea name="contactwhere" id="contactwhere" class="txtfield" tabindex="2" ></textarea>

            <h1>Types of Drawback:</h1>

            <label for="TODcanadaormexico">Do you export to Canada or Mexico?</label>
            <input type="text" name="TODcanadaormexico" id="TODcanadaormexico" class="txtfield" tabindex="2" />

            <label for="TODcommercial">Do you have a ruling of commercial<br /> interchangeability?<br />(Merchandise which may be substituted under the <br />substitution unused merchandise drawback law)</label>
            <input type="text" name="TODcommercial" id="TODcommercial" class="txtfield" tabindex="2" />

            If you answered yes:<br />
            <label for="TODexact">Do you export the exact item you import?<br />(or do you make enhancements)</label>
            <input type="text" name="TODexact" id="TODexact" class="txtfield" tabindex="2" />

            <label for="TODfuture">Do you want to apply for future Drawbacks?<br /></label>
            <input type="text" name="TODfuture" id="TODfuture" class="txtfield" tabindex="2" />

            <label for="TODpast">Do you want to apply for past Drawbacks?<br />(If you wish to apply for past drawbacks please fill out <br />"Past Drawback" section below. If you are applying only <br /> for future drawbacks you can skip that section.)<br /></label>
            <input type="text" name="TODpast" id="TODpast" class="txtfield" tabindex="2" />
            
            <label for="TODreason">Provide the reason that Customs and <br />Border Protection was not timely notified of the intent <br />to export merchandise covered by this application?<br />(Example: I did not know I can apply.)<br /></label>
            <input type="text" name="TODreason" id="TODreason" class="txtfield" tabindex="2" />

            <h1>Merchandise Covered by this application</h1>

            <label for="Merchtypes">What types of product are you importing/exporting <br /> and looking to claim duty back on?</label>
            <input type="text" name="Merchtypes" id="Merchtypes" class="txtfield" tabindex="2" />

            <label for="Merchdiff">Does your product SKU number change from import to export?</label>
            <input type="text" name="Merchdiff" id="Merchdiff" class="txtfield" tabindex="2" />

            <label for="Merchdiffphy">Does the item you import differ physically <br />(other than packaging) in any substantive way <br />then the item you are exporting? If Yes, How?</label>
            <textarea name="Merchdiffphy" id="Merchdiffphy" class="txtfield" tabindex="2" ></textarea>

            <label for="Merchreason">Provide the reason for these differences, if any?<br />(Example: We assemble parts from multiple sources.)</label>
            <input name="Merchreason" id="Merchreason" class="txtfield" tabindex="2" />

            <label for="Merchcntry">What is the country/countries of origin of your products?</label>
            <input name="Merchcntry" id="Merchcntry" class="txtfield" tabindex="2" />

            <h1>Exporting Information</h1>

            <label for="Exportnum">What is the approximate number of exports you anticipate<br />in the next 12 months?</label>
            <input name="Exportnum" id="Exportnum" class="txtfield" tabindex="2" />

            <label for="Exportdol">What is the estimated cost of goods that you <br />will export in the next 12 months?</label>
            <input name="Exportdol" id="Exportdol" class="txtfield" tabindex="2" />

            <label for="Exportport">Which ports of export do you anticipate using<br />over the next 12 months?</label>
            <input name="Exportport" id="Exportport" class="txtfield" tabindex="2" />

            <label for="Exportact">Is your company the actual Exporter?<br />If not, name the exporter.</label>
            <input name="Exportact" id="Exportact" class="txtfield" tabindex="2" />

            <label for="Exportaddr">Address of Exporter</label>
            <input name="Exportaddr" id="Exportaddr" class="txtfield" tabindex="2" />

            <label for="Exportein">EIN Number of Exporter</label>
            <input name="Exportein" id="Exportein" class="txtfield" tabindex="2" />

            <label for="Exportwaiver">Are you able to obtain a waiver from the Exporter in <br />which it waives its' right to claim drawback?</label>
            <input name="Exportwaiver" id="Exportwaiver" class="txtfield" tabindex="2" />

            <h1>Past Drawbacks</h1>

            <label for="PDnum">How many exports did you have in the past 3 years?</label>
            <input name="PDnum" id="PDnum" class="txtfield" tabindex="2" />

            <label for="PDdol">What is the approximate dollar amount that you exported<br />in the past 3 years?</label>
            <input name="PDdol" id="PDdol" class="txtfield" tabindex="2" />

            <label for="PDports">Which ports did you export from?</label>
            <input name="PDports" id="PDports" class="txtfield" tabindex="2" />

            <label for="PDactual">Is your company the actual exporter?</label>
            <input name="PDactual" id="PDactual" class="txtfield" tabindex="2" />

            <label for="PDname">If not, Name of Exporter?</label>
            <input name="PDname" id="PDname" class="txtfield" tabindex="2" />

            <label for="PDaddr">Address of Exporter</label>
            <input name="PDaddr" id="PDaddr" class="txtfield" tabindex="2" />

            <label for="PDein">EIN Number of Exporter</label>
            <input name="PDein" id="PDein" class="txtfield" tabindex="2" />

            <label for="PDwaiver">Are you able to obtain a waiver from the Exporter in <br />which it waives its' right to claim drawback?</label>
            <input name="PDwaiver" id="PDwaiver" class="txtfield" tabindex="2" />

            <label for="PDlong">How long will it take to gather the information in order<br /> to claim those drawbacks?</label>
            <input name="PDlong" id="PDlong" class="txtfield" tabindex="2" />

            <h1>Drawback History</h1>


            <h5>A waiver of prior notice allows the filing of drawback claims on future <br />exports without Customs having to supervise the exportation.</h5>

            <label for="DHapproved">Have you ever been approved for a waiver of prior notice<br /> by any drawback office?</label>
            <input name="DHapproved" id="DHapproved" class="txtfield" tabindex="2" />

            <label for="DHdenied">Have you ever been denied a waiver of prior notice<br /> by any drawback office?</label>
            <input name="DHdenied" id="DHdenied" class="txtfield" tabindex="2" />

            <label for="DHrevoked">Have you ever had a waiver of prior notice<br /> revoked by any drawback office?</label>
            <input name="DHrevoked" id="DHrevoked" class="txtfield" tabindex="2" />

            <label for="DHrenew">Is this a request to renew a previously approved <br />waiver of prior notice by any drawback office?</label>
            <input name="DHrenew" id="DHrenew" class="txtfield" tabindex="2" />

            <h5>Accelerated Payment allows for payment of drawback claim within<br /> three to four weeks of filing.</h5>

            <label for="DHap">Has the applicant ever been approved for accelerated payment<br />of a drawback by any drawback office?</label>
            <input name="DHap" id="DHap" class="txtfield" tabindex="2" />

            <label for="DHapdenied">Has the applicant ever been denied for accelerated payment<br />of a drawback by any drawback office?</label>
            <input name="DHapdenied" id="DHapdenied" class="txtfield" tabindex="2" />

            <label for="DHaprev">Has the applicant ever had an approval for accelerated payment<br />of a drawback revoked by any drawback office?</label>
            <input name="DHaprev" id="DHaprev" class="txtfield" tabindex="2" />

            <label for="DHperm">Is this a request to renew a previously approved permission?</label>
            <input name="DHperm" id="DHperm" class="txtfield" tabindex="2" />

            <h5>If yes, attach permission letter</h5><div id="singleupload">Upload</div>

            <div class="center">
                <input type="button" name="Drawback_Questionnaire_btn_submit" id="Drawback_Questionnaire_btn_submit" class="flatbtn-blu " value="Submit" tabindex="3" />
                <input type="button"  class="flatbtn-blu hidemodal" value="Cancel" id="Drawback_Questionnaire_btn_cancel" tabindex="3" />
                <h1 style="color:red;font-weight:bold;" id="Drawback_Questionnaire_msg"></h1>
            </div>


        </div>
    </div>
    <asp:HiddenField ID="username" runat="server"  />

</asp:Content>

