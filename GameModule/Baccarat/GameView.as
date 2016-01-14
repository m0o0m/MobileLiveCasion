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
		protected var m_IFlipCard:IFlipCard;
		protected var m_memTotalBet:Number = 0;
		protected var m_Right:Array=new Array();
		protected var m_RightBtn:Array=new Array();
		protected var m_showroad:MovieClip;

		protected var m_class:GameClass;

		//构造函数
		public function GameView (prarentClass:GameClass) {
			super (prarentClass);
			m_PlayerPoint = new Point(205,187);
			m_PlayerWidth = 1280;
			m_PlayerHeight = 720;
			m_class = prarentClass;
			m_BetTimerPoint = new Point(1300,946);
			m_centerPoint = new Point(639,554);
			m_ChairViewList=new Array();
			m_ShowChair = true;
		}

		public override function InitGameView ():Boolean {
			if (super.InitGameView() == false) {
				return false;
			}
			InitChairManager ();

			if (m_chairManager && m_ChipManager) {
				var index = this.getChildIndex(m_ChipManager);
				this.setChildIndex (m_chairManager,index);
			}
			if(this.getChildByName("mc_roadlang")){
				m_showroad=this["mc_roadlang"];
				m_showroad.stop();
			}
			InitPkShowManger ();

			InitControlPane ();
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
			m_PkShowManager.SetGameView (this);
			m_PkShowManager.visible = true;
			m_PkShowManager.SetLang (m_lang);
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
		public function ReplaceCard (lookCard:Boolean, cardNo:int, cardSort:int, position:int,LookCardPosition:int,ishost:Boolean):void {
			if (m_PkShowManager) {
				if (m_PkShowManager.visible == false) {
					m_PkShowManager.visible = true;
				}
				m_PkShowManager.ReplaceCard (lookCard, cardNo,cardSort,position,LookCardPosition,ishost);
			}
		}
		public function ShowBCardInfo (cardIndex:int):void {
			if (m_PkShowManager) {
				m_PkShowManager.ShowBCardInfo (cardIndex);
			}
		}
		public function ShowPCardInfo (cardIndex:int):void {
			if (m_PkShowManager) {
				m_PkShowManager.ShowPCardInfo (cardIndex);
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
			m_HisResultManager = m_GameClass.GetHistoryRoad("BaccaratHistoryResultByGame");
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
			m_chairManager = new ChairManager();
			addChild (m_chairManager);
			this.setChildIndex (this["m_LeftMemInfo"],this.getChildIndex(m_chairManager));
			m_ChairViewList = [m_chairManager["m_oneChair"],m_chairManager["m_twoChair"],m_chairManager["m_threeChair"],m_chairManager["m_fiveChair"],m_chairManager["m_sixChair"],m_chairManager["m_sevenChair"],m_chairManager["m_eightChair"]];
			var index:int = 0;
			var len:int=m_ChairViewList.length;
			for (index; index<len; index++) {
				var chairView:ChairIDView = m_ChairViewList[index] as ChairIDView;
				if (chairView) {
					chairView.SetGameView (this);
					chairView.SetLang (m_lang);
				}
			}
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
			if (m_BetTimer) {
				m_BetTimer.SetGameStatus (status);
			}
			if (m_ChipSelectManager) {
				var mc:MovieClip = m_ChipSelectManager.GetMovieClip();
			}
				switch (status) {
					case 2 :
						if (mc) {
							m_ChipSelectManager.HideSelectChip (true);
						}
						if (m_insurance==0) {
						} else {
							m_Rebet.SetEnabled (false);
						}
						break;
					case 0 :
					case 1 :
					case 3 :
					case 4 :
					case 5 :
					case 6 :
						if (mc) {
							m_ChipSelectManager.HideSelectChip (false);
						}
						if (m_showBetPos) {
							m_showBetPos.visible = false;
						}
						break;
					default :
						break;
				}
				if(this.getChildByName("mc_status")){
					this["mc_status"].text = GetTableStatus(status,m_lang);
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
			m_class.SendLookCard (data, openCard, index, position);
		}
		public function CreaditCard (type:int,gameKind:int):void {
			if (m_IFlipCard) {
				m_IFlipCard.SetCardType (type,gameKind);
			}

		}
		public function SetCardNum (cardIndex:int, cardPosition:int, cardNum:int,isShow:Boolean):void {
			if (m_IFlipCard) {
				m_IFlipCard.SetCardNum (cardIndex, cardPosition, cardNum,isShow);
			}
		}
		public function SetMoveData (cardIndex:int, data:String):void {
			if (m_IFlipCard) {
				m_IFlipCard.SetMoveData (cardIndex, data);
			}
		}
		public function OpenMainCard (cardIndex:int):void {
			if (m_IFlipCard) {
				m_IFlipCard.OpenMainCard (cardIndex);
			}
		}
		//咪牌剩余时间
		public function SetLookCardDiffTime (difftime:int):void {
			if (m_IFlipCard == null) {
				m_IFlipCard = m_GameClass.GetFlipCard("FlipCardWindow");
				m_IFlipCard.SetLang (m_lang);
				m_IFlipCard.SetFlipCardPane (this);
				addChild (m_IFlipCard.GetMovieClip());
				var mcFlip:MovieClip = m_IFlipCard.GetMovieClip();
				mcFlip.x =-350;
				mcFlip.y = 130;
				mcFlip.scaleX=2.2;
				mcFlip.scaleY=2.2;
			}
			m_IFlipCard.GetMovieClip().visible = true;
			m_IFlipCard.SetLookCardDiffTime (difftime);
			m_IFlipCard.GetVolume (m_Issound);
			this.setChildIndex (m_IFlipCard.GetMovieClip(), this.numChildren - 1);
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
		override public function RightInfoChange (index:int):void {
			var inde:int = 0;
			var len:int=m_Right.length;
			for (inde; inde<len; inde++) {
				m_Right[inde].visible = false;
				m_RightBtn[inde].SetSelectStatus (false);
			}
			if(index<=2){
				m_Right[index].visible = true;
				m_Right[index].ShowBottom();
				m_RightBtn[index].SetSelectStatus (true);
			}else{
				m_Right[1].visible = true;
				m_Right[1].HideVisible();
			}
		}
		//显示下注金额
		override public function ShowQuotaMoney (money:Number):void {
			m_memTotalBet = money;
		}
		//显示总输赢
		override public function ShowMemberTotalWin (total:Number,money:Number):void {
			if (total>=0) {
				m_centerMessage.ShowWinMessage (0,NumberFormat.formatString(total));
			} else {
				m_centerMessage.ShowWinMessage (1,NumberFormat.formatString(total));
			}
		}
		

		//获取声音大小，1.游戏设置，2.大厅传出值
		override public function GetSound (isPlay:Boolean):void {
			super.GetSound (isPlay);
			if (m_IFlipCard) {
				m_IFlipCard.GetVolume (m_Issound);
			}
		}
		override public function GetLookCard (islook:Boolean):void {
			m_Islookcard = islook;
			
		}
		override public function SetInsurance (insurance:int):void {
			m_insurance = insurance;
			if (m_BetPosManager) {
				m_BetPosManager.SetInsurance (insurance);
			}
		}
		protected var pospoint:Array;
		override public function BetPosPoint (betpospoint:Array):void {
			if (betpospoint) {
				pospoint = betpospoint;
				if (m_chair) {
					if (m_lookOn) {
						m_betposPoint = betpospoint[3];
					} else {
						m_betposPoint = betpospoint[m_chair - 1];
					}
				}
			}
		}
		override public function ShowBetPos (isShow:Boolean,w_BetPos:int,bettotal:Number):void {
			if (m_betposPoint==null) {
				BetPosPoint (pospoint);
			}
			if (m_betposPoint==null || m_betposLimit==null) {
				return;
			}
			if (isShow) {
				m_showBetPos.visible = true;
				m_showBetPos.x = m_betposPoint[w_BetPos - 1][0];
				m_showBetPos.y = m_betposPoint[w_BetPos - 1][1]-25;
				m_showBetPos.ShowBetPos (bettotal,m_minbetposLimit[w_BetPos],m_betposLimit[w_BetPos],1,GameKindEnum.VipBaccarat,w_BetPos,m_lang);
			} else {
				m_showBetPos.visible = false;
			}
		}
		public function OpenCard (openCard:Boolean,index:int,position:int):void {
			m_class.OpenCard (openCard,index,position);
		}
		override public function HideResultBg ():void {
			if (m_PkShowManager) {
				m_PkShowManager.HideResultBg ();
			}
		}
		override public function GetCardInfo ():String {
			if (m_PkShowManager) {
				return m_PkShowManager.GetCardInfo();
			}
			return null;
		}
		//会员下注结果
		override public function OnBetPosition (wChairID:int, wBetPos:int, nBetValue:Number):void {
			
			m_ChipManager.ShowBetChips (wChairID, wBetPos, nBetValue);
			m_BetPosManager.ShowBetTotal (wChairID,wBetPos,nBetValue);
		}
		//添加赢筹码;
		override public function AddWinChips (wChairID:int, wBetPos:int, money:int):void {
			
			m_ChipManager.AddWinChips (wChairID, wBetPos, money);
		}
		//添加输筹码;
		override public function AddLoseChips (wChairID:int, wBetPos:int):void {
			
			m_ChipManager.AddLoseChips (wChairID, wBetPos);
		}
		//添加和筹码;
		override public function AddDrawChips (wChairID:int, wBetPos:int):void {
			
			m_ChipManager.AddDrawChips (wChairID, wBetPos);
		}
		
		//清除旁观筹码;
		override public function ClearLookOnChips ():void {
			
		}
		protected function InitControlPane ():void {
			
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