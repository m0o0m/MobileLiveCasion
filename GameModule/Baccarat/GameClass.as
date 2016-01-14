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
		protected var m_LookCardPosition:int = 0;
		//构造函数
		public function GameClass () {
			super ();
			m_wChairCount = 7;
			m_BetPosCount = 7;
		}
		//声音
		protected override function InitGameSound ():void {
			super.InitGameSound ();
			switch(m_lang){
				case "ch":
				case "tw":
					m_sound.SetType (SoundConst.Bacc_zh);
				break;
				default:
					m_sound.SetType (SoundConst.Bacc_en);
				break;
			}
			m_sound.LoadXml ("Sound/Bacc.xml");
		}
		//查询游戏类接口
		public function QueryIGameClass ():IGameClass {
			return this as GameBaseClass as IGameClass;
		}
		//获取游戏视图
		protected function GetPeerGameView ():GameView {
			if ((m_GameClientView == null)) {
				throw Error("GetPeerGameView m_GameClientView == null");
				return null;
			}
			return m_GameClientView as GameView;
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



		//////////////////////////////////////
		//辅助函数
		protected var m_Insurance:int;
		protected var m_endResult:Boolean;
		protected override function SubGameSubCmd (wSubCmdID:uint,pData:String):Boolean {
			//trace (((("wSubCmdID=" + wSubCmdID) + ";pData=") + pData));
			switch (wSubCmdID) {
				case GameForBaccarat.StartBet ://开始下注
					var startBet:cmdBaccStartBetToMember = cmdBaccStartBetToMember.FillData(pData);
					if (startBet.Insurance == 0) {
						//播放开始投注
						GetPeerGameView().PlaySound (SoundConst.StartBet,null);
						m_LookCardPosition = 0;
						//重置游戏
						if(startBet.Reset){
						  ResetGameClass ();
						  //变更椅子
						   GetPeerGameView().StartChangeChair();
						}
						//显示开始投注提示框;
						GetPeerGameView().ShowTableMessage (MessageType_Table,MT_Table_StartBetting);
					}
					//设置投注位置可以投注;
					GetPeerGameView().SetBetStatus (true);
					//设置游戏状态;
					SetGameStatus (1);
					//计时
					GetPeerGameView().ShowBetTime (startBet.BetTime,startBet.DiffTime);
					//保险;
					if (startBet.Insurance > 0) {
						if (startBet.Insurance == 1) {
							//显示闲保险投注提示框;
							GetPeerGameView().ShowTableMessage (MessageType_Table,MT_PlayerInsurance_StartBetting);
						}
						if (startBet.Insurance == 2) {
							//显示庄保险投注提示框;
							GetPeerGameView().ShowTableMessage (MessageType_Table,MT_BankerInsurance_StartBetting);
						}
						m_LookCardPosition = 2;
						GetPeerGameView().SetOdds (startBet.Odds);
					}
					
					GetPeerGameView().SetInsurance (startBet.Insurance);
					m_Insurance = startBet.Insurance;
					m_endResult=true;
					break;
				case GameForBaccarat.StopBet ://停止下注
					//播放停止投注
					GetPeerGameView().PlaySound (SoundConst.StopBet,null);
					//设置游戏状态
					SetGameStatus (0);
					//清理投注还没有投注筹码
					CancelBetChips ();
					
					
					if (m_Insurance==0) {
						SaveRepeatBetList ();
						//创建PK显示
						GetPeerGameView().ShowPkManager ();
					}
					//设置投注按钮不可用;
					GetPeerGameView().SetBetStatus (false);

					//显示结算中;
					GetPeerGameView().BetOver ();

					//显示提示框;
					GetPeerGameView().ShowTableMessage (MessageType_Table,MT_Table_StopBetting);
					break;
				case GameForBaccarat.NextRound ://下一轮
					if ((pData == "0")) {

					}
					break;
				case GameForBaccarat.CardInfo ://开结果
					var cardInfo:cmdBaccCardInfo = cmdBaccCardInfo.FillData(pData);
					if (cardInfo) {
						if (m_tableInfo.ControlMode == ControlModeEnum.HandStart && 
							cardInfo.IsLookCard && 
							m_LookCardPosition > 0 && 
							m_LookCardPosition == cardInfo.Position ) {
							//创建
							GetPeerGameView().CreaditCard (m_tableInfo.HostMember == m_dwUserID ? 1:2,m_tableInfo.GameKind);
							GetPeerGameView().SetCardNum (cardInfo.Index,cardInfo.Position,cardInfo.CardNum,true);
						}
						if(m_endResult){
							GetPeerGameView().ShowPk (cardInfo.IsLookCard,cardInfo.CardNum,cardInfo.Index,cardInfo.Position,m_LookCardPosition,m_isHost);
						}else{
							GetPeerGameView().ReplaceCard(cardInfo.IsLookCard,cardInfo.CardNum,cardInfo.Index,cardInfo.Position,m_LookCardPosition,m_isHost);
						}
					}
					break;
				case GameForBaccarat.OpenResult ://开结果
				    var openResult:cmdOpenResult=cmdOpenResult.FillData(pData)
					if(openResult.err<0){
						//trace("眯牌错误")
						m_LookCardPosition=0;
					}else{
						if ((openResult.LookCard == 1)||  (openResult.LookCard == 2)) {//通知眯牌 1:庄;2:闲;
							m_LookCardPosition = int(openResult.LookCard);
							}
							if(openResult.LookTime>0){
								GetPeerGameView().SetLookCardDiffTime(openResult.LookTime);
							}
						}
					break;
				case GameForBaccarat.BaccResult ://开结果
					//pk堆显示输赢
					var baccResult:cmdBaccResult = cmdBaccResult.FillData(pData);
					if (baccResult) {
						GetPeerGameView().ShowResult (baccResult.RoadInfo);
					}
					//赢的地方闪烁;
					PlayWin (baccResult.RoadInfo);
					break;
				case GameForBaccarat.EndResult ://结算完成
					GetPeerGameView().ShowAllCardInfo ();
					if(pData=="0"){
						m_endResult=false;
						m_GameClientView.HideResultBg();
						m_GameClientView.GameBack();
						ReturnBack();
						GetPeerGameView().ShowTableMessage (MessageType_Table,MT_GameBack);
						//trace("重新结算");
						return true;
				   }
					//移动筹码;
					m_GameClientView.StartMove ();
					break;
				case GameForBaccarat.LookCard :
					if (m_tableInfo.ControlMode == ControlModeEnum.HandStart) {
						var look:cmdBaccLookCard = cmdBaccLookCard.FillData(pData);
						if (m_tableInfo.HostMember != m_dwUserID && look.Position==m_LookCardPosition) {
							GetPeerGameView().SetMoveData (look.Index,look.Side);
						} else if(look.Show && m_tableInfo.HostMember == m_dwUserID && look.Position==m_LookCardPosition){
							GetPeerGameView().OpenMainCard(look.Index);
						}
						if (look.Show) {
							switch(look.Position){
							case 2:
							GetPeerGameView().ShowBCardInfo (look.Index);
							break;
							case 1:
							GetPeerGameView().ShowPCardInfo (look.Index);
							break;
							}
						}
					}
					break;
				case GameForBaccarat.ChangeBoot :
					//播放更换牌靴
					GetPeerGameView().PlaySound (SoundConst.ChangeBoot,null);
					if ((pData == "0")) {

					}
					break;
				case GameForBaccarat.ChangeDealer :
					if ((pData == "0")) {

					}
					break;
			}
			return true;
		}

		//获取赢投注位置列表
		protected override function GetWinBetPosList (result:String):Array {
			if (((result == null) || result == "")) {
				return null;
			}
			var betPosList:Array = new Array  ;
			var pbWin:String = result.substr(0,1);
			switch (pbWin) {
				case "0" :
					betPosList.push (BetPosition.Tie);
					break;
				case "1" :
					betPosList.push (BetPosition.Banker);
					break;
				case "2" :
					betPosList.push (BetPosition.Player);
					break;
			}
			if (result.substr(1,1) == "1") {
				betPosList.push (BetPosition.BankerPair);
			}
			if (result.substr(2,1) == "1") {
				betPosList.push (BetPosition.PlayerPair);
			}
			if (result.substr(3,1) == "1") {
				betPosList.push (BetPosition.Big);
			} else {
				betPosList.push (BetPosition.Small);
			}
			return betPosList;
		}
		override public function ActiveUserItem (pActiveUserData:cmdMemberInfo):Boolean {
			if (super.ActiveUserItem(pActiveUserData)) {
				if (m_tableInfo.ControlMode == ControlModeEnum.HandStart && m_tableInfo.GameKind == 8 && m_tableInfo.HostMember == m_dwUserID) {
					GetPeerGameView().ShowControlPane ();
				}
				return true;
			}
			return false;
		}
		override public function SetTableStatus (tableStatus:cmdMemberTableStatus):void {
			super.SetTableStatus (tableStatus);
			if (m_tableInfo.ControlMode == ControlModeEnum.HandStart && m_tableInfo.GameKind == GameKindEnum.VipBaccarat && tableStatus.HostMember == m_dwUserID) {
				GetPeerGameView().ShowControlPane ();
			}
		}
		public function ControlOpenCard (lookCard:Boolean):void {
			var pData:String = "0";
			if (lookCard) {
				pData = "1";
			}
			SendData (GameForBaccarat.OpenResult,pData);
		}
		public function ControlNextRound ():void {
			SendData (GameForBaccarat.NextRound,"");
		}
		public function ControlChangeDealer ():void {
			SendData (GameForBaccarat.ChangeDealer,"");
		}
		public function ControlChangeBoot ():void {
			SendData (GameForBaccarat.ChangeBoot,"");
		}
		public function SendLookCard (data:String,openCard:Boolean,index:int,position:int):void {
			var look:cmdBaccLookCard = new cmdBaccLookCard  ;
			look.Chair = this.m_wChairID;
			look.Index = index;
			look.Position = position;
			look.Show = openCard;
			look.Side = data;
			SendData (GameForBaccarat.LookCard,look.PushData());
		}
		public function OpenCard(openCard:Boolean,index:int,position:int):void{
			var look:cmdBaccLookCard = new cmdBaccLookCard  ;
			look.Chair = this.m_wChairID;
			look.Index = index;
			look.Position = position;
			look.Show = openCard;
			look.Side = "";
			SendData (GameForBaccarat.LookCard,look.PushData());
		}
	}
}
include "../Common/GameMessage.as"