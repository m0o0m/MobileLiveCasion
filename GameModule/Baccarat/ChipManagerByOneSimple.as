package {
	import GameModule.Common.ChipBaseManager;
	import flash.geom.Point;
	public class ChipManagerByOneSimple extends ChipBaseManager {

		public function ChipManagerByOneSimple () {
			super ();

			m_BetPosCount = 9;
			m_winAlpha = 0;

			m_BankerPoint = new Point(1111,0);
			//闲，庄，和，闲对，庄对,大，小，闲保险，庄保险
			//一维表示椅子 二维表示下注筹码位置
			m_chipPoint=[
			[
			 new Point(1222,84),
			 new Point(1333,84),
			 new Point(1000,162),
			 new Point(889,162),
			 new Point(1111,162),
			 new Point(0,0),
			 new Point(0,0),
			 new Point(1222,181),
			 new Point(1333,181)]
			];

			//一维表示椅子 二维表示赢筹码位置
			m_winChipPoint=[
			[
			 new Point(1222,64),
			 new Point(1333,64),
			 new Point(1000,132),
			 new Point(889,132),
			 new Point(1111,132),
			 new Point(0,0),
			 new Point(0,0),
			 new Point(1222,161),
			 new Point(1333,161)]
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