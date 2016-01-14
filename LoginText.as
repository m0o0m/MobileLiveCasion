const m_LoginError={en:["Username or password not correct!","Username was closed!","IP is limited!","Post severvice error!"],
					ch:["帐号或密码错误,请重新登陆!","帐号已关闭!","IP限制登录!","请求服务器失败!"],
					tw:["帳號或密碼錯誤,請重新登陸!","帳號已關閉!","IP限制登錄!","請求服務器失敗!"]
					}
const m_LoginText={en:["Account","Password"],
					ch:["账号","密码"],
					tw:["賬號","密碼"]
					}
const m_Loginparam={en:["Please input username!","Please input password!"],
					ch:["请输入账号!","请输入密码!"],
					tw:["請輸入賬號!","請輸入密碼!"]
}
function ShowLoginError(errorcode:Number,lang:String="ch"):String{
	var errorlist:Array=m_LoginError[lang];

	if(errorlist==null){
		errorlist=m_LoginError["en"];
	}
	var error:String="";
		switch(errorcode){
			case 1:
			case 2:
			error=errorlist[0];
			break;
			case 3:
			error=errorlist[1];
			break;
			case 5:
			error=errorlist[2];
			break;
			default:
			error=errorlist[3];
			break;
		}
	return error;
}
function ShowLoginText(index:int,lang:String="ch"):String{
	var textarr:Array=m_LoginText[lang];
	if(textarr==null){
		textarr=m_LoginText["en"];
	}
	if(textarr[index]){
		return textarr[index];
	}
	return "";
}
function ShowAccount(index:int,lang:String="ch"):String{
	var errorlist:Array=m_Loginparam[lang];

	if(errorlist==null){
		errorlist=m_Loginparam["en"];
	}
	if(errorlist[index]){
		return errorlist[index];
	}
	return "";
}
