package{
	import CommonModule.ButtonBaseClass;
	import flash.events.MouseEvent;
	public class ButtonLogin extends ButtonBaseClass {

		public function ButtonLogin () {
			super ();
			this.addEventListener (MouseEvent.MOUSE_DOWN,OnMouseDown);
			this.addEventListener (MouseEvent.MOUSE_UP,OnMouseUp);
		}
		//鼠标按下
		protected function OnMouseDown (e:MouseEvent):void {
			if (m_mcTwinkle) {
				m_mcTwinkle.gotoAndStop (4);
			}
		}
		//鼠标弹上
		protected function OnMouseUp (e:MouseEvent):void {
			if (m_mcTwinkle) {
				m_mcTwinkle.gotoAndStop (2);
			}
		}
		override public function Destroy ():void {
			super.Destroy ();
			this.removeEventListener (MouseEvent.MOUSE_DOWN, OnMouseDown);
			this.removeEventListener (MouseEvent.MOUSE_UP, OnMouseUp);
		}
	}
}