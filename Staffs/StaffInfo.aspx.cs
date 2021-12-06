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
using System.Text;

public partial class StaffInfo : System.Web.UI.Page
{
    Utilities utl = null;
    string sqlstr = "";
    public static int Userid = 0;
    private static int PageSize = 10;
    protected void Page_Load(object sender, EventArgs e)
    {
        if (Request.RequestType == "POST")
        {
            if (Request.Files["StaffImage"] != null && Request.Files["StaffImage"].ContentLength > 0 && Request.Form["StaffId"] != null && Request.Form["StaffId"].Length > 0)
            {
                HttpPostedFile PostedFile = Request.Files["StaffImage"];
                string id = Request.Form["StaffId"].ToString();
                utl = new Utilities();
                sqlstr = "select empcode from e_staffinfo where staffid=" + id + "";
                string empcode = utl.ExecuteScalar(sqlstr);
                string extension = PostedFile.FileName.Substring(PostedFile.FileName.LastIndexOf('.'));
                PostedFile.SaveAs(Server.MapPath("~/Staffs/Uploads/ProfilePhotos/" + empcode + extension));
            }
            if (Request.Files["StaffAcdSC"] != null && Request.Files["StaffAcdSC"].ContentLength > 0 && Request.Form["FileName"] != null && Request.Form["FileName"].Length > 0)
            {
                HttpPostedFile PostedFile = Request.Files["StaffAcdSC"];
                string fileName = Request.Form["FileName"].ToString();
                PostedFile.SaveAs(Server.MapPath("~/Staffs/Uploads/AcademicRecords/" + fileName));
            }
            if (Request.Files["StaffMedical"] != null && Request.Files["StaffMedical"].ContentLength > 0 &&
                Request.Form["FileName"] != null && Request.Form["FileName"].Length > 0)
            {
                HttpPostedFile PostedFile = Request.Files["StaffMedical"];
                string fileName = Request.Form["FileName"].ToString();
                PostedFile.SaveAs(Server.MapPath("~/Staffs/Uploads/MedicalRecords/" + fileName));
            }
            if (Request.Files["StaffLeave"] != null && Request.Files["StaffLeave"].ContentLength > 0
              && Request.Form["FileName"] != null && Request.Form["FileName"].Length > 0)
            {
                HttpPostedFile PostedFile = Request.Files["StaffLeave"];
                string fileName = Request.Form["FileName"].ToString();
                PostedFile.SaveAs(Server.MapPath("~/Staffs/Uploads/LeaveRecords/" + fileName));
            }
            if (Request.Files["StaffRemark"] != null && Request.Files["StaffRemark"].ContentLength > 0
              && Request.Form["FileName"] != null && Request.Form["FileName"].Length > 0)
            {
                HttpPostedFile PostedFile = Request.Files["StaffRemark"];
                string fileName = Request.Form["FileName"].ToString();
                PostedFile.SaveAs(Server.MapPath("~/Staffs/Uploads/Remarks/" + fileName));
            }
            if (Request.Files["StaffPunish"] != null && Request.Files["StaffPunish"].ContentLength > 0
              && Request.Form["FileName"] != null && Request.Form["FileName"].Length > 0)
            {
                HttpPostedFile PostedFile = Request.Files["StaffPunish"];
                string fileName = Request.Form["FileName"].ToString();
                PostedFile.SaveAs(Server.MapPath("~/Staffs/Uploads/PunishmentRecords/" + fileName));
            }
            if (Request.Files["StaffRetire"] != null && Request.Files["StaffRetire"].ContentLength > 0
              && Request.Form["FileName"] != null && Request.Form["FileName"].Length > 0)
            {
                HttpPostedFile PostedFile = Request.Files["StaffRetire"];
                string fileName = Request.Form["FileName"].ToString();
                PostedFile.SaveAs(Server.MapPath("~/Staffs/Uploads/RetirementRecords/" + fileName));
            }
            return;
        }

        Master.chkUser();
        if (Session["UserId"] == null || Session["AcademicID"] == null)
        {

            Response.Redirect("Default.aspx?ses=expired");
        }
        else
        {

            if (Session["UserId"] != null)
                hdnUserId.Value = Session["UserId"].ToString();
            if (Request.QueryString["id"] != null)
            {
                hdnStaffId.Value = Request.QueryString["id"].ToString();
                GetHeaderDetails();
            }

            if (!IsPostBack)
            {
                BindCaste();
                BindReligion();
                BindRelationship();
                BindCommunity();
                BindDepartment();
                BindBloodGroup();
                BindLeaves();
                BindAcademic();
                BindDesignation();
                BindClass();
                BindModes();
                BindSubjectUpto();
                BindLanguages();
                BindDummyAcdRow();
                BindDummyFamilyRow();
                BindDummyNomineeRow();
                BindDummyServiceRow();
                BindDummyCareerRow();
                BindDummyLeaveRow();
                BindDummyRemarkRow();
                BindDummyPunishRow();
                BindDummyRetireRow();
                BindDummyInvRow();
                BindDummyStaffRelationRow();
                BindInvigilation();
                BindYearDropdowns();
                BindEmployeeName();
                BindStaffRelationship();
                BindPlaceofWork();
                BindBuilding();
            }
        }
    }

