package LobbyModule.MessageBox {
	import flash.display.MovieClip;
	
	public class MessageBoxBase extends MovieClip {
		protected var m_msgManager:MessageBoxManager;
		protected var m_confirmFunction:Function = null;
		protected var m_confirmParam:Object = null;
		protected var m_cancleFunction:Function = null;
		protected var m_cancleParam:Object = null;
		protected var m_msgType:int = 0;
		protected var m_code:int=0;
		protected var lang:String="ch";
		
		public function MessageBoxBase() {
			
		}
		public function Show(msgManager:MessageBoxManager, msgType:int,code:int, confirmFunction:Function, confirmParam:Object, cancleFunction:Function, cancleParam:Object):void {
			m_msgType = msgType;
			m_code=code;
			m_msgManager = msgManager;
			m_confirmFunction = confirmFunction;
			m_confirmParam = confirmParam;
			m_cancleFunction = cancleFunction;
			m_cancleParam = cancleParam;
		}
		public function Destroy():void {
			m_msgManager = null;
			m_confirmFunction = null;
			m_confirmParam = null;
			m_cancleFunction = null;
			m_cancleParam = null;
		}
		public function SetLang(strLang:String):void{
			lang=strLang;
		}
		//m_msgTitle
	}
}