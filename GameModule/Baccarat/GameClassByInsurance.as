package {
	import flash.display.MovieClip;
	import flash.utils.ByteArray;
	import flash.geom.Point;

	import CommandProtocol.*;
	import GameModule.Common.*;
	import IGameFrame.*;
	import Net.*;
	//游戏类
	public class GameClassByInsurance extends GameClass {
		protected var m_NomalBetPosCount:uint = 6;//一般投注位置个数+1
		//构造函数
		public function GameClassByInsurance () {
			super ();
			m_wChairCount = 7;
			m_BetPosCount = 9;
			m_isMoreTable=false;
		}
		/////////////////////////////////////
		/////////////////////////////////////
		//创建游戏视图
		override protected function CreateGameView ():GameBaseView {
			return new GameViewByInsurance(this);
		}
	}
}
include "../Common/GameMessage.as"