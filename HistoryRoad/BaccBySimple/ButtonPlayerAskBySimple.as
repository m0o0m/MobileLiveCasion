package HistoryRoad.BaccBySimple{
	import CommonModule.ButtonBaseClass;
	import flash.events.MouseEvent;
	public class ButtonPlayerAskBySimple extends ButtonBaseClass {

		public function ButtonPlayerAskBySimple () {
			// constructor code
			super ();
			this.addEventListener (MouseEvent.MOUSE_DOWN,OnMouseDown);
			this.addEventListener (MouseEvent.MOUSE_UP,OnMouseUp);
		}
		//鼠标按下
		protected function OnMouseDown (e:MouseEvent):void {
			if (m_mcTwinkle) {
				m_mcTwinkle.gotoAndStop (3);
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
			this.removeEventListener (MouseEvent.MOUSE_DOWN,OnMouseDown);
			this.removeEventListener (MouseEvent.MOUSE_UP,OnMouseUp);
		}

	}

}