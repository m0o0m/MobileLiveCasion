package {
	import flash.display.MovieClip;
	import flash.display.Graphics;
	import flash.display.BitmapData;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.display.DisplayObject;
	import flash.utils.setTimeout;
	import flash.text.TextFormat;

	import Common.*;
	import GameModule.Common.GameBaseView;
	import GameModule.Common.*;
	import IGameFrame.*;
	import Net.*;
	import Common.UserPlayer;
	import CommandProtocol.*;
	import GameModule.Common.Button.*;
	import GameModule.Common.InfoPane.*;

	//游戏视图
	public class GameView extends GameBaseView {
		protected var m_memTotalBet:Number = 0;
		protected var m_betPane:InfoPane;
		//protected var m_roadInfo:RoulRoadInfo;
		protected var m_showresoult:ShowGameResoult;//左下角游戏结果显示
		protected var m_ChangeTimerPoint:Boolean = true;
		protected var m_showroad:MovieClip;
		//构造函数
		public function GameView (prarentClass:GameClass) {
			super (prarentClass);
			m_BetTimerPoint = new Point(1300,946);//389,158
			m_PlayerPoint = new Point(205,187);
			m_PlayerWidth = 1280;
			m_PlayerHeight = 720;
			m_centerPoint = new Point(639,554);
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
			InitHistoryResultManger();
			m_UserPlayer = new UserPlayer(m_PlayerWidth,m_PlayerHeight);
			addChild(m_UserPlayer);
			m_UserPlayer.x = m_PlayerPoint.x;
			m_UserPlayer.y = m_PlayerPoint.y;
			var playParam:Array = m_GameClass.GetVideoPlayUrl();
			m_UserPlayer.PlayVideo(playParam[0], playParam[1]);
			m_UserPlayer.addEventListener (UserPlayer.VIDEO_LOADED, onVideoLoaded);
			m_UserPlayer.addEventListener (UserPlayer.LOAD_RESUME, onLoadResume);
			if(this.getChildByName("m_videoLoad")){
				this["m_videoLoad"].visible = true;
				this.setChildIndex(this["m_videoLoad"],this.getChildIndex(m_UserPlayer));
			}
			m_betPane=new InfoPane(0,58,836,false,1280);
			addChild(m_betPane);
			m_betPane.x=205;
			m_betPane.y=187;
			m_betPane.SetGameView(this);
			InitBetPosManager();
			if (m_BetPosManager) {
				m_BetPosManager.SetInfo(m_betPane);
				m_BetPosManager.BetLimitByPos(m_betLimitByPos,m_minLimit);
			}
			InitChipManager();
			InitChipSelectManager();
			
			InitBetTime()
			InitButtonView();
			InitUserInfo();
			InitBetInfo();
			InitShowBetPos();
			InitCenterMessage();
			InitSetUp(table.GameKind);
			SetTablePositionBet(table.PositionTotalBet);
			SetTablePositionMembers(table.PositionMembers);
			if(m_HisResultManager) {
				m_HisResultManager.StringSplit(table.HisRoad);
			}
			if(m_BetTimer){
				m_BetTimer.SetTotalTime(table.BetTime);
				m_BetTimer.SetDifftime(table.DiffTime);
				m_BetTimer.SetControlMode(table.ControlMode);
			}
			InitShowGameResoult ();
			if(m_BetPosManager){
				m_betPane.addChildByBottom(m_BetPosManager,0,0);
			}
			if(m_Confirm && m_Cancel && m_Back && m_Rebet){
				m_betPane.addChildByBottom(m_Confirm,184,763);
				m_betPane.addChildByBottom(m_Cancel,841,763);
				m_betPane.addChildByBottom(m_Back,622,763);
				m_betPane.addChildByBottom(m_Rebet,403,763);
			}
			if(m_ChipManager){
				m_ChipManager.SetInfo(m_betPane);
				m_betPane.addChildByBottom(m_ChipManager,0,0);
			}
			if(this.getChildByName("mc_roadlang")){
				m_showroad=this["mc_roadlang"];
				m_showroad.stop();
			}
			return true;
		}
		//添加按钮
		override protected function InitButtonView():void {
			if(this.getChildByName("m_btnExit")){
				this["m_btnExit"].addEventListener (MouseEvent.CLICK, ExitGameClient);
			}
			//"确定"按钮;
				m_Confirm = new ButtonConfirm();
				m_Cancel = new ButtonCancel();
				m_Back = new ButtonBack();
				m_Rebet = new ButtonRepeat();
			if(this.getChildByName("mc_showchip")){
				m_showchipbtn=this["mc_showchip"];
				m_showchipbtn.visible=true;
				m_showchipbtn.buttonMode=true;
				m_showchipbtn.addEventListener(MouseEvent.CLICK,ShowChipSetting);
				if(m_showchipbtn.getChildByName("mc_light")){
					m_showchipbtn["mc_light"].play();//闪烁
				}
			}
			if(this.getChildByName("mc_hidechip")){
				m_hidechipbtn=this["mc_hidechip"];
				m_hidechipbtn.visible=false;
				m_hidechipbtn.buttonMode=true;
				m_hidechipbtn.addEventListener(MouseEvent.CLICK,HideChipSetting)
			}
			if(m_Confirm) {
				m_Confirm.IChangLang(m_lang);
				m_Confirm.addEventListener (MouseEvent.CLICK, OnSendBet);
				m_Confirm.stop();
			}
			if(m_Cancel) {
				m_Cancel.IChangLang(m_lang);
				m_Cancel.addEventListener (MouseEvent.CLICK,CancelBet);
				m_Cancel.stop();
			}
			if(m_Back) {
				m_Back.IChangLang(m_lang);
				m_Back.addEventListener (MouseEvent.CLICK,BackBetChips);
				m_Back.stop();
			}
			if(m_Rebet) {
				m_Rebet.IChangLang(m_lang);
				m_Rebet.SetEnabled (false);
				m_Rebet.stop();
			}
			SetButtonEnabled(false);
		}
		protected override function InitBetPosManager ():void {
			m_BetPosManager= new BetPosManager();
			m_BetPosManager.SetLang (m_lang);
			//addChild (m_BetPosManager);
		}
		//创建筹码管理
		protected override function InitChipManager ():void {
			m_ChipManager= new ChipManager();
			m_ChipManager.SetSize (1280,836);
		}
		protected  override function InitHistoryResultManger ():void {
			m_HisResultManager = m_GameClass.GetHistoryRoad("RoulettetHistoryResultByGame");
			m_HisResultManager.SetLang (m_lang);
			var mc:MovieClip=m_HisResultManager.GetMovieClip();
			if(mc){
				addChild(mc);
				mc.x=1516;
				mc.y=252;
				
			}
		}
		
		override protected function InitCenterMessage ():void {
			m_centerMessage = new ShowGameMessage();
			m_centerMessage.x = m_centerPoint.x;
			m_centerMessage.y = m_centerPoint.y;
			m_centerMessage.mouseEnabled = false;
			m_centerMessage.SetLang (m_lang);
			m_centerMessage.visible=false;
			addChild (m_centerMessage);
		}

		protected function InitShowGameResoult ():void {
			m_showresoult=new ShowGameResoult();
			m_showresoult.x = 1300;
			m_showresoult.y = 726;
			m_showresoult.mouseEnabled = false;
			m_showresoult.SetLang (m_lang);
			addChild (m_showresoult);
		}
		//游戏状态消息息
		//游戏结果消息
		public function ShowResoult (resoult:String) {
			m_showresoult.ShowResoult (resoult);
		}
		
		//显示下注金额
		override public function ShowQuotaMoney (money:Number):void {
			m_memTotalBet = money;
			ShowLeftBetInfo (money, 0);
		}
		//显示总输赢
		override public function ShowMemberTotalWin (total:Number,money:Number):void {
			ShowLeftBetInfo (m_memTotalBet, money);
			if (total>=0) {
				m_centerMessage.ShowWinMessage (0,NumberFormat.formatString(total));
			} else {
				m_centerMessage.ShowWinMessage (1,NumberFormat.formatString(total));
			}
		}
		
		protected function ShowLeftBetInfo (totalBet:Number, totalWin:Number):void {
			
		}
		public override function DestroyGameView ():void {
			if ((m_bInitGameView == false)) {
				return;
			}
			if (m_UserPlayer) {
				m_UserPlayer.Destroy();
				m_UserPlayer.removeEventListener (UserPlayer.VIDEO_LOADED, onVideoLoaded);
				m_UserPlayer.removeEventListener (UserPlayer.LOAD_RESUME, onLoadResume);
				removeChild(m_UserPlayer);
				m_UserPlayer = null;
			}
			if (m_showresoult) {
				removeChild (m_showresoult);
				m_showresoult = null;
			}
			if (m_HisResultManager) {
				m_HisResultManager.Destroy ();
				var mc:MovieClip=m_HisResultManager.GetMovieClip();
				removeChild(mc);
				m_HisResultManager = null;
			}
			if (m_BetTimer) {
				m_BetTimer.Destroy ();
				m_BetTimer = null;
			}
			if (m_BetPosManager) {
				m_BetPosManager.Destroy();
				m_BetPosManager = null;
			}
			if (m_ChipManager) {
				m_ChipManager.Destroy();
				m_ChipManager = null;
			}
			if (m_HisResultManager) {
				removeChild(m_HisResultManager.GetMovieClip());
				m_HisResultManager.Destroy();
				m_HisResultManager = null;
			}
			if (m_BetTimer) {
				m_BetTimer = null;
			}
			/*if (m_userInfo) {
				removeChild(m_userInfo);
				m_userInfo = null;
			}
			if (m_BetInfo) {
				removeChild(m_BetInfo);
				m_BetInfo = null;
			}*/
			if(m_ChipSelectManager) {
				var mcc:MovieClip = m_ChipSelectManager.GetMovieClip();
				removeChild(mcc);
				m_ChipSelectManager.Destroy();
				m_ChipSelectManager = null;
			}
			if(m_centerMessage){
				m_centerMessage.Destroy();
				removeChild(m_centerMessage);
				m_centerMessage=null;
			}
		   if(m_sound){
			   m_sound.Destory();
			   m_sound=null;
		   }
		  /* if(m_SetUpPane){
			   m_SetUpPane.Destroy();
			   removeChild(m_SetUpPane);
			   m_SetUpPane=null;
		   }*/
			if(this.getChildByName("m_btnExit")){
				this["m_btnExit"].removeEventListener (MouseEvent.CLICK, ExitGameClient);
			}
			//"确定"按钮;
			if(m_Confirm && m_Confirm.hasEventListener (MouseEvent.CLICK)){
			m_Confirm.removeEventListener (MouseEvent.CLICK, OnSendBet);
			}
			//“取消”按钮;
			if(m_Cancel && m_Cancel.hasEventListener (MouseEvent.CLICK)){
			m_Cancel.removeEventListener (MouseEvent.CLICK,CancelBet);
			}
			//“撤消”按钮;
			if(m_Back && m_Back.hasEventListener (MouseEvent.CLICK)){
			m_Back.removeEventListener (MouseEvent.CLICK,BackBetChips);
			}
			//“重复下注”按钮;
			if(m_Rebet && m_Rebet.hasEventListener (MouseEvent.CLICK)){
				m_Rebet.removeEventListener (MouseEvent.CLICK,RepeatBet);
			}
			if(m_showchipbtn){
				if (m_showchipbtn.hasEventListener(MouseEvent.CLICK)) {
					m_showchipbtn.removeEventListener(MouseEvent.CLICK,ShowChipSetting);
				}
				m_showchipbtn=null;
			}
			if(m_hidechipbtn){
				if (m_hidechipbtn.hasEventListener(MouseEvent.CLICK)) {
					m_hidechipbtn.removeEventListener(MouseEvent.CLICK,HideChipSetting);
				}
				m_hidechipbtn=null;
			}
			if(m_betPane){
				m_betPane.Destroy();
				removeChild(m_betPane);
				m_betPane=null;
			}
			while (numChildren > 0) {
				removeChildAt(0);
			}
		}
		//还原视图
		public override function ResetGameView ():void {
			ShowLeftBetInfo (0, 0);
			super.ResetGameView ();
		}
		public function ShowGameInfo (e:MouseEvent):void {
			RightInfoChange (0);
		}
		public function ShowBetPoll (e:MouseEvent):void {
			RightInfoChange (1);
		}
		
		//设置桌子历史结果(路子);
		override public function SetTableHisRoad (hisRoad:String):void {
			if (m_HisResultManager) {
				m_HisResultManager.StringSplit (hisRoad);
				
			}
		}
		override public function ShowBetPos (isShow:Boolean,w_BetPos:int,bettotal:Number):void {
			
		}
		override public function SetTableStatus (status:int,difftime:int):void {
			super.SetTableStatus (status,difftime);
			if(m_betPane){
			switch (status) {
					
					case 2 :
						TargetChipSetting(true);
						m_betPane.MovePane(true);
						break;
					case 3 :
						TargetChipSetting(false);
						m_betPane.MovePane(false);
						break;
					case 0 :
					case 1 :
					case 4 :
					case 5 :
					case 6 :
						break;
				}
			}
			if(this.getChildByName("mc_status")){
				this["mc_status"].text = GetTableStatus(status,m_lang);
			}
		}
		//
		override protected function InitShowBetPos():void{
			
		}
	}
}
include "../Common/GameMessage.as"
include "../../LobbyModule/LobbyText.as"