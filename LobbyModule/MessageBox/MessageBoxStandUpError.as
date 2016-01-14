package LobbyModule.MessageBox{
	import CommandProtocol.StandUpError;
	public class MessageBoxStandUpError extends MessageBox {

		public function MessageBoxStandUpError () {
			// constructor code
			super ();
		}
		public override function ShowMessage (msgType:int,code:int):void {
			if (m_text) {
				removeChild (m_text);
				m_text = null;
			}
			switch (code) {
				case StandUpError.NetClose :
					m_text=new GameStandUp();
					break;
				 /*case StandUpError.NotVIP :
					m_text=new NotVIP();
					break;
			   case StandUpError.NoHostMember :
					m_text=new GameTableDissolution();
					break; 
				case StandUpError.Insufficient:
				    m_text=new Insufficient();
					break;*/
				case StandUpError.NotBetMoreFive:
					 m_text=new NotBetMoreFive();
					break;
				case StandUpError.VIPTimeOut:
					 m_text=new VIPTimeOut();
				    break;

				default :
					break;
			}
			if (m_text) {
				m_text.gotoAndStop (lang);
				if (m_text.getChildByName("err")) {
					m_text["err"].text = m_text["err"].text + "errId:100." + msgType;
				}
				addChild (m_text);
			}
		}

	}

}