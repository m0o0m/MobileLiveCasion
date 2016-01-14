
//桌子状态
const const_TableMessage:Object={en:["Start Bet","Stop Bet","Player Insurance,Please Bet","Banker Insurance,Please Bet","Caculating again"],
								 ch:["已开局,请投注","停止投注","闲保险,请投注","庄保险,请投注","重新结算"],
								 tw:["已開局,請投注","停止投注","閒保險,請投注","莊保險,請投注","重新結算"]};
//投注状态
const const_BetMessage:Object={en:["Bet Successfully","Bet Failt","Status Error","Last bet not back","Over MaxBet","Under MinBet","Open the card, please a bet"],
   							   ch:["投注成功","投注失败","不在投注状态","上次提交还没有返回","该位置已达最大投注","筹码小于该位置最小投注","开牌中,请下一局投注"],
  							   tw:["投注成功","投注失敗","不在投注狀態","上次提交還沒有返回","該位置已達最大投注","籌碼小於該位置最小投注","開牌中,請下一局投注"]};
//投注失败信息
const const_ErrBetMessage:Object={  en:["(Status Error)","(Status Error)","(Status Error)","(Balance Insufficent)","(BetPosition Error)","(BetLimit Error)","(BetLimit Error)","(Over MaxBet)","(Over MaxWinLose)","(Member Error)"],
									ch:["(不在投注状态)","(不在投注状态)","(不在投注状态)","(余额不足)","(投注位置无效)","(限额错误)","(限额错误)","(超过限额)","(超过上限设置最大输赢)","(获取会员信息错误)"],
									tw:["(不在投注狀態)","(不在投注狀態)","(不在投注狀態)","(餘額不足)","(投注位置無效)","(限額錯誤)","(限額錯誤)","(超過限額)","(超過上限設置最大輸贏)","(獲取會員信息錯誤)"]};
//投注位置与按钮解释信息
const const_BetPosLimit:Object={en:[["Bet","MinBet:$min$","MaxBet:$max$"],["Confirm Bet","ReBet","CancelBet","DeleteBet"]],
								ch:[["下注","最小投注:$min$","最大投注:$max$"],["确认投注","重复投注","取消投注","撤消投注"]],
								tw:[["下注","最小投注:$min$","最大投注:$max$"],["確認投注","重複投注","取消投注","撤消投注"]]
};
//桌面显示信息
const const_Other:Object={en:["GameNo:","Balance:","Bet: $betvalue$   Win: $win$"],
  						  ch:["游戏编号:","余额:","投注: $betvalue$   赢: $win$"],
  						  tw:["遊戲編號:","餘額:","投注: $betvalue$   贏: $win$"]
};
//输赢信息
const const_Win:Object={en:["Win","Lose"],
						ch:["本局赢","本局输"],
						tw:["本局贏","本局輸"]};
//显示投注位置
const const_BetPos:Object={en:[["Player","Banker","Tie","PP","BP","Big","Small","PI","BI"],["Tie","Dragon","Tiger"],["Direct","Separate","Three","Street","Triangle","Line","Big","Small","Odd","Even","Red","Black","1stDozen","2ndDozen","3rdDozen","1stRow","2ndRow","3rdRow"]],
							ch:[["闲","庄","和","闲对","庄对","大","小","闲保险","庄保险"],["和","龙","虎"],["直接注","分注","三注","街注","角注","线注","大","小","单","双","红","黑","第一打","第二打","第三打","第一列","第二列","第三列"]],
							 tw:[["閒","莊","和","閒對","莊對","大","小","閒保險","莊保險"],["和","龍","虎"],["直接注","分注","三注","街注","角注","線注","大","小","單","雙","紅","黑","第一打","第二打","第三打","第一列","第二列","第三列"]]
							}
/*
 * 返回当前桌子状态信息
*/
const MessageType_Table:int = 1;
const MT_Table_StartBetting:int = 0;
const MT_Table_StopBetting:int = 1;
const MT_PlayerInsurance_StartBetting:int = 2;
const MT_BankerInsurance_StartBetting:int = 3;
const MT_GameBack:int = 4;

const MessageType_Bet:int = 2;
const MT_Bet_Sucess:int = 0;
const MT_Bet_Fail:int = 1;
const MT_Bet_Status:int = 2;
const MT_Bet_Submit:int = 3;
const MT_Bet_Over:int = 4;
const MT_Bet_Down:int = 5;
const MT_Bet_Out:int = 6;

