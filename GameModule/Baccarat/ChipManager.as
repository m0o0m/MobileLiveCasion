package {

	import GameModule.Common.ChipBaseManager;
	import flash.geom.Point;

	public class ChipManager extends ChipBaseManager {

		public function ChipManager () {
			super ();
            
			m_BetPosCount = 9;

			m_BankerPoint = new Point(635,473);
			//闲，庄，和，闲对，庄对
			m_chipHeapIndex=[[2,1,0,0,0],
							 [2,1,0,0,0],
							 [2,1,0,0,0],
							 [2,1,0,0,0],
							 [2,1,0,0,0],
							 [2,1,0,0,0],
							 [2,1,0,0,0]]
			//一维表示椅子 二维表示下注筹码位置
			m_chipPoint=[
			 [new Point(220,657),new Point(240,617),new Point(520,578),new Point(260,578),new Point(780,578),new Point(0,0),new Point(0,0),new Point(98.3,698.65),new Point(1147.2,698.65)],
			 [new Point(350,657),new Point(367,617),new Point(555,578),new Point(295,578),new Point(815,578),new Point(0,0),new Point(0,0),new Point(111.95,680.6),new Point(1134.85,680.6)],
			 [new Point(483,657),new Point(492,617),new Point(595,578),new Point(335,578),new Point(855,578),new Point(0,0),new Point(0,0),new Point(123.95,662.6),new Point(1119.85,662.6)],
			 [new Point(635,657),new Point(640,617),new Point(630,578),new Point(370,578),new Point(890,578),new Point(0,0),new Point(0,0),new Point(139.95,642.6),new Point(1106.85,642.6)],
			 [new Point(795,657),new Point(788,617),new Point(665,578),new Point(405,578),new Point(925,578),new Point(0,0),new Point(0,0),new Point(151.95,625.65),new Point(1095.85,625.65)],
			 [new Point(922,657),new Point(910,617),new Point(700,578),new Point(440,578),new Point(960,578),new Point(0,0),new Point(0,0),new Point(161.95,611.65),new Point(1084.85,611.65)],
			 [new Point(1043,657),new Point(1030,617),new Point(740,578),new Point(480,578),new Point(1000,578),new Point(0,0),new Point(0,0),new Point(175.05,591),new Point(1069.85,591)]
			];
			//一维表示椅子 二维表示赢筹码位置
			m_winChipPoint=[
			[new Point(255,657),new Point(270,617),new Point(520,568),new Point(260,568),new Point(780,568),new Point(0,0),new Point(0,0),new Point(125.3,698.65),new Point(1120.2,698.65)],
			 [new Point(385,657),new Point(397,617),new Point(555,568),new Point(295,568),new Point(815,568),new Point(0,0),new Point(0,0),new Point(138.95,680.6),new Point(1107.85,680.6)],
			 [new Point(518,657),new Point(522,617),new Point(595,568),new Point(335,568),new Point(855,568),new Point(0,0),new Point(0,0),new Point(150.95,662.6),new Point(1098.85,662.6)],
			 [new Point(610,657),new Point(610,617),new Point(630,568),new Point(370,568),new Point(890,568),new Point(0,0),new Point(0,0),new Point(166.95,642.6),new Point(1079.85,642.6)],
			 [new Point(760,657),new Point(748,617),new Point(665,568),new Point(405,568),new Point(925,568),new Point(0,0),new Point(0,0),new Point(178.95,625.65),new Point(1068.85,625.65)],
			 [new Point(887,657),new Point(870,617),new Point(700,568),new Point(440,568),new Point(960,568),new Point(0,0),new Point(0,0),new Point(188.95,611.65),new Point(1057.85,611.65)],
			 [new Point(1008,657),new Point(990,617),new Point(740,568),new Point(480,568),new Point(1000,568),new Point(0,0),new Point(0,0),new Point(202.05,591),new Point(1042.85,591)]
			];
			m_moveChipPoint=[
			 [new Point(180,699),new Point(220,697)],
			 [new Point(323,699),new Point(363,697)],
			 [new Point(462,699),new Point(502,697)],
			 [new Point(643,699),new Point(603,697)],
			 [new Point(792,699),new Point(752,697)],
			 [new Point(912,699),new Point(875,697)],
			 [new Point(1053,699),new Point(1013,697)]
			];
		}

	}

}