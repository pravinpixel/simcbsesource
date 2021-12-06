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
using System.IO;
using Microsoft.Reporting.WebForms;
using System.Drawing.Printing;
using System.Drawing.Imaging;
using System.Text;

public partial class Reports_StaffCustomReport : System.Web.UI.Page
{
    Utilities utl = null;
    public static int Userid = 0;
    public int m_currentPageIndex;
    public IList<Stream> m_streams;
    PrintDocument printDoc = new PrintDocument();
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            cmbPrinters.Items.Clear();
            foreach (string sPrinters in System.Drawing.Printing.PrinterSettings.InstalledPrinters)
            {
                cmbPrinters.Items.Add(sPrinters);
            }
            DataTable dtSchool = new DataTable();
            utl = new Utilities();
            dtSchool = utl.GetDataTable("exec sp_schoolDetails");
            BindFields();

            ReportParameter brothers = new ReportParameter("brothers", "False", false);
            StaffCustomReport.LocalReport.SetParameters(new ReportParameter[] { brothers });

            ReportParameter sisters = new ReportParameter("sisters", "False", false);
            StaffCustomReport.LocalReport.SetParameters(new ReportParameter[] { sisters });


            ReportParameter aadhaarno = new ReportParameter("aadhaarno", "False", false);
            StaffCustomReport.LocalReport.SetParameters(new ReportParameter[] { aadhaarno });

            ReportParameter accno = new ReportParameter("accno", "False", false);
            StaffCustomReport.LocalReport.SetParameters(new ReportParameter[] { accno });

            ReportParameter bankname = new ReportParameter("bankname", "False", false);
            StaffCustomReport.LocalReport.SetParameters(new ReportParameter[] { bankname });

            ReportParameter bloodgroup = new ReportParameter("bloodgroup", "False", false);
            StaffCustomReport.LocalReport.SetParameters(new ReportParameter[] { bloodgroup });

            ReportParameter caste = new ReportParameter("caste", "False", false);
            StaffCustomReport.LocalReport.SetParameters(new ReportParameter[] { caste });

            ReportParameter community = new ReportParameter("community", "False", false);
            StaffCustomReport.LocalReport.SetParameters(new ReportParameter[] { community });

            ReportParameter departmentname = new ReportParameter("departmentname", "False", false);
            StaffCustomReport.LocalReport.SetParameters(new ReportParameter[] { departmentname });

            ReportParameter designationname = new ReportParameter("designationname", "False", false);
            StaffCustomReport.LocalReport.SetParameters(new ReportParameter[] { designationname });

            ReportParameter disorders = new ReportParameter("disorders", "False", false);
            StaffCustomReport.LocalReport.SetParameters(new ReportParameter[] { disorders });

            ReportParameter dob = new ReportParameter("dob", "False", false);
            StaffCustomReport.LocalReport.SetParameters(new ReportParameter[] { dob });

            ReportParameter docaddr = new ReportParameter("docaddr", "False", false);
            StaffCustomReport.LocalReport.SetParameters(new ReportParameter[] { docaddr });

            ReportParameter docphno = new ReportParameter("docphno", "False", false);
            StaffCustomReport.LocalReport.SetParameters(new ReportParameter[] { docphno });

            ReportParameter doctor = new ReportParameter("doctor", "False", false);
            StaffCustomReport.LocalReport.SetParameters(new ReportParameter[] { doctor });

            ReportParameter doj = new ReportParameter("doj", "False", false);
            StaffCustomReport.LocalReport.SetParameters(new ReportParameter[] { doj });

            ReportParameter dor = new ReportParameter("dor", "False", false);
            StaffCustomReport.LocalReport.SetParameters(new ReportParameter[] { dor });

            ReportParameter email = new ReportParameter("email", "False", false);
            StaffCustomReport.LocalReport.SetParameters(new ReportParameter[] { email });

            ReportParameter emergencyphno = new ReportParameter("emergencyphno", "False", false);
            StaffCustomReport.LocalReport.SetParameters(new ReportParameter[] { emergencyphno });

            ReportParameter empcode = new ReportParameter("empcode", "False", false);
            StaffCustomReport.LocalReport.SetParameters(new ReportParameter[] { empcode });

            ReportParameter epfcode = new ReportParameter("epfcode", "False", false);
            StaffCustomReport.LocalReport.SetParameters(new ReportParameter[] { epfcode });

            ReportParameter handicaptdetails = new ReportParameter("handicaptdetails", "False", false);
            StaffCustomReport.LocalReport.SetParameters(new ReportParameter[] { handicaptdetails });

