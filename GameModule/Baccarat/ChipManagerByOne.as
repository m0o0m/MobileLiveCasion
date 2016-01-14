package {

	import GameModule.Common.ChipBaseManager;
	import flash.geom.Point;

	public class ChipManagerByOne extends ChipBaseManager {

		public function ChipManagerByOne () {
			super ();

			m_BetPosCount = 9;
			m_winAlpha = 0;

			m_BankerPoint = new Point(840,607);
             //闲，庄，和，闲对，庄对，，闲保险，庄保险
			//一维表示椅子 二维表示下注筹码位置
			m_chipPoint=[
				[
				 new Point(652,803),
				 new Point(1072,803),
				 new Point(822,803),
				 new Point(478,823),
				 new Point(1229,823),
				 new Point(0,0),
				 new Point(0,0),
				 new Point(500,768),
				 new Point(1208,768)]
			];

			//一维表示椅子 二维表示赢筹码位置
			m_winChipPoint=[
				[
				 new Point(714,803),
				 new Point(1006,803),
				 new Point(878,803),
				 new Point(534,823),
				 new Point(1169,823),
				 new Point(0,0),
				 new Point(0,0),
				 new Point(556,768),
				 new Point(1152,768)]
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