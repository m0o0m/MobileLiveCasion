package HistoryRoad.RoulBtn{
	import CommonModule.ButtonBaseClass;
	import flash.events.MouseEvent;
	import flash.text.TextFormat;
	public class ButtonBigOrSmall extends ButtonBaseClass {
		protected var format:TextFormat=new TextFormat();
		public function ButtonBigOrSmall() {
			// constructor code
			super();
		threeColor = 0xCCA246;
			firstColor = 0xCCCCCC;
			secendColor = 0xFFFFFF;
			this.addEventListener (MouseEvent.MOUSE_DOWN,OnMouseDown);
			this.addEventListener (MouseEvent.MOUSE_UP,OnMouseOver);
		}
		override public function SetEnabled (enabled:Boolean):void {
			this.enabled = enabled;
			if ((enabled == false)) {
				this.buttonMode = false;
				this.mouseEnabled = false;
				m_isOut = false;
			} else {
				this.buttonMode = true;
				this.mouseEnabled = true;
			}

		}
		//鼠标移上
		override protected function OnMouseOver (event:MouseEvent):void {
			if (m_mcTwinkle) {
				m_isOut = true;
				m_mcTwinkle.gotoAndStop (2);
				if (m_mcLang) {
					var format:TextFormat = new TextFormat  ;
					if ((currentIndex == 1)) {
						format.color = secendColor;
						if (m_mclanglang) {
							m_mclanglang.setTextFormat (format);
						}
					}
				}
			}
		}
		//鼠标移出
		override protected function OnMouseOut (event:MouseEvent):void {
			if ((m_isOut == false)) {
				return;
			}
			if (m_mcTwinkle) {
				m_mcTwinkle.gotoAndStop (1);
				if (m_mcLang) {
					var format:TextFormat = new TextFormat  ;
					if ((currentIndex == 1)) {
						format.color = firstColor;
						if (m_mclanglang) {
							m_mclanglang.setTextFormat (format);
						}
					}
				}
			}
		}
		//鼠标点下
		protected function OnMouseDown (event:MouseEvent):void {
			if ((m_isOut == false)) {
				return;
			}
			if (m_mcTwinkle) {
				m_mcTwinkle.gotoAndStop (3);
				if (m_mcLang) {
					var format:TextFormat = new TextFormat  ;
					if ((currentIndex == 1)) {
						format.color = threeColor;
						if (m_mclanglang) {
							m_mclanglang.setTextFormat (format);
						}
					}
				}
			}
		}
		override public function Destroy ():void {
			super.Destroy ();
			this.removeEventListener (MouseEvent.MOUSE_DOWN,OnMouseDown);
			this.removeEventListener (MouseEvent.MOUSE_UP,OnMouseOver);
		}
		override public function SetSelectStatus (status:Boolean):void {
			var format:TextFormat = new TextFormat  ;
			if ((status == false)) {
				currentIndex = 1;
				format.color = firstColor;
				SetEnabled (true);
			} else {
				currentIndex = 3;
				format.color = threeColor;
				SetEnabled (false);
			}
			m_mcTwinkle.gotoAndStop (currentIndex);
			if (m_mcLang) {
				if (m_mclanglang) {
					m_mclanglang.setTextFormat (format);
				}
			}
		}

	}
	
}
