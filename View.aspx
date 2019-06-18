<%@ Page Language="VB" AutoEventWireup="false" CodeFile="View.aspx.vb" Inherits="View" MasterPageFile="~/MasterPage.master" MaintainScrollPositionOnPostback="true" %>

<asp:Content runat="server" ID="content1" ContentPlaceHolderID="head">
    <style type="text/css">
        .displaynone {
            display: none;
        }

        .auto-style1 {
            width: 252px;
        }
    </style>


    <script>
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
</asp:Content>
<asp:Content runat="server" ID="content2" ContentPlaceHolderID="ContentPlaceHolder1">

    <asp:Label runat="server" ID="lblLogged"></asp:Label>
    &nbsp; | &nbsp;    
        <a href="User.aspx">Go Back to Main Menu</a>

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
                    Current Location:
                    <asp:Panel ID="pnlCurrentLocation" runat="server" Style="margin-left: 0px">
                    </asp:Panel>
                </div>
                <div>
                    Filter by Style:
                                <asp:TextBox CssClass="txtfilter" runat="server" ID="txtFilter"></asp:TextBox><asp:Button runat="server" CssClass="displaynone" ID="btnSubmit" Text="Submit" /><asp:Button runat="server" ID="btnClr" Text="Clear" />
                </div>
                <div id="scroll">
                    <asp:GridView ID="gvFileSystem" runat="server" AutoGenerateColumns="False"
                        CellPadding="4" DataKeyNames="Type,FullPath,Location,Name" Font-Size="Small"
                        ForeColor="#333333" GridLines="None" OnRowCommand="gvFileSystem_RowCommand"
                        OnRowDataBound="gvFileSystem_RowDataBound"  Width="658px">
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
                            <asp:TemplateField  HeaderText="Status">
                                <ItemTemplate>
                                    <asp:CheckBox runat="server"  ID="chbx" Checked='<%# Convert.ToBoolean(Eval("Approved")) %>' />
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:BoundField DataField="FullPath" ItemStyle-CssClass="displaynone" HeaderStyle-CssClass="displaynone" Visible="true" />
                            <asp:BoundField DataField="Comments" HeaderText="Comments"  HeaderStyle-HorizontalAlign="Left"  />
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

</asp:Content>
