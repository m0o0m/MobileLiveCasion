package {
	import flash.display.MovieClip;
	import flash.display.Graphics;
	import flash.display.BitmapData;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.display.DisplayObject;

	import Common.*;
	import GameModule.Common.GameBaseView;
	import GameModule.Common.*;
	import IGameFrame.*;
	import Net.*;
	import Common.UserPlayer;
	import CommandProtocol.*;
	import GameModule.Common.Button.*;
	import GameModule.Common.InfoPane.*;
	public class GameViewBySimple extends GameView {

		public function GameViewBySimple (prarentClass:GameClassBySimple) {
			super (prarentClass);
			m_ChangeTimerPoint = false;
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
				lblTableName.text = ShowCMDLang(table.TableName,m_lang);
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
			InitCenterMessage ();
			InitBetTime ();
			InitUserInfo ();
			InitShowGameResoult ();
			InitChipSelectManager ();
			SetTablePositionBet (table.PositionTotalBet);
			SetTablePositionMembers (table.PositionMembers);
			if (m_BetTimer) {
				m_BetTimer.SetTotalTime (table.BetTime);
				m_BetTimer.SetDifftime (table.DiffTime);
				m_BetTimer.SetControlMode (table.ControlMode);
			}
			return true;
		}
		//添加按钮
		override protected function InitButtonView ():void {
			if (this.getChildByName("m_btnExit")) {
				this["m_btnExit"].addEventListener (MouseEvent.CLICK,ExitGameClient);
			}
			if (this.getChildByName("m_btnConfirm")) {
				m_Confirm = this["m_btnConfirm"];
			}
			if (this.getChildByName("m_btnCancel")) {
				m_Cancel = this["m_btnCancel"];
			}
			if (this.getChildByName("m_btnBack")) {
				m_Back = this["m_btnBack"];
			}
			if (this.getChildByName("m_btnRebet")) {
				m_Rebet = this["m_btnRebet"];
			}
			if (this.getChildByName("mc_showchip")) {
				m_showchipbtn = this["mc_showchip"];
				m_showchipbtn.visible = true;
				m_showchipbtn.buttonMode = true;
				m_showchipbtn.addEventListener (MouseEvent.CLICK,ShowChipSetting);
				if (m_showchipbtn.getChildByName("mc_light")) {
					m_showchipbtn["mc_light"].play ();
				}
			}
			if (this.getChildByName("mc_hidechip")) {
				m_hidechipbtn = this["mc_hidechip"];
				m_hidechipbtn.visible = false;
				m_hidechipbtn.buttonMode = true;
				m_hidechipbtn.addEventListener (MouseEvent.CLICK,HideChipSetting);
			}
			if (m_Confirm) {
				m_Confirm.IChangLang (m_lang);
				m_Confirm.addEventListener (MouseEvent.CLICK,OnSendBet);
				this.setChildIndex (m_Confirm,this.getChildIndex(m_ChipManager));
				m_Confirm.stop ();
			}
			if (m_Cancel) {
				m_Cancel.IChangLang (m_lang);
				m_Cancel.addEventListener (MouseEvent.CLICK,CancelBet);
				this.setChildIndex (m_Cancel,this.getChildIndex(m_ChipManager));
				m_Cancel.stop ();
			}
			if (m_Back) {
				m_Back.IChangLang (m_lang);
				m_Back.addEventListener (MouseEvent.CLICK,BackBetChips);
				this.setChildIndex (m_Back,this.getChildIndex(m_ChipManager));
				m_Back.stop ();
			}
			if (m_Rebet) {
				m_Rebet.IChangLang (m_lang);
				m_Rebet.SetEnabled (false);
				this.setChildIndex (m_Rebet,this.getChildIndex(m_ChipManager));
				m_Rebet.stop ();
			}
			SetButtonEnabled (false);
		}

		protected override function InitBetPosManager ():void {
			m_BetPosManager = new BetPosManager();
			m_BetPosManager.x = 843;
			m_BetPosManager.y = 58;
			addChild (m_BetPosManager);
		}
		//创建筹码管理
		protected override function InitChipManager ():void {
			m_ChipManager = new ChipManagerBySimple();
			addChild (m_ChipManager);
			m_ChipManager.SetSize (600,800);
		}

		//创建用户信息管理
		override protected function InitUserInfo ():void {
			var table:cmdMemberTableInfo = m_GameClass.GetServerAttribute();
			ShowGameRoundNo (table.GameRoundNo);
		}
		override protected function InitHistoryResultManger ():void {
			m_HisResultManager = m_GameClass.GetHistoryRoad("RoulettetHistoryResultBySimple");
			m_HisResultManager.GetMovieClip().x = 100;
			m_HisResultManager.GetMovieClip().y = 57;
			m_HisResultManager.SetLang (m_lang);
			addChild (m_HisResultManager.GetMovieClip());

			this.setChildIndex (m_HisResultManager.GetMovieClip(),this.getChildIndex(m_btnConfirm));
		}
		//初始化筹码选择;
		override protected function InitChipSelectManager ():void {
			m_ChipSelectManager = m_GameClass.GetChipSelect("ChipSelectBaseManager");
			m_ChipSelectManager.SetChipPane (this);
			var mc:MovieClip = m_ChipSelectManager.GetMovieClip();
			mc.visible = false;
			addChild (mc);
		}
		override public function InitBetTime ():void {
			if ((m_BetTimer == null)) {
				m_BetTimer = new BetTimerBySimple();
				m_BetTimer.SetGameBaseView (this);
				m_BetTimer.SetLang (m_lang);
				addChild (m_BetTimer);
				m_BetTimer.x = m_BetTimerPoint.x;
				m_BetTimer.y = m_BetTimerPoint.y;
			}
			if ((m_BetTimer && m_BetTimer.getChildByName("m_bettime"))) {
				m_BetTimer["m_bettime"].scaleX = 0.57;
				m_BetTimer["m_bettime"].scaleY = 0.57;
			}
		}
		override protected function InitShowGameResoult ():void {
			m_showresoult = new ShowGameResoult();
			m_showresoult.x = 629;
			m_showresoult.y = 62;
			m_showresoult.SetLang (m_lang);
			addChild (m_showresoult);
		}
		//显示游戏局号
		override public function ShowGameRoundNo (roundNo:String):void {
			if (this.getChildByName("m_txtRoundNo")) {
				this["m_txtRoundNo"].text = GetOther(0,m_lang) + roundNo;
			}
		}
		//显示下注金额
		override public function ShowQuotaMoney (money:Number):void {
		}
		//显示总输赢
		override public function ShowMemberTotalWin (total:Number,money:Number):void {
			if ((total >= 0)) {
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
		}
		public override function ShowGameInfo (e:MouseEvent):void {
		}
		public override function ShowBetPoll (e:MouseEvent):void {
		}
		//@index:0资料，1路子，2即时信息
		public override function RightInfoChange (index:int):void {
		}
		override public function ShowBetPos (isShow:Boolean,w_BetPos:int,bettotal:Number):void {

		}
		override public function ShowMemberCount (members:int) {
			if (this.getChildByName("m_membercount")) {
				this["m_membercount"].htmlText = GetTableInfo("totalcount","ch").replace("$MemberCount$",members.toString());
			}
		}
		//@status:游戏状态，@str除输赢/结果/座位以外全为null
		override public function PlaySound (status:String,str:String):void {
		}
		public override function SetLang (strlang:String):void {
			super.SetLang (strlang);
			if (this.getChildByName("betposlang")) {
				this["betposlang"].gotoAndStop (strlang);
			}
		}
	}
}
include "../Common/GameMessage.as";
include "../../LobbyModule/LobbyText.as";