package  {
	import flash.display.Sprite;
	import flash.utils.Dictionary;
	import CommandProtocol.*;
	import IGameFrame.IHistoryResultManger;
	public class MoreGameRoomPane extends RoomPane{
		protected var m_selectTableId:Array;//被选中桌台
		protected var m_moreGame:MoreGameContainer;
		public function MoreGameRoomPane() {
			// constructor code
			super();
		}
		//新添加桌子
		public override function AddTable(table:cmdMemberTableInfo):void {
			if (table != null) {
				if (m_tableList[table.TableID] == null) {
					var tp:MoreGameTablePane = new MoreGameTablePane();
					switch (table.GameKind) {
						case GameKindEnum.Baccarat :
						case GameKindEnum.InsuranceBaccarat :
						case GameKindEnum.VipBaccarat :
							tp = new BaccaratMoreGameTablePane();
							break;
						case GameKindEnum.Roulette :
							tp = new RouletteMoreGameTablePane();
							break;
						case GameKindEnum.DragonTiger :
							tp = new DragonTigerMoreGameTablePane();
							break;
					}
					if (tp) {
						tp.IChangLang(lang);
						tp.SetRoomPane(this);
						tp.SetTableInfo(table);
						m_tableList[table.TableID] = tp;
						addChild(tp);
						m_tableCount++;

						if (m_tableSort == null) {
							m_tableSort = new Array();
						}
						if (m_tableSort.indexOf(table.TableID) == -1) {
							m_tableSort.push(table.TableID);
						}
					}
				} else {
					tp = m_tableList[table.TableID] as MoreGameTablePane;
					tp.IChangLang(lang);
					tp.SetTableInfo(table);
				}
				m_langList.push (tp);
			}
		}
		public override  function ShowTable():void {
			if(m_selectTableId==null){
				return;
			}
			var showCount:int = 0;
			for each (var showTableID in m_tableSort) {
				var isNo:Boolean=false;
				var tp:MoreGameTablePane = m_tableList[showTableID] as MoreGameTablePane;
				for(var index:int=0;index<m_selectTableId.length;index++){
					if(showTableID==m_selectTableId[index]){
						tp.visible = false;
						isNo=true;
					}
				}
				if(isNo==false){
				tp.visible = true;
				var pRow:int = showCount;
				var pCell:int = 1;
				tp.x = 1;
				tp.y = pRow * 438 + pRow * 1;
				showCount++;
				}
			}
		}
		public function SetMoreGameContainer(moregame:MoreGameContainer):void{
			m_moreGame=moregame;
		}
		public function SetSelectTable(tableId:Array):void{
			m_selectTableId=tableId;
		}
		public function ChangGameTable(tableID:uint, gameIndex:int):void{
			if(m_moreGame){
				m_moreGame.ChangGameTable(tableID,gameIndex);
			}
		}

	}
	
}
