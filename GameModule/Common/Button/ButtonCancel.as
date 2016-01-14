package GameModule.Common.Button{
	import CommonModule.ButtonBaseClass;
	import flash.text.TextFormat;
	import flash.events.MouseEvent;
	public class ButtonCancel extends ButtonBaseClass {

		public function ButtonCancel() {
			// constructor code
			super();
			firstColor = secendColor = 0x000000;
			//threeColor=0xde2826;
			threeColor=0xffffff;
		}
		override public function SetEnabled(enabled:Boolean):void {
			this.enabled = enabled;
			var format:TextFormat=new TextFormat();
			if (enabled == false) {
				m_mcTwinkle.gotoAndStop(1);
				this.buttonMode = false;
				this.mouseEnabled = false;
				m_isOut=false;
				if (m_mclanglang) {
					format.color = firstColor;
					m_mclanglang.setTextFormat (format);
				}
			} else {
				m_mcTwinkle.gotoAndStop(2);
				this.buttonMode = true;
				this.mouseEnabled = true;
				if (m_mclanglang) {
					format.color = threeColor;
					m_mclanglang.setTextFormat (format);
				}
			}
		}
		//鼠标移上
		override protected function OnMouseOver (event:MouseEvent):void {
			
		}
		//鼠标移出
		override protected function OnMouseOut (event:MouseEvent):void {
		
		}
	}
}