package CommonModule{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;

	import IGameFrame.IChangLang;
	import flash.geom.ColorTransform;
	import flash.text.TextFormat;
	import flash.text.TextField;

	public class ButtonBaseClass extends MovieClip implements IChangLang {
		protected var m_mcTwinkle:MovieClip;//闪烁
		protected var m_mcLang:MovieClip;//语言文字
		protected var m_mclanglang:TextField;

		protected var currentIndex:int = 1;
		protected var moveIndex:int = 2;
		protected var firstColor:Number = 0x917949;
		protected var secendColor:Number = 0xFCEE21;
		protected var threeColor:Number = 0xFFFFFF;

		protected var m_isOut:Boolean = false;

		public function ButtonBaseClass () {
			this.stop();
			this.mouseChildren = false;
			this.buttonMode = true;
			if (this.getChildByName("twinkle")) {
				m_mcTwinkle = this.getChildByName("twinkle") as MovieClip;
				m_mcTwinkle.stop ();
			}
			if (this.getChildByName("lang")) {
				m_mcLang = this.getChildByName("lang") as MovieClip;
				m_mcLang.stop ();
				if (m_mcLang.getChildByName("lang") && this.enabled == true) {
					m_mclanglang = m_mcLang.getChildByName("lang") as TextField;
				}
			}
			this.addEventListener (MouseEvent.MOUSE_OVER, OnMouseOver);
			this.addEventListener (MouseEvent.MOUSE_OUT, OnMouseOut);
		}
		public function SetEnabled (enabled:Boolean):void {
			this.enabled = enabled;
			if (enabled == false) {
				this.alpha = 0.5;
				this.buttonMode = false;
				this.mouseEnabled = false;
				m_isOut = false;
			} else {
				this.alpha = 1;
				this.buttonMode = true;
				this.mouseEnabled = true;
			}

		}
		public function Destroy ():void {
			this.removeEventListener (MouseEvent.MOUSE_OVER, OnMouseOver);
			this.removeEventListener (MouseEvent.MOUSE_OUT, OnMouseOut);
		}
		public function IChangLang (strLang:String):void {
			if (m_mcLang) {
				m_mcLang.gotoAndStop (strLang);
				if (m_mcLang.getChildByName("lang")) {
					m_mclanglang = m_mcLang.getChildByName("lang") as TextField;
					if (this.enabled == false) {
						var format:TextFormat=new TextFormat();
						format.color = threeColor;
						m_mclanglang.setTextFormat (format);
					}
				}
			}
		}
		//鼠标移上
		protected function OnMouseOver (event:MouseEvent):void {
			if (m_mcTwinkle) {
				m_isOut = true;
				m_mcTwinkle.gotoAndStop (moveIndex);
				if (m_mcLang) {
					var format:TextFormat=new TextFormat();
					if (moveIndex == 2) {
						format.color = secendColor;
						if (m_mclanglang) {
							m_mclanglang.setTextFormat (format);
						}
					} else {
						format.color = firstColor;
						if (m_mclanglang) {
							m_mclanglang.setTextFormat (format);
						}
					}
				}
			}
		}
		//鼠标移出
		protected function OnMouseOut (event:MouseEvent):void {
			if (m_isOut==false) {
				return;
			}
			if (m_mcTwinkle) {
				m_mcTwinkle.gotoAndStop (currentIndex);
				if (m_mcLang) {
					var format:TextFormat=new TextFormat();
					if (moveIndex == 2) {
						format.color = firstColor;
						if (m_mclanglang) {
							m_mclanglang.setTextFormat (format);
						}
					} else {
						format.color = secendColor;
						if (m_mclanglang) {
							m_mclanglang.setTextFormat (format);
						}
					}
				}
			}
		}
		public function SetSelectStatus (status:Boolean):void {
			if (status==false) {
				currentIndex = 1;
				moveIndex = 2;
			} else {
				currentIndex = 2;
				moveIndex = 1;
			}
			if(m_mcTwinkle){
				m_mcTwinkle.gotoAndStop (currentIndex);
			}
		}
	}
}