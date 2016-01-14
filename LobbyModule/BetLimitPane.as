package {
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.geom.Matrix;
	import flash.display.GradientType;
	import flash.display.SpreadMethod;
	import IGameFrame.IChangLang;

	public class BetLimitPane extends MovieClip {
		public var _width:int = 893;
		public var _height:int = 105;
		public var itemHeight:int = 172;
		var btnList:Array = new Array();
		var m_lobbywindow:TBSLobbyWindow;
		var m_MoneyType:String;//货币类型
		var m_tableID:uint;
		var m_host:Boolean=false;
		var m_moreEnter:Boolean=false;
		var m_lookon:Boolean=false;
		
		public function BetLimitPane () {
			
		}
		public function SetParmar(lobbywindow:TBSLobbyWindow,tableID:uint,host:Boolean,more:Boolean,lookon:Boolean):void{
			m_lobbywindow=lobbywindow;
			m_tableID=tableID;
			m_host=host;
			m_moreEnter=more;
			m_lookon=lookon;
		}
		public function Destroy ():void {
			ClearLimit ();
		}
		public function HideBetLimit ():void {
			this.visible = false;
		}
		protected function ClearLimit ():void {
			var index:int = 0;
			while (index < btnList.length) {
				if (btnList[index]) {
					btnList[index].Destroy ();
					removeChild (btnList[index]);
					btnList[index] = null;
				}
				index++;
			}
		}
		public function SetBetLimit (limit:Array):void {
			ClearLimit ();
			if (limit == null || limit.length <= 0) {
				return;
			}
			//_height = itemHeight * limit.length;
			//DrawBackground ();

			var count:int = 0;
			var index:int = 0;
			var startpointY:Number=(976-(limit.length-1)*itemHeight+_height)/2;
			while (index < limit.length) {
				var btn:BetLimitItem = new BetLimitItem();
				btn.SetBetLimitPane (this);
				btn.SetBetLimit (limit[index][0], limit[index][1]);
				if (m_MoneyType) {
					btn.SetMoneyType (m_MoneyType);
				}
				btnList.push (btn);

				addChild (btn);
				btn.x = (1920-btn.width)/2;
				btn.y = count * itemHeight+startpointY;
				count++;
				index++;
			}
		}
		public function SelectLimit (limitID:int):void {
			if (m_lobbywindow) {
				m_lobbywindow.EnterGame(limitID,m_tableID,m_host,m_moreEnter,m_lookon);
			}
			HideBetLimit ();
		}
		public function SetMoneyType (moneyType:String):void {
			m_MoneyType = moneyType;
		}

	}
}