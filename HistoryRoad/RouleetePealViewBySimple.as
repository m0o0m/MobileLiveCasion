package  HistoryRoad{
	public class RouleetePealViewBySimple extends RoadPosView{
		protected var num:Number = 0;
		public function RouleetePealViewBySimple() {
			// constructor code
			maxRow = 5;
			_x = 1;
			_y = 1;
			_width = 37;
			_height = 36;
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
				var lastPV = lastRPV as RouleetePealViewBySimple;
				num = lastPV.num + 1;
				suite = num;
			}
			var c:int=int(suite/maxRow);
			var r:int=int(suite%maxRow);
			x = _x + _width * c;
			y = _y + _height * r;
			if(this.getChildByName("rouleeteResult")){
			this["rouleeteResult"].text = number.toString();
			}
		}
	}
	
}
