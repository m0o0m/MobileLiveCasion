package  HistoryRoad{
	import flash.geom.Point;
	
	public class RoulettetHistoryResultBySimple extends RouleeteHistoryResultManger {

		public function RoulettetHistoryResultBySimple() {
			// constructor code
			strPealTbale = "HistoryRoad.RouleetePealTableBySimple";
			strOtherTable = "";
			strHCTable = "";
			strBtnRoadTable = "";
			roadPos = [new Point(0,-3.5),new Point(4,0),new Point(4,0),new Point(4,0),new Point(40,0),new Point(3,125)];
			
			super();
		}

	}
	
}
