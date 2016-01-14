package HistoryRoad{

	import flash.geom.Point;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;

	public class RouleeteHistoryResultManger extends HistoryResultBaseManger {

		protected var rhrm:RouleeteHistoryResultManger = null;

		protected var isVisible:Boolean = true;//是否第一次
		protected var strPealTbale:String;//珠盘显示对象
		protected var strOtherTable:String;//红黑，单双，大小显示对象
		protected var strHCTable:String;//打列显示列表
		protected var strBtnRoadTable:String;//右边按钮对象
		protected var strView:Array;//相同列表对应的不同显示结果数组
		protected var hcName:HitColumnName = null;//打列头

		public function RouleeteHistoryResultManger () {
			roadView=new Array();
			if (strPealTbale!=null&&strPealTbale!="") {
				roadView.push (strPealTbale);
			}
			if (strOtherTable!=null&&strOtherTable!="") {
				//roadView.push (strOtherTable);
				roadView.push (strOtherTable);
				roadView.push (strOtherTable);
			}
			if (strHCTable!=null&&strHCTable!="") {
				roadView.push (strHCTable);
			}
			if (strBtnRoadTable!=null&&strBtnRoadTable!="") {
				//roadView.push (strBtnRoadTable);
			}
			//strView = ["HistoryRoad.RedOrBlackView","HistoryRoad.BigOrSmallView","HistoryRoad.SingleOrDoubleView"];
			strView = ["HistoryRoad.BigOrSmallView","HistoryRoad.SingleOrDoubleView"];
			haveAsk = false;
			super ();
		}

		//销毁
		public override function Destroy ():void {
			super.Destroy ();
			rhrm = null;
			if (hcName) {
				removeChild (hcName);
				hcName = null;
			}
		}

		/*
		 * 显示表格
		*/
		public override function ShowTable ():void {
			var index:int = 0;
			var indexView:int = 0;//红黑，大小，单双索引
			while (index<roadView.length) {
				if (roadLoadView[index] == null) {
					var roadClass:Class = getDefinitionByName(roadView[index]) as Class;
					var rtable:* = new roadClass();
					addChild (rtable);
					var strName:String = roadView[index];
					roadLoadView[index] = rtable;
					if (strName==strOtherTable) {
						roadLoadView[index].posViewName = strView[indexView];
						indexView++;
						//if (isVisible) {
							roadLoadView[index].visible = true;
							isVisible = false;
						/*} else {
							roadLoadView[index].visible = false;
						}*/
					}
					if (strName==strHCTable) {
						if (hcName==null) {
							hcName=new HitColumnName();
							if(m_lang){
								hcName.SetLang(m_lang);
							}
							hcName.x=0;
							hcName.y=200;
							addChild (hcName);
						}
						//if (isVisible) {
							roadLoadView[index].visible = true;
							hcName.visible = true;
							/*isVisible = false;
						} else {
							roadLoadView[index].visible = false;
							hcName.visible = false;
						}*/
					}
					if (strName==strBtnRoadTable) {
						roadLoadView[index].SetRouleetManger (this);
						rhrm = this;
					}
					rtable.x = roadPos[index].x;
					rtable.y = roadPos[index].y;
				}
				index++;
			}
		}

		//处理结果，装入数组显示
		public override function ShowRoad (strNumber:String):void {
			var lenght:int = roadView.length;
			arrResult = new Array(lenght);
			Resoult(strNumber);
			for (var i:int=0; i<lenght; i++) {
				arrResult[i] = int(strNumber);
			}
			if(resoultList==null){
				resoultList=[0,0,0,0,0,0,0];
			}
			ShowRoadTable (arrResult);
		}
		public function Resoult(str:String):void{
			var index:int=int(str);
			var list:Array=[
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
			switch(list[index][1]){
				case 2:
				resoultList[1]+=1;
				break;
				case 1:
				resoultList[0]+=1;
				break;
				case 3:
				resoultList[6]+=1;
				break;
			}
			switch(list[index][4]){
				case 1:
				resoultList[3]+=1;
				break;
				case 2:
				resoultList[2]+=1;
				break;
			}
			switch(list[index][0]){
				case 1:
				resoultList[4]+=1;
				break;
				case 2:
				resoultList[5]+=1;
				break;
			}
		}

		//显示历史记录
		public override function ShowRoadTable (arr:Array):void {
			if (! roadView || roadView.length < 1) {
				return;
			}
			if (! roadPos || roadPos.length < 1) {
				return;
			}
			var index:int = 0;

			var indexView:int = 0;//红黑，大小，单双索引
			while (index<roadView.length) {
				if (roadLoadView[index] == null) {
					var roadClass:Class = getDefinitionByName(roadView[index]) as Class;
					var rtable:* = new roadClass();
					addChild (rtable);
					roadLoadView[index] = rtable;
					rtable.x = roadPos[index].x;
					rtable.y = roadPos[index].y;
				}

				var strName:String = getQualifiedClassName(roadLoadView[index]);
				strName = strName.replace("::",".");
				switch (strName) {
					case strPealTbale :
						roadLoadView[index].ShowRoad (arr[index]);
						break;
					case strBtnRoadTable :
						if (rhrm==null) {
							roadLoadView[index].SetRouleetManger (this);
							rhrm = this;
						}
						break;
					case strOtherTable :
						if (isVisible) {
							roadLoadView[index].posViewName = strView[indexView];
							//if (indexView==0) {
								roadLoadView[index].visible = true;
							//} else {
								//roadLoadView[index].visible = false;
							//}
							indexView++;
						}
						roadLoadView[index].ShowRoad (arr[index]);
						break;
					case strHCTable :
						roadLoadView[index].ShowRoad (arr[index]);
						if (hcName==null) {
							hcName=new HitColumnName();
							addChild (hcName);
							hcName.x=0;
							hcName.y=200;
						}
						break;
				}
				//显示路子;
				index++;
			}
			isVisible = false;
		}

		/*
		 * 右边按钮点击事件
		 @ strViewName 点击的类型
		*/
		public function BtnOntClick (strViewName:String):void {
			if (strViewName=="") {
				return;
			}
			var index:int = 0;
			var strName:String = "";
			hcName.visible = false;
			while (index<roadLoadView.length) {
				strName = getQualifiedClassName(roadLoadView[index]);
				strName = strName.replace("::",".");
				if (strName==strOtherTable||strName==strHCTable ||strName==strPealTbale) {
					if (roadLoadView[index]) {
						roadLoadView[index].visible = false;
						if (roadLoadView[index].posViewName == strViewName) {
							roadLoadView[index].visible = true;
							if (strName==strHCTable) {
								hcName.visible = true;
							}
						}
					}
				}
				index++;
			}
		}
		public override function Shuffle():void {
			super.Shuffle();
			resoultList=[0,0,0,0,0,0,0];
		}
		public override function SetLang(strlang:String):void{
			super.SetLang(strlang);
			if(hcName){
			hcName.SetLang(m_lang);
			}
		}
	}
}