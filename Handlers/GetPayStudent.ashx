<%@ WebHandler Language="C#" Class="GetPayStudent" %>

using System;
using System.Web;
using System.Data;
using System.Data.SqlClient;
public class GetPayStudent : IHttpHandler {
    
    public void ProcessRequest (HttpContext context) {


        context.Response.ContentType = "text/xml";
        context.Response.ContentEncoding = System.Text.Encoding.UTF8;

        System.Text.StringBuilder sbXML = new System.Text.StringBuilder();
        System.Data.DataSet dsSearch = new System.Data.DataSet();
        string searchtxt;

        sbXML.Append("<?xml version=\"1.0\" encoding=\"utf-8\" ?><results>");
        if (context.Request.RequestType == "GET")
        {
            Utilities utl = new Utilities();

            searchtxt = context.Request.QueryString["input"].ToString();

            string query = "[sp_GetPayStudentName]";
            SqlCommand cmd = new SqlCommand(query);
             
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.AddWithValue("@regno", context.Request.QueryString["regno"].ToString());
            cmd.Parameters.AddWithValue("@classname", context.Request.QueryString["class"].ToString());
            cmd.Parameters.AddWithValue("@section", context.Request.QueryString["section"].ToString());
            cmd.Parameters.AddWithValue("@studentname", searchtxt);
            cmd.Parameters.AddWithValue("@AcademicYearId", context.Request.QueryString["AcademicYearId"].ToString());


            
            dsSearch = utl.GetDataWithOutPager(cmd, "PayStudName");

            if (dsSearch != null && dsSearch.Tables.Count > 0 && dsSearch.Tables[0].Rows.Count > 0)
            {
                foreach (System.Data.DataRow dr in dsSearch.Tables[0].Rows)
                {
                    sbXML.Append("<rs id=\"" + dr[0].ToString() + "\" info=\"\">" + dr[1].ToString().Replace("/", " ").Replace("&", " ").Replace("'", "\'") + "</rs>");
                }
            }
        }
        sbXML.Append("</results>");

        context.Response.Write(sbXML.ToString());
    }
   
    public bool IsReusable {
        get {
            return false;
        }
    }

}