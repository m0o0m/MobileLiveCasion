package {
	import flash.display.Sprite;
	import flash.utils.Dictionary;
	import CommandProtocol.*;
	import IGameFrame.IHistoryResultManger;
	import IGameFrame.IChangLang;
	import flash.events.MouseEvent;

	public class RoomPane extends Sprite implements IChangLang {
		var m_lobbyWindow:TBSLobbyWindow;

		protected var m_tableList:Dictionary;//桌子列表
		protected var m_tableSort:Array;//桌子排序
		protected var m_tableCount:int = 0;

		public var m_tableWidth:int = 474.00;//桌子宽
		public var m_tableHeight:int = 452.00;//桌子高
		public var m_CellCount:int = 3;//每一行显示多少个桌子
		public var m_RowSpace:int = 14;//行间距

		protected var m_enterTableID:uint;//进入游戏tableID

		protected var m_MoneyType:String;//货币类型
		protected var m_langList:Array;//需切换语言数组
		protected var lang:String;
		protected var m_VipStatus:Boolean;

		protected var m_otherTablePaneList:Array;//即将推出桌台
		public function RoomPane () {
			m_tableList = new Dictionary  ;
			m_langList = new Array  ;
		}
		public function SetLobbyWindow (lw:TBSLobbyWindow):void {
			m_lobbyWindow = lw;
		}
		public function GetMeUserID ():int {
			if (m_lobbyWindow) {
				return m_lobbyWindow.GetMeUserID();
			}
			return 0;
		}
		public function GetHistoryRoad (className:String):IHistoryResultManger {
			return m_lobbyWindow.GetHistoryRoad(className);
		}
		public function Destroy ():void {
			for (var key in m_tableList) {
				var table:TablePane = m_tableList[key] as TablePane;
				table.Destroy ();
				removeChild (table);

				m_tableList[key] = null;
				delete m_tableList[key];
			}
			m_lobbyWindow = null;
		}
		//显示限额
		public function ShowLimitPane (limit:Array,tableID:uint,host:Boolean,more:Boolean,lookon:Boolean,moneyType:String):void {
			if ((m_lobbyWindow != null)) {
				return m_lobbyWindow.ShowLimitPane(limit,tableID,host,more,lookon,moneyType);
			}
		}
		//进入游戏
		public function EnterGame (tableID:uint,limitID:int,host:Boolean,more:Boolean,lookon:Boolean):Boolean {
			if ((m_lobbyWindow != null)) {
				return m_lobbyWindow.EnterGame(tableID,limitID,host,more,lookon);
			}
			return false;
		}
		public function SetEnterTableID (tableID:uint):void {
			m_enterTableID = tableID;
		}
		//新添加桌子
		public function AddTable (table:cmdMemberTableInfo):void {
			if ((table != null)) {
				if (m_tableList[table.TableID] == null) {
					var tp:TablePane = null;
					switch (table.GameKind) {
						case GameKindEnum.Baccarat :
						case GameKindEnum.InsuranceBaccarat :
						case GameKindEnum.ShareLookBaccarat :
							tp = new BaccaratTablePane  ;
							break;
						case GameKindEnum.Roulette :
							tp = new RouletteTablePane  ;
							break;
						case GameKindEnum.DragonTiger :
							tp = new DragonTigerTablePane  ;
							break;
					}
					if (tp) {
						tp.IChangLang (lang);
						tp.SetRoomPane (this);
						tp.SetTableInfo (table);
						tp.SetMoneyType (m_MoneyType);
						m_tableList[table.TableID] = tp;
						addChild (tp);
						m_tableCount++;

						if ((m_tableSort == null)) {
							m_tableSort = new Array  ;
						}
						if (m_tableSort.indexOf(table.TableID) == -1) {
							m_tableSort.push (table.TableID);
						}
					}
				} else {
					tp = m_tableList[table.TableID] as TablePane;
					tp.IChangLang (lang);
					tp.SetTableInfo (table);
				}
				m_langList.push (tp);
			}
		}
		public function ShowTable ():void {
			var showCount:int = 0;
			for each (var showTableID in m_tableSort) {
				var tp:TablePane = m_tableList[showTableID] as TablePane;
				tp.visible = true;
				var page:int=showCount/6;
				var pRow:int = (showCount-page*6) / m_CellCount;
				var pCell:int = showCount % m_CellCount+page*m_CellCount;
				tp.x = pCell * m_tableWidth+ pCell *2;
				tp.y = pRow * m_tableHeight + pRow * m_RowSpace;
				showCount++;
			}
		}
		//显示历史结果(路子)
		public function SetTableHisRoad (hisRoad:cmdMemberTableHisRoad):void {
			if (((hisRoad && m_tableList) && m_tableList[hisRoad.TableID])) {
				var table:TablePane = m_tableList[hisRoad.TableID] as TablePane;
				if (table) {
					table.SetTableHisRoad (hisRoad);
				}
			}
		}
		//显示桌面投注
		public function SetTablePositionBet (betPos:cmdMemberTablePositionBet):void {
			if (((m_tableList && betPos) && m_tableList[betPos.TableID])) {
				var table:TablePane = m_tableList[betPos.TableID] as TablePane;
				if (table) {
					table.SetTablePositionBet (betPos);
				}
			}
		}
		//显示桌面投注
		public function SetTablePositionMembers (memPos:cmdMemberTablePositionMembers):void {
			if (((m_tableList && memPos) && m_tableList[memPos.TableID])) {
				var table:TablePane = m_tableList[memPos.TableID] as TablePane;
				if (table) {
					table.SetTablePositionMembers (memPos);
				}
			}
		}
		//显示游戏状态
		public function SetTableStatus (tableStatus:cmdMemberTableStatus):void {
			if (((m_tableList && tableStatus) && m_tableList[tableStatus.TableID])) {
				var table:TablePane = m_tableList[tableStatus.TableID] as TablePane;
				if (table) {
					table.SetTableStatus (tableStatus);
				}
			}
		}
		public function SetTableDealer (dealer:cmdMemberTableDealer):void {
			if (((m_tableList && dealer) && m_tableList[dealer.TableID])) {
				var table:TablePane = m_tableList[dealer.TableID] as TablePane;
				if (table) {
					table.SetTableDealer (dealer);
				}
			}
		}
		public function SetBetLimit (tableID:int,limit:Array):void {
			if ((m_tableList && m_tableList[tableID])) {
				var table:TablePane = m_tableList[tableID] as TablePane;
				if (table) {
					table.SetBetLimit (limit);
				}
			}
		}
		public function SetMoneyType (moneyType:String):void {
			m_MoneyType = moneyType;
		}
		public function IChangLang (strLang:String):void {
			if (strLang) {
				lang = strLang;
				var index:int = 0;
				var len:int=m_langList.length;
				for (index; index <len; index++) {
					if (m_langList[index]) {
						m_langList[index].IChangLang (strLang);
					}
				}
			}
		}
		public function SetVipStatus (vipstatus:Boolean):void {
			m_VipStatus = vipstatus;
		}
		//添加页面按钮for TableListPane
		public function GetPageCount ():int {
			var len:int = m_tableSort.length - 1;
			var pageCount:int = len % 6;//分页数
			switch (pageCount) {
				case 0 :
					pageCount = len / 6;
					break;
				case 1 :
				case 2 :
				case 3 :
				case 4 :
				case 5 :
					if (((len / 6) == 0)) {
						pageCount == 1;
					} else {
						pageCount = len / 6 + 1;
					}
					break;
			}
			return pageCount;
		}
		//隐藏table
		protected function HideTableList ():void {
			for each (var showTableID in m_tableSort) {
				var tp:TablePane = m_tableList[showTableID] as TablePane;
				tp.visible = false;
			}
		}
}
}