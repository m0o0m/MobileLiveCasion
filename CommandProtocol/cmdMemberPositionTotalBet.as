package CommandProtocol{

	public class cmdMemberPositionTotalBet {
		public var memID:int;
		public var Chair:int;
		public var TotalBet:String;

		public function cmdMemberPositionTotalBet() {
		}

		public static function FillData(datas:String):cmdMemberPositionTotalBet {
			var list:Array = datas.split(',');
			var _result:cmdMemberPositionTotalBet = new cmdMemberPositionTotalBet  ;
			_result.memID = int(list[0]);
			_result.Chair = int(list[1]);
			_result.TotalBet = list[2];

			return _result;
		}

		public function PushData():String {
			var str:String = this.memID + ',' + this.Chair + ',' + this.TotalBet;
			return str;
		}
	}
}