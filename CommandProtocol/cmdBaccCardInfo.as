package CommandProtocol{

	public class cmdBaccCardInfo {
		public var GameRoundNo:String;
		public var Position:int;
		public var Index:int;
		public var CardNum:int;
		public var IsLookCard:Boolean;

		public function cmdBaccCardInfo () {
		}

		public static function FillData (datas:String):cmdBaccCardInfo {
			var list:Array = datas.split(',');
			var _result:cmdBaccCardInfo = new cmdBaccCardInfo  ;
			_result.GameRoundNo = list[0];
			_result.Position = int(list[1]);
			_result.Index = int(list[2]);
			_result.CardNum = int(list[3]);
			_result.IsLookCard = Tool.StringToBoolean(list[4]);

			return _result;
		}

		public function PushData ():String {
			var str:String = this.GameRoundNo + ',' + this.Position + ',' + this.Index + ',' + this.CardNum + ',' + this.IsLookCard;
			return str;
		}
	}

}