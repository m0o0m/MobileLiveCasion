package GameModule.Common{
	import flash.display.MovieClip;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.geom.Point;

	public class GameStausView extends MovieClip {
		protected var m_width:int = 159.6;//背景宽度
		protected var m_height:int = 80;//背景高度
		protected var statustext:TextField;//显示文本
		protected var textfor:TextFormat;//文本样式
		protected var textPoint:Point = new Point(0,10);//文本位置
		
		public function GameStausView () {
			// constructor code
			AddStatusBg ();
		}
		public function Destroy():void{
			if(statustext) {
				removeChild(statustext);
				statustext = null;
			}
			graphics.clear()
		}
		public function SetGameStatus (status:int):void {
			switch (status) {
				case 0 :
					if (statustext==null) {
						statustext=new TextField();
						addChild (statustext);
						statustext.x = textPoint.x;
						statustext.y = textPoint.y;
						statustext.width = m_width;
						statustext.height = m_height;
						statustext.text = "结算中";
						statustext.visible = true;
						statustext.selectable=false;
						statustext.setTextFormat (SetTextformat());
					} else {
						statustext.visible = true;
					}
					break;
				case 1 :
				  if(statustext){
					statustext.visible = false;
				  }
					break;
			}
		}
		//添加背景
		public function AddStatusBg ():void {
			var _color:int = 0x000000;
			var _alpha:Number = 0.7;
			graphics.beginFill (_color,_alpha);
			graphics.drawRect (this.x,this.y,m_width,m_height);
			graphics.endFill ();
		}
		//设置样式
		public function SetTextformat ():TextFormat {
			textfor=new TextFormat();
			textfor.color = 0xcc9900;
			textfor.align = "center";
			textfor.size = 50;
			textfor.bold = true;
			return textfor;
		}
	}
}