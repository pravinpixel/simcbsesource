//using System;
//using System.Data;
//using System.Data.SqlClient;
//using System.Configuration;
//using System.Web;
//using System.Web.Security;
//using System.Web.UI;
//using System.Web.UI.WebControls;
//using System.Web.UI.WebControls.WebParts;
//using System.Web.UI.HtmlControls;
//using System.Collections;

//public class numbertoword
//{
//    string strConnection = null;
//    public SqlConnection sqlCon = null;
//    SqlDataAdapter da = null;
//    SqlCommand sqlCmd = null;

//    public numbertoword()
//    {
//        strConnection = ConfigurationManager.AppSettings["Connection"].ToString();
//        sqlCon = new SqlConnection(strConnection);
//        sqlCon.Open();
//    }
//    public string AmtInWord(decimal Num)
//    {
//        string functionReturnValue = null;
//        //I have created this function for converting amount in indian rupees (INR). 
//        //You can manipulate as you wish like decimal setting, Doller (any currency) Prefix.

//        string strNum = null;
//        string strNumDec = null;
//        string StrWord = null;
//         strNum = Convert.ToString(Num);

//        if (strings.InStr(1, strNum, ".") != 0)
//        {
//            strNumDec = Strings.Mid(strNum, Strings.InStr(1, strNum, ".") + 1);

//            if (Strings.Len(strNumDec) == 1)
//            {
//                strNumDec = strNumDec + "0";
//            }
//            if (Strings.Len(strNumDec) > 2)
//            {
//                strNumDec = Strings.Mid(strNumDec, 1, 2);
//            }

//            strNum = Strings.Mid(strNum, 1, Strings.InStr(1, strNum, ".") - 1);
//            StrWord = (Convert.ToDouble(strNum) == 1 ? " Rupee " : " Rupees ") + NumToWord(Convert.ToDouble(strNum)) + (Convert.ToDouble(strNumDec) > 0 ? " and Paise" + cWord3(Convert.ToDouble(strNumDec)) : "");
//        }
//        else
//        {
//            StrWord = (Convert.ToDouble(strNum) == 1 ? " Rupee " : " Rupees ") + NumToWord(Convert.ToDouble(strNum));
//        }
//        functionReturnValue = StrWord + " Only";
//        return functionReturnValue;
//        return functionReturnValue;
//    }

//    private string NumToWord(double p)
//    {
//        string strNum = null;
//        string StrWord = null;
//        strNum = Convert.ToString(Num);

//        if (Strings.Len(strNum) <= 3)
//        {
//            StrWord = cWord3(Convert.ToDouble(strNum));
//        }
//        else
//        {
//            StrWord = cWordG3(Convert.ToDouble(Strings.Mid(strNum, 1, Strings.Len(strNum) - 3))) + " " + cWord3(Convert.ToDouble(Strings.Mid(strNum, Strings.Len(strNum) - 2)));
//        }
//        return StrWord;
//    }

//    public string NumToWord(double Num)
//    {
//        //I divided this function in two part.
//        //1. Three or less digit number.
//        //2. more than three digit number.
//        string strNum = null;
//        string StrWord = null;
//        strNum = Convert.ToString(Num);

//        if (Strings.Len(strNum) <= 3)
//        {
//            StrWord = cWord3(Convert.ToDouble(strNum));
//        }
//        else
//        {
//            StrWord = cWordG3(Convert.ToDouble(Strings.Mid(strNum, 1, Strings.Len(strNum) - 3))) + " " + cWord3(Convert.ToDecimal (Strings.Mid(strNum, Strings.Len(strNum) - 2)));
//        }
//        return StrWord;
//    }

//    public string cWordG3(double Num)
//    {
//        string functionReturnValue = null;
//        //2. more than three digit number.
//        string strNum = "";
//        string StrWord = "";
//        string readNum = "";
//         strNum = Convert.ToString(Num);
//        if (Strings.Len(strNum) % 2 != 0)
//        {
//            readNum = Convert.ToDouble(Strings.Mid(strNum, 1, 1));
//            if (readNum != "0")
//            {
//                StrWord = retWord(readNum);
//                readNum = Convert.ToDouble("1" + strReplicate("0", Strings.Len(strNum) - 1) + "000");
//                StrWord = StrWord + " " + retWord(readNum);
//            }
//            strNum = Strings.Mid(strNum, 2);
//        }
//        while (!(Strings.Len(strNum) == 0))
//        {
//            readNum = Convert.ToDouble(Strings.Mid(strNum, 1, 2));
//            if (readNum != "0")
//            {
//                StrWord = StrWord + " " + cWord3(readNum);
//                readNum = Convert.ToDouble("1" + strReplicate("0", Strings.Len(strNum) - 2) + "000");
//                StrWord = StrWord + " " + retWord(readNum);
//            }
//            strNum = Strings.Mid(strNum, 3);
//        }
//        functionReturnValue = StrWord;
//        return functionReturnValue;
//        return functionReturnValue;
//    }

