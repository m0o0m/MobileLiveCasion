package  {
		import flash.text.TextFormat;
		import flash.events.MouseEvent;
	import CommonModule.ButtonBaseClass;
	public class ButtonOpenCard extends ButtonBaseClass{

		public function ButtonOpenCard() {
			// constructor code
			super();
			firstColor = secendColor = 0x000000;
			threeColor=0x4F4F4F;
			this.addEventListener (MouseEvent.MOUSE_DOWN,OnMouseDown);
			this.addEventListener (MouseEvent.MOUSE_UP,OnMouseOut);
		}
		override public function SetEnabled(enabled:Boolean):void {
			this.enabled = enabled;
			var format:TextFormat=new TextFormat();
			if (enabled == false) {
				m_mcTwinkle.gotoAndStop(3);
				this.buttonMode = false;
				this.mouseEnabled = false;
				m_isOut=false;
				if (m_mclanglang) {
					format.color = threeColor;
					m_mclanglang.setTextFormat (format);
				}
			} else {
				m_mcTwinkle.gotoAndStop(1);
				this.buttonMode = true;
				this.mouseEnabled = true;
				if (m_mclanglang) {
					format.color = firstColor;
					m_mclanglang.setTextFormat (format);
				}
			}

		}
		//鼠标点下
		protected function OnMouseDown (event:MouseEvent):void {
			if ((m_isOut == false)) {
				return;
			}
			if (m_mcTwinkle) {
				m_mcTwinkle.gotoAndStop (4);
			}
		}
		override public function Destroy ():void {
			super.Destroy ();
			this.removeEventListener (MouseEvent.MOUSE_DOWN,OnMouseDown);
			this.removeEventListener (MouseEvent.MOUSE_UP,OnMouseOut);
		}

	}
	
}
