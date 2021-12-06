	///////////////////// GEneral /////////////////
function GetXmlHttpObject()
{
if (window.XMLHttpRequest)
  {
  // code for IE7+, Firefox, Chrome, Opera, Safari
  return new XMLHttpRequest();
  }
if (window.ActiveXObject)
  {
  // code for IE6, IE5
  return new ActiveXObject("Microsoft.XMLHTTP");
  }
return null;
}	
	
function validation(source)
{
		
		var d=document.deldetails;
		
		var flag=0;
		
		var memid1="";
		
		var flagg = false;
		
	    if(d.checkbox.checked) 
		{
		var flag=1;
		var kannan=d.checkbox.value;
		
		memid1 = memid1 + kannan + ",";
		
		}	
		
		for (var i = 0; i < d.checkbox.length; i++)
		{
			if(d.checkbox[i].checked)
			{
			var flag=1;
			var kannan=d.checkbox[i].value;
			
			memid1 = memid1 + kannan + ",";
			
			}		 
		
		} 
		
		
	    if(flag==0)
		{
					jAlert('Please select any one');

		return false;
		}
		else{
		d.delid.value=memid1;	
		}
		
		jConfirm('Are you sure want to delete?', 'Are you sure?', function(r) {
																		   
			if(r)
			{
				var xmlhttp=GetXmlHttpObject();
				if (xmlhttp==null)
				  {
				  alert ("Browser does not support HTTP Request");
				  return;
				  }
				  
				var delid = memid1;
				var pag = 1;
				
				var url=source +"&delid=" + delid;
				document.location.href=url;
				xmlhttp.onreadystatechange=function()
				{
					  if (xmlhttp.readyState==4)
						{
							//alert(xmlhttp.responseText)
							/*if(xmlhttp.responseText == 1)
							{
								document.location.href = "businesstype_mng.php?msg=ds&page=1";
							}*/
						}
					
				}
				xmlhttp.open("GET",url,true);
				xmlhttp.send(null);	
				
				//window.location = "business_operations.php?act=delBusinesstype&pag=1&delid="+memid1+"&submit=Delete selected"; 
			}
			else
			{
				flagg = false;
				
			}

		});
		return false;

}
		
function checkall()
{
		
		var d=document.deldetails;
		
		if(d.checkbox.length > 1)
		{
		for (var i = 0; i < d.checkbox.length; i++)
		{		 
		
		 d.checkbox[i].checked=true;				 		 
		
		} 
		
		}
		
		else
		
		{
		
		d.checkbox.checked=true;
		
		}			
		return false;
		
}
		
		
function uncheckall()
{
		
		var d=document.deldetails;
		if(d.checkbox.length > 1)
		
		{
		for (var i = 0; i < d.checkbox.length; i++)
		{		 
			 d.checkbox[i].checked=false;	 		 
		} 
		}
		
		else
		{				 
		
		d.checkbox.checked=false;
		
		}
		
		return false;
		
}	

///////////////////End /////////////
	
