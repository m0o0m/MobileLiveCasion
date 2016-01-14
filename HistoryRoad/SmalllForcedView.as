package HistoryRoad{

	/*
	 * 小强路 显示结果
	*/
	public class SmalllForcedView extends RoadPosView {


		public function SmalllForcedView(number:Number) {
			if (! number || number == 0) {
				return;
			}
			gotoAndStop(number);
			_x = 1;
			_y = 0.6;
			width = height = _width = _height = 5.75;
		}
	}

}