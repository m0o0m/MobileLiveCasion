const const_TopText:Object = { en:["Account","Balance"],
							   ch:["用户名称","账户余额"],
							   tw:["用戶名稱","賬戶餘額"]};
const m_loadStatus={en:["Login Failt,ErrID:","Connecting Server","Sitting down"],
					 ch:["登录失败,错误编号:","网络连接中断","正在分配座位"],
					 tw:["登錄失敗,錯誤編號:","網絡連接中斷","正在分配座位"]}

					 
const m_TableInfo={ en:["Total:$CreditTotal$","       Player: <font color='0x808080'>$player$</font> Tie: <font color='0x808080'>$tie$</font> Banker: <font color='0x808080'>$banker$</font>      ","  Big: <font color='0x808080'>$big$</font>   Small: <font color='0x808080'>$small$</font>   Odd: <font color='0x808080'>$odd$</font>   Even: <font color='0x808080'>$even$</font>","  Tiger: <font color='0x808080'>$tiger$</font>   Tie: <font color='0x808080'>$tie$</font>   Dragon: <font color='0x808080'>$dragon$</font>","Online: <font color='0x808080'>$MemberCount$</font> "],
					ch:["桌上总筹码:$CreditTotal$","   闲: <font color='0x808080'>$player$</font>   和: <font color='0x808080'>$tie$</font>   庄: <font color='0x808080'>$banker$</font>"," 大: <font color='0x808080'>$big$</font>   小: <font color='0x808080'>$small$</font>   单: <font color='0x808080'>$odd$</font>   双: <font color='0x808080'>$even$</font>","  虎: <font color='0x808080'>$tiger$</font>   和: <font color='0x808080'>$tie$</font>   龙: <font color='0x808080'>$dragon$</font>","总人数: <font color='0x808080'>$MemberCount$</font> "],
					tw:["桌上總籌碼:$CreditTotal$","  閒: <font color='0x808080'>$player$</font>   和: <font color='0x808080'>$tie$</font>   莊: <font color='0x808080'>$banker$</font>","大: <font color='0x808080'>$big$</font>   小: <font color='0x808080'>$small$</font>   單: <font color='0x808080'>$odd$</font>   雙: <font color='0x808080'>$even$</font>","  虎: <font color='0x808080'>$tiger$</font>   和: <font color='0x808080'>$tie$</font>   龍: <font color='0x808080'>$dragon$</font>","總人數: <font color='0x808080'>$MemberCount$</font> "]
					}
const m_TableStatus={en:["Paused","Waitting","Betting","Openning","Caculating","Finished","ChangingShoe"],
					ch:["暂停","等待开始","投注中","等待开奖","等待结算","完成结算","更换牌靴"],
					tw:["暫停","等待開始","投注中","等待開獎","等待結算","完成結算","更換牌靴"]}

const m_updatePwd={en:["Please input old password","Please input new password","Confirm new password","Old and new are same","New password are not same","Old password error","New password format error","Password length is between 6 and 32","Server busy","Try again"],
				   ch:["旧密码不能为空","新密码不能为空","请确认新密码","新密码与旧密码相同","确认密码与新密码不符","修改成功","旧密码错误","新密码格式错误，密码长度需6-32位","服务器繁忙,请稍后再试"],
				   tw:["舊密碼不能為空","新密碼不能為空","請確認新密碼","新密碼與舊密碼相同","確認密碼與新密碼不符","修改成功","舊密碼錯誤","新密碼格式錯誤，密碼長度需6-32位","服務器繁忙,請稍後再試"]}
const m_otherTable={en:[["Sic Bo","Super Blackjack","3D Live Sic Bo"],[""],["VIP Bacc 4","VIP Bacc 5","VIP Bacc 6"],["Look Bacc 5","Look Bacc 6","Look Bacc 7","Look Bacc 8","Look Bacc 9"]],
					ch:[["骰宝","超级二十一点","3D真人骰宝"],[""],["VIP 4台","VIP 5台","VIP 6台"],["眯牌5台","眯牌6台","眯牌7台","眯牌8台","眯牌9台"]],
					tw:[["骰寶","超級二十一點","3D真人骰寶"],[""],["VIP 4臺","VIP 5臺","VIP 6臺"],["瞇牌5臺","瞇牌6臺","瞇牌7臺","瞇牌8臺","瞇牌9臺"]]}
function GetTopText (type:String, lang:String):String {
	var langList = const_TopText[lang];
	if(langList == null) {
		langList = const_TopText["en"];
	}
	switch (type) {
		case "name" :
			return langList[0];
		case "bal" :
			return langList[1];
	}
	return "";
}
function GetLoadStatus(lang:String="ch"):Array{
	var loadStatuslist:Array=m_loadStatus[lang];
	if(loadStatuslist==null){
		loadStatuslist=m_loadStatus["en"];
	}
	return loadStatuslist;
}
function GetTableInfo(type:String,lang:String="ch"):String{
	var tableInfo:Array=m_TableInfo[lang];
	if(tableInfo==null){
		tableInfo=m_TableInfo["en"];
	}
	switch(type){
		case "total":
		    return tableInfo[0];
			break;
		case "Bacc":
			return tableInfo[1];
			break;
		case "Roul":
			return tableInfo[2];
			break;
		case "Drti":
			return tableInfo[3];
			break;
		case "totalcount":
		    return tableInfo[4];
			break;
	}
	return null;
}
function GetTableStatus(status:int,lang:String="ch"):String{
	var tablestatus:Array=m_TableStatus[lang];
	if(tablestatus==null){
		tablestatus=m_TableStatus["en"];
	}
	if(tablestatus[status]){
		return tablestatus[status];
	}
	return null;
}
function ShowCMDLang(str:String,lang:String="ch"):String{
	var m_tableInfo:Array=str.split("|");
    var index:int=0;
	if(lang=="en"){
		index=0;
	}else if(lang=="ch"){
		index=1;
	}else if(lang=="tw"){
		index=2;
	}else if(lang=="th"){
		index=4;
	}else if(lang=="jp"){
		index=5;
	}else if(lang=="in"){
		index=6;
	}else if(lang=="vn"){
		index=7;
	}else if(lang=="ko"){
		index=8;
	}else if(lang=="kh"){
		index=9;
	}
	if(m_tableInfo.length<index+1){
		return m_tableInfo[0];
	}
	else{
		return m_tableInfo[index];
	}
	return null;
}
function ShowUpdatePwd(index:int,lang:String="ch"):String{
	var updatepwd:Array=m_updatePwd[lang];
	if(updatepwd==null){
		updatepwd=m_updatePwd["en"];
	}
	if(updatepwd[index]){
		return updatepwd[index];
	}
	return null;
}
function ShowOtherTable(index:int,type:int,lang:String="ch"):String{
	var other:Array=m_otherTable[lang];
	if(other==null){
		other=m_otherTable["en"];
	}
	if(other[type-1][index]){
		return other[type-1][index];
	}
	return null;
}
