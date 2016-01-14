package {
	import flash.events.MouseEvent;
	import CommonModule.ButtonBaseClass;
	public class ButtonLook extends ButtonBaseClass {

		public function ButtonLook () {
			// constructor code
			super ();
			this.addEventListener (MouseEvent.MOUSE_DOWN,OnMouseDown);
			this.addEventListener (MouseEvent.MOUSE_UP,OnMouseOut);
			if (m_mcTwinkle.getChildByName("btn_on")) {
				m_mcTwinkle["btn_on"].stop ();
			}
		}
		//鼠标移上;
		override protected function OnMouseOver (event:MouseEvent):void {
			if (m_mcTwinkle) {
				m_isOut = true;
				if (m_mcTwinkle.getChildByName("btn_on")) {
					m_mcTwinkle["btn_on"].gotoAndStop (2);
				}
			}
		}
		//鼠标移出
		override protected function OnMouseOut (event:MouseEvent):void {
			if ((m_isOut == false)) {
				return;
			}
			if (m_mcTwinkle) {
				if (m_mcTwinkle.getChildByName("btn_on")) {
					m_mcTwinkle["btn_on"].gotoAndStop (1);
				}
			}
		}
		//鼠标点下
		protected function OnMouseDown (event:MouseEvent):void {
			if ((m_isOut == false)) {
				return;
			}
			if (m_mcTwinkle) {
				if (m_mcTwinkle.getChildByName("btn_on")) {
					m_mcTwinkle["btn_on"].gotoAndStop (3);
				}
			}
		}
		override public function Destroy ():void {
			super.Destroy ();
			this.removeEventListener (MouseEvent.MOUSE_DOWN,OnMouseDown);
			this.removeEventListener (MouseEvent.MOUSE_UP,OnMouseOut);
		}
		override public function SetSelectStatus (status:Boolean):void {
			super.SetSelectStatus (status);
			if (m_mcTwinkle.getChildByName("btn_on")) {
				m_mcTwinkle["btn_on"].stop ();
			}
		}

	}

}