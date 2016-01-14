package CommandProtocol{

	public class cmdDragonResult {
		public var GameRoundNo:String;
		public var Result:String;

		public function cmdDragonResult() {
		}

		public static function FillData(datas:String):cmdDragonResult {
			var list:Array = datas.split(',');
			var _result:cmdDragonResult = new cmdDragonResult();
			_result.GameRoundNo = list[0];
			_result.Result = list[1];

			return _result;
		}

		public function PushData():String {
			var str:String = this.GameRoundNo + ',' + this.Result;
			return str;
		}
	}
}