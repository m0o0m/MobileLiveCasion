package {
	import flash.display.MovieClip;
	import flash.events.MouseEvent;

	public class BetLimitItem extends MovieClip {
		var m_LimitID:int = 0;//限额编号
		var m_BetLimitPane:BetLimitPane;
		var m_MoneyType:String;//货币类型
		var m_limitText:String;//限额
		public var _width:int = 265;
		public var _height:int = 29;
		public function BetLimitItem () {
			this.buttonMode = true;
			if (this.getChildByName("m_txtLimit")) {
				this["m_txtLimit"].mouseEnabled = false;
			}
			if(this.getChildByName("bg_item")){
				this["bg_item"].stop();
			}
			this.addEventListener (MouseEvent.CLICK, OnSelectLimit);
			this.addEventListener (MouseEvent.MOUSE_OVER, OnMoveOver);
			this.addEventListener (MouseEvent.MOUSE_OUT, OnMoveOut);
		}
		public function Destroy ():void {
			this.removeEventListener (MouseEvent.CLICK, OnSelectLimit);
			this.removeEventListener (MouseEvent.MOUSE_OVER, OnMoveOver);
			this.removeEventListener (MouseEvent.MOUSE_OUT, OnMoveOut);
		}
		public function SetBetLimitPane (limitPane:BetLimitPane):void {
			m_BetLimitPane = limitPane;
		}
		public function SetBetLimit (limitID:int, limitText:String):void {
			m_LimitID = limitID;
			m_limitText=limitText;
			if (this.getChildByName("m_txtLimit") && m_MoneyType) {
				this["m_txtLimit"].text =m_MoneyType+" $ "+m_limitText;
			}
		}
		private function OnSelectLimit (event:MouseEvent):void {
			m_BetLimitPane.SelectLimit (m_LimitID);
		}
		private function OnMoveOver (event:MouseEvent):void {
			if(this.getChildByName("bg_item")){
				this["bg_item"].gotoAndStop(2);
			}
		}
		private function OnMoveOut (event:MouseEvent):void {
			if(this.getChildByName("bg_item")){
				this["bg_item"].gotoAndStop(1);
			}
		}
		public function SetMoneyType (moneyType:String):void {
			if (moneyType) {
				m_MoneyType=moneyType;
				if (this.getChildByName("m_txtLimit") && m_limitText) {
					this["m_txtLimit"].text =m_MoneyType+" $ "+m_limitText;
				}
			}
		}
	}
}