package {
	import flash.display.MovieClip;
	import flash.utils.ByteArray;
	import flash.geom.Point;

	import CommandProtocol.*;
	import GameModule.Common.*;
	import IGameFrame.*;
	import Net.*;
	public class GameClassByNomalSimple extends GameClassByNomal {

		public function GameClassByNomalSimple () {
			// constructor code
			super ();
		}
		//声音
		protected override function InitGameSound ():void {
			m_sound=new GameSound();
		}
		//创建游戏视图
		override protected function CreateGameView ():GameBaseView {
			return new GameViewByNomalSimple(this);
		}
		//获取筹码选择
		override public function GetSelectChips ():Array {
			if (m_clientContainer) {
				var list:Array = m_clientContainer.GetSelectChips();
				if (list == null || list.length != 2) {
					m_SelectChip = ChipMoney(list[0]);
					return null;
				}
				m_SelectChip = ChipMoney(list[0][list[1]]);
				return list;
			}
			return null;
		}
		override public function ShowMessageBox(type:int,code:int,confirmfun:Function,confirmparam:Object,cancelfun:Function,cancelparam:Object):void{
		}
	}

}
include "../../CommonModule/CHIPCONST.as"