package CommandProtocol{

	public class cmdMemberBalance {
		public var memID:int;
		public var Balance:Number;

		public function cmdMemberBalance () {
		}

		public static function FillData (datas:String):cmdMemberBalance {
			var list:Array = datas.split(',');
			var _result:cmdMemberBalance = new cmdMemberBalance  ;
			_result.memID = int(list[0]);
			_result.Balance = Number(list[1]);

			return _result;
		}

		public function PushData ():String {
			var str:String = this.memID + ',' + this.Balance;
			return str;
		}
	}
}