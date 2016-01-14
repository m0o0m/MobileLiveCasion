package CommandProtocol{

	public class cmdMemberLoginToLobby {
		public var MID:int;
		public var CID:int;
		public var PWD:String;

		public function cmdMemberLoginToLobby () {
		}

		public static function FillData (datas:String):cmdMemberLoginToLobby {
			var list:Array = datas.split(',');
			var _result:cmdMemberLoginToLobby = new cmdMemberLoginToLobby  ;
			_result.MID = int(list[0]);
			_result.CID = int(list[1]);
			_result.PWD = list[2];

			return _result;
		}

		public function PushData ():String {
			var str:String = this.MID + ',' + this.CID + ',' + this.PWD;
			return str;
		}
	}
}