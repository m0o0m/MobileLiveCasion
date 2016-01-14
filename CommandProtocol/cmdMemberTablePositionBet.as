package CommandProtocol{

	public class cmdMemberTablePositionBet {
		public var TableID:int;
		public var PositionBet:String;

		public function cmdMemberTablePositionBet() {
		}

		public static function FillData(datas:String):cmdMemberTablePositionBet {
			var list:Array = datas.split(',');
			var _result:cmdMemberTablePositionBet = new cmdMemberTablePositionBet  ;
			_result.TableID = int(list[0]);
			_result.PositionBet = list[1];

			return _result;
		}

		public function PushData():String {
			var str:String = this.TableID + ',' + this.PositionBet;
			return str;
		}
	}
}