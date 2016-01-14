package  {
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	public class DragonTigerTablePane extends TablePane {
		public function DragonTigerTablePane() {
			super();
			m_strTableInfo = GetTableInfo("Drti","ch");
		}
		override protected function InitHistoryResult ():void {
			hrm = m_roomPane.GetHistoryRoad("DragonHistoryResult");
			if(hrm != null) {
				hrm.SetLang(lang);
				var hrmMc:MovieClip = hrm.GetMovieClip();
				hrmMc.mouseChildren=false;
				hrmMc.mouseEnabled=false;
				addChild (hrmMc);
				hrmMc.x = 59;
				hrmMc.y = 162;
			}
		}
		
		public override function IChangLang (strLang:String):void {
			super.IChangLang(strLang);
			m_strTableInfo = GetTableInfo("Drti",lang);
			if(m_historyroad){
				ShowRoadInfo(m_historyroad);
			}
		}
	}
}
include "./LobbyText.as"