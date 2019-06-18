<%@ Page Language="VB" AutoEventWireup="false" CodeFile="ViewDoc.aspx.vb" Inherits="ViewDoc" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
        <script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jquery/1.11.1/jquery.min.js"></script>

      <script>
        /*<![CDATA[*/
        $(document).ready(function () {
            //$('a.embed').gdocsViewer({ width: 600, height: 750 });
            //$('#embedURL').gdocsViewer();
            //$('#embedURL2').gdocsViewer();
            //$("#embed").attr("src", "http://www.edrawbacks.com/pdf.pdf?rand=" + Math.floor(Math.random() * 100001));
            
            $("#embedtd").replaceWith("<td id='embedtd'><embed id='embed' src='" + 'http://www.edrawbacks.com/docroot/' + '<%= hdnCompany.Value%>' + '/' + '<%= hdnStyle.Value%>' + '/' + '<%= hdnFullFile.Value%>' + '/' + '<%= hdnFullFile.Value%>' + ".pdf' width='600' height='480' type='application/pdf'></td>");
            $("[id*='ddlinfoimport']").change(function () {
                $("#embedtd").replaceWith("<td id='embedtd'><embed id='embed' src='" + 'http://www.edrawbacks.com/docroot/' + '<%= hdnCompany.Value%>' + '/' + '<%= hdnStyle.Value%>' + '/' + '<%= hdnFullFile.Value%>'  + '/' + '<%= hdnFullFile.Value%>' + ".pdf' width='600' height='480' type='application/pdf'></td>");
            });
        });
        /*]]>*/        

    </script>
</head>
<body>
    <form id="form1" runat="server">
    <div>
        <table>
            <tr>
                <td id="embedtd" style="vertical-align: top;">
                    
                </td>
            </tr>
        </table>
    </div>
        <asp:HiddenField ID="hdnCompany" runat="server" />
        <asp:HiddenField ID="hdnStyle" runat="server" />
        <asp:HiddenField ID="hdnDate" runat="server" />
        <asp:HiddenField ID="hdnFullFile" runat="server" />
    </form>
</body>
</html>
