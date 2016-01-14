package CommandProtocol{

	public class cmdDragonCardInfo {
		public var GameRoundNo:String;
		public var Position:int;
		public var CardNum:int;

		public function cmdDragonCardInfo() {
		}

		public static function FillData(datas:String):cmdDragonCardInfo {
			var list:Array = datas.split(',');
			var _result:cmdDragonCardInfo = new cmdDragonCardInfo();
			_result.GameRoundNo = list[0];
			_result.Position = int(list[1]);
			_result.CardNum = int(list[2]);

			return _result;
		}

		public function PushData():String {
			var str:String = this.GameRoundNo + ',' + this.Position + ',' + this.CardNum;
			return str;
		}
	}
}