package HistoryRoad {
	
	/*
	 * 轮盘 红黑、大小、单双显示列表
	*/
	public class RouleeteOtherTable extends RoadBaseTable {
		
		
		public function RouleeteOtherTable() {
			posViewName = "HistoryRoad.RedOrBlackView";
			_width = width;
			_height = height;
			MovingDistance = 28.7;
			Initialize ();
		}
		
		/*
		 * 写入列表对应的结果
		 @ strName 结果类名称
		*/
		public function SetViewName(strName:String){
			if(strName!=""){
				posViewName=strName;
			}
		}
	}
	
}
