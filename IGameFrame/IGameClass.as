package IGameFrame
{
	import flash.display.MovieClip;
	import CommandProtocol.*;
	
	//游戏类接口
	public interface IGameClass
	{
		//创建游戏端
		function CreateGameClient(clientContainer:IGameClassContainer, table:cmdMemberTableInfo, param:Object):Boolean;
		//销毁游戏端
		function DestroyGameClient():void;
		//获取影片
		function GetMovieClip():MovieClip;
		//获取游戏视图
		function GetGameView():IGameView;
		//退出游戏
		function SendEventExitGameClient():void;
		//发送站起
		function OnSendStandUp():void;
		//设置桌子状态
		function SetTableStatus(tableStatus:cmdMemberTableStatus):void;
		//设置桌子历史结果
		function SetTableHisRoad(hisRoad:cmdMemberTableHisRoad):void;
		//设置桌主
		function SetTableDealer(dealer:cmdMemberTableDealer):void;
		function SetTablePositionBet(betPos:cmdMemberTablePositionBet):void;
		function SetTablePositionMembers(memPos:cmdMemberTablePositionMembers):void;
		//获取激活状态
		function SetActiveStatus(active:Boolean):void;
		//获取激活状态
		function GetActiveStatus():Boolean;
		//多台筹码选择
		function SetMoreTableSelectChips(chips:Array):void;
	}
}