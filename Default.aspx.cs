using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Data.SqlClient;
using System.Web.Services;
using System.Configuration;
using System.Globalization;
using System.Drawing.Printing;
using System.Drawing;
using System.Text;
using System.Web.Security;

public partial class _Default : System.Web.UI.Page
{
    Utilities utl = null;
    string  academicid = "";
    CryptoSystem cry = new CryptoSystem();
    protected void Page_Load(object sender, EventArgs e)
    {
       // cry.Decrypt("FYjdXm2XpGH0POJ6YwNoNw==");
        
        if (Request.IsAuthenticated && Session["UserId"] != null)
        {
            utl = new Utilities();
            academicid = utl.ExecuteScalar("select top 1 academicid from m_academicyear where isactive=1 order by academicid asc");
            if (academicid != "")
            {
                Session["AcademicID"] = academicid.ToString();
            }
            Response.Redirect("~/Users/Dashboard.aspx?moduleId=-1&AcademicYear=" + Session["AcademicID"].ToString() + "");
        }
    }

    protected void btnSubmit_Click(object sender, EventArgs e)
    {
        CryptoSystem crypt = new CryptoSystem();
        string password = crypt.Encrypt(txtPassword.Text);
        if (Page.IsValid)
        {
            int userId = IUser.AuthenticateUser(txtUserName.Text, password);
            if (userId != -1)
            {
                Session["UserId"] = userId;
                utl = new Utilities();
                academicid = utl.ExecuteScalar("select top 1 academicid from m_academicyear order by academicid asc");
                  if (academicid != "")
                  {
                      Session["AcademicID"] = academicid.ToString();
                  }
                  string sqlstr = "INSERT INTO m_loginlogs (UserID,SID,LoginDate)VALUES (" + userId + ",'"+Session.SessionID +"',getdate())";
                  utl.ExecuteQuery(sqlstr);

                FormsAuthentication.RedirectFromLoginPage(txtUserName.Text, false);
            }
            else
                lblError.Text = "Invalid Username and password";
        }
    }
}