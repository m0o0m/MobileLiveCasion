package HistoryRoad{

	/**
	 * 大眼路 显示结果
	**/
	public class BigEyesView extends RoadPosView {
		
		/**
		 * 大眼路 显示图形
		 @ number 要显示图形索引，1表示红色，2表示蓝色
		**/
		public function BigEyesView (number:int) {
			if(!number||number==0){
				return;
			}
			gotoAndStop (number);
			_x = 1.85;
			_y = 1.35;
			width = height = _width = _height = 5.75;
		}
	}
}