    private void BindDummyStaffRelationRow()
    {
        HiddenField hdnID = (HiddenField)Page.Master.FindControl("hfViewPrm");

        if (hdnID.Value.ToLower() == "true")
        {
            DataTable dummy = new DataTable();
            dummy.Columns.Add("SlNo");
            dummy.Columns.Add("RelationName");
            dummy.Columns.Add("Relationship");
            dummy.Columns.Add("StaffRelID");
            dummy.Rows.Add();
            dgInstitution.DataSource = dummy;
            dgInstitution.DataBind();
        }

    }
    private void BindEmployeeName()
    {
        Utilities utl = new Utilities();
        DataTable dt = new DataTable();
        dt = utl.GetDataTable("[sp_GetEmployeeRelation]");
        if (dt != null && dt.Rows.Count > 0)
        {
            ddlStaff1.DataSource = dt;
            ddlStaff1.DataTextField = "StaffName";
            ddlStaff1.DataValueField = "StaffId";
            ddlStaff1.DataBind();
        }

    }
    private void BindPlaceofWork()
    {
        utl = new Utilities();
        sqlstr = "sp_getplaceofwork";
        DataTable dt = new DataTable();
        dt = utl.GetDataTable(sqlstr);

        if (dt != null && dt.Rows.Count > 0)
        {
            ddlPlaceofWork.DataSource = dt;
            ddlPlaceofWork.DataTextField = "placeofwork";
            ddlPlaceofWork.DataValueField = "placeofworkID";
            ddlPlaceofWork.DataBind();
        }
        else
        {
            ddlPlaceofWork.DataSource = null;
            ddlPlaceofWork.DataBind();
        }
        ddlPlaceofWork.Items.Insert(0, new ListItem("----Select---", ""));

        if (dt != null && dt.Rows.Count > 0)
        {
            ddlPlaceofWork1.DataSource = dt;
            ddlPlaceofWork1.DataTextField = "placeofwork";
            ddlPlaceofWork1.DataValueField = "placeofworkID";
            ddlPlaceofWork1.DataBind();
        }
        else
        {
            ddlPlaceofWork1.DataSource = null;
            ddlPlaceofWork1.DataBind();
        }
        ddlPlaceofWork1.Items.Insert(0, new ListItem("----Select---", ""));
    }
    private void BindBuilding()
    {
        utl = new Utilities();
        sqlstr = "sp_getbuilding";
        DataTable dt = new DataTable();
        dt = utl.GetDataTable(sqlstr);

        if (dt != null && dt.Rows.Count > 0)
        {
            ddlBuilding.DataSource = dt;
            ddlBuilding.DataTextField = "building";
            ddlBuilding.DataValueField = "buildingID";
            ddlBuilding.DataBind();
        }
        else
        {
            ddlBuilding.DataSource = null;
            ddlBuilding.DataBind();
        }
        ddlBuilding.Items.Insert(0, new ListItem("---Select---", ""));
    }
    private void BindStaffRelationship()
    {
        utl = new Utilities();
        sqlstr = "sp_GetRelationship";
        DataTable dt = new DataTable();
        dt = utl.GetDataTable(sqlstr);

        if (dt != null && dt.Rows.Count > 0)
        {
            ddlRelationship1.DataSource = dt;
            ddlRelationship1.DataTextField = "RelationshipName";
            ddlRelationship1.DataValueField = "RelationshipName";
            ddlRelationship1.DataBind();
        }
        else
        {
            ddlRelationship1.DataSource = null;
            ddlRelationship1.DataBind();
        }

    }
    private void BindYearDropdowns()
    {
        for (int i = 1950; i <= Convert.ToInt32(System.DateTime.Now.AddYears(50).ToString("yyyy")); i++)
        {
            ddlYOC.Items.Add(i.ToString());
            ddlUgYOC.Items.Add(i.ToString());
            ddlYOC.SelectedIndex = 0;
            ddlUgYOC.SelectedIndex = 0;
        }
    }
    private void BindDummyAcdRow()
    {
        HiddenField hdnID = (HiddenField)Page.Master.FindControl("hfViewPrm");

        if (hdnID.Value.ToLower() == "true")
        {
            DataTable dummy = new DataTable();
            dummy.Columns.Add("StaffId");
            dummy.Columns.Add("CourseCompleted");
            dummy.Columns.Add("Board/University");
            dummy.Columns.Add("YearOfCompletion");
            dummy.Columns.Add("MainSubject");
            dummy.Columns.Add("AncillarySubject");
            dummy.Columns.Add("CertificateNo");
            dummy.Columns.Add("SubmittedDate");
            dummy.Columns.Add("ReturnedDate");
            dummy.Columns.Add("Type");
            dummy.Columns.Add("ScannedCopy");


            DataRow dr = dummy.NewRow();
            dr["YearOfCompletion"] = "No Records Found";
            dummy.Rows.Add(dr);
            dgAcdDetails.DataSource = dummy;
            dgAcdDetails.DataBind();
        }
    }
    private void BindDummyFamilyRow()
    {
        HiddenField hdnID = (HiddenField)Page.Master.FindControl("hfViewPrm");

        if (hdnID.Value.ToLower() == "true")
        {
            DataTable dummy = new DataTable();
            dummy.Columns.Add("StaffId");
            dummy.Columns.Add("RelationshipId");
            dummy.Columns.Add("Name");
            dummy.Columns.Add("DOB");
            dummy.Columns.Add("Sex");
            dummy.Columns.Add("Qualification");
            dummy.Columns.Add("Occupation");
            dummy.Columns.Add("Address");
            dummy.Columns.Add("ContactNo");

            DataRow dr = dummy.NewRow();
            dr["Qualification"] = "No Records Found";
            dummy.Rows.Add(dr);
            dgFamily.DataSource = dummy;
            dgFamily.DataBind();
        }
    }
    private void BindDummyNomineeRow()
    {
        HiddenField hdnID = (HiddenField)Page.Master.FindControl("hfViewPrm");

        if (hdnID.Value.ToLower() == "true")
        {
            DataTable dummy = new DataTable();
            dummy.Columns.Add("StaffId");
            dummy.Columns.Add("Name");
            dummy.Columns.Add("Address");
            dummy.Columns.Add("Relationship");
            dummy.Columns.Add("DOB");
            dummy.Columns.Add("Sex");
            dummy.Columns.Add("Share");
            dummy.Columns.Add("Type");
            dummy.Columns.Add("ContactNo");

            DataRow dr = dummy.NewRow();
            dr["DOB"] = "No Records Found";
            dummy.Rows.Add(dr);
            dgNominee.DataSource = dummy;
            dgNominee.DataBind();
        }
    }
    private void BindDummyServiceRow()
    {
        HiddenField hdnID = (HiddenField)Page.Master.FindControl("hfViewPrm");

        if (hdnID.Value.ToLower() == "true")
        {
            DataTable dummy = new DataTable();

            dummy.Columns.Add("AcademicYear");
            dummy.Columns.Add("DOJ");
            dummy.Columns.Add("Designation");
            dummy.Columns.Add("Department");
            dummy.Columns.Add("PlaceOfWork");
            dummy.Columns.Add("SubjectHandling");
            dummy.Columns.Add("ClassAllocated");
            dummy.Columns.Add("Mode");
            dummy.Columns.Add("StaffId");
            DataRow dr = dummy.NewRow();
            dr["SubjectHandling"] = "No Records Found";
            dummy.Rows.Add(dr);
            dgService.DataSource = dummy;
            dgService.DataBind();
        }
    }
    private void BindDummyCareerRow()
    {
        HiddenField hdnID = (HiddenField)Page.Master.FindControl("hfViewPrm");

        if (hdnID.Value.ToLower() == "true")
        {
            DataTable dummy = new DataTable();

            dummy.Columns.Add("Date");
            dummy.Columns.Add("OrderNo");
            dummy.Columns.Add("Designation");
            dummy.Columns.Add("Placeofwork");
            dummy.Columns.Add("Building");
            dummy.Columns.Add("Probation");
            dummy.Columns.Add("CompletionDate");
            dummy.Columns.Add("CompletionOrder");
            dummy.Columns.Add("From");
            dummy.Columns.Add("To");
            dummy.Columns.Add("StaffId");
            DataRow dr = dummy.NewRow();
            dr["CompletionDate"] = "No Records Found";
            dummy.Rows.Add(dr);
            dgCareer.DataSource = dummy;
            dgCareer.DataBind();
        }
    }
    private void BindDummyLeaveRow()
    {
        HiddenField hdnID = (HiddenField)Page.Master.FindControl("hfViewPrm");

        if (hdnID.Value.ToLower() == "true")
        {
            DataTable dummy = new DataTable();
            dummy.Columns.Add("StaffId");
            dummy.Columns.Add("AcademicYear");
            dummy.Columns.Add("Leave");
            dummy.Columns.Add("Reason");
            dummy.Columns.Add("From");
            dummy.Columns.Add("To");
            dummy.Columns.Add("NoOfLeaves");
            dummy.Columns.Add("Uploads");
            dummy.Columns.Add("Status");

            dummy.Rows.Add();
            dgLeave.DataSource = dummy;
            dgLeave.DataBind();
        }
    }
    private void BindDummyRemarkRow()
    {
        HiddenField hdnID = (HiddenField)Page.Master.FindControl("hfViewPrm");

        if (hdnID.Value.ToLower() == "true")
        {
            DataTable dummy = new DataTable();
            dummy.Columns.Add("StaffId");
            dummy.Columns.Add("Date");
            dummy.Columns.Add("Title");
            dummy.Columns.Add("Reason");
            dummy.Columns.Add("Uploads");

            dummy.Rows.Add();
            dgRemark.DataSource = dummy;
            dgRemark.DataBind();
        }
    }
    private void BindDummyPunishRow()
    {
        HiddenField hdnID = (HiddenField)Page.Master.FindControl("hfViewPrm");

        if (hdnID.Value.ToLower() == "true")
        {
            DataTable dummy = new DataTable();
            dummy.Columns.Add("StaffId");
            dummy.Columns.Add("Date");
            dummy.Columns.Add("Title");
            dummy.Columns.Add("Reason");
            dummy.Columns.Add("Uploads");

            dummy.Rows.Add();
            dgPunish.DataSource = dummy;
            dgPunish.DataBind();
        }
    }
    private void BindDummyRetireRow()
    {
        HiddenField hdnID = (HiddenField)Page.Master.FindControl("hfViewPrm");

        if (hdnID.Value.ToLower() == "true")
        {
            DataTable dummy = new DataTable();
            dummy.Columns.Add("StaffId");
            dummy.Columns.Add("Date");
            dummy.Columns.Add("Title");
            dummy.Columns.Add("Reason");
            dummy.Columns.Add("Uploads");

            dummy.Rows.Add();
            dgRetire.DataSource = dummy;
            dgRetire.DataBind();
        }
    }
    private void BindDummyInvRow()
    {
        HiddenField hdnID = (HiddenField)Page.Master.FindControl("hfViewPrm");

        if (hdnID.Value.ToLower() == "true")
        {
            DataTable dummy = new DataTable();
            dummy.Columns.Add("Year");
            dummy.Columns.Add("School");
            dummy.Columns.Add("Place");
            dummy.Columns.Add("Type");
            dummy.Columns.Add("StaffId");

            DataRow dr = dummy.NewRow();
            dr["Place"] = "No Records Found";
            dummy.Rows.Add(dr);
            dgInv.DataSource = dummy;
            dgInv.DataBind();
        }
    }

