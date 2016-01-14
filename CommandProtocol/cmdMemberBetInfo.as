package CommandProtocol{

	public class cmdMemberBetInfo {
		public var memID:int;
		public var TableID:int;
		public var Chair:int;
		public var BetPosition:int;
		public var BetAmount:Number;

		public function cmdMemberBetInfo () {
		}

		public static function FillData (datas:String):cmdMemberBetInfo {
			var list:Array = datas.split(',');
			var _result:cmdMemberBetInfo = new cmdMemberBetInfo  ;
			_result.memID = int(list[0]);
			_result.TableID = int(list[1]);
			_result.Chair = int(list[2]);
			_result.BetPosition = int(list[3]);
			_result.BetAmount = Number(list[4]);

			return _result;
		}

		public function PushData ():String {
			var str:String = this.memID + ',' + this.TableID + ',' + this.Chair + ',' + this.BetPosition + ',' + this.BetAmount;
			return str;
		}
	}
}