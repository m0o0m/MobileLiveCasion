package Dialog {
	import flash.geom.Point;
	import flash.events.MouseEvent;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	
	public class LobbyBreakDialog extends BaseDialog{
		protected var point:Point=new Point(140,86);
		protected var m_TimeCount:int;
		protected var m_Timer:Timer;
		
		protected var m_btn:btn;
		public function LobbyBreakDialog() {
			// constructor code
			super();
		}
		public override function InitDialog():void{
			DrowBackGround();
			InitSessionBox();
			AddReLinkBtn();
			SetLinkTimer(30);
			m_str=m_str.replace("$time$",30);
			ShowMessage();
			
		}
		//增加重连按钮
		public function AddReLinkBtn():void{
			m_btn=new btn();
			m_btn.x=_width*0.4+point.x;
			m_btn.y=_height*0.4+point.y;
			addChild(m_btn);
			m_btn.addEventListener(MouseEvent.CLICK,ReLink);
		}
		//重新连接网络
		public function ReLink(e:MouseEvent):void{
			if(m_iload){
				m_iload.ReLink();
			}
			Destory();
		}
		//显示网络断开消息;
		public function SetLinkTimer(time:int):void {
			if (time > 0) {
				m_TimeCount = time;
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
		}
		//自动重连倒计时
		protected function OnShowTimer(event:TimerEvent):void {
			m_str=init_str;
			m_TimeCount--;
			m_str=m_str.replace("$time$",m_TimeCount)
			ShowMessage();
		}
		//倒计时结束
		protected function OnBetOver(event:TimerEvent):void {
			ReLink(null);
		}
		protected var init_str:String;//最初字符串
		public override function GetMessage(str:String):void{
			m_str=str;
			init_str=m_str;
		}
		//销毁
		public override function Destory():void{
			super.Destory();
			if(m_btn){
				removeChild(m_btn);
				m_btn=null;
			}
		}
	}
}
