package  {
	import flash.geom.Point;
	public class ChipManagerBySimple extends ChipManager{

		public function ChipManagerBySimple() {
			super ();

			m_BetPosCount = 3;
			m_winAlpha = 0;

			m_BankerPoint = new Point(1111,0);
			//和,龙，虎

			//一维表示椅子 二维表示下注筹码位置
			m_chipPoint=[
			 [new Point(720,163),new Point(638,163),new Point(800,163)]
			 ];

			//一维表示椅子 二维表示赢筹码位置
			m_winChipPoint=[
			  [new Point(720,111),new Point(638,111),new Point(800,111)]
			 ];


			m_moveChipPoint=[
			 [new Point(1111,240),new Point(1111,240)],
			];
		}


	}
	
}
