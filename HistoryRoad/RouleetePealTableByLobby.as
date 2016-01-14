package HistoryRoad {
	/**
	 * 轮盘珠盘路列表
	 */
	public class RouleetePealTableByLobby extends RoadBaseTable{
		
		
		public function RouleetePealTableByLobby() {
			_width = width;
			_height = height;
			MovingDistance = 28.5;
			Initialize();
		}
		
		/*
		 * 显示轮盘珠盘路
		 @ number 最新结果
		*/
		public override function ShowRoad(number:int):void
		{
			RemoveAsk();
			var rpt:RouleetePealViewByLobby=new RouleetePealViewByLobby();
			rpt.SetLang(m_lang);
			rpt.RoadPosition(lastRoadView,number);
			lastRoadView = rpt;
			mcParent.addChild(rpt);
			MobileRoad();
		}
	}
	
}
