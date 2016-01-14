package LobbyModule.Button {
	import flash.events.MouseEvent;
	import CommonModule.ButtonBaseClass;
	
	public class ButtonTcClose extends ButtonBaseClass {

		public function ButtonTcClose() {
			// constructor code
			super();
			firstColor = secendColor = 0x000000;
		}
		
		//鼠标移上
		override protected function OnMouseOver (event:MouseEvent):void {
			if (m_mcTwinkle) {
				m_isOut = true;
				m_mcTwinkle.gotoAndStop (2);
			}
		}
		override protected function OnMouseOut (event:MouseEvent):void {
			if (m_isOut==false) {
				return;
			}
			if (m_mcTwinkle) {
				m_mcTwinkle.gotoAndStop (1);
			}
		}

	}
	
}
