package CommandProtocol{

	public class cmdBaccStartBetToMember {
		public var GameRoundNo:String;
        public var BetTime:int;
		public var DiffTime:int;
        public var Reset:Boolean;//是否重置桌面数据
        public var Insurance:int;//0=普通投注；1=闲保险；2=庄保险
        public var MaxBetRate:Number;
        public var Odds:Number;

		public function cmdBaccStartBetToMember () {
		}

		public static function FillData (datas:String):cmdBaccStartBetToMember {
			var list:Array = datas.split(',');
			var _result:cmdBaccStartBetToMember = new cmdBaccStartBetToMember  ;
			_result.GameRoundNo = list[0];
			_result.BetTime = int(list[1]);
			_result.DiffTime = int(list[2]);
			_result.Reset = Tool.StringToBoolean(list[3]);
			_result.Insurance = int(list[4]);
			_result.MaxBetRate = Number(list[5]);
			_result.Odds = Number(list[6]);

			return _result;
		}

		public function PushData ():String {
			var str:String = this.GameRoundNo + ',' + this.BetTime + ',' + this.DiffTime + ',' + this.Reset + ',' + this.Insurance + ',' + this.MaxBetRate + ',' + this.Odds;
			return str;
		}
	}

}