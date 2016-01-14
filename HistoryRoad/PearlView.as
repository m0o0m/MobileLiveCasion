package HistoryRoad
{
	
	/**
	 * 珠盘路 显示结果
	**/
	public class PearlView extends RoadPosView
	{

		protected var num:Number = 0;

		public function PearlView()
		{
			_width = 22;
			_height = 22;
			super();
			maxRow = 6;
			_x=2;
			_y=2;
		}
		
		/**
		 * 珠盘路定位
		 @ lastRPV 上一个珠盘对象 
		 @ number 珠盘图形对应的索引
		 @ arr 占位数组
		**/
		public override function RoadPosition(lastRPV:RoadPosView,number:int,arr:Array=null):void
		{
			gotoAndStop(number);
			if(this.getChildByName("lang")){
			this["lang"].gotoAndStop(m_lang);
			}
			var suite:int = 0;
			if (lastRPV!=null)
			{
				var lastPV = lastRPV as PearlView;
				num = lastPV.num + 1;
				suite = num;
			}
			var c:int=int(suite/maxRow);
			var r:int=int(suite%maxRow);
			_x = _width * c + c + _x;
			_y = _height * r + r + _y;
			x = _x;
			y = _y;
		}
	}
}