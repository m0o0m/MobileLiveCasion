package HistoryRoad {
	import flash.geom.Point;
	import HistoryRoad.*;
	public class BaccaratHistoryResult extends BaccaratHistoryResultManger {

		public function BaccaratHistoryResult() {
			strPearlTable="HistoryRoad.LobbyPearlTable";
			strBigTable=null;
			strBigEyesTable=null;
			strSmallTable=null;
			strSmallForcedTablele=null;
			strRoadInfo="";
			roadPos=[new Point(0,0),new Point(186,0),new Point(186,54),new Point(186,82),new Point(336,82)];
			super();
			//roadView=["HistoryRoad.PearlTable","HistoryRoad.LobbyBigTable","HistoryRoad.BigEyesTable","HistoryRoad.SmallTable","HistoryRoad.SmallForcedTable"];
			
		}
	}
}