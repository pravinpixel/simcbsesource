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

public partial class Voucher : System.Web.UI.Page
{
    Utilities utl = null;
    string sqlstr = "";
    public static int Userid = 0;
    public static string UserName = string.Empty;
    private static int PageSize = 10;
    int iCashVoucherNo = 0;
    int iFuelVoucherNo = 0;
    string FinancialID = "";
    private static string isError = string.Empty;

    protected void Page_Load(object sender, EventArgs e)
    {
        
        Master.chkUser();
        if (Session["UserId"] == null || Session["AcademicID"] == null)
        {
            Response.Redirect("Default.aspx?ses=expired");
        }
        else
        {
            Userid = Convert.ToInt32(Session["UserId"]);
            DataTable dt = new DataTable();
            utl = new Utilities();
            dt = utl.GetDataTable("sp_getuser " + Userid + "");
            if (dt != null && dt.Rows[0]["EmpName"] != null)
            {
                UserName = dt.Rows[0]["EmpName"].ToString();
                hdnUserName.Value = dt.Rows[0]["EmpName"].ToString();
            }

            if (!IsPostBack)
            {
                BindFinancialYear();
                
                FinancialID = utl.ExecuteScalar("select top 1 FinancialID from m_financialyear where FinancialID=(select FinancialID from m_financialyear where isactive=1)");
                    if (FinancialID != "")
                    {
                        hfFinancialID.Value = FinancialID.ToString();
                        ddlFinancialyear.SelectedValue = FinancialID.ToString();
                        Session["FinancialID"] = FinancialID.ToString();
                    }
              
                BindCashVoucherDummyRow();
                BindExpenseType();

                string query = "Select isnull(Max(VoucherNo)+ 1,1)as  VoucherNo from m_cashVouchers where VoucherType='Cash' and FinancialID=(select FinancialID from m_financialyear where isactive=1)";
                iCashVoucherNo = Convert.ToInt32(utl.ExecuteScalar(query));
                txtVoucherNo.Text = iCashVoucherNo.ToString();

                BindVehicleCode();
                BindFuel();
                BindFuelVoucherDummyRow();
                query = "Select isnull(Max(VoucherNo)+ 1,1)as  VoucherNo from m_FuelVouchers where VoucherType='Fuel' and FinancialID=(select FinancialID from m_financialyear where isactive=1)";
                iFuelVoucherNo = Convert.ToInt32(utl.ExecuteScalar(query));
                txtFuelVoucherNo.Text = iFuelVoucherNo.ToString();

                BindCashVoucherNo();
                BindCashReturnVoucherDummyRow();
            }
            txtVoucherDate.Text = System.DateTime.Now.ToString("dd/MM/yyyy");
            txtFuelVoucherDate.Text = System.DateTime.Now.ToString("dd/MM/yyyy");
        }

    }
    public void BindFinancialYear()
    {
        utl = new Utilities();
        sqlstr = "sp_getFinYear";
        DataTable dt = new DataTable();
        dt = utl.GetDataTable(sqlstr);

        if (dt != null && dt.Rows.Count > 0)
        {
            ddlFinancialyear.DataSource = dt;
            ddlFinancialyear.DataTextField = "FinancialYear";
            ddlFinancialyear.DataValueField = "FinancialID";
            ddlFinancialyear.DataBind();
            ddlFinancialyear.Items.Insert(0, "Financial Year");
        }
        else
        {
            ddlFinancialyear.DataSource = null;
            ddlFinancialyear.DataBind();
            ddlFinancialyear.SelectedIndex = 0;
        }
    }
    private void BindFuelVoucherDummyRow()
    {
        DataTable dummy = new DataTable();
        dummy.Columns.Add("VoucherType");
        dummy.Columns.Add("VoucherNo");
        dummy.Columns.Add("VehicleCode");
        dummy.Columns.Add("FuelName");
        dummy.Columns.Add("PricePerLtr");
        dummy.Columns.Add("NoofLtr");
        dummy.Columns.Add("VoucherDate");
        dummy.Columns.Add("Amount");
        dummy.Columns.Add("ReceivedBy");
        dummy.Columns.Add("FuelVoucherID");
        dummy.Columns.Add("Reprint");
        dummy.Rows.Add();
        dgFuelVoucher.DataSource = dummy;
        dgFuelVoucher.DataBind();
    }
    private void BindCashVoucherDummyRow()
    {
        DataTable dummy = new DataTable();
        dummy.Columns.Add("VoucherType");
        dummy.Columns.Add("VoucherNo");
        dummy.Columns.Add("PaymentTo");
        dummy.Columns.Add("PaymentFor");
        dummy.Columns.Add("Amount");
        dummy.Columns.Add("PaymentDate");
        dummy.Columns.Add("BillNo");
        dummy.Columns.Add("ExpenseTypeName");
        dummy.Columns.Add("PayType");
        dummy.Columns.Add("ChequeNo");
        dummy.Columns.Add("ChequeDate");
        dummy.Columns.Add("AccountNo");
        dummy.Columns.Add("CashVoucherID");
        dummy.Columns.Add("Reprint");
        dummy.Rows.Add();
        dgCashVoucher.DataSource = dummy;
        dgCashVoucher.DataBind();
    }
    private void BindCashReturnVoucherDummyRow()
    {
        DataTable dummy = new DataTable();
        dummy.Columns.Add("VoucherType");
        dummy.Columns.Add("VoucherNo");
        dummy.Columns.Add("DateofIssue");
        dummy.Columns.Add("VoucherAmount");
        dummy.Columns.Add("DateofReturn");
        dummy.Columns.Add("PricePerLtr");
        dummy.Columns.Add("ReturningAmount");
        dummy.Columns.Add("CashRetVoucherId");
        dummy.Columns.Add("Reprint");
        dummy.Rows.Add();
        dgCashReturnVoucher.DataSource = dummy;
        dgCashReturnVoucher.DataBind();
    }
    private void BindCashVoucherNo()
    {
        utl = new Utilities();
        sqlstr = "sp_GetCashVoucherNo '" + hfCashVoucherID.Value + "'," + "'Cash'";
        DataTable dt = new DataTable();
        dt = utl.GetDataTable(sqlstr);

        if (dt != null && dt.Rows.Count > 0)
        {
            ddlVoucherNo.DataSource = dt;
            ddlVoucherNo.DataTextField = "VoucherNo";
            ddlVoucherNo.DataValueField = "CashVoucherId";
            ddlVoucherNo.DataBind();
        }
        else
        {
            ddlVoucherNo.DataSource = null;
            ddlVoucherNo.DataBind();
        }
    }

