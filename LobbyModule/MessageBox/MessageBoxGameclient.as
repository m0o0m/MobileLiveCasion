package  LobbyModule.MessageBox{
	public class MessageBoxGameclient extends MessageBox{

		public function MessageBoxGameclient() {
			// constructor code
			super ();
		}
		public override function ShowMessage (msgType:int,code:int):void {
			if (m_text) {
				removeChild (m_text);
				m_text = null;
			}
			switch (code) {
				case MessageType.Game_StandUp :
					m_text=new GameStandUp();
					break;
				case MessageType.Game_OffLine :
					m_text=new GameBreak();
					break;
				case MessageType.Lobby_ExitGame :
					m_text=new LobbyExitGame();
					break;
				case MessageType.Lobby_OtherLogin :
					m_text=new LobbyOtherLogin();
					break;
				/*case MessageType.Game_NotVip:
					m_text=new GameNotVip();
					break;
				case MessageType.Game_PassWord :
					m_text=new GamePassWord();
					break;
				case MessageType.Game_UptPassWordSuccess :
					m_text=new GameUptPassWordSuccess();
					break;
				case MessageType.Game_BalanceFive:
					m_text=new GameBalanceFive();
					break;*/
				case MessageType.Game_BalanceOne:
					m_text=new GameBalanceOne();
					break;
				/*case MessageType.Game_ChangeDealer:
					m_text=new GameChangeDealer();
					break;
				case MessageType.Game_ChangeShoe:
					m_text=new GameChangeShoe();
					break;*/
				default :
					break;
			}
			if(m_text){
				m_text.gotoAndStop (lang);
				if(m_text.getChildByName("err")){
					m_text["err"].text=m_text["err"].text+"errId:100."+msgType;
				}
				ShowLimit();
				addChild (m_text);
			}
		}
		protected function ShowLimit():void{
			if(m_text){
				if(m_text.getChildByName("min")){
				m_text["min"].text=m_confirmParam;
				}
				if(m_text.getChildByName("max")){
				m_text["max"].text=m_cancleParam;
				}
			}
		}

	}
	
}
