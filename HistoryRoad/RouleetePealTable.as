package HistoryRoad{

	/*
	 * 轮盘珠盘路列表
	*/
	public class RouleetePealTable extends RoadBaseTable {


		public function RouleetePealTable() {
			_width = width;
			_height = height;
			posViewName = "HistoryRoad.RouleetePealViewByLobby";
			_x = 0;
			MovingDistance = 28.7;
			Initialize();
		}

		/*
		 * 显示轮盘珠盘路
		 @ number 最新结果
		*/
		public override function ShowRoad(number:int):void {
			RemoveAsk();
			var rpt:RouleetePealView=new RouleetePealView();
			rpt.SetLang(m_lang);
			rpt.RoadPosition(lastRoadView,number);
			lastRoadView = rpt;
			mcParent.addChild(rpt);
			MobileRoad();
		}
	}

}