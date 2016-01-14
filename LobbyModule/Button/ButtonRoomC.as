package LobbyModule.Button {
	import CommonModule.ButtonBaseClass;
	import flash.events.MouseEvent;
	public class ButtonRoomC extends ButtonBaseClass {

		public function ButtonRoomC() {
			super();
			firstColor = secendColor = 0xffffff;
		}
		
		//鼠标移上
		override protected function OnMouseOver (event:MouseEvent):void {
			if (m_mcTwinkle) {
				m_isOut = true;
				m_mcTwinkle.gotoAndStop (2);
			}
		}
		override public function SetSelectStatus (status:Boolean):void {
			if (status==false) {
				currentIndex = 1;
				moveIndex = 3;
			} else {
				currentIndex = 3;
				moveIndex = 1;
			}
			m_mcTwinkle.gotoAndStop (currentIndex);
		}
	}
}