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
using System.IO;

using System.Globalization;

public partial class Reports_DayBookReport : System.Web.UI.Page
{
    Utilities utl = null;
    public static int Userid = 0;
    
    protected void Page_Load(object sender, EventArgs e)
    {
        Master.chkUser();
        if (Session["UserId"] == null || Session["AcademicID"] == null)
        {

            Response.Redirect("Default.aspx?ses=expired");
        }
        else
        {
            if (!IsPostBack)
            {
                txtStartdate.Text = System.DateTime.Now.ToString("dd/MM/yyyy");
            }
            else
            {
                 
            }
        }
    }
    protected void Page_UnLoad(object sender, EventArgs e)
    {
        //reportdocument.Dispose();
        //GC.Collect();
    }
    protected void btnSearch_Click(object sender, EventArgs e)
    {
        if (txtStartdate.Text != "")
        {
            lblDate.Text = txtStartdate.Text;
            DataSet DataSet1 = new DataSet();
            utl = new Utilities();
            DataSet1 = utl.GetDataset("sp_getDailyCollection '" + txtStartdate.Text + "','" + Session["AcademicID"] + "'");
            decimal netAmount = 0;
            decimal netInHand = 0;
            if (DataSet1.Tables[0].Rows[0][0].ToString() != "")
            {
                lbllkgAdminAcc.Text = DataSet1.Tables[0].Rows[0][0].ToString();
                netAmount += Convert.ToDecimal(DataSet1.Tables[0].Rows[0][0].ToString());
            }
            else
            {
                lbllkgAdminAcc.Text = "0.00";
            }

            if (DataSet1.Tables[1].Rows[0][0].ToString() != "")
            {
                lblPrePrimAcc.Text = DataSet1.Tables[1].Rows[0][0].ToString();
                netAmount += Convert.ToDecimal(DataSet1.Tables[1].Rows[0][0].ToString());
            }
            else
            {
                lblPrePrimAcc.Text = "0.00";
            }

            if (DataSet1.Tables[2].Rows[0][0].ToString() != "")
            {
                lblPrimAcc.Text = DataSet1.Tables[2].Rows[0][0].ToString();
                netAmount += Convert.ToDecimal(DataSet1.Tables[2].Rows[0][0].ToString());
            }
            else
            {
                lblPrimAcc.Text = "0.00";
            }

            if (DataSet1.Tables[3].Rows[0][0].ToString() != "")
            {
                lblHighSchAcc.Text = DataSet1.Tables[3].Rows[0][0].ToString();
                netAmount += Convert.ToDecimal(DataSet1.Tables[3].Rows[0][0].ToString());
            }
            else
            {
                lblHighSchAcc.Text = "0.00";
            }

            if (DataSet1.Tables[4].Rows[0][0].ToString() != "")
            {
                lblHighSecAcc.Text = DataSet1.Tables[4].Rows[0][0].ToString();
                netAmount += Convert.ToDecimal(DataSet1.Tables[4].Rows[0][0].ToString());
            }
            else
            {
                lblHighSecAcc.Text = "0.00";
            }

            if (DataSet1.Tables[5].Rows[0][0].ToString() != "")
            {
                lblHostelAcc.Text = DataSet1.Tables[5].Rows[0][0].ToString();
                netAmount += Convert.ToDecimal(DataSet1.Tables[5].Rows[0][0].ToString());
            }
            else
            {
                lblHostelAcc.Text = "0.00";
            }

            hdnTotalAcc.Value = Convert.ToDecimal(netAmount).ToString();
            decimal otherNetAmt = 0;

            DataSet ds = new DataSet();
            utl = new Utilities();
            if (Session["AcademicID"] != null)
                ds = utl.GetDataset("sp_GetDayBookReport '" + txtStartdate.Text + "','" + Session["AcademicID"] + "'");
            if (ds != null && ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0)
            {

                if (ds.Tables[0].Rows[0]["DayBookId"] != null)
                    hdnDayBookId.Value = ds.Tables[0].Rows[0]["DayBookId"].ToString();
                else
                    hdnDayBookId.Value = string.Empty;

                if (ds.Tables[0].Rows[0]["OtherAccount1"] != null)
                    txtAccManual1.Text = ds.Tables[0].Rows[0]["OtherAccount1"].ToString();

                if (ds.Tables[0].Rows[0]["OtherAccount2"] != null)
                    txtAccManual2.Text = ds.Tables[0].Rows[0]["OtherAccount2"].ToString();

                if (ds.Tables[0].Rows[0]["OtherAccount1Value"] != null)
                    txtAccManualValue1.Text = ds.Tables[0].Rows[0]["OtherAccount1Value"].ToString();
                else
                    txtAccManualValue1.Text = "0.00";

                if (ds.Tables[0].Rows[0]["OtherAccount2Value"] != null)
                    txtAccManualValue2.Text = ds.Tables[0].Rows[0]["OtherAccount2Value"].ToString();
                else
                    txtAccManualValue2.Text = "0.00";

              

                otherNetAmt += (Convert.ToDecimal(txtAccManualValue1.Text) + Convert.ToDecimal(txtAccManualValue2.Text));
            }
            else
            {
                txtAccManual1.Text = "Other Accounts if any";
                txtAccManual1.CssClass="water";
                txtAccManual2.Text = "Other Accounts if any";
                txtAccManual2.CssClass = "water";
                txtAccManualValue1.Text = "0.00";
                txtAccManualValue2.Text = "0.00";
            }

            lblNetCash.Text =(Convert.ToDecimal(netAmount) + Convert.ToDecimal(otherNetAmt)).ToString();

            decimal cashSpentNet = 0;
            if (DataSet1.Tables[6].Rows[0][0].ToString() != "")
            {
                lblCashSpent.Text = DataSet1.Tables[6].Rows[0][0].ToString();
                cashSpentNet += Convert.ToDecimal(DataSet1.Tables[6].Rows[0][0].ToString());
            }
            else
            {
                lblCashSpent.Text = "0.00";
            }

            if (ds.Tables[0].Rows.Count>0)
                txtOtherCashSpent.Text = ds.Tables[0].Rows[0]["OtherCashSpent1"].ToString();

            if (ds.Tables[0].Rows.Count > 0)
            {
                txtOtherCashSpentValue.Text = ds.Tables[0].Rows[0]["OtherCashSpent1Value"].ToString();
                cashSpentNet += Convert.ToDecimal(ds.Tables[0].Rows[0]["OtherCashSpent1Value"].ToString());
            }
            else
                txtOtherCashSpentValue.Text = "0.00";

            if (DataSet1.Tables[7].Rows[0][0].ToString() != "")
            {
                lblCashReturn.Text = DataSet1.Tables[7].Rows[0][0].ToString();
                //cashSpentNet += Convert.ToDecimal(DataSet1.Tables[7].Rows[0][0].ToString());
            }
            else
            {
                lblCashReturn.Text = "0.00";
            }
            netInHand = Convert.ToDecimal(lblNetCash.Text) - (Convert.ToDecimal(cashSpentNet)) + Convert.ToDecimal(lblCashReturn.Text);
            lblNetCashInHand.Text = Convert.ToString(netInHand);
        };
    }
  

    [WebMethod]

    public static string InsertAccDetails(string dayBookId, string acdYear, string accDate, string otherAcc1, string otherAcc2, string otherCashSpent, string otherAcc1Value, string otherAcc2Value, string otherCashSpentValue, string userId)
    {
        string[] formats = { "dd/MM/yyyy" };
        string fFrom = DateTime.ParseExact(accDate, formats, new CultureInfo("en-US"), DateTimeStyles.None).ToShortDateString();
        string query = "[SP_InsertDayBookReport] " + dayBookId + "," + acdYear + ",'" + fFrom + "','" + otherAcc1 + "','" + otherAcc2 + "','" + otherCashSpent + "','" + otherAcc1Value + "','" + otherAcc2Value + "','" + otherCashSpentValue + "'," + userId + "";
        Utilities utl = new Utilities();
        string sqlstr = utl.ExecuteScalar(query);
        if (sqlstr != string.Empty)
            return sqlstr;
        else
            return "";
    }
}