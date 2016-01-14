package Dialog {
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.text.TextFormat;
	
	public class SessionBox extends MovieClip{
		
		protected var m_dia:BaseDialog;
		protected var textfor:TextFormat;
		public function SessionBox() {
			// constructor code
			textfor=new TextFormat();
			textfor.align="center";
			this["m_text"].selectable=false;
			this["m_close"].addEventListener(MouseEvent.CLICK,CloseDialog);
			this["m_confirm"].addEventListener(MouseEvent.CLICK,CloseDialog);
		}
		public function ShowMessage(str:String ):void{
			this["m_text"].text=str;
			this["m_text"].setTextFormat(textfor);
		}
		public function GetDialog(dia:BaseDialog):void{
			m_dia=dia
		}
		public function CloseDialog(e:MouseEvent):void{
			m_dia.Destory();
			this["m_close"].removeEventListener(MouseEvent.CLICK,CloseDialog);
		}
		public function Destory():void{
			this["m_text"].text="";
			var index:int=this.numChildren-1;
			for(;index>0;index--){
				this.removeChildAt(0);
			}
		}
	}
}
