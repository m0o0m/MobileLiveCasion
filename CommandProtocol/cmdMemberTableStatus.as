package CommandProtocol{

	public class cmdMemberTableStatus {
		public var TableID:int;
		public var Status:int;
		public var GameRoundNo:String;
		public var DiffTime:int;
		public var OnlineMembers:int;
		public var TotalCredit:Number;
		public var HostMember:int;
		public var NeedPassword:Boolean;
		public var PrivateTable:Boolean;

		public function cmdMemberTableStatus() {
		}

		public static function FillData(datas:String):cmdMemberTableStatus {
			var list:Array = datas.split(',');
			var _result:cmdMemberTableStatus = new cmdMemberTableStatus();
			_result.TableID = int(list[0]);
			_result.Status = int(list[1]);
			_result.GameRoundNo = list[2];
			_result.DiffTime = int(list[3]);
			_result.OnlineMembers = int(list[4]);
			_result.TotalCredit = Number(list[5]);
			_result.HostMember = int(list[6]);
			_result.NeedPassword = Tool.StringToBoolean(list[7]);
			_result.PrivateTable = Tool.StringToBoolean(list[8]);

			return _result;
		}

		public function PushData():String {
			var str:String = this.TableID + ',' + this.Status + ',' + this.GameRoundNo + ',' + this.DiffTime + ',' + this.OnlineMembers + ',' + this.TotalCredit + ',' + this.HostMember + ',' + this.NeedPassword + ',' + this.PrivateTable;
			return str;
		}
	}
}