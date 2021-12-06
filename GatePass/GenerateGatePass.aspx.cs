using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Web.Services;
using System.Globalization;
using System.Data.SqlClient;
using System.Drawing;
using System.Drawing.Printing;
using System.Text.RegularExpressions;
using System.Configuration;

public partial class GatePass_GenerateGatePass : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        Master.chkUser();
        BindDummyRow();
    }

    private void BindDummyRow()
    {
        HiddenField hdnID = (HiddenField)Page.Master.FindControl("hfViewPrm");
        if (hdnID.Value.ToLower() == "true")
        {
            DataTable dummy = new DataTable();
            dummy.Columns.Add("RegNoEmpId");
            dummy.Columns.Add("Name");
            dummy.Columns.Add("ClassDesignation");
            dummy.Columns.Add("Date");
            dummy.Columns.Add("Reason");
            dummy.Columns.Add("From");
            dummy.Columns.Add("To");
            dummy.Columns.Add("ActualInTime");
            dummy.Columns.Add("Option");
            dummy.Columns.Add("View");
            dummy.Columns.Add("Reprint");
            DataRow dr = dummy.NewRow();
            dr["Date"] = "No Records Found";

            dummy.Rows.Add(dr);
            dgPass.DataSource = dummy;
            dgPass.DataBind();
        }
    }

    [WebMethod]
    public static string GetList(string type, string id)
    {
        Utilities utl = new Utilities();
        string sqlstr = "exec SP_GETLISTFORGATEPASS '" + type + "','" + id + "'";
        DataSet ds = new DataSet();
        ds = utl.GetDatasetTable(sqlstr, "Pass");
        return ds.GetXml();
    }

    [WebMethod]
    public static void RePrintGatePass(int GatePassID)
    {
        Utilities utl = new Utilities();

        string sqlstr = "select type from m_gatepass  where GatePassId='" + GatePassID + "' and AcademicID='" + HttpContext.Current.Session["AcademicID"] + "'";
        string type = utl.ExecuteScalar(sqlstr);
        sqlstr = "";
        if (type == "student")
        {
            sqlstr = "select * from m_gatepass a inner join vw_getstudent b on a.regno=b.regno where GatePassId='" + GatePassID + "' and AcademicID='" + HttpContext.Current.Session["AcademicID"] + "'";
        }
        else if (type == "staff")
        {
            sqlstr = "select * from m_gatepass a inner join vw_getstaff b on a.staffid=b.staffid where GatePassId='" + GatePassID + "' and AcademicID='" + HttpContext.Current.Session["AcademicID"] + "'";
        }
        if (sqlstr != "")
        {
            DataSet ds = new DataSet();
            ds = utl.GetDatasetTable(sqlstr, "Pass");
            if (ds != null && ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0)
            {
                sqlstr = "exec SP_ViewGATEPASSList '" + ds.Tables[0].Rows[0]["Type"].ToString() + "','','" + GatePassID + "','" + HttpContext.Current.Session["AcademicID"] + "'";
                DataSet dsnew = new DataSet();
                dsnew = utl.GetDatasetTable(sqlstr, "Pass");
                if (dsnew != null && ds.Tables.Count > 0 && dsnew.Tables[0].Rows.Count > 0)
                {
                    printGatePass(dsnew.Tables[0].Rows[0]["Type"].ToString(), dsnew.Tables[0].Rows[0]["Name"].ToString(), Regex.Replace(dsnew.Tables[0].Rows[0]["BelongsTo"].ToString(), "&amp;", "&"), dsnew.Tables[0].Rows[0]["ID"].ToString(), dsnew.Tables[0].Rows[0]["FormatedDate"].ToString(), dsnew.Tables[0].Rows[0]["InTime"].ToString() + " - " + dsnew.Tables[0].Rows[0]["OutTime"].ToString(), dsnew.Tables[0].Rows[0]["Reason"].ToString());
                }
            }
        }

    }

    [WebMethod]
    public static string ViewGatePass(int GatePassID)
    {
        Utilities utl = new Utilities();
        string sqlstr = "select type from m_gatepass where gatepassid='" + GatePassID + "' and AcademicID='" + HttpContext.Current.Session["AcademicID"] + "'";
        string type=utl.ExecuteScalar(sqlstr);
        DataSet dsnew = new DataSet();
        DataSet ds = new DataSet();
        if (type=="student")
        {
            sqlstr = "select * from m_gatepass a inner join vw_getstudent b on a.regno=b.regno where GatePassId='" + GatePassID + "' and AcademicID='" + HttpContext.Current.Session["AcademicID"] + "'";
          
            ds = utl.GetDatasetTable(sqlstr, "Pass");
          
            if (ds != null && ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0)
            {
                sqlstr = "exec SP_ViewGATEPASSList '" + ds.Tables[0].Rows[0]["Type"].ToString() + "','','" + GatePassID + "','" + HttpContext.Current.Session["AcademicID"] + "'";
                dsnew = utl.GetDatasetTable(sqlstr, "ViewPass");

            }
        }
        else if (type == "staff")
        {
            sqlstr = "select * from m_gatepass a inner join vw_getstaff b on a.staffid=b.staffid where GatePassId='" + GatePassID + "' and AcademicID='" + HttpContext.Current.Session["AcademicID"] + "'";

            ds = utl.GetDatasetTable(sqlstr, "Pass");

            if (ds != null && ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0)
            {
                sqlstr = "exec SP_ViewGATEPASSList '" + ds.Tables[0].Rows[0]["Type"].ToString() + "','','" + GatePassID + "','" + HttpContext.Current.Session["AcademicID"] + "'";
                dsnew = utl.GetDatasetTable(sqlstr, "ViewPass");

            }
        }
      
        return dsnew.GetXml();
    }
    [WebMethod]
    public static string SearchList(string type, string id)
    {
        Utilities utl = new Utilities();
        string sqlstr = "exec SP_ViewGATEPASSList '" + type + "','" + id + "','','" + HttpContext.Current.Session["AcademicID"] + "'"; ;
        DataSet ds = new DataSet();
        ds = utl.GetDatasetTable(sqlstr, "Pass");
        return ds.GetXml();
    }
    [WebMethod]
    public static string UpdateReturnPass(int GatePassID)
    {
        Utilities utl = new Utilities();
        string sqlstr = "update m_gatepass set ActualInTime= '" + System.DateTime.Now.ToString("hh:mm tt") + "' where gatepassid='" + GatePassID + "' and AcademicID='" + HttpContext.Current.Session["AcademicID"] + "'";
         utl.ExecuteQuery(sqlstr);
        return "Updated";
    }
    [WebMethod]
    public static string InsertGatePass(string type, string serialNo, string pid, string Id, string date, string reason, string from, string to, string userId,string classDes,string name)
    {
        Utilities utl = new Utilities();
        string sqlstr = string.Empty;
        string formatedDate=string.Empty;
         string[] formats = { "dd/MM/yyyy" };
        formatedDate = DateTime.ParseExact(date, formats, new CultureInfo("en-US"), DateTimeStyles.None).ToShortDateString();

        if (type.ToLower() == "staff")
            sqlstr = "exec SP_InsertGatePass '" + type + "'," + serialNo + ",null," + pid + ",'" + formatedDate + "','" + reason + "','" + from + "','" + to + "'," + userId + ",'" + HttpContext.Current.Session["AcademicID"] + "'";
        else if (type.ToLower() == "student")
            sqlstr = "exec SP_InsertGatePass '" + type + "'," + serialNo + "," + Id + ",null,'" + formatedDate + "','" + reason + "','" + from + "','" + to + "'," + userId + ",'" + HttpContext.Current.Session["AcademicID"] + "'";
        string strQueryStatus = utl.ExecuteScalar(sqlstr);
        if (strQueryStatus == "")
        {
            string sId=string.Empty;
            //if (type.ToLower() == "staff")
            //{
            //    sId=pid;
            //}
            // else if (type.ToLower() == "student")
            //{
            //     sId=Id;
            // }
            printGatePass(type, name, Regex.Replace(classDes, "&amp;", "&")
, Id, date, from + " - " + to, reason);
            return "";

        }
        else
            return strQueryStatus;
    }

    [WebMethod]
    public static string GetGatePassID()
    {
        Utilities utl = new Utilities();
        string query = "Select isnull(count(GatePassId)+ 1,1)as  GatePassId from m_gatepass where AcademicID='" + HttpContext.Current.Session["AcademicID"] + "' and isactive=1";
        return utl.GetDatasetTable(query,"GatePassIDs").GetXml();

    }

    public static void printGatePass(string type, string name, string desClass, string id, string dateOfPermission, string timePermission, string reason)
    {
        string idName = string.Empty;
        string classDesName = string.Empty;

        if (type.ToLower() == "staff")
        {
            idName = "Emp Code";
            classDesName = "Designation";
        }
        else if(type.ToLower()=="student")
        {
            idName = "Reg No";
            classDesName = "Class & Sec";
        }

        try
        {
            Utilities utl = new Utilities();
            PrintDocument fd = new PrintDocument();
            string SlipType = string.Empty;
            string query = "[sp_schoolDetails] ";
            DataSet dsPrint = utl.GetDataset(query);
            string printerName = ConfigurationManager.AppSettings["FeesPrinter"];
            string clientMachineName, clientIPAddress;
            //  clientMachineName = (Dns.GetHostEntry(Request.ServerVariables["remote_addr"]).HostName);
            clientIPAddress = HttpContext.Current.Request.ServerVariables["remote_addr"];


            if (dsPrint != null && dsPrint.Tables.Count > 0 && dsPrint.Tables[0].Rows.Count > 0)
            {
                StringFormat stringAlignRight = new StringFormat();
                stringAlignRight.Alignment = StringAlignment.Far;
                stringAlignRight.LineAlignment = StringAlignment.Center;

                StringFormat stringAlignLeft = new StringFormat();
                stringAlignLeft.Alignment = StringAlignment.Near;
                stringAlignLeft.LineAlignment = StringAlignment.Center;

                StringFormat stringAlignCenter = new StringFormat();
                stringAlignCenter.Alignment = StringAlignment.Center;
                stringAlignCenter.LineAlignment = StringAlignment.Center;
                int ypos = 0;

                fd.PrintPage += (s, args) =>
                {
                    if (dsPrint.Tables[0].Rows.Count > 0)
                    {
                        args.Graphics.DrawString(dsPrint.Tables[0].Rows[0]["SchoolShortName"].ToString().ToUpper(), new System.Drawing.Font("ARIAL", 9, FontStyle.Regular), Brushes.Black, new Rectangle(0, 0, 250, 25), stringAlignCenter);
                        args.Graphics.DrawString(dsPrint.Tables[0].Rows[0]["Schoolstate"].ToString().ToUpper() + "-" + dsPrint.Tables[0].Rows[0]["SchoolZip"].ToString() + " PHONE NO-" + dsPrint.Tables[0].Rows[0]["phoneno"].ToString().ToUpper(), new System.Drawing.Font("ARIAL", 8, FontStyle.Regular), Brushes.Black, new Rectangle(0, 20, 250, 25), stringAlignCenter);

                        args.Graphics.DrawLine(new Pen(Color.Black, 2), 0, 45, 500, 45);

                        args.Graphics.DrawString("GATE PASS FOR - " + type.ToUpper() + "", new System.Drawing.Font("Arial", 9, FontStyle.Underline), Brushes.Black, new Rectangle(0, 40, 250, 50), stringAlignCenter);

                        args.Graphics.DrawString("Name & " + idName + "", new System.Drawing.Font("Arial", 9, FontStyle.Regular), Brushes.Black, new Rectangle(0, 80, 90, 50), stringAlignLeft);
                        args.Graphics.DrawString(":", new System.Drawing.Font("Arial", 9, FontStyle.Regular), Brushes.Black, new Rectangle(120, 80, 20, 50), stringAlignLeft);
                        args.Graphics.DrawString(name+" & "+ id, new System.Drawing.Font("Arial", 9, FontStyle.Regular), Brushes.Black, new Rectangle(135, 80, 140, 50), stringAlignLeft);

                        args.Graphics.DrawString(""+classDesName+" ", new System.Drawing.Font("Arial", 9, FontStyle.Regular), Brushes.Black, new Rectangle(0, 105, 90, 50), stringAlignLeft);
                        args.Graphics.DrawString(":", new System.Drawing.Font("Arial", 9, FontStyle.Regular), Brushes.Black, new Rectangle(120, 105, 20, 50), stringAlignLeft);
                        args.Graphics.DrawString(desClass, new System.Drawing.Font("Arial", 9, FontStyle.Regular), Brushes.Black, new Rectangle(135, 105, 140, 50), stringAlignLeft);

                        args.Graphics.DrawString("Permission Date", new System.Drawing.Font("Arial", 9, FontStyle.Regular), Brushes.Black, new Rectangle(0, 140, 90, 50), stringAlignLeft);
                        args.Graphics.DrawString(":", new System.Drawing.Font("Arial", 9, FontStyle.Regular), Brushes.Black, new Rectangle(120, 140, 20, 50), stringAlignLeft);
                        string[] formats = { "dd/MM/yyyy" };

                        dateOfPermission = DateTime.ParseExact(dateOfPermission, formats, new CultureInfo("en-UK"), DateTimeStyles.None).ToShortDateString();

                        args.Graphics.DrawString(dateOfPermission, new System.Drawing.Font("Arial", 9, FontStyle.Regular), Brushes.Black, new Rectangle(135, 140, 140, 50), stringAlignLeft);

                        args.Graphics.DrawString("Permission Time ", new System.Drawing.Font("Arial", 9, FontStyle.Regular), Brushes.Black, new Rectangle(0, 175, 90, 50), stringAlignLeft);
                        args.Graphics.DrawString(":", new System.Drawing.Font("Arial", 9, FontStyle.Regular), Brushes.Black, new Rectangle(120, 175, 20, 50), stringAlignLeft);
                        args.Graphics.DrawString(timePermission, new System.Drawing.Font("Arial", 9, FontStyle.Regular), Brushes.Black, new Rectangle(135, 175, 140, 50), stringAlignLeft);

                        args.Graphics.DrawString("Reason", new System.Drawing.Font("Arial", 9, FontStyle.Regular), Brushes.Black, new Rectangle(0, 210, 140, 50), stringAlignLeft);
                        args.Graphics.DrawString(":", new System.Drawing.Font("Arial", 9, FontStyle.Regular), Brushes.Black, new Rectangle(120, 210, 20, 50), stringAlignLeft);
                        args.Graphics.DrawString(reason, new System.Drawing.Font("Arial", 9, FontStyle.Regular), Brushes.Black, new Rectangle(135, 210, 140, 50), stringAlignLeft);

                        args.Graphics.DrawLine(new Pen(Color.Black, 2), 0, 290, 500, 290);

                        args.Graphics.DrawString("Signature of incharge ", new System.Drawing.Font("Arial", 9, FontStyle.Regular), Brushes.Black, new Rectangle(0, 330, 110, 50), stringAlignLeft);
                        args.Graphics.DrawString("Signature of security", new System.Drawing.Font("Arial", 9, FontStyle.Regular), Brushes.Black, new Rectangle(100, 330, 140, 50), stringAlignRight);
                        args.Graphics.DrawString("Signature of " + type + "", new System.Drawing.Font("Arial", 9, FontStyle.Regular), Brushes.Black, new Rectangle(0, 380, 250, 50), stringAlignRight);

                        args.Graphics.DrawLine(new Pen(Color.Black, 2), 0, 430, 500, 430);
                    }
                };
                fd.PrinterSettings.PrinterName = "\\\\" + clientIPAddress + "\\" + printerName + "";
                fd.Print();
            }

        }
        catch (Exception err)
        {


        }
        finally { }
    }
}