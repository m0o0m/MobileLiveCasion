package HistoryRoad {
	
	import HistoryRoad.BaccaratHistoryResultManger;
	import flash.geom.Point;
	
	public class BaccaratHistoryResultByGame extends BaccaratHistoryResultManger {

		public function BaccaratHistoryResultByGame() {
			strPearlTable="HistoryRoad.PearlTable";
			strBigTable="HistoryRoad.BigTable";
			strBigEyesTable="";
			strSmallTable="";
			strSmallForcedTablele="";
			strRoadInfo="";
			/*strBigEyesTable="HistoryRoad.BigEyesTable";
			strSmallTable="HistoryRoad.SmallTable";
			strSmallForcedTablele="HistoryRoad.SmallForcedTable";
			strRoadInfo="HistoryRoad.RoadInfo";*/
			roadPos = [new Point(0,0),new Point(0,274)];
			super ();
		}

	}
}