using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using System.Collections;
/// <summary>
/// Summary description for Utilities
/// </summary>
public class Utilities
{
    string strConnection = null;
    string strConnectionSMS = null;
    public SqlConnection sqlCon = null;
    public SqlConnection sqlConSMS = null;
    SqlDataAdapter da = null;
    SqlCommand sqlCmd = null;
    static readonly string[] ones = new string[] { "", "One", "Two", "Three", "Four", "Five", "Six", "Seven", "Eight", "Nine" };
    static readonly string[] teens = new string[] { "Ten", "Eleven", "Twelve", "Thirteen", "Fourteen", "Fifteen", "Sixteen", "Seventeen", "Eighteen", "Nineteen" };
    static readonly string[] tens = new string[] { "Twenty", "Thirty", "Forty", "Fifty", "Sixty", "Seventy", "Eighty", "Ninety" };
    static readonly string[] thousandsGroups = { "", " Thousand", " Million", " Billion" };

    public Utilities()
    {
        strConnection = ConfigurationManager.AppSettings["SIMCBSEConnection"].ToString();
        sqlCon = new SqlConnection(strConnection);
        sqlCon.Open();

        strConnectionSMS = ConfigurationManager.AppSettings["SIMSMSConnection"].ToString();
        sqlConSMS = new SqlConnection(strConnection);
        sqlConSMS.Open();
    }
private string FriendlyInteger(int n, string leftDigits, int thousands)
    {
        if (n == 0)
            return leftDigits;

        string friendlyInt = leftDigits;
        if (friendlyInt.Length > 0)
            friendlyInt += " ";

        if (n < 10)
            friendlyInt += ones[n];
        else if (n < 20)
            friendlyInt += teens[n - 10];
        else if (n < 100)
            friendlyInt += FriendlyInteger(n % 10, tens[n / 10 - 2], 0);
        else if (n < 1000)
            friendlyInt += FriendlyInteger(n % 100, (ones[n / 100] + " Hundred"), 0);
        else
            friendlyInt += FriendlyInteger(n % 1000, FriendlyInteger(n / 1000, "", thousands + 1), 0);

        return friendlyInt + thousandsGroups[thousands];
    }

    public string DateToWritten(DateTime date)
    {
        return string.Format("{0} {1} {2}", IntegerToWritten(date.Day), date.ToString("MMMM"), IntegerToWritten(date.Year));
    }

    public string IntegerToWritten(int n)
    {
        if (n == 0)
            return "Zero";
        else if (n < 0)
            return "Negative " + IntegerToWritten(-n);

        return FriendlyInteger(n, "", 0);
    }

    public DataSet GetDataset(string strQry)
    {
        DataSet ds = new DataSet();
        using (SqlConnection sqlCon = new SqlConnection(strConnection))
        {
            sqlCon.Open();
            using (SqlCommand sqlCmd = new SqlCommand(strQry, sqlCon))
            {
                sqlCmd.CommandTimeout = 3000;
                using (SqlDataAdapter da = new SqlDataAdapter(sqlCmd))
                {
                    try
                    {
                        da.Fill(ds);
                    }
                    catch
                    { }
                }
            }
        }
        return ds;
    }

    public DataSet GetDatasetTable(string strQry, string tablename)
    {
        DataSet ds = new DataSet();
        using (SqlConnection sqlCon = new SqlConnection(strConnection))
        {
            sqlCon.Open();
            using (SqlCommand sqlCmd = new SqlCommand(strQry, sqlCon))
            {
                sqlCmd.CommandTimeout = 3000;
                using (SqlDataAdapter da = new SqlDataAdapter(sqlCmd))
                {
                    try
                    {
                        da.Fill(ds, tablename);
                    }
                    catch
                    { }
                }
            }
        }
        return ds;
    }


