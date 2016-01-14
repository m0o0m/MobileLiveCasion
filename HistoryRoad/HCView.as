package HistoryRoad {
	
	/*
	 * 轮盘 打列显示结果
	*/
	public class HCView extends RoadPosView {
		
		/*
		 * 打列 结果
		 @ lastRPV 最后一个结果图形对象
		 @ number 最新结果
		 @ type 显示类型 1 打； 2 列； 3 零
		*/
		public function HCView(lastHCV:HCView,number:int,type:int) {
			_width=28.7;
			_height=27.8;
			_x=2;
			_y=2;
			SetRouleeteAtrrribute();
			if (lastHCV!=null)
			{
				x=lastHCV.x+_width;
			}else{
				x = _x;
			}
			if(type==1){
				gotoAndStop(1);
				y=_height*(roadResult[number][2]-1)+_y;
			}else if(type==2){
				gotoAndStop(2);
				y=_height*(roadResult[number][3]+3)+_y;
			}else{
				gotoAndStop(3);
				y=_height*3+_y;
			}
		}
		
	}
	
}
