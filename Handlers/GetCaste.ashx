<%@ WebHandler Language="C#" Class="GetCaste" %>

using System;
using System.Web;

public class GetCaste : IHttpHandler {
    
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

            dsSearch = utl.GetDataset(@"select casteid,castename from m_caste  where castename like'" + searchtxt + "%' order by castename");

            if (dsSearch != null && dsSearch.Tables.Count > 0 && dsSearch.Tables[0].Rows.Count > 0)
            {
                foreach (System.Data.DataRow dr in dsSearch.Tables[0].Rows)
                {
                    sbXML.Append("<rs id=\"" + dr[0].ToString() + "\" info=\"\">" + dr[1].ToString().Replace("/", " ").Replace("&", " ").Replace("'", "\'") + "  </rs>");
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