package GameModule.Common.Button {
	import CommonModule.ButtonBaseClass;
	import flash.events.MouseEvent;

	public class ButtonExit extends ButtonBaseClass {

		public function ButtonExit() {
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
		//鼠标移出
		override protected function OnMouseOut (event:MouseEvent):void {
			if (m_isOut==false) {
				return;
			}
			m_mcTwinkle.gotoAndStop (1);
		}
	}
}