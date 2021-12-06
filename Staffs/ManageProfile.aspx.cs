using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Services;
using System.Data;

public partial class Staffs_ManageProfile : System.Web.UI.Page
{
    Utilities utl = null;
    string sqlstr = "";
    protected void Page_Load(object sender, EventArgs e)
    {
        if (Request.RequestType == "POST")
        {
            if (Request.Files["StaffImage"] != null && Request.Files["StaffImage"].ContentLength > 0 && Request.Form["StaffId"] != null && Request.Form["StaffId"].Length > 0)
            {
                HttpPostedFile PostedFile = Request.Files["StaffImage"];
                string id = Request.Form["StaffId"].ToString();
                string extension = PostedFile.FileName.Substring(PostedFile.FileName.LastIndexOf('.'));
                PostedFile.SaveAs(Server.MapPath("~/Staffs/Uploads/ProfilePhotos/" + id + extension));
            }
        }
        Master.chkUser();
        if (Session["UserId"] != null)
        {
            GetStaffInfo(Session["UserId"].ToString());
        }
        BindCommunity();
    }
    private void GetStaffInfo(string userId)
    {
        Utilities utl = new Utilities();

        string query = "[GetStaffInfo] null,null," + userId + "";
        DataSet ds = utl.GetDataset(query);
        if (ds != null && ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0)
        {
            foreach (DataRow dr in ds.Tables[0].Rows)
            {
                hdnStaffId.Value = dr["StaffId"].ToString();
            }
        }
    }
    [WebMethod]
    public static string GetPersonalDetails(string staffId)
    {
        Utilities utl = new Utilities();
        string query = string.Empty;
        if(staffId!=string.Empty)

        query = "[sp_GetStaffPersonalInfo] " + staffId + "";
        return utl.GetDatasetTable(query, "Personal").GetXml();
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
}