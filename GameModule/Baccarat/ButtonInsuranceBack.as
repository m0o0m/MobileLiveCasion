package  {
	import CommonModule.ButtonBaseClass;
	import flash.events.MouseEvent;
	public class ButtonInsuranceBack extends ButtonBaseClass{

		public function ButtonInsuranceBack() {
			// constructor code
			super();
			this.addEventListener(MouseEvent.MOUSE_DOWN,OnMouseDown);
			this.addEventListener(MouseEvent.MOUSE_UP,OnMouseUp);
		}
		override public function SetEnabled(enabled:Boolean):void {
			this.enabled = enabled;
			if (enabled == false) {
				m_mcTwinkle.gotoAndStop(3);
				this.buttonMode = false;
				this.mouseEnabled = false;
				m_isOut=false;
			} else {
				m_mcTwinkle.gotoAndStop(1);
				this.buttonMode = true;
				this.mouseEnabled = true;
			}
		}
		//鼠标按下
		protected function OnMouseDown(e:MouseEvent):void{
			if (m_mcTwinkle) {
				m_mcTwinkle.gotoAndStop (4);
			}
		}
		//鼠标弹上
		protected function OnMouseUp(e:MouseEvent):void{
			if (m_mcTwinkle) {
				m_mcTwinkle.gotoAndStop (2);
			}
		}
		override public function Destroy ():void {
			super.Destroy();
			this.removeEventListener (MouseEvent.MOUSE_DOWN, OnMouseDown);
			this.removeEventListener (MouseEvent.MOUSE_UP, OnMouseUp);
		}


	}
	
}
