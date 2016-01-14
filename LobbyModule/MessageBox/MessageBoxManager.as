package LobbyModule.MessageBox{
	import flash.display.MovieClip;
	public class MessageBoxManager extends MovieClip  {
		protected var m_msgBox:MessageBoxBase = null;
		protected var m_msgType:int = 0;
		protected var lang:String;

		public function MessageBoxManager() {

		}
		public function ShowMessageBox(msgType:int,code:int, confirmFunction:Function, confirmParam:Object, cancleFunction:Function, cancleParam:Object):void {
			if(m_msgBox) {
				m_msgBox.Destroy();
				removeChild(m_msgBox);
				m_msgBox = null;
			}
			
			switch (msgType) {
				case MessageType.Gameclient:
					m_msgBox = new MessageBoxGameclient();
					break;
				case MessageType.SitDownError:
					m_msgBox = new MessageBoxSitDownError();
					break;
				case MessageType.StandUpError:
					m_msgBox = new MessageBoxStandUpError();
					break;
				case MessageType.Lobby_OffLine:
					m_msgBox=new LobbyOffLine;
					break;
			}
			if (m_msgBox) {
				m_msgBox.SetLang(lang);
				m_msgBox.Show(this,msgType,code,confirmFunction, confirmParam, cancleFunction, cancleParam);
				m_msgBox.scaleX=2;
				m_msgBox.scaleY=2;
				addChild(m_msgBox);
				m_msgBox.x = (this.width - m_msgBox.width)/2;
				m_msgBox.y = (this.height - m_msgBox.height)/2;
				this.visible = true;
			}
		}
		public function Destroy():void {
			if(m_msgBox) {
				m_msgBox.Destroy();
				removeChild(m_msgBox);
				m_msgBox = null;
			}
		}
		//m_msgTitle
		public function HideMessageBox():void {
			this.visible = false;
		}
		public function SetLang(strLang:String):void{
			lang=strLang;
		}
		
	}
}