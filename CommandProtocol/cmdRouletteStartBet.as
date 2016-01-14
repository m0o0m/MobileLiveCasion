package CommandProtocol{

	public class cmdRouletteStartBet {
		public var GameRoundNo:String;
		public var DiffTime:int;

		public function cmdRouletteStartBet () {
		}

		public static function FillData (datas:String):cmdRouletteStartBet {
			var list:Array = datas.split(',');
			var _result:cmdRouletteStartBet = new cmdRouletteStartBet  ;
			_result.GameRoundNo = list[0];
			_result.DiffTime = int(list[1]);

			return _result;
		}

		public function PushData ():String {
			var str:String = this.GameRoundNo + ',' + this.DiffTime;
			return str;
		}
	}
}