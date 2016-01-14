package  {
	import flash.geom.Point;
	public class ChipManagerLookOn extends ChipManager{

		public function ChipManagerLookOn() {
			// constructor code
			super();
			m_winAlpha = 0;
			//一维表示椅子 二维表示下注筹码位置
			m_chipPoint=[
			[new Point(695,657),new Point(690,617),new Point(653,578),new Point(387,578),new Point(918,578),new Point(0,0),new Point(0,0),new Point(130,648.65),new Point(1095.9,648.65)]
			];
			//一维表示椅子 二维表示赢筹码位置
			m_winChipPoint=[
			[new Point(655,657),new Point(650,617),new Point(653,568),new Point(387,568),new Point(918,568),new Point(0,0),new Point(0,0),new Point(99,648.65),new Point(1124.9,648.65)]
			];
			m_moveChipPoint=[
			 [new Point(623,710),new Point(583,710)]
			];
		}
		override public function ShowBetChips (wChairID:int, wBetPos:int, money:int):void {
			super.ShowBetChips(1, wBetPos, money);
		}

	}
	
}