function ShowTMessage (type:int, msgNo:int,lang="ch"):String {
	var str:String = null;
	var tablelist:Object = null;
	if (type == MessageType_Table) {
		tablelist = const_TableMessage[lang];
		if (tablelist==null) {
			tablelist = const_TableMessage["en"];
		}
	} else if (type == MessageType_Bet) {
		tablelist = const_BetMessage[lang];
		if (tablelist==null) {
			tablelist = const_BetMessage["en"];
		}
	}
	if (msgNo<tablelist.length) {
		str = String(tablelist[msgNo]);
		if(str){
			return str;
		}
	}
	return "";
}
/*
 * 返回当前投注状态信息 
*/
function ShowBMessage (msgNo:int, errorList:Array,lang="ch"):String {
	var str:String = null;
	var betlist:Object = const_BetMessage[lang];
	if (betlist==null) {
		betlist = const_BetMessage["en"];
	}
	if (betlist) {
		str = String(betlist[msgNo]);
		if(str){
			return str;
		}
	}
	return "";
}
/*
 * 返回当前具体投注失败信息
 *@betStatus:true投注成功，false失败
 *@errorList：失败列表。index=0：失败位置，index=1失败类型
*/
function ShowErroeMessage (msgNo:int, errorList:Array,lang="ch"):String {
	var str:String = null;
	var m_errorlist = const_ErrBetMessage[lang];
	if (m_errorlist==null) {
		m_errorlist = const_ErrBetMessage["en"];
	}
	if (msgNo==MT_Bet_Fail) {
		if (int(errorList[1])>= 10) {
			str = m_errorlist[9];
		} else {
			str = m_errorlist[errorList[1]-1];
		}
		if(str && errorList[1]){
			str = str + "errId:200."+ errorList[1];
		 	return str;
		}
	}
	return "";
}
/*
 *返回投注位置、按钮显示框信息
 *
*/
function ShowBetPosMessage (lang="ch"):Array {
	var arr:Array = const_BetPosLimit[lang];
	if (arr==null) {
		arr = const_BetPosLimit["en"];
	}
	return arr;
}
/*
 *返回投注位置、按钮显示框信息
 *
*/
function GetOther (index:int,lang="ch"):String {
	var other:Array = const_Other[lang];
	if (other==null) {
		other = const_Other["en"];
	}
	if (other[index]) {
		return other[index];
	}
	return null;
}
/*
 *返回投注位置、按钮显示框信息
 *
*/
function GetWin (type:int,lang="ch"):String {
	var m_win:Array = const_Win[lang];
	if (m_win==null) {
		m_win = const_Win["en"];
	}
	if (m_win[type]) {
		return m_win[type];
	}
	return null;
}
import CommandProtocol.GameKindEnum;
function GetBetPos(gameType:Number,w_betpos:int,lang="ch"):String{
	var str:String=null;
	var betposlist:Array=const_BetPos[lang];
	if(betposlist==null){
		betposlist=const_BetPos["en"];
	}
	switch(gameType){
		case GameKindEnum.Baccarat:
		case GameKindEnum.InsuranceBaccarat:
		case GameKindEnum.VipBaccarat://百家乐
		str=betposlist[0][w_betpos-1];
		break;
		case GameKindEnum.DragonTiger://龙虎
		str=betposlist[1][w_betpos-1];
		break;
		case GameKindEnum.Roulette://轮盘
		var index:int = 0;
			if ((w_betpos <= 0)) {
				return null;
			} else if ((w_betpos < 38)) {
				index = 0;
			} else if ((w_betpos < 98)) {
				index = 1;
			} else if ((w_betpos < 100)) {
				index = 2;
			} else if ((w_betpos < 112)) {
				index = 3;
			} else if ((w_betpos < 134)) {
				index = 4;
			} else if ((w_betpos < 145)) {
				index = 5;
			} else if ((w_betpos == 145)) {
				index = 7;
			} else if ((w_betpos == 146)) {
				index = 6;
			} else if ((w_betpos == 147)) {
				index = 10;
			} else if ((w_betpos == 148)) {
				index = 11;
			} else if ((w_betpos == 149)) {
				index = 8;
			} else if ((w_betpos == 150)) {
				index = 9;
			} else if ((w_betpos == 151)) {
				index = 12;
			} else if ((w_betpos == 152)) {
				index = 13;
			} else if ((w_betpos == 153)) {
				index = 14;
			} else if ((w_betpos == 154)) {
				index = 15;
			} else if ((w_betpos == 155)) {
				index = 16;
			} else if ((w_betpos == 156)) {
				index = 17;
			} else {
				index = 18;
			}
			if (betposlist.length>=2) {
				str = betposlist[2][index];
			}
			break;
		default:
		break;
	}
	return str;
}