using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.HtmlControls;
using System.Data;
using System.Web.Security;

public partial class Users_Dashboard : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (Session["UserId"] != null)
        {
            if (!IsPostBack)
            {
                BindAnnouncements(Convert.ToInt32(Session["UserId"].ToString()));
                BindData(Convert.ToInt32(Session["UserId"].ToString()));
                if (Session["AcademicId"] != null)
                {
                    GetStudentInfo(Session["AcademicId"].ToString());
                    GetHostelInfo(Session["AcademicId"].ToString());
                }
                GetStaffInfo();
                GetReminderInfo();
            }
           
        }

    }

    private void GetReminderInfo()
    {

        HtmlGenericControl ulReminder = new HtmlGenericControl("ul");
        ulReminder.Attributes.Add("class", "stats-list");
        Utilities utl = new Utilities();
        string query = "[sp_getExpiryDateReminderList] ";
        DataSet ds = new DataSet();
        ds = utl.GetDataset(query);

        if (ds != null && ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0)
        {
            foreach (DataRow dr in ds.Tables[0].Rows)
            {
                HtmlGenericControl li = new HtmlGenericControl("li");
               
                HtmlAnchor anchor = new HtmlAnchor();
                anchor.InnerText = dr["RegistrationNo"].ToString();
                anchor.HRef = "#";
                li.Controls.Add(anchor);

                li = new HtmlGenericControl("li");
                Label lbl = new Label();
                lbl.Text = dr["ToDate"].ToString();
                anchor.Controls.Add(lbl);
                anchor.HRef = "#";

                li.Controls.Add(anchor);
                ulReminder.Controls.Add(li);
            }
        }

        plReminder.Controls.Add(ulReminder);
    }
    private void BindAnnouncements(int userId)
    {
        HtmlGenericControl ul = new HtmlGenericControl("ul");
        ul.Attributes.Add("id", "ticker_01");
        ul.Attributes.Add("class", "ticker");

        Utilities utl = new Utilities();
        string query = "[sp_GetAnnouncements] null," + userId + "";
        DataSet ds = new DataSet();
        ds = utl.GetDataset(query);

        if (ds != null && ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0)
        {
            foreach (DataRow dr in ds.Tables[0].Rows)
            {
                HtmlGenericControl li = new HtmlGenericControl("li");
                li.Style.Add("width", "100%");
                li.InnerText = dr["Title"].ToString();
                HtmlAnchor anchor = new HtmlAnchor();
                anchor.InnerText = " - " + dr["Message"].ToString();

                li.Controls.Add(anchor);
                ul.Controls.Add(li);
            }
        }
        else
        {
            HtmlGenericControl li = new HtmlGenericControl("li");
            li.InnerText = "";
            HtmlAnchor anchor = new HtmlAnchor();
            anchor.InnerText = "No Latest Announcements";
            li.Controls.Add(anchor);
            ul.Controls.Add(li);
        }

        phTicker.Controls.Add(ul);
    }

    private void BindData(int userId)
    {

        string menuId = string.Empty;
        string moduleMenuUd = string.Empty;

        List<string> modules = new List<string>();
        List<ListImages> lstImages = new List<ListImages>();

        modules.Add("Staffs/ManageProfile.aspx|user.png|Profile|N");
        modules.Add("Staffs/LeaveApproval.aspx|approvals.png|Leave Approval|Y|select count(*) from e_staffleave where statusid=0");
        modules.Add("Users/AddUser.aspx|manage-users.png|Manage Users|N");
        modules.Add("Management/Announcements.aspx|news.png|Announcements|Y|select count(*) from a_Announcements where AnnouncementsId not in(SELECT AnnouncementsId from a_AnnouncementsLog)");
        modules.Add("Management/ECircular.aspx|note.png|ECircular|Y|select count(*) from a_ECircular where ECircularID not in(SELECT ECircularID from a_ECircularLog)");
        modules.Add("BirthdayWishes/BirthdayWishes.aspx|birthday.png|Birthdays|Y|SP_GETBIRTHDAYCOUNT");
        modules.Add("Students/StudentAttendance.aspx|student-report.png|Student Attendance|N");
        modules.Add("Staffs/StaffAttendance.aspx|staff-report.png|Staff Attendance|N");
        modules.Add("Masters/Vehicle.aspx|reminders.png|Reminders|Y|sp_getExpiryDateReminder");
        foreach (string module in modules)
        {
            string[] splitModules = module.Split('|');
            DataSet ds = GetModulMenuId(Session["UserId"].ToString(), splitModules[0].ToString());
            if (ds != null && ds.Tables[0].Rows.Count > 0)
            {
                menuId = ds.Tables[0].Rows[0]["menuid"].ToString();
                moduleMenuUd = ds.Tables[0].Rows[0]["modulemenuid"].ToString();


                if (CheckPermission(Session["UserId"].ToString(), moduleMenuUd))
                {
                    string acdId = string.Empty;
                    if (Session["AcademicID"] != null)
                        acdId = Session["AcademicID"].ToString();
                    string link = "../" + splitModules[0].ToString() + "?menuId=" + menuId + "&activeIndex=0&moduleId=" + moduleMenuUd + "&AcademicYear=" + acdId + "";
                    Session["Reminder"] = "Yes";
                    string query = string.Empty;
                    if (splitModules.Count() > 4)
                    {
                        query = splitModules[4].ToString();
                    }
                    lstImages.Add(new ListImages
                    {
                        Image = "../img/" + splitModules[1],
                        Link = link,
                        Title = splitModules[2],
                        Notification = splitModules[3],
                        Query = query
                    });

                }
            }
        }
        BindMenus(lstImages);

    }
    private void BindMenus(List<ListImages> lstImages)
    {
        HtmlGenericControl ul = new HtmlGenericControl("ul");
        ul.Attributes.Add("class", "gallery feature_tiles clearfix isotope");
        foreach (ListImages lst in lstImages)
        {
            HtmlGenericControl li = new HtmlGenericControl("li");
            li.Attributes.Add("class", "isotope-item");
            HtmlAnchor anchor = new HtmlAnchor();
            anchor.Attributes.Add("class", "features");
            anchor.HRef = lst.Link;
            HtmlImage img = new HtmlImage();
            img.Src = "../img/" + lst.Image + "";
            HtmlGenericControl spanTitle = new HtmlGenericControl("span");
            spanTitle.InnerText = lst.Title;
            spanTitle.Attributes.Add("class", "name sort_1");
            if (lst.Notification == "Y")
            {
                string count = GetCount(lst.Query).ToString();
                if (count != "0")
                {
                    HtmlGenericControl div = new HtmlGenericControl("div");
                    div.Attributes.Add("class", "starred blue");
                    div.InnerText = count;
                    anchor.Controls.Add(div);
                }
            }
            anchor.Controls.Add(img);
            anchor.Controls.Add(spanTitle);
            li.Controls.Add(anchor);
            ul.Controls.Add(li);
        }
        phMenus.Controls.Add(ul);
    }

    private DataSet GetModulMenuId(string userId, string path)
    {
        string query = "sp_GetModuleMenuId'" + path + "'," + userId + "";
        Utilities utl = new Utilities();
        DataSet ds = new DataSet();
        return utl.GetDataset(query);
    }

    private bool CheckPermission(string userId, string moduleId)
    {
        Utilities utl = new Utilities();
        string addPrm = string.Empty;
        string editPrm = string.Empty;
        string viewPrm = string.Empty;
        string deletePrm = string.Empty;

        string sqlstr = "exec [sp_GetUserMenusAndModules1]" + userId + "," + moduleId + "";
        DataTable dt = new DataTable();
        DataRow dr = null;
        dt = utl.GetDataTable(sqlstr);
        if (dt != null && dt.Rows.Count > 0)
        {
            dr = dt.Rows[0];
            addPrm = dr["AddPrm"].ToString().ToLower();
            deletePrm = dr["DeletePrm"].ToString().ToLower();
            editPrm = dr["EditPrm"].ToString().ToLower();
            viewPrm = dr["ViewPrm"].ToString().ToLower();
            //if (addPrm == "true" || deletePrm == "true" || editPrm == "true")
            //{
            //    viewPrm = "true";
            //    return true;
            //}
            //else
            //{
            //    viewPrm = "false";
            //    return false;
            //}
            return true;
        }
        else
            return false;
    }

    private int GetCount(string query)
    {
        int count = 0;
        Utilities utl = new Utilities();
        count = utl.GetCounts(query);
        return count;
    }

    public class ListImages
    {
        public string Link { get; set; }
        public string Image { get; set; }
        public string Title { get; set; }
        public string Notification { get; set; }
        public string Query { get; set; }
    }

    private void GetStudentInfo(string acdId)
    {
        Utilities utl = new Utilities();
        DataSet ds = new DataSet();
        ds = utl.GetDataset("SP_GETSTUDENTINFOCOUNTS " + acdId + "");
        if (ds != null && ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0)
            totalStudents.InnerText = ds.Tables[0].Rows[0]["TOTALSTUDENTS"].ToString();

        if (ds != null && ds.Tables.Count > 1 && ds.Tables[1].Rows.Count > 0)
            totalgirls.InnerText = ds.Tables[1].Rows[0]["TOTALFEMALE"].ToString();

        if (ds != null && ds.Tables.Count > 2 && ds.Tables[2].Rows.Count > 0)
            totalboys.InnerText = ds.Tables[2].Rows[0]["TOTALMALE"].ToString();

        if (ds != null && ds.Tables.Count > 3 && ds.Tables[3].Rows.Count > 0)
            totalStudentPresent.InnerText = ds.Tables[3].Rows[0]["TODAYATT"].ToString();

    }

    private void GetStaffInfo()
    {
        Utilities utl = new Utilities();
        DataSet ds = new DataSet();
        ds = utl.GetDataset("SP_GETSTAFFINFOCOUNTS");

        if (ds != null && ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0)
            totalStaffs.InnerText = ds.Tables[0].Rows[0]["TOTALSTAFFS"].ToString();

        if (ds != null && ds.Tables.Count > 1 && ds.Tables[1].Rows.Count > 0)
            totalFemale.InnerText = ds.Tables[1].Rows[0]["TOTALFEMALE"].ToString();

        if (ds != null && ds.Tables.Count > 2 && ds.Tables[2].Rows.Count > 0)
            totalMale.InnerText = ds.Tables[2].Rows[0]["TOTALMALE"].ToString();

        if (ds != null && ds.Tables.Count > 3 && ds.Tables[3].Rows.Count > 0)
            totalStaffPresent.InnerText = ds.Tables[3].Rows[0]["TODAYATT"].ToString();
    }

    private void GetHostelInfo(string acdId)
    {
        Utilities utl = new Utilities();
        DataSet ds = new DataSet();
        ds = utl.GetDataset("SP_GETHOSTELINFOCOUNT " + acdId + "");

        if (ds != null & ds.Tables[0].Rows != null)
            totalHstudents.InnerText = ds.Tables[0].Rows[0]["TOTALSTUDENTS"].ToString();

        if (ds != null & ds.Tables[1].Rows != null)
            totalHgirls.InnerText = ds.Tables[1].Rows[0]["TOTALFEMALE"].ToString();

        if (ds != null & ds.Tables[2].Rows != null)
            totalHboys.InnerText = ds.Tables[2].Rows[0]["TOTALMALE"].ToString();
    }
}