package {
	import flash.display.MovieClip;
	import flash.utils.ByteArray;
	import flash.geom.Point;
	import flash.utils.setTimeout;

	import CommandProtocol.*;
	import GameModule.Common.*;
	import IGameFrame.*;
	import Net.*;
	//游戏类
	public class GameClass extends GameBaseClass {
		private var m_LookCardPosition:int = 0;

		//构造函数
		public function GameClass() {
			super();
			m_wChairCount =1;
			m_BetPosCount = 3;
		}
		//声音
		protected override function InitGameSound():void {
			super.InitGameSound();
			switch(m_lang){
				case "ch":
				case "tw":
					m_sound.SetType (SoundConst.Dran_ch);
				break;
				default:
					m_sound.SetType (SoundConst.Dran_en);
				break;
			}
			m_sound.LoadXml("Sound/Drag.xml");
		}
		//查询游戏类接口
		public function QueryIGameClass():IGameClass {
			return this as GameBaseClass as IGameClass;
		}
		//获取游戏视图
		protected function GetPeerGameView():GameView {
			if ((m_GameClientView == null)) {
				throw Error("GetPeerGameView m_GameClientView == null");
				return null;
			}
			return m_GameClientView as GameView;
		}
		/////////////////////////////////////
		/////////////////////////////////////
		//创建游戏视图
		override protected function CreateGameView():GameBaseView {
			return new GameView(this);
		}
		//初始化游戏类
		override public function InitGameClass():Boolean {
			if (super.InitGameClass() == false) {
				return false;
			}

			return true;
		}
		//销毁
		override public function DestroyGameClass():void {
			super.DestroyGameClass();
		}



		//////////////////////////////////////
		//辅助函数

		protected override function SubGameSubCmd(wSubCmdID:uint,pData:String):Boolean {
			trace(((("wSubCmdID=" + wSubCmdID) + ";pData=") + pData));
			switch (wSubCmdID) {
				case GameForDragon.StartBet ://开始下注
					//播放开始投注
					GetPeerGameView().PlaySound(SoundConst.StartBet,null);
					m_LookCardPosition = 0;
					var timeTotal:int = 30;
					var dataList:Array = pData.split(',');
					var resetView:Boolean = false;
					if(dataList.length == 2)  {
						pData =dataList[0];
						if(dataList[1] == "1") {
							resetView = true;
						}
					}
					if ((pData != "")) {
						timeTotal = int(pData);
					}
					if (m_tableInfo.ControlMode != ControlModeEnum.HandStart) {
						//GetPeerGameView().SetBetTimer(timeTotal);//倒计时时间.
					}
					//设置游戏状态
					SetGameStatus(1);
					//重置游戏
					if(resetView) {
						ResetGameClass();
					}
					//设置投注位置可以投注
					GetPeerGameView().SetBetStatus(true);
					//显示提示框;
					GetPeerGameView().ShowTableMessage(MessageType_Table,MT_Table_StartBetting);
					break;
				case GameForDragon.StopBet ://停止下注
					//播放停止投注
					GetPeerGameView().PlaySound(SoundConst.StopBet,null);
					if (((pData == "1") || pData == "2")) {//通知眯牌 1:庄;2:闲;
						m_LookCardPosition = int(pData);
					}
					//设置游戏状态
					SetGameStatus(0);
					//清理投注还没有投注筹码
					CancelBetChips();
					SaveRepeatBetList();
					//创建PK显示
					GetPeerGameView().ShowPkManager();
					//设置投注按钮不可用;
					GetPeerGameView().SetBetStatus(false);

					//显示结算中;
					GetPeerGameView().BetOver();

					//显示提示框;
					GetPeerGameView().ShowTableMessage(MessageType_Table,MT_Table_StopBetting);
					break;
				
				case GameForDragon.CardInfo://开结果
					var cardInfo:cmdDragonCardInfo = cmdDragonCardInfo.FillData(pData);
					if (cardInfo) {
						if (m_tableInfo.ControlMode == ControlModeEnum.HandStart) {
							//创建
							
							GetPeerGameView().CreaditCard(m_tableInfo.HostMember == m_dwUserID ? 1:2,m_tableInfo.GameKind);
							GetPeerGameView().SetCardNum(1,cardInfo.Position,cardInfo.CardNum);
						}
						GetPeerGameView().ShowPk(false,cardInfo.CardNum,1,cardInfo.Position,m_LookCardPosition,m_isHost);
					}
					break;
				case GameForDragon.DragonResult ://开结果
					//pk堆显示输赢
					var dragResult:cmdDragonResult = cmdDragonResult.FillData(pData);
					if (dragResult) {
						GetPeerGameView().ShowResult(dragResult.Result);
					}
					//赢的地方闪烁;
					PlayWin(dragResult.Result);
					break;
				case GameForDragon.EndResult ://结算完成
					GetPeerGameView().ShowAllCardInfo();
					//移动筹码;
					m_GameClientView.StartMove();
					break;
				case GameForDragon.ChangeBoot :
					//播放更换牌靴
					GetPeerGameView().PlaySound(SoundConst.ChangeBoot,null);
					if ((pData == "0")) {

					}
					break;
				case GameForDragon.ChangeDealer :
					if ((pData == "0")) {

					}
					break;
				case GameForDragon.CancelRound ://下一轮
					if ((pData == "0")) {

					}
					break;
			}
			return true;
		}

		//获取赢投注位置列表
		protected override function GetWinBetPosList(result:String):Array {
			if (((result == null) || result == "")) {
				return null;
			}
			var betPosList:Array = new Array  ;
			var pbWin:String = result.substr(0,1);
			switch (pbWin) {
				case "0" :
					betPosList.push(BetPosition.Tie);
					break;
				case "1" :
					betPosList.push(BetPosition.Dragon);
					break;
				case "2" :
					betPosList.push(BetPosition.Tiger);
					break;
			}
			return betPosList;
		}
		override public function ActiveUserItem(pActiveUserData:cmdMemberInfo):Boolean {
			if (super.ActiveUserItem(pActiveUserData)) {
				if (m_tableInfo.ControlMode == ControlModeEnum.HandStart && m_tableInfo.GameKind == 8 && m_tableInfo.HostMember == m_dwUserID) {
					GetPeerGameView().ShowControlPane();
				}
				return true;
			}
			return false;
		}
		override public function SetTableStatus(tableStatus:cmdMemberTableStatus):void {
			super.SetTableStatus(tableStatus);
			if (m_tableInfo.ControlMode == ControlModeEnum.HandStart && m_tableInfo.GameKind == GameKindEnum.VipBaccarat && tableStatus.HostMember == m_dwUserID) {
				GetPeerGameView().ShowControlPane();
			}
		}
		public function ControlOpenCard(lookCard:Boolean):void {
			var pData:String = "0";
			if (lookCard) {
				pData = "1";
			}
			SendData(GameForBaccarat.OpenResult,pData);
		}
		public function ControlNextRound():void {
			SendData(GameForBaccarat.NextRound,"");
		}
		public function ControlChangeDealer():void {
			SendData(GameForBaccarat.ChangeDealer,"");
		}
		public function ControlChangeBoot():void {
			SendData(GameForBaccarat.ChangeBoot,"");
		}
	}
}
include "../Common/GameMessage.as";