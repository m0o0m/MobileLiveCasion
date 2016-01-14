package IGameFrame
{
	import flash.display.MovieClip;
	
	//游戏类容器
	public interface IGameClassContainer
	{
		//活动显示游戏端
		function ActiveGameClass(game:IGameClass):void;
		//销毁游戏端
		function DestroyGameClass(game:IGameClass):void;
		//获取限额
		function GetBetLimit(gameKind:int,limitID:int):Array;
		//获取会员编号
		function GetMeUserID():uint;
		//获取会员密码
		function GetMePassword():String;
		/**
		 * 设置筹码选择 
		 * @chips 二维数组(1:被选择的5个筹码数组,2:当前选择筹码)
		 */
		function SetSelectChips(chips:Array):void;
		//筹码选择
		function GetChipSelect(className:String):IChipSelect;
		//获取筹码选择
		function GetSelectChips():Array;
		//设置视频线路
		function SetVideoLine(index:int):void;
		//获取视频线路
		function GetVideoLine():int;
		//路子
		function GetHistoryRoad(className:String, gameRoad:Boolean = false):IHistoryResultManger;
		function GetFlipCard(className:String):IFlipCard;
		function GetChipView(index:int):MovieClip;
		//显示提示消息
		function ShowMessage(type:int,code:int,confirmfun:Function,confirmparam:Object,cancelfun:Function,cancelparam:Object):void;
		//显示注单
		function ShowStatement():void;
		//从游戏传回声音、音乐值
		function GetSoundSetting():Array;
		function SetSoundSetting(isMusic:Boolean,isSound:Boolean):void;
		//获取VIP限额编号
		function GetVipLimitID(limitType:int):int;
		//显示隐藏桌台列表
		function ShowHideTableListPane(bool:Boolean):void;
	}
}