using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Web.Services;

public partial class Students_ViewStudyCertificate : System.Web.UI.Page
{
    public string _StudCourceHistory = "";

    protected void Page_Load(object sender, EventArgs e)
    {
        Master.chkUser();
        GetConducts();
        string regNo = string.Empty;
        if (Request.QueryString["regno"] != null)
        {
            regNo = Request.QueryString["regno"].ToString();
            hdnRegNo.Value = regNo;
            string acdid = string.Empty;
            if (Session["AcademicID"] != null)
                acdid = Session["AcademicID"].ToString();
            string sRegNo = GetInfo(regNo, acdid);
            BindCourseStudy(sRegNo);
        }
        lblDate.Text = DateTime.Now.ToString("dd/MM/yyyy");
    }
    private string GetInfo(string id, string acdid)
    {
        Utilities utl = new Utilities();

        string sqlstr = "select isactive from m_academicyear where AcademicID='" + HttpContext.Current.Session["AcademicID"].ToString() + "'";
        string Isactive = utl.ExecuteScalar(sqlstr);
        string query = "";
        if (Isactive == "True")
        {
           query = "[sp_GetStudentStudyInfo] " + id + "," + acdid + "";
        }
        else
        {
           query = "[sp_GetOldStudentStudyInfo] " + id + "," + acdid + "";
        }

        DataSet ds = new DataSet();
        string sRegNo = string.Empty;
        ds = utl.GetDataset(query);
        if (ds != null && ds.Tables[0].Rows.Count > 0)
        {
            if (ds.Tables[0].Rows[0]["RegNo"] != null && ds.Tables[0].Rows[0]["RegNo"] != "")
                sRegNo = ds.Tables[0].Rows[0]["RegNo"].ToString().ToUpper();
            if (ds.Tables[0].Rows[0]["AcdYear"] != null && ds.Tables[0].Rows[0]["AcdYear"] != "")
                lblAcdYear.Text = ds.Tables[0].Rows[0]["AcdYear"].ToString().ToUpper();
            if (ds.Tables[0].Rows[0]["StudentName"] != null && ds.Tables[0].Rows[0]["StudentName"] != "")
                lblName.Text = ds.Tables[0].Rows[0]["StudentName"].ToString().ToUpper();
            if (ds.Tables[0].Rows[0]["AdmissionNo"] != null && ds.Tables[0].Rows[0]["AdmissionNo"] != "")
                txtAdminNo.Text = ds.Tables[0].Rows[0]["AdmissionNo"].ToString().ToUpper();
            if (ds.Tables[0].Rows[0]["Parent"] != null && ds.Tables[0].Rows[0]["Parent"] != "")
                txtParentName.Text = ds.Tables[0].Rows[0]["Parent"].ToString().ToUpper();
            if (ds.Tables[0].Rows[0]["DOB"] != null && ds.Tables[0].Rows[0]["DOB"] != "")
                txtStudDOB.Text = ds.Tables[0].Rows[0]["DOB"].ToString().ToUpper();
            if (ds.Tables[0].Rows[0]["Class"] != null && ds.Tables[0].Rows[0]["Class"] != "")
                txtClass.Text = ds.Tables[0].Rows[0]["Class"].ToString().ToUpper();
            if (ds.Tables[0].Rows[0]["Nationality"] != null && ds.Tables[0].Rows[0]["Nationality"] != "")
                txtNationality.Text = ds.Tables[0].Rows[0]["Nationality"].ToString().ToUpper();
            if (ds.Tables[0].Rows[0]["Religion"] != null && ds.Tables[0].Rows[0]["Religion"] != "")
                txtReligion.Text = ds.Tables[0].Rows[0]["Religion"].ToString().ToUpper();
            if (ds.Tables[0].Rows[0]["CasteComm"] != null && ds.Tables[0].Rows[0]["CasteComm"] != "")
                txtCasteComm.Text = ds.Tables[0].Rows[0]["CasteComm"].ToString();
            if (ds.Tables[0].Rows[0]["SubStudyPart1"] != null && ds.Tables[0].Rows[0]["SubStudyPart1"] != "")
                txtStudyP1.Text = ds.Tables[0].Rows[0]["SubStudyPart1"].ToString();
            if (ds.Tables[0].Rows[0]["SubStudyPart2"] != null && ds.Tables[0].Rows[0]["SubStudyPart2"] != "")
                txtStudyP2.Text = ds.Tables[0].Rows[0]["SubStudyPart2"].ToString();
            if (ds.Tables[0].Rows[0]["SubStudyPart3"] != null && ds.Tables[0].Rows[0]["SubStudyPart3"] != "")
                txtStudyP3.Text = ds.Tables[0].Rows[0]["SubStudyPart3"].ToString();
            if (ds.Tables[0].Rows[0]["Conduct"] != null && ds.Tables[0].Rows[0]["Conduct"] != "")
                ddLConduct.Text = ds.Tables[0].Rows[0]["Conduct"].ToString();
            if (ds.Tables[0].Rows[0]["Purpose"] != null && ds.Tables[0].Rows[0]["Purpose"] != "")
                txtPurpose.Text = ds.Tables[0].Rows[0]["Purpose"].ToString();
            if (ds.Tables[0].Rows[0]["Photo"] != null && !string.IsNullOrEmpty(ds.Tables[0].Rows[0]["Photo"].ToString()))
            {
               imgSrc.Src = ds.Tables[0].Rows[0]["Photo"].ToString();               
                     
            }
            else
            {
                imgSrc.Src = this.ResolveUrl(Server.MapPath("Photos/noimage.jpg"));

            }
                    
        }

        return sRegNo;
    }

