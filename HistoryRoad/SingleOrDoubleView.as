package HistoryRoad{

	/*
	 * 轮盘单双 显示结果
	*/
	public class SingleOrDoubleView extends RoadPosView {

		/*
		 * 轮盘 单双显示结果
		 @ number 结果索引
		*/
		public function SingleOrDoubleView(number:int) {
			SetRouleeteAtrrribute();
			if (roadResult==null) {
				return;
			}
			gotoAndStop(roadResult[number][4]);
			_x = 2;
			_y = 1;
			maxRow = 7;
			_width = 27.7;
			_height = 27.2;
		}

		/*
		 * 定位
		 @ rpv 上一个显示结果对象
		 @ number 轮盘结果
		 @ arr 数组填充情况
		*/
		public override function RoadPosition(rpv:RoadPosView,number:int,arr:Array=null):void {
			lastNum = roadResult[number][4];
			if (rpv==null) {//最后一个值为空时，位置为默认位置
				x = _x;
				y = _y;
				l_startx = _x;
			} else {
				if (rpv.lastNum != roadResult[number][4]) {
					x = rpv.l_startx + _width + 1;
					y = _y;
					_row = 0;
					l_startx = x;
					_column = rpv.l_startColumn + 1;
					l_startColumn = rpv.l_startColumn + 1;
				} else {
					l_startColumn = rpv.l_startColumn;
					l_startx = rpv.l_startx;
					if (rpv.Row + 1 < maxRow && NonEmpty(arr[rpv.Column][rpv.Row + 1])) {
						x = rpv.x;
						y = _height + rpv.y + 1;
						_row = rpv.Row + 1;
						_column = rpv.Column;
					} else {
						x = rpv.x + _width + 1;
						y = rpv.y;
						_row = rpv.Row;
						_column = rpv.Column + 1;
					}
				}
			}
		}
		public override  function SetLang(strlang:String):void{
			super.SetLang(strlang);
			if(this.getChildByName("lang")){
			this["lang"].gotoAndStop(m_lang);
			}
		}
	}

}