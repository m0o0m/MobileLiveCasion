package  HistoryRoad.DragonBySimple{
	import HistoryRoad.DragonHistoryResultManager;
	import flash.geom.Point;
	public class DragonHistoryResultManagerBySimple extends DragonHistoryResultManager{

		public function DragonHistoryResultManagerBySimple() {
			// constructor code
			strPearlTable="HistoryRoad.DragonBySimple.PearlTableDragonBySimple";
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
