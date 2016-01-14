package HistoryRoad {
	import flash.geom.Point;
	
	public class RouleeteHistoryResult extends RouleeteHistoryResultManger {

		public function RouleeteHistoryResult() {
			strPealTbale = "HistoryRoad.RouleetePealTableByLobby";
			strOtherTable = "";
			strHCTable = "";
			strBtnRoadTable = "";
			
			roadPos = [new Point(0,0),new Point(290.15,30.35),new Point(290.15,30.35),new Point(290.15,30.35),new Point(330.55,30.35),new Point(807.4,30.35)];
			super ();
		}
	}
}