package LobbyModule.Button{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;

	public class ButtonTableEnter extends MovieClip {
		public function ButtonTableEnter () {
			this.addEventListener (MouseEvent.MOUSE_OVER,OnMouseOver);
			this.addEventListener (MouseEvent.MOUSE_DOWN,OnMouseDown);
			this.addEventListener (MouseEvent.MOUSE_UP,OnMouseOver);
			this.addEventListener (MouseEvent.MOUSE_OUT,OnMouseDown);
			this.stop();
		}
		//鼠标按下
		protected function OnMouseOver (e:MouseEvent):void {
			this.gotoAndStop ("2");
		}
		//鼠标弹上
		protected function OnMouseDown (e:MouseEvent):void {
			this.gotoAndStop ("1");
		}
		protected function SetStatus (bool:Boolean):void {
			if (bool) {
				this.gotoAndStop (2);
			} else {
				this.gotoAndStop (1);
			}
		}
		public function Destroy ():void {
			this.removeEventListener (MouseEvent.MOUSE_OVER,OnMouseOver);
			this.removeEventListener (MouseEvent.MOUSE_DOWN,OnMouseDown);
			this.removeEventListener (MouseEvent.MOUSE_UP,OnMouseOver);
			this.removeEventListener (MouseEvent.MOUSE_OUT,OnMouseDown);
		}
	}
}