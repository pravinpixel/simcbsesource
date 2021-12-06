
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data.SqlClient;
using System.Data;
using System.Configuration;

/// <summary>
/// Summary description for IUser
/// </summary>
public class IUser
{
    public IUser()
    {
        //
        // TODO: Add constructor logic here
        //
    }


    public static int AuthenticateUser(string username, string password)
    {
        // validate Parameters
        if (username == null || username.Length == 0)
            throw (new ArgumentOutOfRangeException("username"));
        if (password == null || password.Length == 0)
            throw (new ArgumentOutOfRangeException("password"));


        // Execute SQL Command
        SqlCommand sqlCmd = new SqlCommand();

        AddParamToSQLCmd(sqlCmd, "@ReturnValue", SqlDbType.Int, 0, ParameterDirection.ReturnValue, null);
        AddParamToSQLCmd(sqlCmd, "@Username", SqlDbType.NText, 255, ParameterDirection.Input, username);
        AddParamToSQLCmd(sqlCmd, "@Password", SqlDbType.NText, 255, ParameterDirection.Input, password);

        SetCommandType(sqlCmd, CommandType.StoredProcedure, "sp_AuthenticateUser");
        ExecuteScalarCmd(sqlCmd);
        int returnValue = (int)sqlCmd.Parameters["@ReturnValue"].Value;
        return returnValue;
    }

    //public static IUserPermission GetUserPermission(int userId, int moduleMenuId)
    //{
    //    SqlCommand cmd=new SqlCommand();

    //    AddParamToSQLCmd(cmd,"@UserId", SqlDbType.Int,0,ParameterDirection.Input,userId);
    //    AddParamToSQLCmd(cmd,"@ModuleMenuId", SqlDbType.Int,0,ParameterDirection.Input,moduleMenuId);
    //    SetCommandType(cmd, CommandType.StoredProcedure, "[sp_GetUserPermission]");

    //    return 
    //}

    private static void AddParamToSQLCmd(SqlCommand sqlCmd, string paramId, SqlDbType sqlType, int paramSize, ParameterDirection paramDirection, object paramvalue)
    {
        // Validate Parameter Properties
        if (sqlCmd == null)
            throw (new ArgumentNullException("sqlCmd"));
        if (paramId == string.Empty)
            throw (new ArgumentOutOfRangeException("paramId"));

        // Add Parameter
        SqlParameter newSqlParam = new SqlParameter();
        newSqlParam.ParameterName = paramId;
        newSqlParam.SqlDbType = sqlType;
        newSqlParam.Direction = paramDirection;

        if (paramSize > 0)
            newSqlParam.Size = paramSize;

        if (paramvalue != null)
            newSqlParam.Value = paramvalue;

        sqlCmd.Parameters.Add(newSqlParam);
    }
    private static void SetCommandType(SqlCommand sqlCmd, CommandType cmdType, string cmdText)
    {
        sqlCmd.CommandType = cmdType;
        sqlCmd.CommandText = cmdText;
    }

    private static Object ExecuteScalarCmd(SqlCommand sqlCmd)
    {
        string ConnectionString = ConfigurationManager.AppSettings["SIMCBSEConnection"];
        // Validate Command Properties
        if (ConnectionString == string.Empty)
            throw (new ArgumentOutOfRangeException("ConnectionString"));

        if (sqlCmd == null)
            throw (new ArgumentNullException("sqlCmd"));

        Object result = null;

        using (SqlConnection cn = new SqlConnection(ConnectionString))
        {
            sqlCmd.Connection = cn;
            cn.Open();
            result = sqlCmd.ExecuteScalar();
        }

        return result;
    }

}