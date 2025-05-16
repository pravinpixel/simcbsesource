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
using System.Data.OleDb;
using System.IO;


public partial class Students_ApplicationSearch : System.Web.UI.Page
{
    Utilities utl = null;
    string sqlstr = "";
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
            Userid = Convert.ToInt32(Session["UserId"]);

            if (!IsPostBack)
            {
                BindAcademicYear();
                BindClass();
                BindDummyRow();

                

            }
            if (Request.QueryString["AcademicYear"] != null && Session["AcademicID"] != null)
            {
                ddlAcademicYear.SelectedValue = Session["AcademicID"].ToString();
            }

        }
    }

    protected void Button2_Click(object sender, EventArgs e)
    {
        utl = new Utilities();
        try
        {
            if (!FileUpload2.HasFile)
            {
                return;
            }
            if (File.Exists(Server.MapPath(".//") + FileUpload2.PostedFile.FileName) == true)
            {
                File.Delete(Server.MapPath(".//") + FileUpload2.PostedFile.FileName);
            }
            FileUpload1.SaveAs(Server.MapPath(".//") + System.DateTime.Now.ToString("yyyyMMddhhmmss") + FileUpload2.PostedFile.FileName);

            string path = Server.MapPath(".//") + System.DateTime.Now.ToString("yyyyMMddhhmmss") + FileUpload2.PostedFile.FileName;
            //  DisplayData();

            string excelConnectionString = "";
            OleDbConnection excelConnection = null;
            OleDbCommand cmd = null;
            try
            {
                excelConnectionString = @"Provider=Microsoft.Jet.OLEDB.4.0;Data Source=" + path + ";Extended Properties='Excel 8.0;HDR=Yes'";
                excelConnection = new OleDbConnection(excelConnectionString);
                cmd = new OleDbCommand("Select sno,regno,type,classid,sectionid,name from [sheet1$]", excelConnection);
                cmd.CommandTimeout = 50000;
                excelConnection.Open();
            }
            catch
            {
                excelConnectionString = @"Provider=Microsoft.ACE.OLEDB.12.0;Data Source=" + path + ";Extended Properties='Excel 8.0;HDR=No'";
                excelConnection = new OleDbConnection(excelConnectionString);
                cmd = new OleDbCommand("Select regno,FeesCatHeadID,Amount,ConcessionAmount from [sheet1$]", excelConnection);
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
                    string regno = ds.Tables[0].Rows[i]["regno"].ToString().Trim();
                    string FeesCatHeadID = ds.Tables[0].Rows[i]["FeesCatHeadID"].ToString().Trim();
                    string ConcessionAmount = ds.Tables[0].Rows[i]["ConcessionAmount"].ToString().Trim();
                    string academicID = ds.Tables[0].Rows[i]["AcademicID"].ToString().Trim();
                    string icnt = utl.ExecuteScalar("select count(*) s_studentconcession where isactive=1 and academicID=" + academicID + " and FeesCatHeadID='" + FeesCatHeadID + "'");
                    if (icnt == "" || icnt == "0")
                    {
                        utl.ExecuteQuery("insert into s_studentconcession(FeesCatHeadID,AcademicID,RegNo,ConcessType,ConcessAmt,IsActive,UserID)values('" + FeesCatHeadID + "','" + academicID + "','" + regno + "','P','" + ConcessionAmount + "',1,1)");

                        sqlstr = "update s_studentinfo set Concession='Y',reason='COVID Concession' where regno='" + regno + "' and academicyear=" + academicID + "";
                        utl.ExecuteQuery(sqlstr);
                    }

                }
                FileUpload2.Dispose();
                File.Delete(path);
                utl.ShowMessage("Uploaded Successfully", this.Page);
            }
        }
        catch (Exception ex)
        {
            FileUpload2.Dispose();
            utl.ShowMessage("File content problem, cant upload the file. kindly check it" + ex, this.Page);
        }
    }

    protected void Button1_Click(object sender, EventArgs e)
    {
        utl = new Utilities();
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
                cmd = new OleDbCommand("Select sno,regno,type,classid,sectionid,name from [sheet1$]", excelConnection);
                cmd.CommandTimeout = 50000;
                excelConnection.Open();
            }
            catch
            {
                excelConnectionString = @"Provider=Microsoft.ACE.OLEDB.12.0;Data Source=" + path + ";Extended Properties='Excel 8.0;HDR=No'";
                excelConnection = new OleDbConnection(excelConnectionString);
                cmd = new OleDbCommand("Select sno,regno,type,classid,sectionid,name from [sheet1$]", excelConnection);
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
                    string regno = ds.Tables[0].Rows[i]["regno"].ToString().Trim();
                    string sno = ds.Tables[0].Rows[i]["sno"].ToString().Trim();
                    string classid = ds.Tables[0].Rows[i]["classid"].ToString().Trim();
                    string sectionid = ds.Tables[0].Rows[i]["sectionid"].ToString().Trim();

                    string stype = ds.Tables[0].Rows[i]["type"].ToString().Trim();

                    sqlstr = "select * from s_studentinfo where regno='" + regno + "'";
                    DataTable dtss = new DataTable();
                    dtss = utl.GetDataTable(sqlstr);
                    if (dtss.Rows.Count > 0)
                    {
                        if (stype.ToString().Trim() == "section")
                        {
                            utl.ExecuteQuery("update s_studentinfo set class='" + classid.ToString().Trim() + "',section='" + sectionid.ToString().Trim() + "' where regno='" + regno.ToString().Trim() + "'");
                        }
                        else if (stype.ToString().Trim() == "fees")
                        {
                            utl.ExecuteQuery("update s_studentinfo set class='" + classid.ToString().Trim() + "',section='" + sectionid.ToString().Trim() + "' where regno='" + regno.ToString().Trim() + "'");
                            DataTable dts = new DataTable();

                            dts = utl.GetDataTable("select top 1 * from f_studentbillmaster where RegNo ='" + regno.ToString().Trim() + "' and AcademicId='" + dtss.Rows[0]["academicyear"].ToString().Trim() + "' and isactive=1 order by billid asc");
                            if (dts.Rows.Count > 0)
                            {
                                utl.ExecuteQuery("update a set a.feescatheadid=f.feescatheadid from f_studentbills as a inner join f_studentbillmaster  as b on a.billid=b.billid  inner join s_studentinfo e on e.regno=b.regno and e.AcademicYear=b.AcademicId inner join m_feescategory g on e.Active=g.FeesCatCode  inner join m_feescategoryhead c on c.feescatheadid=a.feescatheadid  inner join m_feeshead d  on d.feesheadid=c.feesheadid left join m_feescategoryhead f on (e.class=f.classid and f.feesheadid=c.feesheadid   and f.FeesCategoryId=g.FeesCategoryId  and e.AcademicYear=f.AcademicId) where e.regno='" + regno.ToString() + "' and b.BillId=" + dts.Rows[0]["billid"].ToString().Trim() + "  and  e.AcademicYear='" + dtss.Rows[0]["academicyear"].ToString() + "' ");
                            }
                        }
                       // return;
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

    [WebMethod]
    public static string GetStudent(string StudentName, string ApplicationNo)
    {
        Utilities utl = new Utilities();
        DataSet ds = new DataSet();
        string query = "";
        string isActive = Convert.ToString(utl.ExecuteScalar("select isnull(isactive,0) isactive from m_academicyear where academicid='" + HttpContext.Current.Session["AcademicID"] + "'"));
        if (isActive == "True" || isActive == "1")
        {
            query = "sp_GetApplicationStudentInfo " + "''" + ",'" + ApplicationNo + "','" + StudentName + "'";
        }
        else if (isActive == "False" || isActive == "0")
        {
            query = "sp_GetPromoStudentInfo " + HttpContext.Current.Session["AcademicID"] + ",'', '" + ApplicationNo + "','" + StudentName + "'";
        }

        return utl.GetDatasetTable(query, "Student").GetXml();
    }
    private void BindAcademicYear()
    {
        utl = new Utilities();
        sqlstr = "sp_getAcademinYear";
        DataTable dt = new DataTable();
        dt = utl.GetDataTable(sqlstr);

        if (dt != null && dt.Rows.Count > 0)
        {
            ddlAcademicYear.DataSource = dt;
            ddlAcademicYear.DataTextField = "AcademicYear";
            ddlAcademicYear.DataValueField = "AcademicID";
            ddlAcademicYear.DataBind();
        }
        else
        {
            ddlAcademicYear.DataSource = null;
            ddlAcademicYear.DataBind();
            ddlAcademicYear.SelectedIndex = 0;
        }


    }
    private void BindClass()
    {
        utl = new Utilities();
        sqlstr = "sp_GetClass ";
        DataTable dt = new DataTable();
        dt = utl.GetDataTable(sqlstr);

        if (dt != null && dt.Rows.Count > 0)
        {
            ddlClass.DataSource = dt;
            ddlClass.DataTextField = "ClassName";
            ddlClass.DataValueField = "ClassID";
            ddlClass.DataBind();
        }
        else
        {
            ddlClass.DataSource = null;
            ddlClass.DataBind();
            ddlClass.SelectedIndex = 0;
        }
    }

    private void BindDummyRow()
    {
        HiddenField hdnID = (HiddenField)Page.Master.FindControl("hfViewPrm");
        if (hdnID.Value.ToLower() == "true")
        {
            DataTable dummy = new DataTable();
            dummy.Columns.Add("SlNo");
            dummy.Columns.Add("ApplicationNo");
            dummy.Columns.Add("RegNo");
            dummy.Columns.Add("TempNo");
            dummy.Columns.Add("StudentName");
            dummy.Columns.Add("Class");
            dummy.Columns.Add("Status");
            dummy.Columns.Add("StudentID");
            dummy.Rows.Add();
            dgStudentInfo.DataSource = dummy;
            dgStudentInfo.DataBind();
        }
    }

    public static DataSet GetData(SqlCommand cmd, int pageIndex)
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
                    sda.Fill(ds, "StudentInfo");
                    DataTable dt = new DataTable("Pager");
                    dt.Columns.Add("PageIndex");
                    dt.Columns.Add("PageSize");
                    dt.Columns.Add("RecordCount");
                    dt.Rows.Add();
                    dt.Rows[0]["PageIndex"] = pageIndex;
                    dt.Rows[0]["PageSize"] = PageSize;
                    dt.Rows[0]["RecordCount"] = ds.Tables[1].Rows[0][0];
                    ds.Tables.Add(dt);
                    return ds;
                }
            }
        }
    }

    [WebMethod]
    public static string GetStudentInfo(int pageIndex, string studentid, string studentname, string ApplicationNo, string classname, string section, string gender, string phoneno, string hostel, string hostelname, string busfacility, string routecode, string routename, string sStatus, string Academic)
    {
        Utilities utl = new Utilities();

        string isActive = Convert.ToString(utl.ExecuteScalar("select isnull(isactive,0) isactive from m_academicyear where academicid='" + HttpContext.Current.Session["AcademicID"] + "'"));
        string query = "";
        //if (isActive == "True" || isActive == "1")
        //{
        //    query = "[GetApplicationInfo_Pager]";
        //}
        //else if (isActive == "False" || isActive == "0")
        //{
        //    query = "[GetPromoStudentInfo_Pager]";
        //}
        query = "[GetApplicationInfo_Pager]";
        string stracademicyear = "";
        string icnt = "";
        //if (regno != "")
        //{
        //    stracademicyear = utl.ExecuteScalar("select academicyear from s_studentinfo where regno='" + regno + "'");
        //    if (stracademicyear != "" && stracademicyear != "0")
        //    {
        //        icnt = utl.ExecuteScalar("select count(*) from s_studentpromotion where regno='" + regno + "' and academicid='" + stracademicyear + "'");

        //        if (icnt=="" || icnt=="0")
        //        {
        //            utl.ExecuteQuery("insert into  s_studentpromotion(regno,ClassID,SectionID,BusFacility,Concession,Hostel,Scholar,AcademicId,Active,UserId)(select regno,Class,case when Section=0 then NULL else section end,BusFacility,Concession,Hostel,Scholar,academicyear,Active,1 from s_studentinfo where regno= '" + regno + "')");
        //        }
        //    }
          
        //}
        
        
        SqlCommand cmd = new SqlCommand(query);
        cmd.CommandType = CommandType.StoredProcedure;
        cmd.Parameters.AddWithValue("@PageIndex", pageIndex);
        cmd.Parameters.AddWithValue("@PageSize", PageSize);
        cmd.Parameters.Add("@RecordCount", SqlDbType.Int, 4).Direction = ParameterDirection.Output;
        cmd.Parameters.AddWithValue("@studentid", studentid);
        cmd.Parameters.AddWithValue("@studentname", studentname);
        cmd.Parameters.AddWithValue("@applicationNo", ApplicationNo);
        cmd.Parameters.AddWithValue("@classname", classname);
        cmd.Parameters.AddWithValue("@section", section);
        cmd.Parameters.AddWithValue("@gender", gender);
        cmd.Parameters.AddWithValue("@phoneno", phoneno);
        cmd.Parameters.AddWithValue("@hostel", hostel);
        cmd.Parameters.AddWithValue("@hostelname", hostelname);
        cmd.Parameters.AddWithValue("@busfacility", busfacility);
        cmd.Parameters.AddWithValue("@routecode", routecode);
        cmd.Parameters.AddWithValue("@routename", routename);
        cmd.Parameters.AddWithValue("@sStatus", sStatus);
        if (Academic == "")
        {
            Academic = HttpContext.Current.Session["AcademicID"].ToString();
        }
        cmd.Parameters.AddWithValue("@Academic", Academic);
        return GetData(cmd, pageIndex).GetXml();

    }
    [WebMethod]
    public static string GetModuleId(string path)
    {
        Utilities utl = new Utilities();
        DataSet ds = new DataSet();
        string query = "sp_GetModuleMenuIdByPath '" + path + "'," + Userid + "";
        ds = utl.GetDatasetTable(query, "ModuleMenusByPath");
        return ds.GetXml();
    }
    [WebMethod]
    public static string GetSectionByClassID(int ClassID)
    {

        Utilities utl = new Utilities();
        DataSet ds = new DataSet();
        string query = "sp_GetSectionByClass " + ClassID;
        return utl.GetDatasetTable(query, "SectionByClass").GetXml();

    }

    [WebMethod]
    public static string GetStudentBySection(string Class, string Section)
    {

        Utilities utl = new Utilities();
        DataSet ds = new DataSet();
        string isActive = Convert.ToString(utl.ExecuteScalar("select isnull(isactive,0) isactive from m_academicyear where academicid='" + HttpContext.Current.Session["AcademicID"] + "'"));
        string query = "";
        if (isActive == "True" || isActive == "1")
        {
           query = "sp_GetStudentBySection '" + Class + "','" + Section + "','" + HttpContext.Current.Session["AcademicID"].ToString() + "'";
        }
        else if (isActive == "False" || isActive == "0")
        {
            query = "sp_GetPromoStudentBySection '" + Class + "','" + Section + "','" + HttpContext.Current.Session["AcademicID"].ToString() + "'";
        }

        return utl.GetDatasetTable(query, "StudentBySection").GetXml();

    }

    [WebMethod]
    public static string EditStudentInfo(int StudentInfoID)
    {
        Utilities utl = new Utilities();
        DataSet ds = new DataSet();
        string query = "";

        string isActive = Convert.ToString(utl.ExecuteScalar("select isnull(isactive,0) isactive from m_academicyear where academicid='" + HttpContext.Current.Session["AcademicID"] + "'"));
        if (isActive == "True" || isActive == "1")
        {
            query = "sp_GetStudentInfo " + StudentInfoID + "'";
        }
        else if (isActive == "False" || isActive == "0")
        {
            query = "sp_GetPromoStudentInfo " + HttpContext.Current.Session["AcademicID"] + ",'" + StudentInfoID + "'";
        }
        return utl.GetDatasetTable(query, "EditStudentInfo").GetXml();
    }

    [WebMethod]
    public static string DeleteStudentInfo(string StudentInfoID)
    {
        Utilities utl = new Utilities();
        string sqlstr = string.Empty;
        string strQueryStatus = string.Empty;
        string message = string.Empty;
        Userid = Convert.ToInt32(HttpContext.Current.Session["UserId"]);
        strQueryStatus = utl.ExecuteQuery("sp_DeleteStudentInfo " + "" + StudentInfoID + ",'" + Userid + "'");
        if (strQueryStatus == "")
            return "Deleted";
        else
            return "Delete Failed";
    }

    protected void btnSync_Click(object sender, EventArgs e)
    {
        utl = new Utilities();
        DataSet dsapp = new DataSet();
        dsapp = utl.GetAPPDataset("select * from studentapplications a inner join institutions b on b.ID=a.SchoolID inner join student_classes c on c.ClassId=a.ClassRequested and a.SchoolID=c.InstitutionId where a.isactive=1 and AcademicID=(select AcademicID from academicyears where IsActive=1)  and (tempno is null or tempno='')  and c.IsActive=1 and SchoolID=2 and ReturnDate is not null order by ApplicationID asc");
        if (dsapp != null && dsapp.Tables.Count > 0 && dsapp.Tables[0].Rows.Count > 0)
        {
            for (int i = 0; i < dsapp.Tables[0].Rows.Count; i++)
            {
                string classID = utl.ExecuteScalar("select classId from m_class where ClassInWords='" + dsapp.Tables[0].Rows[i]["ClassInWords"].ToString().Trim() + "'");
                string StudId = utl.ExecuteScalar("select isnull(max(studentid)+1,1) from  s_studentinfo where Active='F'");
                string gender = dsapp.Tables[0].Rows[i]["Gender"].ToString().Trim();
                if (gender == "Male")
                {
                    gender = "M";
                }
                else if (gender == "Female")
                {
                    gender = "F";
                }



                string icnt = utl.ExecuteScalar("select count(*) from s_studentinfo where applicationno='" + dsapp.Tables[0].Rows[i]["ApplicationNo"].ToString().Trim() + "' and schoolname='" + dsapp.Tables[0].Rows[i]["code"].ToString().Trim() + "' and active='F' and academicyear='" + HttpContext.Current.Session["AcademicID"] + "' and (tempno is null or tempno='')");
                if (icnt == "" || icnt == "0")
                {
                    utl.ExecuteQuery("Insert into s_studentinfo(Regno,applicationno,Schoolname,StName,Class,AdClass,DOB,Sex,Phno,FName,FatherCell,MName,MotherCell,Active,academicyear,userid)values('" + StudId + "','" + dsapp.Tables[0].Rows[i]["ApplicationNo"].ToString().Trim() + "','" + dsapp.Tables[0].Rows[i]["code"].ToString().Trim() + "','" + dsapp.Tables[0].Rows[i]["StudentName"].ToString().Trim() + "','" + classID.ToString() + "','" + classID.ToString() + "','" + dsapp.Tables[0].Rows[i]["DOB"].ToString().Trim() + "','" + gender.ToString().Trim() + "','" + dsapp.Tables[0].Rows[i]["FatherMobile"].ToString().Trim() + "','" + dsapp.Tables[0].Rows[i]["Fathername"].ToString().Trim() + "','" + dsapp.Tables[0].Rows[i]["FatherMobile"].ToString().Trim() + "','" + dsapp.Tables[0].Rows[i]["MotherName"].ToString().Trim() + "','" + dsapp.Tables[0].Rows[i]["MotherMobile"].ToString().Trim() + "','F','" + HttpContext.Current.Session["AcademicID"] + "',1)");
                }
                else
                {
                    DataSet dsentrance = new DataSet();
                    dsentrance = utl.GetAPPDataset(@"select a.regno,b.applicationNo,d.code,b.ApplicationID from p_entrancemarks a
                                            inner join studentapplications b on a.AcademicID=b.AcademicID and b.SchoolId=a.SchoolID and a.ClassId=b.ClassRequested
                                            and a.RegNo=b.ApplicationID
                                            inner join student_classes c on c.ClassId=b.ClassRequested and b.SchoolID=c.InstitutionId
											inner join institutions d on d.id=a.SchoolId
                                            and a.AcademicID=(select AcademicID from academicyears where IsActive=1) 
                                            and c.IsActive=1 and a.SchoolID=2 and ReturnDate is not null  and (tempno is null or tempno='') and b.applicationno='" + dsapp.Tables[0].Rows[i]["ApplicationNo"].ToString().Trim() + "'  order by ApplicationID asc");
                    if (dsentrance != null && dsentrance.Tables.Count > 0 && dsentrance.Tables[0].Rows.Count > 0)
                    {
                        for (int k = 0; k < dsentrance.Tables[0].Rows.Count; k++)
                        {

                            string itempcnt = utl.ExecuteScalar("select count(*) from s_studentinfo where applicationNo='" + dsentrance.Tables[0].Rows[k]["applicationNo"].ToString().Trim() + "' and schoolname='" + dsentrance.Tables[0].Rows[k]["code"].ToString().Trim() + "' and (tempno is null or tempno='') and active='F' and academicyear='" + HttpContext.Current.Session["AcademicID"] + "' ");
                            if (itempcnt != "" && itempcnt != "0")
                            {
                                string tempno = utl.ExecuteScalar("select isnull(count(tempno)+1,1) from s_studentinfo where (tempno is not null and tempno<>'')  and schoolname='" + dsentrance.Tables[0].Rows[k]["code"].ToString().Trim() + "' and active='F' and academicyear='" + HttpContext.Current.Session["AcademicID"] + "'");
                                if (tempno != "")
                                {
                                    string formattedno = tempno.PadLeft(5, '0');

                                    string strtempno = dsentrance.Tables[0].Rows[k]["code"].ToString().Trim() + "/" + System.DateTime.Now.Year.ToString() + "/" + "TEMP" + "/" + formattedno.ToString().Trim();

                                    utl.ExecuteQuery("update s_studentinfo set tempno='" + strtempno + "' where applicationNo='" + dsentrance.Tables[0].Rows[k]["applicationNo"].ToString().Trim() + "' and schoolname='" + dsentrance.Tables[0].Rows[k]["code"].ToString().Trim() + "' and active='F' and academicyear='" + HttpContext.Current.Session["AcademicID"] + "' ");

                                    utl.ExecuteAPPQuery("update studentapplications set Tempno='" + strtempno + "' where ApplicationID='" + dsentrance.Tables[0].Rows[k]["ApplicationID"].ToString().Trim() + "'");
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}