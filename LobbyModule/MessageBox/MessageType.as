package LobbyModule.MessageBox{
	
	public class MessageType {
		public static const Gameclient:int=100;
		public static const SitDownError:int=200;
		public static const StandUpError:int=300;
		
		public static const Lobby_OffLine:int=0;//大厅断线
		public static const Lobby_ExitGame:int=1;//退出游戏
		public static const Lobby_OtherLogin:int=2;//别处登录
		public static const Game_OffLine:int=3;//游戏断线
		public static const Game_StandUp:int=4;//站起
		public static const Game_NotVip:int=5;//不是Vip賬號
		public static const Game_PassWord:int=6;//输入桌子密码
		public static const Game_UptPassWordSuccess:int=8;//密码修改成功
		public static const Game_BalanceFive:int=9;//小于5倍最小限额
		public static const Game_BalanceOne:int=10;//小于5倍最小限额
		public static const Game_ChangeShoe:int=11;//更换牌靴
		public static const Game_ChangeDealer:int=12;//更换荷官
		
		/*public static const Game_ShotOff:int=101;//账号被踢出3次,无法包桌
		public static const Game_MemberFull102:int=102;//该桌位置已坐满
		public static const Game_NeedVip:int=103;//需VIP账号进入游戏
		public static const Game_HaveHost105:int=105;//已有桌主,无法包桌
		public static const Game_HaveHost106:int=106;//已有桌主,无法包桌
		public static const Game_NoHost:int=107;//桌台没有桌主
		public static const Game_PassWordWrong:int=108;//桌子密码错误
		public static const Game_MemberFull109:int=109;//该桌位置已坐满*/
	}
}