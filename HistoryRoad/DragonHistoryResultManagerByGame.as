package  HistoryRoad {
	import HistoryRoad.DragonHistoryResultManager;
	import flash.geom.Point;
	
	public class DragonHistoryResultManagerByGame extends DragonHistoryResultManager{

		public function DragonHistoryResultManagerByGame() {
			strPearlTable="HistoryRoad.PearlTableDragon";
			strBigTable="HistoryRoad.BigTable";
			strBigEyesTable="";
			strSmallTable="";
			strSmallForcedTablele="";
			strRoadInfo="";
			/*strBigEyesTable="HistoryRoad.BigEyesTable";
			strSmallTable="HistoryRoad.SmallTable";
			strSmallForcedTablele="HistoryRoad.SmallForcedTable";
			strRoadInfo="HistoryRoad.RoadInfoDragon";*/
			roadPos = [new Point(0,0),new Point(0,274)];
			super ();
		}

	}
	
}
