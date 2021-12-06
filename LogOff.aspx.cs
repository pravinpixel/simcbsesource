using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Security;

public partial class LogOff : System.Web.UI.Page
{
    public Utilities utl = null;
    protected void Page_Load(object sender, EventArgs e)
    {
        try
        {
            utl = new Utilities();
            string sqlstr = "update m_loginlogs set LogoutDate=getdate() where userid=" + Session["UserId"].ToString() + " and  LogID=" + Session["LogID"] + "  and SID='" + Session.SessionID + "'";
            utl.ExecuteQuery(sqlstr);
            FormsAuthentication.SignOut();
            Session["User"] = null;
            Session.Abandon();
            Response.Redirect("~/redirect.aspx");
        }
        catch  
        {

            Response.Redirect("~/redirect.aspx");
        }
        
    }
}