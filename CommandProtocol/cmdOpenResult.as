package  CommandProtocol{
	
	public class cmdOpenResult {
		public var err:int;
		public var LookCard:int;
		public var LookTime:int;
		public function cmdOpenResult() {
			// constructor code
		}
		public static function FillData (datas:String):cmdOpenResult {
			var list:Array = datas.split(',');
			var _result:cmdOpenResult = new cmdOpenResult  ;
			_result.err = int(list[0]);
			_result.LookCard = int(list[1]);
			_result.LookTime = int(list[2]);
			return _result;
		}

		public function PushData ():String {
			var str:String = this.err + ',' + this.LookCard + ',' + this.LookTime;
			return str;
		}

	}
	
}
