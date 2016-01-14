package  IGameFrame{
	import flash.display.MovieClip;
	
	public interface ILoad {
		function GetLoadFolder():String;
		function GetHistoryRoad(className:String, gameRoad:Boolean = false):IHistoryResultManger;
		function GetChipSelect(className:String):IChipSelect;
		function GetFlipCard(className:String):IFlipCard;
		function GetChipView(index:int):MovieClip;
		function ResetLink():void;//重新连接大厅
		function GetVersion():String;//版本信息
		function ExitApp():void;
	}
}