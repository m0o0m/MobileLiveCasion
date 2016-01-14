package CommandProtocol{

	public class cmdMemberInfo {
		public var memID:int;
		public var Chair:int;
		public var MoneyID:int;
		public var ShowName:String;
		public var Balance:Number;

		public function cmdMemberInfo() {
		}

		public static function FillData(datas:String):cmdMemberInfo {
			var list:Array = datas.split(',');
			var _result:cmdMemberInfo = new cmdMemberInfo  ;
			_result.memID = int(list[0]);
			_result.Chair = int(list[1]);
			_result.MoneyID = int(list[2]);
			_result.ShowName = list[3];
			_result.Balance = Number(list[4]);

			return _result;
		}

		public function PushData():String {
			var str:String = this.memID + ',' + this.Chair + ',' + this.MoneyID + ',' + this.ShowName + ',' + this.Balance;
			return str;
		}
	}
}