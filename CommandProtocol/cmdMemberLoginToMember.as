package CommandProtocol{

	public class cmdMemberLoginToMember {
		public var errID:int;
		public var memID:int;
		public var Account:String;
		public var ShowName:String;
		public var CasinoVIP:Boolean;
		public var LoginCode:String;

		public function cmdMemberLoginToMember () {
		}

		public static function FillData (datas:String):cmdMemberLoginToMember {
			var list:Array = datas.split(',');
			var _result:cmdMemberLoginToMember = new cmdMemberLoginToMember  ;
			_result.errID = int(list[0]);
			_result.memID = int(list[1]);
			_result.Account = list[2];
			_result.ShowName = list[3];
			_result.CasinoVIP = Tool.StringToBoolean(list[4]);
			_result.LoginCode = list[5];

			return _result;
		}

		public function PushData ():String {
			var str:String = this.errID + ',' + this.memID + ',' + this.Account + ',' + this.ShowName + ',' + this.CasinoVIP + ',' + this.LoginCode;
			return str;
		}
	}
}