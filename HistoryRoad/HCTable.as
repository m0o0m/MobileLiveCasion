package HistoryRoad {
	
	import flash.utils.getDefinitionByName;
	
	/*
	 * 轮盘 打列显示列表
	*/
	public class HCTable extends RoadBaseTable {
		
		
		public function HCTable() {
			posViewName="HistoryRoad.HCView";
			_width = width-1;
			_height = height;
			_x=0;
			
			MovingDistance = 28.7;
			Initialize ();
		}
		
		public override function ShowRoad(number:int):void{
			RemoveAsk();
			var roadClass:Class = getDefinitionByName(posViewName) as Class;
			var rc:*=null;
			if(number==0){
				rc=new roadClass(lastRoadView,number,3);
				mcParent.addChild(rc);
			}else{
				rc=new roadClass(lastRoadView,number,1);
				mcParent.addChild(rc);
				rc=new roadClass(lastRoadView,number,2);
				mcParent.addChild(rc);
			}
			rc.SetLang(m_lang);
			lastRoadView=rc;
			MobileRoad();
		}
	}
	
}
