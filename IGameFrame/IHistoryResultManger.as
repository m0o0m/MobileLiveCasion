package IGameFrame {
	import flash.display.MovieClip;
	public interface IHistoryResultManger {
		function GetMovieClip():MovieClip;
		function Destroy():void;
		function ShowTable():void;
		function StringSplit(strServerResult:String):void;
		function ShowRoad(strNumber:String):void;
		function Shuffle():void;
		function GetResoultList():Array;
		function SetLang(strlang:String):void;
	}
}