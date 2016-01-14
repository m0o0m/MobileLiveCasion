package GameModule.Common{
	import flash.display.MovieClip;
	import flash.text.TextField;
	import flash.utils.Dictionary;
	

	//下注位置管理
	public class BetPosBaseManager extends MovieClip {
		private var m_GameBaseView:GameBaseView;//游戏视图

		protected var m_BetPosList:Array;//投注位置,存放Name

		protected var m_BetPosPlayList:Dictionary;//投注位置需要播放的位置
		protected var m_winBetPosList:Array;//赢投注位置
		
		protected var m_betlimitByPos:Array;//每个投注位置最大限额
		protected var m_minLimit:int;//最小投注限额
		protected var m_limitByPos:Array;//最大限额
		protected var m_minbetlimitByPos:Array;//每个投注位置最小限额
		//
		protected var m_betpospoint:Array;//投注位置坐标
		
		public function BetPosBaseManager () {
			if (m_BetPosList) {
				var index:int = 0;
				while (index < m_BetPosList.length) {
					var bpv:BetPosView = GetBetPosView(index);
					if (bpv) {
						bpv.SetBetPosManager (this);
					}
					index++;
				}
			}
		}
		public function SetGameView (gv:GameBaseView):void {
			m_GameBaseView = gv;
		}
		public function Destroy ():void {
			if (m_BetPosList && m_BetPosList.length > 0) {
				var index:int = 0;
				while (index < m_BetPosList.length) {
					var view:BetPosView = GetBetPosView(index);
					if (view) {
						view.Destroy ();
						view = null;
					}
					index++;
				}
				m_BetPosList = null;
			}
			m_BetPosPlayList=null;
			m_betlimitByPos=null;
			m_limitByPos=null;
			m_minbetlimitByPos=null;
			m_GameBaseView = null;
			var ind:int=this.numChildren-1;
			for(ind;ind>=0;ind--){
				this.removeChildAt(ind);
			}
		}
		public function ResetBetPos ():void {
			SetBetStatus (false);
			m_betTotal=0;
			if(m_limitByPos && m_minLimit){
			BetLimitByPos(m_limitByPos,m_minLimit);
			}
		}
		//下注
		public function OnBet (betPosIndex:int):void {
			m_GameBaseView.OnBet (betPosIndex);
		}
		//设置下注状态;
		public function SetBetStatus (betStatus:Boolean):void {
			if (m_BetPosList && m_BetPosList.length > 0) {
				var index:int = 0;
				while (index < m_BetPosList.length) {
					var view:BetPosView = GetBetPosView(index);
					if (view) {
						view.SetBetStatus (betStatus);
					}
					index++;
				}
			}
		}
		protected function GetBetPosView (index:int):BetPosView {
			if (index < 0 || index >= m_BetPosList.length) {
				return null;
			}
			var bpvName:String = m_BetPosList[index].toString();
			if (bpvName == "" || this.getChildByName(bpvName) == null) {
				return null;
			}
			return (this[bpvName] as BetPosView);
		}

		//特殊投注位置控制
		public function SetPlayBetOver (betPos:String):void {
			if (m_BetPosPlayList == null) {
				return;
			}
			var index:int = 0;
			var list:Array = m_BetPosPlayList[betPos] as Array;
			while (index < list.length) {
				var name:String = list[index];
				this[name].gotoAndStop (2);
				index++;
			}
		}
		public function SetPlayBetOut (betPos:String):void {
			if (m_BetPosPlayList == null) {
				return;
			}
			var index:int = 0;
			var list:Array = m_BetPosPlayList[betPos] as Array;
			while (index < list.length) {
				var name:String = list[index];
				this[name].gotoAndStop (1);
				index++;
			}
		}
		public function PlayWin (winBetPosList:Array):void {
			if (winBetPosList == null) {
				m_winBetPosList = null;
				return;
			}
			m_winBetPosList = winBetPosList;
			if (winBetPosList && winBetPosList.length > 0) {
				var index:int = 0;
				while (index < winBetPosList.length) {
					var bpv:BetPosView = GetBetPosView(winBetPosList[index]);
					if (bpv) {
						bpv.PlayWin ();
					}
					index++;
				}
			}
		}
		public function StopWin ():void {
			if (m_winBetPosList == null) {
				return;
			}
			var index:int = 0;
			while (index < m_winBetPosList.length) {
				var bpv:BetPosView = GetBetPosView(m_winBetPosList[index]);
				if (bpv) {
					bpv.StopWin ();
				}
				index++;
			}
		}
		//获取投注位置限额
		public function BetLimitByPos(limitByPos:Array,minLimit:int):void{
			m_minLimit=minLimit;
			m_limitByPos=limitByPos;
			SetBetLimitByPos(m_limitByPos,m_minLimit);
		}
		//显示投注位置限额
		public function SetBetLimitByPos(limitByPos:Array,minLimit:int):void{
			
		}
	    public function BetPosLimit(betlimitByPos:Array,minbetposlimit:Array):void{
			if(m_GameBaseView){
				m_GameBaseView.BetPosLimit(betlimitByPos,minbetposlimit);
			}
		}
		public function BetPosPoint(arrpoint:Array):void{
			if(m_GameBaseView){
				m_GameBaseView.BetPosPoint(arrpoint);
			}
		}
		public function ShowBetPos(isShow:Boolean,w_BetPos:int,bettotal:Number):void{
			if(m_GameBaseView){
				m_GameBaseView.ShowBetPos(isShow,w_BetPos,bettotal);
			}
		}
		protected var m_betTotal:Number=0;
		public function ShowBetTotal(wChairID:int,wBetPos:int,nBetValue:Number):void{
			m_betTotal=nBetValue;
		}
		//获得赔率,显示赔率
		public function SetOdds(odds:Number):void{
			
		}
		//获得下注类型insurance:0(一般下注),1(闲保险),2(庄保险)
		public function SetInsurance(insurance:int):void{
			
		}
        protected var m_chair:uint;
		public function SetChair(chair:uint):void{
			m_chair= chair;
		}
		public function SetLang(strlang:String):void{
			if(this.getChildByName("mc_betposlang")){
				
			}
		}
		public function SetInfo(infopane:Object):void{
			
		}
	}
}