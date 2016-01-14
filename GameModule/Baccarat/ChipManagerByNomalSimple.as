package {
	import GameModule.Common.ChipBaseManager;
	import flash.geom.Point;
	public class ChipManagerByNomalSimple extends ChipBaseManager {

		public function ChipManagerByNomalSimple () {
			super ();

			m_BetPosCount = 9;
			m_winAlpha = 0;

			m_BankerPoint = new Point(1111,0);
			//闲，庄，和，闲对，庄对,大，小，闲保险，庄保险
			//一维表示椅子 二维表示下注筹码位置
			m_chipPoint=[
			[
			 new Point(1222,163),
			 new Point(1333,163),
			 new Point(1000,163),
			 new Point(889,163),
			 new Point(1111,163),
			 new Point(0,0),
			 new Point(0,0),
			 new Point(622,111),
			 new Point(802,111)]
			];

			//一维表示椅子 二维表示赢筹码位置
			m_winChipPoint=[
			[
			 new Point(1222,111),
			 new Point(1333,111),
			 new Point(1000,111),
			 new Point(889,111),
			 new Point(1111,111),
			 new Point(0,0),
			 new Point(0,0),
			 new Point(622,88),
			 new Point(802,88)]
			];

			m_moveChipPoint=[
			 [new Point(1111,240),
			  new Point(1111,240)]
			];
		}
		override public function ShowBetChips (wChairID:int, wBetPos:int, money:int):void {
			super.ShowBetChips (1, wBetPos, money);
		}

	}

}