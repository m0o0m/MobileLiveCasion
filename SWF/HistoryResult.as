package {
	import flash.system.System;
	import flash.system.Security;
	import flash.system.ApplicationDomain;
	import flash.display.MovieClip;
	import ISWFModule.IModule;
	import HistoryRoad.*;
	import HistoryRoad.MoreGame.*;
	
	public class HistoryResult extends MovieClip implements IModule {
		
		public var ClassMap:Array = [
									 "BtnMobile", HistoryRoad.BtnMobile,
									 "LobbyBigEyesTable", HistoryRoad.LobbyBigEyesTable,
									 "LobbyBigEyesView", HistoryRoad.LobbyBigEyesView,
									 "LobbyBigTable", HistoryRoad.LobbyBigTable,
									 "LobbyBigView", HistoryRoad.LobbyBigView,
									 "LobbyPearlTable", HistoryRoad.LobbyPearlTable,
									 "LobbyPearlView", HistoryRoad.LobbyPearlView,
									 "LobbySmallForcedTable", HistoryRoad.LobbySmallForcedTable,
									 "LobbySmalllForcedView", HistoryRoad.LobbySmalllForcedView,
									 "LobbySmallTable", HistoryRoad.LobbySmallTable,
									 "LobbySmallView", HistoryRoad.LobbySmallView,
									 
									
									 "RouleetePealTable", HistoryRoad.RouleetePealTable,
									 "RouleetePealView", HistoryRoad.RouleetePealView,
									 
									 "LobbyPearlTableForDragon", HistoryRoad.LobbyPearlTableForDragon,
									 "LobbyPearlViewForDragon", HistoryRoad.LobbyPearlViewForDragon,
									 
									 "BaccaratHistoryResult", HistoryRoad.BaccaratHistoryResult,
									 "HistoryResultBaseManger", HistoryRoad.HistoryResultBaseManger,
									 "RouleeteHistoryResult", HistoryRoad.RouleeteHistoryResult,
									 "DragonHistoryResult",HistoryRoad.DragonHistoryResult,
									 
									  "BaccaratMoreGameHistoryResult",HistoryRoad.MoreGame.BaccaratMoreGameHistoryResult,
									  "RouleeteMoreGameHistoryResult", HistoryRoad.MoreGame.RouleeteMoreGameHistoryResult,
									 "DragonMoreGameHistoryResult",HistoryRoad.MoreGame.DragonMoreGameHistoryResult
									 ];
		public function HistoryResult() {
			//Security.allowDomain("*");
			System.useCodePage=true;
		}
		//获取定义类
		public function GetClass(strName:String):Class {
			var index:int = ClassMap.indexOf(strName);
			if(index == -1) {
				return null;
			}
			return ClassMap[index+1];
		}
		//获取当前应用域
		public function getApplicationDomain():ApplicationDomain {
			return ApplicationDomain.currentDomain;
		}
	}
}