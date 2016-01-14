package ChipSelect{

	import flash.display.MovieClip;
	import flash.events.MouseEvent;
		import flash.text.TextFormat;
	import CommonModule.ButtonBaseClass;

	/*
	 * 总筹码中的确认按钮
	*/
	public class Affirm extends ButtonBaseClass {

		protected var totalCp:TotalChipPane = null;//总筹码显示容器

		public function Affirm () {
			super ();
			firstColor = secendColor = 0xffffff;
			threeColor=0x666666;
			x = 75;
			y = 218;
			this.addEventListener (MouseEvent.CLICK,OnClick);
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
		public function SetChipPane (tcp:TotalChipPane):void {
			if (tcp) {
				totalCp = tcp;
			}
		}

		/*
		 * 单击事件，更改当前可用筹码
		*/
		public function OnClick (e:MouseEvent):void {
				if (totalCp) {
					totalCp.OnClickAfffirm ();
					totalCp.ChangeSelectType();//只能切换自选
					totalCp.Hide();
				}
		}
		override public function SetEnabled(enabled:Boolean):void {
			this.enabled = enabled;
			var format:TextFormat=new TextFormat();
			if (enabled == false) {
				m_mcTwinkle.gotoAndStop(3);
				this.buttonMode = false;
				this.mouseEnabled = false;
				m_isOut=false;
				if (m_mclanglang) {
					format.color = threeColor;
					m_mclanglang.setTextFormat (format);
				}
			} else {
				m_mcTwinkle.gotoAndStop(1);
				this.buttonMode = true;
				this.mouseEnabled = true;
				if (m_mclanglang) {
					format.color = firstColor;
					m_mclanglang.setTextFormat (format);
				}
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