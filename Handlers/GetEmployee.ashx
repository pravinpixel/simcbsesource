<%@ WebHandler Language="C#" Class="GetEmployee" %>

using System;
using System.Web;

public class GetEmployee : IHttpHandler {
    
    public void ProcessRequest (HttpContext context) {
        context.Response.ContentType = "text/xml";
        context.Response.ContentEncoding = System.Text.Encoding.UTF8;

        System.Text.StringBuilder sbXML = new System.Text.StringBuilder();
        System.Data.DataSet dsSearch = new System.Data.DataSet();
        System.Data.DataSet dsSearch_v1 = new System.Data.DataSet();
        string searchtxt;
        string type;
        sbXML.Append("<?xml version=\"1.0\" encoding=\"utf-8\" ?><results>");
        if (context.Request.RequestType == "GET")
        {
            Utilities utl = new Utilities();
            Utilities1 utl1 = new Utilities1();
            
            searchtxt = context.Request.QueryString["input"].ToString();
            type = context.Request.QueryString["type"].ToString();

            if (type == "code")
            {
                dsSearch = utl.GetDataset(@"
select s.StaffName,s.StaffId,s.EmpCode from e_staffinfo s left join m_users u on s.staffid=u.staffid  
            where s.isactive='True' and  s.EmpCode like '" + searchtxt.Replace("'","''") + "%' and u.AdminStatus is null order by s.StaffName");

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

                dsSearch = utl.GetDataset(@"select s.StaffName,s.StaffId,s.EmpCode from e_staffinfo s left join m_users u on s.staffid=u.staffid  
            where s.isactive='True' and  s.StaffName like '%" + searchtxt.Replace("'", "''") + "%' and u.AdminStatus is null order by s.StaffName");
                
                //dsSearch = utl.GetDataset(@"select distinct StaffName,StaffId,EmpCode from e_staffinfo  where StaffName like'" + searchtxt + "%' and isactive='True' and adminstatus is null order by StaffName");

                if (dsSearch != null && dsSearch.Tables.Count > 0 && dsSearch.Tables[0].Rows.Count > 0)
                {
                    foreach (System.Data.DataRow dr in dsSearch.Tables[0].Rows)
                    {
                        sbXML.Append("<rs id=\"" + dr[0].ToString() + "\" info=\"\">" + dr[0].ToString().Replace("/", " ").Replace("&", " ").Replace("'", "\'") + "</rs>");
                    }
                }
            }
                
                
            else if (type == "nameforuser")
            {
                dsSearch = utl.GetDataset(@"select s.StaffId,s.EmpCode,s.StaffName from e_staffinfo s left join m_users u on (s.staffid=u.staffid  and u.AdminStatus is null)
            where s.isactive=1 and  s.StaffName like '%" + searchtxt + "%'  order by s.StaffName");                

                if (dsSearch != null && dsSearch.Tables.Count > 0 && dsSearch.Tables[0].Rows.Count > 0)
                {
                    foreach (System.Data.DataRow dr in dsSearch.Tables[0].Rows)
                    {
                        sbXML.Append("<rs id=\"" + dr[0].ToString() + "\" info=\"\">" + dr[2].ToString().Replace("/", " ").Replace("&", " ").Replace("'", "\'") + "</rs>");
                    }
                }
            }


            else if (type == "employeeuser")
            {
                dsSearch = utl.GetDataset(@"select s.StaffId,s.EmpCode,s.StaffName from e_staffinfo s left join m_users u on (s.staffid=u.staffid  and u.AdminStatus is null)
            where s.isactive=1 and  s.StaffName like '%" + searchtxt + "%'  order by s.StaffName");

                dsSearch_v1 = utl1.GetDataset(@"select s.StaffId,s.EmpCode,s.StaffName from e_staffinfo s left join m_users u on (s.staffid=u.staffid  and u.AdminStatus is null)
            where s.isactive=1 and  s.StaffName like '%" + searchtxt + "%'  order by s.StaffName");
                dsSearch.Merge(dsSearch_v1);

                if (dsSearch != null && dsSearch.Tables.Count > 0 && dsSearch.Tables[0].Rows.Count > 0)
                {
                    foreach (System.Data.DataRow dr in dsSearch.Tables[0].Rows)
                    {
                        sbXML.Append("<rs id=\"" + dr[0].ToString() + "\" info=\"\">" + dr[2].ToString().Replace("/", " ").Replace("&", " ").Replace("'", "\'") + "</rs>");
                    }
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