    private void BindReligion()
    {
        utl = new Utilities();
        sqlstr = "sp_GetReligion";
        DataTable dt = new DataTable();
        dt = utl.GetDataTable(sqlstr);

        if (dt != null && dt.Rows.Count > 0)
        {
            ddlReligion.DataSource = dt;
            ddlReligion.DataTextField = "ReligionName";
            ddlReligion.DataValueField = "ReligionId";
            ddlReligion.DataBind();
        }
        else
        {
            ddlReligion.DataSource = null;
            ddlReligion.DataBind();
        }

    }
    private void BindCommunity()
    {
        utl = new Utilities();
        sqlstr = "sp_GetCommunity";
        DataTable dt = new DataTable();
        dt = utl.GetDataTable(sqlstr);

        if (dt != null && dt.Rows.Count > 0)
        {
            ddlCommunity.DataSource = dt;
            ddlCommunity.DataTextField = "CommunityName";
            ddlCommunity.DataValueField = "CommunityId";
            ddlCommunity.DataBind();
        }
        else
        {
            ddlCommunity.DataSource = null;
            ddlCommunity.DataBind();
        }

    }
    private void BindRelationship()
    {
        utl = new Utilities();
        sqlstr = "sp_GetRelationship";
        DataTable dt = new DataTable();
        dt = utl.GetDataTable(sqlstr);

        if (dt != null && dt.Rows.Count > 0)
        {
            ddRelations.DataSource = dt;
            ddRelations.DataTextField = "RelationshipName";
            ddRelations.DataValueField = "RelationshipId";
            ddRelations.DataBind();

            ddlStaffRelationship.DataSource = dt;
            ddlStaffRelationship.DataTextField = "RelationshipName";
            ddlStaffRelationship.DataValueField = "RelationshipId";
            ddlStaffRelationship.DataBind();
        }
        else
        {
            ddlStaffRelationship.DataSource = null;
            ddlStaffRelationship.DataBind();

            ddlStaffRelationship.DataSource = null;
            ddlStaffRelationship.DataBind();
        }

        ddRelations.Items.Insert(0, new ListItem("---Select---", ""));
        ddlStaffRelationship.Items.Insert(0, new ListItem("---Select---", ""));
    }
    private void BindDepartment()
    {
        utl = new Utilities();
        sqlstr = "[sp_GetDepartment]";
        DataTable dt = new DataTable();
        dt = utl.GetDataTable(sqlstr);

        if (dt != null && dt.Rows.Count > 0)
        {
            ddlDepartment.DataSource = dt;
            ddlDepartment.DataTextField = "DepartmentName";
            ddlDepartment.DataValueField = "DepartmentId";
            ddlDepartment.DataBind();

            ddlDepartment2.DataSource = dt;
            ddlDepartment2.DataTextField = "DepartmentName";
            ddlDepartment2.DataValueField = "DepartmentId";
            ddlDepartment2.DataBind();

            ddlServiceDepartment.DataSource = dt;
            ddlServiceDepartment.DataTextField = "DepartmentName";
            ddlServiceDepartment.DataValueField = "DepartmentId";
            ddlServiceDepartment.DataBind();

            ddlLangs.DataSource = dt;
            ddlLangs.DataTextField = "DepartmentName";
            ddlLangs.DataValueField = "DepartmentId";
            ddlLangs.DataBind();

            ddlMainCourse.DataSource = dt;
            ddlMainCourse.DataTextField = "DepartmentName";
            ddlMainCourse.DataValueField = "DepartmentId";
            ddlMainCourse.DataBind();

        }
        else
        {
            ddlDepartment.DataSource = null;
            ddlDepartment.DataBind();

            ddlDepartment2.DataSource = null;
            ddlDepartment2.DataBind();

            ddlServiceDepartment.DataSource = null;
            ddlServiceDepartment.DataBind();



            ddlLangs.DataSource = null;
            ddlLangs.DataBind();

            ddlMainCourse.DataSource = null;
            ddlMainCourse.DataBind();
        }

        ddlDepartment.Items.Insert(0, new ListItem("---Select---", ""));
        ddlDepartment2.Items.Insert(0, new ListItem("---Select---", ""));
        ddlServiceDepartment.Items.Insert(0, new ListItem("---Select---", ""));
        ddlLangs.Items.Insert(0, new ListItem("---Select---", ""));
        ddlMainCourse.Items.Insert(0, new ListItem("---Select---", ""));

    }
    private void BindBloodGroup()
    {
        utl = new Utilities();
        sqlstr = "[sp_GetBloodGroup]";
        DataTable dt = new DataTable();
        dt = utl.GetDataTable(sqlstr);

        if (dt != null && dt.Rows.Count > 0)
        {
            ddlBloodGroup.DataSource = dt;
            ddlBloodGroup.DataTextField = "BloodGroupName";
            ddlBloodGroup.DataValueField = "BloodGroupID";
            ddlBloodGroup.DataBind();
        }
        else
        {
            ddlBloodGroup.DataSource = null;
            ddlBloodGroup.DataBind();
        }

        ddlBloodGroup.Items.Insert(0, new ListItem("---Select---", ""));
    }
    private void BindLeaves()
    {
        utl = new Utilities();
        sqlstr = "sp_GetLeave";
        DataTable dt = new DataTable();
        dt = utl.GetDataTable(sqlstr);

        if (dt != null && dt.Rows.Count > 0)
        {
            ddlLeave.DataSource = dt;
            ddlLeave.DataTextField = "LeaveName";
            ddlLeave.DataValueField = "LeaveId";
            ddlLeave.DataBind();
        }
        else
        {
            ddlLeave.DataSource = null;
            ddlLeave.DataBind();
        }
        ddlLeave.Items.Insert(0, new ListItem("---Select---", ""));
    }
    private void BindInvigilation()
    {
        utl = new Utilities();
        sqlstr = "sp_GetInvigilationDetails";
        DataTable dt = new DataTable();
        dt = utl.GetDataTable(sqlstr);

        if (dt != null && dt.Rows.Count > 0)
        {
            ddlInvTypes.DataSource = dt;
            ddlInvTypes.DataTextField = "InvigilationType";
            ddlInvTypes.DataValueField = "InvigilationId";
            ddlInvTypes.DataBind();
        }
        else
        {
            ddlInvTypes.DataSource = null;
            ddlInvTypes.DataBind();
        }
        ddlInvTypes.Items.Insert(0, new ListItem("---Select---", ""));
    }
    private void BindAcademic()
    {
        utl = new Utilities();
        sqlstr = "SP_GetCurrentAcademicYear";
        DataTable dt = utl.GetDataTable(sqlstr);

        if (dt != null && dt.Rows.Count > 0)
        {
            txtAcademic.Text = dt.Rows[0]["AcademicYear"].ToString();
            hdnAcd.Value = dt.Rows[0]["AcademicId"].ToString();
        }

    }
    private void BindDesignation()
    {
        utl = new Utilities();
        sqlstr = "sp_Getdesignation";
        DataTable dt = new DataTable();
        dt = utl.GetDataTable(sqlstr);

        if (dt != null && dt.Rows.Count > 0)
        {
            ddlDesignation.DataSource = dt;
            ddlDesignation.DataTextField = "DesignationName";
            ddlDesignation.DataValueField = "DesignationId";
            ddlDesignation.DataBind();

            ddlregDesignation.DataSource = dt;
            ddlregDesignation.DataTextField = "DesignationName";
            ddlregDesignation.DataValueField = "DesignationId";
            ddlregDesignation.DataBind();

        }
        else
        {
            ddlDesignation.DataSource = null;
            ddlDesignation.DataBind();

            ddlregDesignation.DataSource = null;
            ddlregDesignation.DataBind();
        }
        ddlDesignation.Items.Insert(0, new ListItem("---Select---", ""));
        ddlregDesignation.Items.Insert(0, new ListItem("---Select---", ""));
    }
    private void BindCaste()
    {
        utl = new Utilities();
        sqlstr = "sp_GetCaste";
        DataTable dt = new DataTable();
        dt = utl.GetDataTable(sqlstr);

        if (dt != null && dt.Rows.Count > 0)
        {
            ddlCaste.DataSource = dt;
            ddlCaste.DataTextField = "CasteName";
            ddlCaste.DataValueField = "CasteID";
            ddlCaste.DataBind();
        }
        else
        {
            ddlCaste.DataSource = null;
            ddlCaste.DataBind();
        }

    }
    private void BindClass()
    {
        utl = new Utilities();
        sqlstr = "sp_GetClass";
        DataTable dt = new DataTable();
        dt = utl.GetDataTable(sqlstr);

        if (dt != null && dt.Rows.Count > 0)
        {
            ddlClass.DataSource = dt;
            ddlClass.DataTextField = "ClassName";
            ddlClass.DataValueField = "ClassId";
            ddlClass.DataBind();
        }
        else
        {
            ddlClass.DataSource = null;
            ddlClass.DataBind();
        }
        ddlClass.Items.Insert(0, new ListItem("---Select---", ""));
    }
    private void BindModes()
    {
        utl = new Utilities();
        sqlstr = "[sp_GetStaffModes]";
        DataTable dt = new DataTable();
        dt = utl.GetDataTable(sqlstr);

        if (dt != null && dt.Rows.Count > 0)
        {
            ddlModes.DataSource = dt;
            ddlModes.DataTextField = "ModeName";
            ddlModes.DataValueField = "StaffModeId";
            ddlModes.DataBind();
        }
        else
        {
            ddlModes.DataSource = null;
            ddlModes.DataBind();
        }
        ddlModes.Items.Insert(0, new ListItem("---Select---", ""));
    }
    private void BindSubjectUpto()
    {
        utl = new Utilities();
        sqlstr = "[sp_GetSubExperience]";
        DataTable dt = new DataTable();
        dt = utl.GetDataTable(sqlstr);

        if (dt != null && dt.Rows.Count > 0)
        {

            ddlSubject.DataSource = dt;
            ddlSubject.DataTextField = "SubExperienceName";
            ddlSubject.DataValueField = "SubExperienceId";
            ddlSubject.DataBind();

        }
        else
        {
            ddlSubject.DataSource = null;
            ddlSubject.DataBind();
        }
        ddlStudiedUpto.Items.Insert(0, new ListItem("---Select---", ""));
        ddlSubject.Items.Insert(0, new ListItem("---Select---", ""));
    }
    private void BindLanguages()
    {
        utl = new Utilities();
        sqlstr = "[sp_GetLanguage]";
        DataTable dt = new DataTable();
        dt = utl.GetDataTable(sqlstr);

        if (dt != null && dt.Rows.Count > 0)
        {
            ddlLanguagesKnown.DataSource = dt;
            ddlLanguagesKnown.DataTextField = "LanguageName";
            ddlLanguagesKnown.DataValueField = "LanguageId";
            ddlLanguagesKnown.DataBind();
        }
        else
        {
            ddlLanguagesKnown.DataSource = null;
            ddlLanguagesKnown.DataBind();
        }
        ddlLanguagesKnown.Items.Insert(0, new ListItem("---Select---", ""));
    }