    public DataTable GetDataTable(string strQry)
    {
        DataTable dt = new DataTable();
        using (SqlConnection sqlCon = new SqlConnection(strConnection))
        {
            sqlCon.Open();
            using (SqlCommand sqlCmd = new SqlCommand(strQry, sqlCon))
            {
                sqlCmd.CommandTimeout = 3000;
                using (SqlDataAdapter da = new SqlDataAdapter(sqlCmd))
                {
                    try
                    {
                        da.Fill(dt);
                    }
                    catch
                    { }
                }
            }

        }

        return dt;
    }
    public string ExecuteQuery(string strQry)
    {
        string strError = string.Empty;
        DataSet ds = new DataSet();
        using (SqlConnection sqlCon = new SqlConnection(strConnection))
        {
            sqlCon.Open();

            using (SqlCommand sqlCmd = new SqlCommand(strQry, sqlCon))
            {
                sqlCmd.CommandTimeout = 3000;
                try
                {
                    sqlCmd.ExecuteNonQuery();

                }
                catch (Exception ex)
                {
                    strError = ex.Message.ToString();
                    try
                    {

                    }
                    catch
                    {

                    }
                }
            }
        }
        return strError;
    }

    public string ExecuteSMSQuery(string strQry)
    {
        string strError = string.Empty;
        DataSet ds = new DataSet();
        using (SqlConnection sqlConSMS = new SqlConnection(strConnectionSMS))
        {
            sqlConSMS.Open();

            using (SqlCommand sqlCmd = new SqlCommand(strQry, sqlConSMS))
            {
                sqlCmd.CommandTimeout = 3000;
                try
                {
                    sqlCmd.ExecuteNonQuery();

                }
                catch (Exception ex)
                {
                    strError = ex.Message.ToString();
                    try
                    {

                    }
                    catch
                    {

                    }
                }
            }
        }
        return strError;
    }
    public int GetNextId(string strTable, string strCol, string strWhere, string condition)
    {
        string max = string.Empty;
        using (SqlConnection connection = new SqlConnection(strConnection))
        {

            string strMsg = string.Empty;
            strMsg = "Select isnull(Max(" + strCol + ")+ 1,1) from " + strTable + " where " + strWhere + "='" + condition + "'";
            using (SqlCommand command = new SqlCommand(strMsg, sqlCon))
            {
                connection.Open();
                if (command.ExecuteScalar() == null)
                {
                    max = "1";
                    connection.Close();
                }
                else if (command.ExecuteScalar() != null)
                {
                    max = command.ExecuteScalar().ToString();
                    connection.Close();

                }
            }
        }
        return Convert.ToInt32(max);
    }
    public void ShowMessage(string messageText, Page pg)
    {
        Label lbl = new Label();
        lbl.Text = "<script language='javascript' type='text/javascript'> alert('" + messageText + "');</script>";
        pg.Controls.Add(lbl);
    }
    public string ExecuteScalar(string strQry)
    {
        string strError = string.Empty;

        string strVal = string.Empty;

        DataSet ds = new DataSet();

        using (SqlConnection sqlCon = new SqlConnection(strConnection))
        {
            sqlCon.Open();

            using (SqlCommand sqlCmd = new SqlCommand(strQry, sqlCon))
            {

                sqlCmd.CommandTimeout = 3000;

                try
                {
                    strVal = Convert.ToString(sqlCmd.ExecuteScalar());
                }

                catch
                {

                }
            }
        }

        return strVal;

    }

    public string ExecuteScalarValue(string strQry)
    {
        string strError = string.Empty;

        string strVal = string.Empty;

        DataSet ds = new DataSet();

        using (SqlConnection sqlCon = new SqlConnection(strConnection))
        {

            sqlCon.Open();

            using (SqlCommand sqlCmd = new SqlCommand(strQry, sqlCon))
            {

                sqlCmd.CommandTimeout = 3000;

                try
                {
                    strVal = Convert.ToString(sqlCmd.ExecuteScalar());
                }

                catch
                {

                }
            }

        }
        return strVal;

    }


