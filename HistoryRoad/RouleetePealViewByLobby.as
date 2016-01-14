package HistoryRoad{

	/*
	 * 轮盘珠盘路 显示结果
	*/
	public class RouleetePealViewByLobby extends RoadPosView {
		protected var num:Number = 0;
		public function RouleetePealViewByLobby () {
			_width =28.4;
			_height =29;
			maxRow = 6;
			_x=1.8;
			_y=3.5;
		}

		/**
		 * 轮盘珠盘路定位
		 @ lastRPV 上一个珠盘对象 
		 @ number 最新结果
		 @ arr 占位数组
		 **/
		public override function RoadPosition (lastRPV:RoadPosView,number:int,arr:Array=null):void {
			SetRouleeteAtrrribute ();
			if(roadResult == null || roadResult[number] == null) {
				number = 0;
			}
			var cor:int = roadResult[number][0];
			if (cor==0) {
				return;
			}
			gotoAndStop (cor);
			var suite:int = 0;
			if (lastRPV!=null) {
				var lastPV = lastRPV as RouleetePealViewByLobby;
				num = lastPV.num + 1;
				suite = num;
			}
			var c:int=int(suite/maxRow);
			var r:int=int(suite%maxRow);
			
			x = _x + _width * c;
			y = _y + _height * r;
			this.rouleeteResult.text = number.toString();
		}
	}
}