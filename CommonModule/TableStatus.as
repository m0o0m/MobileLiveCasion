package CommonModule{

	public class TableStatus {
		public static const PausedTable:int = 0;//展厅桌面游戏
		public static const BettingGame:int = 1;//正在投注
		public static const BettedGame:int = 2;//投注完成
		public static const OpenningResult:int = 3;//正在开游戏结果
		public static const OpennedResult:int = 4;//游戏结果已开出
		public static const CalculatingWinLose:int = 5;//正在结算
		public static const CalculatedWinLose:int = 6;//结算完毕
		public static const ChangingBoot:int = 7;//更换牌靴
		public static const ChangedBoot:int = 8;//牌靴更换完毕
		public static const ChangingDealer:int = 9;//正在更换荷官
		public static const ChangedDealer:int = 10;//荷官更换完毕
	}
}