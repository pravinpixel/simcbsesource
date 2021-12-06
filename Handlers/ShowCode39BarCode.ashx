<%@ WebHandler Language="C#" Class="ShowCode39BarCode" %>

using System;
using System.Web;
using System.Drawing;

public class ShowCode39BarCode : IHttpHandler {
    
    public void ProcessRequest (HttpContext context) {
        context.Response.ContentType = "image/gif";

        var barcode = new Code39BarCode();
        
        // Read in the user's inputs from the querystring
        barcode.BarCodeText = context.Request.QueryString["code"].ToUpper();
        barcode.ShowBarCodeText = context.Request.QueryString["ShowText"] != "0";
        if (context.Request.QueryString["thickness"] == "3")
            barcode.BarCodeWeight = BarCodeWeight.Large;
        else if (context.Request.QueryString["thickness"] == "2")
            barcode.BarCodeWeight = BarCodeWeight.Medium;
        if (!string.IsNullOrEmpty(context.Request.QueryString["Height"]))
            barcode.Height = Convert.ToInt32(context.Request.QueryString["Height"]);
        
        context.Response.BinaryWrite(barcode.Generate());
    }
 
    public bool IsReusable {
        get {
            return false;
        }
    }

}