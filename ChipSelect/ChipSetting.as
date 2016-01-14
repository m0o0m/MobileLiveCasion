package ChipSelect{

	import flash.events.MouseEvent;

	public class ChipSetting extends ChipBaseView {
		protected var m_lang:String;
		/*
		 * 筹码设置
		*/
		public function ChipSetting () {
			SetChipStatus (true);
			if (this.getChildByName("twinkle")) {
				this["twinkle"].gotoAndStop (1);
			}
			if (this.getChildByName("mc")) {
				this["mc"].mouseEnabled=false;
				this["mc"].mouseChildren=false;
				this["mc"].gotoAndStop (3);
			}
			this.addEventListener (MouseEvent.MOUSE_DOWN,OnMouseDown);
			this.addEventListener (MouseEvent.MOUSE_UP,OnMouseOutChip);
		}

		/*
		 * 销毁
		*/
		public override function Destroy ():void {
			this.removeEventListener (MouseEvent.CLICK, OnClickChip);
			this.removeEventListener(MouseEvent.MOUSE_OVER, OnMouseOverChip);
			this.removeEventListener(MouseEvent.MOUSE_OUT, OnMouseOutChip);
			this.removeEventListener (MouseEvent.MOUSE_DOWN,OnMouseDown);
			this.removeEventListener (MouseEvent.MOUSE_UP,OnMouseOutChip);
		}

		/*
		 * 单击事件
		*/
		public override function OnClickChip (e:MouseEvent):void {
			if (chbm) {
				chbm.OnClickSite ();
			}
		}
		/*
		 * 鼠标移上
		*/
		override public function OnMouseOverChip (e:MouseEvent):void {
			if (this.getChildByName("twinkle")) {
				this["twinkle"].gotoAndStop (2);
			}
			if (this.getChildByName("mc")) {
				this["mc"].mouseEnabled=false;
				this["mc"].mouseChildren=false;
				this["mc"].gotoAndStop (1);
				if(m_lang){
					this["mc"]["lang"].gotoAndStop(m_lang);
				}
			}
		}

		/*
		 * 鼠标移除
		*/
		override public function OnMouseOutChip (e:MouseEvent):void {
			if (this.getChildByName("twinkle")) {
				this["twinkle"].gotoAndStop (1);
			}
			if (this.getChildByName("mc")) {
				this["mc"].mouseEnabled=false;
				this["mc"].mouseChildren=false;
				this["mc"].gotoAndStop (3);
			}
		}
		//鼠标点下
		protected function OnMouseDown (event:MouseEvent):void {
			if (this.getChildByName("twinkle")) {
				this["twinkle"].gotoAndStop (3);
			}
			if (this.getChildByName("mc")) {
				this["mc"].mouseEnabled=false;
				this["mc"].mouseChildren=false;
				this["mc"].gotoAndStop (2);
			}
		}
		override public function SetLang (strlang:String):void {
			if (this.getChildByName("lang")) {
				this["lang"].gotoAndStop (strlang);
			}
			m_lang=strlang;
		}
	}
}