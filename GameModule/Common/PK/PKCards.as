package GameModule.Common.PK{

	import flash.display.MovieClip;
	import flash.geom.Point;

	/*
	 * 所有牌
	*/
	public class PKCards extends MovieClip {

		protected var _rotationIndex:int = 2;//要旋转牌的索引
		protected var _number:int;
		protected var _width = 68.2;//牌宽
		protected var _height = 101.85;//牌高
		protected var _rotation = 90;//旋转度数
		//protected var m_lang:String;

		public function PKCards () {
		}
		public function GetCardNumber ():int {
			return _number;
		}
		/*
		 * 显示扑克
		 @ number 扑克索引
		 @ point 扑克位置
		 @ index 第几张牌
		*/
		public function ShowPkInfo (number:int, point:Point, index:int,host:Boolean):void {
			if (index > _rotationIndex || _rotationIndex < 0) {
				index = 1;
			}
			if (number == -1) {
				gotoAndStop("cardback");
				if(this.getChildByName("click")){
					this["click"].visible=host;
					this["click"].mouseEnabled=false;
				}
			} else {
				gotoAndStop (number);
			}
			if(rotation != _rotation) {
				width = _width;
				height = _height;
				if (point) {
					x = point.x;
					y = point.y;
				}
				if (index==_rotationIndex) {
					rotation = _rotation;
				}
			}
		}
		/*public function SetLang(strlang:String):void{
			m_lang=strlang;
		}*/

	}
}