    private void GetConducts()
    {
        Utilities utl = new Utilities();
        string sqlstr = "select conductid,ltrim(rtrim(conductname)) as conductname from m_conducts";
        DataTable dt = new DataTable();
        dt = utl.GetDataTable(sqlstr);

        if (dt != null && dt.Rows.Count > 0)
        {
            ddLConduct.DataSource = dt;
            ddLConduct.DataTextField = "ConductName";
            ddLConduct.DataValueField = "ConductId";
            ddLConduct.DataBind();
        }
        else
        {
            ddLConduct.DataSource = null;
            ddLConduct.DataBind();
        }
    }

    protected void BindCourseStudy(string regNo)
    {
        Utilities utl = new Utilities();
        string sqlstr = "select isactive from m_academicyear where AcademicID='" + HttpContext.Current.Session["AcademicID"].ToString() + "'";
        string Isactive = utl.ExecuteScalar(sqlstr);
        string query = "";
        if (Isactive == "True")
        {
            query = "sp_getTCCourseStudy " + regNo;
        }
        else
        {
            query = "sp_getPromoTCCourseStudy " + regNo + "," + HttpContext.Current.Session["AcademicID"].ToString();
        }

        DataSet dsCourseStudy = utl.GetDataset(query);
        if (dsCourseStudy != null && dsCourseStudy.Tables.Count > 0 && dsCourseStudy.Tables[0].Rows.Count > 0)
        {
            lblSchoolStudied.Visible = false;
            lblSchoolStudied.Text = "";
            OldSchool.Visible = true;
           
            foreach (DataRow _course in dsCourseStudy.Tables[0].Rows)
            {
                _StudCourceHistory += "<tr>";
                _StudCourceHistory += "<td width='20%' class='cours-brd-tl'><p>" + _course["schooladdr"].ToString().ToUpper() + "</p></td>";
                _StudCourceHistory += "<td width='20%' class='cours-brd-tl'><p>" + _course["acdyears"].ToString().ToUpper() + "</p></td>";
                _StudCourceHistory += "<td width='20%' class='cours-brd-tl'><p>" + _course["classes"].ToString().ToUpper() + "</p></td>";
                //_StudCourceHistory += "<td width='20%' class='cours-brd-tl'><p>" + _course["firstlang"].ToString() + "</p></td>";
                _StudCourceHistory += "<td width='20%' class='cours-brd-tlr'><p>" + _course["mis"].ToString().ToUpper() + "</p></td>";
                _StudCourceHistory += "</tr>";

            }
        }
        else
        {
            OldSchool.Visible = false;
            lblSchoolStudied.Visible = true;
            lblSchoolStudied.Text = "NIL";
           
           
        }
    }

    [WebMethod]

    public static string Save(string slNo, string RegNo, string AcademicId, string Class, string SubStudyPart1,
        string SubStudyPart2, string SubStudyPart3, string Conduct, string Purpose, string UserId)
    {
        Utilities utl = new Utilities();
        string strQueryStatus = "";

        string sqlstr = "select isactive from m_academicyear where AcademicID='" + HttpContext.Current.Session["AcademicID"].ToString() + "'";
        string Isactive = utl.ExecuteScalar(sqlstr);
        sqlstr = "";
        if (Isactive == "True")
        {
            sqlstr = "select regno from vw_getstudent where studentid='" + RegNo + "' and AcademicYear='" + HttpContext.Current.Session["AcademicID"].ToString() + "'";
        }
        else
        {
            sqlstr = "select regno from vw_getOldstudent where studentid='" + RegNo + "' and AcademicYear='" + HttpContext.Current.Session["AcademicID"].ToString() + "'";
        }

          string retval=utl.ExecuteScalar(sqlstr);
          if (retval !="")
          {
              sqlstr = "select count(*) from s_studycertificate where regno='" + retval + "' and AcademicId='" + AcademicId + "'";
               retval = utl.ExecuteScalar(sqlstr);
              if (retval == "" || retval == "0")
              {
                  sqlstr = "SP_InsertStudyCertificate '" + slNo + "'," + RegNo + "," + AcademicId + ",'" + Class + "','" + SubStudyPart1 + "','" + SubStudyPart2 + "'," +
             "'" + SubStudyPart3 + "','" + Conduct + "','" + Purpose + "'," + UserId + "";
                  strQueryStatus = utl.ExecuteScalar(sqlstr);
              }
              else
              {
                  sqlstr = "SP_UpdateStudyCertificate '" + slNo + "'," + RegNo + "," + AcademicId + ",'" + Class + "','" + SubStudyPart1 + "','" + SubStudyPart2 + "'," +
            "'" + SubStudyPart3 + "','" + Conduct + "','" + Purpose + "'," + UserId + "";
                  strQueryStatus = utl.ExecuteScalar(sqlstr);
              }
          }
       
        if (strQueryStatus == string.Empty)
            return "";
        else
            return strQueryStatus;
    }
    [WebMethod]
    public static string GetSerialNo()
    {
        Utilities utl = new Utilities();
        string query = "Select isnull(Max(SCId)+ 1,1)as  SerialNo from s_studycertificate";
        return utl.GetDatasetTable(query, "SCIDs").GetXml();

    }


}