using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Web.Services;

public partial class Students_ViewAdmissionWithdrawal : System.Web.UI.Page
{
    public string _StudCourceHistory = "";

    protected void Page_Load(object sender, EventArgs e)
    {
        Master.chkUser();

        string regNo = string.Empty;
        if (Request.QueryString["regno"] != null)
        {
            regNo = Request.QueryString["regno"].ToString();
            hdnRegNo.Value = regNo;
            GetInfo(regNo);
        }
    }
    private void GetInfo(string id)
    {
        Utilities utl = new Utilities();
        string query = "[sp_GetAdmissionWithdrawalInfo] " + id + "";
        DataSet ds = new DataSet();
        ds = utl.GetDataset(query);
        if (ds != null && ds.Tables[0].Rows.Count > 0)
        {
            if (ds.Tables[0].Rows[0]["RegNo"] != null)
                txtRegNo.Text = ds.Tables[0].Rows[0]["RegNo"].ToString();

            if (ds.Tables[0].Rows[0]["StudentName"] != null)
                txtName.Text = ds.Tables[0].Rows[0]["StudentName"].ToString();

            if (ds.Tables[0].Rows[0]["Sex"] != null)
                txtSex.Text = ds.Tables[0].Rows[0]["Sex"].ToString();

            if (ds.Tables[0].Rows[0]["FName"] != null)
                txtFatherName.Text = ds.Tables[0].Rows[0]["FName"].ToString();

            if (ds.Tables[0].Rows[0]["FOcc"] != null && ds.Tables[0].Rows[0]["FOcc"].ToString() != "0")
                txtFOccupation.Text = ds.Tables[0].Rows[0]["FOcc"].ToString();

            if (ds.Tables[0].Rows[0]["MName"] != null)
                txtMotherName.Text = ds.Tables[0].Rows[0]["MName"].ToString();

            if (ds.Tables[0].Rows[0]["MOcc"] != null && ds.Tables[0].Rows[0]["MOcc"].ToString() != "0")
                txtMOccupation.Text = ds.Tables[0].Rows[0]["MOcc"].ToString();

            if (ds.Tables[0].Rows[0]["GName"] != null)
                txtGaurdian.Text = ds.Tables[0].Rows[0]["GName"].ToString();

            if (ds.Tables[0].Rows[0]["GOcc"] != null)
                txtGOccupation.Text = ds.Tables[0].Rows[0]["GOcc"].ToString();

            if (ds.Tables[0].Rows[0]["DOB"] != null)
                txtStudDOB.Text = ds.Tables[0].Rows[0]["DOB"].ToString();

            if (ds.Tables[0].Rows[0]["DOA"] != null)
                txtStudDOA.Text = ds.Tables[0].Rows[0]["DOA"].ToString();

            if (ds.Tables[0].Rows[0]["CasteComm"] != null)
                txtCommCaste.Text = ds.Tables[0].Rows[0]["CasteComm"].ToString();

            if (ds.Tables[0].Rows[0]["NationReligion"] != null)
                txtNatReligion.Text = ds.Tables[0].Rows[0]["NationReligion"].ToString();

            if (ds.Tables[0].Rows[0]["MotherTongue"] != null && ds.Tables[0].Rows[0]["MotherTongue"].ToString() != "0")
                txtMotherTongue.Text = ds.Tables[0].Rows[0]["MotherTongue"].ToString();

            if (ds.Tables[0].Rows[0]["OldSchoolClass"] != null)
                txtSchClassLast.Text = ds.Tables[0].Rows[0]["OldSchoolClass"].ToString();

            if (ds.Tables[0].Rows[0]["Adclass"] != null)
                txtAdClass.Text = ds.Tables[0].Rows[0]["Adclass"].ToString();

            if (ds.Tables[0].Rows[0]["Address"] != null)
                txtAddress.Text = ds.Tables[0].Rows[0]["Address"].ToString();

            if (ds.Tables[0].Rows[0]["Phone"] != null)
                txtPhNo.Text = ds.Tables[0].Rows[0]["Phone"].ToString();

            if (ds.Tables[0].Rows[0]["LeaveOfStudy"] != null)
                txtstudyLeave.Text = ds.Tables[0].Rows[0]["LeaveOfStudy"].ToString();

            if (ds.Tables[0].Rows[0]["TcSlNo"] != null && ds.Tables[0].Rows[0]["TcSlNo"].ToString() != string.Empty)
                txtTcDate.Text = ds.Tables[0].Rows[0]["TcSlNo"].ToString() + " & ";
            else
                txtTcDate.Text = "- & ";

            if (ds.Tables[0].Rows[0]["TcDate"] != null && ds.Tables[0].Rows[0]["TcDate"].ToString() != string.Empty)
                txtTcDate.Text += ds.Tables[0].Rows[0]["TcDate"].ToString();
            else
                txtTcDate.Text += " - ";

            if (ds.Tables[0].Rows[0]["Reason"] != null)
                txtReason.Text = ds.Tables[0].Rows[0]["Reason"].ToString();

            if (ds.Tables[0].Rows[0]["Remarks"] != null)
                txtRemarks.Text = ds.Tables[0].Rows[0]["Remarks"].ToString();

            if (ds.Tables[0].Rows[0]["PhotoFile"] != null && !string.IsNullOrEmpty(ds.Tables[0].Rows[0]["PhotoFile"].ToString()))
                imgSrc.Src = "../Students/Photos/" + ds.Tables[0].Rows[0]["PhotoFile"].ToString();
            else
                imgSrc.Src = "../img/photo.jpg";
        }
    }
    [WebMethod]

    public static string Save(string regNo, string AcademicId, string reason, string remarks,
        string UserId)
    {
        Utilities utl = new Utilities();

        string strQryStatus = utl.ExecuteScalar("IsTcStudentExists " + regNo + "");

        if (strQryStatus == "1")
        {
            string sqlstr = "SP_InsertAdmissionWithdrawal  " + regNo + "," + AcademicId + ",'" + reason + "','" + remarks + "'," + UserId + "";
            string strQueryStatus = utl.ExecuteScalar(sqlstr);
            if (strQueryStatus == string.Empty)
                return "";
            else
                return strQueryStatus;
        }
        else
            return "No";
    }
    [WebMethod]
    public static string GetSerialNo()
    {
        Utilities utl = new Utilities();
        string query = "Select isnull(Max(AdmissionId)+ 1,1)as  SerialNo from s_AdmissionWithDrawal";
        return utl.GetDatasetTable(query, "SCIDs").GetXml();

    }


}