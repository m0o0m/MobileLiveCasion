package {
	import GameModule.Common.BetPosBaseManager;
	import GameModule.Common.BetPosView;
	import GameModule.Common.BetPosMultiple;
	public class BetPosManagerByVipInsurance extends BetPosBaseManager {

		public function BetPosManagerByVipInsurance () {
			// constructor code
			m_BetPosList = ["","bpp","bpb","bpt","bppp","bpbp","","","bppi","bpbi"];
			super ();
			x = 169.25;
			y = 573;
			if (this.getChildByName("mc_podd")) {
				this["mc_podd"].visible = false;
			}
			if (this.getChildByName("mc_bodd")) {
				this["mc_bodd"].visible = false;
			}
		}
		override public function SetBetLimitByPos (limitByPos:Array,minLimit:int):void {
			m_betpospoint=new Array();
			m_betlimitByPos = [[,limitByPos[1]*BetPosMultiple.Player,limitByPos[1]*BetPosMultiple.Banker,limitByPos[1]*BetPosMultiple.Tie,limitByPos[1]*BetPosMultiple.PlayerPair,limitByPos[1]*BetPosMultiple.BankerPair],
			   [,limitByPos[1]*BetPosMultiple.Player,limitByPos[1]*BetPosMultiple.Banker,limitByPos[1]*BetPosMultiple.Tie,limitByPos[1]*BetPosMultiple.PlayerPair,limitByPos[1]*BetPosMultiple.BankerPair],
			   [,limitByPos[1]*BetPosMultiple.Player,limitByPos[1]*BetPosMultiple.Banker,limitByPos[1]*BetPosMultiple.Tie,limitByPos[1]*BetPosMultiple.PlayerPair,limitByPos[1]*BetPosMultiple.BankerPair],
			   [,limitByPos[1]*BetPosMultiple.Player,limitByPos[1]*BetPosMultiple.Banker,limitByPos[1]*BetPosMultiple.Tie,limitByPos[1]*BetPosMultiple.PlayerPair,limitByPos[1]*BetPosMultiple.BankerPair],
			   [,limitByPos[1]*BetPosMultiple.Player,limitByPos[1]*BetPosMultiple.Banker,limitByPos[1]*BetPosMultiple.Tie,limitByPos[1]*BetPosMultiple.PlayerPair,limitByPos[1]*BetPosMultiple.BankerPair],
			   [,limitByPos[1]*BetPosMultiple.Player,limitByPos[1]*BetPosMultiple.Banker,limitByPos[1]*BetPosMultiple.Tie,limitByPos[1]*BetPosMultiple.PlayerPair,limitByPos[1]*BetPosMultiple.BankerPair],
			   [,limitByPos[1]*BetPosMultiple.Player,limitByPos[1]*BetPosMultiple.Banker,limitByPos[1]*BetPosMultiple.Tie,limitByPos[1]*BetPosMultiple.PlayerPair,limitByPos[1]*BetPosMultiple.BankerPair]];
			m_minbetlimitByPos = [,minLimit * BetPosMultiple.Player,minLimit * BetPosMultiple.Banker,minLimit * BetPosMultiple.Tie,minLimit * BetPosMultiple.PlayerPair,minLimit * BetPosMultiple.BankerPair,minLimit,minLimit];
			m_betpospoint=[
			[[220,657],[240,617],[520,578],[260,578],[780,578],[0,0],[0,0],[111,698.65],[1133,698.65]],
			 [[350,657],[367,617],[555,578],[295,578],[815,578],[0,0],[0,0],[124,680.6],[1120,680.6]],
			 [[483,657],[492,617],[595,578],[335,578],[855,578],[0,0],[0,0],[136,662.6],[1111,662.6]],
			 [[635,657],[640,617],[630,578],[370,578],[890,578],[0,0],[0,0],[152,642.6],[1092,642.6]],
			 [[795,657],[788,617],[665,578],[405,578],[925,578],[0,0],[0,0],[164,625.65],[1081,625.65]],
			 [[922,657],[910,617],[700,578],[440,578],[960,578],[0,0],[0,0],[174,611.65],[1070,611.65]],
			 [[1043,657],[1030,617],[740,578],[480,578],[1000,578],[0,0],[0,0],[188,591],[1055,591]]
			];
			BetPosLimit (m_betlimitByPos,m_minbetlimitByPos);
			BetPosPoint (m_betpospoint);
		}
		protected var m_Player:Array;//闲投注总额
		protected var m_Blanker:Array;//庄投注总额
		override public function ShowBetTotal (wChairID:int,wBetPos:int,nBetValue:Number):void {
			m_betTotal = nBetValue;
			if (m_Player==null) {
				m_Player=new Array();
			}
			if (m_Blanker==null) {
				m_Blanker=new Array();
			}
			var view:BetPosView = GetBetPosView(wBetPos);
			if (view) {
				view.ShowBetTotal (m_betTotal);
			}
			if (wBetPos==BetPosition.Player) {
				m_Player[wChairID - 1] = nBetValue;
			}
			if (wBetPos==BetPosition.Banker) {
				m_Blanker[wChairID - 1] = nBetValue;
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
			var Limit:Array =new Array();
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
						if (m_Player==null) {
							break;
						}
						for (var index:int=0; index<m_Player.length; index++) {
							if (! m_Player[inde]) {
								m_Player[inde] = 0;
							}
							Limit[index] = int(m_Player[index] / m_odds);
							m_wBetPos = BetPosition.PlayerInsurance;
							if (this.getChildByName("mc_podd")) {
								this["mc_podd"].visible = true;
								this["mc_podd"].gotoAndStop (m_oddindex);
							}
							m_betlimitByPos[index][m_wBetPos] = Limit[index];
						}


						m_minbetlimitByPos[m_wBetPos] = 1;
						break;
					case 2 :
						if (m_Blanker==null) {
							break;
						}
						for (var inde:int=0; inde<m_Blanker.length; inde++) {
							if (! m_Blanker[inde]) {
								m_Blanker[inde] = 0;
							}

							Limit[inde] = int(m_Blanker[inde] / m_odds);
							m_wBetPos = BetPosition.BankerInsurance;
							if (this.getChildByName("mc_bodd")) {
								this["mc_bodd"].visible = true;
								this["mc_bodd"].gotoAndStop (m_oddindex);
							}
							m_betlimitByPos[inde][m_wBetPos] = Limit[inde];
						}

						m_minbetlimitByPos[m_wBetPos] = 1;
						break;
				}
			}
			if (Limit.length > 0) {
				SetViewInsurance (insurance,Limit[m_chair-1]);
			} else {
				SetViewInsurance (insurance,0);
			}
			BetPosLimit (m_betlimitByPos,m_minbetlimitByPos);
			m_Player = null;
			m_Blanker = null;
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