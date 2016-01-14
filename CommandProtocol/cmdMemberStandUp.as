package CommandProtocol{

	public class cmdMemberStandUp {
		public var memID:int;
		public var Chair:int;
		public var errID:int;

		public function cmdMemberStandUp() {
		}

		public static function FillData(datas:String):cmdMemberStandUp {
			var list:Array = datas.split(',');
			var _result:cmdMemberStandUp = new cmdMemberStandUp  ;
			_result.memID = int(list[0]);
			_result.Chair = int(list[1]);
			_result.errID = int(list[2]);

			return _result;
		}

		public function PushData():String {
			var str:String = this.memID + ',' + this.Chair + ',' + this.errID;
			return str;
		}
	}
}