    public int GetCounts(string strQ)
    {

        string max = string.Empty;

        using (SqlConnection connection = new SqlConnection(strConnection))
        {
            using (SqlCommand command = new SqlCommand(strQ, sqlCon))
            {
                connection.Open();

                if (command.ExecuteScalar() == null)
                {

                    max = "0";

                    connection.Close();

                }

                else if (command.ExecuteScalar() != null)
                {

                    max = command.ExecuteScalar().ToString();

                    connection.Close();

                }
            }
        }
        return Convert.ToInt32(max);

    }
    public string retWord(decimal number1)
    {
        long number = Convert.ToInt64(number1);
        if (number == 0) return "Zero";

        if (number == -2147483648) return "Minus Two Hundred and Fourteen Crore Seventy Four Lakh Eighty Three Thousand Six Hundred and Forty Eight";

        long[] num = new long[4];

        int first = 0;

        long u, h, t;

        System.Text.StringBuilder sb = new System.Text.StringBuilder();

        if (number < 0)
        {
            sb.Append("Minus ");

            number = -number;

        }

        string[] words0 = { "", "One ", "Two ", "Three ", "Four ", "Five ", "Six ", "Seven ", "Eight ", "Nine " };

        string[] words1 = { "Ten ", "Eleven ", "Twelve ", "Thirteen ", "Fourteen ", "Fifteen ", "Sixteen ", "Seventeen ", "Eighteen ", "Nineteen " };

        string[] words2 = { "Twenty ", "Thirty ", "Forty ", "Fifty ", "Sixty ", "Seventy ", "Eighty ", "Ninety " };

        string[] words3 = { "Thousand ", "Lakh ", "Crore " };

        num[0] = number % 1000; // units

        num[1] = number / 1000;

        num[2] = number / 100000;

        num[1] = num[1] - 100 * num[2]; // 

        num[3] = number / 10000000; // crores

        num[2] = num[2] - 100 * num[3]; // lakhs



        for (int i = 3; i > 0; i--)
        {

            if (num[i] != 0)
            {

                first = i;

                break;

            }

        }

        for (int i = first; i >= 0; i--)
        {

            if (num[i] == 0) continue;

            u = num[i] % 10; // ones

            t = num[i] / 10;

            h = num[i] / 100; // hundreds

            t = t - 10 * h; // tens

            if (h > 0) sb.Append(words0[h] + "Hundred ");

            if (u > 0 || t > 0)
            {

                if (h > 0 || i == 0) sb.Append("and ");

                if (t == 0)

                    sb.Append(words0[u]);

                else if (t == 1)

                    sb.Append(words1[u]);

                else

                    sb.Append(words2[t - 2] + words0[u]);

            }

            if (i != 0) sb.Append(words3[i - 1]);

        }

        return sb.ToString().TrimEnd();

    }

    public DataSet GetData(SqlCommand cmd, int pageIndex, string tableName, int PageSize)
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
                    sda.Fill(ds, tableName);
                    DataTable dt = new DataTable("Pager");
                    dt.Columns.Add("PageIndex");
                    dt.Columns.Add("PageSize");
                    dt.Columns.Add("RecordCount");
                    dt.Rows.Add();
                    dt.Rows[0]["PageIndex"] = pageIndex;
                    dt.Rows[0]["PageSize"] = PageSize;
                    string rcnt = cmd.Parameters["@RecordCount"].Value.ToString();
                    if (rcnt != "")
                    {
                        dt.Rows[0]["RecordCount"] = cmd.Parameters["@RecordCount"].Value;
                    }
                    else if (ds.Tables.Count > 1)
                    {
                        if (ds.Tables[1].Rows.Count > 0)
                        {
                            dt.Rows[0]["RecordCount"] = ds.Tables[1].Rows[0][0].ToString();
                        }
                    }

                    ds.Tables.Add(dt);
                    return ds;
                }
            }
        }
    }

    public DataSet GetDataWithOutPager(SqlCommand cmd, string tableName)
    {
        string strConnString = System.Configuration.ConfigurationManager.AppSettings["SIMCBSEConnection"].ToString();
        using (SqlConnection con = new SqlConnection(strConnString))
        {
            using (SqlDataAdapter sda = new SqlDataAdapter())
            {
                cmd.Connection = con;
                sda.SelectCommand = cmd;
                using (DataSet ds = new DataSet())
                {
                    sda.Fill(ds, tableName);
                    return ds;
                }
            }
        }
    }
    
}