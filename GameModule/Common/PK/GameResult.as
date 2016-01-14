package GameModule.Common.PK{

	import flash.display.MovieClip;
	import flash.geom.Point;

	/*
	 * 游戏结果语言
	*/
	public class GameResult extends MovieClip {

		var point:Point = new Point(12.5,2.25);//位置

		/*
		 * 游戏结果语言
		 @ 结果索引
		*/
		public function GameResult (number:int) {
			gotoAndStop (number);
			x = point.x;
			y = point.y;
		}
	}
}