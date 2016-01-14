package CommandProtocol{

	public class cmdMemberBetBack {
		public var memID:int;
		public var Chair:int;
		public var BetPosition:int;
		public var err:int;
		public var BetAmount:Number;

		public function cmdMemberBetBack() {
		}

		public static function FillData(datas:String):cmdMemberBetBack {
			var list:Array = datas.split(',');
			var _result:cmdMemberBetBack = new cmdMemberBetBack  ;
			_result.memID = int(list[0]);
			_result.Chair = int(list[1]);
			_result.BetPosition = int(list[2]);
			_result.err = int(list[3]);
			_result.BetAmount = Number(list[4]);

			return _result;
		}

		public function PushData():String {
			var str:String = this.memID + ',' + this.Chair + ',' + this.BetPosition + ',' + this.err + ',' + this.BetAmount;
			return str;
		}
	}
}