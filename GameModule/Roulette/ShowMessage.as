package {
	import flash.utils.setTimeout;
	import GameModule.Common.ShowGameMessage;

	public class ShowMessage extends ShowGameMessage {

		public function ShowMessage () {
			// constructor code
			super ();
		}
		override public function ShowWinMessage (type:int,num:String):void {
			this.visible = true;
			var str:String = GetWin(type,m_lang);
			if (str==null) {
				return;
			}
			this.gotoAndStop (type+2);
			if (this.getChildByName("resoult")) {
				this["resoult"].text = str + num;
				this["resoult"].mouseEnabled=false;
			}
			setTimeout (HideMc,m_showtime);//显示3秒后隐藏
		}

	}

}
include "../Common/GameMessage.as"