    [WebMethod]
    public static Staff InsertStaff(string staffId, string staffName, string staffShortName, string empCode, string sex, string dob, string pob,
        string motherTongue, string nationality, string religionId, string communityId, string caste, string maritalStatus,
        string permAddress, string contactAddress, string phoneNo, string emailId, string mobileNo, string panCard,
        string aadhaarNo, string RationCard, string SmartCard, string FileNo, string LockerNo, string photoFile, string dateOfRetirement, string userId, string PresentStatus, string WorkingCount, string SistersCount)
    {
        string[] formats = { "dd/MM/yyyy" };
        string dOB = string.Empty;
        if (dob != string.Empty)
            dOB = DateTime.ParseExact(dob, formats, new CultureInfo("en-US"), DateTimeStyles.None).ToString();
        string dOR = string.Empty;
        if (dateOfRetirement != string.Empty)
            dOR = DateTime.ParseExact(dateOfRetirement, formats, new CultureInfo("en-US"), DateTimeStyles.None).ToString();
        string fileExtension = photoFile.Substring(photoFile.LastIndexOf('.') + 1);
        Utilities utl = new Utilities(); //cbseconnection
        Utilities1 utl1 = new Utilities1(); //simv1connection
        string sqlstr = string.Empty;
        string strQueryStatus = string.Empty;
        string message = string.Empty;

        if (string.IsNullOrEmpty(staffId)) staffId = "null"; else staffId = "" + staffId + "";

        if (string.IsNullOrEmpty(sex)) sex = "null"; else sex = "'" + sex + "'";

        if (string.IsNullOrEmpty(pob)) pob = "null"; else pob = "'" + pob + "'";

        if (string.IsNullOrEmpty(motherTongue)) motherTongue = "null"; else motherTongue = "'" + motherTongue + "'";

        if (string.IsNullOrEmpty(nationality)) nationality = "null"; else nationality = "'" + nationality + "'";

        if (string.IsNullOrEmpty(religionId)) religionId = "null"; else religionId = "" + religionId + "";

        if (string.IsNullOrEmpty(communityId)) communityId = "null"; else communityId = "" + communityId + "";

        if (string.IsNullOrEmpty(caste)) caste = "null"; else caste = "'" + caste + "'";

        if (string.IsNullOrEmpty(maritalStatus)) maritalStatus = "null"; else maritalStatus = "'" + maritalStatus + "'";

        if (string.IsNullOrEmpty(permAddress)) permAddress = "null"; else permAddress = "'" + permAddress.Replace("'","''") + "'";

        if (string.IsNullOrEmpty(contactAddress)) contactAddress = "null"; else contactAddress = "'" + contactAddress.Replace("'", "''") + "'";

        if (string.IsNullOrEmpty(phoneNo)) phoneNo = "null"; else phoneNo = "'" + phoneNo.Replace("'", "''") + "'";

        if (string.IsNullOrEmpty(emailId)) emailId = "null"; else emailId = "'" + emailId.Replace("'", "''") + "'";

        if (string.IsNullOrEmpty(mobileNo)) mobileNo = "null"; else mobileNo = "'" + mobileNo.Replace("'", "''") + "'";

        if (string.IsNullOrEmpty(panCard)) panCard = "null"; else panCard = "'" + panCard.Replace("'", "''") + "'";

        if (string.IsNullOrEmpty(RationCard)) RationCard = "null"; else RationCard = "'" + RationCard.Replace("'", "''") + "'";

        if (string.IsNullOrEmpty(SmartCard)) SmartCard = "null"; else SmartCard = "'" + SmartCard.Replace("'", "''") + "'";

        if (string.IsNullOrEmpty(FileNo)) FileNo = "null"; else FileNo = "'" + FileNo.Replace("'", "''") + "'";

        if (string.IsNullOrEmpty(LockerNo)) LockerNo = "null"; else LockerNo = "'" + LockerNo + "'";

        if (string.IsNullOrEmpty(dOB)) dOB = "null"; else dOB = "'" + dOB + "'";
        if (string.IsNullOrEmpty(dOR)) dOR = "null"; else dOR = "'" + dOR + "'";
        if (string.IsNullOrEmpty(aadhaarNo)) aadhaarNo = "null"; else aadhaarNo = "'" + aadhaarNo.Replace("'", "''") + "'";
        if (string.IsNullOrEmpty(WorkingCount)) WorkingCount = "null"; else WorkingCount = "'" + WorkingCount + "'";
        if (string.IsNullOrEmpty(SistersCount)) SistersCount = "null"; else SistersCount = "'" + SistersCount + "'";

        string status = string.Empty;
        Staff staff = new Staff();

        //Getting MAX Emp code - Start

        string sqlquery_empcode = "select ISNULL(max(convert(int,empcode)), 0) as empcode from e_Staffinfo";
        int empcde_db1 = Convert.ToInt32(utl.ExecuteScalar(sqlquery_empcode));
        int empcde_db2 = Convert.ToInt32(utl1.ExecuteScalar(sqlquery_empcode));
        int max_empcode;

        if (empcde_db1 == empcde_db2)
        {
            max_empcode = empcde_db1;
            max_empcode = max_empcode + 1;
        }
        else if (empcde_db1 > empcde_db2)
        {
            max_empcode = empcde_db1;
            max_empcode = max_empcode + 1;
        }
        else
        {
            max_empcode = empcde_db2;
            max_empcode = max_empcode + 1;
        }

        //Getting MAX Emp code - End


        //Getting MAX StaffID for Autoincrement issue - Start

        string sqlquery_staffid = "select ISNULL((max(StaffId)),0) as staffid from e_Staffinfo";
        int staffid_db1 = Convert.ToInt32(utl.ExecuteScalar(sqlquery_staffid));
        int staffid_db2 = Convert.ToInt32(utl1.ExecuteScalar(sqlquery_staffid));
        int max_staffid;

        if (staffid_db1 == staffid_db2)
        {
            max_staffid = staffid_db1;           
        }
        else if (staffid_db1 > staffid_db2)
        {
            max_staffid = staffid_db1;           
        }
        else
        {
            max_staffid = staffid_db2;           
        }

        string sqlquery_maxstaffid = "dbcc checkident('e_Staffinfo',reseed," + max_staffid + ")";
        utl.ExecuteQuery(sqlquery_maxstaffid);

        //Getting MAX StaffID for Autoincrement issue - END


        sqlstr = "[sp_InsertStaffInfo] " + staffId + "," + "'" + staffName.Replace("'", "''") + "','" + staffShortName.Replace("'", "''") + "','" + max_empcode.ToString() + "'," + sex + "," + dOB + "," + pob + "," + motherTongue + "," + nationality + "," + religionId + "," + communityId + "," + caste + "," + maritalStatus + "" + "," + permAddress + "," + contactAddress + "," + phoneNo + "," + emailId + "," + mobileNo + "," + panCard + "," + aadhaarNo + "," + RationCard + "," + SmartCard + "," + FileNo + "," + LockerNo + ",''," + dOR + "," + userId + ",'" + PresentStatus + "'," + WorkingCount + "," + SistersCount + "";
        strQueryStatus = utl.ExecuteScalar(sqlstr);
       

        if (staffId != null && staffId != "null")
        {
            sqlstr = "select empcode from e_staffinfo where staffid=" + strQueryStatus + "";
            strQueryStatus = utl.ExecuteScalar(sqlstr);
            string formatedPhoto = strQueryStatus + "." + fileExtension;
            string sqlPhoto = string.Empty;
            string strQueryPhotoStatus = string.Empty;
            if (!string.IsNullOrEmpty(photoFile))
            {
                sqlPhoto = "[SP_UpdatePhotoFile] " + strQueryStatus + "," + "'" + formatedPhoto + "'";
                strQueryPhotoStatus = utl.ExecuteQuery(sqlPhoto);
            }
            if (strQueryStatus == string.Empty)
                status = "Update Failed";
            else
                status = "Updated";


            staff.StaffId = staffId;
            staff.Status = status;
        }
        else
        {
            string formatedPhoto = strQueryStatus + "." + fileExtension;
            string sqlPhoto = string.Empty;
            string strQueryPhotoStatus = string.Empty;
            if (!string.IsNullOrEmpty(photoFile))
            {
                sqlPhoto = "[SP_UpdatePhotoFile] " + strQueryStatus + "," + "'" + formatedPhoto + "'";
                strQueryPhotoStatus = utl.ExecuteQuery(sqlPhoto);

            }

            sqlstr = "select staffid from e_staffinfo where empcode=" + strQueryStatus + "";
            strQueryStatus = utl.ExecuteScalar(sqlstr);

            if (strQueryStatus == string.Empty)
                status = "Insert Failed";
            else
                status = "Inserted";


            staff.StaffId = strQueryStatus;
            staff.Status = status;
        }
        return staff;
    }

    [WebMethod]
    public static string DeleteStaffRelationInfo(int StaffRelID)
    {
        Utilities utl = new Utilities();
        string sqlstr = string.Empty;
        string strQueryStatus = string.Empty;
        string message = string.Empty;
        Userid = Convert.ToInt32(HttpContext.Current.Session["UserId"]);
        strQueryStatus = utl.ExecuteQuery("sp_DeleteStaffRelationInfo " + StaffRelID + "," + Userid + "");
        if (strQueryStatus == "")
            return "Deleted";
        else
            return "Delete Failed";
    }
    [WebMethod]
    public static string GetStaffRelationInfo(int StaffID)
    {
        Utilities utl = new Utilities();
        DataSet ds = new DataSet();
        string query = "sp_GetStaffRelationInfo " + "''" + "," + "''" + "," + "" + StaffID + "";
        return utl.GetDatasetTable(query, "StaffRelations").GetXml();
    }
    [WebMethod]
    public static string EditStaffRelationInfo(int StaffRelID, string Relationship)
    {
        Utilities utl = new Utilities();
        DataSet ds = new DataSet();

        string query = "sp_GetStaffRelationInfo " + StaffRelID + ",'" + Relationship + "'" + "," + "''";
        return utl.GetDatasetTable(query, "StaffRelation").GetXml();
    }
    [WebMethod]
    public static string UpdateStaffRelativeDetails(string staffId, string RelationID, string Relationship, string StaffRelId)
    {
        Utilities utl = new Utilities();
        string sqlstr = string.Empty;
        string strQueryStatus = string.Empty;
        string message = string.Empty;
        Userid = Convert.ToInt32(HttpContext.Current.Session["UserId"]);

        if (!string.IsNullOrEmpty(StaffRelId))
        {
            sqlstr = "sp_UpdateStaffRelativeInfo " + "'" + StaffRelId + "','" + staffId.Replace("'", "''") + "','" + RelationID.Replace("'", "''") + "','" + Relationship + "','" + Userid + "'";
            strQueryStatus = utl.ExecuteQuery(sqlstr);
            if (strQueryStatus == "")
                return "Updated";
            else
                return "Update Failed";
        }
        else
        {
            sqlstr = "sp_InsertStaffRelativeInfo " + "'" + staffId.Replace("'", "''") + "','" + RelationID.Replace("'", "''") + "','" + Relationship + "','" + Userid + "'";
            strQueryStatus = utl.ExecuteQuery(sqlstr);
            if (strQueryStatus == "")
                return "Inserted";
            else
                return "Insert Failed";
        }
    }

    [WebMethod]
    public static string UpdateAcademicDetails(string staffId, string coursecomp, string board, string yoc, string mainSub, string ancSub, string certNo,
        string subDate, string retDate, string type, string filePath, string fileName, int userId, string staffAcdId)
    {
        string[] formats = { "dd/MM/yyyy" };
        string Yoc = string.Empty;
        string sDate = string.Empty;
        string rDate = string.Empty;
        string fileExtension = fileName.Substring(fileName.LastIndexOf('.') + 1);


        if (subDate != string.Empty)
            sDate = DateTime.ParseExact(subDate, formats, new CultureInfo("en-US"), DateTimeStyles.None).ToShortDateString();
        if (retDate != string.Empty)
            rDate = DateTime.ParseExact(retDate, formats, new CultureInfo("en-US"), DateTimeStyles.None).ToShortDateString();

        if (string.IsNullOrEmpty(coursecomp)) coursecomp = "null"; else coursecomp = "'" + coursecomp + "'";
        if (string.IsNullOrEmpty(board)) board = "null"; else board = "'" + board + "'";
        if (string.IsNullOrEmpty(yoc)) yoc = "null"; else yoc = "'" + yoc + "'";
        if (string.IsNullOrEmpty(mainSub)) mainSub = "null"; else mainSub = "" + mainSub + "";
        if (string.IsNullOrEmpty(ancSub)) ancSub = "null"; else ancSub = "" + ancSub + "";
        if (string.IsNullOrEmpty(certNo)) certNo = "null"; else certNo = "'" + certNo + "'";
        if (string.IsNullOrEmpty(sDate)) sDate = "null"; else sDate = "'" + sDate + "'";
        if (string.IsNullOrEmpty(rDate)) rDate = "null"; else rDate = "'" + rDate + "'";
        if (string.IsNullOrEmpty(type)) type = "null"; else type = "'" + type + "'";
        if (string.IsNullOrEmpty(filePath)) filePath = "null"; else filePath = "'" + filePath + "'";
        if (string.IsNullOrEmpty(fileName)) fileName = "null"; else fileName = "'" + fileName + "'";
        if (string.IsNullOrEmpty(staffAcdId)) staffAcdId = "null"; else staffAcdId = "" + staffAcdId + "";
        Utilities utl = new Utilities();
        string sqlstr = "[sp_UpdateStaffAcademicDetails] " + "" + staffId + "," + coursecomp + "," + board + "," + yoc + "," + mainSub + "," + ancSub + "," + certNo +
          "," + sDate + "," + rDate + "," + type + "," + filePath + "," + fileName + "," + userId + "," + staffAcdId + ",'" + fileExtension + "'";
        string strQueryStatus = utl.ExecuteScalar(sqlstr);

        if (strQueryStatus == "")
            return "";
        else
            return strQueryStatus;
    }


