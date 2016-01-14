package {
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import LobbyModule.MessageBox.MessageType;

	public class HostControlPane extends MovieClip {
		public var m_GameView:GameView;

		public function HostControlPane () {
			stop();
			this["m_btnOpenCard"].addEventListener (MouseEvent.CLICK, OnOpenCard);
			this["m_btnNextRound"].addEventListener (MouseEvent.CLICK, OnNextRound);
			this["m_btnChangeDealer"].addEventListener (MouseEvent.CLICK, OnChangeDealer);
			this["m_btnChangeBoot"].addEventListener (MouseEvent.CLICK, OnChangeBoot);
		}
		public function Destroy ():void {
			this["m_btnOpenCard"].removeEventListener (MouseEvent.CLICK, OnOpenCard);
			this["m_btnNextRound"].removeEventListener (MouseEvent.CLICK, OnNextRound);
			this["m_btnChangeDealer"].removeEventListener (MouseEvent.CLICK, OnChangeDealer);
			this["m_btnChangeBoot"].removeEventListener (MouseEvent.CLICK, OnChangeBoot);
		}
		public function SetGameView (game:GameView):void {
			m_GameView = game;
		}
		private var m_isLookCard:Boolean = true;
		public function SetLookCard (look:Boolean):void {
			m_isLookCard = look;
		}
		private function OnOpenCard (event:MouseEvent):void {
			if (m_GameView) {
				m_GameView.ControlOpenCard (m_isLookCard);
			}
		}
		private function OnNextRound (event:MouseEvent):void {
			if (m_GameView) {
				m_GameView.ControlNextRound ();
			}
		}
		private function OnChangeDealer (event:MouseEvent):void {
			if (m_GameView) {
				m_GameView.ControlChangeDealer ();
				m_GameView.ShowMessageBox (MessageType.Gameclient,MessageType.Game_ChangeDealer,null,null,null,null);
			}
		}
		private function OnChangeBoot (event:MouseEvent):void {
			if (m_GameView) {
				m_GameView.ControlChangeBoot ();
				m_GameView.ShowMessageBox (MessageType.Gameclient,MessageType.Game_ChangeShoe,null,null,null,null);
			}
		}
		public function SetStatus (status:int):void {
			switch (status) {
				case 2 :
					SetBtnEnable (true);
					break;
				case 0 :
				case 1 :
				case 3 :
				case 4 :
				case 5 :
				case 6 :
					SetBtnEnable (false);
					break;
				default :
					break;
			}

		}
		protected function SetBtnEnable (bool:Boolean):void {
			if (this.getChildByName("m_btnOpenCard")) {
				this["m_btnOpenCard"].SetEnabled (bool);
			}
			if (this.getChildByName("m_btnNextRound")) {
				this["m_btnNextRound"].SetEnabled (bool);
			}
			if (this.getChildByName("m_btnChangeDealer")) {
				this["m_btnChangeDealer"].SetEnabled (bool);
			}
			if (this.getChildByName("m_btnChangeBoot")) {
				this["m_btnChangeBoot"].SetEnabled (bool);
			}
		}
		public function SetLang (strlang:String):void {
			if (this.getChildByName("m_btnOpenCard")) {
				this["m_btnOpenCard"].IChangLang (strlang);
			}
			if (this.getChildByName("m_btnNextRound")) {
				this["m_btnNextRound"].IChangLang (strlang);
			}
			if (this.getChildByName("m_btnChangeDealer")) {
				this["m_btnChangeDealer"].IChangLang (strlang);
			}
			if (this.getChildByName("m_btnChangeBoot")) {
				this["m_btnChangeBoot"].IChangLang (strlang);
			}
		}
	}
}