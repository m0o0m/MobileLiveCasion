package HistoryRoad{

	/*
	 * 小路 显示列表
	*/
	public class SmallTable extends RoadBaseTable {

		public function SmallTable() {
			posViewName = "HistoryRoad.SmallView";
			_width = width;
			_height = height;
			_x = 0;
			_y = 0;
			MovingDistance = 13.5;
			Initialize();
			trace("SmallTable.width" + this.width);
		}
	}
}