    private void BindFuel()
    {
        utl = new Utilities();
        sqlstr = "sp_GetFuelType " + "''";
        DataTable dt = new DataTable();
        dt = utl.GetDataTable(sqlstr);

        if (dt != null && dt.Rows.Count > 0)
        {

            rbtnFuel.DataSource = dt;
            rbtnFuel.DataTextField = "FuelTypeName";
            rbtnFuel.DataValueField = "FuelTypeId";
            rbtnFuel.DataBind();
        }
        else
        {
            ddlVehicleNo.DataSource = null;
            ddlVehicleNo.DataBind();
            ddlVehicleNo.SelectedIndex = 0;
        }

    }
    private void BindVehicleCode()
    {
        utl = new Utilities();
        sqlstr = "sp_GetVehicle";
        DataTable dt = new DataTable();
        dt = utl.GetDataTable(sqlstr);

        if (dt != null && dt.Rows.Count > 0)
        {
            ddlVehicleNo.DataSource = dt;
            ddlVehicleNo.DataTextField = "VehicleCode";
            ddlVehicleNo.DataValueField = "VehicleId";
            ddlVehicleNo.DataBind();
        }
        else
        {
            ddlVehicleNo.DataSource = null;
            ddlVehicleNo.DataBind();
            ddlVehicleNo.SelectedIndex = 0;
        }


    }
    private void BindExpenseType()
    {
        utl = new Utilities();
        sqlstr = "sp_GetExpenseType";
        DataTable dt = new DataTable();
        dt = utl.GetDataTable(sqlstr);

        if (dt != null && dt.Rows.Count > 0)
        {
            ddlExpenseType.DataSource = dt;
            ddlExpenseType.DataTextField = "ExpenseTypeName";
            ddlExpenseType.DataValueField = "ExpenseTypeID";
            ddlExpenseType.DataBind();
        }
        else
        {
            ddlExpenseType.DataSource = null;
            ddlExpenseType.DataBind();
        }

    }

    public static DataSet GetCashVoucherData(SqlCommand cmd, int pageIndex)
    {

        string strConnString = ConfigurationManager.AppSettings["SIMCBSEConnection"].ToString();
        using (SqlConnection con = new SqlConnection(strConnString))
        {
            using (SqlDataAdapter sda = new SqlDataAdapter())
            {
                cmd.Connection = con;
                sda.SelectCommand = cmd;
                using (DataSet ds = new DataSet())
                {
                    sda.Fill(ds, "CashVouchers");
                    DataTable dt = new DataTable("Pager");
                    dt.Columns.Add("PageIndex");
                    dt.Columns.Add("PageSize");
                    dt.Columns.Add("RecordCount");
                    dt.Columns.Add("FinancialID");
                    dt.Rows.Add();
                    dt.Rows[0]["PageIndex"] = pageIndex;
                    dt.Rows[0]["PageSize"] = PageSize;
                    dt.Rows[0]["RecordCount"] = cmd.Parameters["@RecordCount"].Value;
                    dt.Rows[0]["FinancialID"] = HttpContext.Current.Session["FinancialID"];
                    ds.Tables.Add(dt);
                    return ds;
                }
            }
        }
    }

    public static DataSet GetCashVoucherIDData(SqlCommand cmd)
    {

        string strConnString = ConfigurationManager.AppSettings["SIMCBSEConnection"].ToString();
        using (SqlConnection con = new SqlConnection(strConnString))
        {
            using (SqlDataAdapter sda = new SqlDataAdapter())
            {
                cmd.Connection = con;
                Utilities utl = new Utilities();
                sda.SelectCommand = cmd;
                using (DataSet ds = new DataSet())
                {
                    sda.Fill(ds, "CashVoucherIDs");
                    return ds;
                }
            }
        }
    }
    [WebMethod]
    public static string GetCashVoucherID()
    {
        string query = "Select isnull(Max(VoucherNo)+ 1,1)as  CashVoucherID from m_cashVouchers where VoucherType='Cash' and FinancialID=(select FinancialID from m_financialyear where isactive=1)";
        SqlCommand cmd = new SqlCommand(query);
        cmd.CommandType = CommandType.Text;
        return GetCashVoucherIDData(cmd).GetXml();

    }
    [WebMethod]
    public static string GetCashVoucher(int pageIndex)
    {
        Utilities utl = new Utilities();
        string query = "[GetCashVoucher_Pager]";
        SqlCommand cmd = new SqlCommand(query);
        cmd.CommandType = CommandType.StoredProcedure;
        cmd.Parameters.AddWithValue("@PageIndex", pageIndex);
        cmd.Parameters.AddWithValue("@PageSize", PageSize);
        cmd.Parameters.Add("@RecordCount", SqlDbType.Int, 4).Direction = ParameterDirection.Output;
        cmd.Parameters.Add("@FinancialID", HttpContext.Current.Session["FinancialID"]);
        return GetCashVoucherData(cmd, pageIndex).GetXml();
    }

    [WebMethod]
    public static string EditCashVoucher(int CashVoucherID)
    {
        Utilities utl = new Utilities();
        DataSet ds = new DataSet();
        string query = "sp_GetCashVoucher " + "" + CashVoucherID + "";
        return utl.GetDatasetTable(query, "EditCashVoucher").GetXml();
    }

    [WebMethod]
    public static string SaveCashVoucher(string id, string cashvoucherno, string paymentto, string paymentfor, string amount, string paymentdate, string billno, string expensetype, string paytype, string chequeno, string chequedate, string accountno, string userName, string expenseTypeText)
    {
        string chequeDateFormat = chequedate;
        Utilities utl = new Utilities();
        string sqlstr = string.Empty;
        string strQueryStatus = string.Empty;
        string message = string.Empty;
        Userid = Convert.ToInt32(HttpContext.Current.Session["UserId"]);
        string oripaymentdate = paymentdate;
        if (paymentdate != "")
        {
            string[] myDateTimeString = paymentdate.Split('/');
            paymentdate = "'" + myDateTimeString[2] + "/" + myDateTimeString[1] + "/" + myDateTimeString[0] + "'";
        }

        if (chequedate == "")
        {
            chequedate = "null";
        }
        else
        {
            string[] myDateTimeString = chequedate.Split('/');
            chequedate = "'" + myDateTimeString[2] + "/" + myDateTimeString[1] + "/" + myDateTimeString[0] + "'";
        }
        if (!string.IsNullOrEmpty(id))
        {
            sqlstr = "select isnull(count(*),0) from m_CashVouchers where VoucherType='Cash' and voucherno='" + cashvoucherno + "'  and paymentto='" + paymentto + "'  and paymentfor='" + paymentfor + "' and amount='" + amount + "'  and paymentdate=" + paymentdate + "  and billno='" + billno + "'  and expensetypeid='" + expensetype + "'  and paytype='" + paytype + "'  and chequeno='" + chequeno + "'  and chequedate=" + chequedate + " and accountno='" + accountno + "'   and CashVoucherid!='" + id + "' and isactive=1 and FinancialID=(select FinancialID from m_financialyear where isactive=1)";
            string iCount = Convert.ToString(utl.ExecuteScalar(sqlstr));
            if (iCount == "0")
            {

                sqlstr = "sp_UpdateCashVoucher " + "" + id + ",'Cash','" + cashvoucherno + "','" + paymentto + "','" + paymentfor + "','" + amount + "'," + paymentdate + ",'" + billno + "','" + expensetype + "','" + paytype + "','" + chequeno + "'," + chequedate + ",'" + accountno + "','" + Userid + "'";
                strQueryStatus = utl.ExecuteQuery(sqlstr);
                if (strQueryStatus == "")
                {
                    printCashVoucher(cashvoucherno, paymentto, paymentfor, amount, oripaymentdate, billno, expensetype, paytype, chequeno, chequeDateFormat, accountno, userName, expenseTypeText);
                    return "Updated";
                }
                else
                    return "Update Failed";
            }
            else
            {
                return "Already Exists, Update";
            }
        }
        else
        {
            sqlstr = "select isnull(count(*),0) from m_CashVouchers where VoucherType='Cash' and voucherno='" + cashvoucherno + "'  and paymentto='" + paymentto + "'  and paymentfor='" + paymentfor + "' and amount='" + amount + "'  and paymentdate=" + paymentdate + "  and billno='" + billno + "'  and expensetypeid='" + expensetype + "'  and paytype='" + paytype + "'  and chequeno='" + chequeno + "'  and chequedate=" + chequedate + " and accountno='" + accountno + "' and isactive=1 and FinancialID=(select FinancialID from m_financialyear where isactive=1)";
            string iCount = Convert.ToString(utl.ExecuteScalar(sqlstr));
            if (iCount == "0")
            {
                sqlstr = "sp_InsertCashVoucher " + "'Cash','" + cashvoucherno + "','" + paymentto + "','" + paymentfor + "','" + amount + "'," + paymentdate + ",'" + billno + "','" + expensetype + "','" + paytype + "','" + chequeno + "'," + chequedate + ",'" + accountno + "','" + Userid + "'";
                strQueryStatus = utl.ExecuteQuery(sqlstr);
                if (strQueryStatus == "")
                {
                    printCashVoucher(cashvoucherno, paymentto, paymentfor, amount, oripaymentdate, billno, expensetype, paytype, chequeno, chequeDateFormat, accountno, userName, expenseTypeText);
                    return "Inserted";
                }
                else
                    return "Insert Failed";
            }
            else
            {
                return "Already Exists, Insert";
            }
        }
    }

