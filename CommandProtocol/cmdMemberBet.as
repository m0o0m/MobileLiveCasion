package CommandProtocol{

	public class cmdMemberBet {
		public var memID:int;
		public var TableID:int;
		public var Chair:int;
		public var GameRoundNo:String;
		public var BetPosition:String;
		public var BetAmount:String;

		public function cmdMemberBet() {
		}

		public static function FillData(datas:String):cmdMemberBet {
			var list:Array = datas.split(',');
			var _result:cmdMemberBet = new cmdMemberBet  ;
			_result.memID = int(list[0]);
			_result.TableID = int(list[1]);
			_result.Chair = int(list[2]);
			_result.GameRoundNo = list[3];
			_result.BetPosition = list[4];
			_result.BetAmount = list[5];

			return _result;
		}

		public function PushData():String {
			var str:String = this.memID + ',' + this.TableID + ',' + this.Chair + ',' + this.GameRoundNo + ',' + this.BetPosition + ',' + this.BetAmount;
			return str;
		}
	}
}