package HistoryRoad{
	
	import flash.utils.getDefinitionByName;

	/**
	 * 大路结果列表 百家乐,龙虎使用
	**/
	public class BigTable extends RoadBaseTable {

		protected var _column:int = 0;
		protected var _row:int = 0;

		public function BigTable () {
			posViewName = "HistoryRoad.BigView";
			_width = width;
			_height = height;
			_x=0;
			_y=0;
			MovingDistance = 25
			Initialize ();
		}

		//显示大路
		public override function ShowRoad (number:int):void {
			if(!number||number==0){
				return;
			}
			if ((number == 3)) {
				if ((lastRoadView == null)) {
					return;
				} else {
					lastRoadView.AddDrawResult ();
				}
			} else {
				RemoveAsk ();
				var roadClass:Class = getDefinitionByName(posViewName) as Class;
				var rc:*=new roadClass(number);
				rc.SetLang(m_lang);
				rc.RoadPosition (lastRoadView,number,posArray);
				lastRoadView = rc;
				FillingArray (rc.Column,rc.Row,1);
				_column = rc.Column;
				_row = rc.Row;
				mcParent.addChild (rc);
				MobileRoad ();

			}
		}

		//预测下一次结果
		public function FShowRoad (number:int):void {
			if(!number||number==0){
				return;
			}
			var roadClass:Class = getDefinitionByName(posViewName) as Class;
			var rc:*=new roadClass(number);
			rc.SetLang(m_lang);
			rc.RoadPosition (lastRoadView,number,posArray);
			FillingArray (rc.Column,rc.Row,undefined);
			_column = rc.Column;
			_row = rc.Row;
		}

		public function get PosArray ():Array {
			return posArray;
		}

		public function get Column ():int {
			return _column;
		}

		public function get Row ():int {
			return _row;
		}
	}
}