    public static void printCashVoucher(string cashvoucherno, string paymentto, string paymentfor, string amount, string paymentdate, string billno, string expensetype, string paytype, string chequeno, string chequedate, string accountNo, string userName, string expenseTypeText)
    {
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

                  args.Graphics.DrawLine(new Pen(Color.Black, 1), 0, 45, 500, 45);

                  args.Graphics.DrawString("Voucher for - " + paytype + "(CASH)", new System.Drawing.Font("Arial", 9, FontStyle.Underline), Brushes.Black, new Rectangle(0, 40, 250, 50), stringAlignCenter);

                  args.Graphics.DrawString("Voucher No", new System.Drawing.Font("Arial", 9, FontStyle.Regular), Brushes.Black, new Rectangle(0, 70, 90, 50), stringAlignLeft);
                  args.Graphics.DrawString(":", new System.Drawing.Font("Arial", 9, FontStyle.Regular), Brushes.Black, new Rectangle(120, 70, 20, 50), stringAlignLeft);
                  args.Graphics.DrawString(cashvoucherno, new System.Drawing.Font("Arial", 9, FontStyle.Regular), Brushes.Black, new Rectangle(135, 70, 140, 50), stringAlignLeft);

                  args.Graphics.DrawString("Payment For", new System.Drawing.Font("Arial", 9, FontStyle.Regular), Brushes.Black, new Rectangle(0, 95, 90, 50), stringAlignLeft);
                  args.Graphics.DrawString(":", new System.Drawing.Font("Arial", 9, FontStyle.Regular), Brushes.Black, new Rectangle(120, 95, 20, 50), stringAlignLeft);
                  args.Graphics.DrawString(paymentfor, new System.Drawing.Font("Arial", 9, FontStyle.Regular), Brushes.Black, new Rectangle(135, 95, 140, 50), stringAlignLeft);

                  args.Graphics.DrawString("Payment To ", new System.Drawing.Font("Arial", 9, FontStyle.Regular), Brushes.Black, new Rectangle(0, 120, 90, 50), stringAlignLeft);
                  args.Graphics.DrawString(":", new System.Drawing.Font("Arial", 9, FontStyle.Regular), Brushes.Black, new Rectangle(120, 120, 20, 50), stringAlignLeft);
                  args.Graphics.DrawString(paymentto, new System.Drawing.Font("Arial", 9, FontStyle.Regular), Brushes.Black, new Rectangle(135, 120, 140, 50), stringAlignLeft);

                  args.Graphics.DrawString("Amount ", new System.Drawing.Font("Arial", 9, FontStyle.Regular), Brushes.Black, new Rectangle(0, 145, 90, 50), stringAlignLeft);
                  args.Graphics.DrawString(":", new System.Drawing.Font("Arial", 9, FontStyle.Regular), Brushes.Black, new Rectangle(120, 145, 20, 50), stringAlignLeft);
                  args.Graphics.DrawString(amount, new System.Drawing.Font("Arial", 9, FontStyle.Regular), Brushes.Black, new Rectangle(135, 145, 140, 50), stringAlignLeft);
                  ypos = 145;
                  if (billno != string.Empty && billno != "-")
                  {
                      ypos += 25;
                      args.Graphics.DrawString("Bill No ", new System.Drawing.Font("Arial", 9, FontStyle.Regular), Brushes.Black, new Rectangle(0, ypos, 90, 50), stringAlignLeft);
                      args.Graphics.DrawString(":", new System.Drawing.Font("Arial", 9, FontStyle.Regular), Brushes.Black, new Rectangle(120, ypos, 20, 50), stringAlignLeft);
                      args.Graphics.DrawString(billno, new System.Drawing.Font("Arial", 9, FontStyle.Regular), Brushes.Black, new Rectangle(135, ypos, 140, 50), stringAlignLeft);

                  }
                  ypos += 25;

                  args.Graphics.DrawString("Expense Type ", new System.Drawing.Font("Arial", 9, FontStyle.Regular), Brushes.Black, new Rectangle(0, ypos, 90, 50), stringAlignLeft);
                  args.Graphics.DrawString(":", new System.Drawing.Font("Arial", 9, FontStyle.Regular), Brushes.Black, new Rectangle(120, ypos, 20, 50), stringAlignLeft);
                  args.Graphics.DrawString(expenseTypeText, new System.Drawing.Font("Arial", 9, FontStyle.Regular), Brushes.Black, new Rectangle(135, ypos, 140, 50), stringAlignLeft);

                  if (paytype == "Cash")
                  {
                      ypos += 25;

                      args.Graphics.DrawString("Pay Type ", new System.Drawing.Font("Arial", 9, FontStyle.Regular), Brushes.Black, new Rectangle(0, ypos, 90, 50), stringAlignLeft);
                      args.Graphics.DrawString(":", new System.Drawing.Font("Arial", 9, FontStyle.Regular), Brushes.Black, new Rectangle(120, ypos, 20, 50), stringAlignLeft);
                      args.Graphics.DrawString(paytype, new System.Drawing.Font("Arial", 9, FontStyle.Regular), Brushes.Black, new Rectangle(135, ypos, 140, 50), stringAlignLeft);

                  }
                  else
                  {

                      ypos += 25;

                      args.Graphics.DrawString("Pay Type ", new System.Drawing.Font("Arial", 9, FontStyle.Regular), Brushes.Black, new Rectangle(0, ypos, 90, 50), stringAlignLeft);
                      args.Graphics.DrawString(":", new System.Drawing.Font("Arial", 9, FontStyle.Regular), Brushes.Black, new Rectangle(120, ypos, 20, 50), stringAlignLeft);
                      args.Graphics.DrawString(paytype, new System.Drawing.Font("Arial", 9, FontStyle.Regular), Brushes.Black, new Rectangle(135, ypos, 140, 50), stringAlignLeft);

                      ypos += 25;

                      args.Graphics.DrawString("Cheque No ", new System.Drawing.Font("Arial", 9, FontStyle.Regular), Brushes.Black, new Rectangle(0, ypos, 90, 50), stringAlignLeft);
                      args.Graphics.DrawString(":", new System.Drawing.Font("Arial", 9, FontStyle.Regular), Brushes.Black, new Rectangle(120, ypos, 20, 50), stringAlignLeft);
                      args.Graphics.DrawString(chequeno, new System.Drawing.Font("Arial", 9, FontStyle.Regular), Brushes.Black, new Rectangle(135, ypos, 140, 50), stringAlignLeft);

                      ypos += 25;

                      args.Graphics.DrawString("Cheque Date ", new System.Drawing.Font("Arial", 9, FontStyle.Regular), Brushes.Black, new Rectangle(0, ypos, 90, 50), stringAlignLeft);
                      args.Graphics.DrawString(":", new System.Drawing.Font("Arial", 9, FontStyle.Regular), Brushes.Black, new Rectangle(120, ypos, 20, 50), stringAlignLeft);
                      args.Graphics.DrawString(chequedate, new System.Drawing.Font("Arial", 9, FontStyle.Regular), Brushes.Black, new Rectangle(135, ypos, 140, 50), stringAlignLeft);

                      ypos += 25;

                      args.Graphics.DrawString("Account No ", new System.Drawing.Font("Arial", 9, FontStyle.Regular), Brushes.Black, new Rectangle(0, ypos, 90, 50), stringAlignLeft);
                      args.Graphics.DrawString(":", new System.Drawing.Font("Arial", 9, FontStyle.Regular), Brushes.Black, new Rectangle(120, ypos, 20, 50), stringAlignLeft);
                      args.Graphics.DrawString(accountNo, new System.Drawing.Font("Arial", 9, FontStyle.Regular), Brushes.Black, new Rectangle(135, ypos, 140, 50), stringAlignLeft);

                  }

                  ypos += 35;
                  Pen pen = new Pen(Color.Black, 1);
                  pen.DashStyle = System.Drawing.Drawing2D.DashStyle.Dot;
                  args.Graphics.DrawLine(pen, 0, ypos, 500, ypos);

                  args.Graphics.DrawString("Date : " + paymentdate, new System.Drawing.Font("Arial", 9, FontStyle.Regular), Brushes.Black, new Rectangle(0, ypos, 110, 50), stringAlignLeft);
                  args.Graphics.DrawString("Cashier : " + userName + "", new System.Drawing.Font("Arial", 9, FontStyle.Regular), Brushes.Black, new Rectangle(100, ypos, 140, 50), stringAlignRight);
                  ypos += 80;

                  Pen pen2 = new Pen(Color.Black, 1);
                  pen2.DashStyle = System.Drawing.Drawing2D.DashStyle.Dot;
                  args.Graphics.DrawLine(pen2, 0, ypos, 500, ypos);

              }
          };

                fd.PrinterSettings.PrinterName = "\\\\" + clientIPAddress + "\\" + printerName + "";
                fd.Print();

            }

            isError = "no";

        }
        catch (Exception err)
        {
            isError = "yes";

        }
        finally { }
    }

    public static void printFuelVoucher(string fuelvoucherno, string fuelType, string vehicleNo, string noOfLtr, string pricePerLtr, string amount, string VoucherDate, string receivedby, string userName)
    {

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

                        args.Graphics.DrawString("Voucher for - " + fuelType, new System.Drawing.Font("Arial", 9, FontStyle.Underline), Brushes.Black, new Rectangle(0, 40, 250, 50), stringAlignCenter);

                        args.Graphics.DrawString("Voucher No", new System.Drawing.Font("Arial", 9, FontStyle.Regular), Brushes.Black, new Rectangle(0, 65, 90, 50), stringAlignLeft);
                        args.Graphics.DrawString(":", new System.Drawing.Font("Arial", 9, FontStyle.Regular), Brushes.Black, new Rectangle(120, 65, 20, 50), stringAlignLeft);
                        args.Graphics.DrawString(fuelvoucherno, new System.Drawing.Font("Arial", 9, FontStyle.Regular), Brushes.Black, new Rectangle(135, 65, 140, 50), stringAlignLeft);

                        args.Graphics.DrawString("Vehicle No ", new System.Drawing.Font("Arial", 9, FontStyle.Regular), Brushes.Black, new Rectangle(0, 90, 90, 50), stringAlignLeft);
                        args.Graphics.DrawString(":", new System.Drawing.Font("Arial", 9, FontStyle.Regular), Brushes.Black, new Rectangle(120, 90, 20, 50), stringAlignLeft);
                        args.Graphics.DrawString(vehicleNo, new System.Drawing.Font("Arial", 9, FontStyle.Regular), Brushes.Black, new Rectangle(135, 90, 140, 50), stringAlignLeft);

                        args.Graphics.DrawString("No.of.lts ", new System.Drawing.Font("Arial", 9, FontStyle.Regular), Brushes.Black, new Rectangle(0, 115, 90, 50), stringAlignLeft);
                        args.Graphics.DrawString(":", new System.Drawing.Font("Arial", 9, FontStyle.Regular), Brushes.Black, new Rectangle(120, 115, 20, 50), stringAlignLeft);
                        args.Graphics.DrawString(noOfLtr, new System.Drawing.Font("Arial", 9, FontStyle.Regular), Brushes.Black, new Rectangle(135, 115, 140, 50), stringAlignLeft);

                        args.Graphics.DrawString("Cost/litre ", new System.Drawing.Font("Arial", 9, FontStyle.Regular), Brushes.Black, new Rectangle(0, 140, 90, 50), stringAlignLeft);
                        args.Graphics.DrawString(":", new System.Drawing.Font("Arial", 9, FontStyle.Regular), Brushes.Black, new Rectangle(120, 140, 20, 50), stringAlignLeft);
                        args.Graphics.DrawString(pricePerLtr, new System.Drawing.Font("Arial", 9, FontStyle.Regular), Brushes.Black, new Rectangle(135, 140, 140, 50), stringAlignLeft);

                        args.Graphics.DrawString("Amount ", new System.Drawing.Font("Arial", 9, FontStyle.Regular), Brushes.Black, new Rectangle(0, 165, 90, 50), stringAlignLeft);
                        args.Graphics.DrawString(":", new System.Drawing.Font("Arial", 9, FontStyle.Regular), Brushes.Black, new Rectangle(120, 165, 20, 50), stringAlignLeft);
                        args.Graphics.DrawString(amount, new System.Drawing.Font("Arial", 9, FontStyle.Regular), Brushes.Black, new Rectangle(135, 165, 140, 50), stringAlignLeft);

                        args.Graphics.DrawString("Received by ", new System.Drawing.Font("Arial", 9, FontStyle.Regular), Brushes.Black, new Rectangle(0, 190, 90, 50), stringAlignLeft);
                        args.Graphics.DrawString(":", new System.Drawing.Font("Arial", 9, FontStyle.Regular), Brushes.Black, new Rectangle(120, 190, 20, 50), stringAlignLeft);
                        args.Graphics.DrawString(receivedby, new System.Drawing.Font("Arial", 9, FontStyle.Regular), Brushes.Black, new Rectangle(135, 190, 140, 50), stringAlignLeft);

                        //args.Graphics.DrawLine(new Pen(Color.Black, 2), 0, 225, 500, 225);

                        Pen pen = new Pen(Color.Black, 1);
                        pen.DashStyle = System.Drawing.Drawing2D.DashStyle.Dot;
                        args.Graphics.DrawLine(pen, 0, 225, 500, 225);



                        args.Graphics.DrawString("Date : " + VoucherDate, new System.Drawing.Font("Arial", 9, FontStyle.Regular), Brushes.Black, new Rectangle(0, 225, 110, 50), stringAlignLeft);
                        args.Graphics.DrawString("Cashier : " + userName + "", new System.Drawing.Font("Arial", 9, FontStyle.Regular), Brushes.Black, new Rectangle(100, 225, 140, 50), stringAlignRight);

                        Pen pen2 = new Pen(Color.Black, 1);
                        pen2.DashStyle = System.Drawing.Drawing2D.DashStyle.Dot;
                        args.Graphics.DrawLine(pen2, 0, 295, 500, 295);

                        //args.Graphics.DrawLine(new Pen(Color.Black, 2), 0, 295, 500, 295);
                    }
                };
                fd.PrinterSettings.PrinterName = "\\\\" + clientIPAddress + "\\" + printerName + "";
                fd.Print();
                isError = "no";
            }

        }
        catch (Exception err)
        {
            isError = "yes";

        }
        finally { }
    }

    public static void printCashReturnVoucher(string cashvoucherno, string dateofissue, string dateofreturn, string voucheramount, string returningamount, string userName)
    {

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

                        args.Graphics.DrawString("Voucher for - Cash Return", new System.Drawing.Font("Arial", 9, FontStyle.Underline), Brushes.Black, new Rectangle(0, 40, 250, 50), stringAlignCenter);

                        args.Graphics.DrawString("Voucher No", new System.Drawing.Font("Arial", 9, FontStyle.Regular), Brushes.Black, new Rectangle(0, 65, 90, 50), stringAlignLeft);
                        args.Graphics.DrawString(":", new System.Drawing.Font("Arial", 9, FontStyle.Regular), Brushes.Black, new Rectangle(120, 65, 20, 50), stringAlignLeft);
                        args.Graphics.DrawString(cashvoucherno, new System.Drawing.Font("Arial", 9, FontStyle.Regular), Brushes.Black, new Rectangle(135, 65, 140, 50), stringAlignLeft);

                        args.Graphics.DrawString("Date Of Issue ", new System.Drawing.Font("Arial", 9, FontStyle.Regular), Brushes.Black, new Rectangle(0, 90, 90, 50), stringAlignLeft);
                        args.Graphics.DrawString(":", new System.Drawing.Font("Arial", 9, FontStyle.Regular), Brushes.Black, new Rectangle(120, 90, 20, 50), stringAlignLeft);
                        args.Graphics.DrawString(dateofissue, new System.Drawing.Font("Arial", 9, FontStyle.Regular), Brushes.Black, new Rectangle(135, 90, 140, 50), stringAlignLeft);

                        args.Graphics.DrawString("Voucher Amount ", new System.Drawing.Font("Arial", 9, FontStyle.Regular), Brushes.Black, new Rectangle(0, 115, 190, 50), stringAlignLeft);
                        args.Graphics.DrawString(":", new System.Drawing.Font("Arial", 9, FontStyle.Regular), Brushes.Black, new Rectangle(120, 115, 20, 50), stringAlignLeft);
                        args.Graphics.DrawString(voucheramount, new System.Drawing.Font("Arial", 9, FontStyle.Regular), Brushes.Black, new Rectangle(135, 115, 140, 50), stringAlignLeft);

                        args.Graphics.DrawString("Date Of Return ", new System.Drawing.Font("Arial", 9, FontStyle.Regular), Brushes.Black, new Rectangle(0, 140, 190, 50), stringAlignLeft);
                        args.Graphics.DrawString(":", new System.Drawing.Font("Arial", 9, FontStyle.Regular), Brushes.Black, new Rectangle(120, 140, 20, 50), stringAlignLeft);
                        args.Graphics.DrawString(dateofreturn, new System.Drawing.Font("Arial", 9, FontStyle.Regular), Brushes.Black, new Rectangle(135, 140, 140, 50), stringAlignLeft);

                        args.Graphics.DrawString("Returning Amount ", new System.Drawing.Font("Arial", 9, FontStyle.Regular), Brushes.Black, new Rectangle(0, 165, 190, 50), stringAlignLeft);
                        args.Graphics.DrawString(":", new System.Drawing.Font("Arial", 9, FontStyle.Regular), Brushes.Black, new Rectangle(120, 165, 20, 50), stringAlignLeft);
                        args.Graphics.DrawString(returningamount, new System.Drawing.Font("Arial", 9, FontStyle.Regular), Brushes.Black, new Rectangle(135, 165, 140, 50), stringAlignLeft);

                        Pen pen = new Pen(Color.Black, 1);
                        pen.DashStyle = System.Drawing.Drawing2D.DashStyle.Dot;
                        args.Graphics.DrawLine(pen, 0, 220, 500, 220);
                        //args.Graphics.DrawLine(new Pen(Color.Black, 2), 0, 350, 500, 350);

                        args.Graphics.DrawString("Date : " + System.DateTime.Now.ToString("dd/MM/yyyy"), new System.Drawing.Font("Arial", 9, FontStyle.Regular), Brushes.Black, new Rectangle(0, 220, 110, 50), stringAlignLeft);
                        args.Graphics.DrawString("Cashier : " + UserName + "", new System.Drawing.Font("Arial", 9, FontStyle.Regular), Brushes.Black, new Rectangle(100, 220, 140, 50), stringAlignRight);

                        Pen pen2 = new Pen(Color.Black, 1);
                        pen2.DashStyle = System.Drawing.Drawing2D.DashStyle.Dot;
                        args.Graphics.DrawLine(pen2, 0, 290, 500, 290);
                    }
                };

                fd.PrinterSettings.PrinterName = "\\\\" + clientIPAddress + "\\" + printerName + "";
                fd.Print();
                isError = "no";
            }
        }
        catch (Exception err)
        {
            isError = "yes";
        }
        finally { }
    }

    [WebMethod]
    public static string DeleteCashVoucher(string CashVoucherID)
    {
        Utilities utl = new Utilities();
        string sqlstr = string.Empty;
        string strQueryStatus = string.Empty;
        string message = string.Empty;
        Userid = Convert.ToInt32(HttpContext.Current.Session["UserId"]);
        strQueryStatus = utl.ExecuteScalar("sp_DeleteCashVoucher " + "" + CashVoucherID + ",'" + Userid + "'");
        if (strQueryStatus == "")
            return "Deleted";
        else
            return strQueryStatus;
    }

    [WebMethod]
    public static string GetFuelPrice(string fuelid)
    {
        string query = "Select  top 1 isnull(a.PricePerLtr,0) as  PricePerLtr from m_fuels a inner join m_fueltypes b on a.fueltypeid=b.fueltypeid where a.fueltypeid='" + fuelid + "' and a.isactive=1 order by entrydate desc";
        SqlCommand cmd = new SqlCommand(query);
        cmd.CommandType = CommandType.Text;
        return GetFuelPriceData(cmd).GetXml();

    }
    public static DataSet GetFuelPriceData(SqlCommand cmd)
    {

        string strConnString = ConfigurationManager.AppSettings["SIMCBSEConnection"].ToString();
        using (SqlConnection con = new SqlConnection(strConnString))
        {
            using (SqlDataAdapter sda = new SqlDataAdapter())
            {
                cmd.Connection = con;
                Utilities utl = new Utilities();
                sda.SelectCommand = cmd;
                using (DataSet ds = new DataSet())
                {
                    sda.Fill(ds, "FuelPrice");
                    return ds;
                }
            }
        }
    }

    public static DataSet GetFuelVoucherData(SqlCommand cmd, int pageIndex)
    {

        string strConnString = ConfigurationManager.AppSettings["SIMCBSEConnection"].ToString();
        using (SqlConnection con = new SqlConnection(strConnString))
        {
            using (SqlDataAdapter sda = new SqlDataAdapter())
            {
                cmd.Connection = con;
                sda.SelectCommand = cmd;
                using (DataSet ds = new DataSet())
                {
                    sda.Fill(ds, "FuelVouchers");
                    DataTable dt = new DataTable("Pager");
                    dt.Columns.Add("PageIndex");
                    dt.Columns.Add("PageSize");
                    dt.Columns.Add("RecordCount");
                    dt.Columns.Add("FinancialID");
                    dt.Rows.Add();
                    dt.Rows[0]["PageIndex"] = pageIndex;
                    dt.Rows[0]["PageSize"] = PageSize;
                    dt.Rows[0]["RecordCount"] = cmd.Parameters["@RecordCount"].Value;
                    dt.Rows[0]["FinancialID"] = HttpContext.Current.Session["FinancialID"];
                    ds.Tables.Add(dt);
                    return ds;
                }
            }
        }
    }

    public static DataSet GetFuelVoucherIDData(SqlCommand cmd)
    {

        string strConnString = ConfigurationManager.AppSettings["SIMCBSEConnection"].ToString();
        using (SqlConnection con = new SqlConnection(strConnString))
        {
            using (SqlDataAdapter sda = new SqlDataAdapter())
            {
                cmd.Connection = con;
                Utilities utl = new Utilities();
                sda.SelectCommand = cmd;
                using (DataSet ds = new DataSet())
                {
                    sda.Fill(ds, "FuelVoucherIDs");
                    return ds;
                }
            }
        }
    }
    [WebMethod]
    public static string GetFuelVoucherID()
    {
        string query = "Select isnull(Max(VoucherNo)+ 1,1)as  FuelVoucherID from m_FuelVouchers where VoucherType='Fuel' and FinancialID=(select FinancialID from m_financialyear where isactive=1)";
        SqlCommand cmd = new SqlCommand(query);
        cmd.CommandType = CommandType.Text;
        return GetFuelVoucherIDData(cmd).GetXml();

    }
    [WebMethod]
    public static string GetFuelVoucher(int pageIndex)
    {
        Utilities utl = new Utilities();
        string query = "[GetFuelVoucher_Pager]";
        SqlCommand cmd = new SqlCommand(query);
        cmd.CommandType = CommandType.StoredProcedure;
        cmd.Parameters.AddWithValue("@PageIndex", pageIndex);
        cmd.Parameters.AddWithValue("@PageSize", PageSize);
        cmd.Parameters.Add("@RecordCount", SqlDbType.Int, 4).Direction = ParameterDirection.Output;
        cmd.Parameters.Add("@FinancialID", HttpContext.Current.Session["FinancialID"]);
        return GetFuelVoucherData(cmd, pageIndex).GetXml();
    }

    [WebMethod]
    public static string EditFuelVoucher(int FuelVoucherID)
    {
        Utilities utl = new Utilities();
        DataSet ds = new DataSet();
        string query = "sp_GetFuelVoucher " + "" + FuelVoucherID + "";
        return utl.GetDatasetTable(query, "EditFuelVoucher").GetXml();
    }

    [WebMethod]

    public static string SaveFuelVoucher(string id, string fuelvoucherno, string vehicleno, string fueltypeid, string priceperlitre, string nooflitre, string amount, string receivedby, string fuelVoucherdate, string fuelType, string userName)
    {
        Utilities utl = new Utilities();
        string sqlstr = string.Empty;
        string strQueryStatus = string.Empty;
        string message = string.Empty;
        Userid = Convert.ToInt32(HttpContext.Current.Session["UserId"]);
        string OrifuelVoucherdate = fuelVoucherdate;
        if (fuelVoucherdate != "")
        {
            string[] myDateTimeString = fuelVoucherdate.Split('/');
            fuelVoucherdate = "'" + myDateTimeString[2] + "/" + myDateTimeString[1] + "/" + myDateTimeString[0] + "'";
        }
        if (!string.IsNullOrEmpty(id))
        {
            sqlstr = "select isnull(count(*),0) from m_FuelVouchers where VoucherType='Fuel' and voucherno='" + fuelvoucherno + "'  and vehicleno='" + vehicleno + "'  and fueltypeid='" + fueltypeid + "' and priceperltr='" + priceperlitre + "' and amount='" + amount + "' and noofltr='" + nooflitre + "' and receivedby='" + receivedby + "' and Voucherdate=" + fuelVoucherdate + " and FuelVoucherid!='" + id + "' and isactive=1 and FinancialID=(select FinancialID from m_financialyear where isactive=1)   ";
            string iCount = Convert.ToString(utl.ExecuteScalar(sqlstr));
            if (iCount == "0")
            {

                sqlstr = "sp_UpdateFuelVoucher " + "" + id + ",'Fuel','" + fuelvoucherno + "','" + vehicleno + "','" + fueltypeid + "','" + priceperlitre + "','" + nooflitre + "','" + amount + "','" + receivedby + "'," + fuelVoucherdate + ",'" + Userid + "'";
                strQueryStatus = utl.ExecuteQuery(sqlstr);
                if (strQueryStatus == "")
                {
                    sqlstr = "select  registrationno from  m_vehicles where VehicleId='" + vehicleno + "'";
                    string registrationno = utl.ExecuteScalar(sqlstr);

                    printFuelVoucher(fuelvoucherno, fuelType, registrationno, nooflitre, priceperlitre, amount, OrifuelVoucherdate, receivedby, userName);
                    return "Updated";

                }
                else
                    return "Update Failed";
            }
            else
            {
                return "Already Exists, Update";
            }
        }
        else
        {
            sqlstr = "select isnull(count(*),0) from m_FuelVouchers where VoucherType='Fuel' and voucherno='" + fuelvoucherno + "'  and vehicleno='" + vehicleno + "'  and fueltypeid='" + fueltypeid + "' and priceperltr='" + priceperlitre + "' and amount='" + amount + "' and noofltr='" + nooflitre + "' and receivedby='" + receivedby + "' and Voucherdate=" + fuelVoucherdate + " and isactive=1 and FinancialID=(select FinancialID from m_financialyear where isactive=1)   ";
            string iCount = Convert.ToString(utl.ExecuteScalar(sqlstr));
            if (iCount == "0")
            {
                sqlstr = "sp_InsertFuelVoucher " + "'Fuel','" + fuelvoucherno + "','" + vehicleno + "','" + fueltypeid + "','" + priceperlitre + "','" + nooflitre + "','" + amount + "','" + receivedby + "'," + fuelVoucherdate + ",'" + Userid + "'";
                strQueryStatus = utl.ExecuteQuery(sqlstr);
                if (strQueryStatus == "")
                {
                    sqlstr = "select  registrationno from  m_vehicles where VehicleId='" + vehicleno + "'";
                    string registrationno = utl.ExecuteScalar(sqlstr);

                    printFuelVoucher(fuelvoucherno, fuelType, registrationno, nooflitre, priceperlitre, amount, OrifuelVoucherdate, receivedby, userName);
                    return "Inserted";
                }
                else
                    return "Insert Failed";
            }
            else
            {
                return "Already Exists, Insert";
            }
        }
    }
    [WebMethod]
    public static string DeleteFuelVoucher(string FuelVoucherID)
    {
        Utilities utl = new Utilities();
        string sqlstr = string.Empty;
        string strQueryStatus = string.Empty;
        string message = string.Empty;
        Userid = Convert.ToInt32(HttpContext.Current.Session["UserId"]);
        strQueryStatus = utl.ExecuteScalar("sp_DeleteFuelVoucher " + "" + FuelVoucherID + ",'" + Userid + "'");
        if (strQueryStatus == "")
            return "Deleted";
        else
            return strQueryStatus;
    }


    [WebMethod]
    public static string GetCashReturnVoucher(int pageIndex)
    {
        Utilities utl = new Utilities();
        string query = "[GetCashRetVoucher_Pager]";
        SqlCommand cmd = new SqlCommand(query);
        cmd.CommandType = CommandType.StoredProcedure;
        cmd.Parameters.AddWithValue("@PageIndex", pageIndex);
        cmd.Parameters.AddWithValue("@PageSize", PageSize);
        cmd.Parameters.Add("@RecordCount", SqlDbType.Int, 4).Direction = ParameterDirection.Output;
        cmd.Parameters.Add("@FinancialID", HttpContext.Current.Session["FinancialID"]);
        return GetCashReturnVoucherData(cmd, pageIndex).GetXml();
    }
    public static DataSet GetCashReturnVoucherData(SqlCommand cmd, int pageIndex)
    {

        string strConnString = ConfigurationManager.AppSettings["SIMCBSEConnection"].ToString();
        using (SqlConnection con = new SqlConnection(strConnString))
        {
            using (SqlDataAdapter sda = new SqlDataAdapter())
            {
                cmd.Connection = con;
                sda.SelectCommand = cmd;
                using (DataSet ds = new DataSet())
                {
                    sda.Fill(ds, "CashReturns");
                    DataTable dt = new DataTable("Pager");
                    dt.Columns.Add("PageIndex");
                    dt.Columns.Add("PageSize");
                    dt.Columns.Add("RecordCount");
                    dt.Columns.Add("FinancialID");
                    dt.Rows.Add();
                    dt.Rows[0]["PageIndex"] = pageIndex;
                    dt.Rows[0]["PageSize"] = PageSize;
                    dt.Rows[0]["RecordCount"] = cmd.Parameters["@RecordCount"].Value;
                    dt.Rows[0]["FinancialID"] = HttpContext.Current.Session["FinancialID"];
                    ds.Tables.Add(dt);
                    return ds;
                }
            }
        }
    }

    [WebMethod]
    public static string EditCashReturnVoucher(int CashReturnVoucherID)
    {
        Utilities utl = new Utilities();
        DataSet ds = new DataSet();
        string query = "sp_GetCashRetVoucher " + "" + CashReturnVoucherID + "";
        return utl.GetDatasetTable(query, "EditCashReturnVoucher").GetXml();
    }

    [WebMethod]
    public static string SaveCashReturnVoucher(string cashretvoucherid, string cashvoucherno, string dateofissue, string dateofreturn, string voucheramount, string returningamount, string userName)
    {
        string issDate = dateofissue;
        string retDate = dateofreturn;
        Utilities utl = new Utilities();
        string sqlstr = string.Empty;
        string strQueryStatus = string.Empty;
        string message = string.Empty;
        Userid = Convert.ToInt32(HttpContext.Current.Session["UserId"]);
        if (dateofissue != "")
        {
            string[] myDateTimeString = dateofissue.Split('/');
            dateofissue = "'" + myDateTimeString[2] + "/" + myDateTimeString[1] + "/" + myDateTimeString[0] + "'";
        }
        if (dateofreturn != "")
        {
            string[] myDateTimeString = dateofreturn.Split('/');
            dateofreturn = "'" + myDateTimeString[2] + "/" + myDateTimeString[1] + "/" + myDateTimeString[0] + "'";
        }

        if (!string.IsNullOrEmpty(cashretvoucherid))
        {
            sqlstr = "select isnull(count(*),0) from m_CashReturnVouchers where VoucherType='Cash Return' and CashVoucherId='" + cashvoucherno + "' and dateofissue=" + dateofissue + " and dateofreturn=" + dateofreturn + "  and voucheramount='" + voucheramount + "'  and returningamount='" + returningamount + "' and cashretvoucherid!='" + cashretvoucherid + "' and isactive=1 and FinancialID=(select FinancialID from m_financialyear where isactive=1)   ";
            string iCount = Convert.ToString(utl.ExecuteScalar(sqlstr));
            if (iCount == "0")
            {
                sqlstr = "sp_UpdateCashRetVoucher " + "" + cashretvoucherid + ",'Cash Return','" + cashvoucherno + "'," + dateofissue + "," + dateofreturn + ",'" + voucheramount + "'," + returningamount + ",'" + Userid + "'";
                strQueryStatus = utl.ExecuteQuery(sqlstr);
                if (strQueryStatus == "")
                {
                    printCashReturnVoucher(cashvoucherno, issDate, retDate, voucheramount, returningamount, userName);
                    return "Updated";
                }
                else
                    return "Update Failed";
            }
            else
            {
                return "Already Exists, Update";
            }
        }
        else
        {
            sqlstr = "select isnull(count(*),0) from m_CashReturnVouchers  where VoucherType='Cash Return' and CashVoucherId='" + cashvoucherno + "' and dateofissue=" + dateofissue + " and dateofreturn=" + dateofreturn + "  and voucheramount='" + voucheramount + "'  and returningamount='" + returningamount + "' and isactive=1 and FinancialID=(select FinancialID from m_financialyear where isactive=1)   ";
            string iCount = Convert.ToString(utl.ExecuteScalar(sqlstr));
            if (iCount == "0")
            {

                sqlstr = "sp_InsertCashRetVoucher " + "'Cash Return','" + cashvoucherno + "'," + dateofissue + "," + dateofreturn + ",'" + voucheramount + "'," + returningamount + ",'" + Userid + "'";
                strQueryStatus = utl.ExecuteQuery(sqlstr);
                if (strQueryStatus == "")
                {
                    printCashReturnVoucher(cashvoucherno, issDate, retDate, voucheramount, returningamount, userName);
                    return "Inserted";
                }
                else
                    return "Insert Failed";
            }
            else
            {
                return "Already Exists, Insert";
            }
        }
    }
    [WebMethod]
    public static string DeleteCashReturnVoucher(string CashReturnVoucherID)
    {
        Utilities utl = new Utilities();
        string sqlstr = string.Empty;
        string strQueryStatus = string.Empty;
        string message = string.Empty;
        Userid = Convert.ToInt32(HttpContext.Current.Session["UserId"]);
        strQueryStatus = utl.ExecuteScalar("sp_DeleteCashRetVoucher " + "" + CashReturnVoucherID + ",'" + Userid + "'");
        if (strQueryStatus == "")
            return "Deleted";
        else
            return strQueryStatus;
    }


    [WebMethod]
    public static string GetCashVoucherAmount(string cashvoucherno)
    {
        string query = "Select isnull(Amount,0) as  TotalAmount,convert(varchar(10),PaymentDate,103)  as PaymentDate from m_cashvouchers where CashVoucherId='" + cashvoucherno + "' and FinancialID=(select FinancialID from m_financialyear where isactive=1)   ";
        SqlCommand cmd = new SqlCommand(query);
        cmd.CommandType = CommandType.Text;
        return GetCashVoucherAmountData(cmd).GetXml();

    }
    public static DataSet GetCashVoucherAmountData(SqlCommand cmd)
    {

        string strConnString = ConfigurationManager.AppSettings["SIMCBSEConnection"].ToString();
        using (SqlConnection con = new SqlConnection(strConnString))
        {
            using (SqlDataAdapter sda = new SqlDataAdapter())
            {
                cmd.Connection = con;
                Utilities utl = new Utilities();
                sda.SelectCommand = cmd;
                using (DataSet ds = new DataSet())
                {
                    sda.Fill(ds, "CashVoucherAmt");
                    return ds;
                }
            }
        }
    }



    [WebMethod]
    public static string RePrintCashVoucher(string CashVoucherID)
    {
        Utilities utl = new Utilities();
        DataSet ds = new DataSet();
        string query = "sp_GetCashVoucher " + "" + CashVoucherID + "";
        ds = utl.GetDataset(query);
        if (ds.Tables[0].Rows.Count > 0)
        {
            foreach (DataRow dr in ds.Tables[0].Rows)
            {

                printCashVoucher(dr["VoucherNo"].ToString(), dr["PaymentTo"].ToString(), dr["PaymentFor"].ToString(), dr["Amount"].ToString(), dr["PaymentDate"].ToString(), dr["BillNo"].ToString(), dr["ExpenseTypeID"].ToString(), dr["PayType"].ToString(), dr["ChequeNo"].ToString(), dr["ChequeDate"].ToString(), dr["AccountNo"].ToString(), dr["staffshortname"].ToString(), dr["ExpenseTypeName"].ToString());

            }
        }

        if (isError == "yes")
            return "0";
        else
            return "1";

    }

    [WebMethod]
    public static string RePrintCashReturnVoucher(string CashReturnVoucherID)
    {
        Utilities utl = new Utilities();
        DataSet ds = new DataSet();
        string query = "sp_GetCashRetVoucher " + "" + CashReturnVoucherID + "";
        ds = utl.GetDataset(query);
        if (ds.Tables[0].Rows.Count > 0)
        {
            foreach (DataRow dr in ds.Tables[0].Rows)
            {
                printCashReturnVoucher(dr["VoucherNo"].ToString(), dr["DateOfIssue"].ToString(), dr["DateOfReturn"].ToString(), dr["VoucherAmount"].ToString(), dr["ReturningAmount"].ToString(), dr["StaffShortName"].ToString());

            }
        }

        if (isError == "yes")
            return "0";
        else
            return "1";

    }

    [WebMethod]
    public static string RePrintFuelVoucher(string FuelVoucherID)
    {
        Utilities utl = new Utilities();
        DataSet ds = new DataSet();
        string query = "sp_GetFuelVoucher " + "" + FuelVoucherID + "";
        ds = utl.GetDataset(query);
        if (ds.Tables[0].Rows.Count > 0)
        {
            foreach (DataRow dr in ds.Tables[0].Rows)
            {
                //string sqlstr = "select  registrationno from  m_vehicles where VehicleId='" + dr["VehicleNo"].ToString() + "'";
                //string registrationno = utl.ExecuteScalar(sqlstr);

                printFuelVoucher(dr["VoucherNo"].ToString(), dr["FuelName"].ToString(), dr["VehicleNo"].ToString(), dr["NoofLtr"].ToString(), dr["PricePerLtr"].ToString(), dr["Amount"].ToString(), dr["VoucherDate"].ToString(), dr["ReceivedBy"].ToString(), dr["staffshortname"].ToString());

            }
        }

        if (isError == "yes")
            return "0";
        else
            return "1";

    }


    protected void ddlFinancialyear_SelectedIndexChanged(object sender, EventArgs e)
    {
        if (ddlFinancialyear.SelectedIndex==0)
        {
            ScriptManager.RegisterClientScriptBlock(this.Page, this.GetType(), "myfunction", "<script type='text/javascript'> AlertMessage('info', 'Select Financial Year');</script>", false);
        }
        Session["FinancialID"] = ddlFinancialyear.SelectedValue.ToString();
        if (Session["FinancialID"].ToString() != "")
        {
            hfFinancialID.Value = Session["FinancialID"].ToString();
            ddlFinancialyear.SelectedValue = Session["FinancialID"].ToString();
            string isactive = utl.ExecuteScalar("select isactive from m_financialyear where FinancialID='" + ddlFinancialyear.SelectedValue + "'");
            //if (isactive == "False")
            //{
            //    ScriptManager.RegisterClientScriptBlock(this.Page, this.GetType(), "myfunction", "<script type='text/javascript'>ControlDisable('" + isactive + "');</script>", false);

            //}
            //else
            //{
            //    ScriptManager.RegisterClientScriptBlock(this.Page, this.GetType(), "myfunction", "<script type='text/javascript'>ControlDisable('" + isactive + "');</script>", false);
            //}
        }
    }    
}