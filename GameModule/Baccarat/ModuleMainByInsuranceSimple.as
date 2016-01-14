package {
	import flash.display.MovieClip;
	import flash.system.*;
	import flash.events.Event;

	import IGameFrame.IGameClass;
	import IGameFrame.IGameModule;

	public class ModuleMainByInsuranceSimple extends MovieClip implements IGameModule {
		public function ModuleMainByInsuranceSimple () {
			//Security.allowDomain ("*");
			System.useCodePage = true;
		}
		//查询游戏类接口
		public function getIGameClass ():IGameClass {
			var game:GameClassByInsuranceSimple;
			var igame:IGameClass;
			try {
				game = new GameClassByInsuranceSimple();
				igame = game.QueryIGameClass();
				return igame;
			} catch (e:Event) {
				System.setClipboard (e.toString());
			}
			game = null;
			igame = null;
			return null;
		}
	}
}
