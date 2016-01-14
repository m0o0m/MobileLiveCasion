package HistoryRoad
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	/**
	 * 移动按钮
	**/
	public class BtnMobile extends MovieClip
	{
		/**
		 * 实例化移动按钮并加上相应事件
		 @ _w 父对象宽度
		 @ _h 父对象高度
		 @ fun 事件执行函数
		 @ isLeft 所在位置 true表示在左边 false表示在右边
		**/
		public function BtnMobile(_w:Number,_h:Number,fun:Function,isLeft:Boolean=true)
		{
			if(!_w||!_h||fun==null){
				return;
			}
			var num:Number = 1;
			num = isLeft ? 2:1;
			if (isLeft)
			{
				num = 2;
				_w = 0;
			}
			else
			{
				num = 1;
				_w = _w - width;
			}
			gotoAndStop(num);
			x = _w;
			y = (_h - height) / 2;
			alpha = 0;
			addEventListener(MouseEvent.CLICK,fun);
			addEventListener(MouseEvent.MOUSE_OUT,fun);
			addEventListener(MouseEvent.MOUSE_OVER,fun);
		}
	}
}