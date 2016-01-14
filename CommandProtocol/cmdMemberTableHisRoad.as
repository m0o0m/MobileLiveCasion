package CommandProtocol{

	public class cmdMemberTableHisRoad {
		public var TableID:int;
		public var HisRoad:String;

		public function cmdMemberTableHisRoad() {
		}

		public static function FillData(datas:String):cmdMemberTableHisRoad {
			var list:Array = datas.split(',');
			var _result:cmdMemberTableHisRoad = new cmdMemberTableHisRoad  ;
			_result.TableID = int(list[0]);
			_result.HisRoad = list[1];

			return _result;
		}

		public function PushData():String {
			var str:String = this.TableID + ',' + this.HisRoad;
			return str;
		}
	}
}