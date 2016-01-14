package  GameModule.Common{
	public class SoundConst {
		//gametype声音类型
		public static const Bacc_en:String ="Bacc_en";// 百家乐(english)
		public static const Bacc_zh:String ="Bacc_zh";// 百家乐(中文)
		public static const Roul_en:String ="Rou_en";// 轮盘(english)
		public static const Roul_ch:String ="Rou_ch";// 轮盘(中文)
		public static const Dran_en:String ="Dt_en";// 龙虎(english)
		public static const Dran_ch:String ="Dt_ch";// 龙虎(中文)
		//gameStatus游戏状态
		public static const EnterGame:String = "enter";// 进入游戏GameBaseClass.CreateGameClient
		public static const StartBet:String = "betstart";// 开始投注GameClass.SubGameSubCmd
		public static const BetSuccess:String = "betsuccess";// 投注成功GameBaseClass.BetReturnMessage
		public static const StopBet:String = "betstop";// 停止投注GameClass.SubGameSubCmd
		public static const GameWin:String = "win";// 游戏输赢PKShowBaseManager.ShowResultBg
		public static const GameResoult:String = "resoult";// 结果点数;PKShowBaseManager.ShowResultBg
		public static const ChangeBoot:String = "changeboot";// 更换牌靴;GameClass.SubGameSubCmd
		public static const ChangeTable:String = "changetable";// 更换桌台
		public static const LackBalance:String = "balance";// 余额不足GameBaseClass.OnSendBet
		public static const Thank:String = "thanks";// 感谢小费
		public static const NoBet:String = "nobet";// 没有下注GameBaseClass.SaveRepeatBetList
		public static const SitDown:String = "sitdown";// 坐下GameBaseClass.InitGameClass
		//gameWin游戏输赢；第1位:0和,1庄赢,2闲赢； 第2位:0无,1庄对；第3位:0无,1闲对
		public static const Banker:String = "100";// 庄赢
		public static const BankerP:String = "101";// 庄赢闲对
		public static const BankerB:String = "110";// 庄赢庄对
		public static const BankerBP:String = "111";// 庄赢庄对闲对
		public static const Tie:String = "000";// 和
		public static const TieP:String = "001";// 和闲对
		public static const TieB:String = "010";// 和庄对
		public static const TieBP:String = "011";// 和庄对闲对
		public static const Player:String = "200";// 闲赢
		public static const PlayerP:String = "201";// 闲赢闲对
		public static const PlayerB:String = "210";// 闲赢庄对
		public static const PlayerBP:String = "211";// 闲赢庄对闲对
		
		public static const DragDragon:String="1";//龙赢
		public static const DragTie:String="0";//和
		public static const DragTiger:String="2";//虎赢
		//gameResoult游戏结果点数/sitDown座位号
		//轮盘:0-36
		//百家乐:10-19表示庄点数.20-29表示闲点数。第1位表示庄,闲;第2位表示点数
		//龙虎:11-19,1a-1d表示龙点数21-29,2a-2d表示虎点数。第1位表示龙,虎;第2位表示点数
		public static const Zero:String = "0";// 0点
		public static const One:String = "1";// 1点/座位1
		public static const Two:String = "2";// 2点/座位2
		public static const Three:String = "3";// 3点/座位3
		public static const Four:String = "4";// 4点
		public static const Five:String = "5";// 5点/座位5
		public static const Six:String = "6";// 6点/座位6
		public static const Seven:String = "7";// 7点/座位7
		public static const Eight:String = "8";// 8点/座位8
		public static const Nine:String = "9";// 9点
		public static const Ten:String = "10";// 10点/庄0点
		public static const Eleven:String = "11";// 11点/庄1点/龙1点
		public static const Twelve:String = "12";// 12点/庄2点/龙2点
		public static const Thirteen:String = "13";// 13点/庄3点/龙3点
		public static const Fourteen:String = "14";// 14点/庄4点/龙4点
		public static const Fifteen:String = "15";// 15点/庄5点/龙5点
		public static const Sixteen:String = "16";// 16点/庄6点/龙6点
		public static const Seventeen:String = "17";// 17点/庄7点/龙7点
		public static const Eightteen:String = "18";// 18点/庄8点/龙8点
		public static const Nineteen:String = "19";// 19点/庄9点/龙9点
		public static const Twenty:String = "20";// 20点/闲0点
		public static const TwentyOne:String = "21";// 21点/闲1点/虎1点
		public static const TwentyTwo:String = "22";// 22点/闲2点/虎2点
		public static const TwentyThree:String = "23";// 23点/闲3点/虎3点
		public static const TwentyFour:String = "24";//24点/闲4点/虎4点
		public static const TwentyFive:String = "25";// 25点/闲5点/虎5点
		public static const TwentySix:String = "26";// 26点/闲6点/虎6点
		public static const TwentySeven:String = "27";// 27点/闲7点/虎7点
		public static const TwentyEight:String = "28";// 28点/闲8点/虎8点
		public static const TwentyNine:String = "29";// 29点/闲9点/虎9点
		public static const Thirty:String = "30";// 30点
		public static const ThirtyOne:String = "31";// 31点
		public static const ThirtyTwo:String = "32";// 32点
		public static const ThirtyThree:String = "33";// 33点
		public static const ThirtyFour:String = "34";// 34点
		public static const ThirtyFive:String = "35";// 35点
		public static const ThirtySix:String = "36";// 36点
		
		public static const DranTen:String = "110";// 龙10点
		public static const DranEleven:String = "111";// 龙J
		public static const DranTwelve:String = "112";// 龙Q
		public static const DranThirteen:String = "113";// 龙K
		public static const TigeTen:String = "210";// 虎10点
		public static const TigeEleven:String = "211";// 虎J
		public static const TigeTwelve:String = "212";// 虎Q
		public static const TigeThirteen:String = "213";// 虎K
	}
	
}
