package {
	import flash.display.MovieClip;
	import flash.utils.setTimeout;
	import flash.text.TextField;

	public class ShowGameResoult extends MovieClip {
		protected var m_resoultlist:Array = null;
		protected var m_lang:String;//当前语言
		//@m_resoult设置1-36的数字类型[[红2黑1，大1小2，单1双2，打1-2-3]]
		protected var m_resoult:Array=[[2,2,1,1],[1,2,2,1],[2,2,1,1],//1-3
		 [1,2,2,1],[2,2,1,1],[1,2,2,1],//4-6
		 [2,2,1,1],[1,2,2,1],[2,2,1,1],//7-9
		 [1,2,2,1],[1,2,1,1],[2,2,2,1],//10-12
		 [1,2,1,2],[2,2,2,2],[1,2,1,2],//13-15
		 [2,2,2,2],[1,2,1,2],[2,2,2,2],//16-18
		 [2,1,1,2],[1,1,2,2],[2,1,1,2],//19-21
		 [1,1,2,2],[2,1,1,2],[1,1,2,2],//22-24
		 [2,1,1,3],[1,1,2,3],[2,1,1,3],//25-27
		 [1,1,2,3],[1,1,1,3],[2,1,2,3],//28-30
		 [1,1,1,3],[2,1,2,3],[1,1,1,3],//31-33
		 [2,1,2,3],[1,1,1,3],[2,1,2,3]//34-36
		];
		public function ShowGameResoult() {
			// constructor code
			this.visible = false;
		}
		public function ShowResoult(res:String):void {
			if(res=="" ||res==null){
				return;
			}
			if(Number(res)>36){
				return;
			}
			m_resoultlist = GetResoultList(m_lang);
			var resoult:Number = Number(res);
			this.visible = true;
			this.mouseEnabled=false;
			this.mouseChildren=false;
			if (resoult==0) {
				if(this.getChildByName("num")){
					this["num"]["bg"].gotoAndStop(3);
					this["num"]["numtext"].text = resoult.toString();
				}
				setTimeout(HideMc,5000);
				return;
			}
			switch (m_resoult[resoult-1][0]) {
				case 1 :
					if(this.getChildByName("num")){
						this["num"]["bg"].gotoAndStop(2);
						this["num"]["numtext"].text = resoult.toString();
					}
					break;
				case 2 :
					if(this.getChildByName("num")){
						this["num"]["bg"].gotoAndStop(1);
						this["num"]["numtext"].text = resoult.toString();
					}
					break;
					default:
					break;
			}
			setTimeout(HideMc,5000);
		}
		protected function HideMc() {
			this.visible = false;
		}
		public function SetLang(strlang:String):void{
			m_lang=strlang;
		}
	}
}
include "ResoultMessage.as"