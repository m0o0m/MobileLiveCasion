package CommandProtocol{

	public class cmdMemberChangeChairBack {
		public var err:int;
		public var OldChair:int;
		public var NewChair:int;

		public function cmdMemberChangeChairBack() {
		}

		public static function FillData(datas:String):cmdMemberChangeChairBack {
			var list:Array = datas.split(',');
			var _result:cmdMemberChangeChairBack = new cmdMemberChangeChairBack  ;
			_result.err = int(list[0]);
			_result.OldChair = int(list[1]);
			_result.NewChair = int(list[2]);

			return _result;
		}

		public function PushData():String {
			var str:String = this.err + ',' + this.OldChair + ',' + this.NewChair;
			return str;
		}
	}
}