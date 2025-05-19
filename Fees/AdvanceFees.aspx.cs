using System;
using System.Collections.Generic;
using System.Linq;
using System.Data;
using System.Text;
using System.Data.SqlClient;
using System.Web;
using System.Web.UI;
using System.Globalization;
using System.Web.UI.WebControls;
using System.Web.Services;
using System.Web.UI.HtmlControls;
using System.Configuration;
using System.Drawing.Printing;
using System.Drawing;
using System.Web.Script.Serialization;
using System.Data.OleDb;
using System.IO;


public partial class Fees_AdvanceFees : System.Web.UI.Page
{
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
            if (Request.QueryString["RegNo"]!=null)
            {
                hdnRegNo.Value = Request.QueryString["RegNo"].ToString();
            }


            if (Session["AcademicID"] != null && Session["AcademicID"].ToString() != string.Empty)
            {
                hdnAcademicId.Value = Session["AcademicID"].ToString();
            }
            else
            {
                Utilities utl = new Utilities();
                hdnAcademicId.Value = utl.ExecuteScalar("select top 1 academicid from m_academicyear where isactive=1 order by academicid desc");
            }


            hdnFinancialId.Value = "3";
            hdnDate.Value = DateTime.Now.ToString("dd/MM/yyyy");


            Userid = Convert.ToInt32(Session["UserId"]);
            hdnUserId.Value = Session["UserId"].ToString();
            if (!IsPostBack)
            {
                BindAcademicYear();
            }
        }
    }

    private void BindAcademicYear()
    {
        Utilities utl = new Utilities();
        DataTable dtAcademicYear = utl.GetDataTable("exec [sp_getAdvanceBelongYear]");
        if (dtAcademicYear != null && dtAcademicYear.Rows.Count > 0)
        {
            ListItem currentYear = new ListItem(dtAcademicYear.Rows[0]["Year"].ToString(), dtAcademicYear.Rows[0]["academicid"].ToString());
            currentYear.Selected = true;
            ListItem nextYear = null;
            rdlAdvanceFees.Items.Add(currentYear);
            if (dtAcademicYear.Rows != null && dtAcademicYear.Rows.Count>1)
            {
                nextYear = new ListItem(dtAcademicYear.Rows[1]["Year"].ToString(), dtAcademicYear.Rows[1]["academicid"].ToString());
                rdlAdvanceFees.Items.Add(nextYear);
            }
        }
    }


    [WebMethod]
    public static string BindAdvanceFees(string regNo, string academicId,string editPrm)
    {
        string strConnString = ConfigurationManager.AppSettings["SIMCBSEConnection"].ToString();

        StringBuilder str = new StringBuilder();
        DataSet dsManageFees = new DataSet();
        SqlConnection conn = new SqlConnection(strConnString);
        SqlCommand cmd = new SqlCommand("sp_ManageAdvanceFee");
        cmd.CommandType = CommandType.StoredProcedure;
        cmd.Parameters.AddWithValue("@regno", regNo);
        cmd.Parameters.AddWithValue("@AcademicId", academicId);
        cmd.Parameters.Add("@FeesCatId", SqlDbType.Int).Direction = ParameterDirection.Output;
        cmd.Parameters.Add("@FeesMonthName", SqlDbType.VarChar, 20).Direction = ParameterDirection.Output;
        cmd.Parameters.Add("@FeesTotalAmt", SqlDbType.Decimal, 18).Direction = ParameterDirection.Output;
        cmd.Parameters["@FeesTotalAmt"].Precision = 18;
        cmd.Parameters["@FeesTotalAmt"].Scale = 2;
        cmd.Parameters.Add("@FeesMonth", SqlDbType.VarChar, 20).Direction = ParameterDirection.Output;
        cmd.Parameters.Add("@FeesType", SqlDbType.VarChar, 20).Direction = ParameterDirection.Output;
        conn.Open();
        cmd.Connection = conn;
        SqlDataAdapter daManageFees = new SqlDataAdapter();
        daManageFees.SelectCommand = cmd;

        daManageFees.Fill(dsManageFees);
        conn.Close();



        string firstContent = string.Empty;
        string secondContent = string.Empty;
        string thirdContent = string.Empty;

        if (dsManageFees != null && dsManageFees.Tables.Count > 0)
        {
           firstContent = GetFirstContent(dsManageFees, cmd, regNo, academicId,editPrm);
           secondContent = GetSecondContent(dsManageFees, cmd, regNo, academicId);
        //    thirdContent = GetThirdContent(dsManageFees, cmd, regNo, academicId);
        }

        DataSet ds = new DataSet();
      DataTable dt = new DataTable("FirstContent");
        dt.Columns.Add(new DataColumn("firsthtml", typeof(string)));

        DataRow dr = dt.NewRow();
        dr["firsthtml"] = firstContent;
        dt.Rows.Add(dr);

        DataTable dt2 = new DataTable("SecondContent");
            dt2.Columns.Add(new DataColumn("secondhtml", typeof(string)));

            DataRow dr2 = dt2.NewRow();
            dr2["secondhtml"] = secondContent;
            dt2.Rows.Add(dr2);


            /*     DataTable dt3 = new DataTable("ThirdContent");
           dt3.Columns.Add(new DataColumn("thirdhtml", typeof(string)));

           DataRow dr3 = dt3.NewRow();
           dr3["thirdhtml"] = thirdContent;
           dt3.Rows.Add(dr3);  */


          ds.Tables.Add(dt);
        ds.Tables.Add(dt2);
      //  ds.Tables.Add(dt3);

        return ds.GetXml();

    }




    public static string GetFirstContent(DataSet dsManageFees, SqlCommand cmd, string regno, string academicId,string editPrm)
    {

        StringBuilder divThirdContent = new StringBuilder();
        string strOptions = string.Empty;
        string _Billno = string.Empty;
        string _BillDate = string.Empty;
        string _BillUser = string.Empty;
        string feesCatHeadId = string.Empty;
        string feesHeadAmt = string.Empty;
        string feesCatId = string.Empty;
        string feesMonthName = string.Empty;
        string feestotalAmount = string.Empty;


        if (cmd.Parameters["@FeesType"].Value.ToString().Trim().ToUpper() == "ADVANCE")
        {


            if (cmd.Parameters["@FeesCatId"] != null)
                feesCatId = cmd.Parameters["@FeesCatId"].Value.ToString();

            if (cmd.Parameters["@FeesMonthName"] != null)
                feesMonthName = cmd.Parameters["@FeesMonthName"].Value.ToString();

            if (cmd.Parameters["@FeesTotalAmt"] != null)
                feestotalAmount = cmd.Parameters["@FeesTotalAmt"].Value.ToString();

            if (dsManageFees.Tables[2].Rows.Count > 0)
            {
                for (int k = 0; k < dsManageFees.Tables[2].Rows.Count; k++)
                {

                    feesCatHeadId += dsManageFees.Tables[2].Rows[k]["feescatheadid"].ToString() + "|";
                    feesHeadAmt += "0.00|";
                }
            }

            _Billno = "<td class='center'>-</td>";
            _BillDate = "<td class='center'>-</td>";
            _BillUser = "<td class='center'>-</td>";

            strOptions = "<table cellpadding='10' cellspacing='10' > <tr><td><a href='javascript:CreateBill();' class='creat-link'> <img src='../img/creat.png' alt='' width='22' height='22' align='absmiddle' />  Create </a> </td><td> <a href='javascript:IgnoreBill(\"" + regno + "\",\"" + academicId + "\",\"" + feesCatHeadId + "\",\"" + feesHeadAmt + "\",\"" + feesCatId + "\",\"" + feesMonthName + "\",\"0.00\");'  class='creat-link' > <img src='../img/ignor.jpg' alt='' width='22' height='22' align='absmiddle' />   Ignore </a> </td></tr></table>";

            divThirdContent.Append(" <table class='data display datatable' id='example'><thead><tr><th width='20%' class='sorting_mod center' >Months</th><th width='20% center' class='sorting_mod' >Receipt/Bill No</th><th width='16%' class='sorting_mod center' >Date</th><th width='18%' class='sorting_mod center' >Received By</th><th width='30% center' class='sorting_mod' >Option</th></tr></thead>");

            divThirdContent.Append("<tr class='odd gradeX'><td class='center'> Advance Fee</td>");
            divThirdContent.Append(_Billno);
            divThirdContent.Append(_BillDate);
            divThirdContent.Append(_BillUser);
            divThirdContent.Append("<td>" + strOptions.ToString() + "</td>");
            divThirdContent.Append("</tr>");
            divThirdContent.Append("</table>");

        }
        else if (cmd.Parameters["@FeesType"].Value.ToString().Trim().ToUpper() == "PAID")
        {
            DataRow[] drPaidFees = dsManageFees.Tables[0].Select(" feescatcode='F' ");
            if (drPaidFees.Length > 0)
            {

                _Billno = "<td class='center'>-</td>";
                _BillDate = "<td class='center'>-</td>";
                _BillUser = "<td class='center'>-</td>";

                divThirdContent.Append(" <table class='data display datatable' id='example'><thead><tr><th width='20%' class='sorting_mod center' >Months</th><th width='20% center' class='sorting_mod' >Receipt/Bill No</th><th width='16%' class='sorting_mod center' >Date</th><th width='18%' class='sorting_mod center' >Received By</th><th width='30% center' class='sorting_mod' >Option</th></tr></thead>");

                _Billno = "<td class='center'>" + drPaidFees[0]["billno"].ToString() + "</td>";
                _BillDate = "<td class='center'>" + drPaidFees[0]["billdate"].ToString() + "</td>";
                _BillUser = "<td class='center'>" + drPaidFees[0]["staffshortname"].ToString() + "</td>";
                strOptions = "<table cellpadding='10' cellspacing='10' > <tr><td> <a href='javascript:ViewBill(\"" + drPaidFees[0]["billid"].ToString() + "\");'  class='creat-link'>  <img src='../img/creat.png' alt='' width='22' height='22' align='absmiddle' />  View </a> </td>";

                if (editPrm == "true")
                {
                    strOptions += " <td> <a href='javascript:PrintBill(\"" + drPaidFees[0]["billid"].ToString() + "\");'  class='creat-link' >  <img src='../img/print.png' alt='' width='22' height='22' align='absmiddle' />  Print </a> </td>";
                }                 
                strOptions += "</tr></table>";

                divThirdContent.Append("<tr class='odd gradeX'><td class='center'> Advance Fee</td>");
                divThirdContent.Append(_Billno);
                divThirdContent.Append(_BillDate);
                divThirdContent.Append(_BillUser);
                divThirdContent.Append("<td>" + strOptions.ToString() + "</td>");
                divThirdContent.Append("</tr>");
                divThirdContent.Append("</table>");

            }


        }

        return divThirdContent.ToString();

    }

    public static string GetSecondContent(DataSet dsManageFees, SqlCommand cmd, string regno, string academicId)
    {
        StringBuilder feePOPUPStudentDetails = new StringBuilder();
        StringBuilder feePOPUPHeadDetails = new StringBuilder();
        StringBuilder feePOPUPContent = new StringBuilder();

        if (dsManageFees.Tables[2].Rows.Count > 0 )
        {

            string feesCatHeadId = "";
            string feesHeadAmt = "";
            string feesCatId = string.Empty;
            string feesMonthName = string.Empty;
            string feestotalAmount = string.Empty;
            string paymentMode = string.Empty;

            if (cmd.Parameters["@FeesCatId"] != null)
                feesCatId = cmd.Parameters["@FeesCatId"].Value.ToString();

            if (cmd.Parameters["@FeesMonthName"] != null)
                feesMonthName = cmd.Parameters["@FeesMonthName"].Value.ToString();

            if (cmd.Parameters["@FeesTotalAmt"] != null)
                feestotalAmount = cmd.Parameters["@FeesTotalAmt"].Value.ToString();

            if (cmd.Parameters["@FeesMonth"].Value.ToString() != string.Empty)
            {

                if (dsManageFees.Tables[dsManageFees.Tables.Count - 1].Rows.Count > 0)
                {
                    paymentMode = "<select id=\"selPaymentMode\" name=\"selPaymentMode\">";
                    for (int q = 0; q < dsManageFees.Tables[dsManageFees.Tables.Count - 1].Rows.Count; q++)
                    {

                        paymentMode += "<option value=\"" + dsManageFees.Tables[dsManageFees.Tables.Count - 1].Rows[q]["paymentmodeid"].ToString() + "\">" + dsManageFees.Tables[dsManageFees.Tables.Count - 1].Rows[q]["paymentmodename"].ToString() + "</option>";

                    }
                    paymentMode += "</select>";
                }


                feePOPUPStudentDetails.Append(@"<table width='700px' border='0' cellpadding='3'  cellspacing='0' class='popup-form' >
                                           <tr>
	                                          <td width='105' >Reg No</td>
	                                          <td width='16' >:</td>
	                                          <td width='245' ><label for='textfield2'>" + dsManageFees.Tables[1].Rows[0]["regno"].ToString() + "</label> </td>");
                feePOPUPStudentDetails.Append(@"<td >Date Of Paid</td>
	                                          <td >:</td>
	                                          <td ><input type='text' name='txtBillDate' id='txtBillDate' class='ptxtbx ' /></td>
	                                          </tr>");
                feePOPUPStudentDetails.Append(@"<tr><td width='104' height='30' >Name</td>
	                                          <td width='12' >:</td>
	                                          <td width='258' ><label for='textfield2'>" + dsManageFees.Tables[1].Rows[0]["stname"].ToString().ToUpper() + "</label></td>");
                feePOPUPStudentDetails.Append(@"<td width='105' >Month </td>
	                                      <td width='16' >:</td>
	                                      <td width='245' ><label for='textfield2'>" + feesMonthName + "</label></td></tr>");
                feePOPUPStudentDetails.Append(@"<tr>
	                              <td height='30' >Class</td>
	                              <td >:</td>
	                              <td ><label for='textfield2'>" + dsManageFees.Tables[1].Rows[0]["classname"].ToString().ToUpper() + "</label></td></tr>");
                if (paymentMode != string.Empty)
                {
                    feePOPUPStudentDetails.Append(@"<tr><td >Payment Mode</td>
	                                          <td >:</td>
	                                          <td >" + paymentMode + "</td><td></td><td></td><td></td></tr>");
                }
                feePOPUPStudentDetails.Append(@"</tr></table>");  
       




                if (dsManageFees.Tables[2].Rows.Count > 0 )
                {

                    feePOPUPHeadDetails.Append(@" <table width='100%' border='0' cellspacing='0' cellpadding='5' class='popup-form'>
	                                          <tr class='tlb-trbg'><td width='79%' height='30'>Heads</td><td width='21%'>Amount</td></tr>");
                    for (int k = 0; k < dsManageFees.Tables[2].Rows.Count; k++)
                    {
                        feesCatHeadId += dsManageFees.Tables[2].Rows[k]["feescatheadid"].ToString() + "|";
                        feesHeadAmt += dsManageFees.Tables[2].Rows[k]["amount"].ToString() + "|";
                        feePOPUPHeadDetails.Append(@"<tr><td height='30' class='tdbrd'> " + dsManageFees.Tables[2].Rows[k]["feesheadname"].ToString().ToUpper() + "</td>");
                        feePOPUPHeadDetails.Append(@"<td class='tdbrd'>" + dsManageFees.Tables[2].Rows[k]["amount"].ToString().ToUpper() + "</td></tr>");

                    }
                    feePOPUPHeadDetails.Append(@"<tr class='tlt-rs'><td height='30' class='tdbrd'>Total </td>
                                                    <td class='tdbrd'>Rs. " + cmd.Parameters["@FeesTotalAmt"].Value.ToString() + "</td></tr></table>");

                }

                feePOPUPContent.Append(@"<table width='650px' border='0' cellpadding='3'  cellspacing='0' class='popup-form tlt-mainbrd' style='border: 1px solid #bfbfbf; background-color:#fff;'>");
                feePOPUPContent.Append("<tr><td style='padding: 10px 10px 0px;float:right;'><a href='javascript:closeCreateBill()'>close</a></td></tr>");
                feePOPUPContent.Append("<tr><td  class='popup-form' style='padding:6px;'>" + feePOPUPStudentDetails.ToString() + "</td></tr>");

                feePOPUPContent.Append(@"<tr><td  class='popup-form' style='padding:6px;'>" + feePOPUPHeadDetails.ToString() + "</td></tr>");
                feePOPUPContent.Append("<tr><td style='text-align:center;' ><input id=\"btnSubmit\" type=\"button\" class=\"btn btn-navy\"  value=\"Save & Print\" onclick=\"SaveFeesBill(\'" + regno + "\',\'" + academicId + "\',\'" + feesCatHeadId + "\',\'" + feesHeadAmt + "\',\'" + feesCatId + "\',\'" + feesMonthName + "\',\'" + feestotalAmount + "\');\" /></td> </tr>");
                feePOPUPContent.Append(@"<tr><td colspan='6' ></td></tr> </table>");

                //divBillContents.InnerHtml = feePOPUPContent.ToString();
            }
        }
        return feePOPUPContent.ToString();
    }


    [WebMethod]
    public static string SaveBillDetails(string regNo, string AcademicId,  string FeesHeadIds, string FeesAmount, string FeesCatId, string FeesMonthName, string FeestotalAmount, string BillDate, string userId, string PaymentMode)
    {
        Utilities utl = new Utilities();
        FeesHeadIds = FeesHeadIds.Substring(0, FeesHeadIds.Length - 1);
        FeesAmount = FeesAmount.Substring(0, FeesAmount.Length - 1);
        string[] feeHead = FeesHeadIds.Split('|');
        string[] feeAmount = FeesAmount.Split('|');

        string subQuery = string.Empty;
        int i = 0;
        foreach (string head in feeHead)
        {
            subQuery += "INSERT INTO [dbo].[f_studentbills]([BillId],[FeesCatHeadId],[BillMonth],[Amount],[IsActive],[UserId])VALUES(''DummyBill''," + head + ",''" + FeesMonthName + "''," + feeAmount[i] + ",''True''," + userId + ")";
            i++;
        }

        if (BillDate == string.Empty)
        {
            BillDate = DateTime.Now.ToString("dd/MM/yyyy");


        }

        string[] formats = { "dd/MM/yyyy" };
        string formatBillDate = DateTime.ParseExact(BillDate, formats, new CultureInfo("en-US"), DateTimeStyles.None).ToShortDateString();

        string query = "[SP_InsertFeesBill] '0000'," + AcademicId + "," + FeesCatId + "," + regNo + ",'" + FeesMonthName + "'," + FeestotalAmount + ",'" + formatBillDate + "'," + userId + ",'" + subQuery + "'," + PaymentMode;

      //  string strQueryStatus = utl.ExecuteQuery(query);

        DataSet dsSaveBill = utl.GetDataset(query);

        if (dsSaveBill != null && dsSaveBill.Tables.Count > 0 && dsSaveBill.Tables[0].Rows.Count > 0)
        {
            PrintBill(dsSaveBill.Tables[0].Rows[0][0].ToString());   
            return "Updated";
        }
        else
            return "Failed";

      
    }

    [WebMethod]
    public static string ViewBillDetails(string billId)
    {
        Utilities utl = new Utilities();
        string query = "[sp_GetStudentAdvanceBill] " + billId + "";
        DataSet ds = utl.GetDataset(query);
        return ds.GetXml();
    }

    [WebMethod]
    public static string BindStudDetails(string regNo, string academicId)
    {
        Utilities utl = new Utilities();
        DataSet dsStud = utl.GetDataset("sp_getStudentAdvanceDetails " + regNo + "," + academicId);
        return dsStud.GetXml();
    }

    [WebMethod]
    public static string PrintBillDetails(string billId)
    {
        PrintBill(billId);
        return "";
    }

    public static void PrintBill(string billId)
    {
        try
        {
            PrintDocument fd = new PrintDocument();
            Utilities utl = new Utilities();
            string query = "[sp_GetStudentAdvanceBill] " + billId + "";
            DataSet dsPrint = utl.GetDataset(query);
            int yPos = 0;
            int headCount = 0;
            string printerName = ConfigurationManager.AppSettings["FeesPrinter"];
            string clientMachineName, clientIPAddress;
            //  clientMachineName = (Dns.GetHostEntry(Request.ServerVariables["remote_addr"]).HostName);
            clientIPAddress = HttpContext.Current.Request.ServerVariables["remote_addr"];

            if (dsPrint.Tables.Count > 1)
            {
                StringBuilder str = new StringBuilder();
            

                StringBuilder str1 = new StringBuilder();

                StringFormat stringAlignRight = new StringFormat();
                stringAlignRight.Alignment = StringAlignment.Far;
                stringAlignRight.LineAlignment = StringAlignment.Center;

                StringFormat stringAlignLeft = new StringFormat();
                stringAlignLeft.Alignment = StringAlignment.Near;
                stringAlignLeft.LineAlignment = StringAlignment.Center;

                StringFormat stringAlignCenter = new StringFormat();
                stringAlignCenter.Alignment = StringAlignment.Center;
                stringAlignCenter.LineAlignment = StringAlignment.Center;


                fd.PrintPage += (s, args) =>
                {

                    if (dsPrint.Tables[0].Rows.Count > 0)
                    {
                        args.Graphics.DrawString(dsPrint.Tables[2].Rows[0]["SchoolShortName"].ToString().ToUpper(), new System.Drawing.Font("ARIAL", 9, FontStyle.Regular), Brushes.Black, new Rectangle(0, 0, 250, 25), stringAlignCenter);
                        args.Graphics.DrawString(dsPrint.Tables[2].Rows[0]["Schoolstate"].ToString().ToUpper() + "-" + dsPrint.Tables[2].Rows[0]["SchoolZip"].ToString() + " PHONE NO-" + dsPrint.Tables[2].Rows[0]["phoneno"].ToString().ToUpper(), new System.Drawing.Font("ARIAL", 8, FontStyle.Regular), Brushes.Black, new Rectangle(0, 20, 250, 25), stringAlignLeft);

                        args.Graphics.DrawLine(new Pen(Color.Black, 2), 0, 42, 500, 42);
                        args.Graphics.DrawString("Reg.No : " + dsPrint.Tables[0].Rows[0]["RegNo"].ToString(), new System.Drawing.Font("ARIAL", 9, FontStyle.Regular), Brushes.Black, new Rectangle(0, 45, 130, 50), stringAlignLeft);
                        args.Graphics.DrawString("Rec.No : " + dsPrint.Tables[0].Rows[0]["BillNo"].ToString(), new System.Drawing.Font("ARIAL", 9, FontStyle.Regular), Brushes.Black, new Rectangle(120, 45, 120, 50), stringAlignRight);
                        args.Graphics.DrawString("Name 	:  " + dsPrint.Tables[0].Rows[0]["stname"].ToString(), new System.Drawing.Font("ARIAL", 9, FontStyle.Regular), Brushes.Black, new Rectangle(0, 70, 250, 50), stringAlignLeft);
                        args.Graphics.DrawString("Class : 	" + dsPrint.Tables[0].Rows[0]["classname"].ToString(), new System.Drawing.Font("ARIAL", 9, FontStyle.Regular), Brushes.Black, new Rectangle(0, 95, 130, 50), stringAlignLeft);
                        args.Graphics.DrawString(" Month 	: 	" + dsPrint.Tables[0].Rows[0]["BillMonth"].ToString(), new System.Drawing.Font("ARIAL", 9, FontStyle.Regular), Brushes.Black, new Rectangle(120, 95, 120, 50), stringAlignRight);
                        args.Graphics.DrawString("PARTICULARS", new System.Drawing.Font("ARIAL", 9, FontStyle.Regular), Brushes.Black, new Rectangle(0, 135, 180, 50), stringAlignCenter);
                        args.Graphics.DrawString("AMOUNT ", new System.Drawing.Font("ARIAL", 9, FontStyle.Regular), Brushes.Black, new Rectangle(180, 135, 70, 50), stringAlignCenter);
                        if (dsPrint.Tables[1].Rows.Count > 0)
                        {
                            yPos = 158;

                            for (int i = 0; i < dsPrint.Tables[1].Rows.Count; i++, yPos += 30, headCount += 1)
                            {

                                args.Graphics.DrawString(dsPrint.Tables[1].Rows[i]["FeesHeadName"].ToString(), new System.Drawing.Font("ARIAL", 9, FontStyle.Regular), Brushes.Black, new Rectangle(5, yPos, 180, 50), stringAlignLeft);
                                args.Graphics.DrawString(dsPrint.Tables[1].Rows[i]["Amount"].ToString(), new System.Drawing.Font("ARIAL", 9, FontStyle.Regular), Brushes.Black, new Rectangle(165, yPos, 70, 50), stringAlignRight);
                            }
                        }

                        args.Graphics.DrawString("TOTAL", new System.Drawing.Font("ARIAL", 9, FontStyle.Regular), Brushes.Black, new Rectangle(0, yPos + 8, 180, 50), stringAlignRight);
                        args.Graphics.DrawString(dsPrint.Tables[0].Rows[0]["TotalAmount"].ToString(), new System.Drawing.Font("ARIAL", 9, FontStyle.Regular), Brushes.Black, new Rectangle(165, yPos + 8, 70, 50), stringAlignRight);


                        args.Graphics.DrawString("Date : " + dsPrint.Tables[0].Rows[0]["BillDate"].ToString(), new System.Drawing.Font("ARIAL", 9, FontStyle.Regular), Brushes.Black, new Rectangle(0, yPos + 40, 250, 50), stringAlignLeft);
                        args.Graphics.DrawString("Cashier : " + dsPrint.Tables[0].Rows[0]["staffname"].ToString(), new System.Drawing.Font("ARIAL", 9, FontStyle.Regular), Brushes.Black, new Rectangle(0, yPos + 70, 250, 50), stringAlignLeft);

                        args.Graphics.DrawRectangle(new Pen(Color.Black, 1), 0, 145, 180, 25);
                        args.Graphics.DrawRectangle(new Pen(Color.Black, 1), 180, 145, 68, 25);

                        args.Graphics.DrawRectangle(new Pen(Color.Black, 1), 0, 170, 180, 30 * headCount);
                        args.Graphics.DrawRectangle(new Pen(Color.Black, 1), 180, 170, 68, 30 * headCount);

                        args.Graphics.DrawRectangle(new Pen(Color.Black, 1), 0, yPos + 12, 180, 35);
                        args.Graphics.DrawRectangle(new Pen(Color.Black, 1), 180, yPos + 12, 68, 35);
                    }





                };
                fd.PrinterSettings.PrinterName = "\\\\" + clientIPAddress + "\\" + printerName + "";
                fd.Print();
            }
            fd.Dispose();
            GC.SuppressFinalize(fd);
        }
        catch (Exception err)
        {


        }
        finally { GC.Collect(); }
    }


    protected void Button1_Click(object sender, EventArgs e)
    {
        Utilities utl = new Utilities();
        try
        {
            if (!FileUpload1.HasFile)
            {
                return;
            }
            if (File.Exists(Server.MapPath(".//") + FileUpload1.PostedFile.FileName) == true)
            {
                File.Delete(Server.MapPath(".//") + FileUpload1.PostedFile.FileName);
            }
            FileUpload1.SaveAs(Server.MapPath(".//") + System.DateTime.Now.ToString("yyyyMMddhhmmss") + FileUpload1.PostedFile.FileName);

            string path = Server.MapPath(".//") + System.DateTime.Now.ToString("yyyyMMddhhmmss") + FileUpload1.PostedFile.FileName;
            //  DisplayData();

            string excelConnectionString = "";
            OleDbConnection excelConnection = null;
            OleDbCommand cmd = null;
            try
            {
                excelConnectionString = @"Provider=Microsoft.Jet.OLEDB.4.0;Data Source=" + path + ";Extended Properties='Excel 8.0;HDR=Yes'";
                excelConnection = new OleDbConnection(excelConnectionString);
                cmd = new OleDbCommand("Select regno,amount,datefor,receiptno,remarks,oldregno  from [sheet1$]", excelConnection);
                cmd.CommandTimeout = 50000;
                excelConnection.Open();
            }
            catch
            {
                excelConnectionString = @"Provider=Microsoft.ACE.OLEDB.12.0;Data Source=" + path + ";Extended Properties='Excel 8.0;HDR=No'";
                excelConnection = new OleDbConnection(excelConnectionString);
                cmd = new OleDbCommand("Select regno,amount,datefor,receiptno,remarks,oldregno from [sheet1$]", excelConnection);
                cmd.CommandTimeout = 50000;
                excelConnection.Open();
            }
            OleDbDataAdapter da = new OleDbDataAdapter(cmd);
            DataSet ds = new DataSet();
            da.Fill(ds);
            excelConnection.Close();
            if (ds.Tables[0].Rows.Count > 0)
            {
                for (int i = 0; i < ds.Tables[0].Rows.Count; i++)
                {
                    string sqlstr = "";
                    string regno = ds.Tables[0].Rows[i]["regno"].ToString();
                    string amount = ds.Tables[0].Rows[i]["amount"].ToString();
                    string datefor = ds.Tables[0].Rows[i]["datefor"].ToString();
                    string receiptno = ds.Tables[0].Rows[i]["receiptno"].ToString();
                    string datepaid = Convert.ToDateTime(datefor).ToString("yyyy-MM-dd");
                    string remarks = ds.Tables[0].Rows[i]["remarks"].ToString();
                    string oldregno = ds.Tables[0].Rows[i]["oldregno"].ToString();
                    if (remarks.ToLower() == "transfer")
                    {
                        int icnt = Convert.ToInt32(utl.ExecuteScalar("select  isnull(COUNT(*),0) from s_studentpromotion where AcademicId=31 and regno='" + regno + "'"));
                        if (icnt == 0 || icnt == null)
                        {
                            utl.ExecuteQuery(@"insert into dbo.s_studentpromotion(regno,ClassID,SectionID,BusFacility,Concession,Hostel,Scholar
                            ,AcademicId,Active,UserId)(select " + regno + ",ClassId,SectionId,BusFacility,Concession,Hostel,Scholar,31,Active,1 from  SIMV6.dbo.s_studentpromotion where regno=" + oldregno + " and AcademicId=15)");
                        }

                        sqlstr = @"select e.*, e.FeesCatHeadID,e.FeesHeadId,e.Amount from s_studentinfo info 
	                          inner join s_studentpromotion promo on info.RegNo=promo.RegNo  
	                          inner join m_feescategoryhead e on e.ClassId=promo.ClassId and e.AcademicId=promo.AcademicId
	                          and e.FeesCategoryId= case when promo.Active='C' then '1' when promo.Active='N' then '2' end  and e.isactive=1
	                          inner join m_feeshead f on f.FeesHeadId=e.FeesHeadId and f.FeesHeadCode='A'
                            where promo.academicID=31 and info.regno='" + regno + "'";

                        DataTable dtfee = new DataTable();

                        dtfee = utl.GetDataTable(sqlstr);
                        if (dtfee != null && dtfee.Rows.Count > 0)
                        {
                            for (int k = 0; k < dtfee.Rows.Count; k++)
                            {
                                string subQuery = string.Empty;

                                int COUNT = Convert.ToInt32(utl.ExecuteScalar("select COUNT(billno) from f_studentbillmaster where FinancialId=12 and isactive=1"));
                                COUNT = COUNT + 1;

                                string iexists = utl.ExecuteScalar("select isnull(count(*),0) from f_studentbillmaster where isactive=1 and FinancialId=12 and billrefno='" + receiptno + "' and regno='" + regno + "'");
                                if (iexists == "" || iexists == "0")
                                {

                                    string query = @" INSERT INTO [dbo].[f_studentbillmaster]                      
                                               ([BillNo]                      
                                               ,[FinancialId]                      
                                               ,[AcademicId]                      
                                               ,[FeesCategoryId]                      
                                               ,[RegNo]                      
                                               ,[BillMonth]                      
                                               ,[TotalAmount]                      
                                               ,[BillDate]               
                                               ,[PaymentModeId]                     
                                               ,[IsActive]                      
                                               ,[UserId]
                                                ,billrefno                       
                                               )                      
                                         VALUES                      
                              (('0000' +convert(nvarchar(20)," + COUNT + ")) ,12,31," + dtfee.Rows[k]["FeesCategoryId"].ToString() + ",'" + regno + "','Mar'," + amount + ",'" + datepaid + "',1  ,'True' ,1,'" + receiptno + "')";
                                    utl.ExecuteQuery(query);

                                    string BillID = utl.ExecuteScalar("SELECT max(BillID) from f_studentbillmaster");

                                    subQuery = "INSERT INTO [dbo].[f_studentbills]([BillId],[FeesCatHeadId],[BillMonth],[Amount],[IsActive],[UserId])VALUES(" + BillID + "," + dtfee.Rows[k]["FeesCatHeadID"].ToString() + ",'Mar',10000,'True',1)";

                                    utl.ExecuteQuery(subQuery);

                                    utl.ExecuteQuery("insert into f_studentpaymodebills(BillID,CashAmount,CardAmount,Isactive,userID)values(" + BillID + ",10000,0,'True',1)");

                                }
                            }
                        }
                    }
                    else
                    {
                        sqlstr = @"select e.*, e.FeesCatHeadID,e.FeesHeadId,e.Amount from s_studentinfo info 
	                          inner join s_studentpromotion promo on info.RegNo=promo.RegNo  
	                          inner join m_feescategoryhead e on e.ClassId=promo.ClassId and e.AcademicId=promo.AcademicId
	                          and e.FeesCategoryId= case when promo.Active='C' then '1' when promo.Active='N' then '2' end  and e.isactive=1
	                          inner join m_feeshead f on f.FeesHeadId=e.FeesHeadId and f.FeesHeadCode='A'
                            where promo.academicID=31 and info.regno='" + regno + "'";

                        DataTable dtfee = new DataTable();

                        dtfee = utl.GetDataTable(sqlstr);
                        if (dtfee != null && dtfee.Rows.Count > 0)
                        {
                            for (int k = 0; k < dtfee.Rows.Count; k++)
                            {
                                string subQuery = string.Empty;

                                int COUNT = Convert.ToInt32(utl.ExecuteScalar("select COUNT(billno) from f_studentbillmaster where FinancialId=12 and isactive=1"));
                                COUNT = COUNT + 1;

                                string iexists = utl.ExecuteScalar("select isnull(count(*),0) from f_studentbillmaster where isactive=1 and FinancialId=12 and billrefno='" + receiptno + "' and regno='" + regno + "'");
                                if (iexists == "" || iexists == "0")
                                {

                                    string query = @" INSERT INTO [dbo].[f_studentbillmaster]                      
                                               ([BillNo]                      
                                               ,[FinancialId]                      
                                               ,[AcademicId]                      
                                               ,[FeesCategoryId]                      
                                               ,[RegNo]                      
                                               ,[BillMonth]                      
                                               ,[TotalAmount]                      
                                               ,[BillDate]               
                                               ,[PaymentModeId]                     
                                               ,[IsActive]                      
                                               ,[UserId]
                                                ,billrefno                       
                                               )                      
                                         VALUES                      
                              (('0000' +convert(nvarchar(20)," + COUNT + ")) ,12,31," + dtfee.Rows[k]["FeesCategoryId"].ToString() + ",'" + regno + "','Mar'," + amount + ",'" + datepaid + "',1  ,'True' ,1,'" + receiptno + "')";
                                    utl.ExecuteQuery(query);

                                    string BillID = utl.ExecuteScalar("SELECT max(BillID) from f_studentbillmaster");

                                    subQuery = "INSERT INTO [dbo].[f_studentbills]([BillId],[FeesCatHeadId],[BillMonth],[Amount],[IsActive],[UserId])VALUES(" + BillID + "," + dtfee.Rows[k]["FeesCatHeadID"].ToString() + ",'Mar',10000,'True',1)";

                                    utl.ExecuteQuery(subQuery);

                                    utl.ExecuteQuery("insert into f_studentpaymodebills(BillID,CashAmount,CardAmount,Isactive,userID)values(" + BillID + ",10000,0,'True',1)");

                                }
                            }
                        }
                    }
                }
            }

            FileUpload1.Dispose();
            File.Delete(path);
            utl.ShowMessage("Uploaded Successfully", this.Page);
        }
        catch (Exception ex)
        {
            FileUpload1.Dispose();
            utl.ShowMessage("File content problem, cant upload the file. kindly check it" + ex, this.Page);

        }
    }
}