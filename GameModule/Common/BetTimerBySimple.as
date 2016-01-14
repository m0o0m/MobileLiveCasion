package  GameModule.Common{
	import flash.events.TimerEvent;
	import flash.text.TextFormat;
	public class BetTimerBySimple extends BetTimer{

		public function BetTimerBySimple() {
			// constructor code
			super();
		}
		//显示框
		override public function ChangeStatus (bool:Boolean) {
			if(this.getChildByName("m_time")){
			this["m_time"].visible = bool;
			}
			this["m_bettime"].visible = bool;
			if(this.getChildByName("m_bg")){
				this["m_bg"].visible = false;
			}
		}
		//时间递减没有声音
		override public function OnShowTimer (e:TimerEvent):void {
			m_timeCount--;
			if ((m_timeCount < 0)) {
				return;
			}
			moviec.graphics.clear ();
			S_angle +=  m_ration;
			DrawSector (moviec,52,52,80,S_angle,270,0x000000);
			this["m_bettime"]["m_text"].text = m_timeCount;
			if (((m_timeCount <= 5) && m_GameBaseView)) {
				//var format:TextFormat = new TextFormat  ;
				//format.color = 0xff0000;
				//this["m_bettime"]["m_text"].setTextFormat (format);
				this["m_bettime"]["mc_shadow"].visible=true;
				this["m_bettime"]["mc_numshadow"].visible=true;
			}
		}
	}
}
include "../../LobbyModule/LobbyText.as";
