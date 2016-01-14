package LobbyModule.MessageBox{
	{
		import CommandProtocol.SitDownError;
		public class MessageBoxSitDownError extends MessageBox {

			public function MessageBoxSitDownError () {
				// constructor code
				super ();
			}
			public override function ShowMessage (msgType:int,code:int):void {
				if (m_text) {
					removeChild (m_text);
					m_text = null;
				}
				switch (code) {
					case SitDownError.SeatError :
						m_text=new SeatError();
						break;
					/*case SitDownError.NotVIP :
						m_text=new NotVIP();
						break;*/
					case SitDownError.SystemError :
						m_text=new SystemError();
						break;
					/*case SitDownError.VIPMoreThreeNotBet :
						m_text=new VIPMoreThreeNotBet();
						break;
					case SitDownError.ChairNumError :
						m_text=new ChairNumError();
						break;
					case SitDownError.NoChairForHost :
						m_text=new NoChairForHost();
						break;*/
					case SitDownError.NoEmptyChair :
						m_text=new NoEmptyChair();
						break;
					case SitDownError.Insufficient :
						m_text=new SitDownInsufficient();
						break;
					/*case SitDownError.AlreadyHaveHostMember :
						m_text=new AlreadyHaveHostMember();
						break;
					case SitDownError.TablePasswordError :
						m_text=new TablePasswordError();
						break;
					case SitDownError.NoHostMember :
						m_text=new NoHostMember();
						break;
					case SitDownError.SeatErrorForHaveBet:
					    m_text=new SeatErrorForHaveBet();
						break;*/
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
};