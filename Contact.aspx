<%@ Page Language="VB" AutoEventWireup="false" CodeFile="Contact.aspx.vb" Inherits="Contact" MasterPageFile="~/MasterPage.master" MaintainScrollPositionOnPostback="true" %>

<asp:Content runat="server" ID="content1" ContentPlaceHolderID="head"></asp:Content>
<asp:Content runat="server" ID="content2" ContentPlaceHolderID="ContentPlaceHolder1">
</asp:Content>
<asp:Content runat="server" ID="content3" ContentPlaceHolderID="ContentPlaceHolder2">


    <table id="box">
        <tr>
            <td colspan="2" style="font-size:1.05em;">Please enter your information and click 'Submit'.</td>
        </tr>
        <tr>
            <td>Company Name:
            </td>
            <td>
                <asp:TextBox runat="server" ID="txtName" Width="172px"></asp:TextBox>
            </td>
        </tr>
        <tr>
            <td>Contact Name:
            </td>
            <td>
                <asp:TextBox runat="server" ID="txtContact" Width="172px"></asp:TextBox>
            </td>
        </tr>
        <tr>
            <td>Address:
            </td>
            <td>
                <asp:TextBox runat="server" TextMode="MultiLine" ID="txtAddress" Width="172px"></asp:TextBox>
            </td>
        </tr>
        <tr>
            <td>Phone:
            </td>
            <td>
                <asp:TextBox runat="server" ID="txtPhone" Width="172px"></asp:TextBox>
            </td>
        </tr>
        <tr>
            <td>Email:
            </td>
            <td>
                <asp:TextBox runat="server" ID="txtEmail" Width="172px"></asp:TextBox>
            </td>
        </tr>
        <tr>
            <td>Message:
            </td>
            <td>
                <asp:TextBox runat="server" TextMode="MultiLine" ID="txtMessage" Width="171px"></asp:TextBox>
            </td>
        </tr>
        <tr>
            <td colspan="5">
                <h3>If you'd like to find out if you're eligible for our eDrawback program, please fill out the following questions.</h3>
                <div class="clear" style="height: 10px;"></div>
                <div class="yorn">
                    Does your company import merchandise to the United States?

                </div>
                <asp:RadioButtonList runat="server" ID="q1" RepeatDirection="Horizontal" RepeatLayout="Flow">
                    <asp:ListItem Value="Y"></asp:ListItem>
                    <asp:ListItem Value="N"></asp:ListItem>
                </asp:RadioButtonList>
                <div class="clear"></div>

                <div class="clear" style="height: 10px;"></div>
                <div class="yorn">
                    Which customs broker handles your company’s imports?

                </div>
                <asp:TextBox runat="server" ID="q2" Width="100px"></asp:TextBox>
                <div class="clear"></div>

                <div class="clear" style="height: 10px;"></div>
                <div class="yorn">
                    Approximately what is the import tax rate that your company pays?

                </div>
                <asp:TextBox runat="server" ID="q3" Width="100px"></asp:TextBox>
                <div class="clear"></div>

                <div class="clear" style="height: 10px;"></div>
                <div class="yorn">
                    How much of that duty paid merchandise does your company export?

                </div>
                <asp:TextBox runat="server" ID="q4" Width="100px"></asp:TextBox>
                <div class="clear"></div>

                <div class="clear" style="height: 10px;"></div>
                <div class="yorn">
                    Does your company export to Canada or Mexico?

                </div>
                <asp:RadioButtonList runat="server" ID="q5" RepeatDirection="Horizontal" RepeatLayout="Flow">
                    <asp:ListItem Value="Y"></asp:ListItem>
                    <asp:ListItem Value="N"></asp:ListItem>
                </asp:RadioButtonList>
                <div class="clear"></div>

                <div class="clear" style="height: 10px;"></div>
                <div class="yorn">
                    Which customs broker handles your company’s exports?

                </div>
                <asp:TextBox runat="server" ID="q6" Width="100px"></asp:TextBox>
                <div class="clear"></div>

            </td>
        </tr>
        <tr>
            <td colspan="2">
                <asp:Button runat="server" Text="Submit" OnClick="Unnamed1_Click" Width="240px" />
            </td>

        </tr>
    </table>
    <asp:Label runat="server" ForeColor="Red" ID="lblMsg"></asp:Label>
</asp:Content>
