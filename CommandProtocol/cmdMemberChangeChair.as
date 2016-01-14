package CommandProtocol{

	public class cmdMemberChangeChair {
		public var TableID:int;
		public var Chair:int;

		public function cmdMemberChangeChair() {
		}

		public static function FillData(datas:String):cmdMemberChangeChair {
			var list:Array = datas.split(',');
			var _result:cmdMemberChangeChair = new cmdMemberChangeChair  ;
			_result.TableID = int(list[0]);
			_result.Chair = int(list[1]);

			return _result;
		}

		public function PushData():String {
			var str:String = this.TableID + ',' + this.Chair;
			return str;
		}
	}
}