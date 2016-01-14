package HistoryRoad
{
	import flash.utils.getDefinitionByName;
	
	/**
	 * 珠盘路结果列表
	**/
	public class PearlTable extends RoadBaseTable
	{

		public function PearlTable()
		{
			posViewName = "HistoryRoad.PearlViewBaccarat";
			_width = width;
			_height = height;
			_x=0;
			_y=0;
			MovingDistance = 50;
			Initialize();
		}
		
		/*
		 * 显示珠盘路
		 @ number 要显示的结果索引
		*/
		public override function ShowRoad(number:int):void
		{
			if(!number||number==0){
				return;
			}
			RemoveAsk();
			var roadClass:Class = getDefinitionByName(posViewName) as Class;
			var pt:*=new roadClass();
			pt.SetLang(m_lang);
			pt.RoadPosition(lastRoadView,number);
			lastRoadView = pt;
			mcParent.addChild(pt);
			MobileRoad();
		}
		
		/*
		 * 显示珠盘路问路
		 @ number 要显示的结果索引 1表示庄问路 2表示闲问路
		*/
		public override function ShowAsk(number:Number):void
		{
			if(!number||number==0){
				return;
			}
			RemoveAsk();
			var roadClass:Class = getDefinitionByName(posViewName) as Class;
			askRoad=new roadClass();
			askRoad.SetLang(m_lang);
			askRoad.RoadPosition(lastRoadView,number);
			mcParent.addChild(askRoad);
			MobileRoad();
		}
	}
}