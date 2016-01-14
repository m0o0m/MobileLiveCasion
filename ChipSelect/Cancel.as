package ChipSelect{

	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.text.TextFormat;
	import CommonModule.ButtonBaseClass;

	/*
	 * 总筹码容器中的取消按钮
	*/
	public class Cancel extends ButtonBaseClass {

		protected var totalCp:TotalChipPane = null;//总筹码容器

		public function Cancel () {
			super ();
			firstColor = secendColor = 0xffffff;
			threeColor=0x666666;
			x = 168;
			y = 218;
			this.addEventListener (MouseEvent.CLICK,OnClick);
			this.buttonMode = true;
			this.addEventListener(MouseEvent.MOUSE_DOWN,OnMouseDown);
			this.addEventListener(MouseEvent.MOUSE_UP,OnMouseUp);
		}

		/*
		 * 销毁
		*/
		public override function Destroy ():void {
			this.removeEventListener (MouseEvent.CLICK,OnClick);
			this.removeEventListener (MouseEvent.MOUSE_DOWN, OnMouseDown);
			this.removeEventListener (MouseEvent.MOUSE_UP, OnMouseUp);
			totalCp = null;
		}

		/*
		 * 实例化总筹码显示容器
		 @ tcp 总筹码显示容器
		*/
		public function SetChipPane (tcp:TotalChipPane) {
			if (tcp) {
				totalCp = tcp;
			}
		}

		/*
		 * 单击事件，取消更改当前可用筹码
		*/
		public function OnClick (e:MouseEvent) {
			if (totalCp) {
				totalCp.Hide();
			}
		}
		//鼠标按下
		protected function OnMouseDown(e:MouseEvent):void{
			if (m_mcTwinkle) {
				m_mcTwinkle.gotoAndStop (4);
			}
			if (m_mclanglang) {
					var format:TextFormat=new TextFormat();
					format.color = threeColor;
					m_mclanglang.setTextFormat (format);
				}
		}
		//鼠标弹上
		protected function OnMouseUp(e:MouseEvent):void{
			if (m_mcTwinkle) {
				m_mcTwinkle.gotoAndStop (2);
			}
			if (m_mclanglang) {
					var format:TextFormat=new TextFormat();
					format.color = firstColor;
					m_mclanglang.setTextFormat (format);
				}
		}
	}
}