    [WebMethod]
    public static string UpdateCourseDetails(string staffUndGngId, string staffId, string course, string board, string main, string yoc, string userid)
    {
        if (string.IsNullOrEmpty(staffUndGngId)) staffUndGngId = "null"; else staffUndGngId = "'" + staffUndGngId + "'";
        if (string.IsNullOrEmpty(course)) course = "null"; else course = "'" + course + "'";
        if (string.IsNullOrEmpty(board)) board = "null"; else board = "'" + board + "'";
        if (string.IsNullOrEmpty(main)) main = "null"; else main = "" + main + "";
        if (string.IsNullOrEmpty(yoc)) yoc = "null"; else yoc = "'" + yoc + "'";

        Utilities utl = new Utilities();
        string sqlstr1 = "[sp_UpdateStaffCourseDetails]" + staffUndGngId + "," + staffId + "," + course + "," + board + "," + main + "," + yoc + "," + userid + "";
        string strQueryStatus1 = utl.ExecuteQuery(sqlstr1);

        if (strQueryStatus1 == string.Empty)
            return "Updated";
        else
            return "Update Failed";
    }

    [WebMethod]

    public static string UpdateFamilyDetails(string staffFamilyId, string staffId, string relId, string name, string dob, string sex, string qaul,
        string occup, string addr, string contno, string userId)
    {

        string[] formats = { "dd/MM/yyyy" };
        string dOB = string.Empty;

        if (!string.IsNullOrEmpty(dob))
            dOB = DateTime.ParseExact(dob, formats, new CultureInfo("en-US"), DateTimeStyles.None).ToShortDateString();

        if (string.IsNullOrEmpty(relId)) relId = "null"; else relId = "" + relId + "";
        if (string.IsNullOrEmpty(name)) name = "null"; else name = "'" + name.Replace("'", "''") + "'";
        if (string.IsNullOrEmpty(dOB)) dOB = "null"; else dOB = "'" + dOB + "'";
        if (string.IsNullOrEmpty(sex)) sex = "null"; else sex = "'" + sex + "'";
        if (string.IsNullOrEmpty(qaul)) qaul = "null"; else qaul = "'" + qaul.Replace("'", "''") + "'";
        if (string.IsNullOrEmpty(occup)) occup = "null"; else occup = "'" + occup.Replace("'", "''") + "'";
        if (string.IsNullOrEmpty(addr)) addr = "null"; else addr = "'" + addr.Replace("'", "''") + "'";
        if (string.IsNullOrEmpty(contno)) contno = "null"; else contno = "'" + contno + "'";

        Utilities utl = new Utilities();
        string sqlstr = "[sp_UpdateStaffFamilyDetails] '" + staffFamilyId + "','" + staffId + "','" + relId + "'," + name + "," + dOB + "," + sex + "," + qaul +
          "," + occup + "," + addr + "," + contno + "," + userId + "";
        string strQueryStatus = utl.ExecuteQuery(sqlstr);
        if (strQueryStatus == "")
            return "Updated";
        else
            return "Update Failed";

    }

    [WebMethod]
    public static string UpdateNomineeDetails(string staffId, string relId, string name, string addr, string dob, string sex, string share,
        string type, string contactNo, string userId)
    {
        string[] formats = { "dd/MM/yyyy" };
        string dOB = string.Empty;
        if (!string.IsNullOrEmpty(dob))
            dOB = DateTime.ParseExact(dob, formats, new CultureInfo("en-US"), DateTimeStyles.None).ToShortDateString();

        if (string.IsNullOrEmpty(relId)) relId = "null"; else relId = "" + relId + "";
        if (string.IsNullOrEmpty(name)) name = "null"; else name = "'" + name + "'";
        if (string.IsNullOrEmpty(addr)) addr = "null"; else addr = "'" + addr + "'";
        if (string.IsNullOrEmpty(dOB)) dOB = "null"; else dOB = "'" + dOB + "'";
        if (string.IsNullOrEmpty(sex)) sex = "null"; else sex = "'" + sex + "'";
        if (string.IsNullOrEmpty(share)) share = "null"; else share = "" + share + "";
        if (string.IsNullOrEmpty(type)) type = "null"; else type = "'" + type + "'";
        if (string.IsNullOrEmpty(contactNo)) contactNo = "null"; else contactNo = "'" + contactNo + "'";

        Utilities utl = new Utilities();
        string sqlstr = "[sp_UpdateStaffNomineeDetails] " + "" + staffId + "," + name + "," + addr + "," + relId + "," + dOB + "," + sex + "," + share +
          "," + type + "," + contactNo + "," + userId + "";
        string strQueryStatus = utl.ExecuteQuery(sqlstr);
        if (strQueryStatus == "")
            return "Updated";
        else
            return "Update Failed";

    }


    [WebMethod]
    public static string UpdateMedicalDetails(string staffId, string bloodGroupId, string disorders, string height, string weight, string emergencyPhNo, string doctor,
        string docAddr, string docPhNo, string idMarks, string isHandicap, string handicapDetail, int userId)
    {
        if (string.IsNullOrEmpty(bloodGroupId)) bloodGroupId = "null"; else bloodGroupId = "" + bloodGroupId + "";
        if (string.IsNullOrEmpty(disorders)) disorders = "null"; else disorders = "'" + disorders + "'";
        if (string.IsNullOrEmpty(height)) height = "null"; else height = "" + height + "";
        if (string.IsNullOrEmpty(weight)) weight = "null"; else weight = "" + weight + "";
        if (string.IsNullOrEmpty(emergencyPhNo)) emergencyPhNo = "null"; else emergencyPhNo = "'" + emergencyPhNo + "'";
        if (string.IsNullOrEmpty(doctor)) doctor = "null"; else doctor = "'" + doctor + "'";
        if (string.IsNullOrEmpty(docAddr)) docAddr = "null"; else docAddr = "'" + docAddr + "'";
        if (string.IsNullOrEmpty(docPhNo)) docPhNo = "null"; else docPhNo = "'" + docPhNo + "'";
        if (idMarks.ToLower() == ";") idMarks = "null"; else idMarks = "'" + idMarks + "'";
        if (string.IsNullOrEmpty(isHandicap)) isHandicap = "null"; else isHandicap = "'" + isHandicap + "'";
        if (string.IsNullOrEmpty(handicapDetail)) handicapDetail = "null"; else handicapDetail = "'" + handicapDetail + "'";

        Utilities utl = new Utilities();
        string sqlstr = "[sp_UpdateStaffMedicalDetails] " + "" + staffId + "," + bloodGroupId + "," + disorders + "," + height + "," + weight + "," + emergencyPhNo + "," + doctor +
          "," + docAddr + "," + docPhNo + "," + idMarks + "," + isHandicap + "," + handicapDetail + "," + userId + "";
        string sql = string.Empty;
        string strQueryStatus = utl.ExecuteQuery(sqlstr);
        string str = string.Empty;
        if (strQueryStatus == "")
        {
            return "Updated";
        }
        else
            return "Update Failed";
    }

    [WebMethod]
    public static string UpdateMedicalRemarkDetails(string staffMedRecId, string staffId, string reason, string recordDate, string fileName, string filePath, string userId)
    {
        string[] formats = { "dd/MM/yyyy" };
        string date = DateTime.ParseExact(recordDate, formats, new CultureInfo("en-US"), DateTimeStyles.None).ToShortDateString();
        string fileExtension = fileName.Substring(fileName.LastIndexOf('.') + 1);
        if (string.IsNullOrEmpty(staffMedRecId)) staffMedRecId = "null"; else staffMedRecId = "" + staffMedRecId + "";
        if (string.IsNullOrEmpty(reason)) reason = "null"; else reason = "'" + reason + "'";
        if (string.IsNullOrEmpty(date)) date = "null"; else date = "'" + date + "'";
        if (string.IsNullOrEmpty(fileName)) fileName = "null"; else fileName = "'" + fileName + "'";
        if (string.IsNullOrEmpty(filePath)) filePath = "null"; else filePath = "'" + filePath + "'";
        Utilities utl = new Utilities();
        string sql = string.Empty;
        string str = string.Empty;

        sql = " exec sp_UpdateStaffMedicalRecordDetails " + staffMedRecId + "," + staffId + "," + reason + "," + date + "," + fileName + "," + filePath + "," + userId + ",'" + fileExtension + "'";
        str = utl.ExecuteScalar(sql);
        if (str != string.Empty)
            return str;
        else
            return "";

    }

