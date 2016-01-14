package CommandProtocol{

	public class cmdMemberTableDealer {
		public var TableID:int;
		public var Dealer:String;

		public function cmdMemberTableDealer() {
		}

		public static function FillData(datas:String):cmdMemberTableDealer {
			var list:Array = datas.split(',');
			var _result:cmdMemberTableDealer = new cmdMemberTableDealer  ;
			_result.TableID = int(list[0]);
			_result.Dealer = list[1];

			return _result;
		}

		public function PushData():String {
			var str:String = this.TableID + ',' + this.Dealer;
			return str;
		}
	}
}