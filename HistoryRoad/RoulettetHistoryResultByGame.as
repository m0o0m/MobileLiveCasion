package  HistoryRoad{
	import flash.geom.Point;
	public class RoulettetHistoryResultByGame extends RouleeteHistoryResultManger {

		public function RoulettetHistoryResultByGame() {
			// constructor code
			// constructor code
			strPealTbale = "HistoryRoad.RouleetePealTable";
			strOtherTable = "HistoryRoad.RouleeteOtherTable";
			strHCTable = "HistoryRoad.HCTable";
			//strBtnRoadTable = "HistoryRoad.RouleeteBtnRoadTable";
			strBtnRoadTable = "";
			roadPos = [new Point(0,0),new Point(0,400),new Point(0,600),new Point(54.6,200)];
			super();
		}

	}
	
}
