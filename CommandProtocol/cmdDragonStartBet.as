package CommandProtocol{

	public class cmdDragonStartBet {
		public var GameRoundNo:String;
		public var DiffTime:int;
		public var BootNo:String;

		public function cmdDragonStartBet() {
		}

		public static function FillData(datas:String):cmdDragonStartBet {
			var list:Array = datas.split(',');
			var _result:cmdDragonStartBet = new cmdDragonStartBet();
			_result.GameRoundNo = list[0];
			_result.DiffTime = int(list[1]);
			_result.BootNo = list[2];

			return _result;
		}

		public function PushData():String {
			var str:String = this.GameRoundNo + ',' + this.DiffTime + ',' + this.BootNo;
			return str;
		}
	}
}