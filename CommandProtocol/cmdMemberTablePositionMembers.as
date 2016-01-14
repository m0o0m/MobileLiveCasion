package CommandProtocol{

	public class cmdMemberTablePositionMembers {
		public var TableID:int;
		public var PositionMembers:String;

		public function cmdMemberTablePositionMembers() {
		}

		public static function FillData(datas:String):cmdMemberTablePositionMembers {
			var list:Array = datas.split(',');
			var _result:cmdMemberTablePositionMembers = new cmdMemberTablePositionMembers  ;
			_result.TableID = int(list[0]);
			_result.PositionMembers = list[1];

			return _result;
		}

		public function PushData():String {
			var str:String = this.TableID + ',' + this.PositionMembers;
			return str;
		}
	}
}