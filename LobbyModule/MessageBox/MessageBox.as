package LobbyModule.MessageBox{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;

	public class MessageBox extends MessageBoxBase {
		protected var m_close:Object;
		protected var m_confirm:Object;
		//显示文本
		protected var m_text:MovieClip;
		public function MessageBox () {
			// constructor code
			if (this.getChildByName("close")) {
				m_close = this.getChildByName("close");
				m_close.addEventListener (MouseEvent.CLICK,CloseMessageBox);
			}
			if (this.getChildByName("confirm")) {
				m_confirm = this.getChildByName("confirm");
				m_confirm.addEventListener (MouseEvent.CLICK,ConfirmMessageBox);
			}
		}
		override public function Show (msgManager:MessageBoxManager, msgType:int,code:int, confirmFunction:Function, confirmParam:Object,cancleFunction:Function,cancleParam:Object):void {
			m_msgType = msgType;
			m_code=code;
			m_msgManager = msgManager;
			m_confirmFunction = confirmFunction;
			m_confirmParam = confirmParam;
			m_cancleFunction = cancleFunction;
			m_cancleParam = cancleParam;
			ShowMessage (m_msgType,m_code);
		}
		public function ShowMessage (msgType:int,code:int):void {
		}
		public function CloseMessageBox (e:MouseEvent):void {
			if (m_msgManager) {
				m_msgManager.HideMessageBox ();
			}
			if (m_cancleFunction!=null) {
				m_cancleFunction ();
			}
		}
		public function ConfirmMessageBox (e:MouseEvent):void {
			if (m_msgManager) {
				m_msgManager.HideMessageBox ();
			}
			if (m_confirmFunction!=null) {
				if (m_text["password"]) {
					if (m_text["password"].text == "") {
						return;
					}
					m_confirmFunction (m_text["password"].text);
					return;
				}
				m_confirmFunction ();
			}
		}
		override public function Destroy ():void {
			super.Destroy ();
			if (m_close) {
				m_close.removeEventListener (MouseEvent.CLICK,CloseMessageBox);
				m_close = null;
			}
			if (m_confirm) {
				m_confirm.removeEventListener (MouseEvent.CLICK,ConfirmMessageBox);
				m_confirm = null;
			}
			if (m_text) {
				removeChild (m_text);
				m_text = null;
			}
		}
		public override function SetLang(strLang:String):void{
			super.SetLang(strLang);
			if(m_confirm){
				m_confirm.IChangLang(lang);
			}
			if (this.getChildByName("top")) {
				this["top"].gotoAndStop(lang);
			}
		}
	}
}