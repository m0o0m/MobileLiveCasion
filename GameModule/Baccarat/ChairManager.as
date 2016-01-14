package {

	import flash.display.MovieClip;

	import GameModule.Common.ChairIDView;
	public class ChairManager extends MovieClip {


		public function ChairManager () {
			x = 169.50;
			y = 686;
		}
		public function Destroy ():void {
			var index:int = this.numChildren;
			while (index > 0) {
				removeChildAt (0);
				index--;
			}
		}
	}
}