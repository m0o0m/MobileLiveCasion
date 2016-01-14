
package CommandProtocol{

	public class cmdMemberTableInfo {
		public var TableID:int;
		public var TableName:String;
		public var TablePhone:String;
		public var RoomID:int;
		public var GameKind:int;
		public var ServerIP:String;
		public var ServerPort:int;
		public var LiveVideo1:String;
		public var LiveVideo2:String;
		public var LiveVideo3:String;
		public var LiveVideo4:String;
		public var LimitType:int;
		public var Dealer:String;
		public var Status:int;
		public var GameRoundNo:String;
		public var BetTime:int;
		public var DiffTime:int;
		public var SortNum:int;
		public var OnlineMembers:int;
		public var TotalCredit:Number;
		public var HostMember:int;
		public var NeedPassword:Boolean;
		public var PrivateTable:Boolean;
		public var PositionMembers:String;
		public var PositionTotalBet:String;
		public var HisRoad:String;
		public var ControlMode:int;

		public function cmdMemberTableInfo() {
		}

		public static function FillData(datas:String):cmdMemberTableInfo {
			var list:Array = datas.split(',');
			var _result:cmdMemberTableInfo = new cmdMemberTableInfo  ;
			_result.TableID = int(list[0]);
			_result.TableName = list[1];
			_result.TablePhone = list[2];
			_result.RoomID = int(list[3]);
			_result.GameKind = int(list[4]);
			_result.ServerIP = list[5];
			_result.ServerPort = int(list[6]);
			_result.LiveVideo1 = list[7];
			_result.LiveVideo2 = list[8];
			_result.LiveVideo3 = list[9];
			_result.LiveVideo4 = list[10];
			_result.LimitType = int(list[11]);
			_result.Dealer = list[12];
			_result.Status = int(list[13]);
			_result.GameRoundNo = list[14];
			_result.BetTime = int(list[15]);
			_result.DiffTime = int(list[16]);
			_result.SortNum = int(list[17]);
			_result.OnlineMembers = int(list[18]);
			_result.TotalCredit = Number(list[19]);
			_result.HostMember = int(list[20]);
			_result.NeedPassword = Tool.StringToBoolean(list[21]);
			_result.PrivateTable = Tool.StringToBoolean(list[22]);
			_result.PositionMembers = list[23];
			_result.PositionTotalBet = list[24];
			_result.HisRoad = list[25];
			_result.ControlMode = int(list[26]);

			return _result;
		}

		public function PushData():String {
			var str:String = this.TableID + ',' + this.TableName + ',' + this.TablePhone + ',' + this.RoomID + ',' + this.GameKind + ',' + this.ServerIP + ',' + this.ServerPort + ',' + this.LiveVideo1 + ',' + this.LiveVideo2 + ',' + this.LiveVideo3 + ',' + this.LiveVideo4 + ',' + this.LimitType + ',' + this.Dealer + ',' + this.Status + ',' + this.GameRoundNo + ',' + this.BetTime + ',' + this.DiffTime + ',' + this.SortNum + ',' + this.OnlineMembers + ',' + this.TotalCredit + ',' + this.HostMember + ',' + this.NeedPassword + ',' + this.PrivateTable + ',' + this.PositionMembers + ',' + this.PositionTotalBet + ',' + this.HisRoad + ',' + this.ControlMode;
			return str;
		}
	}
}