    [WebMethod]
    public static string UpdateServiceAppDetails(string staffAcdServiceId, string staffId, string acdId, string doj, string desg, string dept, string pow, string subHandle, string classAllocate, string mode, string userId)
    {
        string[] formats = { "dd/MM/yyyy" };
        string dojFormat = DateTime.ParseExact(doj, formats, new CultureInfo("en-US"), DateTimeStyles.None).ToShortDateString();

        if (string.IsNullOrEmpty(staffAcdServiceId)) staffAcdServiceId = "null"; else staffAcdServiceId = "" + staffAcdServiceId + "";
        if (string.IsNullOrEmpty(dojFormat)) dojFormat = "null"; else dojFormat = "'" + dojFormat + "'";
        if (string.IsNullOrEmpty(desg)) desg = "null"; else desg = "" + desg + "";
        if (string.IsNullOrEmpty(dept)) dept = "null"; else dept = "" + dept + "";
        if (string.IsNullOrEmpty(pow)) pow = "null"; else pow = "'" + pow + "'";
        if (string.IsNullOrEmpty(subHandle)) subHandle = "null"; else subHandle = "" + subHandle + "";
        if (string.IsNullOrEmpty(classAllocate)) classAllocate = "null"; else classAllocate = "" + classAllocate + "";
        if (string.IsNullOrEmpty(mode)) mode = "null"; else mode = "" + mode + "";

        Utilities utl = new Utilities();
        string sqlstr1 = "[sp_UpdateServiceAppDetails] " + staffAcdServiceId + ", " + staffId + "," + acdId + "," + desg + "," + dept + "," + pow + "," + subHandle + "," + classAllocate + "," + mode + "," + dojFormat + "," + userId + "";
        string strQueryStatus1 = utl.ExecuteQuery(sqlstr1);
        string strQueryStatus2 = string.Empty;
        string strQueryStatus3 = string.Empty;
        string sql = string.Empty;

        sqlstr1 = "Update T set T.DepartmentID=S.DepartmentID,T.DesignationID=s.DesignationID,T.PlaceofWorkID=s.PlaceofWork from e_staffinfo T inner join  e_staffacdservices S on T.StaffId=S.StaffID where S.StaffAcdServiceID=(select  top 1 a.StaffAcdServiceID from e_staffacdservices a where a.StaffID='" + staffId + "' and a.StaffAcdServiceID='" + staffAcdServiceId + "' order by StaffAcdServiceId desc)  and T.StaffID='" + staffId + "' and S.StaffAcdServiceID='" + staffAcdServiceId + "'";

        //utl.ExecuteQuery(sqlstr1);

        if (strQueryStatus1 == string.Empty)
        {
            return "Updated";
        }
        else
            return "Update Failed";

    }
    [WebMethod]
    public static string UpdateStaffLanguageDetails(string staffLangServiceId, string staffId, string language, string studied, string userId)
    {
        if (string.IsNullOrEmpty(staffLangServiceId) || staffLangServiceId == "'null'") staffLangServiceId = "null"; else staffLangServiceId = "'" + staffLangServiceId + "'";
        if (staffLangServiceId == "null")
        {
            staffLangServiceId = null;
        }
        if (string.IsNullOrEmpty(language)) language = "null"; else language = "" + language + "";
        if (string.IsNullOrEmpty(studied)) studied = "null"; else studied = "" + studied + "";

        Utilities utl = new Utilities();
        string sqlstr1 = "[sp_UpdateStaffLanguageDetails]'" + staffLangServiceId + "'," + staffId + "," + language + ",'" + studied + "'," + userId + "";
        string strQueryStatus1 = utl.ExecuteQuery(sqlstr1);

        if (strQueryStatus1 == string.Empty)
            return "Updated";
        else
            return "Update Failed";
    }
    [WebMethod]
    public static string UpdateLangKnown(string staffLangKnownId, string staffId, string language, string isRead, string isWrite, string isSpeak, string userId)
    {
        if (string.IsNullOrEmpty(staffLangKnownId)) staffLangKnownId = "null"; else staffLangKnownId = "" + staffLangKnownId + "";
        if (string.IsNullOrEmpty(language)) language = "null"; else language = "" + language + "";
        if (string.IsNullOrEmpty(isRead)) isRead = "null"; else isRead = "'" + isRead + "'";
        if (string.IsNullOrEmpty(isWrite)) isWrite = "null"; else isWrite = "'" + isWrite + "'";
        if (string.IsNullOrEmpty(isSpeak)) isSpeak = "null"; else isSpeak = "'" + isSpeak + "'";

        Utilities utl = new Utilities();
        string sqlstr1 = "[sp_UpdateStaffLanguageKnownDetails]" + staffLangKnownId + "," + staffId + "," + language + "," + isRead + "," + isWrite + "," + isSpeak + "," + userId + "";
        string strQueryStatus1 = utl.ExecuteQuery(sqlstr1);

        if (strQueryStatus1 == string.Empty)
            return "Updated";
        else
            return "Update Failed";
    }
    [WebMethod]
    public static string UpdateCareerDetails(string staffCareerServiceId, string staffId, string orderNo, string careerServiceDate, string placeofwork, string designationId,
         string probationPeriod, string completionOrderNo, string completionDate, string acdFromDate, string acdToDate, string userId, string description, string salarydescription,string building)
    {
        string[] formats = { "dd/MM/yyyy" };
        string dateFormat = DateTime.ParseExact(careerServiceDate, formats, new CultureInfo("en-US"), DateTimeStyles.None).ToShortDateString();
        string comFormat = string.Empty;
        if (!string.IsNullOrEmpty(completionDate))
            comFormat = DateTime.ParseExact(completionDate, formats, new CultureInfo("en-US"), DateTimeStyles.None).ToShortDateString();

        if (string.IsNullOrEmpty(staffCareerServiceId)) staffCareerServiceId = "null"; else staffCareerServiceId = "" + staffCareerServiceId + "";
        if (string.IsNullOrEmpty(orderNo)) orderNo = "null"; else orderNo = "'" + orderNo + "'";
        if (string.IsNullOrEmpty(dateFormat)) dateFormat = "null"; else dateFormat = "'" + dateFormat + "'";
        if (string.IsNullOrEmpty(comFormat)) comFormat = "null"; else comFormat = "'" + comFormat + "'";
        if (string.IsNullOrEmpty(placeofwork)) placeofwork = "null"; else placeofwork = "'" + placeofwork + "'";
        if (string.IsNullOrEmpty(designationId)) designationId = "null"; else designationId = "" + designationId + "";
        if (string.IsNullOrEmpty(probationPeriod)) probationPeriod = "null"; else probationPeriod = "'" + probationPeriod + "'";
        if (string.IsNullOrEmpty(completionOrderNo)) completionOrderNo = "null"; else completionOrderNo = "'" + completionOrderNo + "'";
        if (string.IsNullOrEmpty(completionDate)) completionDate = "null"; else completionDate = "'" + completionDate + "'";
        if (string.IsNullOrEmpty(acdFromDate)) acdFromDate = "null"; else acdFromDate = "'" + acdFromDate + "'";
        if (string.IsNullOrEmpty(acdToDate)) acdToDate = "null"; else acdToDate = "'" + acdToDate + "'";
        if (string.IsNullOrEmpty(description)) description = "null"; else description = "'" + description.Replace("'","''") + "'";
        if (string.IsNullOrEmpty(description)) salarydescription = "null"; else salarydescription = "'" + salarydescription.Replace("'", "''") + "'";
        if (string.IsNullOrEmpty(building)) building = "null"; else building = "'" + building + "'";
        Utilities utl = new Utilities();
        string sqlstr1 = "[sp_UpdateCareerServiceDetails] " + staffCareerServiceId + "," + staffId + "," + orderNo + "," + dateFormat + "," + placeofwork + "," + designationId + "," + probationPeriod + "," + completionOrderNo + "," + comFormat + "," + acdFromDate + "," + acdToDate + "," + userId + "," + description + "," + salarydescription + "," + building + ",'" + HttpContext.Current.Session["AcademicID"] + "'";
        string strQueryStatus1 = utl.ExecuteQuery(sqlstr1);

        sqlstr1 = "Update T set T.DesignationID=S.DesignationID,T.PlaceofWorkID=s.PlaceofWork,T.BuildingID=S.Building from e_staffinfo T inner join  e_staffcareerservice S on T.StaffId=S.StaffID  and S.isactive=1 where S.StaffCareerServiceID=(select  top 1 a.StaffCareerServiceID from e_staffcareerservice a where a.StaffID='" + staffId + "' and a.AcdToDate=(select max(AcdToDate) from  e_staffcareerservice where StaffID='" + staffId + "' and isactive=1) and T.StaffID='" + staffId + "'";
        utl.ExecuteQuery(sqlstr1);



        if (strQueryStatus1 == string.Empty)
        {
            return "Updated";
        }
        else
            return "Update Failed";
    }
    [WebMethod]
    public static string UpdateInvDetails(string staffExtInvId, string staffId, string year, string schoolName, string place,
         string invId, string userId)
    {
        if (string.IsNullOrEmpty(staffExtInvId)) staffExtInvId = "null"; else staffExtInvId = "" + staffExtInvId + "";
        if (string.IsNullOrEmpty(year)) year = "null"; else year = "'" + year + "'";
        if (string.IsNullOrEmpty(schoolName)) schoolName = "null"; else schoolName = "'" + schoolName + "'";
        if (string.IsNullOrEmpty(place)) place = "null"; else place = "'" + place + "'";
        if (string.IsNullOrEmpty(invId)) invId = "null"; else invId = "" + invId + "";

        Utilities utl = new Utilities();
        string sqlstr1 = "[sp_UpdateStaffInvigilation] " + staffExtInvId + "," + staffId + "," + year + "," + schoolName + "," + place + "," + invId + "," + userId + "";
        string strQueryStatus1 = utl.ExecuteQuery(sqlstr1);
        if (strQueryStatus1 == string.Empty)
        {
            return "Updated";
        }
        else
            return "Update Failed";
    }

    [WebMethod]
    public static string UpdateResignDetails(string staffResignId, string staffId, string year, string reason, string certDate, string resDate,
         string userId)
    {
        string[] formats = { "dd/MM/yyyy" };
        string certFormat = string.Empty;
        if (!string.IsNullOrEmpty(certDate))
            certFormat = DateTime.ParseExact(certDate, formats, new CultureInfo("en-US"), DateTimeStyles.None).ToShortDateString();
        string resFormat = string.Empty;
        if (!string.IsNullOrEmpty(resDate))
            resFormat = DateTime.ParseExact(resDate, formats, new CultureInfo("en-US"), DateTimeStyles.None).ToShortDateString();

        if (string.IsNullOrEmpty(staffResignId)) staffResignId = "null"; else staffResignId = "" + staffResignId + "";
        if (string.IsNullOrEmpty(year)) year = "null"; else year = "'" + year + "'";
        if (string.IsNullOrEmpty(reason)) reason = "null"; else reason = "'" + reason + "'";
        if (string.IsNullOrEmpty(certFormat)) certFormat = "null"; else certFormat = "'" + certFormat + "'";
        if (string.IsNullOrEmpty(resFormat)) resFormat = "null"; else resFormat = "'" + resFormat + "'";

        Utilities utl = new Utilities();
        string sqlstr1 = "[sp_UpdateStaffResignation] " + staffResignId + "," + staffId + "," + year + "," + reason + "," + certFormat + "," + resFormat + "," + userId + "";
        string strQueryStatus1 = utl.ExecuteQuery(sqlstr1);
        if (strQueryStatus1 == string.Empty)
        {
            return "Updated";
        }
        else
            return "Update Failed";
    }

