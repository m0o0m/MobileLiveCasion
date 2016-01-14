package CommandProtocol{

	public class cmdMemberSitResult {
		public var errID:int;
		public var Chair:int;
		public var LookOn:Boolean;

		public function cmdMemberSitResult() {
		}

		public static function FillData(datas:String):cmdMemberSitResult {
			var list:Array = datas.split(',');
			var _result:cmdMemberSitResult = new cmdMemberSitResult  ;
			_result.errID = int(list[0]);
			_result.Chair = int(list[1]);
			_result.LookOn = Tool.StringToBoolean(list[2]);

			return _result;
		}

		public function PushData():String {
			var str:String = this.errID + ',' + this.Chair + ',' + this.LookOn;
			return str;
		}
	}
}