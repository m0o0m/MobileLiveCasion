package  LobbyModule.MessageBox{
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import flash.events.MouseEvent;
	public class LobbyOffLine extends MessageBox {
		protected var m_TimeCount:int=30;
		protected var m_Timer:Timer;
		public function LobbyOffLine() {
			// constructor code
			super();
		}
		override public function ShowMessage (msgType:int,code:int):void {
			if (m_text==null) {
				if(msgType==MessageType.Lobby_OffLine){
					m_text=new LobbybreakLine();
				}
				m_text.gotoAndStop(lang);
				addChild(m_text);
				SetLinkTimer();
			}
		}
		public function SetLinkTimer():void {
				if (m_Timer == null) {
					m_Timer = new Timer(1000,m_TimeCount);
					m_Timer.addEventListener(TimerEvent.TIMER, OnShowTimer);
					m_Timer.addEventListener(TimerEvent.TIMER_COMPLETE, OnBetOver);
				} else {
					m_Timer.repeatCount = m_TimeCount;
					m_Timer.reset();
				}
				m_Timer.start();
		}
		//自动重连倒计时
		protected function OnShowTimer(event:TimerEvent):void {
			m_TimeCount--;
			if(m_text){
				m_text["m_time"].text=m_TimeCount.toString();
			}
		}
		//倒计时结束
		protected function OnBetOver(event:TimerEvent):void {
			ConfirmMessageBox(null);
		}
		override public function CloseMessageBox (e:MouseEvent):void {
			super.CloseMessageBox(null);
			StopTime();
		}
		override public function ConfirmMessageBox (e:MouseEvent):void {
			super.ConfirmMessageBox(null);
			StopTime();
		}
		public function StopTime():void{
			if(m_Timer){
				    m_Timer.stop();
			        m_Timer.addEventListener(TimerEvent.TIMER, OnShowTimer);
					m_Timer.addEventListener(TimerEvent.TIMER_COMPLETE, OnBetOver);
					m_Timer=null;
			}
		}
	}
}
