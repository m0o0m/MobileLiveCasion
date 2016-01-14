package {
	import flash.display.MovieClip;
	import flash.display.Graphics;
	import flash.display.BitmapData;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	import Common.*;
	import GameModule.Common.*;
	import IGameFrame.*;
	import Net.*;
	import GameModule.Common.PK.PKShowBaseManager;
	import CommandProtocol.cmdMemberInfo;
	import CommandProtocol.cmdMemberTableInfo;
	import GameModule.Common.InfoPane.*;
	public class GameViewByNomalSimple extends GameViewByNomal {

		public function GameViewByNomalSimple (prarentClass:GameClassByNomalSimple) {
			// constructor code
			super (prarentClass);
			m_BetTimerPoint = new Point(14,110);
			m_centerPoint = new Point(250,90);
		}
		public override function InitGameView ():Boolean {
			if (m_bInitGameView) {
				return true;
			}
			var table:cmdMemberTableInfo = m_GameClass.GetServerAttribute();
			var lblTableName:Object = this.getChildByName("m_tableName");
			if (lblTableName) {
				lblTableName.text =ShowCMDLang(table.TableName,m_lang);
			}
			m_bInitGameView = true;
			InitBetPosManager ();
			if (m_BetPosManager) {
				m_BetPosManager.SetGameView (this);
				m_BetPosManager.BetLimitByPos (m_betLimitByPos,m_minLimit);
			}
			InitChipManager ();
			InitHistoryResultManger ();
			if (m_HisResultManager) {
				m_HisResultManager.StringSplit (table.HisRoad);
			}
			InitButtonView ();
			InitBetTime ();
			InitUserInfo ();
			InitPkShowManger ();
			InitChipSelectManager ();
			InitCenterMessage ();
			SetTablePositionBet (table.PositionTotalBet);
			SetTablePositionMembers (table.PositionMembers);
			if (m_BetTimer) {
				m_BetTimer.SetTotalTime (table.BetTime);
				m_BetTimer.SetDifftime (table.DiffTime);
				m_BetTimer.SetControlMode (table.ControlMode);
			}
			return true;
		}
		protected override function InitBetPosManager ():void {
			m_BetPosManager= new BetPosManagerByNomal();
			m_BetPosManager.x = 843;
			m_BetPosManager.y = 58;
			addChild (m_BetPosManager);
		}
		//创建筹码管理
		protected override function InitChipManager ():void {
			m_ChipManager= new ChipManagerByNomalSimple();
			addChild (m_ChipManager);
			m_ChipManager.SetSize (600,800);
		}
		//创建信息表;
		protected override function InitBetInfo ():void {
			
		}
		//创建PK显示管理
		public override function InitPkShowManger ():void {
			m_PkShowManager = new PKShowManagerBySimple();
			addChild(m_PkShowManager);
			m_PkShowManager.scaleY=1.3;
			m_PkShowManager.scaleX=1.3;
			m_PkShowManager.x=192;
			m_PkShowManager.y=82.15;
			m_PkShowManager.SetLang(m_lang);
			m_PkShowManager.SetGameView (this);
			m_PkShowManager.visible =false;
		}
		//创建用户信息管理
		override protected function InitUserInfo ():void {
			var table:cmdMemberTableInfo = m_GameClass.GetServerAttribute();
			ShowGameRoundNo (table.GameRoundNo);
		}
		protected  override function InitHistoryResultManger ():void {
			m_HisResultManager = m_GameClass.GetHistoryRoad("BaccaratHistoryResultBySimple");
			m_HisResultManager.GetMovieClip().x = 100;
			m_HisResultManager.GetMovieClip().y = 57;
			m_HisResultManager.SetLang(m_lang);
			addChild (m_HisResultManager.GetMovieClip());
			
			this.setChildIndex(m_HisResultManager.GetMovieClip(), this.getChildIndex(m_btnConfirm));
		}
		//初始化筹码选择;
		override protected function InitChipSelectManager ():void {
			m_ChipSelectManager = m_GameClass.GetChipSelect("ChipSelectBaseManager");
			m_ChipSelectManager.SetChipPane (this);
			var mc:MovieClip = m_ChipSelectManager.GetMovieClip();
			mc.visible=false;
			addChild(mc);
		}
		override protected function InitCenterMessage():void {
			m_centerMessage = new ShowGameMessage();
			m_centerMessage.x=m_centerPoint.x;
			m_centerMessage.y=m_centerPoint.y;
			m_centerMessage.SetLang(m_lang);
			m_centerMessage.visible=false;
			addChild(m_centerMessage);
		}
		override public function InitBetTime ():void {
			if (m_BetTimer == null) {
				m_BetTimer = new BetTimerBySimple();
				m_BetTimer.SetGameBaseView(this);
				m_BetTimer.SetLang(m_lang);
				addChild(m_BetTimer);
				m_BetTimer.x = m_BetTimerPoint.x;
				m_BetTimer.y = m_BetTimerPoint.y;
			}
			if (m_BetTimer && m_BetTimer.getChildByName("m_bettime")) {
				m_BetTimer["m_bettime"].scaleX = 0.57;
				m_BetTimer["m_bettime"].scaleY = 0.57;
			}
		}
		//显示游戏局号
		override public function ShowGameRoundNo (roundNo:String):void {
			this["m_txtRoundNo"].text = GetOther(0,m_lang) + roundNo;
		}
		//显示下注金额
		override public function ShowQuotaMoney (money:Number):void {
		}
		//显示总输赢
		override public function ShowMemberTotalWin (total:Number,money:Number):void {
			if (total>=0) {
				m_centerMessage.ShowWinMessage (0,NumberFormat.formatString(total));
			} else {
				m_centerMessage.ShowWinMessage (1,NumberFormat.formatString(total));
			}
		}
		//显示余额
		override public function ShowBalance (moneyType:String,balance:Number):void {
		}
		//还原视图
		public override function ResetGameView ():void {
			super.ResetGameView ();
			if (m_PkShowManager) {
				m_PkShowManager.visible=false;
			}
		}
		public override function ShowGameInfo (e:MouseEvent):void {
		}
		public override function ShowBetPoll (e:MouseEvent):void {
		}
		//显示RightInfo
		//@index:0资料，1路子，2即时信息
		public override function RightInfoChange (index:int):void {
		}
		override public function ShowBetPos (isShow:Boolean,w_BetPos:int,bettotal:Number):void {

		}
		override public function ShowMemberCount (members:int) {
			if (this.getChildByName("m_membercount")) {
				this["m_membercount"].htmlText = GetTableInfo("totalcount",m_lang).replace("$MemberCount$",members.toString());
			}
		}
		//播放声音
		//@status:游戏状态，@str除输赢/结果/座位以外全为null
		override public function PlaySound(status:String,str:String):void{
		}
		public override function SetLang(strlang:String):void{
			super.SetLang(strlang);
			if(this.getChildByName("betposlang")){
				this["betposlang"].gotoAndStop(strlang);
			}
		}
		override public function SetTableStatus (status:int,difftime:int):void {
			if ((status != 2)) {
				if (m_BetPosManager) {
					m_BetPosManager.addEventListener (MouseEvent.CLICK,ShowOutBet);
				}
			} else {
				if ((m_BetPosManager && m_BetPosManager.hasEventListener(MouseEvent.CLICK))) {
					m_BetPosManager.removeEventListener (MouseEvent.CLICK,ShowOutBet);
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
					if ((m_insurance != 0)) {
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
						m_ChipSelectManager.HideSelectChip (true);
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
	}
}
include "../Common/GameMessage.as"
include "../../LobbyModule/LobbyText.as"