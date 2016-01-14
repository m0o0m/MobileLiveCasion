package CommandProtocol{

	public class SitDownError {
		public static const SitSuccess:int = 0;
		public static const SystemError:int = 1;
		public static const VIPMoreThreeNotBet:int = 2;
		public static const SeatError:int = 3;
		public static const NotVIP:int = 4;
		public static const Insufficient:int = 5;
		public static const ChairNumError:int = 6;
		public static const NoChairForHost:int = 7;
		public static const AlreadyHaveHostMember:int = 8;
		public static const NoHostMember:int = 9;
		public static const TablePasswordError:int = 10;
		public static const NoEmptyChair:int = 11;
		public static const SeatErrorForHaveBet:int=12;
	}
}