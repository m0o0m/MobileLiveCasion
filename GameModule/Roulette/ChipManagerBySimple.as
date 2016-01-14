package  {
	import flash.geom.Point;
	import flash.display.MovieClip;
	import GameModule.Common.ChipBaseManager;
	import GameModule.Common.ChipHeapView;
	import caurina.transitions.Tweener;
	import  GameModule.Common.GameBaseView;
	public class ChipManagerBySimple extends ChipManager {

		public function ChipManagerBySimple() {
			// constructor code
			super();
			// constructor code
			//投注坐标
			  m_winAlpha=0;
		       m_chipPoint=[[new Point(249,394),
						 new Point(286,483),new Point(310,402),new Point(330,334),
						 new Point(349,483),new Point(369,402),new Point(386,334),
						 new Point(410,483),new Point(426,402),new Point(441,334),
						 new Point(472,483),new Point(485,402),new Point(497,334),
						 new Point(534,483),new Point(543,402),new Point(551,334),
						 new Point(595,483),new Point(601,402),new Point(606,334),//16-18
						 new Point(657,483),new Point(659,402),new Point(661,334),
						 new Point(719,483),new Point(718,402),new Point(716,334),
						 new Point(781,483),new Point(775,402),new Point(771,334),
						 new Point(843,483),new Point(834,402),new Point(826,334),
						 new Point(906,483),new Point(893,402),new Point(881,334),
						 new Point(967,483),new Point(950,402),new Point(938,334),
						 //2连36
						 new Point(314,473),new Point(336,392),new Point(353,324),
						 new Point(373,473),new Point(391,392),new Point(408,324),
						 new Point(436,473),new Point(451,392),new Point(463,324),
						 new Point(497,473),new Point(508,392),new Point(518,324),
						 new Point(558,473),new Point(568,392),new Point(574,324),
						 new Point(621,473),new Point(624,392),new Point(628,324),
						 new Point(684,473),new Point(694,392),new Point(684,324),
						 new Point(746,473),new Point(744,392),new Point(741,324),
						 new Point(810,473),new Point(802,392),new Point(796,324),
						 new Point(870,473),new Point(858,392),new Point(850,324),
						 new Point(931,473),new Point(916,392),new Point(904,324),
						 new Point(249,473),new Point(275,392),new Point(297,324),
						 //24
						 new Point(293,435),new Point(316,359),
						 new Point(353,435),new Point(372,359),
						 new Point(413,435),new Point(429,359),
						 new Point(473,435),new Point(486,359),
						 new Point(533,435),new Point(542,359),
						 new Point(594,435),new Point(599,359),
						 new Point(652,435),new Point(655,359),
						 new Point(713,435),new Point(713,359),
						 new Point(773,435),new Point(769,359),
						 new Point(831,435),new Point(825,359),
						 new Point(892,435),new Point(882,359),
						 new Point(953,435),new Point(939,359),
						  //3连14
						 new Point(263,435),new Point(286,359),
						 new Point(271,522),new Point(335,522),new Point(399,522),new Point(463,522),new Point(526,522),new Point(590,522),
						 new Point(654,522),new Point(718,522),new Point(783,522),new Point(846,522),new Point(909,522),new Point(972,522),
						 //4连22
						 new Point(327,435),new Point(347,359),
						 new Point(385,435),new Point(405,359),
						 new Point(447,435),new Point(460,359),
						 new Point(507,435),new Point(518,359),
						 new Point(567,435),new Point(575,359),
						 new Point(626,435),new Point(630,359),
						 new Point(687,435),new Point(687,359),
						 new Point(747,435),new Point(745,359),
						 new Point(808,435),new Point(800,359),
						 new Point(866,435),new Point(856,359),
						 new Point(928,435),new Point(914,359),
						 //6连11
						 new Point(361,297),new Point(416,297),new Point(468,297),new Point(524,297),new Point(580,297),new Point(632,297),
						 new Point(684,297),new Point(737,297),new Point(795,297),new Point(846,297),new Point(899,297),
						 //12小，大，红，黑，单，双
						 new Point(273,639),new Point(967,639),new Point(1170,173),new Point(1314,173),new Point(895,173),new Point(1030,173),
						 new Point(355,559),new Point(621,559),new Point(885,559),
						 new Point(1020,473),new Point(1001,392),new Point(987,324)
						 ]]
			//设置赢筹码坐标为筹码坐标左移10个像素
			m_winChipPoint=[[]]
			for(var i:int=0;i<m_chipPoint[0].length;i++){
				 m_winChipPoint[0][i]=m_chipPoint[0][i].add(new Point(-10,0))
			}
			m_BetPosCount =197;
			m_BankerPoint = new Point(655.5,0);
			m_moveChipPoint = [[new Point(655,190),new Point(662,190)]];
		}
		override public function GetChipView(index:int):MovieClip {
			var gbv:GameBaseView = this.parent as GameBaseView;
			return gbv.GetChipView(index);
		}

	}
	
}
