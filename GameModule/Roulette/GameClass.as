package {
	import flash.display.MovieClip;
	import flash.utils.ByteArray;
	import flash.utils.setTimeout;
	import flash.geom.Point;
	
	import flash.utils.Dictionary;
	import CommandProtocol.*;
	import GameModule.Common.*;
	import IGameFrame.*;
	import Net.*;
	//游戏类
	public class GameClass extends GameBaseClass {
		//构造函数
		public function GameClass () {
			super ();
			m_wChairCount = 1;
			m_BetPosCount = 197;
		}
		//声音
		protected override function InitGameSound ():void {
			m_sound=new GameSound();
			switch(m_lang){
				case "ch":
				case "tw":
					m_sound.SetType (SoundConst.Roul_ch);
				break;
				default:
					m_sound.SetType (SoundConst.Roul_en);
				break;
			}
			m_sound.LoadXml ("Sound/Roul.xml");
		}
		//查询游戏类接口
		public function QueryIGameClass ():IGameClass {
			return this  as  GameBaseClass  as  IGameClass;
		}
		//获取游戏视图
		protected function GetPeerGameView ():GameView {
			if (m_GameClientView == null) {
				throw Error("GetPeerGameView m_GameClientView == null");
				return null;
			}
			return m_GameClientView  as  GameView;
		}
		/////////////////////////////////////
		/////////////////////////////////////
		//创建游戏视图
		override protected function CreateGameView ():GameBaseView {
			return new GameView(this);
		}
		//初始化游戏类
		override public function InitGameClass ():Boolean {
			if (super.InitGameClass() == false) {
				return false;
			}
			return true;
		}
		//销毁
		override public function DestroyGameClass ():void {
			super.DestroyGameClass ();
		}

		protected override function SubGameSubCmd (wSubCmdID:uint,pData:String):Boolean {
			trace ("wSubCmdID="+wSubCmdID+"; pData="+pData);
			switch (wSubCmdID) {
				case GameForRoulette.StartBet ://开始投注
					//播放开始投注
					GetPeerGameView().PlaySound (SoundConst.StartBet,null);
					SetGameStatus (1);
					var dataList:Array = pData.split(',');
					var resetView:Boolean = false;
					if (dataList.length == 2) {
						pData = dataList[0];
						if (dataList[1] == "1") {
							resetView = true;
						}
					}
					//设置游戏状态
					if(resetView){
					 ResetGameClass ();
					}
					//重置游戏
					GetPeerGameView().ShowTableMessage (MessageType_Table,MT_Table_StartBetting);
					//显示开始投注;
					GetPeerGameView().SetBetStatus (true);
					//投注按钮控制(打开成可用状态;//设置投注位置可以投注;
					//GetPeerGameView().SetGameStatus (m_bGameStatus);
					//添加倒计时背景;

					//倒计时时间;
					break;
				case GameForRoulette.StopBet ://停止投注
					//播放停止投注
					GetPeerGameView().PlaySound (SoundConst.StopBet,null);
					GetPeerGameView().BetOver ();
					//倒计时结束;
					SetGameStatus (0);
					//设置游戏状态
					CancelBetChips ();
					//清除未确定下注
					SaveRepeatBetList ();
					//保存本局下注
					GetPeerGameView().ShowTableMessage (MessageType_Table,MT_Table_StopBetting);
					//显示停止投注;
					GetPeerGameView().SetBetStatus (false);
					//投注按钮控制(禁用状态;//设置投注位置不可以投注;
					break;
				case GameForRoulette.BallNum :

					break;
				case GameForRoulette.RouletteResult :
					var result:cmdRouletteResult = cmdRouletteResult.FillData(pData);
					if (result) {
						//播放结果
						GetPeerGameView().PlaySound (SoundConst.GameResoult,result.BallNum);
						//pk堆显示输赢;
						GetPeerGameView().ShowResoult (result.BallNum);
						//赢的地方闪烁;
						PlayWin (result.BallNum);
					}
					break;
				case GameForRoulette.EndResult :
					//移动筹码
					GetPeerGameView().StartMove ();
					break;
			}
			return false;
		}
		//@result结果
		//@betposlist[数字,红黑,单双,打，列，大小
		private var betposlist:Dictionary;
		protected override function GetWinBetPosList (result:String):Array {
			if (betposlist==null) {
				betposlist=new Dictionary();
				betposlist["0"] = [0];
				betposlist["1"] = [1,146,148,150,153,144];
				betposlist["2"] = [2,147,149,150,154,144];
				betposlist["3"] = [3,146,148,150,155,144];
				betposlist["4"] = [4,147,149,150,153,144];
				betposlist["5"] = [5,146,148,150,154,144];
				betposlist["6"] = [6,147,149,150,155,144];
				betposlist["7"] = [7,146,148,150,153,144];
				betposlist["8"] = [8,147,149,150,154,144];
				betposlist["9"] = [9,146,148,150,155,144];
				betposlist["10"] = [10,147,149,150,153,144];
				betposlist["11"] = [11,147,148,150,154,144];
				betposlist["12"] = [12,146,149,150,155,144];
				betposlist["13"] = [13,147,148,151,153,144];
				betposlist["14"] = [14,146,149,151,154,144];
				betposlist["15"] = [15,147,148,151,155,144];
				betposlist["16"] = [16,146,149,151,153,144];
				betposlist["17"] = [17,147,148,151,154,144];
				betposlist["18"] = [18,146,149,151,155,144];
				betposlist["19"] = [19,146,148,151,153,145];
				betposlist["20"] = [20,147,149,151,154,145];
				betposlist["21"] = [21,146,148,151,155,145];
				betposlist["22"] = [22,147,149,151,153,145];
				betposlist["23"] = [23,146,148,151,154,145];
				betposlist["24"] = [24,147,149,151,155,145];
				betposlist["25"] = [25,146,148,152,153,145];
				betposlist["26"] = [26,147,149,152,154,145];
				betposlist["27"] = [27,146,148,152,155,145];
				betposlist["28"] = [28,147,149,152,153,145];
				betposlist["29"] = [29,147,148,152,154,145];
				betposlist["30"] = [30,146,149,152,155,145];
				betposlist["31"] = [31,147,148,152,153,145];
				betposlist["32"] = [32,146,149,152,154,145];
				betposlist["33"] = [33,147,148,152,155,145];
				betposlist["34"] = [34,146,149,152,153,145];
				betposlist["35"] = [35,147,148,152,154,145];
				betposlist["36"] = [36,146,149,152,155,145];
			}
			if (betposlist[result]) {
				var m_WinBetPosList:Array=new Array();
				m_WinBetPosList = betposlist[result];
				return m_WinBetPosList;
			}
			return null;
		}
		override public function OnSendBet ():Boolean {
			//不在投注状态
			if (m_bGameStatus != 1) {
				m_GameClientView.ShowTableMessage (MessageType_Bet, MT_Bet_Status);
				return false;
			}
			if (m_SubmitStatus) {
				m_GameClientView.ShowTableMessage (MessageType_Bet, MT_Bet_Submit);
				return true;
			}
			SetBetPosLimit ();
			m_SubmitStatus = true;
			var bet:cmdMemberBet = new cmdMemberBet();
			bet.memID = m_dwUserID;
			bet.TableID = m_wTableID;
			bet.Chair = m_wChairID;
			bet.GameRoundNo = m_tableInfo.GameRoundNo;
			var betTotal:int = 0;
			var index:int = 0;
			var sum:int = 0;
			while (index < m_BetTotalList.length) {
				if (m_BetTotalList[index]) {
					var betMoney:int = int(m_BetTotalList[index][1]);
					var m_BetMoney:int = betMoney + int(m_BetTotalList[index][0]);
					if (m_BetMoney > 0) {
						//判断位置最大投注和最小投注(未实现)
						if (m_BetMoney > betlimitByPos[index]) {
							//提示超过最大投注
							trace ("发送下注 提示超过最大投注");
							m_SubmitStatus = false;
							m_GameClientView.ShowBetMessage (MT_Bet_Fail, [index, 8]);
							return false;
						}
						if (m_BetMoney < minbetlimitByPos[index]) {
							//提示低于最小投注
							trace ("发送下注 提示低于最小投注");
							m_SubmitStatus = false;
							m_GameClientView.ShowBetMessage (MT_Bet_Fail, [index, 6]);
							return false;
						}
						//累计总投注
						betTotal +=  m_BetMoney;
					}
					sum +=  int(m_BetTotalList[index][1]);
				}
				index++;
			}
			if (betTotal < m_MinBet) {
				//提示低于最小投注
				trace ("发送下注 提示低于最小投注");
				m_SubmitStatus = false;
				m_GameClientView.ShowBetMessage (MT_Bet_Fail, [index, 6]);
				return false;
			}
			if (betTotal>m_MaxBet*100) {
				//提示超出桌面最大投注
				trace ("发送下注 提示超出桌面投注");
				m_SubmitStatus = false;
				m_GameClientView.ShowBetMessage (MT_Bet_Fail, [index, 9]);
				return false;
			}
			//播放余额不足
			if (sum>m_pMeUserItem.Balance) {
				m_GameClientView.PlaySound (SoundConst.LackBalance,null);
				m_GameClientView.ShowBetMessage (MT_Bet_Fail, [index, 4]);
				m_SubmitStatus = false;
				return false;
			}
			//判断投注是否超过额度(未实现)
			//判断是否超过信用(未实现)
			//投注
			m_BetErrorList = new Array();

			index = 0;
			var betPosition:Array=new Array();
			var betAmount:Array=new Array();
			while (index < m_BetTotalList.length) {
				if (m_BetTotalList[index] && m_BetTotalList[index][1]) {
					betMoney = int(m_BetTotalList[index][1]);
					if (betMoney > 0) {
						betPosition.push (index.toString());
						betAmount.push (betMoney.toString());
						m_BetCount++;
					}
				}
				index++;
			}
			bet.BetPosition = betPosition.join("|");
			bet.BetAmount = betAmount.join("|");
			if (SendData(GameForMember.Bet, bet.PushData()) == false) {
				trace ("发送下注 发送投注");
				m_SubmitStatus = false;
				m_GameClientView.ShowBetMessage (MT_Bet_Fail, [index, 5]);
				return false;
			}
			return true;
		}
	}
}
include "../Common/GameMessage.as"