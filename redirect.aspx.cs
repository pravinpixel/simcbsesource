using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Security;

public partial class redirect : System.Web.UI.Page
{
    Utilities utl = null;
    string academicid = "";

    protected void Page_Load(object sender, EventArgs e)
    {
        if (Request.QueryString["userid"] != null)
        {
            if (Request.QueryString["redirecturl"] != null)
            {
                Session["UserId"] = Request.QueryString["userid"].ToString();

                string redirecturl_all = Request.QueryString["redirecturl"];
                string redirecturl = redirecturl_all.Replace("@", "&");


                utl = new Utilities();
                academicid = utl.ExecuteScalar("select top 1 academicid from m_academicyear where isactive=1 order by academicid asc");
                if (academicid != "")
                {
                    Session["AcademicID"] = academicid.ToString();
                }
                Response.Redirect("~/" + redirecturl + "&AcademicYear=" + Session["AcademicID"].ToString() + "");
            }
            else
            {
                Session["UserId"] = Request.QueryString["userid"].ToString();

                utl = new Utilities();
                academicid = utl.ExecuteScalar("select top 1 academicid from m_academicyear where isactive=1 order by academicid asc");
                if (academicid != "")
                {
                    Session["AcademicID"] = academicid.ToString();
                }
                Response.Redirect("~/Users/Dashboard.aspx?moduleId=-1&AcademicYear=" + Session["AcademicID"].ToString() + "");
            }

        }
    }
}