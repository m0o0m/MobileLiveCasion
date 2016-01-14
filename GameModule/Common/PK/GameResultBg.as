package GameModule.Common.PK{

	import flash.display.MovieClip;
	import flash.geom.Point;

	/*
	 * 游戏结果背景
	*/
	public class GameResultBg extends MovieClip {

		/*
		 * 游戏结果背景
		 @ number 输赢索引 1庄赢 2闲赢 3和
		 @ point 位置
		*/
		public function GameResultBg (number:int,point:Point) {
			gotoAndStop (number);
			if (point) {
				x = point.x;
				y = point.y;
			}
			var gameResult:GameResult = new GameResult(number);
			if (gameResult) {
				addChild (gameResult);
			}
		}
	}
}