package {
	import GameModule.Common.ChipBaseManager;
	import flash.geom.Point;
	public class ChipManagerByNomal extends ChipBaseManager {

		public function ChipManagerByNomal () {
			// constructor code
			super ();

			m_BetPosCount = 5;
			m_winAlpha = 0;

			m_BankerPoint = new Point(840,607);
			//一维表示椅子 二维表示下注筹码位置
			m_chipPoint=[
			[
			 new Point(643,800),
			 new Point(1052,800),
			 new Point(811,800),
			 new Point(476,800),
			 new Point(1213,800),
		     ]
			];

			//一维表示椅子 二维表示赢筹码位置
			m_winChipPoint=[
			[
			 new Point(709,800),
			 new Point(983,800),
			 new Point(873,800),
			 new Point(528,800),
			 new Point(1153,800),
		     ]
			];

			m_moveChipPoint=[
			 [new Point(755,926),
			  new Point(755,926)]
			];
		}
		override public function ShowBetChips (wChairID:int, wBetPos:int, money:int):void {
			super.ShowBetChips(1, wBetPos, money);
		}
	}

}