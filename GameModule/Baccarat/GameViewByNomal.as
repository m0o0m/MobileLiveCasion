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
	public class GameViewByNomal extends GameView {

		public function GameViewByNomal (prarentClass:GameClassByNomal) {
			// constructor code
			super (prarentClass);
			m_ChairViewList = null;
			m_ShowChair = false;
		}
		override protected function InitChairManager ():void {
		}
		//会员下注结果
		override public function OnBetPosition (wChairID:int,wBetPos:int,nBetValue:Number):void {
			if ((wChairID == m_chair)) {
				m_ChipManager.ShowBetChips (wChairID,wBetPos,nBetValue);
			}
			m_BetPosManager.ShowBetTotal (wChairID,wBetPos,nBetValue);
		}
		//创建投注区;
		override protected function InitBetPosManager ():void {
			m_BetPosManager = new BetPosManagerByNomal  ;
			addChild (m_BetPosManager);
		}
		//创建筹码管理
		override protected function InitChipManager ():void {
			m_ChipManager = new ChipManagerByNomal  ;
			addChild (m_ChipManager);
			m_ChipManager.SetSize (nGameUIWidth,nGameUIHeight);
		}
		override public function BetPosPoint (betpospoint:Array):void {
			if (betpospoint) {
				m_betposPoint = betpospoint;
			}
		}
		override public function ShowBetPos (isShow:Boolean,w_BetPos:int,bettotal:Number):void {
			/*if (isShow) {
				m_showBetPos.visible = true;
				m_showBetPos.x = m_BetPosManager.x + m_betposPoint[w_BetPos][0];
				m_showBetPos.y = m_BetPosManager.y + m_betposPoint[w_BetPos][1] - 20;
				if ((m_insurance == 0)) {
					m_showBetPos.ShowBetPos (bettotal,m_minbetposLimit[w_BetPos],m_betposLimit[w_BetPos],1,GameKindEnum.Baccarat,w_BetPos,m_lang);
				} else {
					m_showBetPos.ShowBetPos (bettotal,0,m_betposLimit[w_BetPos],1,GameKindEnum.Baccarat,w_BetPos,m_lang);
				}
			} else {
				m_showBetPos.visible = false;
			}*/
		}
		override protected function InitControlPane ():void {

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
					TargetChipSetting(true);
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
					TargetChipSetting(false);
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