package GameModule.Common {
	import flash.display.MovieClip;
	import flash.geom.Point;
	import flash.display.Shape
	
	public class BetBaseStatus extends MovieClip {
		
		protected var betTimer:BetTimer=null;//倒计时
		protected var betTimerPos:Point=new Point(170.6,2.95);//倒计时位置
		
		protected var betSettlement:BetSettlement=null;//结算中
		protected var betSettlementPos:Point=new Point(60,-2.8);//结算中位置
		protected var bgwidth:int=417//背景宽度
		protected var bgheight:int=84//背景高度
		
		public function BetBaseStatus(bt:BetTimer) {
			betSettlement=new BetSettlement();
			betTimer=bt;
			AddStatus();
			AddStatusBg()
			BetTimerVisible(false);
			SettleVisible(false);
		}
		public function Destroy():void {
			if(betTimer) {
				betTimer.Destroy();
				removeChild(betTimer);
				betTimer = null;
			}
			if(betSettlement) {
				removeChild(betSettlement);
				betSettlement = null;
			}
		}
		public function AddStatusBg():void{
			var _color:int=0x000000;
			var _alpha:Number=0.7;
			graphics.beginFill(_color,_alpha);
			graphics.drawRect(this.x,this.y,bgwidth,bgheight);
			graphics.endFill();
		}
		/*
		 * 添加数据到背景上
		*/
		protected function AddStatus(){
			if(betTimer){
				addChild(betTimer);
				betTimer.x=betTimerPos.x;
				betTimer.y=betTimerPos.y;
			}
			if(betSettlement){
				addChild(betSettlement);
				betSettlement.x=betSettlementPos.x;
				betSettlement.y=betSettlementPos.y;
			}
		}
		
		/*
		 * 倒计时显示隐藏
		 @ betTimerStatus 倒计时显示状态
		*/
		public function BetTimerVisible(betTimerStatus:Boolean){
			betTimer.visible=betTimerStatus;
		}
		
		/*
		 * 结算显示隐藏
		 @ betTimerStatus 结算状态
		*/
		public function SettleVisible(setStatus:Boolean){
			betSettlement.visible=setStatus;
		}
	}
}