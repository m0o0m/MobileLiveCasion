package {
	import GameModule.Common.BetPosBaseManager;
	import GameModule.Common.BetPosView;
	import GameModule.Common.BetPosMultiple;
	public class BetPosManager extends BetPosBaseManager {

		public function BetPosManager () {
			//[,闲，庄，和，闲对，庄对，大，小]
			m_BetPosList = ["","bpp","bpb","bpt","bppp","bpbp","bpbig","bps","",""];
			super ();
			x = 169.25;
			y = 573;
		}
		override public function SetBetLimitByPos (limitByPos:Array,minLimit:int):void {
			m_betpospoint=new Array();
			m_betlimitByPos = [,limitByPos[1]*BetPosMultiple.Player,limitByPos[1]*BetPosMultiple.Banker,limitByPos[1]*BetPosMultiple.Tie,limitByPos[1]*BetPosMultiple.PlayerPair,limitByPos[1]*BetPosMultiple.BankerPair,limitByPos[1],limitByPos[1]];
			m_minbetlimitByPos=[,minLimit*BetPosMultiple.Player,minLimit*BetPosMultiple.Banker,minLimit*BetPosMultiple.Tie,minLimit*BetPosMultiple.PlayerPair,minLimit*BetPosMultiple.BankerPair,minLimit,minLimit]
			m_betpospoint=[
			  [[220,657],[240,617],[520,578],[260,578],[780,578],[0,0],[0,0],[66.9,697.7],[1159.25,697.7]],
			 [[350,657],[367,617],[555,578],[295,578],[815,578],[0,0],[0,0],[105,682.65],[1117.9,682.65]],
			 [[483,657],[492,617],[595,578],[335,578],[855,578],[0,0],[0,0],[85.9,665.35],[1139.95,665.35]],
			 [[635,657],[640,617],[630,578],[370,578],[890,578],[0,0],[0,0],[130,648.65],[1095.9,648.65]],
			 [[795,657],[788,617],[665,578],[405,578],[925,578],[0,0],[0,0],[117,633.65],[1111.9,633.65]],
			 [[922,657],[910,617],[700,578],[440,578],[960,578],[0,0],[0,0],[155,617.65],[1071.9,617.65]],
			 [[1043,657],[1030,617],[740,578],[480,578],[1000,578],[0,0],[0,0],[136,600.65],[1086.9,600.65]]
			];
		   BetPosLimit(m_betlimitByPos,m_minbetlimitByPos);
		   BetPosPoint(m_betpospoint);
		}
		override public function ShowBetTotal (wChairID:int,wBetPos:int,nBetValue:Number):void {
			m_betTotal = nBetValue;
			var view:BetPosView = GetBetPosView(wBetPos);
			 if(view){
				 view.ShowBetTotal(m_betTotal);
			 }
		}
	}
}