package CommandProtocol{

	public class cmdRouletteResult {
		public var GameRoundNo:String;
		public var BallNum:String;

		public function cmdRouletteResult () {
		}

		public static function FillData (datas:String):cmdRouletteResult {
			var list:Array = datas.split(',');
			var _result:cmdRouletteResult = new cmdRouletteResult  ;
			_result.GameRoundNo = list[0];
			_result.BallNum = list[1];

			return _result;
		}

		public function PushData ():String {
			var str:String = this.GameRoundNo + ',' + this.BallNum;
			return str;
		}
	}
}