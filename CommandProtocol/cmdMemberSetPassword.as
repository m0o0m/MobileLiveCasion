package CommandProtocol{

	public class cmdMemberSetPassword {
		public var TableID:int;
		public var pwd:String;

		public function cmdMemberSetPassword() {
		}

		public static function FillData(datas:String):cmdMemberSetPassword {
			var list:Array = datas.split(',');
			var _result:cmdMemberSetPassword = new cmdMemberSetPassword  ;
			_result.TableID = int(list[0]);
			_result.pwd = list[1];

			return _result;
		}

		public function PushData():String {
			var str:String = this.TableID + ',' + this.pwd;
			return str;
		}
	}
}