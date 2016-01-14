package {
	import GameModule.Common.BetPosBaseManager;
	import GameModule.Common.BetPosView;
	import GameModule.Common.BetPosMultiple;
	public class BetPosManagerByOne extends BetPosBaseManager {
		public function BetPosManagerByOne () {
			m_BetPosList = ["","bpp","bpb","bpt","bppp","bpbp","","","bppi","bpbi"];
			super ();
			x = 445;
			y = 762;
			if (this.getChildByName("mc_podd")) {
				this["mc_podd"].visible = false;
			}
			if (this.getChildByName("mc_bodd")) {
				this["mc_bodd"].visible = false;
			}
		}
		override public function SetBetLimitByPos (limitByPos:Array,minLimit:int):void {
			m_betpospoint=new Array();
			m_betlimitByPos = [,limitByPos[1]*BetPosMultiple.Player,limitByPos[1]*BetPosMultiple.Banker,limitByPos[1]*BetPosMultiple.Tie,limitByPos[1]*BetPosMultiple.PlayerPair,limitByPos[1]*BetPosMultiple.BankerPair];
			m_minbetlimitByPos=[,minLimit*BetPosMultiple.Player,minLimit*BetPosMultiple.Banker,minLimit*BetPosMultiple.Tie,minLimit*BetPosMultiple.PlayerPair,minLimit*BetPosMultiple.BankerPair];
			if (m_BetPosList && m_BetPosList.length > 0) {
				var index:int = 0;
				while (index < m_BetPosList.length) {
					var view:BetPosView = GetBetPosView(index);
					if (view) {
						m_betpospoint[index]=view.GetPoint();
					}
					index++;
				}
			}
			BetPosLimit(m_betlimitByPos,m_minbetlimitByPos);
			BetPosPoint(m_betpospoint);
		}
		protected var m_Player:Number;//闲投注总额
		protected var m_Blanker:Number;//庄投注总额
		override public function ShowBetTotal (wChairID:int,wBetPos:int,nBetValue:Number):void {
			m_betTotal = nBetValue;
			var view:BetPosView = GetBetPosView(wBetPos);
			 if(view){
				 view.ShowBetTotal(m_betTotal);
			 }
			if (wBetPos==BetPosition.Player) {
				m_Player = nBetValue;
			}
			if (wBetPos==BetPosition.Banker) {
				m_Blanker = nBetValue;
			}
		}
		protected var m_odds:Number;//赔率
		protected var m_Limit:int;//保险投注限额
		protected var m_wBetPos:int;//投注位置
		protected var m_oddindex:int;//赔率显示帧数
		protected var m_oddlist:Array = [1.5,2,3,4,8,9];//
		//获得赔率
		override public function SetOdds (odds:Number):void {
			m_odds = odds;
			var index:int = 0;
			for (index; index<m_oddlist.length; index++) {
				if (m_odds==m_oddlist[index]) {
					m_oddindex = index + 1;
					return;
				}
			}
		}
		//获得下注类型insurance:0(一般下注),1(闲保险),2(庄保险）,显示赔率
		override public function SetInsurance (insurance:int):void {
			m_Limit=0;
			if (m_odds) {
				switch (insurance) {
					case 0 :
						if (this.getChildByName("mc_podd")) {
							this["mc_podd"].visible = false;
						}
						if (this.getChildByName("mc_bodd")) {
							this["mc_bodd"].visible = false;
						}
						break;
					case 1 :
						m_Limit =int( m_Player / m_odds);
						m_wBetPos = BetPosition.PlayerInsurance;
						if (this.getChildByName("mc_podd")) {
							this["mc_podd"].visible = true;
							this["mc_podd"].gotoAndStop (m_oddindex);
						}
						m_betlimitByPos[m_wBetPos] = m_Limit;
						m_minbetlimitByPos[m_wBetPos]=1;
						break;
					case 2 :
						m_Limit =int( m_Blanker / m_odds);
						m_wBetPos = BetPosition.BankerInsurance;
						if (this.getChildByName("mc_bodd")) {
							this["mc_bodd"].visible = true;
							this["mc_bodd"].gotoAndStop (m_oddindex);
						}
						m_betlimitByPos[m_wBetPos] = m_Limit;
						m_minbetlimitByPos[m_wBetPos]=1;
				}
			}
			SetViewInsurance (insurance,m_Limit);
		    BetPosLimit(m_betlimitByPos,m_minbetlimitByPos);
			m_Player=0;
			m_Blanker=0;
		}
		//
		public function SetViewInsurance (insurance:int,limit:int):void {
			if (m_BetPosList && m_BetPosList.length > 0) {
				var index:int = 0;
				while (index < m_BetPosList.length) {
					var view:BetPosView = GetBetPosView(index);
					if (view) {
						view.SetViewInsurance (insurance,limit);
					}
					index++;
				}
			}
		}
	}
}