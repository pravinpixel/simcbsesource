using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

/// <summary>
/// Summary description for IUserPermission
/// </summary>
public class IUserPermission
{
     int _UserId;
     int _MenuId;
     int _ParentId;
     int _ModuleId;
     int _PermissionId;
     string _UserName;
     string _ParentMenuName;
     string _MenuName;
     string _ModuleName;
     bool _AddPrm;
     bool _ViewPrm;
     bool _DeletePrm;
     bool _EditPrm;


    public IUserPermission()
    {
    }
    //public IUserPermission(int userId, int menuId, int parentId, int moduleId, int permissionId, string userName, string parentName,
    //    string menuName, string moduleName, bool addPrm, bool viewPrm, bool deletePrm, bool editPrm)
    //{
    //    //
    //    // TODO: Add constructor logic here
    //    //
    //    _UserId = userId;
    //    _MenuId = menuId;
    //    _ParentId = parentId;
    //    _ModuleId = moduleId;
    //    _PermissionId = permissionId;
    //    _UserName = userName;
    //    _ParentName = parentName;
    //    _MenuName = menuName;
    //    _ModuleName = moduleName;
    //    _AddPrm = addPrm;
    //    _ViewPrm = viewPrm;
    //    _DeletePrm = deletePrm;
    //    _EditPrm = editPrm;
    //}

    public int UserId
    {
        get { return _UserId; }
        set { _UserId = value; }
    }
    public int MenuId
    {
        get { return _MenuId; }
        set { _MenuId = value; }
    }
    public int ParentId
    {
        get { return _ParentId; }
        set { _ParentId = value; }
    }
    public int ModuleId
    {
        get { return _ModuleId; }
        set { _ModuleId = value; }
    }
    public int PermissionId
    {
        get { return _PermissionId; }
        set { _PermissionId = value; }
    }
    public string UserName
    {
        get { return _UserName; }
        set { _UserName = value; }
    }
    public string ParentMenuName
    {
        get { return _ParentMenuName; }
        set { _ParentMenuName = value; }
    }
    public string MenuName
    {
        get { return _MenuName; }
        set { _MenuName = value; }
    }
    public string ModuleName
    {
        get { return _ModuleName; }
        set { _ModuleName = value; }
    }
    public bool AddPrm
    {
        get { return _AddPrm; }
        set { _AddPrm = value; }
    }
    public bool EditPrm
    {
        get { return _EditPrm; }
        set { _EditPrm = value; }
    }
    public bool DeletePrm
    {
        get { return _DeletePrm; }
        set { _DeletePrm = value; }
    }
    public bool ViewPrm
    {
        get { return _ViewPrm; }
        set { _ViewPrm = value; }
    }

}