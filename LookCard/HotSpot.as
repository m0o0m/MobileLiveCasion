package {
	
	/*
	 * 触发翻牌事件位置
	*/
	import flash.display.MovieClip;
	import flash.display.StageAlign;
	public class HotSpot extends MovieClip {

		/*
		 * 实例化翻牌点，并确定位置
		 @ pw 牌的宽度
		 @ ph 牌的高度
		 @ cor 各个翻牌点对应的标记
		*/
		public function HotSpot(pw:Number,ph:Number,cor:String) {
			stop();
			//width=height=pw*0.5;
			gotoAndStop(cor);
			switch (cor) {
				case "TL" ://左上翻牌点
					x =0;
					y = 0;
					break;
				case "TR" ://右上翻牌点
					x = pw;
					y = 0;
					break;
				case "BL" ://坐下翻牌点
					x = 1;
					y = ph;
					break;
				case "BR" ://右下翻牌点
					x = pw;
					y = ph;
					break;
				case "T"://上中翻牌点
					x=pw/2;
					y=0;
					break;
				case "B"://下中翻牌点
					x=pw/2;
					y=ph;
					break;
				case "L"://左中翻牌点
					x=0;
					y=ph/2;
					break;
				case "R":
					x=pw;//有中翻牌点
					y=ph/2;
					break;
			}
		}
	}
}