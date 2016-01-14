package HistoryRoad{
	import flash.text.TextFormat;
	import flash.text.TextField;

	/**
	 * 大路 显示结果
	**/
	public class BigView extends RoadPosView {

		protected var txtDraw:TextField = null;
		protected var _drawCount:int = 0;//和的个数

		public function BigView (number:int) {
			if(!number||number==0){
				return;
			}
			_x = 1.7;
			_y = 1.7;
			gotoAndStop (number);
			_width = 11.5;
			_height = 10.7;
		}

		//和的时候添加数字或者改变改变图形
		public function AddDrawResult ():void {
			_drawCount++;
			if ((_drawCount == 1)) {
				if ((lastNum == 1)) {
					gotoAndStop (3);
				} else {
					gotoAndStop (4);
				}
			} else {
				gotoAndStop (lastNum);

				if ((txtDraw == null)) {
					txtDraw = new TextField  ;
					txtDraw.x = -0.5;
					txtDraw.y = -2.25;
					addChild (txtDraw);
				}
				txtDraw.mouseEnabled=false;
				txtDraw.text = _drawCount.toString();
				var sformat:TextFormat = new TextFormat  ;
				sformat.size = 8;
				sformat.bold = true;
				sformat.color = 0x00FF00;
				txtDraw.setTextFormat (sformat);
			}
		}
	}
}