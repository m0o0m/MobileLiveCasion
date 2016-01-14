package HistoryRoad {
	
	import flash.display.MovieClip;
	
	/*
	 * 路子显示结果父类
	*/
	public class RoadPosView extends MovieClip {

		protected var _row:int=0;//行数，记录当前填充的行
		protected var _column:int=0;//列数，记录当前填充的列
		
		public var _x:Number=1;//初始x坐标
		public var _y:Number=1;//初始y坐标
		
		public var _width:Number=0;//宽
		public var _height:Number=0;//高
		
		public var l_startx=1;//记录最后一个对象起始x坐标
		public var l_startColumn=0;//记录最后一个对象起始列
		
		public var lastNum:int=0;//记录最后一个颜色，1表示红，2表示蓝
		public var maxRow:int=6;//最大行数
		
		protected var roadResult:Array;//存储结果对应的状态 一维索引表示最新结果 二维索引表示属性[0-5]分别代表红黑，大小,打，列，单双
		
		protected var m_lang:String;
		public function RoadPosView() {
		}
		
		/*
		 * 定位
		 @ rpv 上一个显示结果对象
		 @ number 要显示的索引
		 @ arr 数组填充情况
		*/
		public function RoadPosition(rpv:RoadPosView,number:int,arr:Array=null):void{
			if(!number||number==0){
				return;
			}
			lastNum=number;
			if(rpv==null){//最后一个值为空时，位置为默认位置
				x=_x;
				y=_y;
				l_startx=_x;
			}else{
				if(rpv.lastNum!=number){
					x=rpv.l_startx+_width+1;
					y=_y;
					_row=0;
					l_startx=x;
					_column=rpv.l_startColumn+1;
					l_startColumn=rpv.l_startColumn+1;
				}else{
					l_startColumn=rpv.l_startColumn;
					l_startx=rpv.l_startx;
					if(rpv.Row+1<maxRow&&NonEmpty(arr[rpv.Column][rpv.Row+1])){
						x=rpv.x;
						y=_height+rpv.y+1;
						_row=rpv.Row+1;
						_column=rpv.Column;
					}else{
						x=rpv.x+_width+1;
						y=rpv.y;
						_row=rpv.Row;
						_column=rpv.Column+1;
					}
				}
			}
		}
		
		/*
		 * 轮盘设置开局结果对应的属性
		*/
		protected function SetRouleeteAtrrribute():void{
			roadResult=[
						[3,3,4,4,3],
						[1,2,1,1,2],
						[2,2,1,2,1],
						[1,2,1,3,2],
						[2,2,1,1,1],
						[1,2,1,2,2],
						[2,2,1,3,1],
						[1,2,1,1,2],
						[2,2,1,2,1],
						[1,2,1,3,2],
						[2,2,1,1,1],
						[2,2,1,2,2],
						[1,2,1,3,1],
						[2,2,2,1,2],
						[1,2,2,2,1],
						[2,2,2,3,2],
						[1,2,2,1,1],
						[2,2,2,2,2],
						[1,2,2,3,1],
						[1,1,2,1,2],
						[2,1,2,2,1],
						[1,1,2,3,2],
						[2,1,2,1,1],
						[1,1,2,2,2],
						[2,1,2,3,1],
						[1,1,3,1,2],
						[2,1,3,2,1],
						[1,1,3,3,2],
						[2,1,3,1,1],
						[2,1,3,2,2],
						[1,1,3,3,1],
						[2,1,3,1,2],
						[1,1,3,2,1],
						[2,1,3,3,2],
						[1,1,3,1,1],
						[2,1,3,2,2],
						[1,1,3,3,1]
					  ]
		}
		
		//非空判断
		public function NonEmpty(param):Boolean{
			if(param==undefined||param==null){
				return true;
			}
			return false;
		}
		
		//行属性
		public function get Row(){
			return _row;
		}
		
		//列属性
		public function get Column(){
			return _column;
		}
		public function SetLang(strlang:String):void{
			m_lang=strlang;
		}
	}
}
