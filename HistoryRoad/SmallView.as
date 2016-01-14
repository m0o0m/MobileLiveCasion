package HistoryRoad{

	/*
	 * 小路 显示结果
	*/
	public class SmallView extends RoadPosView {

		public function SmallView(number:int) {
			if (! number || number == 0) {
				return;
			}
			gotoAndStop(number);
			_x = 1;
			_y = 0.6;
			width = _width = 5.75;
			height = _height = 5.75;
		}
	}
}