            ReportParameter height = new ReportParameter("height", "False", false);
            StaffCustomReport.LocalReport.SetParameters(new ReportParameter[] { height });

            ReportParameter idmarks = new ReportParameter("idmarks", "False", false);
            StaffCustomReport.LocalReport.SetParameters(new ReportParameter[] { idmarks });

            ReportParameter maritalstatus = new ReportParameter("maritalstatus", "False", false);
            StaffCustomReport.LocalReport.SetParameters(new ReportParameter[] { maritalstatus });

            ReportParameter mobileno = new ReportParameter("mobileno", "False", false);
            StaffCustomReport.LocalReport.SetParameters(new ReportParameter[] { mobileno });

            ReportParameter mothertongue = new ReportParameter("mothertongue", "False", false);
            StaffCustomReport.LocalReport.SetParameters(new ReportParameter[] { mothertongue });

            ReportParameter nationality = new ReportParameter("nationality", "False", false);
            StaffCustomReport.LocalReport.SetParameters(new ReportParameter[] { nationality });

            ReportParameter peraddr = new ReportParameter("peraddr", "False", false);
            StaffCustomReport.LocalReport.SetParameters(new ReportParameter[] { peraddr });

            ReportParameter pancardno = new ReportParameter("pancardno", "False", false);
            StaffCustomReport.LocalReport.SetParameters(new ReportParameter[] { pancardno });

            ReportParameter phoneno = new ReportParameter("phoneno", "False", false);
            StaffCustomReport.LocalReport.SetParameters(new ReportParameter[] { phoneno });

            ReportParameter placeofwork = new ReportParameter("placeofwork", "False", false);
            StaffCustomReport.LocalReport.SetParameters(new ReportParameter[] { placeofwork });

            ReportParameter religion = new ReportParameter("religion", "False", false);
            StaffCustomReport.LocalReport.SetParameters(new ReportParameter[] { religion });

            ReportParameter sex = new ReportParameter("sex", "False", false);
            StaffCustomReport.LocalReport.SetParameters(new ReportParameter[] { sex });

            ReportParameter staffname = new ReportParameter("staffname", "False", false);
            StaffCustomReport.LocalReport.SetParameters(new ReportParameter[] { staffname });

            ReportParameter subjecthandling = new ReportParameter("subjecthandling", "False", false);
            StaffCustomReport.LocalReport.SetParameters(new ReportParameter[] { subjecthandling });

            ReportParameter tempaddr = new ReportParameter("tempaddr", "False", false);
            StaffCustomReport.LocalReport.SetParameters(new ReportParameter[] { tempaddr });

            ReportParameter weight = new ReportParameter("weight", "False", false);
            StaffCustomReport.LocalReport.SetParameters(new ReportParameter[] { weight });

            ReportParameter smartcardno = new ReportParameter("smartcardno", "False", false);
            StaffCustomReport.LocalReport.SetParameters(new ReportParameter[] { smartcardno });

            ReportParameter rationcardno = new ReportParameter("rationcardno", "False", false);
            StaffCustomReport.LocalReport.SetParameters(new ReportParameter[] { rationcardno });

            ReportParameter fileno = new ReportParameter("fileno", "False", false);
            StaffCustomReport.LocalReport.SetParameters(new ReportParameter[] { fileno });

            ReportParameter lockerno = new ReportParameter("lockerno", "False", false);
            StaffCustomReport.LocalReport.SetParameters(new ReportParameter[] { lockerno });

            ReportParameter relationlist = new ReportParameter("relationlist", "False", false);
            StaffCustomReport.LocalReport.SetParameters(new ReportParameter[] { relationlist });

            ReportParameter Schoolname = new ReportParameter("Schoolname", dtSchool.Rows[0]["SchoolName"].ToString());
            StaffCustomReport.LocalReport.SetParameters(new ReportParameter[] { Schoolname });

