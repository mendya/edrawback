
Partial Class ViewDoc
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load
        hdnCompany.Value = Context.Request.QueryString("company")
        hdnStyle.Value = Context.Request.QueryString("style")
        hdnDate.Value = Context.Request.QueryString("date")
        hdnFullFile.Value = Context.Request.QueryString("FullFile")
    End Sub
End Class
