package IGameFrame{
	import flash.display.MovieClip;
	
	public interface IChipSelect {
		// constructor code
		function GetMovieClip ():MovieClip;
		function Destroy ():void;
		function ShowTotalChip ():void;
		function ShowSelectChip ():void;
		function SetChipPane (chipPane:IChipPane):void;
		function HideSelectChip(bool:Boolean):void;
		function SetLang(strLang:String):void;
		function ShowChipPane(arr:Array):void;
	}
}