            ReportParameter Printdate = new ReportParameter("Printdate", System.DateTime.Now.ToString("dd/MM/yyyy"));
            StaffCustomReport.LocalReport.SetParameters(new ReportParameter[] { Printdate });

        }


    }


    protected string BindFields()
    {
        StringBuilder sb = new StringBuilder();

        DataTable dt = new DataTable();
        string sqlstr = "SELECT Upper(COLUMN_NAME) as Columnname FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = N'Vw_GetStaff' and COLUMN_NAME  in ('StaffName','EmpCode','DOB','DOJ','DOR','Sex','MotherTongue','Religion','Community','Caste','AadhaarNo','TempAddr','PerAddr','Email','MobileNo','BloodGroup','DisOrders','EmergencyPhNo','Doctor','DocAddr','DocPhNo','IdMarks','HandicaptDetails','Nationality','PanCardNo','AccNo','BankName','DateOfRetirement','EPFCode','MaritalStatus','PhoneNo','PlaceOfWork','DepartmentName','DesignationName','SmartCardNo','RationCardNo','FileNo','LockerNo','RelationList','Brothers','Sisters')";
        dt = utl.GetDataTable(sqlstr);
        Session["Count"] = dt.Rows.Count.ToString();
        if (dt != null && dt.Rows.Count > 0)
        {
            foreach (DataRow dr in dt.Rows)
            {
                chkids.Items.Add(dr["Columnname"].ToString());

            }
            foreach (ListItem li in chkids.Items)
            {

                if (li.Text.ToLower() == "empcode" || li.Text.ToLower() == "staffname" || li.Text.ToLower() == "designationname")
                {
                    li.Selected = true;
                    li.Enabled = false;
                }
            }
        }


        return sb.ToString();
    }






    protected void btnSearch_Click(object sender, EventArgs e)
    {
        utl = new Utilities();
        DataTable dtSchool = new DataTable();
        dtSchool = utl.GetDataTable("exec sp_schoolDetails");

        foreach (ListItem li in chkids.Items)
        {
            if (li.Text.ToLower() == "brothers")
            {
                if (li.Selected == true)
                {
                    ReportParameter brothers = new ReportParameter(li.Text.ToLower(), "True", true);
                    StaffCustomReport.LocalReport.SetParameters(new ReportParameter[] { brothers });
                }
                else
                {
                    ReportParameter brothers = new ReportParameter(li.Text.ToLower(), "False", false);
                    StaffCustomReport.LocalReport.SetParameters(new ReportParameter[] { brothers });
                }

            }
            if (li.Text.ToLower() == "sisters")
            {
                if (li.Selected == true)
                {
                    ReportParameter sisters = new ReportParameter(li.Text.ToLower(), "True", true);
                    StaffCustomReport.LocalReport.SetParameters(new ReportParameter[] { sisters });
                }
                else
                {
                    ReportParameter sisters = new ReportParameter(li.Text.ToLower(), "False", false);
                    StaffCustomReport.LocalReport.SetParameters(new ReportParameter[] { sisters });
                }

            }
            if (li.Text.ToLower() == "aadhaarno")
            {
                if (li.Selected == true)
                {
                    ReportParameter aadhaarno = new ReportParameter(li.Text.ToLower(), "True", true);
                    StaffCustomReport.LocalReport.SetParameters(new ReportParameter[] { aadhaarno });
                }
                else
                {
                    ReportParameter aadhaarno = new ReportParameter(li.Text.ToLower(), "False", false);
                    StaffCustomReport.LocalReport.SetParameters(new ReportParameter[] { aadhaarno });
                }

            }
            if (li.Text.ToLower() == "smartcardno")
            {
                if (li.Selected == true)
                {
                    ReportParameter smartcardno = new ReportParameter(li.Text.ToLower(), "True", true);
                    StaffCustomReport.LocalReport.SetParameters(new ReportParameter[] { smartcardno });
                }
                else
                {
                    ReportParameter smartcardno = new ReportParameter(li.Text.ToLower(), "False", false);
                    StaffCustomReport.LocalReport.SetParameters(new ReportParameter[] { smartcardno });
                }

            }
            if (li.Text.ToLower() == "rationcardno")
            {
                if (li.Selected == true)
                {
                    ReportParameter rationcardno = new ReportParameter(li.Text.ToLower(), "True", true);
                    StaffCustomReport.LocalReport.SetParameters(new ReportParameter[] { rationcardno });
                }
                else
                {
                    ReportParameter rationcardno = new ReportParameter(li.Text.ToLower(), "False", false);
                    StaffCustomReport.LocalReport.SetParameters(new ReportParameter[] { rationcardno });
                }

            }
            if (li.Text.ToLower() == "relationlist")
            {
                if (li.Selected == true)
                {
                    ReportParameter relationlist = new ReportParameter(li.Text.ToLower(), "True", true);
                    StaffCustomReport.LocalReport.SetParameters(new ReportParameter[] { relationlist });
                }
                else
                {
                    ReportParameter relationlist = new ReportParameter(li.Text.ToLower(), "False", false);
                    StaffCustomReport.LocalReport.SetParameters(new ReportParameter[] { relationlist });
                }

            }
            if (li.Text.ToLower() == "fileno")
            {
                if (li.Selected == true)
                {
                    ReportParameter fileno = new ReportParameter(li.Text.ToLower(), "True", true);
                    StaffCustomReport.LocalReport.SetParameters(new ReportParameter[] { fileno });
                }
                else
                {
                    ReportParameter fileno = new ReportParameter(li.Text.ToLower(), "False", false);
                    StaffCustomReport.LocalReport.SetParameters(new ReportParameter[] { fileno });
                }

            }
            if (li.Text.ToLower() == "lockerno")
            {
                if (li.Selected == true)
                {
                    ReportParameter lockerno = new ReportParameter(li.Text.ToLower(), "True", true);
                    StaffCustomReport.LocalReport.SetParameters(new ReportParameter[] { lockerno });
                }
                else
                {
                    ReportParameter lockerno = new ReportParameter(li.Text.ToLower(), "False", false);
                    StaffCustomReport.LocalReport.SetParameters(new ReportParameter[] { lockerno });
                }

            }
            if (li.Text.ToLower() == "accno")
            {
                if (li.Selected == true)
                {
                    ReportParameter accno = new ReportParameter(li.Text.ToLower(), "True", true);
                    StaffCustomReport.LocalReport.SetParameters(new ReportParameter[] { accno });
                }
                else
                {
                    ReportParameter accno = new ReportParameter(li.Text.ToLower(), "False", false);
                    StaffCustomReport.LocalReport.SetParameters(new ReportParameter[] { accno });
                }

            }

            if (li.Text.ToLower() == "bankname")
            {
                if (li.Selected == true)
                {
                    ReportParameter bankname = new ReportParameter(li.Text.ToLower(), "True", true);
                    StaffCustomReport.LocalReport.SetParameters(new ReportParameter[] { bankname });
                }
                else
                {
                    ReportParameter bankname = new ReportParameter(li.Text.ToLower(), "False", false);
                    StaffCustomReport.LocalReport.SetParameters(new ReportParameter[] { bankname });
                }

            }

            if (li.Text.ToLower() == "bloodgroup")
            {
                if (li.Selected == true)
                {
                    ReportParameter bloodgroup = new ReportParameter(li.Text.ToLower(), "True", true);
                    StaffCustomReport.LocalReport.SetParameters(new ReportParameter[] { bloodgroup });
                }
                else
                {
                    ReportParameter bloodgroup = new ReportParameter(li.Text.ToLower(), "False", false);
                    StaffCustomReport.LocalReport.SetParameters(new ReportParameter[] { bloodgroup });
                }

            }

            if (li.Text.ToLower() == "caste")
            {
                if (li.Selected == true)
                {
                    ReportParameter caste = new ReportParameter(li.Text.ToLower(), "True", true);
                    StaffCustomReport.LocalReport.SetParameters(new ReportParameter[] { caste });
                }
                else
                {
                    ReportParameter caste = new ReportParameter(li.Text.ToLower(), "False", false);
                    StaffCustomReport.LocalReport.SetParameters(new ReportParameter[] { caste });
                }

            }


            if (li.Text.ToLower() == "community")
            {
                if (li.Selected == true)
                {
                    ReportParameter community = new ReportParameter(li.Text.ToLower(), "True", true);
                    StaffCustomReport.LocalReport.SetParameters(new ReportParameter[] { community });
                }
                else
                {
                    ReportParameter community = new ReportParameter(li.Text.ToLower(), "False", false);
                    StaffCustomReport.LocalReport.SetParameters(new ReportParameter[] { community });
                }

            }

            if (li.Text.ToLower() == "departmentname")
            {
                if (li.Selected == true)
                {
                    ReportParameter departmentname = new ReportParameter(li.Text.ToLower(), "True", true);
                    StaffCustomReport.LocalReport.SetParameters(new ReportParameter[] { departmentname });
                }
                else
                {
                    ReportParameter departmentname = new ReportParameter(li.Text.ToLower(), "False", false);
                    StaffCustomReport.LocalReport.SetParameters(new ReportParameter[] { departmentname });
                }

            }

            if (li.Text.ToLower() == "designationname")
            {
                if (li.Selected == true)
                {
                    ReportParameter designationname = new ReportParameter(li.Text.ToLower(), "True", true);
                    StaffCustomReport.LocalReport.SetParameters(new ReportParameter[] { designationname });
                }
                else
                {
                    ReportParameter designationname = new ReportParameter(li.Text.ToLower(), "False", false);
                    StaffCustomReport.LocalReport.SetParameters(new ReportParameter[] { designationname });
                }

            }

            if (li.Text.ToLower() == "disorders")
            {
                if (li.Selected == true)
                {
                    ReportParameter disorders = new ReportParameter(li.Text.ToLower(), "True", true);
                    StaffCustomReport.LocalReport.SetParameters(new ReportParameter[] { disorders });
                }
                else
                {
                    ReportParameter disorders = new ReportParameter(li.Text.ToLower(), "False", false);
                    StaffCustomReport.LocalReport.SetParameters(new ReportParameter[] { disorders });
                }

            }

            if (li.Text.ToLower() == "dor")
            {
                if (li.Selected == true)
                {
                    ReportParameter dor = new ReportParameter(li.Text.ToLower(), "True", true);
                    StaffCustomReport.LocalReport.SetParameters(new ReportParameter[] { dor });
                }
                else
                {
                    ReportParameter dor = new ReportParameter(li.Text.ToLower(), "False", false);
                    StaffCustomReport.LocalReport.SetParameters(new ReportParameter[] { dor });
                }

            }

            if (li.Text.ToLower() == "dob")
            {
                if (li.Selected == true)
                {
                    ReportParameter dob = new ReportParameter(li.Text.ToLower(), "True", true);
                    StaffCustomReport.LocalReport.SetParameters(new ReportParameter[] { dob });
                }
                else
                {
                    ReportParameter dob = new ReportParameter(li.Text.ToLower(), "False", false);
                    StaffCustomReport.LocalReport.SetParameters(new ReportParameter[] { dob });
                }

            }

            if (li.Text.ToLower() == "doj")
            {
                if (li.Selected == true)
                {
                    ReportParameter doj = new ReportParameter(li.Text.ToLower(), "True", true);
                    StaffCustomReport.LocalReport.SetParameters(new ReportParameter[] { doj });
                }
                else
                {
                    ReportParameter doj = new ReportParameter(li.Text.ToLower(), "False", false);
                    StaffCustomReport.LocalReport.SetParameters(new ReportParameter[] { doj });
                }

            }

            if (li.Text.ToLower() == "docaddr")
            {
                if (li.Selected == true)
                {
                    ReportParameter docaddr = new ReportParameter(li.Text.ToLower(), "True", true);
                    StaffCustomReport.LocalReport.SetParameters(new ReportParameter[] { docaddr });
                }
                else
                {
                    ReportParameter docaddr = new ReportParameter(li.Text.ToLower(), "False", false);
                    StaffCustomReport.LocalReport.SetParameters(new ReportParameter[] { docaddr });
                }

            }

            if (li.Text.ToLower() == "docphno")
            {
                if (li.Selected == true)
                {
                    ReportParameter docphno = new ReportParameter(li.Text.ToLower(), "True", true);
                    StaffCustomReport.LocalReport.SetParameters(new ReportParameter[] { docphno });
                }
                else
                {
                    ReportParameter docphno = new ReportParameter(li.Text.ToLower(), "False", false);
                    StaffCustomReport.LocalReport.SetParameters(new ReportParameter[] { docphno });
                }

            }

            if (li.Text.ToLower() == "doctor")
            {
                if (li.Selected == true)
                {
                    ReportParameter doctor = new ReportParameter(li.Text.ToLower(), "True", true);
                    StaffCustomReport.LocalReport.SetParameters(new ReportParameter[] { doctor });
                }
                else
                {
                    ReportParameter doctor = new ReportParameter(li.Text.ToLower(), "False", false);
                    StaffCustomReport.LocalReport.SetParameters(new ReportParameter[] { doctor });
                }

            }


            if (li.Text.ToLower() == "email")
            {
                if (li.Selected == true)
                {
                    ReportParameter email = new ReportParameter(li.Text.ToLower(), "True", true);
                    StaffCustomReport.LocalReport.SetParameters(new ReportParameter[] { email });
                }
                else
                {
                    ReportParameter email = new ReportParameter(li.Text.ToLower(), "False", false);
                    StaffCustomReport.LocalReport.SetParameters(new ReportParameter[] { email });
                }

            }

            if (li.Text.ToLower() == "emergencyphno")
            {
                if (li.Selected == true)
                {
                    ReportParameter emergencyphno = new ReportParameter(li.Text.ToLower(), "True", true);
                    StaffCustomReport.LocalReport.SetParameters(new ReportParameter[] { emergencyphno });
                }
                else
                {
                    ReportParameter emergencyphno = new ReportParameter(li.Text.ToLower(), "False", false);
                    StaffCustomReport.LocalReport.SetParameters(new ReportParameter[] { emergencyphno });
                }

            }

            if (li.Text.ToLower() == "empcode")
            {
                if (li.Selected == true)
                {
                    ReportParameter empcode = new ReportParameter(li.Text.ToLower(), "True", true);
                    StaffCustomReport.LocalReport.SetParameters(new ReportParameter[] { empcode });
                }
                else
                {
                    ReportParameter empcode = new ReportParameter(li.Text.ToLower(), "False", false);
                    StaffCustomReport.LocalReport.SetParameters(new ReportParameter[] { empcode });
                }

            }




            if (li.Text.ToLower() == "epfcode")
            {
                if (li.Selected == true)
                {
                    ReportParameter epfcode = new ReportParameter(li.Text.ToLower(), "True", true);
                    StaffCustomReport.LocalReport.SetParameters(new ReportParameter[] { epfcode });
                }
                else
                {
                    ReportParameter epfcode = new ReportParameter(li.Text.ToLower(), "False", false);
                    StaffCustomReport.LocalReport.SetParameters(new ReportParameter[] { epfcode });
                }

            }

            if (li.Text.ToLower() == "handicaptdetails")
            {
                if (li.Selected == true)
                {
                    ReportParameter handicaptdetails = new ReportParameter(li.Text.ToLower(), "True", true);
                    StaffCustomReport.LocalReport.SetParameters(new ReportParameter[] { handicaptdetails });
                }
                else
                {
                    ReportParameter handicaptdetails = new ReportParameter(li.Text.ToLower(), "False", false);
                    StaffCustomReport.LocalReport.SetParameters(new ReportParameter[] { handicaptdetails });
                }

            }

            if (li.Text.ToLower() == "height")
            {
                if (li.Selected == true)
                {
                    ReportParameter height = new ReportParameter(li.Text.ToLower(), "True", true);
                    StaffCustomReport.LocalReport.SetParameters(new ReportParameter[] { height });
                }
                else
                {
                    ReportParameter height = new ReportParameter(li.Text.ToLower(), "False", false);
                    StaffCustomReport.LocalReport.SetParameters(new ReportParameter[] { height });
                }

            }

            if (li.Text.ToLower() == "idmarks")
            {
                if (li.Selected == true)
                {
                    ReportParameter idmarks = new ReportParameter(li.Text.ToLower(), "True", true);
                    StaffCustomReport.LocalReport.SetParameters(new ReportParameter[] { idmarks });
                }
                else
                {
                    ReportParameter idmarks = new ReportParameter(li.Text.ToLower(), "False", false);
                    StaffCustomReport.LocalReport.SetParameters(new ReportParameter[] { idmarks });
                }

            }

            if (li.Text.ToLower() == "maritalstatus")
            {
                if (li.Selected == true)
                {
                    ReportParameter maritalstatus = new ReportParameter(li.Text.ToLower(), "True", true);
                    StaffCustomReport.LocalReport.SetParameters(new ReportParameter[] { maritalstatus });
                }
                else
                {
                    ReportParameter maritalstatus = new ReportParameter(li.Text.ToLower(), "False", false);
                    StaffCustomReport.LocalReport.SetParameters(new ReportParameter[] { maritalstatus });
                }

            }

            if (li.Text.ToLower() == "mobileno")
            {
                if (li.Selected == true)
                {
                    ReportParameter mobileno = new ReportParameter(li.Text.ToLower(), "True", true);
                    StaffCustomReport.LocalReport.SetParameters(new ReportParameter[] { mobileno });
                }
                else
                {
                    ReportParameter mobileno = new ReportParameter(li.Text.ToLower(), "False", false);
                    StaffCustomReport.LocalReport.SetParameters(new ReportParameter[] { mobileno });
                }

            }
            if (li.Text.ToLower() == "mothertongue")
            {
                if (li.Selected == true)
                {
                    ReportParameter mothertongue = new ReportParameter(li.Text.ToLower(), "True", true);
                    StaffCustomReport.LocalReport.SetParameters(new ReportParameter[] { mothertongue });
                }
                else
                {
                    ReportParameter mothertongue = new ReportParameter(li.Text.ToLower(), "False", false);
                    StaffCustomReport.LocalReport.SetParameters(new ReportParameter[] { mothertongue });
                }

            }

            if (li.Text.ToLower() == "nationality")
            {
                if (li.Selected == true)
                {
                    ReportParameter nationality = new ReportParameter(li.Text.ToLower(), "True", true);
                    StaffCustomReport.LocalReport.SetParameters(new ReportParameter[] { nationality });
                }
                else
                {
                    ReportParameter nationality = new ReportParameter(li.Text.ToLower(), "False", false);
                    StaffCustomReport.LocalReport.SetParameters(new ReportParameter[] { nationality });
                }

            }

            if (li.Text.ToLower() == "peraddr")
            {
                if (li.Selected == true)
                {
                    ReportParameter peraddr = new ReportParameter(li.Text.ToLower(), "True", true);
                    StaffCustomReport.LocalReport.SetParameters(new ReportParameter[] { peraddr });
                }
                else
                {
                    ReportParameter peraddr = new ReportParameter(li.Text.ToLower(), "False", false);
                    StaffCustomReport.LocalReport.SetParameters(new ReportParameter[] { peraddr });
                }

            }
            if (li.Text.ToLower() == "pancardno")
            {
                if (li.Selected == true)
                {
                    ReportParameter pancardno = new ReportParameter(li.Text.ToLower(), "True", true);
                    StaffCustomReport.LocalReport.SetParameters(new ReportParameter[] { pancardno });
                }
                else
                {
                    ReportParameter pancardno = new ReportParameter(li.Text.ToLower(), "False", false);
                    StaffCustomReport.LocalReport.SetParameters(new ReportParameter[] { pancardno });
                }

            }

            if (li.Text.ToLower() == "placeofwork")
            {
                if (li.Selected == true)
                {
                    ReportParameter placeofwork = new ReportParameter(li.Text.ToLower(), "True", true);
                    StaffCustomReport.LocalReport.SetParameters(new ReportParameter[] { placeofwork });
                }
                else
                {
                    ReportParameter placeofwork = new ReportParameter(li.Text.ToLower(), "False", false);
                    StaffCustomReport.LocalReport.SetParameters(new ReportParameter[] { placeofwork });
                }

            }
            if (li.Text.ToLower() == "religion")
            {
                if (li.Selected == true)
                {
                    ReportParameter religion = new ReportParameter(li.Text.ToLower(), "True", true);
                    StaffCustomReport.LocalReport.SetParameters(new ReportParameter[] { religion });
                }
                else
                {
                    ReportParameter religion = new ReportParameter(li.Text.ToLower(), "False", false);
                    StaffCustomReport.LocalReport.SetParameters(new ReportParameter[] { religion });
                }

            }
            if (li.Text.ToLower() == "sex")
            {
                if (li.Selected == true)
                {
                    ReportParameter sex = new ReportParameter(li.Text.ToLower(), "True", true);
                    StaffCustomReport.LocalReport.SetParameters(new ReportParameter[] { sex });
                }
                else
                {
                    ReportParameter sex = new ReportParameter(li.Text.ToLower(), "False", false);
                    StaffCustomReport.LocalReport.SetParameters(new ReportParameter[] { sex });
                }

            }


            if (li.Text.ToLower() == "staffname")
            {
                if (li.Selected == true)
                {
                    ReportParameter staffname = new ReportParameter(li.Text.ToLower(), "True", true);
                    StaffCustomReport.LocalReport.SetParameters(new ReportParameter[] { staffname });
                }
                else
                {
                    ReportParameter staffname = new ReportParameter(li.Text.ToLower(), "False", false);
                    StaffCustomReport.LocalReport.SetParameters(new ReportParameter[] { staffname });
                }

            }
            if (li.Text.ToLower() == "subjecthandling")
            {
                if (li.Selected == true)
                {
                    ReportParameter subjecthandling = new ReportParameter(li.Text.ToLower(), "True", true);
                    StaffCustomReport.LocalReport.SetParameters(new ReportParameter[] { subjecthandling });
                }
                else
                {
                    ReportParameter subjecthandling = new ReportParameter(li.Text.ToLower(), "False", false);
                    StaffCustomReport.LocalReport.SetParameters(new ReportParameter[] { subjecthandling });
                }

            }
            if (li.Text.ToLower() == "tempaddr")
            {
                if (li.Selected == true)
                {
                    ReportParameter tempaddr = new ReportParameter(li.Text.ToLower(), "True", true);
                    StaffCustomReport.LocalReport.SetParameters(new ReportParameter[] { tempaddr });
                }
                else
                {
                    ReportParameter tempaddr = new ReportParameter(li.Text.ToLower(), "False", false);
                    StaffCustomReport.LocalReport.SetParameters(new ReportParameter[] { tempaddr });
                }

            }

            if (li.Text.ToLower() == "phoneno")
            {
                if (li.Selected == true)
                {
                    ReportParameter phoneno = new ReportParameter(li.Text.ToLower(), "True", true);
                    StaffCustomReport.LocalReport.SetParameters(new ReportParameter[] { phoneno });
                }
                else
                {
                    ReportParameter phoneno = new ReportParameter(li.Text.ToLower(), "False", false);
                    StaffCustomReport.LocalReport.SetParameters(new ReportParameter[] { phoneno });
                }

            }

            if (li.Text.ToLower() == "weight")
            {
                if (li.Selected == true)
                {
                    ReportParameter weight = new ReportParameter(li.Text.ToLower(), "True", true);
                    StaffCustomReport.LocalReport.SetParameters(new ReportParameter[] { weight });
                }
                else
                {
                    ReportParameter weight = new ReportParameter(li.Text.ToLower(), "False", false);
                    StaffCustomReport.LocalReport.SetParameters(new ReportParameter[] { weight });
                }

            }
        }

        ReportParameter Schoolname = new ReportParameter("Schoolname", dtSchool.Rows[0]["SchoolName"].ToString());
        StaffCustomReport.LocalReport.SetParameters(new ReportParameter[] { Schoolname });
        ReportParameter Printdate = new ReportParameter("Printdate", System.DateTime.Now.ToString("dd/MM/yyyy"));
        StaffCustomReport.LocalReport.SetParameters(new ReportParameter[] { Printdate });
        StaffCustomReport.LocalReport.Refresh();

    }


    private void Page_Init(object sender, EventArgs e)
    {
        try
        {
            Master.chkUser();
            if (Session["UserId"] == null || Session["AcademicID"] == null)
            {

                Response.Redirect("Default.aspx?ses=expired");
            }
            else
            {
                if (!Page.IsPostBack)
                {
                    Session["strClass"] = "All Class";
                    Session["strSection"] = "All Section";
                }
                // btnSearch_Click(sender, e);
            }

        }
        catch (Exception)
        {


        }
    }

    protected void ddlClass_SelectedIndexChanged(object sender, EventArgs e)
    {


    }

    private void PrintReport()
    {


    }



    public void Dispose()
    {
        if (m_streams != null)
        {
            foreach (Stream stream in m_streams)
                stream.Close();
            m_streams = null;
        }
    }

    public void Export(LocalReport report)
    {
        string deviceInfo =
          "<DeviceInfo>" +
          "  <OutputFormat>EMF</OutputFormat>" +
          "  <PageWidth>8.27in</PageWidth>" +
          "  <PageHeight>11.69in</PageHeight>" +
          "  <MarginTop>0.5in</MarginTop>" +
          "  <MarginLeft>0.5in</MarginLeft>" +
          "  <MarginRight>0.5in</MarginRight>" +
          "  <MarginBottom>0.5in</MarginBottom>" +
          "</DeviceInfo>";
        Warning[] warnings;
        m_streams = new List<Stream>();
        report.Render("Image", deviceInfo, CreateStream,
           out warnings);



        foreach (Stream stream in m_streams)
            stream.Position = 0;
    }
    // Handler for PrintPageEvents
    public void PrintPage(object sender, PrintPageEventArgs ev)
    {
        Metafile pageImage = new
           Metafile(m_streams[m_currentPageIndex]);
        ev.Graphics.DrawImage(pageImage, ev.PageBounds);
        m_currentPageIndex++;
        ev.HasMorePages = (m_currentPageIndex < m_streams.Count);
    }

    public void Print()
    {
        if (m_streams == null || m_streams.Count == 0)
            return;
        printDoc.PrinterSettings.PrinterName = cmbPrinters.SelectedItem.Text;
        if (!printDoc.PrinterSettings.IsValid)
        {
            string msg = String.Format(
               "Can't find printer \"{0}\".", cmbPrinters.SelectedItem.Text);
            return;
        }
        printDoc.PrintPage += new PrintPageEventHandler(PrintPage);
        printDoc.Print();
    }
    private Stream CreateStream(string name, string fileNameExtension, Encoding encoding, string mimeType, bool willSeek)
    {
        Stream stream = new MemoryStream();
        m_streams.Add(stream);
        return stream;
    }

    protected void chkAll_CheckedChanged(object sender, EventArgs e)
    {
        if (chkAll.Checked == true)
        {
            foreach (ListItem li in chkids.Items)
            {

                if (li.Text.ToLower() == "empcode" || li.Text.ToLower() == "staffname" || li.Text.ToLower() == "designationname")
                {
                    li.Selected = true;
                    li.Enabled = false;
                }
                else
                {
                    li.Selected = true;
                }
            }
            unchkAll.Checked = false;
        }

    }
    protected void unchkAll_CheckedChanged(object sender, EventArgs e)
    {
        if (unchkAll.Checked == true)
        {
            foreach (ListItem li in chkids.Items)
            {

                if (li.Text.ToLower() == "empcode" || li.Text.ToLower() == "staffname" || li.Text.ToLower() == "designationname")
                {
                    li.Selected = true;
                    li.Enabled = false;
                }
                else
                {
                    li.Selected = false;
                }
            }
            chkAll.Checked = false;
        }

    }

}