    [WebMethod]
    public static string UpdateBankDetails(string staffId, string bankStatus, string bankName, string bankBranchCode, string accNo, string epfCode, string userId)
    {
        if (string.IsNullOrEmpty(bankStatus)) bankStatus = "null"; else bankStatus = "'" + bankStatus + "'";
        if (string.IsNullOrEmpty(bankName)) bankName = "null"; else bankName = "'" + bankName + "'";
        if (string.IsNullOrEmpty(bankBranchCode)) bankBranchCode = "null"; else bankBranchCode = "'" + bankBranchCode + "'";
        if (string.IsNullOrEmpty(accNo)) accNo = "null"; else accNo = "'" + accNo + "'";
        if (string.IsNullOrEmpty(epfCode)) epfCode = "null"; else epfCode = "'" + epfCode + "'";


        Utilities utl = new Utilities();
        string sqlstr = "[sp_UpdateStaffBankDetails] " + "" + staffId + "," + bankStatus + "," + bankName + "," + bankBranchCode + "," + accNo + "," + epfCode + "," + userId + "";
        string strQueryStatus = utl.ExecuteQuery(sqlstr);
        if (strQueryStatus == "")
            return "Updated";
        else
            return "Update Failed";
    }

    [WebMethod]
    public static string UpdateLeaveDetails(string staffId, string acdYear, string leaveId, string reason, string from, string to, string noOfLeave, string fileName, string filePath, string userId, string staffLeaveId)
    {
        string[] formats = { "dd/MM/yyyy" };
        string fFrom = DateTime.ParseExact(from, formats, new CultureInfo("en-US"), DateTimeStyles.None).ToShortDateString();
        string fTo = DateTime.ParseExact(to, formats, new CultureInfo("en-US"), DateTimeStyles.None).ToShortDateString();
        string fileExtension = fileName.Substring(fileName.LastIndexOf('.') + 1);

        if (string.IsNullOrEmpty(fFrom)) fFrom = "null"; else fFrom = "'" + fFrom + "'";
        if (string.IsNullOrEmpty(fTo)) fTo = "null"; else fTo = "'" + fTo + "'";
        if (string.IsNullOrEmpty(noOfLeave)) noOfLeave = "null"; else noOfLeave = "" + noOfLeave + "";
        if (string.IsNullOrEmpty(fileName)) fileName = "null"; else fileName = "'" + fileName + "'";
        if (string.IsNullOrEmpty(filePath)) filePath = "null"; else filePath = "'" + filePath + "'";
        if (string.IsNullOrEmpty(staffLeaveId)) staffLeaveId = "null"; else staffLeaveId = "'" + staffLeaveId + "'";
        if (string.IsNullOrEmpty(fileExtension)) fileExtension = "null"; else fileExtension = "'" + fileExtension + "'";
        string query = "[sp_UpdateStaffLeaveDetails] " + staffId + ",'" + acdYear + "'," + leaveId + ",'" + reason + "'," + fFrom + "," + fTo + "," + noOfLeave + "," + fileName + "," + filePath + "," + userId + "," + staffLeaveId + "," + fileExtension + ",0";
        string sqlstr = string.Empty;
        Utilities utl = new Utilities();
        sqlstr = utl.ExecuteScalar(query);
        if (sqlstr != string.Empty)
            return sqlstr;
        else
            return "";
    }

