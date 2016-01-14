package GameModule.Common.InfoPane {
	import flash.display.MovieClip;

	public class InfoPaneTopPane extends MovieClip {
		var thisWidth:Number = 0; 
		public function InfoPaneTopPane(topHeight:int, _width:int) {
			thisWidth = this.width;
			
			var centerHeight:int = topHeight - 15;
			if(centerHeight > 0) {
				this["m_center"].scaleY = centerHeight;
			}
			
			if(_width > 0 && _width != thisWidth) {
				this["m_center"].scaleX = _width/thisWidth;
			}
		}
		public function Destroy():void {
		}
	}
}