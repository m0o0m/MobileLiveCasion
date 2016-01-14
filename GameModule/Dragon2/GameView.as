package {
	import flash.display.MovieClip;
	import flash.display.Graphics;
	import flash.display.BitmapData;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextFormat;

	import Common.*;
	import GameModule.Common.*;
	import IGameFrame.*;
	import Net.*;
	import GameModule.Common.PK.PKShowBaseManager;
	import CommandProtocol.cmdMemberInfo;
	import CommandProtocol.cmdMemberTableInfo;
	import CommandProtocol.GameKindEnum;
	import GameModule.Common.InfoPane.*;

	//游戏视图
	public class GameView extends GameBaseView implements IFlipCardPane {
		protected var m_PkShowManager:PKShowBaseManager;//Pk显示管理
		protected var m_chairManager:MovieClip;//全部椅子
		protected var m_betStatusPos:Point = new Point(134.90,1.70);//投注状态位置
		protected var returnLobby:Object;//返回大厅按钮
		protected var m_IFlipCard:IFlipCard;

		protected var m_memTotalBet:Number = 0;
		protected var m_class:GameClass;
		
		protected var m_showroad:MovieClip;

		//构造函数
		public function GameView (prarentClass:GameClass) {
			super (prarentClass);
			m_PlayerPoint = new Point(205,187);
			m_PlayerWidth = 1280;
			m_PlayerHeight = 720;
			m_class = prarentClass;
			m_BetTimerPoint = new Point(1300,946);
			m_centerPoint = new Point(639,554);
			m_ChairViewList = null;
			m_ShowChair = false;
		}

		public override function InitGameView ():Boolean {
			if (super.InitGameView() == false) {
				return false;
			}

			InitChairManager ();

			if (m_chairManager && m_BetPosManager) {
				var index = this.getChildIndex(m_BetPosManager);
				this.setChildIndex (m_chairManager,index-1);
			}
			InitPkShowManger ();
			if(this.getChildByName("mc_roadlang")){
				m_showroad=this["mc_roadlang"];
				m_showroad.stop();
			}
			return true;
		}
		public override function DestroyGameView ():void {
			if (m_chairManager) {
				m_chairManager.Destroy ();
				removeChild (m_chairManager);
				m_chairManager = null;
			}
			if (m_BetTimer) {
				m_BetTimer.Destroy ();
				m_BetTimer = null;
			}
			if (m_IFlipCard) {
				m_IFlipCard.Destroy ();
				removeChild (m_IFlipCard.GetMovieClip());
				m_IFlipCard = null;
			}
			
			if (m_HisResultManager) {
				m_HisResultManager.Destroy ();
				var mc:MovieClip=m_HisResultManager.GetMovieClip();
				removeChild(mc);
				m_HisResultManager = null;
			}
			
			super.DestroyGameView ();
		}

		//还原视图
		public override function ResetGameView ():void {
			//ShowLeftBetInfo (0, 0);
			super.ResetGameView ();
			if (m_PkShowManager) {
				m_PkShowManager.ClearPk ();
			}
			if (m_IFlipCard) {
				m_IFlipCard.Reset ();
				m_IFlipCard.GetMovieClip().visible = false;
			}
		}

		//创建PK显示管理
		public function InitPkShowManger ():void {
			m_PkShowManager = new PKShowManager();
			m_PkShowManager.SetLang (m_lang);
			m_PkShowManager.SetGameView (this);
			m_PkShowManager.visible = true;
			m_PkShowManager.x=1490;
			m_PkShowManager.y=206;
			addChild(m_PkShowManager);
			if(this.getChildByName("mc_shadowPK")){
				this.setChildIndex(m_PkShowManager,this.getChildIndex(this.getChildByName("mc_shadowPK")));
			}

		}

		//销毁PK显示管理
		public function DestroyPkShowManger ():void {
			if (m_PkShowManager) {
				m_PkShowManager.Destroy ();
				m_PkShowManager = null;
			}
		}

		//显示PK管理
		public function ShowPkManager ():void {
			if (m_PkShowManager) {
				m_PkShowManager.visible = true;
			}
		}

		/*
		  * 显示PK
		  @ cardNo 牌索引
		  @ cardSort 张数索引
		  @ position 庄闲类型 1庄 2闲
		*/
		public function ShowPk (lookCard:Boolean, cardNo:int, cardSort:int, position:int,LookCardPosition:int,ishost:Boolean):void {
			if (m_PkShowManager) {
				if (m_PkShowManager.visible == false) {
					m_PkShowManager.visible = true;
				}
				m_PkShowManager.ShowPK (lookCard, cardNo,cardSort,position,LookCardPosition,ishost);
			}
		}

		//清除结果(路子)
		public function ClearHisResult () {
			if (m_HisResultManager) {
				m_HisResultManager.Shuffle ();
			}
		}

		//创建投注区
		protected override function InitBetPosManager ():void {
			m_BetPosManager = new BetPosManager();
			addChild (m_BetPosManager);

		}
		//创建筹码管理
		protected override function InitChipManager ():void {
			m_ChipManager = new ChipManager();
			addChild (m_ChipManager);
			m_ChipManager.SetSize (nGameUIWidth, nGameUIHeight);
		}

		//创建历史结果管理(路子)
		protected override function InitHistoryResultManger ():void {
			m_HisResultManager = m_GameClass.GetHistoryRoad("DragonHistoryResultManagerByGame");
			m_HisResultManager.SetLang (m_lang);
			var mc:MovieClip=m_HisResultManager.GetMovieClip();
			if(mc){
				addChild(mc);
				mc.x=1506;
				mc.y=628;
			}
		}
		// 创建椅子管理;
		protected function InitChairManager ():void {
		}

		//显示结果
		public function ShowResult (baccResult:String):void {
			if (m_PkShowManager) {
				m_PkShowManager.ShowResultBg (baccResult);
			}
		}

		public function ShowControlPane ():void {
			
		}
		override public function SetTableStatus (status:int,difftime:int):void {
			if(status !=2){
				if(m_BetPosManager){
					m_BetPosManager.addEventListener(MouseEvent.CLICK,ShowOutBet);
				}
			}else{
				if(m_BetPosManager && m_BetPosManager.hasEventListener(MouseEvent.CLICK)){
				   m_BetPosManager.removeEventListener(MouseEvent.CLICK,ShowOutBet);
				  }
			}
			if(m_BetTimer){
				m_BetTimer.SetGameStatus(status);
				m_BetTimer.SetDifftime(difftime);
			}
			if(this.getChildByName("mc_status")){
				this["mc_status"].text = GetTableStatus(status,m_lang);
			}
			switch (status) {
				case 2 :
					TargetChipSetting(true);
					break;
				case 0 :
				case 1 :
				case 3 :
				case 4 :
				case 5 :
				case 6 :
					TargetChipSetting(false);
					break;
				default :
					break;
			}
		}
		public function ShowAllCardInfo ():void {
			if (m_IFlipCard != null) {
				m_IFlipCard.GetMovieClip().visible = false;
			}
			if (m_PkShowManager) {
				m_PkShowManager.ShowAllCardInfo ();
			}
		}
		public function ControlOpenCard (lookCard:Boolean):void {
			m_class.ControlOpenCard (lookCard);
		}
		public function ControlNextRound ():void {
			m_class.ControlNextRound ();
		}
		public function ControlChangeDealer ():void {
			m_class.ControlChangeDealer ();
		}
		public function ControlChangeBoot ():void {
			m_class.ControlChangeBoot ();
		}
		public function SendMoveData (data:String, openCard:Boolean, index:int, position:int):void {
		}
		public function CreaditCard (type:int,gamekind:int):void {
			if (m_IFlipCard == null) {
				m_IFlipCard = m_GameClass.GetFlipCard("FlipCardWindow");
				m_IFlipCard.SetFlipCardPane (this);
				addChild (m_IFlipCard.GetMovieClip());
				var mcFlip:MovieClip = m_IFlipCard.GetMovieClip();
				mcFlip.x = 100;
				mcFlip.y = 200;
			}
			m_IFlipCard.GetMovieClip().visible = true;
			m_IFlipCard.SetCardType (type,gamekind);
			this.setChildIndex (m_IFlipCard.GetMovieClip(), this.numChildren - 1);
		}
		public function SetCardNum (cardIndex:int, cardPosition:int, cardNum:int):void {
			if (m_IFlipCard) {
				m_IFlipCard.SetCardNum (cardIndex, cardPosition, cardNum);
			}
		}
		public function SetMoveData (cardIndex:int, data:String):void {
			if (m_IFlipCard) {
				m_IFlipCard.SetMoveData (cardIndex, data);
			}
		}
		public function ShowGameInfo (e:MouseEvent):void {
			RightInfoChange (0);
		}
		public function ShowRoadInfo (e:MouseEvent):void {
			RightInfoChange (1);
		}
		public function ShowBetPoll (e:MouseEvent):void {
			RightInfoChange (2);
		}
		
		//显示下注金额
		override public function ShowQuotaMoney (money:Number):void {
			m_memTotalBet = money;
			//ShowLeftBetInfo (money, 0);
		}
		//显示总输赢
		override public function ShowMemberTotalWin (total:Number,money:Number):void {
			//ShowLeftBetInfo (m_memTotalBet, money);
			if (total>=0) {
				m_centerMessage.ShowWinMessage (0,NumberFormat.formatString(total));
			} else {
				m_centerMessage.ShowWinMessage (1,NumberFormat.formatString(total));
			}
		}
		
		public function OpenCard (openCard:Boolean,index:int,position:int):void {
		}
		override public function ShowBetPos(isShow:Boolean,w_BetPos:int,bettotal:Number):void{
			
		}
		//翻开未眯的牌
		public function OpenNotLook():void{
			if(m_GameClass){
				m_GameClass.OpenNotLook();
			}
		}
	}
}
include "../Common/GameMessage.as"
include "../../LobbyModule/LobbyText.as"