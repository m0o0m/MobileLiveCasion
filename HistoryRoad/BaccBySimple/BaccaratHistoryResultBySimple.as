package  HistoryRoad.BaccBySimple{
	import HistoryRoad.BaccaratHistoryResultManger;
	import flash.geom.Point;
	public class BaccaratHistoryResultBySimple extends BaccaratHistoryResultManger {

		public function BaccaratHistoryResultBySimple() {
			// constructor code
			strPearlTable="HistoryRoad.BaccBySimple.PearlTableBySimple";
			strBigTable="HistoryRoad.BaccBySimple.BigTableBySimple";
			strBigEyesTable="HistoryRoad.BaccBySimple.BigEyesTableBySimple";
			strSmallTable="HistoryRoad.BaccBySimple.SmallTableBySimple";
			strSmallForcedTablele="HistoryRoad.BaccBySimple.SmallForcedTableBySimple";
			strRoadInfo="";
			roadPos = [new Point(0,0),new Point(367,0),new Point(367,97),new Point(367,139),new Point(543.5,139)];
			super ();
		}

	}
	
}
