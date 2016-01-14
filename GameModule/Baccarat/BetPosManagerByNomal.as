package  {
	import GameModule.Common.BetPosBaseManager;
	import GameModule.Common.BetPosView;
	import GameModule.Common.BetPosMultiple;
	public class BetPosManagerByNomal extends BetPosBaseManager{

		public function BetPosManagerByNomal() {
			// constructor code
			//[,闲，庄，和，闲对，庄对，大，小]
			m_BetPosList = ["","bpp","bpb","bpt","bppp","bpbp"];
			super ();
			x = 437;
			y = 767;
		}
		override public function SetBetLimitByPos (limitByPos:Array,minLimit:int):void {
			m_betpospoint=new Array();
			m_betlimitByPos = [,limitByPos[1]*BetPosMultiple.Player,limitByPos[1]*BetPosMultiple.Banker,limitByPos[1]*BetPosMultiple.Tie,limitByPos[1]*BetPosMultiple.PlayerPair,limitByPos[1]*BetPosMultiple.BankerPair];
			m_minbetlimitByPos=[,minLimit*BetPosMultiple.Player,minLimit*BetPosMultiple.Banker,minLimit*BetPosMultiple.Tie,minLimit*BetPosMultiple.PlayerPair,minLimit*BetPosMultiple.BankerPair]
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
		override public function ShowBetTotal (wChairID:int,wBetPos:int,nBetValue:Number):void {
			m_betTotal = nBetValue;
			var view:BetPosView = GetBetPosView(wBetPos);
			 if(view){
				 view.ShowBetTotal(m_betTotal);
			 }
		}

	}
	
}
