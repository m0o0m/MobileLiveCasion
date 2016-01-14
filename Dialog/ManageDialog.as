package Dialog {
	import flash.display.MovieClip;
	import IGameFrame.ILoad;
	
	public class ManageDialog extends MovieClip{
		protected var m_dia:BaseDialog;
		protected var m_message:Array = ["网络已断开，请重新连接。($time$秒后自动重连)","游戏已断开，请重新进入","您已退出游戏","桌主已离开,请重新进入游戏"];
		
		public function ManageDialog() {
			// constructor code
		}
		public function GetMessageType(type:int):void{
			Destory();
			switch(type){
				case DialogConst.LobbyBreak:
				m_dia=new LobbyBreakDialog();
				break;
				case DialogConst.GameBreak:
				case DialogConst.StandUp:
				case DialogConst.DissolveTable:
				m_dia=new BaseDialog();
				break;
			}
			addChild(m_dia);
			m_dia.GetMessage(m_message[type]);
			m_dia.InitDialog();
			
		}
		public function SetILoad(iload:ILoad):void{
			if(m_dia){
				m_dia.SetILoad(iload);
			}
		}
		public function Destory():void{
			if(m_dia){
				m_dia.Destory();
				removeChild(m_dia);
				m_dia=null;
			}
		}
	}
}
