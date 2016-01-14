package GameModule.Common.InfoPane{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;

	import caurina.transitions.Tweener;

	public class InfoPaneBottomPane extends MovieClip {
		protected var m_minMode:Boolean = false;
		protected var m_maxHeight:int = 0;
		protected var m_IsShowBottom:Boolean;
		protected var m_InfoPane:InfoPane;
		var thisWidth:Number = 0;
		protected var m_button:MovieClip;
		protected var m_bg:MovieClip;

		public function InfoPaneBottomPane (minHeight:int,maxHeight:int,expression:Boolean,_width:int) {
			thisWidth = this.width;
			m_maxHeight=maxHeight;
			if (this.getChildByName("mc_bg")) {
				m_bg = this["mc_bg"];
				m_bg.height=maxHeight;
				m_bg.alpha=0.5;
			}
			if (this.getChildByName("mc_button")) {
				m_button = this["mc_button"];
				m_button.buttonMode = true;
				m_button.addEventListener (MouseEvent.CLICK,OnExpansion);
			}
			if ((_width > 0) && _width != thisWidth) {
				if(m_bg){
					m_bg.scaleX = _width / thisWidth;
				}
				if(m_button){
					m_button.scaleX = _width / thisWidth;
				}
			}
			if(expression==false){
				MovePane(false);
			}
		}
		public function Destroy ():void {
			m_button.removeEventListener (MouseEvent.CLICK,OnExpansion);
			var len:int=this.numChildren-1;
			for(var i:int=0;i<len;i++){
				removeChildAt(i);
			}
		}
		public function OnExpansion (event:MouseEvent):void {
			MovePane(m_minMode);
		}
		public function MovePane(bool:Boolean):void{
			if ((bool)) {//开始移动
				//上移
				Tweener.addTween (this,{x:0,y:0,time:1,onComplete:MoveComplete,onCompleteParams:[false]});
			} else {
				//下移
				Tweener.addTween (this,{x:0,y:m_maxHeight,time:1,onComplete:MoveComplete,onCompleteParams:[true]});
			}
		}
		public function MoveComplete (status:Boolean):void {
			m_minMode = status;
			
		}
		/*public function SetInfoPane (infoPane:InfoPane):void {
			if (infoPane) {
				m_InfoPane = infoPane;
			}
		}*/

	}
}