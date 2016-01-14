package HistoryRoad{

	/**
	 * 大眼路 结果列表
	**/
	public class BigEyesTable extends RoadBaseTable {

		public function BigEyesTable () {
			posViewName = "HistoryRoad.BigEyesView";
			_width = width;
			_height = height;
			_x=0;
			_y=0;
			MovingDistance =13.5;
			Initialize ();
		}
	}
}