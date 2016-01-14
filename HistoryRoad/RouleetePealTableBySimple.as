package  HistoryRoad{
	
	public class RouleetePealTableBySimple extends RoadBaseTable{

		public function RouleetePealTableBySimple() {
			// constructor code
			_width = width;
			_height = height;
			posViewName = "HistoryRoad.RouleetePealViewBySimple";
			_x = 0;
			MovingDistance = 40;
			Initialize();
		}
		/*
		 * 显示轮盘珠盘路
		 @ number 最新结果
		*/
		public override function ShowRoad(number:int):void {
			RemoveAsk();
			var rpt:RouleetePealViewBySimple=new RouleetePealViewBySimple();
			rpt.SetLang(m_lang);
			rpt.RoadPosition(lastRoadView,number);
			lastRoadView = rpt;
			mcParent.addChild(rpt);
			MobileRoad();
		}

	}
	
}
