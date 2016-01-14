package {
	import flash.display.MovieClip;
	import flash.display.Graphics;
	import flash.display.BitmapData;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	import GameModule.Common.InfoPane.*;
	import GameModule.Common.*;
	import IGameFrame.*;
	import Net.*;
	import GameModule.Common.PK.PKShowBaseManager;
	import CommandProtocol.cmdMemberInfo;
	import CommandProtocol.cmdMemberTableInfo;
	import CommandProtocol.GameKindEnum;
	import flash.display.DisplayObject;

	//游戏视图
	public class GameViewByInsurance extends GameView {
		//保险投注影片剪辑for betposInsurance
		//protected var m_betposForInsurance:BetPosForInsurance;
		//保险投注影片剪辑坐标for betposInsurance
		//protected var m_point:Point = new Point(484,393);
		//保险筹码选择
		//protected var m_InsuranceChipSelectManager:IChipSelect;
		//筹码选择数组
		protected var m_selectChipsList:Array=new Array();
		//构造函数
		public function GameViewByInsurance (prarentClass:GameClassByInsurance) {
			//m_BetTimerPoint = new Point(176.6,22);
			super (prarentClass);
			m_ChairViewList = null;
			m_ShowChair = false;
			//m_topInfo["m_btnInfo"].addEventListener (MouseEvent.CLICK,ShowListBet);
			//m_topInfo["m_btnInfo"];
			//m_topInfo["m_btnSetting"]
		}
		//for betposInsurance
		public override function InitGameView ():Boolean {
			if (super.InitGameView() == false) {
				return false;
			}
			InitBetPosForInsurance ();
			return true;
		}
		//for insurance
		override public function ActiveGameView():void {
			super.ActiveGameView();
			/*if(m_betposForInsurance){
				m_betposForInsurance.SetChair(m_chair);
			}*/
		}
		//for betposInsurance
		override public function SetInsurance (insurance:int):void {
			super.SetInsurance (insurance);
			/*if (insurance!=0 && m_betposForInsurance) {
				m_betposForInsurance.SetInsurance (insurance);
				
			}*/
		}
		override public function SetSelctChipView():void{
			/*if(m_InsuranceChipSelectManager){
					m_InsuranceChipSelectManager.HideSelectChip (true);
					if(m_selectChipsList){
						m_InsuranceChipSelectManager.ShowChipPane(m_selectChipsList);
					}else{
						m_InsuranceChipSelectManager.SetChipPane (this);
					}
				}*/
		}
		//获得赔率for betposInsurance;
		override public function SetOdds (odds:Number):void {
			super.SetOdds (odds);
			/*if (m_betposForInsurance) {
				m_betposForInsurance.SetOdds (odds);
			}*/
		}
		//for betposInsurance;
		protected function InitBetPosForInsurance ():void {
			/*if (m_betposForInsurance==null) {
				m_betposForInsurance=new BetPosForInsurance();
				m_betposForInsurance.x = m_point.x;
				m_betposForInsurance.y = m_point.y;
				m_betposForInsurance.ResetBetPos ();
				m_betposForInsurance.SetGameView (this);
				addChild (m_betposForInsurance);
				if (m_InsuranceChipSelectManager) {
					var mc:MovieClip = m_InsuranceChipSelectManager.GetMovieClip();
					this.setChildIndex (m_betposForInsurance,this.getChildIndex(mc)+1);
					if (m_showBetPos) {
						this.setChildIndex (m_showBetPos,this.getChildIndex(m_betposForInsurance));
					}
				}
			}*/
		}
		//for betposInsurance
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
				switch (status) {
					case 2 :
						TargetChipSetting(true);
						if (m_insurance==0) {
						} else {
							m_Rebet.SetEnabled (false);
						}
						break;
					case 0 :
					case 1 :
					case 3 :
					case 4 :
					case 6 :
							if(m_selectChipsList && m_ChipSelectManager ){
								m_ChipSelectManager.ShowChipPane(m_selectChipsList);
							}
						TargetChipSetting(false);
						break;
					case 5 :
						m_insurance=0;
						break;
					default :
						break;
				}
				if(this.getChildByName("mc_status")){
				this["mc_status"].text = GetTableStatus(status,m_lang);
			}
			//}
		}
		//会员下注结果
		override public function OnBetPosition(wChairID:int, wBetPos:int, nBetValue:Number):void {
			if(wChairID==m_chair){
			m_ChipManager.ShowBetChips(wChairID, wBetPos, nBetValue);
			}
			m_BetPosManager.ShowBetTotal(wChairID,wBetPos,nBetValue);
		}
		//会员下注for betposInsurance;
		override public function OnBet (betPosIndex:int):void {
			if (m_GameClass) {
				if (m_GameClass.OnBet(betPosIndex)) {
					SetButtonEnabled (true);
					m_Rebet.SetEnabled (false);
				}
			}
		}
		//确认下注for betposInsurance
		override public function OnSendBet (e:MouseEvent):void {
			if (m_GameClass) {
				if (m_GameClass.OnSendBet() == false) {
					SetButtonEnabled (true);
					/*if (m_betposForInsurance) {
						m_betposForInsurance.SetButtonEnabled (true);
					}*/
				} else {
					SetButtonEnabled (false);
					/*if (m_betposForInsurance ) {
						m_betposForInsurance.SetButtonEnabled (false);
					}*/
				}
			}

		}
		//取消下注
		override public function CancelBet (e:MouseEvent):void {
			if (m_GameClass) {
				m_GameClass.CancelBetChips ();
			}
			SetButtonEnabled (false);
			/*if (m_betposForInsurance ) {
				m_betposForInsurance.SetButtonEnabled (false);
			}*/
		}
		//撤消下注;
		override public function BackBetChips (e:MouseEvent):void {
			if (m_GameClass) {
				var isBack:Boolean = m_GameClass.BackBetChips();
				SetButtonEnabled (isBack);
				/*if (m_betposForInsurance ) {
					m_betposForInsurance.SetButtonEnabled (isBack);
				}*/
			}
		}
		//for betposInsurance;
		override public function ShowBetPosInsurance(isShow:Boolean,w_BetPos:int,bettotal:Number,point:Point):void{
			if( m_betposLimit==null){
				return;
			}
			if (isShow) {
				m_showBetPos.visible = true;
				m_showBetPos.x = point.x;
				m_showBetPos.y = point.y;
				m_showBetPos.ShowBetPos (bettotal,m_minbetposLimit[w_BetPos],m_betposLimit[w_BetPos],1,GameKindEnum.InsuranceBaccarat,w_BetPos,m_lang);
			} else {
				m_showBetPos.visible = false;
			}
		}
		override protected function InitChairManager ():void {
		}
		//创建投注区
		override protected function InitBetPosManager ():void {
			m_BetPosManager = new BetPosManagerByOne();
			addChild (m_BetPosManager);
		}
		//创建筹码管理
		override protected function InitChipManager ():void {
			m_ChipManager = new ChipManagerByOne();
			addChild (m_ChipManager);
			m_ChipManager.SetSize (nGameUIWidth, nGameUIHeight);
		}
		
		override public function BetPosPoint(betpospoint:Array):void{
			if(betpospoint){
				m_betposPoint=betpospoint;
			}
		}
		override public function ShowBetPos(isShow:Boolean,w_BetPos:int,bettotal:Number):void{
			/*if(isShow){
				m_showBetPos.visible=true;
				m_showBetPos.x=m_BetPosManager.x+m_betposPoint[w_BetPos][0];
				m_showBetPos.y=m_BetPosManager.y+m_betposPoint[w_BetPos][1]-20;
				m_showBetPos.ShowBetPos(bettotal,m_minbetposLimit[w_BetPos],m_betposLimit[w_BetPos],1,GameKindEnum.InsuranceBaccarat,w_BetPos,m_lang);
			}
			else{
				m_showBetPos.visible=false;
			}*/
		}
		override protected function InitControlPane():void{
			
		}
		/**
		 * 设置筹码选择 
		 * @chips 二维数组(1:被选择的5个筹码数组,2:当前选择筹码)
		 */
		override public function SetSelectChips(chips:Array):void {
			if (m_GameClass) {
				m_GameClass.SetSelectChips(chips);
			}
			m_selectChipsList=chips;
		}
		public override function DestroyGameView ():void {
			
			/*if(m_InsuranceChipSelectManager){
				var mc:MovieClip = m_InsuranceChipSelectManager.GetMovieClip();
				removeChild(mc);
				m_InsuranceChipSelectManager.Destroy();
				m_InsuranceChipSelectManager = null;
			}
			if(m_betposForInsurance){
				m_betposForInsurance.Destroy();
				removeChild(m_betposForInsurance);
				m_betposForInsurance=null;
			}*/
			super.DestroyGameView();
		}
		
	}
}
include "../Common/GameMessage.as"
include "../../LobbyModule/LobbyText.as"