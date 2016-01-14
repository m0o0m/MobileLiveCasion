package CommandProtocol{

	public class cmdMemberSitDown {
		public var memID:int;
		public var LoginCode:String;
		public var TableID:int;
		public var blID:int;
		public var LookOn:Boolean;
		public var Host:Boolean;
		public var SitPassword:String;

		public function cmdMemberSitDown() {
		}

		public static function FillData(datas:String):cmdMemberSitDown {
			var list:Array = datas.split(',');
			var _result:cmdMemberSitDown = new cmdMemberSitDown  ;
			_result.memID = int(list[0]);
			_result.LoginCode = list[1];
			_result.TableID = int(list[2]);
			_result.blID = int(list[3]);
			_result.LookOn = Tool.StringToBoolean(list[4]);
			_result.Host = Tool.StringToBoolean(list[5]);
			_result.SitPassword = list[6];

			return _result;
		}

		public function PushData():String {
			var str:String = this.memID + ',' + this.LoginCode + ',' + this.TableID + ',' + this.blID + ',' + this.LookOn + ',' + this.Host + ',' + this.SitPassword;
			return str;
		}
	}
}