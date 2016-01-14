﻿package {
	import GameModule.Common.ChipBaseManager;
	import GameModule.Common.ChipHeapView;
	import flash.geom.Point;
	import caurina.transitions.Tweener;
	import GameModule.Common.InfoPane.*;
	import flash.display.MovieClip;

	public class ChipManager extends ChipBaseManager {
		protected var m_inforpane:InfoPane;
		public function ChipManager () {
			super();
			// constructor code
			//投注坐标
			  m_winAlpha=0;
		       m_chipPoint=[[new Point(27,304),
						 new Point(106,446),new Point(106,304),new Point(106,180),//1-3
						 new Point(196,446),new Point(196,304),new Point(196,180),
						 new Point(286,446),new Point(286,304),new Point(286,180),
						 new Point(376,446),new Point(376,304),new Point(376,180),
						 new Point(466,446),new Point(466,304),new Point(466,180),
						 new Point(556,446),new Point(556,304),new Point(556,180),//16-18
						 new Point(646,446),new Point(646,304),new Point(646,180),
						 new Point(736,446),new Point(736,304),new Point(736,180),
						 new Point(826,446),new Point(826,304),new Point(826,180),
						 new Point(916,446),new Point(916,304),new Point(916,180),
						 new Point(1006,446),new Point(1006,304),new Point(1006,180),//31-33
						 new Point(1096,446),new Point(1096,304),new Point(1096,180),
						 //2连36
						 new Point(166,446),new Point(166,304),new Point(166,180),//0104,0205,0306
						 new Point(255,446),new Point(255,304),new Point(255,180),
						 new Point(344,446),new Point(344,304),new Point(344,180),
						 new Point(433,446),new Point(433,304),new Point(433,180),
						 new Point(522,446),new Point(522,304),new Point(522,180),
						 new Point(611,446),new Point(611,304),new Point(611,180),
						 new Point(700,446),new Point(700,304),new Point(700,180),
						 new Point(789,446),new Point(789,304),new Point(789,180),
						 new Point(878,446),new Point(878,304),new Point(878,180),
						 new Point(967,446),new Point(967,304),new Point(967,180),
						 new Point(1056,446),new Point(1056,304),new Point(1056,180),
						 new Point(77,446),new Point(77,304),new Point(77,180),//01,02,03
						 //24
						 new Point(106,345),new Point(106,218),//0102,0203
						 new Point(196,345),new Point(196,218),
						 new Point(286,345),new Point(286,218),
						 new Point(376,345),new Point(376,218),
						 new Point(466,345),new Point(466,218),
						 new Point(556,345),new Point(556,218),
						 new Point(646,345),new Point(646,218),
						 new Point(736,345),new Point(736,218),
						 new Point(826,345),new Point(826,218),
						 new Point(916,345),new Point(916,218),
						 new Point(1006,345),new Point(1006,218),
						 new Point(1096,345),new Point(1096,218),
						  //3连14
						 new Point(77,345),new Point(77,218),
						 new Point(106,488),new Point(196,488),new Point(286,488),new Point(376,488),new Point(466,488),new Point(556,488),
						 new Point(646,488),new Point(736,488),new Point(826,488),new Point(916,488),new Point(1006,488),new Point(1096,488),
						 //4连22
						 new Point(166,345),new Point(166,218),
						 new Point(255,345),new Point(255,218),
						 new Point(344,345),new Point(344,218),
						 new Point(433,345),new Point(433,218),
						 new Point(522,345),new Point(522,218),
						 new Point(611,345),new Point(611,218),
						 new Point(700,345),new Point(700,218),
						 new Point(789,345),new Point(789,218),
						 new Point(878,345),new Point(878,218),
						 new Point(967,345),new Point(967,218),
						 new Point(1056,345),new Point(1056,218),
						 //6连11
						 new Point(166,488),new Point(255,488),new Point(344,488),new Point(433,488),new Point(522,488),new Point(611,488),
						 new Point(700,488),new Point(789,488),new Point(878,488),new Point(967,488),new Point(1056,488),
						 //12
						 new Point(166,622),new Point(1006,622),new Point(677,622),new Point(497,622),new Point(859,622),new Point(321,622),
						 new Point(231,534),new Point(585,534),new Point(930,534),//打
						 new Point(1180,446),new Point(1180,304),new Point(1180,180)//列
						 ]]
			//设置赢筹码坐标为筹码坐标左移10个像素
			m_winChipPoint=[[]]
			for(var i:int=0;i<m_chipPoint[0].length;i++){
				 m_winChipPoint[0][i]=m_chipPoint[0][i].add(new Point(-10,0))
			}
			m_BetPosCount =197;
			m_BankerPoint = new Point(610,0);
			m_moveChipPoint = [[new Point(610,760),new Point(610,760)]];
			
		}
		protected override function GetChairIndex(wChairID:int):int{
			return 0;
		}
		override public function SetInfo(infopane:Object):void{
			if(infopane){
				m_inforpane=infopane as InfoPane ;
			}
		}
		override public function GetChipView(index:int):MovieClip {
			if(m_inforpane){
				return m_inforpane.GetChipView(index);
			}
			return null;
			
		}
	}
}