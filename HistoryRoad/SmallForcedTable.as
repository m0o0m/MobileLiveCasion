package HistoryRoad
{

	/*
	 * 小强路 显示列表
	*/
	public class SmallForcedTable extends RoadBaseTable
	{

		public function SmallForcedTable()
		{
			posViewName = "HistoryRoad.SmalllForcedView";
			_width = width;
			_height = height;
			_x=0;
			_y=0;
			MovingDistance = 13.5;
			Initialize();
			trace("SmallForcedTable.width" + this.width);
		}
	}
}