//    public string cWord3(double Num)
//    {
//        string functionReturnValue = null;
//        //1. Three or less digit number.
//        string strNum = "";
//        string StrWord = "";
//        string readNum = "";
//        if (Num < 0)
//            Num = Num * -1;
//         strNum = Convert.ToString(Num);

//        if (Strings.Len(strNum) == 3)
//        {
//            readNum = Convert.ToDouble(Strings.Mid(strNum, 1, 1));
//            StrWord = retWord(readNum) + " Hundred";
//            strNum = Strings.Mid(strNum, 2, Strings.Len(strNum));
//        }

//        if (Strings.Len(strNum) <= 2)
//        {
//            if (Convert.ToDouble(strNum) >= 0 & Convert.ToDouble(strNum) <= 20)
//            {
//                StrWord = StrWord + " " + retWord(Convert.ToDouble(strNum));
//            }
//            else
//            {
//                StrWord = StrWord + " " + retWord(Convert.ToDouble(Strings.Mid(strNum, 1, 1) + "0")) + " " + retWord(Convert.ToDouble(Strings.Mid(strNum, 2, 1)));
//            }
//        }

//        strNum = Convert.ToString(Num);
//        functionReturnValue = StrWord;
//        return functionReturnValue;
//        return functionReturnValue;
//    }

//    public string retWord(double Num)
//    {
//        string functionReturnValue = null;
//        //This two dimensional array store the primary word convertion of number.
//        functionReturnValue = "";
//        object[,] ArrWordList = {
//        {
//            0,
//            ""
//        },
//        {
//            1,
//            "One"
//        },
//        {
//            2,
//            "Two"
//        },
//        {
//            3,
//            "Three"
//        },
//        {
//            4,
//            "Four"
//        },
//        {
//            5,
//            "Five"
//        },
//        {
//            6,
//            "Six"
//        },
//        {
//            7,
//            "Seven"
//        },
//        {
//            8,
//            "Eight"
//        },
//        {
//            9,
//            "Nine"
//        },
//        {
//            10,
//            "Ten"
//        },
//        {
//            11,
//            "Eleven"
//        },
//        {
//            12,
//            "Twelve"
//        },
//        {
//            13,
//            "Thirteen"
//        },
//        {
//            14,
//            "Fourteen"
//        },
//        {
//            15,
//            "Fifteen"
//        },
//        {
//            16,
//            "Sixteen"
//        },
//        {
//            17,
//            "Seventeen"
//        },
//        {
//            18,
//            "Eighteen"
//        },
//        {
//            19,
//            "Nineteen"
//        },
//        {
//            20,
//            "Twenty"
//        },
//        {
//            30,
//            "Thirty"
//        },
//        {
//            40,
//            "Forty"
//        },
//        {
//            50,
//            "Fifty"
//        },
//        {
//            60,
//            "Sixty"
//        },
//        {
//            70,
//            "Seventy"
//        },
//        {
//            80,
//            "Eighty"
//        },
//        {
//            90,
//            "Ninety"
//        },
//        {
//            100,
//            "Hundred"
//        },
//        {
//            1000,
//            "Thousand"
//        },
//        {
//            100000,
//            "Lakh"
//        },
//        {
//            10000000,
//            "Crore"
//        }
//    };

//        int i = 0;
//        for (i = 0; i <= Information.UBound(ArrWordList); i++)
//        {
//            if (Num == ArrWordList[i, 0])
//            {
//                functionReturnValue = ArrWordList[i, 1];
//                break; // TODO: might not be correct. Was : Exit For
//            }
//        }
//        return functionReturnValue;
//        return functionReturnValue;
//    }

//    public string strReplicate(string str, int intD)
//    {
//        string functionReturnValue = null;
//        //This fucntion padded "0" after the number to evaluate hundred, thousand and on....
//        //using this function you can replicate any Charactor with given string.
//        int i = 0;
//        functionReturnValue = "";
//        for (i = 1; i <= intD; i++)
//        {
//            functionReturnValue = functionReturnValue + str;
//        }
//        return functionReturnValue;
//        return functionReturnValue;
//    }
//}