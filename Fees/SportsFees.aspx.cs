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
using System.IO;

public partial class Students_SportsFees : System.Web.UI.Page
{
    Utilities utl = null;
    public static int Userid = 0;
    private static int PageSize = 10;
    protected void Page_Load(object sender, EventArgs e)
    {
        Master.chkUser();
        if (Session["UserId"] == null || Session["AcademicID"] == null)
        {
            Response.Redirect("Default.aspx?ses=expired");
        }
        else
        {
            if (Request.QueryString.AllKeys.Contains("regno"))
            {
                hdnRegNo.Value = Request.QueryString["regno"].ToString();

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
                //  BindAcademicYearMonth();
            }
        }
    }
    [WebMethod]
    public static string BindAcademicYearMonth(string regNo, string academicId, string editPrm, string delPrm)
    {
        string strConnString = ConfigurationManager.AppSettings["SIMCBSEConnection"].ToString();

        StringBuilder str = new StringBuilder();
        DataSet dsManageFees = new DataSet();
        SqlConnection conn = new SqlConnection(strConnString);
        Utilities utl = new Utilities();
        
        string sqlstr = "select isactive from m_academicyear where AcademicID='" + HttpContext.Current.Session["AcademicID"].ToString() + "'";
        string Isactive = utl.ExecuteScalar(sqlstr);
        HttpContext.Current.Session["Isactive"] = Isactive.ToString();
        string query = "";
        SqlCommand cmd = new SqlCommand();
        if (Isactive == "True")
        {
           cmd = new SqlCommand("sp_ManageSportsFee");
        }
        else
        {
           cmd = new SqlCommand("sp_ManageOldSportsFee");
        }
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
        cmd.Parameters.Add("@isTerm", SqlDbType.Int).Direction = ParameterDirection.Output;

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
            firstContent = GetFirstContent(dsManageFees, cmd, regNo, academicId,editPrm, delPrm);
            secondContent = GetSecondContent(dsManageFees, cmd, regNo, academicId);
            thirdContent = GetThirdContent(dsManageFees, cmd, regNo, academicId, editPrm, delPrm);
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

        ds.Tables.Add(dt);
        ds.Tables.Add(dt2);

        return ds.GetXml();
    }

    public static string GetFirstContent(DataSet dsManageFees, SqlCommand cmd, string regno, string academicId, string editPrm, string delPrm)
    {
        StringBuilder divFirstContent = new StringBuilder();
        string strOptions = string.Empty;
        string _Billno = string.Empty;
        string _BillDate = string.Empty;
        string _BillUser = string.Empty;
        string feesCatHeadId = string.Empty;
        string feesHeadAmt = string.Empty;
        string feesCatId = string.Empty;
        string feesMonthName = string.Empty;
        string feestotalAmount = string.Empty;
        if (cmd.Parameters["@FeesCatId"] != null)
            feesCatId = cmd.Parameters["@FeesCatId"].Value.ToString();

        if (cmd.Parameters["@FeesMonthName"] != null)
            feesMonthName = cmd.Parameters["@FeesMonthName"].Value.ToString();

        if (cmd.Parameters["@FeesTotalAmt"] != null)
            feestotalAmount = cmd.Parameters["@FeesTotalAmt"].Value.ToString();

        if (dsManageFees.Tables[3].Rows.Count > 0)
        {
            for (int k = 0; k < dsManageFees.Tables[3].Rows.Count; k++)
            {
                feesCatHeadId += dsManageFees.Tables[3].Rows[k]["feescatheadid"].ToString() + "|";
                feesHeadAmt += "0.00|";
            }
        }
        if (dsManageFees.Tables[0].Rows.Count > 0)
        {
            divFirstContent.Append(" <table class='data display datatable' id='example'><thead><tr><th width='20%' class='sorting_mod center' >Months</th><th width='20% center' class='sorting_mod' >Receipt/Bill No</th><th width='16%' class='sorting_mod center' >Date</th><th width='18%' class='sorting_mod center' >Received By</th><th width='30% center' class='sorting_mod' >Option</th></tr></thead>");
            for (int i = 0; i < dsManageFees.Tables[0].Rows.Count; i++)
            {
                _Billno = "<td class='center'>-</td>";
                _BillDate = "<td class='center'>-</td>";
                _BillUser = "<td class='center'>-</td>";

                if (dsManageFees.Tables[0].Rows[i]["monthnum"].ToString() == cmd.Parameters["@FeesMonth"].Value.ToString() && cmd.Parameters["@FeesType"].Value.ToString().Trim().ToUpper() == "SPORTS")
                    //  strOptions = "<table cellpadding='10' cellspacing='10' > <tr><td><a href='javascript:CreateBill(\"" + regno + "\",\"" + academicId + "\");'> Create </a> </td><td> <a href='javascript:IgnoreBill(\"" + regno + "\",\"" + academicId + "\");'>  Ignore </a> </td></tr></table>";
                    strOptions = "<table cellpadding='10' cellspacing='10' > <tr><td><a href='javascript:CreateBill();' class='creat-link'> <img src='../img/creat.png' alt='' width='22' height='22' align='absmiddle' />  Create </a> </td><td> <a href='javascript:IgnoreBill(\"" + regno + "\",\"" + academicId + "\",\"" + feesCatHeadId + "\",\"" + feesHeadAmt + "\",\"" + feesCatId + "\",\"" + feesMonthName + "\",\"0.00\");'  class='creat-link' > <img src='../img/ignor.jpg' alt='' width='22' height='22' align='absmiddle' />   Ignore </a> </td></tr></table>";
                else
                    strOptions = "<table cellpadding='10' cellspacing='10' > <tr><td> - </td><td> - </td></tr></table>";
                if (dsManageFees.Tables[1].Rows.Count > 0)
                {
                    DataRow[] drPaidFees = dsManageFees.Tables[1].Select("billmonth='" + dsManageFees.Tables[0].Rows[i]["monthname"].ToString().ToUpper().Trim() + "' and feescatcode<>'F' ");

                    if (drPaidFees.Length > 0)
                    {
                        _Billno = "<td class='center'>" + drPaidFees[0]["billno"].ToString() + "</td>";
                        _BillDate = "<td class='center'>" + drPaidFees[0]["billdate"].ToString() + "</td>";
                        _BillUser = "<td class='center'>" + drPaidFees[0]["staffshortname"].ToString() + "</td>";
                        strOptions = "<table cellpadding='10' cellspacing='10' > <tr><td> <a href='javascript:ViewBill(\"" + drPaidFees[0]["billid"].ToString() + "\");'  class='creat-link'>  <img src='../img/creat.png' alt='' width='22' height='22' align='absmiddle' />  View </a> </td>";

                        if (HttpContext.Current.Session["Isactive"] != null && HttpContext.Current.Session["Isactive"].ToString() != "" && HttpContext.Current.Session["Isactive"].ToString().ToLower() != "false")
                        {
                            if (delPrm == "true" && HttpContext.Current.Session["Isactive"].ToString().ToLower() == "true")
                            {
                                strOptions += " <td> <a href='javascript:DeleteBill(\"" + drPaidFees[0]["billid"].ToString() + "\");'  class='creat-link' >  <img src='../img/delete.png' alt='' align='absmiddle' />  Delete </a><td>";
                            }

                            if (editPrm == "true" && HttpContext.Current.Session["Isactive"].ToString().ToLower() == "true")
                            {
                                strOptions += " <td> <a href='javascript:PrintBill(\"" + drPaidFees[0]["billid"].ToString() + "\");'  class='creat-link' >  <img src='../img/print.png' alt='' width='22' height='22' align='absmiddle' />  Print </a> </td>";
                            }
                        }
                        else
                        {
                            if (editPrm == "true")
                            {
                                strOptions += " <td> <a href='javascript:PrintBill(\"" + drPaidFees[0]["billid"].ToString() + "\");'  class='creat-link' >  <img src='../img/print.png' alt='' width='22' height='22' align='absmiddle' />  Print </a> </td>";
                            }
                        }

                        strOptions += " </tr>";
                        if (dsManageFees.Tables[0].Rows[i]["monthnum"].ToString() == cmd.Parameters["@FeesMonth"].Value.ToString() && cmd.Parameters["@FeesType"].Value.ToString().Trim().ToUpper() == "SPORTS")
                            strOptions += "<tr><td><a href='javascript:updateBill(\"" + drPaidFees[0]["billid"].ToString() + "\");' class='creat-link'> <img src='../img/creat.png' alt='' width='22' height='22' align='absmiddle' />  Update Bill </a> </td><td> <a href='javascript:IgnoreExistingBill(\"" + drPaidFees[0]["billid"].ToString() + "\",\"" + academicId + "\",\"" + feesCatHeadId + "\",\"" + feesHeadAmt + "\",\"" + feesCatId + "\",\"" + feesMonthName + "\",\"0.00\");'  class='creat-link' > <img src='../img/ignor.jpg' alt='' width='22' height='22' align='absmiddle' />   Ignore </a> </td></tr>";

                        strOptions += " </table>";

                    }
                }
                DataRow[] monthtoterm=dsManageFees.Tables[dsManageFees.Tables.Count - 1].Select("fullmonth='"+dsManageFees.Tables[0].Rows[i]["monthname"].ToString()+"'");
                divFirstContent.Append("<tr class='odd gradeX'><td class='center'>" + monthtoterm[0][2].ToString() + "</td>");
                divFirstContent.Append(_Billno);
                divFirstContent.Append(_BillDate);
                divFirstContent.Append(_BillUser);
                divFirstContent.Append("<td>" + strOptions.ToString() + "</td>");
                divFirstContent.Append("</tr>");

            }
            divFirstContent.Append("</table>");

            //divAcademicFees.InnerHtml = divFirstContent.ToString();

        }
        return divFirstContent.ToString();
    }



