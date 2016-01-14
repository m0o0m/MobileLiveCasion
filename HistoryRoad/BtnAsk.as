package HistoryRoad{

	import flash.display.MovieClip;
	import flash.events.MouseEvent;

	/**
	 * 问路按钮
	**/
	public class BtnAsk extends MovieClip {

		public function BtnAsk (str:String,fun:Function) {
			x = 0.85;
			if ((str == "blank")) {
				y = 87.75;
			} else {
				y = 102.90;
			}
			gotoAndStop (1);
			buttonMode = true;
			alpha = 0;
			addEventListener (MouseEvent.CLICK,fun);
			addEventListener (MouseEvent.MOUSE_OUT,fun);
			addEventListener (MouseEvent.MOUSE_OVER,fun);
		}
	}
}