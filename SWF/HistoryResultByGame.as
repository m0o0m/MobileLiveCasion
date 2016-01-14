package {
	import flash.system.System;
	import flash.system.Security;
	import flash.system.ApplicationDomain;
	import flash.display.MovieClip;
	import ISWFModule.IModule;
	import HistoryRoad.*;
	import HistoryRoad.BaccBySimple.*;
	import HistoryRoad.DragonBySimple.*;
	
	public class HistoryResultByGame extends MovieClip implements IModule {
		
		public var ClassMap:Array = [
									 "BtnMobile", HistoryRoad.BtnMobile,
									 "LobbyBigEyesTable", HistoryRoad.BigEyesTable,
									 "LobbyBigEyesView", HistoryRoad.BigEyesView,
									 "LobbyBigTable", HistoryRoad.BigTable,
									 "LobbyBigView", HistoryRoad.BigView,
									 "LobbyPearlTable", HistoryRoad.PearlTable,
									 "LobbyPearlView", HistoryRoad.PearlView,
									 "LobbySmallForcedTable", HistoryRoad.SmallForcedTable,
									 "LobbySmalllForcedView", HistoryRoad.SmalllForcedView,
									 "LobbySmallTable", HistoryRoad.SmallTable,
									 "LobbySmallView", HistoryRoad.SmallView,
									 
									 "PearlTableBySimple",HistoryRoad.BaccBySimple.PearlTableBySimple,
									 "PearlViewBySimple",HistoryRoad.BaccBySimple.PearlViewBySimple,
									 "BigEyesTableBySimple",HistoryRoad.BaccBySimple.BigEyesTableBySimple,
									 "BigEyesViewBySimple",HistoryRoad.BaccBySimple.BigEyesViewBySimple,
									 "BigTableBySimple",HistoryRoad.BaccBySimple.BigTableBySimple,
									 "BigViewBySimple",HistoryRoad.BaccBySimple.BigViewBySimple,
									 "SmallForcedTableBySimple",HistoryRoad.BaccBySimple.SmallForcedTableBySimple,
									 "SmalllForcedViewBySimple",HistoryRoad.BaccBySimple.SmalllForcedViewBySimple,
									 "SmallTableBySimple",HistoryRoad.BaccBySimple.SmallTableBySimple,
									 "SmallViewBySimple",HistoryRoad.BaccBySimple.SmallViewBySimple,
									 "RoadInfoBySimple",HistoryRoad.BaccBySimple.RoadInfoBySimple,
									 
									 "BigOrSmallView", HistoryRoad.BigOrSmallView,
									 "HitColumnName", HistoryRoad.HitColumnName,
									 "HCView", HistoryRoad.HCView,
									 "HCTable", HistoryRoad.HCTable,
									 "RedOrBlackView", HistoryRoad.RedOrBlackView,
									 "RoadInfo", HistoryRoad.RoadInfo,
									 "SingleOrDoubleView", HistoryRoad.SingleOrDoubleView,
									 "RouleetePealViewBySimple", HistoryRoad.RouleetePealViewBySimple,
									 "RouleetePealTableBySimple",HistoryRoad.RouleetePealTableBySimple,
									 
									 "PearlViewDragon",HistoryRoad.PearlViewDragon,
									 "PearlTableDragon",HistoryRoad.PearlTableDragon,
									 "RoadInfoDragon",HistoryRoad.RoadInfoDragon,
									 
									 "PearlViewDragonBySimple",HistoryRoad.DragonBySimple.PearlViewDragonBySimple,
									 "PearlTableDragonBySimple",HistoryRoad.DragonBySimple.PearlTableDragonBySimple,
									 "RoadInfoDragonBySimple",HistoryRoad.DragonBySimple.RoadInfoDragonBySimple,
									 
									 "BaccaratHistoryResultByGame", HistoryRoad.BaccaratHistoryResultByGame,
					                 "DragonHistoryResultManagerByGame",HistoryRoad.DragonHistoryResultManagerByGame,
									 "RoulettetHistoryResultByGame",HistoryRoad.RoulettetHistoryResultByGame,
									  
									  "RoulettetHistoryResultBySimple",HistoryRoad.RoulettetHistoryResultBySimple,
									 "BaccaratHistoryResultBySimple",HistoryRoad.BaccBySimple.BaccaratHistoryResultBySimple,
									 "DragonHistoryResultManagerBySimple",HistoryRoad.DragonBySimple.DragonHistoryResultManagerBySimple,
									 "HistoryResultBaseManger", HistoryRoad.HistoryResultBaseManger
									 
									 ];
		public function HistoryResultByGame() {
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