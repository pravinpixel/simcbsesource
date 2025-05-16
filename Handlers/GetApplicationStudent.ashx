<%@ WebHandler Language="C#" Class="GetEmployee" %>

using System;
using System.Web;

public class GetEmployee : IHttpHandler
{

    public void ProcessRequest(HttpContext context)
    {
        context.Response.ContentType = "text/xml";
        context.Response.ContentEncoding = System.Text.Encoding.UTF8;

        System.Text.StringBuilder sbXML = new System.Text.StringBuilder();
        System.Data.DataSet dsSearch = new System.Data.DataSet();
        string searchtxt;
        string type;
        sbXML.Append(@"<?xml version='1.0' encoding='utf-8' ?><results>");
        if (context.Request.RequestType == "GET")
        {
            Utilities utl = new Utilities();
            searchtxt = context.Request.QueryString["input"].ToString();
            type = context.Request.QueryString["type"].ToString();

            if (type == "code")
            {
                dsSearch = utl.GetDataset(@"
select s.Stname as StudentName,s.StudentId,s.ApplicationNo from s_studentinfo s  
            where  s.applicationno like '" + searchtxt + "%' and applicationno is not null and Active='F' order by s.Stname");

                if (dsSearch != null && dsSearch.Tables.Count > 0 && dsSearch.Tables[0].Rows.Count > 0)
                {
                    foreach (System.Data.DataRow dr in dsSearch.Tables[0].Rows)
                    {
                        sbXML.Append("<rs id=\"" + dr[0].ToString() + "\" info=\"\">" + dr[2].ToString().Replace("/", " ").Replace("&", " ").Replace("'", "\'") + "</rs>");
                    }
                }
            }
            else if (type == "name")
            {
                dsSearch = utl.GetDataset(@"select s.Stname as StudentName,s.StudentId,s.ApplicationNo from s_studentinfo s    
            where   s.Stname like '" + searchtxt + "%' and applicationno is not null and Active='F' order by s.Stname");

                if (dsSearch != null && dsSearch.Tables.Count > 0 && dsSearch.Tables[0].Rows.Count > 0)
                {
                    foreach (System.Data.DataRow dr in dsSearch.Tables[0].Rows)
                    {
                        sbXML.Append("<rs id=\"" + dr[0].ToString() + "\" info=\"\">" + dr[0].ToString().Replace("/", " ").Replace("&", " ").Replace("'", "\'") + "</rs>");
                    }
                }
            }
        }
        sbXML.Append("</results>");

        context.Response.Write(sbXML.ToString());
    }

    public bool IsReusable
    {
        get
        {
            return false;
        }
    }

}