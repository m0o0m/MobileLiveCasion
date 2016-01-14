package {

	import GameModule.Common.ChipBaseManager;
	import flash.geom.Point;

	public class ChipManager extends ChipBaseManager {

		public function ChipManager () {
			super ();

			m_BetPosCount = 3;
			m_winAlpha = 0;

			m_BankerPoint = new Point(842,614);
			//和,龙，虎

			//一维表示椅子 二维表示下注筹码位置
			m_chipPoint=[
			 [new Point(806,798),new Point(592,798),new Point(1121,798)]
			 ];

			//一维表示椅子 二维表示赢筹码位置
			m_winChipPoint=[
			 [new Point(877,798),new Point(653,798),new Point(1043,798)]
			 ];


			m_moveChipPoint=[
			 [new Point(810,916),new Point(810.1,916)],
			];
		}

	}

}