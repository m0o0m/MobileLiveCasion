package {
	import flash.display.MovieClip;

	public class RouletteTablePane extends TablePane {
		public function RouletteTablePane() {
			// constructor code
			super();
			m_strTableInfo = GetTableInfo("Roul","ch");
		}
		override protected function InitHistoryResult():void {
			hrm = m_roomPane.GetHistoryRoad("RouleeteHistoryResult");
			if (hrm != null) {
				hrm.SetLang(lang);
				var hrmMc:MovieClip = hrm.GetMovieClip();
				hrmMc.mouseChildren=false;
				hrmMc.mouseEnabled=false;
				addChild(hrmMc);
				hrmMc.x = 59;
				hrmMc.y = 162;
			}
		}
		public override function IChangLang (strLang:String):void {
			super.IChangLang(strLang);
			m_strTableInfo = GetTableInfo("Roul",lang);
			if(m_historyroad){
				ShowRoadInfo(m_historyroad);
			}
		}
	}
}
include "./LobbyText.as"