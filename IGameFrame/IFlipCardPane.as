package IGameFrame {
	public interface IFlipCardPane {
		function SendMoveData(data:String, openCard:Boolean, index:int, position:int):void;
		function OpenNotLook():void;//倒计时结束，翻开未眯的牌
	}
}
