package HistoryRoad{
	import flash.geom.Point;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	import flash.utils.Timer;
	import flash.display.Graphics;

	public class BaccaratHistoryResultManger extends HistoryResultBaseManger {

		private var newBgResult:int = -1;//大路的最新结果

		private var bt:* = null;//大路
		private var hrbm:HistoryResultBaseManger = null;

		protected var strPearlTable:String;
		protected var strBigTable:String;
		protected var strBigEyesTable:String;
		protected var strSmallTable:String;
		protected var strSmallForcedTablele:String;
		protected var strRoadInfo:String;

		public function BaccaratHistoryResultManger () {
			roadView=new Array();
			if (strPearlTable!=null&&strPearlTable!="") {
				roadView.push (strPearlTable);
			}
			if (strBigTable!=null&&strBigTable!="") {
				roadView.push (strBigTable);
			}
			if (strBigEyesTable!=null&&strBigEyesTable!="") {
				roadView.push (strBigEyesTable);
			}
			if (strSmallTable!=null&&strSmallTable!="") {
				roadView.push (strSmallTable);
			}
			if (strSmallForcedTablele!=null&&strSmallForcedTablele!="") {
				roadView.push (strSmallForcedTablele);
			}
			if (strRoadInfo!=null&&strRoadInfo!="") {
				roadView.push (strRoadInfo);
			}
			//roadPos = [new Point(4.3,30.3),new Point(356.3,30.3),new Point(357.3,89),new Point(357.3,118.90),new Point(563.3,118.90),new Point(773.05,30.3)];
			super ();
		}

		//销毁
		public override function Destroy ():void {
			super.Destroy ();
			bt = null;
			hrbm = null;
		}

		//处理结果，装入数组显示
		public override function ShowRoad (strNumber:String):void {
			var lenght:int = roadView.length;
			arrResult = BaccaratResult(strNumber);
			if (arrResult) {
				if (resoultList==null) {
					resoultList = [0,0,0,0];
				}
				ShowRoadTable (arrResult);
			}
		}

		//结果处理
		//结果 1:庄;2:闲;3:和;4:闲(庄对闲对);5:闲(庄对);6闲(闲对);7:庄(庄对闲对);8:庄(庄对);9:庄(闲对);10:和(庄对闲对);11:和(庄对);12:和(闲对)
		private function BaccaratResult (strNumber:String):Array {
			if (strNumber==null||strNumber=="") {
				return null;
			}
			var lenght:int = roadView.length;
			var Result:Array = new Array(lenght);
			var blankPlay:int = 0;
			switch (strNumber.substring(0,1)) {
				case "0" :
					blankPlay = 3;
					resoultList[2] +=  1;
					break;
				case "1" :
					blankPlay = 1;
					resoultList[0] +=  1;
					break;
				case "2" :
					blankPlay = 2;
					resoultList[1] +=  1;
					break;
			}
			switch (strNumber.substr(1, 2)) {
				case "00" :
					Result[0] = blankPlay;
					break;
				case "01" :
					if (blankPlay==1) {
						Result[0] = 9;
					} else if (blankPlay==2) {
						Result[0] = 6;
					} else {
						Result[0] = 12;
					}
					break;
				case "10" :
					if (blankPlay==1) {
						Result[0] = 8;
					} else if (blankPlay==2) {
						Result[0] = 5;
					} else {
						Result[0] = 11;
					}
					break;
				case "11" :
					if (blankPlay==1) {
						Result[0] = 7;
					} else if (blankPlay==2) {
						Result[0] = 4;
					} else {
						Result[0] = 10;
					}
					break;
			}
			Result[1] = blankPlay;
			Result[lenght - 1] = Result[0];

			return Result;
		}

		//显示历史记录
		public override function ShowRoadTable (arr:Array):void {
			if (! roadView || roadView.length < 1) {
				return;
			}
			if (! roadPos || roadPos.length < 1) {
				return;
			}
			var index = 0;
			arrBAsk = [1,1];
			arrPAsk = [2,2];
			while (index<roadView.length) {
				if (roadLoadView[index] == null) {
					var roadClass:Class = getDefinitionByName(roadView[index]) as Class;
					var rtable:* = new roadClass();
					addChild (rtable);
					roadLoadView[index] = rtable;
					rtable.x = roadPos[index].x;
					rtable.y = roadPos[index].y;
				}
				var className:String = getQualifiedClassName(roadLoadView[index]);
				className = className.replace("::",".");
				switch (className) {
					case strBigEyesTable ://大眼路
						if (newBgResult!=-1&&newBgResult!=3) {
							arr[index] = AttachedResult(column,row,BEType);//得到大眼路结果
						} else {
							arr[index] = 0;
						}

						break;
					case strSmallTable ://小路
						if (newBgResult!=-1&&newBgResult!=3) {
							arr[index] = AttachedResult(column,row,SType);//得到小路结果
						} else {
							arr[index] = 0;
						}
						break;
					case strSmallForcedTablele ://小强路
						if (newBgResult!=-1&&newBgResult!=3) {
							arr[index] = AttachedResult(column,row,SFType);//得到小路结果
						} else {
							arr[index] = 0;
						}
						break;
					case strRoadInfo :
						if (bt) {
							//庄问路数据
							bt.FShowRoad (1);
							column = bt.Column;
							row = bt.Row;
							bigArr = bt.PosArray;
							arrBAsk.push (AttachedResult(column,row,BEType));
							arrBAsk.push (AttachedResult(column,row,SType));
							arrBAsk.push (AttachedResult(column,row,SFType));

							//闲问路数据
							bt.FShowRoad (2);
							column = bt.Column;
							row = bt.Row;
							bigArr = bt.PosArray;
							arrPAsk.push (AttachedResult(column,row,BEType));
							arrPAsk.push (AttachedResult(column,row,SType));
							arrPAsk.push (AttachedResult(column,row,SFType));
							roadLoadView[index].bAsk = arrBAsk;
							roadLoadView[index].pAsk = arrPAsk;
						}
						if (hrbm==null) {
							roadLoadView[index].SetHistoryManger (this);
							hrbm = this;
						}
						break;
				}
				if (! NonEmpty(arr[index]) && arr[index] != 0) {//如果没有数据和数据为0不显示
					roadLoadView[index].ShowRoad (arr[index]);
					//显示路子;
					if (className==strBigTable) {//大路
						if (bt==null) {
							bt = roadLoadView[index];
						}
						column = roadLoadView[index].Column;
						row = roadLoadView[index].Row;
						bigArr = roadLoadView[index].PosArray;
						newBgResult = arr[index];
					}
				}
				index++;
			}
		}
		public override function Shuffle ():void {
			super.Shuffle ();
			resoultList = [0,0,0,0];
		}
	}
}