    public static string GetSecondContent(DataSet dsManageSchoolFees, SqlCommand cmd, string regno, string academicId)
    {
        StringBuilder feePOPUPStudentDetails = new StringBuilder();
        StringBuilder feePOPUPHeadDetails = new StringBuilder();
        StringBuilder feePOPUPContent = new StringBuilder();

        if (dsManageSchoolFees.Tables[2].Rows.Count > 0 && dsManageSchoolFees.Tables[0].Rows.Count > 0)
        {

            string feesCatHeadId = "";
            string feesHeadAmt = "";

            string feesHeadActualAmt = "";
            string feesConcessionAmt = string.Empty;

            string feesCatId = string.Empty;
            string feesMonthName = string.Empty;
            string feestotalAmount = string.Empty;
            string paymentMode = string.Empty;

            string sport_academicID = string.Empty;
            string sport_feesCatHeadId = "";
            string sport_feesHeadAmt = "";
            string sport_feesCatId = string.Empty;
            string sport_feesHeadActualAmt = "";
            string sport_feesConcessionAmt = "";
            string sport_feesMonthName = string.Empty;
            string sport_feestotalAmount = string.Empty;

            if (cmd.Parameters["@FeesCatId"] != null)
                feesCatId = cmd.Parameters["@FeesCatId"].Value.ToString();

            if (cmd.Parameters["@FeesMonthName"] != null)
                feesMonthName = cmd.Parameters["@FeesMonthName"].Value.ToString();

            if (cmd.Parameters["@FeesTotalAmt"] != null)
                feestotalAmount = cmd.Parameters["@FeesTotalAmt"].Value.ToString();

            if (cmd.Parameters["@FeesMonth"].Value.ToString() != string.Empty)
            {
                DataRow[] PaidMonthRow = dsManageSchoolFees.Tables[0].Select("monthnum=" + cmd.Parameters["@FeesMonth"].Value.ToString());
                string PaidMonthName = "";
                string cashmode = "";
                string cardmode = "";
                string qrmode = "";
                string remarks = "";
                string paymodeHTML = "";
                if (PaidMonthRow.Length > 0)
                    PaidMonthName = PaidMonthRow[0]["monthname"].ToString();

                if (dsManageSchoolFees.Tables[dsManageSchoolFees.Tables.Count - 2].Rows.Count > 0)
                {
                    paymentMode = "<select id=\"selPaymentMode\"  onchange=\"bindpaymode(this);\" name=\"selPaymentMode\">";
                    for (int q = 0; q < dsManageSchoolFees.Tables[dsManageSchoolFees.Tables.Count - 2].Rows.Count; q++)
                    {

                        paymentMode += "<option value=\"" + dsManageSchoolFees.Tables[dsManageSchoolFees.Tables.Count - 2].Rows[q]["paymentmodeid"].ToString() + "\">" + dsManageSchoolFees.Tables[dsManageSchoolFees.Tables.Count - 2].Rows[q]["paymentmodename"].ToString() + "</option>";

                        if (dsManageSchoolFees.Tables[dsManageSchoolFees.Tables.Count - 2].Rows[q]["paymentmodeid"].ToString() == "4" || dsManageSchoolFees.Tables[dsManageSchoolFees.Tables.Count - 2].Rows[q]["paymentmodeid"].ToString() == "8" || dsManageSchoolFees.Tables[dsManageSchoolFees.Tables.Count - 2].Rows[q]["paymentmodeid"].ToString() == "9")
                        {
                            cashmode = "<input type=\"textbox\" id=\"txtcashamt\" onkeyup=\"checkval(this);\" class='numericswithdecimals' style=\"width: 50px;\" name=\"txtcashamt\" value=\"0\"/>";
                            cardmode = "<input type=\"textbox\" id=\"txtcardamt\" onkeyup=\"checkval(this);\"  class='numericswithdecimals' style=\"width: 50px;\"  name=\"txtcardamt\" value=\"0\"/>";
                            qrmode = "<input type=\"textbox\" id=\"txtqramt\" onkeyup=\"checkval(this);\"  class='numericswithdecimals' style=\"width: 50px;\"  name=\"txtqramt\" value=\"0\"/>";
                            remarks = "<input type=\"textbox\" id=\"txtremarks\" style=\"width: 600px;\" class=\"jsrequired\" name=\"txtremarks\"/>";

                            paymodeHTML = @"<tr><td>Payment Mode</td>
	                                          <td >:</td>
	                                          <td >" + paymentMode + "</td><td id=\"modes\" style='display:none;float: left;position: absolute;' colspan='3'>Cash: " + cashmode + "&nbsp;Card:" + cardmode + "&nbsp;QR:" + qrmode + "</td></tr>";
                            paymodeHTML += @"<tr><td id='remarks' colspan='6'><br/>Remarks:&nbsp;" + remarks + "</td></tr>";

                        }
                        if (dsManageSchoolFees.Tables[dsManageSchoolFees.Tables.Count - 2].Rows[q]["paymentmodeid"].ToString() == "10" || dsManageSchoolFees.Tables[dsManageSchoolFees.Tables.Count - 2].Rows[q]["paymentmodeid"].ToString() == "11" || dsManageSchoolFees.Tables[dsManageSchoolFees.Tables.Count - 2].Rows[q]["paymentmodeid"].ToString() == "12" || dsManageSchoolFees.Tables[dsManageSchoolFees.Tables.Count - 2].Rows[q]["paymentmodeid"].ToString() == "13" || dsManageSchoolFees.Tables[dsManageSchoolFees.Tables.Count - 2].Rows[q]["paymentmodeid"].ToString() == "14" || dsManageSchoolFees.Tables[dsManageSchoolFees.Tables.Count - 2].Rows[q]["paymentmodeid"].ToString() == "15")
                        {
                            cashmode = "<input type=\"textbox\" id=\"txtcashamt\" onkeyup=\"checkval(this);\" class='numericswithdecimals' style=\"width: 50px;\" name=\"txtcashamt\" value=\"0\"/>";
                            cardmode = "<input type=\"textbox\" id=\"txtcardamt\" onkeyup=\"checkval(this);\"  class='numericswithdecimals' style=\"width: 50px;\"  name=\"txtcardamt\" value=\"0\"/>";
                            qrmode = "<input type=\"textbox\" id=\"txtqramt\" onkeyup=\"checkval(this);\"  class='numericswithdecimals' style=\"width: 50px;\"  name=\"txtqramt\" value=\"0\"/>";
                            remarks = "<input type=\"textbox\" id=\"txtremarks\" style=\"width: 600px;\" class=\"jsrequired\" name=\"txtremarks\"/>";

                            paymodeHTML = @"<tr><td>Payment Mode</td>
	                                          <td >:</td>
	                                          <td >" + paymentMode + "</td><td id=\"modes\" style='display:none;float: left;position: absolute;' colspan='3'>Cash: " + cashmode + "&nbsp;Card:" + cardmode + "&nbsp;QR:" + qrmode + "</td></tr>";
                            paymodeHTML += @"<tr><td id='remarks' colspan='6'><br/>Remarks:&nbsp;" + remarks + "</td></tr>";
                        }
                        else
                        {
                            cashmode = "<input type=\"textbox\" onkeyup=\"checkval(this);\" class='numericswithdecimals' style=\"width: 50px;\" id=\"txtcashamt\" name=\"txtcashamt\" value=\"0\"/>";
                            cardmode = "<input type=\"textbox\"  onkeyup=\"checkval(this);\" class='numericswithdecimals' style=\"width: 50px;\"  id=\"txtcardamt\" name=\"txtcardamt\" value=\"0\"/>";
                            qrmode = "<input type=\"textbox\" id=\"txtqramt\" onkeyup=\"checkval(this);\"  class='numericswithdecimals' style=\"width: 50px;\"  name=\"txtqramt\" value=\"0\"/>";
                            remarks = "<input type=\"textbox\" id=\"txtremarks\" style=\"width: 600px;\" class=\"jsrequired\" name=\"txtremarks\"/>";

                            paymodeHTML = @"<tr><td>Payment Mode</td>
	                                          <td >:</td>
	                                          <td >" + paymentMode + "</td><td id=\"modes\" style='display:none;float: left;position: absolute;' colspan='3'>Cash: " + cashmode + "&nbsp;Card:" + cardmode + "&nbsp;QR:" + qrmode + "</td></tr>";
                            paymodeHTML += @"<tr><td id='remarks' colspan='6'><br/>Remarks:&nbsp;" + remarks + "</td></tr>";
                        }
                    }
                    paymentMode += "</select>";
                }

                feePOPUPStudentDetails.Append(@"<table width='700px' border='0' cellpadding='3'  cellspacing='0' class='popup-form' >
                                           <tr>
	                                          <td width='100' >Reg No</td>
	                                          <td width='10' >:</td>
	                                          <td width='250' ><label for='textfield2'>" + dsManageSchoolFees.Tables[2].Rows[0]["regno"].ToString() + "</label> </td>");
                feePOPUPStudentDetails.Append(@"<td width='100'>Date Of Paid</td>
	                                          <td width='10'>:</td>
	                                          <td width='250'><input type='text' name='txtBillDate' id='txtBillDate' class='ptxtbx ' /></td>
	                                          </tr>");
                feePOPUPStudentDetails.Append(@"<tr><td  height='30' >Name</td>
	                                          <td  >:</td>
	                                          <td  ><label for='textfield2'>" + dsManageSchoolFees.Tables[2].Rows[0]["stname"].ToString().ToUpper() + "</label></td>");
                if (cmd.Parameters["@isTerm"] != null && cmd.Parameters["@isTerm"].Value.ToString() == "1")
                {
                    DataRow[] monthtoterm = dsManageSchoolFees.Tables[dsManageSchoolFees.Tables.Count - 1].Select("fullmonth='" + PaidMonthName + "'");
                    feePOPUPStudentDetails.Append(@"<td  >Term </td>
	                                      <td  >:</td>
	                                      <td  ><label for='textfield2'>" + monthtoterm[0][4] + "</label></td></tr>");
                }
                else

                    feePOPUPStudentDetails.Append(@"<td  >Month </td>
	                                      <td  >:</td>
	                                      <td  ><label for='textfield2'>" + PaidMonthName + "</label></td></tr>");


                feePOPUPStudentDetails.Append(@"<tr>
	                              <td height='30' >Class</td>
	                              <td >:</td>
	                              <td ><label for='textfield2'>" + dsManageSchoolFees.Tables[2].Rows[0]["classname"].ToString().ToUpper() + "</label></td>");
                feePOPUPStudentDetails.Append(@"<td height='30' >Section</td>
	                                      <td >:</td>
	                                      <td ><label for='textfield2'>" + dsManageSchoolFees.Tables[2].Rows[0]["sectionname"].ToString().ToUpper() + "</label></td></tr>");
                if (paymentMode != string.Empty)
                {
                    feePOPUPStudentDetails.Append(paymodeHTML);

                }
                feePOPUPStudentDetails.Append(@"</tr></table>");




                decimal schooltotal = 0;
                decimal sportstotal = 0;

                decimal schoolConcessionTotal = 0;

                if (dsManageSchoolFees.Tables[3].Rows.Count > 0 && dsManageSchoolFees.Tables[0].Rows.Count > 0)
                {

                    feePOPUPHeadDetails.Append(@" <table width='100%' border='0' cellspacing='0' cellpadding='5' class='popup-form'>
	                                          <tr class='tlb-trbg'><td width='79%' height='30' align='left' style='padding-left:10px;'>Heads</td><td width='21%' align='center'>Amount</td></tr>");
                    feePOPUPHeadDetails.Append(@"<tr><td colspan='2'><div class='' style='overflow:auto; height:120px; margin:10px 0px;width:100%;'>
                                                <table width='100%' border='0' cellspacing='0' cellpadding='0'>");

                    decimal sumofactualAmt = 0;

                    for (int k = 0; k < dsManageSchoolFees.Tables[3].Rows.Count; k++)
                    {
                        decimal actualAmt = Convert.ToDecimal(dsManageSchoolFees.Tables[3].Rows[k]["actualamount"]);
                        decimal amount = Convert.ToDecimal(dsManageSchoolFees.Tables[3].Rows[k]["amount"]);
                        decimal concession = actualAmt - amount;

                        feesCatHeadId += dsManageSchoolFees.Tables[3].Rows[k]["feescatheadid"].ToString() + "|";
                        feesHeadAmt += dsManageSchoolFees.Tables[3].Rows[k]["amount"].ToString() + "|";

                        feesHeadActualAmt += dsManageSchoolFees.Tables[3].Rows[k]["actualamount"].ToString() + "|";
                        feesConcessionAmt += concession + "|"; 


                        feePOPUPHeadDetails.Append(@"<tr><td height='30' class='tdbrd'> " + dsManageSchoolFees.Tables[3].Rows[k]["feesheadname"].ToString().ToUpper() + "</td>");
                        // feePOPUPHeadDetails.Append(@"<td class='tdbrd amt-rgt'>" + Math.Round(Convert.ToDecimal(dsManageSchoolFees.Tables[3].Rows[k]["amount"].ToString().ToUpper())) + "</td></tr>");
                        // feePOPUPHeadDetails.Append(@"<td class='tdbrd amt-rgt'>" + Math.Round(Convert.ToDecimal(dsManageSchoolFees.Tables[3].Rows[k]["actualamount"].ToString().ToUpper())) + "</td></tr>");
                        feePOPUPHeadDetails.Append(@"<td class='tdbrd amt-rgt'>" + Math.Round(Convert.ToDecimal(dsManageSchoolFees.Tables[3].Rows[k]["actualamount"].ToString().ToUpper())) + "</td></tr>");

                        sumofactualAmt += Math.Round(actualAmt);
                        schoolConcessionTotal += concession;
                    }
                    feePOPUPHeadDetails.Append(@"</table></div></td></tr>");
                    feePOPUPHeadDetails.Append(@"<tr class='tlt-rs'><td height='30' class='tdbrd'>Total </td>
                                                    <td class='tdbrd amt-rgt'>Rs. " + Math.Round(Convert.ToDecimal(cmd.Parameters["@FeesTotalAmt"].Value.ToString())) + "</td></tr></table>");

                   
                    schooltotal = Math.Round(Convert.ToDecimal(cmd.Parameters["@FeesTotalAmt"].Value.ToString()));

                }

                Utilities utl = new Utilities();
                DataSet dataSports = new DataSet();
                sport_academicID = utl.ExecuteASSScalar("select top 1 academicID from m_academicyear where isactive=1 order by academicID desc ");

                //
                string sport_Student = utl.ExecuteASSScalar("select count(*)  from s_studentinfo where RegNo = " + dsManageSchoolFees.Tables[2].Rows[0]["RegNo"].ToString() + " and academicyear=" + sport_academicID);

                SqlConnection sport_conn = new SqlConnection(ConfigurationManager.AppSettings["ASSConnection"].ToString());
                string sqlstr = "select isactive from m_academicyear where AcademicID='" + sport_academicID + "'";
                string sport_Isactive = utl.ExecuteASSScalar(sqlstr);
                HttpContext.Current.Session["sport_Isactive"] = sport_Isactive.ToString();
                SqlCommand sport_cmd = new SqlCommand();
                //
                if (sport_Student != "0" && sport_Student != null && sport_Student != "")
                {
                    if (sport_Isactive == "True")
                    {
                        sport_cmd = new SqlCommand("sp_ManageFee");
                    }
                    else
                    {
                        sport_cmd = new SqlCommand("[sp_ManageOldFee]");
                    }

                    sport_cmd.CommandType = CommandType.StoredProcedure;
                    sport_cmd.Parameters.AddWithValue("@regno", dsManageSchoolFees.Tables[2].Rows[0]["RegNo"].ToString());
                    sport_cmd.Parameters.AddWithValue("@AcademicId", sport_academicID);
                    sport_cmd.Parameters.Add("@FeesCatId", SqlDbType.Int).Direction = ParameterDirection.Output;
                    sport_cmd.Parameters.Add("@FeesMonthName", SqlDbType.VarChar, 20).Direction = ParameterDirection.Output;
                    sport_cmd.Parameters.Add("@FeesTotalAmt", SqlDbType.Decimal, 18).Direction = ParameterDirection.Output;
                    sport_cmd.Parameters["@FeesTotalAmt"].Precision = 18;
                    sport_cmd.Parameters["@FeesTotalAmt"].Scale = 2;
                    sport_cmd.Parameters.Add("@FeesMonth", SqlDbType.VarChar, 20).Direction = ParameterDirection.Output;
                    sport_cmd.Parameters.Add("@FeesType", SqlDbType.VarChar, 20).Direction = ParameterDirection.Output;
                    sport_cmd.Parameters.Add("@isTerm", SqlDbType.Int).Direction = ParameterDirection.Output;
                    sport_conn.Open();
                    sport_cmd.Connection = sport_conn;
                    SqlDataAdapter daDataSports = new SqlDataAdapter();
                    daDataSports.SelectCommand = sport_cmd;

                    daDataSports.Fill(dataSports);
                    sport_conn.Close();

                    if (dataSports != null && dataSports.Tables[0].Rows.Count > 0)
                    {

                        if (sport_cmd.Parameters["@FeesCatId"] != null)
                            sport_feesCatId = sport_cmd.Parameters["@FeesCatId"].Value.ToString();

                        if (sport_cmd.Parameters["@FeesMonthName"] != null)
                            sport_feesMonthName = sport_cmd.Parameters["@FeesMonthName"].Value.ToString();

                        if (sport_cmd.Parameters["@FeesTotalAmt"] != null)
                            sport_feestotalAmount = sport_cmd.Parameters["@FeesTotalAmt"].Value.ToString();

                        if (dataSports.Tables[3].Rows.Count > 0 && sport_feesMonthName == feesMonthName)
                        {
                            feePOPUPHeadDetails.Append(@" <table width='100%' border='0' cellspacing='0' cellpadding='5' class='popup-form'>
	                                          <tr class='tlb-trbg'><td width='79%' height='30' align='left' style='padding-left:10px;'>Heads</td><td width='21%' align='center'>Amount</td></tr>");
                            feePOPUPHeadDetails.Append(@"<tr><td colspan='2'><div class='' style='overflow:auto; height:120px; margin:10px 0px;width:100%;'>
                                                <table width='100%' border='0' cellspacing='0' cellpadding='0'>");

                            for (int k = 0; k < dataSports.Tables[3].Rows.Count; k++)
                            {
                                decimal sportactualAmt = Convert.ToDecimal(dsManageSchoolFees.Tables[3].Rows[k]["actualamount"]);
                                decimal sportamount = Convert.ToDecimal(dsManageSchoolFees.Tables[3].Rows[k]["amount"]);
                                decimal sportconcession = sportactualAmt - sportamount;

                                sport_feesCatHeadId += dataSports.Tables[3].Rows[k]["feescatheadid"].ToString() + "|";
                                sport_feesHeadAmt += dataSports.Tables[3].Rows[k]["amount"].ToString() + "|";
                                sport_feesHeadActualAmt += dsManageSchoolFees.Tables[3].Rows[k]["actualamount"].ToString() + "|";
                                sport_feesConcessionAmt += sportconcession + "|"; 

                                feePOPUPHeadDetails.Append(@"<tr><td height='30' class='tdbrd'> " + dataSports.Tables[3].Rows[k]["feesheadname"].ToString().ToUpper() + "</td>");
                                feePOPUPHeadDetails.Append(@"<td class='tdbrd amt-rgt'>" + Math.Round(Convert.ToDecimal(dataSports.Tables[3].Rows[k]["amount"].ToString().ToUpper())) + "</td></tr>");
                                sport_feestotalAmount += Math.Round(Convert.ToDecimal(dataSports.Tables[3].Rows[k]["amount"].ToString().ToUpper()));
                            }
                            feePOPUPHeadDetails.Append(@"</table></div></td></tr>");
                            if (sport_feestotalAmount != "")
                            {
                                feePOPUPHeadDetails.Append(@"<tr class='tlt-rs'><td height='30' class='tdbrd'>Total </td>
                                                    <td class='tdbrd amt-rgt'>Rs. " + Math.Round(Convert.ToDecimal(sport_feestotalAmount.ToString())) + "</td></tr>");

                                sportstotal = Math.Round(Convert.ToDecimal(sport_feestotalAmount));
                            }

                            //   feePOPUPHeadDetails.Append(@"<br/><br/><tr class='tlt-rs'><td height='30' class='tdbrd'>Grand Total </td>
                            //                          <td class='tdbrd amt-rgt'>Rs. " + Math.Round(Convert.ToDecimal(schooltotal) + Convert.ToDecimal(sportstotal)) + "</td></tr></table>");

                        }
                    }

                }
                feePOPUPHeadDetails.Append(@" <table width='100%' border='0' cellspacing='0' cellpadding='5' class='popup-form'>");

                if (schoolConcessionTotal > 0)
                {

                    feePOPUPHeadDetails.Append(@" <tr class='tlt-rs'><td height='30' class='tdbrd'>Concession Granted</td>
                                                     <td class='tdbrd amt-rgt'>Rs. " + Math.Round(schoolConcessionTotal) + "</td></tr>");
                }

                feePOPUPHeadDetails.Append(@"<br/><br/><tr class='tlt-rs'><td height='30' class='tdbrd'>Grand Total </td>
                                                    <td class='tdbrd amt-rgt'>Rs. " + Math.Round(Convert.ToDecimal(schooltotal) + Convert.ToDecimal(sportstotal)) + "</td></tr></table>");



                DataTable dtadv = new DataTable();

                string old_academicID = utl.ExecuteScalar("select top 1 academicID from m_academicyear where isactive=0 order by academicID desc ");

                dtadv = utl.GetDataTable(@"select top 1 a.*,convert(varchar(10),a.billdate,103) as datebill,case when Billrefno is null then BillNo else Billrefno end as ReceiptNo from f_studentbillmaster a 
	  inner join s_studentpromotion b on a.RegNo=b.RegNo  and a.isactive=1
	  inner join s_studentinfo info on info.RegNo=b.RegNo
	  inner join f_studentbills d on d.BillId=a.BillId and d.isactive=1
	  inner join m_feescategoryhead e on e.FeesCatHeadID=d.FeesCatHeadId and e.AcademicId=b.AcademicId
	  inner join m_feeshead f on f.FeesHeadId=e.FeesHeadId and f.FeesHeadCode='A'
      WHERE  info.regno = '" + dsManageSchoolFees.Tables[2].Rows[0]["RegNo"].ToString() + "' AND info.academicyear = " + HttpContext.Current.Session["AcademicID"] + " and b.AcademicId= '" + old_academicID + "' order by a.billID desc");
                if (dtadv != null && dtadv.Rows.Count > 0 && feesMonthName=="Jun")
                {
                    feePOPUPHeadDetails.Append("<tr><td colspan='2'>Remarks:</td></tr>");
                    feePOPUPHeadDetails.Append("<tr><td colspan='2'>Advance Received: " + dtadv.Rows[0]["TotalAmount"].ToString() + "</td></tr>");
                    feePOPUPHeadDetails.Append("<tr><td colspan='2'>Bill No: " + dtadv.Rows[0]["ReceiptNo"].ToString() + "</td></tr>");
                    feePOPUPHeadDetails.Append("<tr><td colspan='2'>Bill Date: " + dtadv.Rows[0]["datebill"].ToString() + "</td></tr>");
                    feePOPUPHeadDetails.Append("<tr><td></td></tr>");
                }

                feePOPUPContent.Append(@"<table width='650px' border='0' cellpadding='3'  cellspacing='0' class='popup-form tlt-mainbrd' style='border: 1px solid #bfbfbf; background-color:#fff;'>");
                feePOPUPContent.Append("<tr><td style='padding: 10px 10px 0px;float:right;'><a href='javascript:closeCreateBill()'>close</a></td></tr>");
                feePOPUPContent.Append("<tr><td  class='popup-form' style='padding:6px;'>" + feePOPUPStudentDetails.ToString() + "</td></tr>");

                feePOPUPContent.Append(@"<tr><td  class='popup-form' style='padding:6px;'>" + feePOPUPHeadDetails.ToString() + "</td></tr>");

                // if (dataSports != null && dataSports.Tables[0].Rows.Count > 0)
                if (dataSports != null && dataSports.Tables.Count > 0 && dataSports.Tables[0].Rows.Count > 0)
                {
                    if (sport_feestotalAmount=="")
                    {
                        sport_feestotalAmount = "0";
                    }
                    // feePOPUPContent.Append("<tr><td style='text-align:center;' ><input id=\"btnSubmit\" type=\"button\" class=\"btn btn-navy\"  value=\"Save & Print\" onclick=\"SaveFeesBill(\'" + regno + "\',\'" + academicId + "-" + sport_academicID + "\',\'" + feesCatHeadId + "-" + sport_feesCatHeadId + "\',\'" + feesHeadAmt + "-" + sport_feesHeadAmt + "\',\'" + feesCatId + "-" + sport_feesCatId + "\',\'" + feesMonthName + "-" + sport_feesMonthName + "\',\'" + Math.Round(Convert.ToDecimal(feestotalAmount)) + "-" + Math.Round(Convert.ToDecimal(sport_feestotalAmount)) + "\');\" /></td> </tr>");
                    feePOPUPContent.Append("<tr><td style='text-align:center;' ><input id=\"btnSubmit\" type=\"button\" class=\"btn btn-navy testsport\"  value=\"Save & Print\" onclick=\"SaveFeesBill(\'"
                             + regno + "\',\'"
                             + academicId + "-" + sport_academicID + "\',\'"
                             + feesCatHeadId + "-" + sport_feesCatHeadId + "\',\'"
                             + feesHeadAmt + "-" + sport_feesHeadAmt + "\',\'"
                             + feesCatId + "-" + sport_feesCatId + "\',\'"
                             + feesMonthName + "-" + sport_feesMonthName + "\',\'"
                             + Math.Round(Convert.ToDecimal(feestotalAmount)) + "-" + Math.Round(Convert.ToDecimal(sport_feestotalAmount)) + "\',\'"
                             + feesHeadActualAmt + "-" + sport_feesHeadActualAmt + "\',\'"
                             + feesConcessionAmt + "-" + sport_feesConcessionAmt + "\');\" /></td> </tr>");

                }
                else
                {
                    feePOPUPContent.Append("<tr><td style='text-align:center;' ><input id=\"btnSubmit\" type=\"button\" class=\"btn btn-navy test\"  value=\"Save & Print\" onclick=\"SaveFeesBill(\'"
                       + regno + "\',\'"
                       + academicId + "\',\'"
                       + feesCatHeadId + "\',\'"
                       + feesHeadAmt + "\',\'"
                       + feesCatId + "\',\'"
                       + feesMonthName + "\',\'"
                       + Math.Round(Convert.ToDecimal(feestotalAmount)) + "\',\'"
                       + feesHeadActualAmt + "\',\'"
                       + feesConcessionAmt + "\');\" /></td> </tr>");

                    //feePOPUPContent.Append("<tr><td style='text-align:center;' ><input id=\"btnSubmit\" type=\"button\" class=\"btn btn-navy\"  value=\"Save & Print\" onclick=\"SaveFeesBill(\'" + regno + "\',\'" + academicId + "\',\'" + feesCatHeadId + "\',\'" + feesHeadAmt + "\',\'" + feesCatId + "\',\'" + feesMonthName + "\',\'" + Math.Round(Convert.ToDecimal(feestotalAmount)) + "\');\" /></td> </tr>");
                }


                feePOPUPContent.Append(@"<tr><td colspan='6' ></td></tr> </table>");
                feePOPUPContent.Append(@"<input type=""hidden"" id=""hdnMonthNum"" value=" + cmd.Parameters["@FeesMonth"].Value.ToString() + ">");
                feePOPUPContent.Append(@"<input type=""hidden"" id=""hdnFeeType"" value=" + cmd.Parameters["@FeesType"].Value.ToString() + ">");

                //divBillContents.InnerHtml = feePOPUPContent.ToString();
            }
        }
        return feePOPUPContent.ToString();
    }

    public static string GetThirdContent(DataSet dsManageSchoolFees, SqlCommand cmd, string regno, string academicId, string editPrm, string delPrm)
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

            DataRow[] drPaidFees = dsManageSchoolFees.Tables[1].Select(" feescatcode='S' ");
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

                if (HttpContext.Current.Session["Isactive"] != null && HttpContext.Current.Session["Isactive"].ToString() != "" && HttpContext.Current.Session["Isactive"].ToString().ToLower() != "false")
                {
                    if (delPrm == "true" && HttpContext.Current.Session["Isactive"].ToString().ToLower() == "true")
                    {
                        strOptions += " <td> <a href='javascript:DeleteBill(\"" + drPaidFees[0]["billid"].ToString() + "\");'  class='creat-link' >  <img src='../img/delete.png' alt='' align='absmiddle' />  Delete </a><td>";
                    }
                    if (editPrm == "true" && HttpContext.Current.Session["Isactive"].ToString().ToLower() == "true")
                    {
                        strOptions += " <td> <a href='javascript:PrintBill(\"" + drPaidFees[0]["billid"].ToString() + "\");'  class='creat-link' >  <img src='../img/print.png' alt='' width='22' height='22' align='absmiddle' />  Print </a> </td>";
                    }
                }
                else
                {
                    if (editPrm == "true")
                    {
                        strOptions += " <td> <a href='javascript:PrintBill(\"" + drPaidFees[0]["billid"].ToString() + "\");'  class='creat-link' >  <img src='../img/print.png' alt='' width='22' height='22' align='absmiddle' />  Print </a> </td>";
                    }
                }
                strOptions += " </tr></table>";

                divThirdContent.Append("<tr class='odd gradeX'><td class='center'> Advance Fee</td>");
                divThirdContent.Append(_Billno);
                divThirdContent.Append(_BillDate);
                divThirdContent.Append(_BillUser);
                divThirdContent.Append("<td>" + strOptions.ToString() + "</td>");
                divThirdContent.Append("</tr>");
                divThirdContent.Append("</table>");

            }

        }
        else
        {
            DataRow[] drPaidFees = dsManageSchoolFees.Tables[1].Select(" feescatcode='S' ");
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

                if (HttpContext.Current.Session["Isactive"] != null && HttpContext.Current.Session["Isactive"].ToString() != "" && HttpContext.Current.Session["Isactive"].ToString().ToLower() != "false")
                {
                    if (delPrm == "true" && HttpContext.Current.Session["Isactive"].ToString().ToLower() == "true")
                    {
                        strOptions += " <td> <a href='javascript:DeleteBill(\"" + drPaidFees[0]["billid"].ToString() + "\");'  class='creat-link' >  <img src='../img/delete.png' alt='' align='absmiddle' />  Delete </a><td>";
                    }
                    if (editPrm == "true" && HttpContext.Current.Session["Isactive"].ToString().ToLower() == "true")
                    {
                        strOptions += " <td> <a href='javascript:PrintBill(\"" + drPaidFees[0]["billid"].ToString() + "\");'  class='creat-link' >  <img src='../img/print.png' alt='' width='22' height='22' align='absmiddle' />  Print </a> </td>";
                    }
                }
                else
                {
                    if (editPrm == "true")
                    {
                        strOptions += " <td> <a href='javascript:PrintBill(\"" + drPaidFees[0]["billid"].ToString() + "\");'  class='creat-link' >  <img src='../img/print.png' alt='' width='22' height='22' align='absmiddle' />  Print </a> </td>";
                    }
                }
                strOptions += " </tr></table>";

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

    [WebMethod]
    public static string UpdateBillDetails(string BillId, string AcademicId, string FeesHeadIds, string FeesAmount, string FeesCatId, string FeesMonthName, string FeestotalAmount, string BillDate, string userId, string PaymentMode, string CashAmt, string CardAmt, string QRAmount, string MonthNum, string FeeType)
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
            subQuery += "INSERT INTO [dbo].[f_studentbills]([BillId],[FeesCatHeadId],[BillMonth],[Amount],[IsActive],[UserId])VALUES(" + BillId + "," + head + ",''" + FeesMonthName + "''," + feeAmount[i] + ",''True''," + userId + ")";
            i++;
        }

        if (BillDate == string.Empty)
        {
            BillDate = DateTime.Now.ToString("dd/MM/yyyy");
        }

        if (PaymentMode == "1")
        {
            CashAmt = FeestotalAmount;
            CardAmt = "0";
            QRAmount = "0";
        }
        else if (PaymentMode == "3")
        {
            CardAmt = FeestotalAmount;
            CashAmt = "0";
            QRAmount = "0";
        }
        else if (PaymentMode == "5")
        {
            QRAmount = FeestotalAmount;
            CashAmt = "0";
            CardAmt = "0";
        }


        string[] formats = { "dd/MM/yyyy" };
        string formatBillDate = DateTime.ParseExact(BillDate, formats, new CultureInfo("en-US"), DateTimeStyles.None).ToShortDateString();

        string query = "[SP_UpdateFeesBill] '0000'," + AcademicId + "," + FeesCatId + "," + BillId + ",'" + FeesMonthName + "'," + FeestotalAmount + ",'" + formatBillDate + "'," + userId + ",'" + subQuery + "'," + PaymentMode + ",'" + CashAmt + "','" + CardAmt + "','" + QRAmount + "'";

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
    public static string SaveBillDetails(string regNo, string AcademicId, string FeesHeadIds, string FeesAmount, string FeesCatId, string FeesMonthName, string FeestotalAmount, string FeesHeadActualAmt, string FeesHeadConcessionAmt, string BillDate, string userId, string PaymentMode, string CashAmt, string CardAmt, string QRAmount, string Remarks, string MonthNum, string FeeType)
    {
        Utilities utl = new Utilities();
        //FeesHeadIds = FeesHeadIds.Substring(0, FeesHeadIds.Length - 1);
        //FeesAmount = FeesAmount.Substring(0, FeesAmount.Length - 1);
        //FeesCatId = FeesCatId.Substring(0, FeesCatId.Length - 1);
        //CardAmt = CardAmt.Substring(0, CardAmt.Length - 1);
        //CashAmt = CashAmt.Substring(0, CashAmt.Length - 1);
        FeesHeadActualAmt = FeesHeadActualAmt.Substring(0, FeesHeadActualAmt.Length - 1);
        FeesHeadConcessionAmt = FeesHeadConcessionAmt.Substring(0, FeesHeadConcessionAmt.Length - 1);



        string[] fh = FeesHeadIds.Split('-');
        string[] feeHead = fh[0].Split('|');

        string[] faActual = FeesHeadActualAmt.Split('-');
        string[] feeActualAmt = faActual[0].Split('|');


        string[] faConcession = FeesAmount.Split('-');
        string[] feeConcessionAmt = faConcession[0].Split('|');

        string[] feeActualAmount = FeesHeadActualAmt.Split('|');
        string[] feeConcessionAmount = FeesHeadConcessionAmt.Split('|');

        string[] sport_feeHead = new string[2];
        if (fh.Length > 1)
        {
            sport_feeHead = fh[1].Split('|');
        }


        string[] ac = AcademicId.Split('-');
        string academic = ac[0].ToString();
        string sport_academic = string.Empty;
        if (ac.Length > 1)
        {
            sport_academic = ac[1].ToString();
        }

        string[] fa = FeesAmount.Split('-');
        string[] feeAmount = fa[0].Split('|');
        string[] sport_feeAmount = new string[2];
        if (fa.Length > 1)
        {
            sport_feeAmount = fa[1].Split('|');
        }

        string[] fc = FeesCatId.Split('-');
        string feecatid = fc[0].ToString();
        string sport_feecatid = string.Empty;
        if (fc.Length > 1)
        {
            sport_feecatid = fc[1].ToString();
        }

        string[] fm = FeesMonthName.Split('-');
        string feemonth = fm[0].ToString();
        string sport_feemonth = string.Empty;
        if (fm.Length > 1)
        {
            sport_feemonth = fm[1].ToString();
        }

        string[] fta = FeestotalAmount.Split('-');
        string feetotalamt = fta[0].ToString();
        string sport_feetotalamt = string.Empty;
        if (fta.Length > 1)
        {
            sport_feetotalamt = fta[1].ToString();
        }

        string[] cs = CashAmt.Split('-');
        string cashamt = cs[0].ToString();
        string sport_cashamt = string.Empty;
        if (cs.Length > 1)
        {
            sport_cashamt = cs[1].ToString();
        }

        string[] crd = CardAmt.Split('-');
        string cardamt = crd[0].ToString();
        string sport_cardamt = string.Empty;
        if (crd.Length > 1)
        {
            sport_cardamt = crd[1].ToString();
        }

        string[] qr = QRAmount.Split('-');
        string qramt = qr[0].ToString();
        string sport_qramt = string.Empty;
        if (qr.Length > 1)
        {
            sport_qramt = qr[1].ToString();
        }


        if (BillDate == string.Empty)
        {
            BillDate = DateTime.Now.ToString("dd/MM/yyyy");
        }

        string[] formats = { "dd/MM/yyyy" };

        string formatBillDate = DateTime.ParseExact(BillDate, formats, new CultureInfo("en-US"), DateTimeStyles.None).ToShortDateString();
        DateTime dtdate = Convert.ToDateTime(formatBillDate);
       string  strdtdate = dtdate.ToString("yyyy-MM-dd");
       if (PaymentMode == "1")
       {
           cashamt = feetotalamt;
           cardamt = "0";

           sport_cashamt = sport_feetotalamt;
           sport_cardamt = "0";
           sport_qramt = "0";
       }
       else if (PaymentMode == "3")
       {
           cashamt = "0";
           cardamt = feetotalamt;

           sport_cashamt = "0";
           sport_cardamt = sport_feetotalamt;
           sport_qramt = "0";
       }

       else if (PaymentMode == "5")
       {
           cashamt = "0";
           cardamt = "0";
           qramt = feetotalamt;
           sport_cashamt = "0";
           sport_cardamt = "0";
           sport_qramt = sport_feetotalamt;
       }


        FeesCatId = utl.ExecuteScalar("select feescategoryid from m_feescategory where feescatcode=(select active from s_studentinfo where regno='" + regNo + "')");

        string subAssQuery = string.Empty;
        int i = 0;

        //ASS BILL Opening
        if (sport_feeHead.Length > 0)
        {
            foreach (string s_head in sport_feeHead)
            {
                if (s_head != "" && s_head != null && sport_feeAmount[i].ToString() != "" && sport_feeAmount[i].ToString() != null)
                {
                    subAssQuery += "INSERT INTO [dbo].[f_studentbills]([BillId],[FeesCatHeadId],[BillMonth],[Amount],[IsActive],[UserId])VALUES(''DummyBill''," + s_head + ",''" + sport_feemonth + "''," + sport_feeAmount[i] + ",''True''," + userId + ")";

                    i++;
                }

            }
            string ass_query = "";
            DataSet dsSportSaveBill = null;

            if (sport_feecatid != "" && sport_feemonth != "" && subAssQuery != "")
            {
                ass_query = "[SP_InsertFeesBill] '0000'," + sport_academic + "," + sport_feecatid + "," + regNo + ",'" + sport_feemonth + "'," + sport_feetotalamt + ",'" + strdtdate + "'," + userId + ",'" + subAssQuery + "'," + PaymentMode + ",'" + sport_cardamt + "','" + sport_cardamt + "','" + sport_qramt + "'";

                dsSportSaveBill = utl.GetAssDataset(ass_query);
            }

            //if (dsSportSaveBill != null && dsSportSaveBill.Tables.Count > 0 && dsSportSaveBill.Tables[0].Rows.Count > 0)
            //{

            //    ass_query = "select distinct convert(varchar,year(startdate))+'-'+  convert(varchar,Datepart(yy,enddate)) as AcademicYear   from m_academicyear  where academicID='" + sport_academic + "'";
            //    string sport_AcademicYear = utl.ExecuteASSScalar(ass_query);

            //    ass_query = "select isnull(count(*),0)+1 from f_studenttaxbillmaster a inner join f_studentbillmaster b on a.BillID=b.BillID where b.academicID='" + sport_academic + "' ";
            //    string sport_TaxBillcnt = utl.ExecuteASSScalar(ass_query);

            //    string sport_schoolabbrivation = utl.ExecuteScalar("select ltrim(rtrim(Schoolabbreviation)) from m_schooldetails");
            //    string sport_TaxBillNo = "GST/" + sport_schoolabbrivation.ToString().TrimEnd() + "/" + "" + sport_AcademicYear + "/000" + sport_TaxBillcnt.ToString();

            //    ass_query = "insert into f_studenttaxbillmaster(TaxBillNo,BillID,isactive,userID)values( '" + sport_TaxBillNo.ToString().Trim() + "'," + dsSportSaveBill.Tables[0].Rows[0][0].ToString() + ",'true'," + userId + ")";
            //    utl.ExecuteASSQuery(ass_query);

            //    string sport_taxBillID = utl.ExecuteASSScalar("SELECT isnull(max(TaxBillID),0) from f_studenttaxbillmaster where isactive=1");
            //    string sport_taxQuery = string.Empty;
            //    i = 0;
            //    foreach (string s_head in sport_feeHead)
            //    {
            //        if (s_head != "")
            //        {
            //            string s_classID = utl.ExecuteASSScalar("select class from s_studentinfo where regno = '" + regNo + "'");

            //            string s_headID = utl.ExecuteASSScalar("select feesheadid from m_feescategoryhead where FeesCatHeadID='" + s_head + "' and academicID='" + sport_academic + "' and ClassID='" + s_classID + "' and feescategoryID='" + sport_feecatid + "' and formonth like '%" + sport_feemonth + "%'");

            //            DataTable sport_dttax = new DataTable();
            //            sport_dttax = utl.GetASSDataTable("select a.* from m_tax a  where a.isactive=1 and a.academicid='" +  sport_academic + "' and a.feeheadid='" + s_headID + "'");
            //            if (sport_dttax.Rows.Count > 0)
            //            {
            //                decimal s_taxvalue = Convert.ToDecimal(sport_feeAmount[i]) / (100 + Convert.ToDecimal(sport_dttax.Rows[0]["Percentage"].ToString())) * Convert.ToDecimal(sport_dttax.Rows[0]["Percentage"].ToString());

            //                sport_taxQuery = "insert into f_studenttaxbills(TaxBillID,FeesCatId,TaxID,TaxPercent,TaxAmount,isactive,userid)values('" + sport_taxBillID + "','" + s_head + "','" + sport_dttax.Rows[0]["TaxID"].ToString() + "','" + sport_dttax.Rows[0]["Percentage"].ToString() + "','" + s_taxvalue + "','true','" + userId + "')";
            //                utl.ExecuteASSQuery(sport_taxQuery);
            //            }

            //            i++;
            //        }
            //    }

            //}
        }

        //Ass BILL closure

        string subQuery = string.Empty;
        i = 0;
        foreach (string head in feeHead)
        {
            if (head!="" && head !=null)
            {
                //subQuery += "INSERT INTO [dbo].[f_studentbills]([BillId],[FeesCatHeadId],[BillMonth],[Amount],[IsActive],[UserId])VALUES(''DummyBill''," + head + ",''" + feemonth + "''," + feeAmount[i] + ",''True''," + userId + ")";
                subQuery += "INSERT INTO [dbo].[f_studentbills]([BillId],[FeesCatHeadId],[BillMonth],[Amount],[IsActive],[UserId],[ActualAmount],[Discount]) " +
                 "VALUES(''DummyBill''," + head + ",''" + feemonth + "''," + feeAmount[i] + ",''True''," + userId + "," + feeActualAmount[i] + "," + feeConcessionAmount[i] + ")";

                i++;
            }
           
        }

        string query = "[SP_InsertFeesBill] '0000'," + academic + "," + feecatid + "," + regNo + ",'" + feemonth + "'," + feetotalamt + ",'" + strdtdate + "'," + userId + ",'" + subQuery + "'," + PaymentMode + ",'" + cashamt + "','" + cardamt + "','" + qramt + "'";

        DataSet dsSaveBill = utl.GetDataset(query);
        if (dsSaveBill != null && dsSaveBill.Tables.Count > 0 && dsSaveBill.Tables[0].Rows.Count > 0)
        {

            query = "select distinct convert(varchar,year(startdate))+'-'+  convert(varchar,Datepart(yy,enddate)) as AcademicYear   from m_academicyear  where academicID='" + academic + "'";
            string AcademicYear = utl.ExecuteScalar(query);

            query = "select isnull(count(*),0)+1 from f_studenttaxbillmaster a inner join f_studentbillmaster b on a.BillID=b.BillID where b.academicID='" + academic + "' ";
            string TaxBillcnt = utl.ExecuteScalar(query);

            string schoolabbrivation = utl.ExecuteScalar("select ltrim(rtrim(Schoolabbreviation)) from m_schooldetails");
            string TaxBillNo = "GST/" + schoolabbrivation.ToString().TrimEnd() + "/" + "" + AcademicYear + "/000" + TaxBillcnt.ToString();

            query = "insert into f_studenttaxbillmaster(TaxBillNo,BillID,isactive,userID)values( '" + TaxBillNo.ToString().Trim() + "'," + dsSaveBill.Tables[0].Rows[0][0].ToString() + ",'true'," + userId + ")";
            utl.ExecuteQuery(query);

            string taxBillID = utl.ExecuteScalar("SELECT isnull(max(TaxBillID),0) from f_studenttaxbillmaster where isactive=1");
            string taxQuery = string.Empty;
            i = 0;
            foreach (string head in feeHead)
            {
                string classID = utl.ExecuteScalar("select class from s_studentinfo where regno = '" + regNo + "'");

                string headID = utl.ExecuteScalar("select feesheadid from m_feescategoryhead where FeesCatHeadID='" + head + "' and academicID='" + academic + "' and ClassID='" + classID + "' and feescategoryID='" + feecatid + "' and formonth like '%" + feemonth + "%'");

                DataTable dttax = new DataTable();
                dttax = utl.GetDataTable("select a.* from m_tax a  where a.isactive=1 and a.academicid='" + academic + "' and a.feeheadid='" + headID + "'");
                if (dttax.Rows.Count > 0)
                {
                    decimal taxvalue = Convert.ToDecimal(feeAmount[i]) / (100 + Convert.ToDecimal(dttax.Rows[0]["Percentage"].ToString())) * Convert.ToDecimal(dttax.Rows[0]["Percentage"].ToString());

                    taxQuery = "insert into f_studenttaxbills(TaxBillID,FeesCatId,TaxID,TaxPercent,TaxAmount,isactive,userid)values('" + taxBillID + "','" + head + "','" + dttax.Rows[0]["TaxID"].ToString() + "','" + dttax.Rows[0]["Percentage"].ToString() + "','" + taxvalue + "','true','" + userId + "')";
                    utl.ExecuteQuery(taxQuery);
                }

                i++;
            }

            PrintBill(dsSaveBill.Tables[0].Rows[0][0].ToString());
            return "Updated";
        }
        
        else
            return "Failed";
    }


    public static void PrintSlip(string BillId, string regNo, string AcademicId)
    {
        try
        {
            PrintDocument fd = new PrintDocument();
            Utilities utl = new Utilities();
            string SlipType = string.Empty;
            string query = "[sp_PrintSlip] " + BillId;
            DataSet dsPrint = utl.GetDataset(query);
            string printerName = ConfigurationManager.AppSettings["" + dsPrint.Tables[0].Rows[0]["BillMonth"].ToString() + "FeesPrinter"];
            string clientMachineName, clientIPAddress;
            //  clientMachineName = (Dns.GetHostEntry(Request.ServerVariables["remote_addr"]).HostName);
            clientIPAddress = HttpContext.Current.Request.ServerVariables["remote_addr"];

            if (dsPrint != null && dsPrint.Tables.Count > 1 && dsPrint.Tables[0].Rows.Count > 0 && BillId != string.Empty)
            {

                for (int i = 0; i < 2; i++)
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

                    str.Append(dsPrint.Tables[0].Rows[0]["SchoolShortName"].ToString().ToUpper() + " \r\n  " + dsPrint.Tables[0].Rows[0]["Schoolstate"].ToString().ToUpper() + " - " + dsPrint.Tables[0].Rows[0]["SchoolZip"].ToString() + "PHONE NO - " + dsPrint.Tables[0].Rows[0]["phoneno"].ToString().ToUpper() + "\r\n");



                    fd.PrintPage += (s, args) =>
                    {

                        if (dsPrint.Tables[0].Rows.Count > 0)
                        {
                            args.Graphics.DrawString(dsPrint.Tables[0].Rows[0]["SchoolShortName"].ToString().ToUpper(), new System.Drawing.Font("ARIAL", 9, FontStyle.Regular), Brushes.Black, new Rectangle(0, 0, 250, 25), stringAlignCenter);
                            args.Graphics.DrawString(dsPrint.Tables[0].Rows[0]["Schoolstate"].ToString().ToUpper() + "-" + dsPrint.Tables[0].Rows[0]["SchoolZip"].ToString() + " PHONE NO-" + dsPrint.Tables[0].Rows[0]["phoneno"].ToString().ToUpper(), new System.Drawing.Font("ARIAL", 8, FontStyle.Regular), Brushes.Black, new Rectangle(0, 20, 250, 25), stringAlignCenter);

                            args.Graphics.DrawLine(new Pen(Color.Black, 2), 0, 45, 500, 45);

                            if (i == 0)
                                SlipType = "BOOKS";
                            else
                                SlipType = "UNIFORM";

                            args.Graphics.DrawString("DELIVERY SLIP - " + SlipType, new System.Drawing.Font("ARIAL", 9, FontStyle.Underline), Brushes.Black, new Rectangle(0, 40, 250, 50), stringAlignCenter);


                            args.Graphics.DrawString("Bill No : " + dsPrint.Tables[1].Rows[0]["BillNo"].ToString().ToUpper(), new System.Drawing.Font("ARIAL", 9, FontStyle.Regular), Brushes.Black, new Rectangle(0, 80, 120, 50), stringAlignLeft);
                            args.Graphics.DrawString("Date : " + dsPrint.Tables[1].Rows[0]["BillDate"].ToString().ToUpper(), new System.Drawing.Font("ARIAL", 9, FontStyle.Regular), Brushes.Black, new Rectangle(135, 80, 130, 50), stringAlignRight);

                            args.Graphics.DrawString("Name ", new System.Drawing.Font("ARIAL", 9, FontStyle.Regular), Brushes.Black, new Rectangle(0, 105, 90, 50), stringAlignLeft);
                            args.Graphics.DrawString(":", new System.Drawing.Font("ARIAL", 9, FontStyle.Regular), Brushes.Black, new Rectangle(120, 105, 20, 50), stringAlignLeft);
                            args.Graphics.DrawString(dsPrint.Tables[1].Rows[0]["stname"].ToString().ToUpper(), new System.Drawing.Font("ARIAL", 8, FontStyle.Regular), Brushes.Black, new Rectangle(135, 105, 140, 50), stringAlignLeft);

                            args.Graphics.DrawString("Register No", new System.Drawing.Font("ARIAL", 9, FontStyle.Regular), Brushes.Black, new Rectangle(0, 125, 90, 50), stringAlignLeft);
                            args.Graphics.DrawString(":", new System.Drawing.Font("ARIAL", 9, FontStyle.Regular), Brushes.Black, new Rectangle(120, 125, 20, 50), stringAlignLeft);
                            args.Graphics.DrawString(dsPrint.Tables[1].Rows[0]["regno"].ToString().ToUpper(), new System.Drawing.Font("ARIAL", 9, FontStyle.Regular), Brushes.Black, new Rectangle(135, 125, 140, 50), stringAlignLeft);

                            args.Graphics.DrawString("Class", new System.Drawing.Font("ARIAL", 9, FontStyle.Regular), Brushes.Black, new Rectangle(0, 150, 90, 50), stringAlignLeft);
                            args.Graphics.DrawString(":", new System.Drawing.Font("ARIAL", 9, FontStyle.Regular), Brushes.Black, new Rectangle(120, 150, 20, 50), stringAlignLeft);
                            args.Graphics.DrawString(dsPrint.Tables[1].Rows[0]["classname"].ToString().ToUpper(), new System.Drawing.Font("ARIAL", 9, FontStyle.Regular), Brushes.Black, new Rectangle(135, 150, 140, 50), stringAlignLeft);

                            args.Graphics.DrawString("Section", new System.Drawing.Font("ARIAL", 9, FontStyle.Regular), Brushes.Black, new Rectangle(0, 175, 90, 50), stringAlignLeft);
                            args.Graphics.DrawString(":", new System.Drawing.Font("ARIAL", 9, FontStyle.Regular), Brushes.Black, new Rectangle(120, 175, 20, 50), stringAlignLeft);
                            args.Graphics.DrawString(dsPrint.Tables[1].Rows[0]["sectionname"].ToString().ToUpper(), new System.Drawing.Font("ARIAL", 9, FontStyle.Regular), Brushes.Black, new Rectangle(135, 175, 140, 50), stringAlignLeft);


                            args.Graphics.DrawString("Cashier", new System.Drawing.Font("ARIAL", 9, FontStyle.Regular), Brushes.Black, new Rectangle(0, 205, 250, 50), stringAlignRight);


                            args.Graphics.DrawString("Delivery Date : ", new System.Drawing.Font("ARIAL", 9, FontStyle.Regular), Brushes.Black, new Rectangle(0, 205, 110, 50), stringAlignLeft);

                            Pen pen = new Pen(Color.Black, 1);
                            pen.DashStyle = System.Drawing.Drawing2D.DashStyle.Dot;
                            args.Graphics.DrawLine(pen, 0, 215, 500, 215);

                            //args.Graphics.DrawLine(new Pen(Color.Black, 2), 0, 215, 500, 215);


                            args.Graphics.DrawString("Delivered", new System.Drawing.Font("ARIAL", 9, FontStyle.Regular), Brushes.Black, new Rectangle(120, 255, 130, 50), stringAlignRight);

                            Pen pen1 = new Pen(Color.Black, 1);
                            pen1.DashStyle = System.Drawing.Drawing2D.DashStyle.Dot;
                            args.Graphics.DrawLine(pen1, 0, 290, 500, 290);

                            //args.Graphics.DrawLine(new Pen(Color.Black, 2), 0, 290, 500, 290);
                        }

                    };
                    // clientIPAddress = "192.168.0.43";
                    fd.PrinterSettings.PrinterName = "\\\\" + clientIPAddress + "\\" + printerName + "";
                    fd.Print();
                }
            }
            fd.Dispose();
            GC.SuppressFinalize(fd);
        }
        catch (Exception err)
        {

        }

        finally { GC.Collect(); GC.WaitForPendingFinalizers(); }

    }

   /* [WebMethod]
    public static string SaveBillDetails(string regNo, string AcademicId, string FeesHeadIds, string FeesAmount, string FeesCatId, string FeesMonthName, string FeestotalAmount, string BillDate, string userId, string PaymentMode)
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
            subQuery += "INSERT INTO [dbo].[f_Sportsbills]([BillId],[FeesCatHeadId],[BillMonth],[Amount],[IsActive],[UserId])VALUES(''DummyBill''," + head + ",''" + FeesMonthName + "''," + feeAmount[i] + ",''True''," + userId + ")";
            i++;
        }

        if (BillDate == string.Empty)
        {
            BillDate = DateTime.Now.ToString("dd/MM/yyyy");


        }

        string[] formats = { "dd/MM/yyyy" };
        string formatBillDate = DateTime.ParseExact(BillDate, formats, new CultureInfo("en-US"), DateTimeStyles.None).ToShortDateString();

        string query = "[SP_InsertSportsFeesBill] '0000'," + AcademicId + "," + FeesCatId + "," + regNo + ",'" + FeesMonthName + "'," + FeestotalAmount + ",'" + formatBillDate + "'," + userId + ",'" + subQuery + "'," + PaymentMode;

        DataSet dsSaveBill = utl.GetDataset(query);

        if (dsSaveBill != null && dsSaveBill.Tables.Count > 0 && dsSaveBill.Tables[0].Rows.Count > 0)
        {
            PrintBill(dsSaveBill.Tables[0].Rows[0][0].ToString());
            return "Updated";
        }
        else
            return "Failed";
    }*/

    [WebMethod]
    public static string ViewBillDetails(string billId)
    {
        Utilities utl = new Utilities();
        string sqlstr = "select isactive from m_academicyear where AcademicID='" + HttpContext.Current.Session["AcademicID"].ToString() + "'";
        string Isactive = utl.ExecuteScalar(sqlstr);
        HttpContext.Current.Session["Isactive"] = Isactive.ToString();
        string query = "";
        DataSet dsStud = new DataSet();
        if (Isactive == "True")
        {
           query = "[sp_GetSportsBill] " + billId + "";
        }
        else
        {
            query = "[sp_GetOldSportsBill] " + billId + ",'" + HttpContext.Current.Session["AcademicID"] + "'";
        }

        DataSet ds = utl.GetDataset(query);
        return ds.GetXml();
    }

    [WebMethod]
    public static string BindStudDetails(string regNo, string academicId)
    {
        Utilities utl = new Utilities();
        string sqlstr = "select isactive from m_academicyear where AcademicID='" + HttpContext.Current.Session["AcademicID"].ToString() + "'";
        string Isactive = utl.ExecuteScalar(sqlstr);
        HttpContext.Current.Session["Isactive"] = Isactive.ToString();
        string query = "";
        DataSet dsStud = new DataSet();
        if (Isactive == "True")
        {
            dsStud = utl.GetDataset("sp_getStudentDetails " + regNo + "," + academicId);
        }
        else
        {
            dsStud = utl.GetDataset("sp_getOldStudentDetails " + regNo + "," + academicId);
        }
        return dsStud.GetXml();

    }


    [WebMethod]
    public static string PrintBillDetails(string billId)
    {
        Utilities utl = new Utilities();
        string StrContent = "";
      string  BillMonth = utl.ExecuteScalar("select BillMonth from f_studentbillmaster where billId='" + billId + "'");
        if (BillMonth=="Jun")
        {
             StrContent = PrinTaxtBill(billId); 
        }
        else
        {
             PrintBill(billId);
             StrContent = "";
        }

        return StrContent;
    }
    public static string PrinTaxtBill(string billId)
    {
        string clientMachineName, clientIPAddress = "";
        string strPrintContent = "";

        StringBuilder str = new StringBuilder();
        Utilities utl = new Utilities();
        string sqlstr = "select isactive from m_academicyear where AcademicID='" + HttpContext.Current.Session["AcademicID"].ToString() + "'";
        string Isactive = utl.ExecuteScalar(sqlstr);
        HttpContext.Current.Session["Isactive"] = Isactive.ToString();
        string query = "";
        DataSet dsStud = new DataSet();
        if (Isactive == "True")
        {
            query = "[sp_GetStudentTaxBill] " + billId + "";

            DataSet dsPrint = utl.GetDataset(query);
            int yPos = 0;
            int headCount = 0;
            string printerName = ConfigurationManager.AppSettings["JuneFeesPrinter"];

            clientIPAddress = HttpContext.Current.Request.ServerVariables["remote_addr"];

            if (dsPrint.Tables.Count > 1)
            {

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

                if (dsPrint.Tables[0].Rows.Count > 0)
                {
                    decimal totalConcessionAmount = 0;
                    str.Append("<table width='100%' border='0' align='center' cellpadding='0' cellspacing='0' style=' border:1px dashed #000000;' class='billcont'><tr><td width='380' style='padding-left:5px;padding-right:5px;'><table width='300' border='0' cellspacing='0' cellpadding='3'><tr><td height='10' colspan='2' align='center' class='billcont' ></td></tr><tr><td height='30' colspan='2' align='center' class='billcont' style='border-bottom: 1px solid #000;margin-left:20px;margin-right:20px;' >" + dsPrint.Tables[2].Rows[0]["SchoolShortName"].ToString().ToUpper() + "</td></tr><tr><td height='30' colspan='2' align='center' class='ph'> " + dsPrint.Tables[2].Rows[0]["Schoolstate"].ToString().ToUpper() + "-" + dsPrint.Tables[2].Rows[0]["SchoolZip"].ToString() + " PHONE NO-" + dsPrint.Tables[2].Rows[0]["phoneno"].ToString().ToUpper() + "</td></tr><tr class='billcont'><td width='52%' height='40'>&nbsp;Reg. No. : " + dsPrint.Tables[0].Rows[0]["RegNo"].ToString() + "</td><td width='48%'><div style='float:right;'>Rec. No. : " + dsPrint.Tables[0].Rows[0]["BillNo"].ToString() + "</div></td></tr><tr class='billcont'><td height='40' colspan='2'>Name : " + dsPrint.Tables[0].Rows[0]["stname"].ToString() + "</td></tr><tr class='billcont'><td width='52%' height='40'>Class &amp;Sec : " + dsPrint.Tables[0].Rows[0]["classname"].ToString() + "  " + dsPrint.Tables[0].Rows[0]["sectionname"].ToString() + " </td><td><div style='float:right;'>Month : " + dsPrint.Tables[0].Rows[0]["BillMonth"].ToString() + "</div></td></tr><tr><td height='10' colspan='2'></td></tr><tr><td colspan='2'><table width='100%' border='0' align='center' cellpadding='3' cellspacing='0' class='particulars' style='border:1px solid #000;'><tr class='billcont'><td width='75%' height='25' style='border-bottom: 1px solid #000;border-right: 1px solid #000;'><div align='center'>PARTICULARS</div></td><td width='30%' style='border-bottom: 1px solid #000;'><div align='center'>AMOUNT</div></td></tr>");
                    for (int i = 0; i < dsPrint.Tables[1].Rows.Count; i++)
                    {
                        // str.Append(" <tr class='billcont'><td height='25' style='border-right:1px solid #000;'>" + dsPrint.Tables[1].Rows[i]["FeesHeadName"].ToString() + "</td><td><div align='center'> " + dsPrint.Tables[1].Rows[i]["Amount"].ToString() + " </div></td></tr> ");
                        string feesHeadName = dsPrint.Tables[1].Rows[i]["FeesHeadName"].ToString();
                        string actualAmount = dsPrint.Tables[1].Rows[i]["ActualAmount"].ToString();
                        string concessionAmount = dsPrint.Tables[1].Rows[i]["ConcessionAmount"].ToString();
                        decimal concessionVal;
                        if (decimal.TryParse(concessionAmount, out concessionVal))
                        {
                            totalConcessionAmount += concessionVal;
                        }
                        str.Append(" <tr class='billcont'>" +
                                   "<td height='25' style='border-right:1px solid #000;'>" + feesHeadName + "</td>" +
                                   "<td>" + "<div align='center'>" + actualAmount + "</div>" + "</td></tr> ");

                    }
                    if (totalConcessionAmount > 0)
                    {
                        str.Append(" <tr class='billcont'>" + "<td height='25' style='border-right:1px solid #000;'>Concession Granted </td>" +
                                  "<td>" + "<div align='center'>" + totalConcessionAmount + "</div>" + "</td></tr> ");
                    }


                    Code39BarCode barcode = new Code39BarCode();
                    barcode.BarCodeText = dsPrint.Tables[0].Rows[0]["RegNo"].ToString();
                    barcode.ShowBarCodeText = true;
                    barcode.BarCodeWeight = BarCodeWeight.Small;
                    byte[] imgArr = barcode.Generate();
                    using (FileStream file = new FileStream(HttpContext.Current.Server.MapPath("~\\Students\\Barcodes\\") + dsPrint.Tables[0].Rows[0]["RegNo"].ToString() + ".JPG", FileMode.Create, FileAccess.Write))
                    {
                        file.Write(imgArr, 0, imgArr.Length);
                    }

                    str.Append("<tr class='billcont'><td height='45' style='border-top: 1px solid #000;border-right: 1px solid #000;'>TOTAL</td><td style='border-top:1px solid #000;'><div align='center'>" + dsPrint.Tables[0].Rows[0]["TotalAmount"].ToString() + "</div></td></tr></table></td></tr><br/><br/>");

                    DataTable dtadv = new DataTable();
                    string old_academicID = utl.ExecuteScalar("select top 1 * from m_academicyear where isactive=0 order by academicID desc ");
                    dtadv = utl.GetDataTable(@" select sf.*,convert(varchar(10),billdate,103) as datebill  FROM   s_studentinfo info
	  inner join s_studentpromotion promo on info.RegNo=promo.RegNo
             INNER JOIN m_feescategory c  
                     ON info.active = c.feescatcode  
                        AND c.isactive = 1  
             INNER JOIN m_feescategoryhead ch on  
                   ch.academicid = promo.AcademicId
                        AND promo.classId = ch.classid  
                        AND ch.isactive = 1  
             INNER JOIN m_feeshead h  
                     ON h.feesheadid = ch.feesheadid  
                        AND h.feesheadcode = 'A'  
                        AND h.isactive = 1  
             INNER JOIN f_studentbillmaster sf  
                     ON sf.regno = info.regno  
                        AND ch.academicid = sf.academicid  
                        AND sf.isactive = 1  
			INNER JOIN f_studentbills sfb  
                     ON sfb.BillId = sf.BillId  
                        AND ch.FeesCatHeadID = sfb.FeesCatHeadID  
                        AND sfb.isactive = 1 
      WHERE  info.regno = '" + dsPrint.Tables[0].Rows[0]["RegNo"].ToString() + "' AND info.academicyear = " + HttpContext.Current.Session["AcademicID"] + " and promo.AcademicId= '" + old_academicID + "' order by sf.billID desc");
                    if (dtadv != null && dtadv.Rows.Count > 0)
                    {
                        str.Append("<tr><td colspan='2' class='billcont'>Remarks:</td></tr>");
                        str.Append("<tr><td colspan='2' class='billcont'>Advance Received: " + dtadv.Rows[0]["TotalAmount"].ToString() + "</td></tr>");
                        str.Append("<tr><td colspan='2' class='billcont'>Bill No: " + dtadv.Rows[0]["BillNo"].ToString() + "</td></tr>");
                        str.Append("<tr><td colspan='2' class='billcont'>Bill Date: " + dtadv.Rows[0]["datebill"].ToString() + "</td></tr>");
                        str.Append("<tr><td></td></tr>");
                    }

                    str.Append("<tr ><td colspan='2' class='billcont'>&nbsp;Date : " + dsPrint.Tables[0].Rows[0]["BillDate"].ToString() + "<br/><br/></td></tr><tr><td colspan='2' class='billcont'>Cashier : " + dsPrint.Tables[0].Rows[0]["staffname"].ToString() + "<br/><br/><br/><br/></td></tr></table></td><td width='300' valign='top' style='padding-left:5px;padding-right:5px;border-left: 1px dashed #000000;border-right: 1px dashed #000000;'><table width='300' border='0' align='center' cellpadding='3' cellspacing='0'><tr><td height='10' colspan='2' align='center' class='billcont' ></td></tr><tr><td height='50' colspan='2' align='center' class='billcont' style='border-bottom: 1px solid #000;margin-left:20px;margin-right:20px;'>" + dsPrint.Tables[2].Rows[0]["SchoolShortName"].ToString().ToUpper() + "</td></tr><tr><td height='50' colspan='2' align='center' class='ph'> " + dsPrint.Tables[2].Rows[0]["Schoolstate"].ToString().ToUpper() + "-" + dsPrint.Tables[2].Rows[0]["SchoolZip"].ToString() + " PHONE NO-" + dsPrint.Tables[2].Rows[0]["phoneno"].ToString().ToUpper() + "</td></tr><tr><td height='50' colspan='2' align='center' class='billcont'><U>DELIVERY SLIP - BOOKS</U></td></tr><tr class='billcont'><td width='55%' height='50'>Ref. No. : " + dsPrint.Tables[0].Rows[0]["BillNo"].ToString() + "</td><td width='45%' style='padding-right:10px;' align='right'>Date : " + dsPrint.Tables[0].Rows[0]["BillDate"].ToString() + "</td></tr><tr class='billcont'><td height='50'>Reg No. : " + dsPrint.Tables[0].Rows[0]["RegNo"].ToString() + "</td><td height='50' style='padding-right:10px;' align='right'>Class &amp;Sec : " + dsPrint.Tables[0].Rows[0]["classname"].ToString() + "  " + dsPrint.Tables[0].Rows[0]["sectionname"].ToString() + " </td></tr><tr class='billcont'><td height='50'>Name : " + dsPrint.Tables[0].Rows[0]["stname"].ToString() + "</td><td style='padding-right:10px;' align='right'>Gender : " + dsPrint.Tables[0].Rows[0]["Sex"].ToString().ToUpper() + "</td></tr><tr class='billcont'><td colspan='2' align='center' valign='top' class='barcodeimage'><img style='max-width:inherit;' width='201' src= '../Students/Barcodes/" + dsPrint.Tables[0].Rows[0]["RegNo"].ToString() + ".JPG' /></td></tr><tr><td colspan='2'>&nbsp;</td></tr><tr class='billcont'><td colspan='2' style='border-top: 1px solid #000;border-bottom: 1px solid #000;'><br/> &nbsp;Cashier : " + dsPrint.Tables[0].Rows[0]["staffname"].ToString() + "<br/><br/></td></tr><tr class='billcont'><td colspan='2' style='border-bottom: 1px solid #000;'><div align='center'><br/> Delivery Details<br/><br/></div></td></tr><tr><td colspan='2' >&nbsp;</td></tr><tr class='billcont'><td colspan='2'>&nbsp;Date : <br/><br/></td></tr><tr class='billcont'><td colspan='2'>Issued By :<br/><br/><br/></td></tr></table></td><td width='300' valign='top' style='padding-left:5px;padding-right:0px;'><table width='300' border='0' align='right' cellpadding='3' cellspacing='0'><tr><td height='10' colspan='2' align='center' class='billcont' ></td></tr><tr><td height='50' colspan='2' align='center' class='billcont' style='border-bottom: 1px solid #000;margin-left:20px;margin-right:20px;' >" + dsPrint.Tables[2].Rows[0]["SchoolShortName"].ToString().ToUpper() + "</td></tr><tr><td height='50' colspan='2' align='center' class='ph'> " + dsPrint.Tables[2].Rows[0]["Schoolstate"].ToString().ToUpper() + "-" + dsPrint.Tables[2].Rows[0]["SchoolZip"].ToString() + " PHONE NO-" + dsPrint.Tables[2].Rows[0]["phoneno"].ToString().ToUpper() + "</td></tr><tr><td height='50' class='billcont' align='center' colspan='2'><U>DELIVERY SLIP - UNIFORMS</U></td></tr><tr class='billcont'><td width='55%' height='50'>Ref. No. : " + dsPrint.Tables[0].Rows[0]["BillNo"].ToString() + "</td><td width='45%'style='padding-right:10px;' align='right'>Date : " + dsPrint.Tables[0].Rows[0]["BillDate"].ToString() + "</td></tr><tr class='billcont'><td height='50'>Reg No. : " + dsPrint.Tables[0].Rows[0]["RegNo"].ToString() + "</td><td height='50' style='padding-right:10px;' align='right'>Class &amp;Sec : " + dsPrint.Tables[0].Rows[0]["classname"].ToString() + "  " + dsPrint.Tables[0].Rows[0]["sectionname"].ToString() + " </td></tr><tr class='billcont'><td height='50'>Name : " + dsPrint.Tables[0].Rows[0]["stname"].ToString() + "</td><td style='padding-right:10px;' align='right'>Gender : " + dsPrint.Tables[0].Rows[0]["Sex"].ToString().ToUpper() + "</td></tr><tr class='billcont'><td colspan='2' align='center' valign='top' class='barcodeimage'><img style='max-width:inherit;' width='201' src= '../Students/Barcodes/" + dsPrint.Tables[0].Rows[0]["RegNo"].ToString() + ".JPG' /></td></tr><tr class='billcont'><td colspan='2' style='border-top: 1px solid #000;border-bottom: 1px solid #000;'><br/> Cashier : " + dsPrint.Tables[0].Rows[0]["staffname"].ToString() + "<br/><br/></td></tr><tr class='billcont'><td colspan='2' style='border-bottom: 1px solid #000;'><div align='center'><br/> Delivery Details<br/><br/></div></td></tr><tr><td colspan='2' >&nbsp;</td></tr><tr class='billcont'><td colspan='2'>&nbsp;Date : <br/><br/></td></tr><tr class='billcont'><td colspan='2'>Issued By :<br/><br/><br/></td></tr></table></td></tr></table>");

                    sqlstr = "select isnull(count(b.TaxBillID),0) from f_studenttaxbillmaster a inner join f_studenttaxbills b on a.TaxBillID=b.TaxBillID where BillID='" + billId + "' and a.isactive=1";
                    string ibillcnt = utl.ExecuteScalar(sqlstr);
                    if (ibillcnt == "0")
                    {
                        sqlstr = " select* from f_studentbills where billID='" + billId + "'";
                        DataTable dtbill = new DataTable();
                        dtbill = utl.GetDataTable(sqlstr);
                        if (dtbill != null && dtbill.Rows.Count > 0)
                        {
                            for (int i = 0; i < dtbill.Rows.Count; i++)
                            {
                                string classID = utl.ExecuteScalar("select class from s_studentinfo where regno = '" + dsPrint.Tables[1].Rows[0]["RegNo"].ToString() + "'");

                                string headID = utl.ExecuteScalar("select feesheadid from m_feescategoryhead where FeesCatHeadID='" + dtbill.Rows[i]["FeesCatHeadId"] + "' and academicID='" + HttpContext.Current.Session["AcademicID"] + "' and ClassID='" + classID + "' and feescategoryID='" + dsPrint.Tables[0].Rows[0]["FeesCategoryID"].ToString() + "' and formonth like '%" + dsPrint.Tables[1].Rows[0]["BillMonth"].ToString() + "%'");

                                DataTable dttax = new DataTable();
                                dttax = utl.GetDataTable("select a.* from m_tax a  where a.isactive=1 and a.academicid='" + HttpContext.Current.Session["AcademicID"] + "' and a.feeheadid='" + headID + "'");
                                if (dttax.Rows.Count > 0)
                                {
                                    decimal taxvalue = Convert.ToDecimal(dtbill.Rows[i]["Amount"]) / (100 + Convert.ToDecimal(dttax.Rows[0]["Percentage"].ToString())) * Convert.ToDecimal(dttax.Rows[0]["Percentage"].ToString());
                                    if (dsPrint.Tables[3].Rows.Count > 0)
                                    {

                                        string taxQuery = "insert into f_studenttaxbills(TaxBillID,FeesCatId,TaxID,TaxPercent,TaxAmount,isactive,userid)values('" + dsPrint.Tables[3].Rows[0]["TaxBillID"].ToString().Trim() + "','" + dtbill.Rows[i]["FeesCatHeadId"].ToString().Trim() + "','" + dttax.Rows[0]["TaxID"].ToString().Trim() + "','" + dttax.Rows[0]["Percentage"].ToString().Trim() + "','" + taxvalue + "','true','" + dsPrint.Tables[1].Rows[0]["UserId"].ToString().Trim() + "')";
                                        utl.ExecuteQuery(taxQuery);
                                    }
                                }
                            }
                        }

                    }
                    if (dsPrint.Tables[3].Rows.Count > 0)
                    {
                        str.Append("<table width='100%' border='0' align='center' cellpadding='0' cellspacing='0' class='break-after'><tr class='billcont'><table width='100%' border='0' align='center' cellpadding='0' cellspacing='0'><br/><tr class='billcont'><td height='30'>Hail Mary!</td><td style='text-align:right;' height='30'>Praise the Lord!</td></tr><tr class='billcont'><td height='5'></td><td height='5'></td></tr><tr class='billcont'><td style='text-align:center;font-size: 18px;' colspan='2' height='25'>" + dsPrint.Tables[2].Rows[0]["SchoolShortName"].ToString().ToUpper() + "</td></tr><tr class='billcont'><td style='text-align:center;' colspan='2' height='25'> (A unit of Amalorpavam Educational Welfare Society)</td></tr><tr class='billcont'><td style='text-align:center;' colspan='2' height='25'> " + dsPrint.Tables[2].Rows[0]["SchoolAddress"].ToString().ToUpper() + ", " + dsPrint.Tables[2].Rows[0]["SchoolCity"].ToString().ToUpper() + ", " + dsPrint.Tables[2].Rows[0]["SchoolDist"].ToString().ToUpper() + "</td></tr><tr class='billcont'><td style='text-align:center;' colspan='2' height='25'><b>GSTIN : </b>" + dsPrint.Tables[2].Rows[0]["GSTIN"].ToString().ToUpper() + "</td></tr><br/><br/><br/><tr class='billcont'><td height='25'>BILL No.: " + dsPrint.Tables[3].Rows[0]["TaxBillNo"].ToString().ToUpper() + "</td><td style='padding-left:500px;' height='25'>Ref. No .: " + dsPrint.Tables[3].Rows[0]["BillNo"].ToString().ToUpper() + "</td></tr><tr class='billcont'><td height='25'>Regn. No.: " + dsPrint.Tables[3].Rows[0]["RegNo"].ToString().ToUpper() + "</td><td style='padding-left:500px;' height='25'>Class & Sec. : " + dsPrint.Tables[3].Rows[0]["ClassName"].ToString().ToUpper() + " " + dsPrint.Tables[3].Rows[0]["SectionName"].ToString().ToUpper() + "</td></tr><tr class='billcont'><td height='25'>Student Name : " + dsPrint.Tables[3].Rows[0]["StName"].ToString().ToUpper() + " </td><td style='padding-left:500px;' height='25'>State Code : 34</td></tr><tr class='billcont'><td height='5'></td><td height='5'></td></tr></table><table width='100%' border='0' align='center' cellpadding='0' cellspacing='0' style='border:1px solid #000;'><tr class='billcont'><th style='border-bottom: 1px solid #000;border-right: 1px solid #000;' height='25'>SL. NO.</th><th style='border-bottom: 1px solid #000;border-right: 1px solid #000;' height='25'>DESCRIPTION OF GOODS</th><th style='border-bottom: 1px solid #000;border-right: 1px solid #000;' height='25'>QTY</th><th style='border-bottom: 1px solid #000;border-right: 1px solid #000;' height='25'>RATE</th><th style='border-bottom: 1px solid #000;border-right: 1px solid #000;' height='25'>TAXABLE VALUE</th><th style='border-bottom: 1px solid #000;border-right: 1px solid #000;' height='25'>GST%</th><th style='border-bottom: 1px solid #000;border-right: 1px solid #000;' height='25'>GST% AMOUNT</th><th style='border-bottom: 1px solid #000;border-right: 1px solid #000;' height='25'>SGST</th><th style='border-bottom: 1px solid #000;border-right: 1px solid #000;' height='25'>CGST</th><th style='border-bottom: 1px solid #000;'>AMOUNT</th></tr> ");

                        decimal total = 0, totalconcessionamountPage2 = 0;

                        for (int i = 0; i < dsPrint.Tables[4].Rows.Count; i++)
                        {
                            total += Math.Round(Convert.ToDecimal(dsPrint.Tables[4].Rows[i]["Amount"]));

                            // str.Append(" <tr class=' billcont' style='text-align:center;'><td height='25' style='border-bottom: 1px solid #000;border-right: 1px solid #000;'> " + (i + 1).ToString() + " </td><td height='25' style='text-align:left;border-bottom: 1px solid #000;border-right: 1px solid #000;'>  " + dsPrint.Tables[4].Rows[i]["FeesHeadName"].ToString().ToUpper() + "</td><td height='25' style='border-bottom: 1px solid #000;border-right: 1px solid #000;'>  " + dsPrint.Tables[4].Rows[i]["qty"].ToString().ToUpper() + "</td><td height='25' style='border-bottom: 1px solid #000;border-right: 1px solid #000;'>  " + dsPrint.Tables[4].Rows[i]["extax"].ToString().ToUpper() + "</td><td height='25' style='border-bottom: 1px solid #000;border-right: 1px solid #000;'>  " + (Convert.ToDecimal(dsPrint.Tables[4].Rows[i]["qty"]) * Convert.ToDecimal(dsPrint.Tables[4].Rows[i]["extax"])).ToString().ToUpper() + "</td><td height='25' style='border-bottom: 1px solid #000;border-right: 1px solid #000;'> " + dsPrint.Tables[4].Rows[i]["TaxPercent"].ToString().ToUpper() + "</td><td height='25' style='border-bottom: 1px solid #000;border-right: 1px solid #000;'>  " + dsPrint.Tables[4].Rows[i]["TaxAmount"].ToString().ToUpper() + "</td><td height='25' style='border-bottom: 1px solid #000;border-right: 1px solid #000;'>  " + dsPrint.Tables[4].Rows[i]["cgst"].ToString().ToUpper() + "</td><td height='25' style='border-bottom: 1px solid #000;border-right: 1px solid #000;'>  " + dsPrint.Tables[4].Rows[i]["cgst"].ToString().ToUpper() + " </td><td height='25' style='border-bottom: 1px solid #000;border-right: 1px solid #000;text-align:right;padding-right: 10px;'>  " + Math.Round(Convert.ToDecimal(dsPrint.Tables[4].Rows[i]["Amount"].ToString().ToUpper())).ToString() + " </td></tr>");
                            str.Append(" <tr class=' billcont' style='text-align:center;'><td height='25' style='border-bottom: 1px solid #000;border-right: 1px solid #000;'> " + (i + 1).ToString() + " </td><td height='25' style='text-align:left;border-bottom: 1px solid #000;border-right: 1px solid #000;'>  " + dsPrint.Tables[4].Rows[i]["FeesHeadName"].ToString().ToUpper() + "</td><td height='25' style='border-bottom: 1px solid #000;border-right: 1px solid #000;'>  " + dsPrint.Tables[4].Rows[i]["qty"].ToString().ToUpper() + "</td><td height='25' style='border-bottom: 1px solid #000;border-right: 1px solid #000;'>  " + dsPrint.Tables[4].Rows[i]["extax"].ToString().ToUpper() + "</td><td height='25' style='border-bottom: 1px solid #000;border-right: 1px solid #000;'>  " + (Convert.ToDecimal(dsPrint.Tables[4].Rows[i]["qty"]) * Convert.ToDecimal(dsPrint.Tables[4].Rows[i]["extax"])).ToString().ToUpper() + "</td><td height='25' style='border-bottom: 1px solid #000;border-right: 1px solid #000;'> " + dsPrint.Tables[4].Rows[i]["TaxPercent"].ToString().ToUpper() + "</td><td height='25' style='border-bottom: 1px solid #000;border-right: 1px solid #000;'>  " + dsPrint.Tables[4].Rows[i]["TaxAmount"].ToString().ToUpper() + "</td><td height='25' style='border-bottom: 1px solid #000;border-right: 1px solid #000;'>  " + dsPrint.Tables[4].Rows[i]["cgst"].ToString().ToUpper() + "</td><td height='25' style='border-bottom: 1px solid #000;border-right: 1px solid #000;'>  " + dsPrint.Tables[4].Rows[i]["cgst"].ToString().ToUpper() + " </td><td height='25' style='border-bottom: 1px solid #000;border-right: 1px solid #000;text-align:right;padding-right: 10px;'>  " + Math.Round(Convert.ToDecimal(dsPrint.Tables[4].Rows[i]["actualamount"].ToString().ToUpper())).ToString() + " </td></tr>");

                        }

                        string roundoff = utl.ExecuteScalar("select round(" + Math.Round(Convert.ToDecimal(total)).ToString() + ",-1)");

                        decimal roundval = Convert.ToDecimal(roundoff) - Math.Round(Convert.ToDecimal(total));
                        //   str.Append("<tr class='billcont'><td colspan='9' height='25' style='border-bottom: 1px solid #000;border-right: 1px solid #000;text-align:right;padding-right: 10px;'> SUB TOTAL</td><td height='25' style='border-bottom: 1px solid #000;text-align:right;padding-right: 10px;'> " + Math.Round(Convert.ToDecimal(total)) + "</td></tr><tr class='billcont'><td colspan='9' height='25' style='border-bottom: 1px solid #000;border-right: 1px solid #000;text-align:right;padding-right: 10px;'> ROUND OFF</td><td height='25' style='border-bottom: 1px solid #000;text-align:right;padding-right: 10px;'> " + Convert.ToDecimal(roundval).ToString() + "</td></tr><tr class='billcont'><td colspan='9' height='25' style='border-right: 1px solid #000;text-align:right;padding-right: 10px;'> TOTAL</td><td height='25' style='text-align:right;padding-right: 10px;'> " + roundoff.ToString().ToUpper() + "</td></tr></table><table width='100%' border='0' align='center' cellpadding='0' cellspacing='0'><tr class='billcont'><td height='5'></td><td height='5'></td></tr><tr class='billcont'><td colspan='2' height='10'>Amount in words :  " + utl.retWord(Math.Round(Convert.ToDecimal(roundoff.ToString().ToUpper()))) + " Only</td></tr><tr class='billcont'><td height='50'>Date : " + dsPrint.Tables[3].Rows[0]["BillDate"].ToString() + "</td><td height='50' style='text-align:right;'><strong>Cashier:  " + dsPrint.Tables[0].Rows[0]["staffname"].ToString() + "</strong></td></tr></table></tr></table>");
                        str.Append(@"
<tr class='billcont'>
    <td colspan='9' height='25' style='border-bottom: 1px solid #000; border-right: 1px solid #000; text-align:right; padding-right: 10px;'> 
        SUB TOTAL
    </td>
    <td height='25' style='border-bottom: 1px solid #000; text-align:right; padding-right: 10px;'> 
        " + Math.Round(Convert.ToDecimal(total)) + @"
    </td>
</tr>");

                        if (totalconcessionamountPage2 > 0)
                        {
                            str.Append(@"
<tr class='billcont'>
    <td colspan='9' height='25' style='border-bottom: 1px solid #000; border-right: 1px solid #000; text-align:right; padding-right: 10px;'> 
        CONCESSION GRANTED
    </td>
    <td height='25' style='border-bottom: 1px solid #000; text-align:right; padding-right: 10px;'> 
        " + Convert.ToDecimal(totalconcessionamountPage2).ToString("0.00") + @"
    </td>
</tr>");
                        }

                        str.Append(@"
<tr class='billcont'>
    <td colspan='9' height='25' style='border-bottom: 1px solid #000; border-right: 1px solid #000; text-align:right; padding-right: 10px;'> 
        ROUND OFF
    </td>
    <td height='25' style='border-bottom: 1px solid #000; text-align:right; padding-right: 10px;'> 
        " + Convert.ToDecimal(roundval).ToString("0.00") + @"
    </td>
</tr>

<tr class='billcont'>
    <td colspan='9' height='25' style='border-right: 1px solid #000; text-align:right; padding-right: 10px;'> 
        TOTAL
    </td>
    <td height='25' style='text-align:right; padding-right: 10px;'> 
        " + roundoff.ToString().ToUpper() + @"
    </td>
</tr>

</table>

<table width='100%' border='0' align='center' cellpadding='0' cellspacing='0'>
<tr class='billcont'>
    <td height='5'></td>
    <td height='5'></td>
</tr>

<tr class='billcont'>
    <td colspan='2' height='10'>
        Amount in words : " + utl.retWord(Math.Round(Convert.ToDecimal(roundoff.ToString().ToUpper()))) + @" Only
    </td>
</tr>

<tr class='billcont'>
    <td height='50'>
        Date : " + dsPrint.Tables[3].Rows[0]["BillDate"].ToString() + @"
    </td>
    <td height='50' style='text-align:right;'>
        <strong>Cashier: " + dsPrint.Tables[0].Rows[0]["staffname"].ToString() + @"</strong>
    </td>
</tr>
</table>
");

                    }
                }

                strPrintContent = str.ToString();
            }
        }
        else
        {
            if (Convert.ToInt32(HttpContext.Current.Session["AcademicID"]) >= 27)
            {
                query = "[Sp_getstudentoldtaxbill] " + billId + ",'" + HttpContext.Current.Session["AcademicID"] + "'";

                DataSet dsPrint = utl.GetDataset(query);
                int yPos = 0;
                int headCount = 0;
                string printerName = ConfigurationManager.AppSettings["JuneFeesPrinter"];

                clientIPAddress = HttpContext.Current.Request.ServerVariables["remote_addr"];

                if (dsPrint.Tables.Count > 1)
                {

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

                    if (dsPrint.Tables[0].Rows.Count > 0)
                    {
                        str.Append("<table width='100%' border='0' align='center' cellpadding='0' cellspacing='0' style=' border:1px dashed #000000;' class='billcont'><tr><td width='380' style='padding-left:5px;padding-right:5px;'><table width='300' border='0' cellspacing='0' cellpadding='3'><tr><td height='10' colspan='2' align='center' class='billcont' ></td></tr><tr><td height='30' colspan='2' align='center' class='billcont' style='border-bottom: 1px solid #000;margin-left:20px;margin-right:20px;' >" + dsPrint.Tables[2].Rows[0]["SchoolShortName"].ToString().ToUpper() + "</td></tr><tr><td height='30' colspan='2' align='center' class='ph'> " + dsPrint.Tables[2].Rows[0]["Schoolstate"].ToString().ToUpper() + "-" + dsPrint.Tables[2].Rows[0]["SchoolZip"].ToString() + " PHONE NO-" + dsPrint.Tables[2].Rows[0]["phoneno"].ToString().ToUpper() + "</td></tr><tr class='billcont'><td width='52%' height='40'>&nbsp;Reg. No. : " + dsPrint.Tables[0].Rows[0]["RegNo"].ToString() + "</td><td width='48%'><div style='float:right;'>Rec. No. : " + dsPrint.Tables[0].Rows[0]["BillNo"].ToString() + "</div></td></tr><tr class='billcont'><td height='40' colspan='2'>Name : " + dsPrint.Tables[0].Rows[0]["stname"].ToString() + "</td></tr><tr class='billcont'><td width='52%' height='40'>Class &amp;Sec : " + dsPrint.Tables[0].Rows[0]["classname"].ToString() + "  " + dsPrint.Tables[0].Rows[0]["sectionname"].ToString() + " </td><td><div style='float:right;'>Month : " + dsPrint.Tables[0].Rows[0]["BillMonth"].ToString() + "</div></td></tr><tr><td height='10' colspan='2'></td></tr><tr><td colspan='2'><table width='100%' border='0' align='center' cellpadding='3' cellspacing='0' class='particulars' style='border:1px solid #000;'><tr class='billcont'><td width='75%' height='25' style='border-bottom: 1px solid #000;border-right: 1px solid #000;'><div align='center'>PARTICULARS</div></td><td width='30%' style='border-bottom: 1px solid #000;'><div align='center'>AMOUNT</div></td></tr>");
                        for (int i = 0; i < dsPrint.Tables[1].Rows.Count; i++)
                        {
                            str.Append(" <tr class='billcont'><td height='25' style='border-right:1px solid #000;'>" + dsPrint.Tables[1].Rows[i]["FeesHeadName"].ToString() + "</td><td><div align='center'> " + dsPrint.Tables[1].Rows[i]["Amount"].ToString() + " </div></td></tr> ");
                        }

                        Code39BarCode barcode = new Code39BarCode();
                        barcode.BarCodeText = dsPrint.Tables[0].Rows[0]["RegNo"].ToString();
                        barcode.ShowBarCodeText = true;
                        barcode.BarCodeWeight = BarCodeWeight.Small;
                        byte[] imgArr = barcode.Generate();
                        using (FileStream file = new FileStream(HttpContext.Current.Server.MapPath("~\\Students\\Barcodes\\") + dsPrint.Tables[0].Rows[0]["RegNo"].ToString() + ".JPG", FileMode.Create, FileAccess.Write))
                        {
                            file.Write(imgArr, 0, imgArr.Length);
                        }

                        str.Append("<tr class='billcont'><td height='45' style='border-top: 1px solid #000;border-right: 1px solid #000;'>TOTAL</td><td style='border-top:1px solid #000;'><div align='center'>" + dsPrint.Tables[0].Rows[0]["TotalAmount"].ToString() + "</div></td></tr></table></td></tr><tr ><td colspan='2' class='billcont'>&nbsp;Date : " + dsPrint.Tables[0].Rows[0]["BillDate"].ToString() + "<br/><br/></td></tr><tr><td colspan='2' class='billcont'>Cashier : " + dsPrint.Tables[0].Rows[0]["staffname"].ToString() + "<br/><br/><br/><br/></td></tr></table></td><td width='300' valign='top' style='padding-left:5px;padding-right:5px;border-left: 1px dashed #000000;border-right: 1px dashed #000000;'><table width='300' border='0' align='center' cellpadding='3' cellspacing='0'><tr><td height='10' colspan='2' align='center' class='billcont' ></td></tr><tr><td height='50' colspan='2' align='center' class='billcont' style='border-bottom: 1px solid #000;margin-left:20px;margin-right:20px;'>" + dsPrint.Tables[2].Rows[0]["SchoolShortName"].ToString().ToUpper() + "</td></tr><tr><td height='50' colspan='2' align='center' class='ph'> " + dsPrint.Tables[2].Rows[0]["Schoolstate"].ToString().ToUpper() + "-" + dsPrint.Tables[2].Rows[0]["SchoolZip"].ToString() + " PHONE NO-" + dsPrint.Tables[2].Rows[0]["phoneno"].ToString().ToUpper() + "</td></tr><tr><td height='50' colspan='2' align='center' class='billcont'><U>DELIVERY SLIP - BOOKS</U></td></tr><tr class='billcont'><td width='55%' height='50'>Ref. No. : " + dsPrint.Tables[0].Rows[0]["BillNo"].ToString() + "</td><td width='45%' style='padding-right:10px;' align='right'>Date : " + dsPrint.Tables[0].Rows[0]["BillDate"].ToString() + "</td></tr><tr class='billcont'><td height='50'>Reg No. : " + dsPrint.Tables[0].Rows[0]["RegNo"].ToString() + "</td><td height='50' style='padding-right:10px;' align='right'>Class &amp;Sec : " + dsPrint.Tables[0].Rows[0]["classname"].ToString() + "  " + dsPrint.Tables[0].Rows[0]["sectionname"].ToString() + " </td></tr><tr class='billcont'><td height='50'>Name : " + dsPrint.Tables[0].Rows[0]["stname"].ToString() + "</td><td style='padding-right:10px;' align='right'>Gender : " + dsPrint.Tables[0].Rows[0]["Sex"].ToString().ToUpper() + "</td></tr><tr class='billcont'><td colspan='2' align='center' valign='top' class='barcodeimage'><img style='max-width:inherit;' width='201' src= '../Students/Barcodes/" + dsPrint.Tables[0].Rows[0]["RegNo"].ToString() + ".JPG' /></td></tr><tr><td colspan='2'>&nbsp;</td></tr><tr class='billcont'><td colspan='2' style='border-top: 1px solid #000;border-bottom: 1px solid #000;'><br/> &nbsp;Cashier : " + dsPrint.Tables[0].Rows[0]["staffname"].ToString() + "<br/><br/></td></tr><tr class='billcont'><td colspan='2' style='border-bottom: 1px solid #000;'><div align='center'><br/> Delivery Details<br/><br/></div></td></tr><tr><td colspan='2' >&nbsp;</td></tr><tr class='billcont'><td colspan='2'>&nbsp;Date : <br/><br/></td></tr><tr class='billcont'><td colspan='2'>Issued By :<br/><br/><br/></td></tr></table></td><td width='300' valign='top' style='padding-left:5px;padding-right:0px;'><table width='300' border='0' align='right' cellpadding='3' cellspacing='0'><tr><td height='10' colspan='2' align='center' class='billcont' ></td></tr><tr><td height='50' colspan='2' align='center' class='billcont' style='border-bottom: 1px solid #000;margin-left:20px;margin-right:20px;' >" + dsPrint.Tables[2].Rows[0]["SchoolShortName"].ToString().ToUpper() + "</td></tr><tr><td height='50' colspan='2' align='center' class='ph'> " + dsPrint.Tables[2].Rows[0]["Schoolstate"].ToString().ToUpper() + "-" + dsPrint.Tables[2].Rows[0]["SchoolZip"].ToString() + " PHONE NO-" + dsPrint.Tables[2].Rows[0]["phoneno"].ToString().ToUpper() + "</td></tr><tr><td height='50' class='billcont' align='center' colspan='2'><U>DELIVERY SLIP - UNIFORMS</U></td></tr><tr class='billcont'><td width='55%' height='50'>Ref. No. : " + dsPrint.Tables[0].Rows[0]["BillNo"].ToString() + "</td><td width='45%'style='padding-right:10px;' align='right'>Date : " + dsPrint.Tables[0].Rows[0]["BillDate"].ToString() + "</td></tr><tr class='billcont'><td height='50'>Reg No. : " + dsPrint.Tables[0].Rows[0]["RegNo"].ToString() + "</td><td height='50' style='padding-right:10px;' align='right'>Class &amp;Sec : " + dsPrint.Tables[0].Rows[0]["classname"].ToString() + "  " + dsPrint.Tables[0].Rows[0]["sectionname"].ToString() + " </td></tr><tr class='billcont'><td height='50'>Name : " + dsPrint.Tables[0].Rows[0]["stname"].ToString() + "</td><td style='padding-right:10px;' align='right'>Gender : " + dsPrint.Tables[0].Rows[0]["Sex"].ToString().ToUpper() + "</td></tr><tr class='billcont'><td colspan='2' align='center' valign='top' class='barcodeimage'><img style='max-width:inherit;' width='201' src= '../Students/Barcodes/" + dsPrint.Tables[0].Rows[0]["RegNo"].ToString() + ".JPG' /></td></tr><tr class='billcont'><td colspan='2' style='border-top: 1px solid #000;border-bottom: 1px solid #000;'><br/> Cashier : " + dsPrint.Tables[0].Rows[0]["staffname"].ToString() + "<br/><br/></td></tr><tr class='billcont'><td colspan='2' style='border-bottom: 1px solid #000;'><div align='center'><br/> Delivery Details<br/><br/></div></td></tr><tr><td colspan='2' >&nbsp;</td></tr><tr class='billcont'><td colspan='2'>&nbsp;Date : <br/><br/></td></tr><tr class='billcont'><td colspan='2'>Issued By :<br/><br/><br/></td></tr></table></td></tr></table>");

                        sqlstr = "select isnull(count(b.TaxBillID),0) from f_studenttaxbillmaster a inner join f_studenttaxbills b on a.TaxBillID=b.TaxBillID where BillID='" + billId + "' and a.isactive=1";
                        string ibillcnt = utl.ExecuteScalar(sqlstr);
                        if (ibillcnt == "0")
                        {
                            sqlstr = " select* from f_studentbills where billID='" + billId + "'";
                            DataTable dtbill = new DataTable();
                            dtbill = utl.GetDataTable(sqlstr);
                            if (dtbill != null && dtbill.Rows.Count > 0)
                            {
                                for (int i = 0; i < dtbill.Rows.Count; i++)
                                {
                                    string classID = utl.ExecuteScalar("select class from s_studentinfo where regno = '" + dsPrint.Tables[1].Rows[0]["RegNo"].ToString() + "'");

                                    string headID = utl.ExecuteScalar("select feesheadid from m_feescategoryhead where FeesCatHeadID='" + dtbill.Rows[i]["FeesCatHeadId"] + "' and academicID='" + HttpContext.Current.Session["AcademicID"] + "' and ClassID='" + classID + "' and feescategoryID='" + dsPrint.Tables[3].Rows[0]["FeesCategoryID"].ToString() + "' and formonth like '%" + dsPrint.Tables[1].Rows[0]["BillMonth"].ToString() + "%'");

                                    DataTable dttax = new DataTable();
                                    dttax = utl.GetDataTable("select a.* from m_tax a  where a.isactive=1 and a.academicid='" + HttpContext.Current.Session["AcademicID"] + "' and a.feeheadid='" + headID + "'");
                                    if (dttax.Rows.Count > 0)
                                    {
                                        decimal taxvalue = Convert.ToDecimal(dtbill.Rows[i]["Amount"]) / (100 + Convert.ToDecimal(dttax.Rows[0]["Percentage"].ToString())) * Convert.ToDecimal(dttax.Rows[0]["Percentage"].ToString());

                                        string taxQuery = "insert into f_studenttaxbills(TaxBillID,FeesCatId,TaxID,TaxPercent,TaxAmount,isactive,userid)values('" + dsPrint.Tables[3].Rows[0]["TaxBillID"].ToString().Trim() + "','" + dtbill.Rows[i]["FeesCatHeadId"].ToString().Trim() + "','" + dttax.Rows[0]["TaxID"].ToString().Trim() + "','" + dttax.Rows[0]["Percentage"].ToString().Trim() + "','" + taxvalue + "','true','" + dsPrint.Tables[1].Rows[0]["UserId"].ToString().Trim() + "')";
                                        utl.ExecuteQuery(taxQuery);
                                    }
                                }
                            }

                        }

                        str.Append("<table width='100%' border='0' align='center' cellpadding='0' cellspacing='0' class='break-after'><tr class='billcont'><table width='100%' border='0' align='center' cellpadding='0' cellspacing='0'><br/><tr class='billcont'><td height='30'>Hail Mary!</td><td style='text-align:right;' height='30'>Praise the Lord!</td></tr><tr class='billcont'><td height='5'></td><td height='5'></td></tr><tr class='billcont'><td style='text-align:center;font-size: 18px;' colspan='2' height='25'>" + dsPrint.Tables[2].Rows[0]["SchoolShortName"].ToString().ToUpper() + "</td></tr><tr class='billcont'><td style='text-align:center;' colspan='2' height='25'> (A unit of Amalorpavam Educational Welfare Society)</td></tr><tr class='billcont'><td style='text-align:center;' colspan='2' height='25'> " + dsPrint.Tables[2].Rows[0]["SchoolAddress"].ToString().ToUpper() + ", " + dsPrint.Tables[2].Rows[0]["SchoolCity"].ToString().ToUpper() + ", " + dsPrint.Tables[2].Rows[0]["SchoolDist"].ToString().ToUpper() + "</td></tr><tr class='billcont'><td style='text-align:center;' colspan='2' height='25'><b>GSTIN : </b>" + dsPrint.Tables[2].Rows[0]["GSTIN"].ToString().ToUpper() + "</td></tr><br/><br/><br/><tr class='billcont'><td height='25'>BILL No.: " + dsPrint.Tables[3].Rows[0]["TaxBillNo"].ToString().ToUpper() + "</td><td style='padding-left:500px;' height='25'>Ref. No .: " + dsPrint.Tables[3].Rows[0]["BillNo"].ToString().ToUpper() + "</td></tr><tr class='billcont'><td height='25'>Regn. No.: " + dsPrint.Tables[3].Rows[0]["RegNo"].ToString().ToUpper() + "</td><td style='padding-left:500px;' height='25'>Class & Sec. : " + dsPrint.Tables[3].Rows[0]["ClassName"].ToString().ToUpper() + " " + dsPrint.Tables[3].Rows[0]["SectionName"].ToString().ToUpper() + "</td></tr><tr class='billcont'><td height='25'>Student Name : " + dsPrint.Tables[3].Rows[0]["StName"].ToString().ToUpper() + " </td><td style='padding-left:500px;' height='25'>State Code : 34</td></tr><tr class='billcont'><td height='5'></td><td height='5'></td></tr></table><table width='100%' border='0' align='center' cellpadding='0' cellspacing='0' style='border:1px solid #000;'><tr class='billcont'><th style='border-bottom: 1px solid #000;border-right: 1px solid #000;' height='25'>SL. NO.</th><th style='border-bottom: 1px solid #000;border-right: 1px solid #000;' height='25'>DESCRIPTION OF GOODS</th><th style='border-bottom: 1px solid #000;border-right: 1px solid #000;' height='25'>QTY</th><th style='border-bottom: 1px solid #000;border-right: 1px solid #000;' height='25'>RATE</th><th style='border-bottom: 1px solid #000;border-right: 1px solid #000;' height='25'>TAXABLE VALUE</th><th style='border-bottom: 1px solid #000;border-right: 1px solid #000;' height='25'>GST%</th><th style='border-bottom: 1px solid #000;border-right: 1px solid #000;' height='25'>GST% AMOUNT</th><th style='border-bottom: 1px solid #000;border-right: 1px solid #000;' height='25'>SGST</th><th style='border-bottom: 1px solid #000;border-right: 1px solid #000;' height='25'>CGST</th><th style='border-bottom: 1px solid #000;'>AMOUNT</th></tr> ");

                        decimal total = 0;

                        for (int i = 0; i < dsPrint.Tables[4].Rows.Count; i++)
                        {
                            total += Math.Round(Convert.ToDecimal(dsPrint.Tables[4].Rows[i]["Amount"]));

                            str.Append(" <tr class=' billcont' style='text-align:center;'><td height='25' style='border-bottom: 1px solid #000;border-right: 1px solid #000;'> " + (i + 1).ToString() + " </td><td height='25' style='text-align:left;border-bottom: 1px solid #000;border-right: 1px solid #000;'>  " + dsPrint.Tables[4].Rows[i]["FeesHeadName"].ToString().ToUpper() + "</td><td height='25' style='border-bottom: 1px solid #000;border-right: 1px solid #000;'>  " + dsPrint.Tables[4].Rows[i]["qty"].ToString().ToUpper() + "</td><td height='25' style='border-bottom: 1px solid #000;border-right: 1px solid #000;'>  " + dsPrint.Tables[4].Rows[i]["extax"].ToString().ToUpper() + "</td><td height='25' style='border-bottom: 1px solid #000;border-right: 1px solid #000;'>  " + (Convert.ToDecimal(dsPrint.Tables[4].Rows[i]["qty"]) * Convert.ToDecimal(dsPrint.Tables[4].Rows[i]["extax"])).ToString().ToUpper() + "</td><td height='25' style='border-bottom: 1px solid #000;border-right: 1px solid #000;'> " + dsPrint.Tables[4].Rows[i]["TaxPercent"].ToString().ToUpper() + "</td><td height='25' style='border-bottom: 1px solid #000;border-right: 1px solid #000;'>  " + dsPrint.Tables[4].Rows[i]["TaxAmount"].ToString().ToUpper() + "</td><td height='25' style='border-bottom: 1px solid #000;border-right: 1px solid #000;'>  " + dsPrint.Tables[4].Rows[i]["cgst"].ToString().ToUpper() + "</td><td height='25' style='border-bottom: 1px solid #000;border-right: 1px solid #000;'>  " + dsPrint.Tables[4].Rows[i]["cgst"].ToString().ToUpper() + " </td><td height='25' style='border-bottom: 1px solid #000;border-right: 1px solid #000;text-align:right;padding-right: 10px;'>  " + Math.Round(Convert.ToDecimal(dsPrint.Tables[4].Rows[i]["Amount"].ToString().ToUpper())).ToString() + " </td></tr>");
                        }

                        string roundoff = utl.ExecuteScalar("select round(" + Math.Round(Convert.ToDecimal(total)).ToString() + ",-1)");

                        decimal roundval = Convert.ToDecimal(roundoff) - Math.Round(Convert.ToDecimal(total));
                        str.Append("<tr class='billcont'><td colspan='9' height='25' style='border-bottom: 1px solid #000;border-right: 1px solid #000;text-align:right;padding-right: 10px;'> SUB TOTAL</td><td height='25' style='border-bottom: 1px solid #000;text-align:right;padding-right: 10px;'> " + Math.Round(Convert.ToDecimal(total)) + "</td></tr><tr class='billcont'><td colspan='9' height='25' style='border-bottom: 1px solid #000;border-right: 1px solid #000;text-align:right;padding-right: 10px;'> ROUND OFF</td><td height='25' style='border-bottom: 1px solid #000;text-align:right;padding-right: 10px;'> " + Convert.ToDecimal(roundval).ToString() + "</td></tr><tr class='billcont'><td colspan='9' height='25' style='border-right: 1px solid #000;text-align:right;padding-right: 10px;'> TOTAL</td><td height='25' style='text-align:right;padding-right: 10px;'> " + roundoff.ToString().ToUpper() + "</td></tr></table><table width='100%' border='0' align='center' cellpadding='0' cellspacing='0'><tr class='billcont'><td height='5'></td><td height='5'></td></tr><tr class='billcont'><td colspan='2' height='10'>Amount in words :  " + utl.retWord(Math.Round(Convert.ToDecimal(roundoff.ToString().ToUpper()))) + " Only</td></tr><tr class='billcont'><td height='50'>Date : " + dsPrint.Tables[3].Rows[0]["BillDate"].ToString() + "</td><td height='50' style='text-align:right;'><strong>Cashier</strong></td></tr></table></tr></table>");

                    }

                    strPrintContent = str.ToString();
                }
            }
            else
            {
                query = "[sp_GetOldStudentBill] " + billId + ",'" + HttpContext.Current.Session["AcademicID"] + "'";

                DataSet dsPrint = utl.GetDataset(query);
                int yPos = 0;
                int headCount = 0;
                string printerName = ConfigurationManager.AppSettings["JuneFeesPrinter"];

                clientIPAddress = HttpContext.Current.Request.ServerVariables["remote_addr"];

                if (dsPrint.Tables.Count > 1)
                {

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

                    if (dsPrint.Tables[0].Rows.Count > 0)
                    {
                        str.Append("<table width='100%' border='0' align='center' cellpadding='0' cellspacing='0' style=' border:1px dashed #000000;' class='billcont'><tr><td width='380' style='padding-left:5px;padding-right:5px;'><table width='300' border='0' cellspacing='0' cellpadding='3'><tr><td height='10' colspan='2' align='center' class='billcont' ></td></tr><tr><td height='30' colspan='2' align='center' class='billcont' style='border-bottom: 1px solid #000;margin-left:20px;margin-right:20px;' >" + dsPrint.Tables[2].Rows[0]["SchoolShortName"].ToString().ToUpper() + "</td></tr><tr><td height='30' colspan='2' align='center' class='ph'> " + dsPrint.Tables[2].Rows[0]["Schoolstate"].ToString().ToUpper() + "-" + dsPrint.Tables[2].Rows[0]["SchoolZip"].ToString() + " PHONE NO-" + dsPrint.Tables[2].Rows[0]["phoneno"].ToString().ToUpper() + "</td></tr><tr class='billcont'><td width='52%' height='40'>&nbsp;Reg. No. : " + dsPrint.Tables[0].Rows[0]["RegNo"].ToString() + "</td><td width='48%'><div style='float:right;'>Rec. No. : " + dsPrint.Tables[0].Rows[0]["BillNo"].ToString() + "</div></td></tr><tr class='billcont'><td height='40' colspan='2'>Name : " + dsPrint.Tables[0].Rows[0]["stname"].ToString() + "</td></tr><tr class='billcont'><td width='52%' height='40'>Class &amp;Sec : " + dsPrint.Tables[0].Rows[0]["classname"].ToString() + "  " + dsPrint.Tables[0].Rows[0]["sectionname"].ToString() + " </td><td><div style='float:right;'>Month : " + dsPrint.Tables[0].Rows[0]["BillMonth"].ToString() + "</div></td></tr><tr><td height='10' colspan='2'></td></tr><tr><td colspan='2'><table width='100%' border='0' align='center' cellpadding='3' cellspacing='0' class='particulars' style='border:1px solid #000;'><tr class='billcont'><td width='75%' height='25' style='border-bottom: 1px solid #000;border-right: 1px solid #000;'><div align='center'>PARTICULARS</div></td><td width='30%' style='border-bottom: 1px solid #000;'><div align='center'>AMOUNT</div></td></tr>");
                        for (int i = 0; i < dsPrint.Tables[1].Rows.Count; i++)
                        {
                            str.Append(" <tr class='billcont'><td height='25' style='border-right:1px solid #000;'>" + dsPrint.Tables[1].Rows[i]["FeesHeadName"].ToString() + "</td><td><div align='center'> " + dsPrint.Tables[1].Rows[i]["Amount"].ToString() + " </div></td></tr> ");
                        }

                        str.Append("<tr class='billcont'><td height='45' style='border-top: 1px solid #000;border-right: 1px solid #000;'>TOTAL</td><td style='border-top:1px solid #000;'><div align='center'>" + dsPrint.Tables[0].Rows[0]["TotalAmount"].ToString() + "</div></td></tr></table></td></tr><tr ><td colspan='2' class='billcont'>&nbsp;Date : " + dsPrint.Tables[0].Rows[0]["BillDate"].ToString() + "<br/><br/></td></tr><tr><td colspan='2' class='billcont'>Cashier : " + dsPrint.Tables[0].Rows[0]["staffname"].ToString() + "<br/><br/><br/><br/></td></tr></table></td><td width='300' valign='top' style='padding-left:5px;padding-right:5px;border-left: 1px dashed #000000;border-right: 1px dashed #000000;'><table width='300' border='0' align='center' cellpadding='3' cellspacing='0'><tr><td height='10' colspan='2' align='center' class='billcont' ></td></tr><tr><td height='50' colspan='2' align='center' class='billcont' style='border-bottom: 1px solid #000;margin-left:20px;margin-right:20px;'>" + dsPrint.Tables[2].Rows[0]["SchoolShortName"].ToString().ToUpper() + "</td></tr><tr><td height='50' colspan='2' align='center' class='ph'> " + dsPrint.Tables[2].Rows[0]["Schoolstate"].ToString().ToUpper() + "-" + dsPrint.Tables[2].Rows[0]["SchoolZip"].ToString() + " PHONE NO-" + dsPrint.Tables[2].Rows[0]["phoneno"].ToString().ToUpper() + "</td></tr><tr><td height='50' colspan='2' align='center' class='billcont'><U>DELIVERY SLIP - BOOKS</U></td></tr><tr class='billcont'><td width='55%' height='50'>Ref. No. : " + dsPrint.Tables[0].Rows[0]["BillNo"].ToString() + "</td><td width='45%' style='padding-right:10px;' align='right'>Date : " + dsPrint.Tables[0].Rows[0]["BillDate"].ToString() + "</td></tr><tr class='billcont'><td height='50' colspan='2'>Reg No. : " + dsPrint.Tables[0].Rows[0]["RegNo"].ToString() + "</td></tr><tr class='billcont'><td height='50' colspan='2'>Name : " + dsPrint.Tables[0].Rows[0]["stname"].ToString() + "</td></tr><tr class='billcont'><td height='50'>Class &amp;Sec : " + dsPrint.Tables[0].Rows[0]["classname"].ToString() + "  " + dsPrint.Tables[0].Rows[0]["sectionname"].ToString() + " </td><td style='padding-right:10px;' align='right'>Gender : " + dsPrint.Tables[0].Rows[0]["Sex"].ToString().ToUpper() + "</td></tr><tr><td colspan='2'>&nbsp;</td></tr><tr class='billcont'><td colspan='2' style='border-top: 1px solid #000;border-bottom: 1px solid #000;'><br/> &nbsp;Cashier : " + dsPrint.Tables[0].Rows[0]["staffname"].ToString() + "<br/><br/></td></tr><tr class='billcont'><td colspan='2' style='border-bottom: 1px solid #000;'><div align='center'><br/> Delivery Details<br/><br/></div></td></tr><tr><td colspan='2' >&nbsp;</td></tr><tr class='billcont'><td colspan='2'>&nbsp;Date : <br/><br/></td></tr><tr class='billcont'><td colspan='2'>Issued By :<br/><br/><br/></td></tr></table></td><td width='300' valign='top' style='padding-left:5px;padding-right:0px;'><table width='300' border='0' align='right' cellpadding='3' cellspacing='0'><tr><td height='10' colspan='2' align='center' class='billcont' ></td></tr><tr><td height='50' colspan='2' align='center' class='billcont' style='border-bottom: 1px solid #000;margin-left:20px;margin-right:20px;' >" + dsPrint.Tables[2].Rows[0]["SchoolShortName"].ToString().ToUpper() + "</td></tr><tr><td height='50' colspan='2' align='center' class='ph'> " + dsPrint.Tables[2].Rows[0]["Schoolstate"].ToString().ToUpper() + "-" + dsPrint.Tables[2].Rows[0]["SchoolZip"].ToString() + " PHONE NO-" + dsPrint.Tables[2].Rows[0]["phoneno"].ToString().ToUpper() + "</td></tr><tr><td height='50' class='billcont' align='center' colspan='2'><U>DELIVERY SLIP - UNIFORMS</U></td></tr><tr class='billcont'><td width='55%' height='50'>Ref. No. : " + dsPrint.Tables[0].Rows[0]["BillNo"].ToString() + "</td><td width='45%'style='padding-right:10px;' align='right'>Date : " + dsPrint.Tables[0].Rows[0]["BillDate"].ToString() + "</td></tr><tr class='billcont'><td height='50' colspan='2'>Reg No. : " + dsPrint.Tables[0].Rows[0]["RegNo"].ToString() + "</td></tr><tr class='billcont'><td height='50' colspan='2'>Name : " + dsPrint.Tables[0].Rows[0]["stname"].ToString() + "</td></tr><tr class='billcont'><td height='50'>Class &amp;Sec : " + dsPrint.Tables[0].Rows[0]["classname"].ToString() + "  " + dsPrint.Tables[0].Rows[0]["sectionname"].ToString() + " </td><td style='padding-right:10px;' align='right'>Gender : " + dsPrint.Tables[0].Rows[0]["Sex"].ToString().ToUpper() + "</td></tr><tr><td colspan='2'>&nbsp;</td></tr><tr class='billcont'><td colspan='2' style='border-top: 1px solid #000;border-bottom: 1px solid #000;'><br/> Cashier : " + dsPrint.Tables[0].Rows[0]["staffname"].ToString() + "<br/><br/></td></tr><tr class='billcont'><td colspan='2' style='border-bottom: 1px solid #000;'><div align='center'><br/> Delivery Details<br/><br/></div></td></tr><tr><td colspan='2' >&nbsp;</td></tr><tr class='billcont'><td colspan='2'>&nbsp;Date : <br/><br/></td></tr><tr class='billcont'><td colspan='2'>Issued By :<br/><br/><br/></td></tr></table></td></tr></table>");

                    }

                    strPrintContent = str.ToString();

                }
            }
        }
        return strPrintContent;
    }

    public static void PrintBill(string billId)
    {
        try
        {
            PrintDocument fd = new PrintDocument();
            Utilities utl = new Utilities();
            string sqlstr = "select isactive from m_academicyear where AcademicID='" + HttpContext.Current.Session["AcademicID"].ToString() + "'";
            string Isactive = utl.ExecuteScalar(sqlstr);
            HttpContext.Current.Session["Isactive"] = Isactive.ToString();
            string query = "";
            DataSet dsStud = new DataSet();
            if (Isactive == "True")
            {
                query = "[sp_GetStudentBill] " + billId + "";
            }
            else
            {
                query = "[sp_GetOldStudentBill] " + billId + ",'" + HttpContext.Current.Session["AcademicID"] + "'";
            }

            DataSet dsPrint = utl.GetDataset(query);
            int yPos = 0;
            int headCount = 0;
            string printerName = ConfigurationManager.AppSettings["FeesPrinter"];
            string clientMachineName, clientIPAddress;
            //  clientMachineName = (Dns.GetHostEntry(Request.ServerVariables["remote_addr"]).HostName);
            clientIPAddress = HttpContext.Current.Request.ServerVariables["remote_addr"];

            if (dsPrint.Tables.Count > 1 && dsPrint.Tables[0].Rows.Count > 0)
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
                        args.Graphics.DrawString(dsPrint.Tables[2].Rows[0]["Schoolstate"].ToString().ToUpper() + "-" + dsPrint.Tables[2].Rows[0]["SchoolZip"].ToString() + " PHONE NO-" + dsPrint.Tables[2].Rows[0]["phoneno"].ToString().ToUpper(), new System.Drawing.Font("ARIAL", 8, FontStyle.Regular), Brushes.Black, new Rectangle(0, 20, 250, 25), stringAlignCenter);

                        args.Graphics.DrawLine(new Pen(Color.Black, 2), 0, 42, 500, 42);
                        args.Graphics.DrawString("Reg.No : " + dsPrint.Tables[0].Rows[0]["RegNo"].ToString(), new System.Drawing.Font("ARIAL", 9, FontStyle.Regular), Brushes.Black, new Rectangle(0, 45, 150, 50), stringAlignLeft);
                        args.Graphics.DrawString("Rec.No : " + dsPrint.Tables[0].Rows[0]["BillNo"].ToString(), new System.Drawing.Font("ARIAL", 9, FontStyle.Regular), Brushes.Black, new Rectangle(120, 45, 120, 50), stringAlignRight);
                        args.Graphics.DrawString("Name 	:  " + dsPrint.Tables[0].Rows[0]["stname"].ToString(), new System.Drawing.Font("ARIAL", 9, FontStyle.Regular), Brushes.Black, new Rectangle(0, 70, 250, 50), stringAlignLeft);
                        args.Graphics.DrawString("Class & Section : 	" + dsPrint.Tables[0].Rows[0]["classname"].ToString() + "  " + dsPrint.Tables[0].Rows[0]["sectionname"].ToString(), new System.Drawing.Font("ARIAL", 9, FontStyle.Regular), Brushes.Black, new Rectangle(0, 95, 150, 50), stringAlignLeft);
                        args.Graphics.DrawString(" Month 	: 	" + dsPrint.Tables[0].Rows[0]["BillMonth"].ToString(), new System.Drawing.Font("ARIAL", 9, FontStyle.Regular), Brushes.Black, new Rectangle(120, 95, 120, 50), stringAlignRight);
                        args.Graphics.DrawString("PARTICULARS", new System.Drawing.Font("ARIAL", 8, FontStyle.Regular), Brushes.Black, new Rectangle(0, 135, 180, 50), stringAlignCenter);
                        args.Graphics.DrawString("AMOUNT ", new System.Drawing.Font("ARIAL", 8, FontStyle.Regular), Brushes.Black, new Rectangle(180, 135, 70, 50), stringAlignCenter);
                        decimal totalConcessionAmount = 0;

                        if (dsPrint.Tables[1].Rows.Count > 0)
                        {
                            yPos = 158;

                            for (int i = 0; i < dsPrint.Tables[1].Rows.Count; i++, yPos += 25, headCount += 1)
                            {
                                string concessionAmount = dsPrint.Tables[1].Rows[i]["ConcessionAmount"].ToString();
                                decimal concessionVal;
                                if (decimal.TryParse(concessionAmount, out concessionVal))
                                {
                                    totalConcessionAmount += concessionVal;
                                }
                                args.Graphics.DrawString(dsPrint.Tables[1].Rows[i]["FeesHeadName"].ToString(), new System.Drawing.Font("ARIAL", 9, FontStyle.Regular), Brushes.Black, new Rectangle(5, yPos, 180, 50), stringAlignLeft);
                                // args.Graphics.DrawString(dsPrint.Tables[1].Rows[i]["Amount"].ToString(), new System.Drawing.Font("ARIAL", 9, FontStyle.Regular), Brushes.Black, new Rectangle(165, yPos, 70, 50), stringAlignRight);
                                args.Graphics.DrawString(dsPrint.Tables[1].Rows[i]["actualamount"].ToString(), new System.Drawing.Font("ARIAL", 9, FontStyle.Regular), Brushes.Black, new Rectangle(165, yPos, 70, 50), stringAlignRight);

                            }
                        }

                        int tableHeight = 25 * headCount;

                        if (totalConcessionAmount > 0)
                        {
                            yPos += 25;
                            tableHeight += 25;
                            // Draw border around Concession row
                            Pen penConcession = new Pen(Color.Black, 1);
                            penConcession.DashStyle = System.Drawing.Drawing2D.DashStyle.Dot;
                            args.Graphics.DrawRectangle(penConcession, 0, yPos, 180, 25);
                            args.Graphics.DrawRectangle(penConcession, 180, yPos, 68, 25);

                            args.Graphics.DrawString("Concession Granted", new Font("ARIAL", 9, FontStyle.Regular), Brushes.Black, new Rectangle(0, yPos, 180, 25), stringAlignLeft);
                            args.Graphics.DrawString(totalConcessionAmount.ToString("0.00"), new Font("ARIAL", 9, FontStyle.Regular), Brushes.Black, new Rectangle(165, yPos, 70, 25), stringAlignRight);
                            yPos += 14;
                        }
                        tableHeight += 35;

                        args.Graphics.DrawString("TOTAL", new System.Drawing.Font("ARIAL", 9, FontStyle.Regular), Brushes.Black, new Rectangle(0, yPos, 180, 50), stringAlignRight);
                        args.Graphics.DrawString(dsPrint.Tables[0].Rows[0]["TotalAmount"].ToString(), new System.Drawing.Font("ARIAL", 9, FontStyle.Regular), Brushes.Black, new Rectangle(165, yPos, 70, 50), stringAlignRight);

                        // args.Graphics.DrawString("TOTAL", new System.Drawing.Font("ARIAL", 9, FontStyle.Regular), Brushes.Black, new Rectangle(0, yPos + 8, 180, 50), stringAlignRight);
                        // args.Graphics.DrawString(dsPrint.Tables[0].Rows[0]["TotalAmount"].ToString(), new System.Drawing.Font("ARIAL", 9, FontStyle.Regular), Brushes.Black, new Rectangle(165, yPos + 8, 70, 50), stringAlignRight);


                        args.Graphics.DrawString("Date : " + dsPrint.Tables[0].Rows[0]["BillDate"].ToString(), new System.Drawing.Font("ARIAL", 9, FontStyle.Regular), Brushes.Black, new Rectangle(0, yPos + 40, 250, 50), stringAlignLeft);
                        args.Graphics.DrawString("Cashier : " + dsPrint.Tables[0].Rows[0]["staffname"].ToString(), new System.Drawing.Font("ARIAL", 9, FontStyle.Regular), Brushes.Black, new Rectangle(0, yPos + 40, 250, 150), stringAlignLeft);

                        //args.Graphics.DrawRectangle(new Pen(Color.Black, 1), 0, 145, 180, 25);
                        //args.Graphics.DrawRectangle(new Pen(Color.Black, 1), 180, 145, 68, 25);

                        //Pen pen = new Pen(Color.Black, 1);
                        //pen.DashStyle = System.Drawing.Drawing2D.DashStyle.Dot;
                        //args.Graphics.DrawRectangle(pen, 0, 145, 180, 25);

                        //Pen pen0 = new Pen(Color.Black, 1);
                        //pen0.DashStyle = System.Drawing.Drawing2D.DashStyle.Dot;
                        //args.Graphics.DrawRectangle(pen0, 180, 145, 68, 25);

                        //Pen pen1 = new Pen(Color.Black, 1);
                        //pen1.DashStyle = System.Drawing.Drawing2D.DashStyle.Dot;
                        //args.Graphics.DrawRectangle(pen1, 0, 170, 180, 25 * headCount);

                        //Pen pen2 = new Pen(Color.Black, 1);
                        //pen2.DashStyle = System.Drawing.Drawing2D.DashStyle.Dot;
                        //args.Graphics.DrawRectangle(pen2, 180, 170, 68, 25 * headCount);

                        //Pen pen3 = new Pen(Color.Black, 1);
                        //pen3.DashStyle = System.Drawing.Drawing2D.DashStyle.Dot;
                        //args.Graphics.DrawRectangle(pen3, 0, yPos + 12, 180, 35);

                        //Pen pen4 = new Pen(Color.Black, 1);
                        //pen4.DashStyle = System.Drawing.Drawing2D.DashStyle.Dot;
                        //args.Graphics.DrawRectangle(pen4, 180, yPos + 12, 68, 35);

                        Pen tablePen = new Pen(Color.Black, 1);
                        tablePen.DashStyle = System.Drawing.Drawing2D.DashStyle.Dot;

                        args.Graphics.DrawRectangle(tablePen, 0, 145, 180, 25);
                        args.Graphics.DrawRectangle(tablePen, 180, 145, 68, 25);

                        args.Graphics.DrawRectangle(tablePen, 0, 170, 180, tableHeight);
                        args.Graphics.DrawRectangle(tablePen, 180, 170, 68, tableHeight);

                        args.Graphics.DrawLine(tablePen, 180, 145, 180, 170 + tableHeight);



                        //args.Graphics.DrawRectangle(new Pen(Color.Black, 1), 0, 170, 180, 25 * headCount);
                        //args.Graphics.DrawRectangle(new Pen(Color.Black, 1), 180, 170, 68, 25 * headCount);

                        //args.Graphics.DrawRectangle(new Pen(Color.Black, 1), 0, yPos + 12, 180, 35);
                        //args.Graphics.DrawRectangle(new Pen(Color.Black, 1), 180, yPos + 12, 68, 35);
                    }

                };
                // clientIPAddress = "192.168.0.48";
                //commentit
                clientIPAddress = "192.168.0.102";
                fd.PrinterSettings.PrinterName = "\\\\" + clientIPAddress + "\\" + printerName + "";
                fd.Print();
            }
            fd.Dispose();
        }
        catch (Exception err)
        {
        }
    }

    [WebMethod]
    public static string DeleteBill(string billId)
    {
        Utilities utl = new Utilities();
        string query = "[SP_DeleteSportsBill] " + billId + "";
        string strError = string.Empty;
        strError = utl.ExecuteQuery(query);
        return strError;
    }
}