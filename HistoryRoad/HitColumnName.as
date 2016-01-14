package HistoryRoad {
	
	import flash.display.MovieClip;
	
	/*
	 * 打列头
	*/
	public class HitColumnName extends MovieClip {
		
		
		public function HitColumnName() {
			x=19.5;
			y=58;
		}
		public function SetLang(strlang:String):void{
			this["lang"].gotoAndStop(strlang);
		}
	}
	
}
