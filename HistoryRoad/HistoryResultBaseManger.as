package HistoryRoad{

	import flash.display.MovieClip;
	import flash.utils.getDefinitionByName;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import IGameFrame.IHistoryResultManger;
	
	/*
	 * 路子管理
	*/
	public class HistoryResultBaseManger extends MovieClip implements IHistoryResultManger {

		protected var roadView:Array;//路子表格数组
		protected var roadLoadView:Array;//已经加载到界面的表格

		protected var roadPos:Array;//路子表格位置

		protected var column:int = 0;//最新大路列；
		protected var row:int = 0;//最新大路行；
		protected var bigArr:Array = null;//大路最新结果数组
		protected var maxRow:int = 6;//最大行数

		protected var BEType:int = 1;//判断大眼路结果参数
		protected var SType:int = 2;//判断小路结果参数
		protected var SFType:int = 3;//判断小强路结果参数

		protected var arrResult:Array;//显示结果数组
		protected var arrBAsk:Array;//庄问路数组
		protected var arrPAsk:Array;//闲问路数组

		protected var haveAsk:Boolean = true;//是否有问路
		protected var tiemInterval:int=100;//事件间隔
		protected var time:Timer;//闪烁定时器
		protected var timeNum:int = 1;//定时器执行的次数
		protected var alphaNum:Number = 0.8;//透明度
		protected var number:int = 1;//透明度加减，1减，2加
		
		protected var localResultArray:Array=null;//本地存储结果数组
		protected var sameCount:int=10;//本地数据和发回数据从后向前比较，有sameCount个连续相同停止比较
		protected var forwardNumber:int=20;//向前推进个数
		protected var resoultList:Array=null;
		
		protected var roadstr:String;
		protected var m_lang:String;
		public function HistoryResultBaseManger() {
			roadLoadView = new Array();
			resoultList=[0,0,0,0,0,0,0];//[庄，闲，和],[大，小，单，双，红，黑，零]
			if(haveAsk && time == null) {
				time = new Timer(tiemInterval);
				time.addEventListener (TimerEvent.TIMER,timeStar);
			}
			var index:int=0;
			ShowTable();
		}	
		
		public function GetResoultList():Array{
			return resoultList;
		}
		
		//销毁
		public function Destroy():void {
			if ((roadLoadView && roadLoadView.length > 0)) {
				var index:int = 0;
				while ((index < roadLoadView.length)) {
					if (roadLoadView[index]) {
						roadLoadView[index].Destroy ();
						removeChild(roadLoadView[index]);
						roadLoadView[index] = null;
					}
					index++;
				}
				roadLoadView=null;
			}
			roadView = null;
			roadPos = null;
			bigArr = null;
			arrResult = null;
			arrBAsk = null;
			if(time != null) {
				time.removeEventListener(TimerEvent.TIMER, timeStar);
			}
			time = null;
			localResultArray=null;
			timeNum = 1;
			alphaNum = 0.8;
			number = 1;
			BEType = 1;
			SType = 2;
			SFType = 3;
		}
		
		public function GetMovieClip():MovieClip {
			return this;
		}
		/*
		 * 显示表格
		*/
		public function ShowTable():void{
			var index:int=0;
			while (index<roadView.length) {
				if (roadLoadView[index] == null) {
					var roadClass:Class = getDefinitionByName(roadView[index]) as Class;
					var rtable:* = new roadClass();
					addChild (rtable);
					roadLoadView[index] = rtable;
					rtable.x = roadPos[index].x;
					rtable.y = roadPos[index].y;
				}
				index++;
			}
		}
		
		/*
		 * 服务器返回字符串分割
		 @ number 向前推进个数
		 @ sameCount 相同数量
		*/
		public function StringSplit(strServerResult:String):void{
			roadstr=strServerResult;
			if(strServerResult==""){
				Shuffle();
				return;
			}
			var index:int=-1;
			var starIndex:int=0;
			var serverResult:Array=new Array();
			serverResult=strServerResult.split("|");
			index=ContrastArray(serverResult);
			if(index==-2){
				return;
			}else if(index==-1){
				starIndex=0;
			}else{
				starIndex=index;
			}
			if(starIndex==0){
				Shuffle();
			}
			for(var i:int=starIndex;i<serverResult.length;i++){
				ShowRoad(serverResult[i]);
			}
		}
		
		//处理结果，装入数组显示
		public function ShowRoad(strNumber:String):void {
			
		}
		
		/*
		 * 比较数组
		 @ number 向前推进个数
		 @ sameCount 相同数量 停止比较
		*/
		public function ContrastArray(serverResult:Array):int{
			var index:int=-2;
			if(serverResult==null){
				index=-2;
				return index;
			}			
			if(localResultArray==null){
				localResultArray=serverResult;;
				index=-1;
				return index;
			}
			if(serverResult.length<localResultArray.length){
				localResultArray=serverResult;
				index=-1;
				return index;
			}
			if(localResultArray.length<sameCount||serverResult.length<sameCount){
				if(localResultArray.length<serverResult.length){
					index=localResultArray.length;					
					return index;
				}else{
					sameCount=serverResult.length-1;
				}
			}
			var conIndex:int=forwardNumber;
			var serverIndex:int=serverResult.length-1;
			var localIndex:int=localResultArray.length-1;
			var starServerIndex:int=serverResult.length-1;
			var lastSame:int=-1;
			var count:int=0;
			var hasSame:Boolean=false;
			while(conIndex>0){
				if(serverIndex<0||serverIndex<(serverResult.length-1-forwardNumber)){
					break;
				}
				if(count>=sameCount){
					break;
				}
				if(localResultArray[localIndex]==serverResult[serverIndex]){
					count++;					
					if(!hasSame){
						starServerIndex=serverIndex;
						lastSame=serverIndex;
						hasSame=true;
					}
					serverIndex--;
					localIndex--;
					conIndex--;
				}else{
					count=0;
					conIndex=forwardNumber;
					localIndex=localResultArray.length-1;
					serverIndex=--starServerIndex;
					hasSame=false;
				}
			}
			if(count>=sameCount){
				index=lastSame;
			}else{
				localResultArray=serverResult;
				index=-1;
			}			
			return index;
		}
		
		/*
		 * 显示路子
		 @ arr 最新结果数组
		*/
		public function ShowRoadTable(arr:Array):void {
			if (! roadView || roadView.length < 1) {
				return;
			}
			if (! roadPos || roadPos.length < 1) {
				return;
			}
			var index = 0;
			while ((index < roadView.length)) {
				if (roadLoadView[index] == null) {
					var roadClass:Class = getDefinitionByName(roadView[index]) as Class;
					var rtable:* = new roadClass  ;
					addChild (rtable);
					roadLoadView[index] = rtable;
					rtable.x = roadPos[index].x;
					rtable.y = roadPos[index].y;
				}
				if (! NonEmpty(arr[index])) {
					roadLoadView[index].ShowRoad (arr[index]);
				}
				index++;
			}
		}
		
		/*
		 * 显示问路
		 @ number 1庄问路 2闲问路
		*/
		public function ShowRoadAsk(number:int):void {
			if(!number){
				return;
			}
			if (! roadView || roadView.length < 1) {
				return;
			}
			if (! roadPos || roadPos.length < 1) {
				return;
			}
			var index = 0;
			while ((index < roadView.length)) {
				if (roadLoadView[index] == null) {
					var roadClass:Class = getDefinitionByName(roadView[index]) as Class;
					var rtable:* = new roadClass  ;
					addChild (rtable);
					roadLoadView[index] = rtable;
					rtable.x = roadPos[index].x;
					rtable.y = roadPos[index].y;
				}
				if(number==1){
					roadLoadView[index].ShowAsk(arrBAsk[index]);
				}
				else{
					roadLoadView[index].ShowAsk(arrPAsk[index]);
				}
				

				index++;
			}
		}
		
		/*
		 * 改变路子颜色
		 @ alphaNumber 透明度
		*/
		public function ChangRoadAlpha(alphaNumber:Number):void {
			if(!alphaNumber){
				return;
			}
			if (! roadView || roadView.length < 1) {
				return;
			}
			if (! roadPos || roadPos.length < 1) {
				return;
			}
			var index = 0;
			while ((index < roadView.length)) {
				if (roadLoadView[index] == null) {
					var roadClass:Class = getDefinitionByName(roadView[index]) as Class;
					var rtable:* = new roadClass  ;
					addChild (rtable);
					roadLoadView[index] = rtable;
					rtable.x = roadPos[index].x;
					rtable.y = roadPos[index].y;
				}
				roadLoadView[index].RoadAlpha(alphaNumber);

				index++;
			}
		}

		//移除问路
		public function RemoveAsk():void {
			if (! roadView || roadView.length < 1) {
				return;
			}
			if (! roadPos || roadPos.length < 1) {
				return;
			}
			var index = 0;
			while ((index < roadView.length)) {
				if (roadLoadView[index] == null) {
					var roadClass:Class = getDefinitionByName(roadView[index]) as Class;
					var rtable:* = new roadClass  ;
					addChild (rtable);
					roadLoadView[index] = rtable;
					rtable.x = roadPos[index].x;
					rtable.y = roadPos[index].y;
				}
				roadLoadView[index].RemoveAsk();

				index++;
			}
		}

		//洗牌
		public function Shuffle():void {
			if ((roadLoadView && roadLoadView.length > 0)) {
				var index:int = 0;
				while ((index < roadLoadView.length)) {
					if (roadLoadView[index]) {
						roadLoadView[index].Shuffle();
					}
					index++;
				}
			}
			localResultArray=null;
			bigArr=null;
			arrBAsk=[1,1];
			arrPAsk=[2,2];
		}
		
		/*
		 * 问路点击事件方法
		 @ number 1庄问路 2闲问路
		*/
		public function OnAsk(number:Number):void {
			if(time == null) {
				return ;
			}
			if (time.running) {
				StopTiem();
			}
			time.start();
			ShowRoadAsk(number);
		}

		//定时器执行方法，作用是改变问路透明度，制造处闪烁效果
		private function timeStar(e:TimerEvent) {
			if (((number % 2) == 1)) {
				if ((alphaNum <= 0.4)) {
					number = 2;
				} else {
					alphaNum -=  0.2;
				}
			} else {
				if ((alphaNum >= 0.8)) {
					number = 1;
				} else {
					alphaNum +=  0.2;
				}
			}
			ChangRoadAlpha (alphaNum);
			timeNum++;
			if ((timeNum >= 40)) {
				StopTiem();
			}

		}

		//停止定时器
		public function StopTiem():void {
			time.stop();
			time.reset();
			alphaNum = 0.8;
			number = 1;
			timeNum = 1;
			RemoveAsk();
		}
		
		/*
		 * 更具大路最新结果判断大眼路，小路，小强路显示结果
		 @ c 最新列
		 @ r 最新行
		 @ type 路子类型 1 大眼路 2小路 3小强路
		*/
		public function AttachedResult(c:int,r:int,type:int):int {
			var ret:int = 0;
			if ((bigArr == null)) {
				return ret;
			}
			var c_star = 2,c_last = 3;//c_star表示开始计算的列，c_last表示如果c_star列第二行没有值从c_last列开始计算
			if ((type == BEType)) {//大眼路从第2列第二行开始，如果第2列没有则从第3列第一行开始
				c_star = 2;
				c_last = 3;
			} else if ((type == SType)) {//小路从第3列第二行开始，如果第3列没有则从第4列第一行开始
				c_star = 3;
				c_last = 4;
			} else if ((type == SFType)) {//小强路从第4列第二行开始，如果第4列没有则从第5列第一行开始
				c_star = 4;
				c_last = 5;
			}
			if (bigArr.length < c_star) {
				return ret;
			}
			if (bigArr.length == c_star) {
				if (NonEmpty(bigArr[c_star - 1][1])) {
					return ret;
				}
			}
			if (bigArr.length >= c_last) {
				if (NonEmpty(bigArr[c_star - 1][1])&&NonEmpty(bigArr[c_last - 1][0])) {
					return ret;
				}
			}
			if ((row == 0)) {//换列大眼路对前一列与前二列结果，小路对前一列与前三列结果，小强路对前一列与前四列结果，整齐则画红（1），不整齐则画蓝（2）
				for (var n = 0; n < maxRow; n++) {
					if (((NonEmpty(bigArr[c - c_star][n]) && ! NonEmpty(bigArr[c - 1][n])) || ! NonEmpty(bigArr[c - c_star][n]) && NonEmpty(bigArr[c - 1][n]))) {

						ret = 2;
						break;
					} else if ((NonEmpty(bigArr[c - c_star][n]) && NonEmpty(bigArr[c - 1][n]))) {
						ret = 1;
						break;
					}
				}
			} else {//换行大路和前一列比较，小路和前二列比较，小强路和前三列比较
				if (! NonEmpty(bigArr[c - c_star + 1][r])) {//有结果则为红（1）
					ret = 1;
				} else {
					if (NonEmpty(bigArr[c - c_star + 1][r - 1])) {//无结果，如果前面的前两行或两行以上都没都没结果为红（1），否则为蓝（2）
						ret = 1;
					} else {
						ret = 2;
					}
				}
			}
			return ret;
		}
		
		/*
		 * 非空判断
		 @ param 要判断的值
		*/
		protected function NonEmpty(param):Boolean {
			if (((param == undefined) || param == null)) {
				return true;
			}
			return false;
		}
		public function SetLang(strlang:String):void{
			var index:int=0;
			for(index;index<roadLoadView.length;index++){
				roadLoadView[index].SetLang(strlang);
			}
			m_lang=strlang;
			if(roadstr){
				StringSplit(roadstr);
			}
		}
	}
}