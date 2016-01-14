package CommandProtocol{

	public class cmdBaccLookCard {
		public var Chair:int;
		public var Position:int;
		public var Index:int;
		public var Side:String;
		public var Show:Boolean;

		public function cmdBaccLookCard () {
		}

		public static function FillData (datas:String):cmdBaccLookCard {
			var list:Array = datas.split(',');
			var _result:cmdBaccLookCard = new cmdBaccLookCard  ;
			_result.Chair = int(list[0]);
			_result.Position = int(list[1]);
			_result.Index = int(list[2]);
			_result.Side = list[3];
			_result.Show = Tool.StringToBoolean(list[4]);

			return _result;
		}

		public function PushData ():String {
			var str:String = this.Chair + ',' + this.Position + ',' + this.Index + ',' + this.Side + ',' + this.Show;
			return str;
		}
	}

}