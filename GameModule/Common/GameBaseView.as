package GameModule.Common{
	import flash.display.Stage;
	import flash.display.StageDisplayState;
	import flash.utils.ByteArray;
	import flash.display.MovieClip;
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Matrix;
	import flash.display.BitmapData;
	import flash.display.GradientType;
	import flash.utils.Timer;
	import flash.text.TextFormat;

	import IGameFrame.*;
	import CommandProtocol.*;
	import Common.UserPlayer;
	import GameModule.Common.Button.*;
	import Common.NumberFormat;

	public class GameBaseView extends MovieClip implements IGameView,IChipPane {
		public static var nGameUIWidth:uint = 1920;
		public static var nGameUIHeight:uint = 1080;

		protected var m_GameClass:GameBaseClass;
		protected var m_bInitGameView:Boolean;

		protected var m_ChairViewList:Array;//椅子视图 (椅子号从1开始, 索引 = Chair - 1)
		protected var m_ShowChair:Boolean = false;//是否显示椅子

		protected var m_BetPosManager:BetPosBaseManager;//投注位置管理

		protected var m_ChipManager:ChipBaseManager;//筹码管理

		protected var m_UserPlayer:UserPlayer;//视频播放器
		protected var m_PlayerPoint:Point = new Point(2,1.5);//播放器位置
		protected var m_PlayerWidth:int = 1278;//播放器宽度
		protected var m_PlayerHeight:int = 720;//播放器高度
		protected var m_HisResultManager:IHistoryResultManger;//历史结果管理(路子)
		protected var m_ChipSelectManager:IChipSelect;//筹码选择

		protected var m_SelectChipPoint:Point = new Point(86,155);//选择筹码座标
		protected var m_BetTimer:BetTimer;//投注倒计时
		protected var m_BetTimerPoint:Point;

		//protected var m_userInfo:UserInfo = null;//用户信息

		//protected var m_BetInfo:BetInfo;//投注汇总显示

		protected var m_centerMessage:ShowGameMessage;//中间消息提示
		protected var m_centerPoint:Point=new Point(0,0);//消息提示位置

		protected var m_sound:GameSound;//声音
		protected var m_betLimitByPos:Array;//每一个投注位置最大限额；
		protected var m_minLimit:int;//最小投注限额
		
		//protected var m_SetUpPane:SetUpGameEffect;//设置
		
		//protected var m_SetUpPanePoint:Point=new Point(376,9);
		
		protected var m_Ismusic:Boolean;//播放背景音乐
		protected var m_Issound:Boolean;//声音
		protected var m_Islookcard:Boolean=true;//是否咪牌
		
		protected var m_Confirm:ButtonConfirm;
		protected var m_Cancel:ButtonCancel;
		protected var m_Rebet:ButtonRepeat;
		protected var m_Back:ButtonBack;
		
		protected var m_showBetPos:ShowBetPosLimit;//显示投注位置信息影片剪辑
		
		protected var m_isHost:Boolean=false;
		
		protected var m_lang:String;//当前语言
		
		protected var m_lookOn:Boolean;//是否旁观
		protected var m_chair:int = 0;//椅子号
		
		protected var m_isRe:Boolean=false;//能否重复下注
		protected var m_betposLimit:Array;//影片剪辑限额
		protected var m_minbetposLimit:Array;//每个位置最小限额
		
		protected var m_betposPoint:Array;//投注显示影片剪辑坐标
		
		protected var m_insurance:int;//主要是为m_LeftTopInfoPane显示问题
		protected var text_format:TextFormat;//字体样式
		
		protected var m_showchipbtn:MovieClip;//显示筹码按钮
		protected var m_hidechipbtn:MovieClip;//隐藏筹码按钮
		
		public function GameBaseView(prarentClass:GameBaseClass) {
			stop();
			m_GameClass = prarentClass;
			m_bInitGameView = false;
			text_format=new TextFormat();
			text_format.font="Microsoft YaHei";
			
		}
		//初始化游戏视图
		public function InitGameView():Boolean {
			if (m_bInitGameView) {
				return true;
			}
			var table:cmdMemberTableInfo = m_GameClass.GetServerAttribute();
			var lblTableName:Object = this.getChildByName("m_tableName");
			if (lblTableName) {
				lblTableName.text =ShowCMDLang(table.TableName,m_lang);
			}
			m_bInitGameView = true;
			if(m_UserPlayer==null){
				m_UserPlayer = new UserPlayer(m_PlayerWidth,m_PlayerHeight);
				addChild(m_UserPlayer);
			}
			m_UserPlayer.x = m_PlayerPoint.x;
			m_UserPlayer.y = m_PlayerPoint.y;

			var playParam:Array = m_GameClass.GetVideoPlayUrl();
			m_UserPlayer.PlayVideo(playParam[0], playParam[1]);
			m_UserPlayer.addEventListener (UserPlayer.VIDEO_LOADED, onVideoLoaded);
			m_UserPlayer.addEventListener (UserPlayer.LOAD_RESUME, onLoadResume);
			this.setChildIndex(m_UserPlayer, 1);
			if(this.getChildByName("m_videoLoad")){
				this["m_videoLoad"].visible = true;
				var index:int = this.getChildIndex(this["m_videoLoad"]);
				if(index == 0) {
					this.setChildIndex(m_UserPlayer, 0);
					this.setChildIndex(this["m_videoLoad"], 1);
				}	else {
					this.setChildIndex(m_UserPlayer, index);
				}
			}
			InitBetPosManager();
			if (m_BetPosManager) {
				m_BetPosManager.SetGameView(this);
				m_BetPosManager.BetLimitByPos(m_betLimitByPos,m_minLimit);
			}
			InitChipManager();
			InitChipSelectManager();
			InitHistoryResultManger();
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
			return true;
		}
		public function ActiveGameView():void {
			m_chair = m_GameClass.GetMeChairID();
			if(m_BetPosManager){
				m_BetPosManager.SetChair(m_chair);
			}
		}
		
		protected function onVideoLoaded (event:Event):void {
			if(this["m_videoLoad"]){
				this["m_videoLoad"].visible = false;
			}
		}
		protected function onLoadResume (event:Event):void {
			if(this["m_videoLoad"]){
				this["m_videoLoad"].visible = true;
			}
		}
		//创建投注区
		protected function InitBetPosManager():void {
			m_BetPosManager = new BetPosBaseManager();
			addChild(m_BetPosManager);
			
		}
		//创建筹码管理
		protected function InitChipManager():void {
			m_ChipManager = new ChipBaseManager();
			addChild(m_ChipManager);
			m_ChipManager.SetSize(nGameUIWidth, nGameUIHeight);
		}
		//创建历史结果管理(路子);
		protected function InitHistoryResultManger():void {
		}
		//初始化筹码选择;
		protected function InitChipSelectManager():void {
			m_ChipSelectManager =  m_GameClass.GetChipSelect("ChipSelectBaseManager");
			m_ChipSelectManager.SetChipPane (this);
			m_ChipSelectManager.SetLang(m_lang);
			var mc:MovieClip = m_ChipSelectManager.GetMovieClip();
			addChild (mc);
			mc.visible=false;
			this.setChildIndex (mc,(this.numChildren-1));
			mc.x = m_SelectChipPoint.x;
			mc.y = m_SelectChipPoint.y;
		}
		//
		protected function InitCenterMessage():void {
			m_centerMessage = new ShowGameMessage();
			m_centerMessage.x=m_centerPoint.x;
			m_centerMessage.y=m_centerPoint.y;
			m_centerMessage.SetLang(m_lang);
			m_centerMessage.visible=false;
			addChild(m_centerMessage);
		}
		//
		protected function InitShowBetPos():void{
			m_showBetPos=new ShowBetPosLimit();
			m_showBetPos.visible=false;
			m_showBetPos.mouseEnabled=false;
			m_showBetPos.SetLang(m_lang);
			addChild(m_showBetPos);
			if(m_ChipManager){
			this.setChildIndex(m_showBetPos,this.getChildIndex(m_ChipManager)+1);
			}
		}
		//创建用户信息管理
		protected function InitUserInfo():void {
			/*m_userInfo=new UserInfo();
			addChild(m_userInfo);
			m_userInfo.SetLang(m_lang);*/
			var table:cmdMemberTableInfo = m_GameClass.GetServerAttribute();
			ShowGameRoundNo(table.GameRoundNo);
			ShowTableName(ShowCMDLang(table.TableName,m_lang));
			/*ShowTableNumber(table.TableID.toString());
			ShowTablePhone(table.TablePhone);
			
			
			ShowDealerName(table.Dealer);*/
		}
		protected function InitBetInfo():void {
			/*m_BetInfo = new BetInfo();
			addChild(m_BetInfo);*/
		}
		
		public function SetHost(isHost:Boolean):void{
			/*m_isHost=isHost;
			if(m_SetUpPane){
				m_SetUpPane.Goto(m_isHost);
			}*/
		}
		//设置
		protected function InitSetUp(gameKind:int):void{
			/*if(m_SetUpPane==null){
			m_SetUpPane=new SetUpGameEffect();
			}
			m_SetUpPane.SetLang(m_lang);
			m_SetUpPane.x=m_SetUpPanePoint.x;
			m_SetUpPane.y=m_SetUpPanePoint.y;
			m_SetUpPane.visible=false;
			m_SetUpPane.Goto(m_isHost);
			addChild(m_SetUpPane);
			m_SetUpPane.SetGameView(this);
		    if(m_ChipSelectManager){
			this.setChildIndex(m_SetUpPane,this.numChildren-1);
			}*/
		}
		public function SetSound(sound:GameSound){
			m_sound=sound;
		}
		//播放声音
		//@status:游戏状态，@str除输赢/结果/座位以外全为null
		public function PlaySound(status:String,str:String):void{
			m_sound.GetSong(status,str);
		}
		//添加按钮
		protected function InitButtonView():void {
			if(this.getChildByName("m_btnExit")){
				this["m_btnExit"].addEventListener (MouseEvent.CLICK, ExitGameClient);
			}
			//"确定"按钮;
			if (this.getChildByName("m_btnConfirm")) {
				m_Confirm = this["m_btnConfirm"];
			}
			//“取消”按钮;
			if (this.getChildByName("m_btnCancel")) {
				m_Cancel = this["m_btnCancel"];
			}
			//"撤消下注";
			if (this.getChildByName("m_btnBack")) {
				m_Back = this["m_btnBack"];
			}
			//“重复下注”按钮;
			if (this.getChildByName("m_btnRebet")) {
				m_Rebet = this["m_btnRebet"];
			}
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
				this.setChildIndex(m_Confirm,this.getChildIndex(m_ChipManager));
				m_Confirm.stop();
			}
			if(m_Cancel) {
				m_Cancel.IChangLang(m_lang);
				m_Cancel.addEventListener (MouseEvent.CLICK,CancelBet);
				this.setChildIndex(m_Cancel,this.getChildIndex(m_ChipManager));
				m_Cancel.stop();
			}
			if(m_Back) {
				m_Back.IChangLang(m_lang);
				m_Back.addEventListener (MouseEvent.CLICK,BackBetChips);
				this.setChildIndex(m_Back,this.getChildIndex(m_ChipManager));
				m_Back.stop();
			}
			if(m_Rebet) {
				m_Rebet.IChangLang(m_lang);
				m_Rebet.SetEnabled (false);
				this.setChildIndex(m_Rebet,this.getChildIndex(m_ChipManager));
				m_Rebet.stop();
			}
			SetButtonEnabled(false);
		}
		//删除按钮
		public function RemoveButton():void{
		}
		
		public function SetTablePositionBet(positionBet:String):void {
			/*if (m_BetInfo) {
				m_BetInfo.SetTablePositionBet(positionBet);
			}*/
		}
		public function SetTablePositionMembers(positionMembers:String):void {
			/*if (m_BetInfo) {
				m_BetInfo.SetTablePositionMembers(positionMembers);
			}*/
		}
		//显示用户名
		public function ShowUserName(userName:String):void {
			/*if (m_userInfo) {
				m_userInfo.ShowUserName(userName);
			}*/
			if(this.getChildByName("m_UserName")){
				this["m_UserName"].text=userName;
			}
		}
		//显示余额
		public function ShowBalance(moneyType:String,balance:Number):void {
			/*if (m_userInfo) {
				m_userInfo.ShowBalance(moneyType,balance);
			}*/
			if(this.getChildByName("m_UserBal")){
				this["m_UserBal"].text=moneyType+"  "+NumberFormat.BalanceFormat(balance);
			}
		}
		//显示桌编号
		public function ShowTableNumber(tableNumber:String):void {
			/*if (m_userInfo) {
				m_userInfo.ShowTableNumber(tableNumber);
			}*/
		}
		//显示桌名称
		public function ShowTableName(tableName:String):void {
			if(this.getChildByName("m_tableName")){
				this["m_tableName"].text = tableName;
			}
		}
		public function ShowTablePhone(tablePhone:String):void {
			/*if (m_userInfo) {
				m_userInfo.ShowTablePhone(tablePhone);
			}*/
		}
		//显示游戏局号
		public function ShowGameRoundNo(roundNo:String):void {
			if (this.getChildByName("m_txtRoundNo")) {
				this["m_txtRoundNo"].text = GetOther(0,m_lang) + roundNo;
			}
		}
		//显示荷官名
		public function ShowDealerName(dealerName:String):void {
			/*if (m_userInfo) {
				m_userInfo.ShowDealerName(dealerName);
			}*/
		}
		//显示最小投注
		public function ShowQuotaMin(quotamin:String):void {
			/*if (m_userInfo) {
				m_userInfo.ShowQuotaMin(quotamin);
			}*/
		}
		//显示最大投注
		public function ShowQuotaMax(quotamax:String):void {
			/*if (m_userInfo) {
				m_userInfo.ShowQuotaMax(quotamax);
			}*/
		}
		//显示投注总额
		public function ShowQuotaMoney(money:Number):void {
		}
		//显示总输赢
		public function ShowMemberTotalWin(total:Number,money:Number):void {
			
		}
		//销毁游戏视图
		public function DestroyGameView():void {
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
			if (m_BetPosManager) {
				m_BetPosManager.Destroy();
				removeChild(m_BetPosManager);
				m_BetPosManager = null;
			}
			if (m_ChipManager) {
				m_ChipManager.Destroy();
				removeChild(m_ChipManager);
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
				var mc:MovieClip = m_ChipSelectManager.GetMovieClip();
				removeChild(mc);
				m_ChipSelectManager.Destroy();
				m_ChipSelectManager = null;
			}
			if(m_centerMessage){
				m_centerMessage.Destroy();
				removeChild(m_centerMessage);
				m_centerMessage=null;
			}
			if(m_showBetPos){
				m_showBetPos.Destroy();
				removeChild(m_showBetPos);
				m_showBetPos=null;
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
			if(m_showchipbtn ){
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
			RemoveButton();
			if(m_GameClass){
				m_GameClass=null;
			}
			while (numChildren > 0) {
				removeChildAt(0);
			}
		}
		//还原游戏视图
		public function ResetGameView():void {
			if (m_BetPosManager) {
				StopWin();
				m_BetPosManager.ResetBetPos();
			}
			if (m_ChipManager) {
				m_ChipManager.ClearChips();
			}
			/*if(m_BetInfo) {
				m_BetInfo.ResetView();
			}*/
		}
		public function GameBack():void {
			if (m_BetPosManager) {
				StopWin();
				m_BetPosManager.ResetBetPos();
			}
			if (m_ChipManager) {
				m_ChipManager.ClearChips();
			}
			/*if(m_BetInfo) {
				m_BetInfo.ResetView();
			}*/
		}
		//增加用户;
		public function SetUserInfo(wChairID:int, pUserData:cmdMemberInfo, bOwnChair:Boolean):void {
			if (m_ShowChair) {
				var chairIndex:int = GetChairIndex(wChairID);
				if (m_ChairViewList != null && m_ChairViewList[chairIndex] != null) {
					var chairView:ChairIDView = m_ChairViewList[chairIndex] as ChairIDView;
					if (chairView) {
						chairView.SetChairData(wChairID, pUserData, bOwnChair);
					}
				}
			}
		}
		//清空用户座位筹码
		public function ClearMemberChips(endGame:Array):void{
			if(m_ChipManager){
				m_ChipManager.ClearMemberChips(endGame);
			}
		}
		public function ClearUserChips(chair:int):void{
			if(m_ChipManager){
				m_ChipManager.ClearUserChips(chair);
			}
		}
		//会员下注结果
		public function OnBetPosition(wChairID:int, wBetPos:int, nBetValue:Number):void {
			m_ChipManager.ShowBetChips(wChairID, wBetPos, nBetValue);
			m_BetPosManager.ShowBetTotal(wChairID,wBetPos,nBetValue);
		}
		//会员下注;
		public function OnBet(betPosIndex:int):void {
			if(m_GameClass){
			if(m_GameClass.OnBet(betPosIndex)){
				SetButtonEnabled(true);
			   m_Rebet.SetEnabled(false);
			  };
			}
		}
		//余额更新;
		public function BalanceChang(wChairID:int, nBalance:Number):void {
			if (m_ShowChair) {
				var chairIndex:int = GetChairIndex(wChairID);

				if (m_ChairViewList != null && m_ChairViewList[chairIndex] != null) {
					var chairView:ChairIDView = m_ChairViewList[chairIndex] as ChairIDView;
					if (chairView) {
						chairView.ChangBalance(nBalance);
					}
				}
			}
		}
		//设置桌子历史结果(路子)
		public function SetTableHisRoad(hisRoad:String):void {
			if (m_HisResultManager) {
				m_HisResultManager.StringSplit(hisRoad);
			}
		}
		//////////////////////////////////////;
		//更新游戏视图
		public function UpdateGameView():void {
			if (stage) {
				stage.invalidate();
			}
		}
		//用椅子号获取索引
		public function GetChairIndex(chairID:int):int {
			return chairID - 1;
		}
		//开始投注
		public function SetBetStatus(betStatus:Boolean):void {
			m_BetPosManager.SetBetStatus(betStatus);
			if(betStatus==false){
				m_Rebet.SetEnabled(false);
			    SetButtonEnabled(false);
				if(m_showBetPos){
					m_showBetPos.visible=false;
				}
			}
			else{
				m_Rebet.SetEnabled(m_isRe);
			}
		}
		//添加赢筹码;
		public function AddWinChips(wChairID:int, wBetPos:int, money:int):void {
			m_ChipManager.AddWinChips(wChairID, wBetPos, money);
		}
		//添加输筹码;
		public function AddLoseChips(wChairID:int, wBetPos:int):void {
			m_ChipManager.AddLoseChips(wChairID, wBetPos);
		}
		//添加和筹码;
		public function AddDrawChips(wChairID:int, wBetPos:int):void {
			m_ChipManager.AddDrawChips(wChairID, wBetPos);
		}
		//开始移动;
		public function StartMove():void {
			m_ChipManager.StartMove();
		}
		/**
		 * 设置筹码选择 
		 * @chips 二维数组(1:被选择的5个筹码数组,2:当前选择筹码)
		 */
		public function SetSelectChips(chips:Array):void {
			if (m_GameClass) {
				m_GameClass.SetSelectChips(chips);
			}
		}
		//获取筹码选择
		public function GetSelectChips():Array {
			if (m_GameClass) {
				return m_GameClass.GetSelectChips();
			}
			return null;
		}
		//播放赢动画
		public function PlayWin(winBetPosList:Array):void {
			m_BetPosManager.PlayWin(winBetPosList);
		}
		public function StopWin():void {
			m_BetPosManager.StopWin();
		}
		public function InitBetTime():void{
			if (m_BetTimer == null) {
				m_BetTimer = new BetTimer();
				m_BetTimer.SetGameBaseView(this);
				m_BetTimer.SetLang(m_lang);
				addChild(m_BetTimer);
				m_BetTimer.x = m_BetTimerPoint.x;
				m_BetTimer.y = m_BetTimerPoint.y;
			}
		}
		protected function GetTimerChildIndex():int {
			return this.numChildren - 1;
		}
		//投注结束(倒计时结束)
		public function BetOver():void {
			if (m_GameClass) {
				m_GameClass.BetOver();
			}
		}
		protected function GetGameStatusChildIndex():int {
			return this.numChildren - 1;
		}
		//桌子提示消息
		public function ShowTableMessage(type:int, msgNo:int):void {
			if (m_centerMessage) {
				/*if(msgNo==MT_PlayerInsurance_StartBetting || msgNo==MT_BankerInsurance_StartBetting){
					m_centerMessage.y=m_centerPoint.y+70;
				}else{*/
					m_centerMessage.y=m_centerPoint.y;
				//}
				m_centerMessage.ShowTableMessage(type, msgNo);
			}
		}
		//投注消息
		public function ShowBetMessage(msgNo:int, errorList:Array):void {
			if (m_centerMessage) {
				m_centerMessage.ShowBetMessage(msgNo, errorList);
			}
		}
		//确认下注
		public function OnSendBet(e:MouseEvent):void {
			if (m_GameClass) {
				if(m_GameClass.OnSendBet() == false) {
					SetButtonEnabled(true);
				}
				else{
					SetButtonEnabled(false);
				}
			}
			
		}
		//取消下注
		public function CancelBet(e:MouseEvent):void {
			if (m_GameClass) {
				m_GameClass.CancelBetChips();
			}
			SetButtonEnabled(false);
		}
		//撤消下注
		public function BackBetChips(e:MouseEvent):void{
			if (m_GameClass) {
				var isBack:Boolean=m_GameClass.BackBetChips();
				SetButtonEnabled(isBack);
			}
		}
		//重复下注
		public function RepeatBet(e:MouseEvent):void {
			if (m_GameClass) {
				m_GameClass.RepeatBet();
			}
			m_Rebet.SetEnabled(false);
			SetButtonEnabled(true);
		}
		//按钮是否可用true可用
		public function SetButtonEnabled(bool:Boolean):void{
			if(m_Confirm){
				m_Confirm.SetEnabled(bool);
			}
			if(m_Cancel){
				m_Cancel.SetEnabled(bool);
			}
			if(m_Back){
				m_Back.SetEnabled(bool);
			}
		}
		//全屏
		private function OnFullScreen (event:MouseEvent):void {
			/*if (stage.displayState != StageDisplayState.FULL_SCREEN) {
				stage.displayState = StageDisplayState.FULL_SCREEN;
			} else {
				stage.displayState = StageDisplayState.NORMAL;
			}
			this["m_topInfo"]["m_btnScreen"].SetSelectStatus (stage.displayState == StageDisplayState.FULL_SCREEN);*/
		}
		//退出游戏
		protected function ExitGameClient (e:MouseEvent) {
			if (m_GameClass) {
				m_GameClass.OnSendStandUp ();
			}
		}
		public function SetTableStatus(status:int,difftime:int):void{
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
		}
		public function ShowListBet(event:MouseEvent):void{
			if(m_GameClass){
			m_GameClass.ShowListBet();
			}
		}
		public function IsReapetBet(bool:Boolean):void{
			m_isRe=bool;
			m_Rebet.SetEnabled(bool);
			m_Rebet.addEventListener(MouseEvent.CLICK,RepeatBet);
		}
		public function SetBetLimitByPos(limitforPos:Array,minlimit:int):void{
			if(limitforPos){
			    m_betLimitByPos=limitforPos;
			}
			if(minlimit){
				m_minLimit=minlimit;
			}
			if(m_BetPosManager){
				m_BetPosManager.BetLimitByPos(m_betLimitByPos,m_minLimit);
			}
		}
		
		public function BetPosLimit(betposLimit:Array,minbetposlimit:Array):void{
			if(betposLimit){
				m_betposLimit=betposLimit;
			}
			if(minbetposlimit){
				m_minbetposLimit=minbetposlimit;
			}
		}
		
		public function BetPosPoint(betpospoint:Array):void{
			if(betpospoint){
				m_betposPoint=betpospoint;
			}
		}
		public function GetBetLimitByPos():Array{
			if(m_betposLimit){
				return m_betposLimit;
			}
			return null;
		}
		public function GetMinBetLimitByPos():Array{
			if(m_minbetposLimit){
				return m_minbetposLimit;
			}
			return null;
		}
		public function ShowBetPos(isShow:Boolean,w_BetPos:int,bettotal:Number):void{
			if(isShow){
				m_showBetPos.visible=true;
				m_showBetPos.x=m_BetPosManager.x+m_betposPoint[w_BetPos][0];
				m_showBetPos.y=m_BetPosManager.y+m_betposPoint[w_BetPos][1];
				if(m_insurance==0){
				m_showBetPos.ShowBetPos(bettotal,m_minbetposLimit[w_BetPos],m_betposLimit[w_BetPos],1,0,w_BetPos,m_lang);
				}
				else{
				m_showBetPos.ShowBetPos(bettotal,0,m_betposLimit[w_BetPos],1,0,w_BetPos,m_lang);
				}
			}
			else{
				m_showBetPos.visible=false;
			}
		}
		public function ShowSetUp(e:MouseEvent):void{
			/*m_SetUpPane.visible=true;
			m_SetUpPane.SetEffect(m_Ismusic,m_Issound,m_Islookcard);//音乐,声音,眯牌*/
		}
		//获取背景音乐状态，1.游戏设置，2.大厅传出值
		public function GetMusic(isPlay:Boolean):void{
			m_Ismusic=isPlay;
		}
		//获取声音大小，1.游戏设置，2.大厅传出值
		public function GetSound(isPlay:Boolean):void{
			m_Issound=isPlay;
			if(m_sound){
			m_sound.GetVolume(m_Issound);
			}
			m_BetTimer.GetVolume(m_Issound);
		}
		//获取咪牌状态，1.游戏设置
		public function GetLookCard(islook:Boolean):void{
			m_Islookcard=islook;
		}
		public function SetGameEffect(isMusic:Boolean,isSound:Boolean):void{
			if(m_GameClass){
			m_GameClass.SetGameEffect(m_Ismusic,m_Issound);//传值回大厅
			}
		}
		public function ShowBetTime(bettime:int,difftime:int):void{
			if(m_BetTimer){
			    m_BetTimer.SetTotalTime(bettime);
				m_BetTimer.SetDifftime(difftime);
			}
		}
		//获得赔率
		public function SetOdds(odds:Number):void{
		    if(m_BetPosManager){
			m_BetPosManager.SetOdds(odds);
			}
		}
		//获得下注类型insurance:0(一般下注),1(闲保险),2(庄保险)
		public function SetInsurance(insurance:int):void{
			m_insurance=insurance;
			if(m_BetPosManager){
			m_BetPosManager.SetInsurance(insurance);
			}
		}
		public function SetPassword(tablepassword:String):Boolean{
			if(m_GameClass){
				return m_GameClass.SetPassword(tablepassword);
			}
			return false;
		}
		public function HideResultBg():void{
			
		}
		public function ShowMemberCount(members:int){
			
		}
		public function SetLang(strlang:String):void{
			m_lang=strlang;
			if(this.getChildByName("m_topInfo")){
				this["m_topInfo"]["m_btnScreen"].IChangLang(m_lang);
				this["m_topInfo"]["m_btnInfo"].IChangLang(m_lang);
				this["m_topInfo"]["m_btnExit"].IChangLang(m_lang);
				this["m_topInfo"]["m_btnSetting"].IChangLang(m_lang);
			}
		}
		public function GetCardInfo():String{
			return null;
		}
		public function SetLookOn(lookon:Boolean){
			m_lookOn=lookon;
		}
		public function ClearLookOnChips():void{
			
		}
		//点击变更椅子
		public function ChangeChair(chair:int):void{
			if(m_GameClass){
			   m_GameClass.ChangeChair(chair);
			}
		}
		public function StopChangeChair():void{
			if(m_ChairViewList){
			var index:int = 0;
			var len:int=m_ChairViewList.length;
			for (index; index<len; index++) {
				var chairView:ChairIDView = m_ChairViewList[index] as ChairIDView;
				if (chairView) {
					chairView.StopChangeChair();
				}
			}
			}
		}
		public function StartChangeChair():void{
			if(m_ChairViewList){
			var index:int = 0;
			var len:int=m_ChairViewList.length;
			for (index; index<len; index++) {
				var chairView:ChairIDView = m_ChairViewList[index] as ChairIDView;
				if (chairView) {
					chairView.StartChangeChair();
				}
			}
			}
		}
		public function ShowMessageBox(type:int,code:int,confirmfun:Function,confirmparam:Object,cancelfun:Function,cancelparam:Object):void{
			if(m_GameClass){
				m_GameClass.ShowMessageBox(type,code,confirmfun,confirmparam,cancelfun,cancelparam);
			}
		}
		public function ShowBetPosInsurance(isShow:Boolean,w_BetPos:int,bettotal:Number,point:Point):void{
			
		}
		//变换路子，资料，即时彩池显示
		public function RightInfoChange (index:int):void {
			
		}
		//显示隐藏桌台列表
		public function ShowHideTableListPane(bool:Boolean):void{
			if(m_GameClass){
				m_GameClass.ShowHideTableListPane(bool);
			}
		}
		/*//改变声音
		public function ChangeSound(e:MouseEvent):void{
			if(m_GameClass){
				m_GameClass.ChangeSound();
			}
		}
		//播放背景音乐
		public function PlayBgMusic(e:MouseEvent):void{
			if(m_GameClass){
				m_GameClass.PlayBgMusic();
			}
		}*/
		public function ShowOutBet(e:MouseEvent):void{
			ShowBetMessage(MT_Bet_Out,null);
		}
		public function GetChipView(index:int):MovieClip {
			if(m_GameClass){
				return m_GameClass.GetChipView(index);
			}
			return null;
		}
		//保险显示投注筹码
		public function SetSelctChipView():void{
			
		}
		protected function ShowChipSetting(e:MouseEvent):void{
			TargetChipSetting(true);
		}
		protected function HideChipSetting(e:MouseEvent):void{
			TargetChipSetting(false);
		}
		protected function TargetChipSetting(bool:Boolean):void{
			if(m_hidechipbtn && m_showchipbtn){
				m_hidechipbtn.visible=bool;
				m_showchipbtn.visible=!bool;
				if(m_ChipSelectManager){
					var mc:MovieClip = m_ChipSelectManager.GetMovieClip();
					mc.visible=bool;
				}
			}
		}
	}
}
include "../../LobbyModule/LobbyText.as";
include "../Common/GameMessage.as"