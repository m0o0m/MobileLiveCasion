package GameModule.Common{
	import flash.display.MovieClip;
	import flash.utils.Dictionary;
	import CommandProtocol.*;
	import Common.NumberFormat;
	
	public class BetInfo extends MovieClip {
		protected var m_memberCount:Array;//存储下注人数
		protected var m_betCount:Array;//存储下注金额
		protected var m_betInfo:Dictionary;//显示文本
		
		public function BetInfo () {
		}
		public function ResetView():void {
			if(m_betInfo && m_betCount && m_memberCount) {
				var index:int = 0;
				while(index < m_betCount.length) {
					m_betInfo[index].text = "";
					index ++;
				}
			}
			m_memberCount = null;
			m_betCount = null;
		}
		//设置下注人数
		public function SetTablePositionBet (positionBet:String):void {
			m_betCount = positionBet.split("|");
			
			ShowPositionInfo();
		}
		//设置下注金额
		public function SetTablePositionMembers (positionMembers:String):void {
			m_memberCount = positionMembers.split("|");
			
			ShowPositionInfo();
		}
		//显示下注信息
		private function ShowPositionInfo ():void {
			if(m_betInfo && m_betCount && m_memberCount) {
				var index:int = 0;
				while(index < m_betCount.length) {
					if(m_betInfo[index] && m_betCount[index] && m_memberCount[index]) {
						m_betInfo[index].text =NumberFormat.formatString( Number(m_betCount[index]))+ "/" + int(m_memberCount[index]).toFixed(0);
					}
					index ++;
				}
			}
		}
		public function SetLang(strlang:String):void{
			this["info"].gotoAndStop(strlang);
		}
	}
}