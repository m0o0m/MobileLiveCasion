package  HistoryRoad.MoreGame{
	import HistoryRoad.*;
	public class LobbyMorePearlTableRoulette extends RoadBaseTable{

		public function LobbyMorePearlTableRoulette() {
			_width = width-1.8;
			_height = height;
			_x=0;
			MovingDistance = 15.6;
			Initialize();
		}
		
		/*
		 * 显示轮盘珠盘路
		 @ number 最新结果
		*/
		public override function ShowRoad(number:int):void
		{
			RemoveAsk();
			var rpt:LobbyMorePearlViewRoulette=new LobbyMorePearlViewRoulette();
			rpt.RoadPosition(lastRoadView,number);
			lastRoadView = rpt;
			mcParent.addChild(rpt);
			MobileRoad();
		}
	}
	
}

