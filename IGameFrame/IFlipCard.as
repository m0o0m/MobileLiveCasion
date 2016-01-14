package IGameFrame {
	import flash.display.MovieClip;
	
	public interface IFlipCard {

		function SetFlipCardPane(fcPane:IFlipCardPane):void;
		function GetMovieClip():MovieClip;
		function Destroy():void;
		function Reset():void;
		//扑克类型 (1:主控;2:被动;)
		function SetCardType(type:int,gameKind:int):void;
		//扑克数字
		function SetCardNum(cardIndex:int, cardPosition:int, cardNum:int,isShow:Boolean=true):void;
		function SetMoveData(cardIndex:int, data:String):void;
		function OpenMainCard(cardIndex:int):void;
		//咪牌剩余时间
		function SetLookCardDiffTime(difftime:int):void;
		
		function GetVolume(volumne:Boolean):void;
		
		function SetLang(strlang:String):void;
	}
	
}
