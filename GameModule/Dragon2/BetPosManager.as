package {
	import GameModule.Common.BetPosBaseManager;
	import GameModule.Common.BetPosView;
	import CommandProtocol.GameKindEnum;
	import GameModule.Common.BetPosMultiple;
	public class BetPosManager extends BetPosBaseManager {
		public function BetPosManager () {
			m_BetPosList = ["","bptie","bpdragon","bptiger"];
			super ();
			x = 431;
			y = 761;
		}
		override public function SetBetLimitByPos (limitByPos:Array,minLimit:int):void {
			m_betpospoint=new Array();
			m_betlimitByPos = [,limitByPos[1]*BetPosMultiple.Tie,limitByPos[1]*BetPosMultiple.Dragon,limitByPos[1]*BetPosMultiple.Tiger];
			m_minbetlimitByPos=[,minLimit*BetPosMultiple.Tie,minLimit*BetPosMultiple.Dragon,minLimit*BetPosMultiple.Tiger]
			if ((m_BetPosList && m_BetPosList.length > 0)) {
				var index:int = 0;
				while ((index < m_BetPosList.length)) {
					var view:BetPosView = GetBetPosView(index);
					if (view) {
						m_betpospoint[index] = view.GetPoint();
					}
					index++;
				}
			}
			BetPosLimit (m_betlimitByPos,m_minbetlimitByPos);
			BetPosPoint (m_betpospoint);
		}
		override public function ShowBetTotal (wChairID:int,wBetPos:int,nBetValue:Number):void {
			m_betTotal = nBetValue;
			var view:BetPosView = GetBetPosView(wBetPos);
			if (view) {
				view.ShowBetTotal (m_betTotal);
			}
		}
	}
}
include "../Common/GameMessage.as";