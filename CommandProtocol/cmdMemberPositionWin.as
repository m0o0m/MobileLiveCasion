package CommandProtocol{

	public class cmdMemberPositionWin {
		public var memID:int;
		public var Chair:int;
		public var TotalWin:String;

		public function cmdMemberPositionWin() {
		}

		public static function FillData(datas:String):cmdMemberPositionWin {
			var list:Array = datas.split(',');
			var _result:cmdMemberPositionWin = new cmdMemberPositionWin  ;
			_result.memID = int(list[0]);
			_result.Chair = int(list[1]);
			_result.TotalWin = list[2];

			return _result;
		}

		public function PushData():String {
			var str:String = this.memID + ',' + this.Chair + ',' + this.TotalWin;
			return str;
		}
	}
}