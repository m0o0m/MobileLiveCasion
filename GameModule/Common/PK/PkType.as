package GameModule.Common.PK{

	import flash.display.MovieClip;
	import flash.geom.Point;

	/*
	 * 庄闲类型
	*/
	public class PkType extends MovieClip {

		/*
		 * 庄闲类型
		 @ number 庄闲索引 1庄 2闲
		 @ point 位置
		*/
		public function PkType (number:int,point:Point) {
			gotoAndStop (number);
			if (point) {
				x = point.x;
				y = point.y;
			}
		}
		public function SetLang(strlang:String):void{
			this["type"].gotoAndStop(strlang);
		}
	}

}