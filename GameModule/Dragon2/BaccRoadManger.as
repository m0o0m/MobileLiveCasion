package {
	
	import HistoryRoad.BaccaratHistoryResultManger;
	import flash.geom.Point;
	
	public class BaccRoadManger extends BaccaratHistoryResultManger {

		public function BaccRoadManger() {
			strPearlTable="HistoryRoad.PearlTable";
			strBigTable="HistoryRoad.BigTable";
			strBigEyesTable="HistoryRoad.BigEyesTable";
			strSmallTable="HistoryRoad.SmallTable";
			strSmallForcedTablele="HistoryRoad.SmallForcedTable";
			strRoadInfo="HistoryRoad.RoadInfo";
			roadPos = [new Point(4.3,30.3),new Point(356.3,30.3),new Point(357.3,89),new Point(357.3,118.90),new Point(563.3,118.90),new Point(773.05,30.3)];
			super ();
			x=144.35;
			y=638.75;
		}

	}
}