    [WebMethod]
    public static string UpdateRemarkDetails(string staffId, string remDate, string title, string reason, string fileName, string filePath, string userId)
    {
        string[] formats = { "dd/MM/yyyy" };
        string rem = DateTime.ParseExact(remDate, formats, new CultureInfo("en-US"), DateTimeStyles.None).ToShortDateString();
        string fileExtension = fileName.Substring(fileName.LastIndexOf('.') + 1);

        if (string.IsNullOrEmpty(title)) title = "null"; else title = "'" + title + "'";
        if (string.IsNullOrEmpty(rem)) rem = "null"; else rem = "'" + rem + "'";
        if (string.IsNullOrEmpty(reason)) reason = "null"; else reason = "'" + reason + "'";
        if (string.IsNullOrEmpty(fileName)) fileName = "null"; else fileName = "'" + fileName + "'";
        if (string.IsNullOrEmpty(filePath)) filePath = "null"; else filePath = "'" + filePath + "'";

        Utilities utl = new Utilities();
        string sqlstr = "[sp_UpdateStaffRemarkDetails] " + "" + staffId + "," + rem + "," + title + "," + reason + "," + fileName + "," + filePath + "," + userId + ",'" + fileExtension + "'";
        string strQueryStatus = utl.ExecuteScalar(sqlstr);
        if (strQueryStatus != string.Empty)
            return strQueryStatus;
        else
            return "";
    }
    [WebMethod]
    public static string UpdatePunishementDetails(string staffId, string punishDate, string title, string reason, string fileName, string filePath, string userId)
    {
        string[] formats = { "dd/MM/yyyy" };
        string punish = DateTime.ParseExact(punishDate, formats, new CultureInfo("en-US"), DateTimeStyles.None).ToShortDateString();
        string fileExtension = fileName.Substring(fileName.LastIndexOf('.') + 1);

        if (string.IsNullOrEmpty(title)) title = "null"; else title = "'" + title + "'";
        if (string.IsNullOrEmpty(reason)) reason = "null"; else reason = "'" + reason + "'";
        if (string.IsNullOrEmpty(punish)) punish = "null"; else punish = "'" + punish + "'";
        if (string.IsNullOrEmpty(fileName)) fileName = "null"; else fileName = "'" + fileName + "'";
        if (string.IsNullOrEmpty(filePath)) filePath = "null"; else filePath = "'" + filePath + "'";
        Utilities utl = new Utilities();
        string sqlstr = "[sp_UpdateStaffPunishmentDetails] " + "" + staffId + "," + punish + "," + title + "," + reason + "," + fileName + "," + filePath + "," + userId + ",'" + fileExtension + "'";
        string strQueryStatus = utl.ExecuteScalar(sqlstr);
        if (strQueryStatus != string.Empty)
            return strQueryStatus;
        else
            return "";
    }
    [WebMethod]
    public static string UpdateRetirementDetails(string staffId, string retDate, string title, string reason, string fileName, string filePath, string userId)
    {
        string[] formats = { "dd/MM/yyyy" };
        string ret = DateTime.ParseExact(retDate, formats, new CultureInfo("en-US"), DateTimeStyles.None).ToShortDateString();
        string fileExtension = fileName.Substring(fileName.LastIndexOf('.') + 1);

        if (string.IsNullOrEmpty(title)) title = "null"; else title = "'" + title + "'";
        if (string.IsNullOrEmpty(reason)) reason = "null"; else reason = "'" + reason + "'";
        if (string.IsNullOrEmpty(ret)) ret = "null"; else ret = "'" + ret + "'";
        if (string.IsNullOrEmpty(fileName)) fileName = "null"; else fileName = "'" + fileName + "'";
        if (string.IsNullOrEmpty(filePath)) filePath = "null"; else filePath = "'" + filePath + "'";
        Utilities utl = new Utilities();
        string sqlstr = "[sp_UpdateStaffRetirementDetails] " + "" + staffId + "," + ret + "," + title + "," + reason + "," + fileName + "," + filePath + "," + userId + ",'" + fileExtension + "'";
        string strQueryStatus = utl.ExecuteScalar(sqlstr);
        if (strQueryStatus == "")
            return "";
        else
            return strQueryStatus;
    }
    [WebMethod]
    public static string EditFamilyDetails(int StaffFamilyId)
    {
        Utilities utl = new Utilities();
        string query = "sp_GetStaffFamilyById " + StaffFamilyId + "";
        return utl.GetDatasetTable(query, "EditFamily").GetXml();
    }
    [WebMethod]
    public static string GetFamilyDetails(int staffId)
    {
        Utilities utl = new Utilities();
        string query = "[GetStaffFamilyById] " + staffId + "";
        return utl.GetDatasetTable(query, "Family").GetXml();
    }
    [WebMethod]
    public static string GetNomineeDetails(int staffId)
    {
        Utilities utl = new Utilities();
        string query = "GetStaffNomineeById " + staffId + "";
        return utl.GetDatasetTable(query, "Nominee").GetXml();
    }
    [WebMethod]
    public static string GetLeaveDetails(string staffId, string academicId, string staffLeaveId)
    {
        Utilities utl = new Utilities();
        string query = string.Empty;
        if (staffLeaveId == string.Empty)
            query = "[sp_GetStaffLeaveId] " + staffId + "," + academicId + ",''";
        else
            query = "[sp_GetStaffLeaveId] '',''," + staffLeaveId + "";

        return utl.GetDatasetTable(query, "Leave").GetXml();
    }
    [WebMethod]
    public static string GetRemarkDetails(string staffId)
    {
        Utilities utl = new Utilities();
        string query = string.Empty;
        query = "[sp_GetStaffRemark] " + staffId + "";
        return utl.GetDatasetTable(query, "Remark").GetXml();
    }
    [WebMethod]
    public static string GetPunishDetails(string staffId)
    {
        Utilities utl = new Utilities();
        string query = string.Empty;
        query = "[sp_GetStaffPunish] " + staffId + "";
        return utl.GetDatasetTable(query, "Punish").GetXml();
    }
    [WebMethod]
    public static string GetRetireDetails(string staffId)
    {
        Utilities utl = new Utilities();
        string query = string.Empty;
        query = "[sp_GetStaffRetire] " + staffId + "";
        return utl.GetDatasetTable(query, "Retire").GetXml();
    }
    [WebMethod]
    public static string GetPersonalDetails(string staffId)
    {
        Utilities utl = new Utilities();
        string query = string.Empty;
        query = "[sp_GetStaffPersonalInfo] " + staffId + "";
        return utl.GetDatasetTable(query, "Personal").GetXml();
    }
    [WebMethod]
    public static string GetAcademicDetails(string staffId, string staffAcdId)
    {
        Utilities utl = new Utilities();
        string query = string.Empty;
        if (string.IsNullOrEmpty(staffId))
            staffId = "''";

        if (string.IsNullOrEmpty(staffAcdId))
            staffAcdId = "''";

        query = "[sp_GetStaffAcademicInfo] " + staffId + "," + staffAcdId + "";
        return utl.GetDatasetTable(query, "Academic").GetXml();
    }
    [WebMethod]
    public static string GetCourseDetails(string staffId)
    {
        Utilities utl = new Utilities();
        string query = string.Empty;
        query = "[sp_GetStaffCourseInfo] " + staffId + "";
        return utl.GetDatasetTable(query, "StaffCourse").GetXml();
    }
    [WebMethod]
    public static string GetMedicalRemarks(string staffId)
    {
        Utilities utl = new Utilities();
        string query = string.Empty;
        query = "[sp_GetStaffMedicalRecords] " + staffId + "";

        return utl.GetDatasetTable(query, "MedicalRecords").GetXml();
    }
    [WebMethod]
    public static string GetSubjectDetails(string staffId)
    {
        Utilities utl = new Utilities();
        string query = string.Empty;
        query = "[sp_GetStaffSubjectDetails] " + staffId + "";

        return utl.GetDatasetTable(query, "SubjectDetails").GetXml();
    }
    [WebMethod]
    public static string GetLangKnown(string staffId)
    {
        Utilities utl = new Utilities();
        string query = string.Empty;
        query = "sp_GetStaffLangKnownDetails " + staffId + "";

        return utl.GetDatasetTable(query, "LangKnownDetails").GetXml();
    }
    [WebMethod]
    public static string GetServiceDetails(string staffId)
    {
        Utilities utl = new Utilities();
        string query = string.Empty;
        query = "[sp_GetServiceAppDetails] " + staffId + "";

        return utl.GetDatasetTable(query, "Service").GetXml();
    }
    [WebMethod]
    public static string GetCareerDetails(string staffId, string staffCareerServiceId)
    {
        if (string.IsNullOrEmpty(staffCareerServiceId))
            staffCareerServiceId = "''";

        if (string.IsNullOrEmpty(staffId))
            staffId = "''";

        Utilities utl = new Utilities();
        string query = string.Empty;
        query = "[sp_GetStaffCareerDetails] " + staffId + "," + staffCareerServiceId + "";

        return utl.GetDatasetTable(query, "CareerService").GetXml();
    }
    [WebMethod]
    public static string GetInvDetails(string staffId, string staffExtInvId)
    {
        if (string.IsNullOrEmpty(staffExtInvId))
            staffExtInvId = "''";

        if (string.IsNullOrEmpty(staffId))
            staffId = "''";

        Utilities utl = new Utilities();
        string query = string.Empty;
        query = "[sp_GetStaffInvigilationDetails] " + staffId + "," + staffExtInvId + "";

        return utl.GetDatasetTable(query, "InvService").GetXml();
    }
    [WebMethod]
    public static string GetResignDetails(string staffId)
    {
        Utilities utl = new Utilities();
        string query = string.Empty;
        query = "[sp_GetStaffResignDetails] " + staffId + "";

        return utl.GetDatasetTable(query, "Resign").GetXml();
    }
    [WebMethod]
    public static string EditServiceDetails(string staffServiceId)
    {
        Utilities utl = new Utilities();
        string query = string.Empty;
        query = "[sp_GetServiceAppDetails] '', " + staffServiceId + "";

        return utl.GetDatasetTable(query, "EditService").GetXml();
    }
    [WebMethod]
    public static string DeleteAcademicDetails(int userId, int staffAcdId)
    {
        Utilities utl = new Utilities();
        string query = "[sp_DeleteStaffAcademic] " + staffAcdId + "," + userId + "";
        string strQueryStatus = utl.ExecuteQuery(query);
        if (strQueryStatus == "")
            return "Delete";
        else
            return "Failed";
    }
    [WebMethod]
    public static string DeleteFamilyDetails(int staffFamilyId, int userId)
    {
        Utilities utl = new Utilities();
        string query = "[sp_DeleteStaffFamily] " + staffFamilyId + "," + userId + "";
        string strQueryStatus = utl.ExecuteQuery(query);
        if (strQueryStatus == "")
            return "Deleted";
        else
            return "Delete Failed";
    }
    [WebMethod]
    public static string DeleteNomineeDetails(int staffNomineeId, int userId)
    {
        Utilities utl = new Utilities();
        string query = "[sp_DeleteNomineeFamily] " + staffNomineeId + "," + userId + "";
        string strQueryStatus = utl.ExecuteQuery(query);
        if (strQueryStatus == "")
            return "Deleted";
        else
            return "Delete Failed";
    }
    [WebMethod]
    public static string DeleteLeaveDetails(int staffLeaveId, int userId)
    {
        Utilities utl = new Utilities();
        string query = "[sp_DeleteStaffLeave] " + staffLeaveId + "," + userId + "";
        string strQueryStatus = utl.ExecuteQuery(query);
        if (strQueryStatus == "")
            return "Deleted";
        else
            return "Delete Failed";
    }
    [WebMethod]
    public static string DeleteRemarkDetails(int staffRemarkId, int userId)
    {
        Utilities utl = new Utilities();
        string query = "[sp_DeleteStaffRemark] " + staffRemarkId + "," + userId + "";
        string strQueryStatus = utl.ExecuteQuery(query);
        if (strQueryStatus == "")
            return "Deleted";
        else
            return "Delete Failed";
    }
    [WebMethod]
    public static string DeletePunishDetails(int staffPunishId, int userId)
    {
        Utilities utl = new Utilities();
        string query = "[sp_DeleteStaffPunish] " + staffPunishId + "," + userId + "";
        string strQueryStatus = utl.ExecuteQuery(query);
        if (strQueryStatus == "")
            return "Deleted";
        else
            return "Delete Failed";
    }
    [WebMethod]
    public static string DeleteRetireDetails(int staffRetireId, int userId)
    {
        Utilities utl = new Utilities();
        string query = "[sp_DeleteStaffRetire] " + staffRetireId + "," + userId + "";
        string strQueryStatus = utl.ExecuteQuery(query);
        if (strQueryStatus == "")
            return "Deleted";
        else
            return "Delete Failed";
    }
    [WebMethod]
    public static string DeleteCourseDetails(int staffUndGngId, int userId)
    {
        Utilities utl = new Utilities();
        string query = "[sp_DeleteStaffCourse] " + staffUndGngId + "," + userId + "";
        string strQueryStatus = utl.ExecuteQuery(query);
        if (strQueryStatus == "")
            return "Delete";
        else
            return "Failed";
    }

    [WebMethod]
    public static string DeleteMedicalRemarkDetails(string staffMedRecId, string userId)
    {
        Utilities utl = new Utilities();
        string query = "[sp_DeleteStaffMedicalRecords] " + staffMedRecId + "," + userId + "";
        string strQueryStatus = utl.ExecuteQuery(query);
        if (strQueryStatus == "")
            return "Delete";
        else
            return "Failed";
    }
    [WebMethod]
    public static string DeleteSubDetails(string staffLangServiceId, string userId)
    {
        Utilities utl = new Utilities();
        string query = "[sp_DeleteStaffSubjectDetail] " + staffLangServiceId + "," + userId + "";
        string strQueryStatus = utl.ExecuteQuery(query);
        if (strQueryStatus == "")
            return "Delete";
        else
            return "Failed";
    }
    [WebMethod]
    public static string DeleteLangKnownDetails(string staffLangKnownId, string userId)
    {
        Utilities utl = new Utilities();
        string query = "[sp_DeleteStaffLangKnownDetail] " + staffLangKnownId + "," + userId + "";
        string strQueryStatus = utl.ExecuteQuery(query);
        if (strQueryStatus == "")
            return "Delete";
        else
            return "Failed";
    }
    [WebMethod]
    public static string DeleteServiceDetails(string staffAcdServiceId, string userId)
    {
        Utilities utl = new Utilities();
        string query = "[sp_DeleteStaffServiceDetail] " + staffAcdServiceId + "," + userId + "";
        string strQueryStatus = utl.ExecuteQuery(query);
        if (strQueryStatus == "")
            return "Deleted";
        else
            return "Delete Failed";
    }

    [WebMethod]
    public static string DeleteCareerDetails(string staffAcdServiceId, string userId)
    {
        Utilities utl = new Utilities();
        string query = "[sp_DeleteStaffCareerDetail] " + staffAcdServiceId + "," + userId + "";
        string strQueryStatus = utl.ExecuteQuery(query);
        if (strQueryStatus == "")
            return "Deleted";
        else
            return "Delete Failed";
    }
    [WebMethod]
    public static string DeleteInvDetails(string staffExtInvId, string userId)
    {
        Utilities utl = new Utilities();
        string query = "[sp_DeleteStaffInvDetail] " + staffExtInvId + "," + userId + "";
        string strQueryStatus = utl.ExecuteQuery(query);
        if (strQueryStatus == "")
            return "Deleted";
        else
            return "Delete Failed";
    }

    public class Staff
    {
        public string StaffId { get; set; }
        public string Status { get; set; }
        public string MaxId { get; set; }
    }

    private void GetHeaderDetails()
    {
        if (Request.QueryString["id"] != null)
        {
            string staffId = Request.QueryString["id"].ToString();
            Utilities utl = new Utilities();
            string query = "select s.[StaffName],s.[EmpCode],[dbo].[fn_getStaffPresentDesignation](s.staffID) as DesignationName,s.PresentStatus from e_staffinfo s  where  s.staffid= " + staffId + "";
            DataTable dt = utl.GetDataTable(query);

            if (dt != null && dt.Rows.Count > 0)
            {
                lblStaffName.Text = dt.Rows[0]["StaffName"].ToString();
                lblEmpCode.Text = dt.Rows[0]["EmpCode"].ToString();
                lblDesg.Text = dt.Rows[0]["DesignationName"].ToString();
                lblStatus.Text = dt.Rows[0]["PresentStatus"].ToString();
            }
        }

    }

}