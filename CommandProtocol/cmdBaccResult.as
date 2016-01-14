package CommandProtocol{

	public class cmdBaccResult {
		public var GameRoundNo:String;
		public var PlayerNumber:int;
		public var BankerNumber:int;
		public var RoadInfo:String;

		public function cmdBaccResult () {
		}

		public static function FillData (datas:String):cmdBaccResult {
			var list:Array = datas.split(',');
			var _result:cmdBaccResult = new cmdBaccResult  ;
			_result.GameRoundNo = list[0];
			_result.PlayerNumber = int(list[1]);
			_result.BankerNumber = int(list[2]);
			_result.RoadInfo = list[3];

			return _result;
		}

		public function PushData ():String {
			var str:String = this.GameRoundNo + ',' + this.PlayerNumber + ',' + this.BankerNumber + ',' + this.RoadInfo;
			return str;
		}
	}

}