package {
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.events.Event;
	import flash.display.StageAlign;
	import flash.events.MouseEvent;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import caurina.transitions.Tweener;
	import fl.motion.MotionEvent;

	public class FlipBook extends MovieClip{
		public static var START_MOVE:String = "startMove";//开始移动
		public static var END_MOVE:String = "endMove";//停止移动
		
		public var m_Flip:FlipCard;

		public var currentPage:uint = 1;//定义当前页变量，默认为第1页
		public var totalPages:uint;//定义总页数变量
		public var currentRightPaper;//定义当前页面右部变量
		private var currentLeftPaper:Paper = null;//定义当前页面左部变量，默认为空
		private var paper:Paper = null;//画布
		private var currentPaper:Paper = null;//当前画布

		private var leftPagesArr:Array = [];//左部页面存储数组
		private var rightPagesArr:Array = [];//右部页面存储数组

		public var _width:Number;//定义宽
		public var _height:Number;//定义高

		private var fp:Point=new Point();//
		private var hs1,hs2,hs3,hs4,hs5,hs6,hs7,hs8;//定义八个翻页点
		private var currentHS:HotSpot = null;//当前翻页点
		private var areFlip:Boolean = true;//是否达到翻页条件翻页
		private var isReady:Boolean = true;//翻页点是否可用
		private var isTurn:Boolean = false;//是否翻页

		private var init:Boolean = true;//是否初始化
		private var isDown:Boolean = false;//是否处于按下状态
		private var m_point:Array=[[10,20,30,40,50,60,70,80,100,110,120,130,140,150,160,170,180,190,200,210,220,230,240,250,260,270,280,290],//x轴坐标
		   [10,20,30,40,50,60,70,80,90,100,110,120,130,140,150,160,300,310,320,330,340,350,360,370,380,390,400,410,420,430,440]];

		public function FlipBook(_w:Number,_h:Number) {
			visible = false;
			_width = _w;//宽度等于参数_w
			_height = _h;//高度等于参数_h
			fp.x = _w;
			fp.y = _h;
			addHS();//增加翻页点
			shadowFMasker._mc.width = _w;
			shadowFMasker._mc.height = _h + 1;
			//shadowFR.height=shadowF.height=Math.sqrt(_w*_w+_h*_h)*2;
			shadowFRMasker.x = _w / 2;
			shadowFRMasker.y = 0;
			shadowFRMasker.width = _w;
			shadowFRMasker.height = _h;
			addEventListener(Event.ENTER_FRAME,enterFrame);
			addEventListener(Event.ADDED_TO_STAGE,addTS);
		}

		/*
		 * 添加画布
		 @ pageA 牌的背面
		 @ pageB 牌的正面
		 @ bm_smoothing 位图是否平滑
		*/
		public function addPaper(pageA:DisplayObject,pageB:DisplayObject,bm_smoothing:Boolean=true):void {
			totalPages++;
			if (bm_smoothing) {
				pageA is Bitmap&&(Bitmap(pageA).smoothing=true);
				pageB is Bitmap&&(Bitmap(pageB).smoothing=true);
			}
			paper = new Paper(pageA,pageB,_width,_height);
			papers.addChild(paper);
			papers.setChildIndex(paper,0);
			currentPaper = paper;
		}

		/*
		 * 鼠标是否超出工作区
		*/
		private function mousePosition():Boolean {
			if (mouseY<0||mouseY>_height||mouseX<0||mouseX>_width) {
				return false;
			}
			return true;
		}


		//ENTER_FRAME事件函数,主要作用是根据鼠标不断变化不断调整阴影位置
		public function enterFrame(e):void {
			if (currentPaper) {

				//如果鼠标按下状态，并且鼠标位置超出工作区，则结束动画
				/*if (isDown&&!mousePosition()) {
					isDown = false;
					var lpoint = new Point(currentPaper.lp.point.x,currentPaper.lp.point.y);
					gotoHSPoint(currentHS,lpoint);
					SetDataPoint("",lpoint,isDown,false);
				}*/
				updatefp();
				currentPaper.Update(fp,currentPaper.currentCor);
				//shadowF.rotation = currentPaper.mask_rotation;
				//shadowFR.x = shadowF.x = currentPaper.mask_x;
				//shadowFR.y = shadowF.y = currentPaper.mask_y;
				//设置遮罩层位置及旋转角度
				if (currentPaper.currentCor == StageAlign.TOP) {
					//shadowFMasker.x = 0;
					shadowFMasker.y = currentPaper.lp.point.y;
					shadowFMasker.rotation = currentPaper.mask_rotation * 2;
					//shadowFR.alpha=(Math.abs(shadowFR.y)/_height)+0.3;
				} else if (currentPaper.currentCor==StageAlign.BOTTOM) {
					//shadowF.rotation = 90;
					shadowFMasker.x = 0;
					shadowFMasker.y = currentPaper.lp.point.y;
					shadowFMasker.rotation = 180;
					//shadowFR.alpha=(Math.abs(_height-Math.abs(shadowFR.y))/_height)+0.3;
				} else if (currentPaper.currentCor==StageAlign.LEFT) {
					shadowFMasker.x = currentPaper.lp.point.x;
					shadowFMasker.y = _height;
					shadowFMasker.rotation = 0;
					//shadowFR.alpha=(Math.abs(shadowFR.x)/_width)+0.3;
				} else if (currentPaper.currentCor==StageAlign.RIGHT) {
					shadowFMasker.x = currentPaper.lp.point.x;
					shadowFMasker.y = 0;
					shadowFMasker.rotation = 0;
				} else {
					shadowFMasker.x = currentPaper.lp.point.x;
					shadowFMasker.y = currentPaper.lp.point.y;
					shadowFMasker.rotation = currentPaper.mask_rotation * 2;
					//shadowFR.alpha=(Math.abs(shadowFR.x)/_width)+0.3;
				}
				if (currentPaper.currentCor == StageAlign.RIGHT || currentPaper.currentCor == StageAlign.BOTTOM_RIGHT || currentPaper.currentCor == StageAlign.TOP_RIGHT) {
					//shadowFR.alpha=(Math.abs(_width-Math.abs(shadowFR.x))/_width)+0.3;
				}
				//shadowFR.rotation = shadowFMasker.rotation / 2;//阴影旋转角度
				//shadowFR.scaleX = currentPaper.currentDir == "right" ? 1:-1;//阴影方向
				shadowFMasker._mc.x = currentPaper.page.x;
				shadowFMasker._mc.y = currentPaper.page.y;
				if (init) {
					currentPaper = null;
					visible = true;
					init = false;
				}

			}
		}

		//更新fp点坐标
		private function updatefp() {
			if (isDown) {
				fp.x +=  (mouseX - fp.x) * 0.6;
				fp.y +=  (mouseY - fp.y) * 0.6;
				for (var index:int=0; index<m_point[1].length; index++) {
					if (int(fp.x)==m_point[0][index]||int(fp.y)==m_point[1][index]) {
						SetDataPoint("",fp,isDown,false);
					}
				}
			}
		}



		//添加八个可翻页的点，并加上相应事件
		private function addHS() {
			hs1 = new HotSpot(_width,_height,"TL");//左上角翻页点TL=TOP-LEFT
			hs2 = new HotSpot(_width,_height,"TR");//右上角翻页点TR=TOP-RIGHT
			hs3 = new HotSpot(_width,_height,"BL");//左下角翻页点BL=BOTTOM-LEFT
			hs4 = new HotSpot(_width,_height,"BR");//右下角翻页点BR=BOTTOM-RIGHT
			hs5 = new HotSpot(_width,_height,"T");//中上翻页点TC=TOP-CENTER
			hs6 = new HotSpot(_width,_height,"B");//中下翻页点BC=BOTTOM-CENTER
			hs7 = new HotSpot(_width,_height,"L");//左中翻页点LC=LEFT-CENTER
			hs8 = new HotSpot(_width,_height,"R");//右中翻页点RC=RIGHT-CENTER
			hots.addChild(hs1);
			//翻页点添加到舞台;
			hots.addChild(hs2);
			hots.addChild(hs3);
			hots.addChild(hs4);
			hots.addChild(hs5);
			hots.addChild(hs6);
			hots.addChild(hs7);
			hots.addChild(hs8);
			for (var j=1; j<=8; j++) {//为每个翻页点添加翻页事件的鼠标侦听
				//this["hs" + j].buttonMode=true
				this["hs" + j].addEventListener(MouseEvent.MOUSE_DOWN,meHandler);
				this["hs" + j].addEventListener(MouseEvent.MOUSE_OVER,meHandler);
				this["hs" + j].addEventListener(MouseEvent.MOUSE_MOVE,meHandler);
				this["hs" + j].addEventListener(MouseEvent.MOUSE_MOVE,meHandler);
			}
			currentHS = hs4;//设置默认翻页点为hs4
			hots.alpha = 0;//设置翻页点透明不可见
		}

		private function addTS(e) {
			this.stage.addEventListener(MouseEvent.MOUSE_UP,meHandler);
		}



		/*
		 * 根据不同的翻页点设置fp的默认坐标点
		 @ cor 翻页点
		*/
		private function fpgotoCor(cor:String) {
			Tweener.removeTweens(fp);
			if (cor==StageAlign.TOP_LEFT) {
				fp.x = hs1.x,fp.y = hs1.y;
			} else if (cor==StageAlign.TOP_RIGHT) {
				fp.x = hs2.x,fp.y = hs2.y;
			} else if (cor==StageAlign.BOTTOM_LEFT) {
				fp.x = hs3.x,fp.y = hs3.y;
			} else if (cor==StageAlign.BOTTOM_RIGHT) {
				fp.x = hs4.x,fp.y = hs4.y;
			} else if (cor == StageAlign.TOP) {
				fp.x = hs5.x,fp.y = hs5.y;
			} else if (cor == StageAlign.BOTTOM) {
				fp.x = hs6.x,fp.y = hs6.y;
			} else if (cor == StageAlign.LEFT) {
				fp.x = hs7.x,fp.y = hs7.y;
			} else if (cor == StageAlign.RIGHT) {
				fp.x = hs8.x,fp.y = hs8.y;
			}
		}



		/*
		 * 翻页
		 @ _hs 翻页点
		 @ point 当前鼠标位置
		*/
		public function gotoHSPoint(_hs,point:Point):void {
			var hs = _hs;
			
			//翻页
			if (hs==hs1||hs==hs7) {
				if (point.x >= _width || point.y>=_height) {
					areFlip = ! areFlip;
					hs == hs1 && currentPaper.setCor("TL",areFlip);
					hs == hs7 && currentPaper.setCor("L",areFlip);
					fp = new Point(0,0.1);//翻页后将fp坐标重置
					SetStatus(false);
					SetDataPoint("",point,isDown,true);
				}
			} else if(hs==hs3 ||hs==hs6 ){
				if(point.x >= _width  || point.y <= 0){
					areFlip = ! areFlip;
					hs == hs3 && currentPaper.setCor("BL",areFlip);
					hs == hs6 && currentPaper.setCor("B",areFlip);
					fp = new Point(0,_height / 1.001);
					SetStatus(false);
					SetDataPoint("",point,isDown,true);
				}
			}
			else if (hs==hs4||hs==hs8) {
				if (point.x <=0 || point.y<=0) {
					areFlip = ! areFlip;
					hs == hs4 && currentPaper.setCor("BR",areFlip);
					hs == hs8 && currentPaper.setCor("R",areFlip);
					fp = new Point(_width,_height/1.001);
					SetStatus(false);
					SetDataPoint("",point,isDown,true);
				}
			}else if (hs==hs2||hs==hs5) {
				if (point.y >= _height || point.x <= 0) {
					areFlip = ! areFlip;
					hs == hs2 && currentPaper.setCor("TR",areFlip);
					hs == hs5 && currentPaper.setCor("T",areFlip);
					fp=new Point(_width,0.1);
					SetStatus(false);
					SetDataPoint("",point,isDown,true);
				}
			} 
			/*if (hs==hs1||hs==hs3||hs==hs7) {
				if (point.x >= _width *1) {
					areFlip = ! areFlip;
					hs == hs1 && currentPaper.setCor("TL",areFlip);
					hs == hs3 && currentPaper.setCor("BL",areFlip);
					hs == hs7 && currentPaper.setCor("L",areFlip);
					if (hs==hs1||hs==hs7) {
						fp = new Point(0,0);//翻页后将fp坐标重置
					}
					if (hs==hs3) {
						fp = new Point(0,_height / 1.001);
					}
					SetStatus(false);
					SetDataPoint("",point,isDown,true);
				}
			} else if (hs==hs2||hs==hs4||hs==hs8) {
				if (point.x <= _width *0) {
					areFlip = ! areFlip;
					hs == hs2 && currentPaper.setCor("TR",areFlip);
					hs == hs4 && currentPaper.setCor("BR",areFlip);
					hs == hs8 && currentPaper.setCor("R",areFlip);

					if (hs==hs2||hs==hs8) {
						fp = new Point(_width,0);
					}
					if (hs==hs4) {
						fp = new Point(_width,_height);
					}
					SetStatus(false);
					SetDataPoint("",point,isDown,true);
				}
			} else if (hs==hs5) {
				if (point.y >= _height *1) {
					areFlip = ! areFlip;
					hs == hs5 && currentPaper.setCor("T",areFlip);
					fp=new Point(_width/2,0);
					SetStatus(false);
					SetDataPoint("",point,isDown,true);
				}
			} else if (hs==hs6) {
				if (point.y <= _height *0) {
					areFlip = ! areFlip;
					hs == hs6 && currentPaper.setCor("B",areFlip);
					fp=new Point(_width/2,_height);
					SetStatus(false);
					SetDataPoint("",point,isDown,true);
				}
			}*/
			Tweener.removeTweens(fp);
			//返回
			Tweener.addTween(fp, {x:hs.x,y:hs.y, time:0.5, transition:"easeOutBack",onComplete:complete});
			//完成
			function complete() {
				fadeOutShadow();
				papers.setChildIndex(paper,papers.numChildren-1);
				//交换层次
				//显示翻牌结果
				hs == hs1 && currentPaper.setCor("TL",areFlip);
				hs == hs2 && currentPaper.setCor("TR",areFlip);
				hs == hs3 && currentPaper.setCor("BL",areFlip);
				hs == hs4 && currentPaper.setCor("BR",areFlip);
				hs == hs5 && currentPaper.setCor("T",areFlip);
				hs == hs6 && currentPaper.setCor("B",areFlip);
				hs == hs7 && currentPaper.setCor("L",areFlip);
				hs == hs8 && currentPaper.setCor("R",areFlip);
				currentPaper = null;
			}
		}

		/*
		 * 淡入阴影
		*/
		private function fadeInShadow() {
			//Tweener.removeTweens(shadowF);
			//Tweener.removeTweens(shadowFR);
			//shadowFR.visible = shadowF.visible = true;
			//Tweener.addTween(shadowF, {alpha:1,visible:true, time:0, transition:"easeOutSine"});
			//Tweener.addTween(shadowFR, {alpha:1,visible:true, time:0, transition:"easeOutSine"});

		}

		/*
		 * 淡入出阴影
		*/
		private function fadeOutShadow() {
			//Tweener.removeTweens(shadowF);
			//Tweener.removeTweens(shadowFR);
			//Tweener.addTween(shadowF, {alpha:0,visible:false, time:.5, transition:"easeOutSine"});
			//Tweener.addTween(shadowFR, {alpha:0,visible:false, time:.5, transition:"easeOutSine"});
		}
		/*
		 * 各翻页点对应事件对应方法
		*/
		private function meHandler(e:MouseEvent):void {
			if (isReady) {
				if (isDown) {
					if (e.type == MouseEvent.MOUSE_UP) {//鼠标弹起
						dispatchEvent (new Event(FlipBook.END_MOVE));
						isDown = false;
						var lpoint = new Point(currentPaper.lp.point.x,currentPaper.lp.point.y);
						SetDataPoint("",lpoint,isDown,false);
						gotoHSPoint(currentHS,lpoint);
					}
				}
				var et = e.target;
				if (e.type == MouseEvent.MOUSE_DOWN) {//鼠标按下
					dispatchEvent (new Event(FlipBook.START_MOVE));
					fadeInShadow();
					if (et == hs1) {
						isDown = true;
						currentPaper = paper;
						currentPaper.setCor(StageAlign.TOP_LEFT,areFlip);
						fpgotoCor(StageAlign.TOP_LEFT);
						currentHS = et;
						papers.setChildIndex(currentPaper,papers.numChildren-1);
						SetDataPoint("1",new Point(currentHS.x,currentHS.y),isDown,false);
					} else if (et==hs2) {
						isDown = true;
						currentPaper = paper;
						currentPaper.setCor(StageAlign.TOP_RIGHT,areFlip);
						fpgotoCor(StageAlign.TOP_RIGHT);
						currentHS = et;
						papers.setChildIndex(currentPaper,papers.numChildren-1);
						SetDataPoint("2",new Point(currentHS.x,currentHS.y),isDown,false);
					} else if (et==hs3) {
						isDown = true;
						currentPaper = paper;
						currentPaper.setCor(StageAlign.BOTTOM_LEFT,areFlip);
						fpgotoCor(StageAlign.BOTTOM_LEFT);
						currentHS = et;
						papers.setChildIndex(currentPaper,papers.numChildren-1);
						SetDataPoint("3",new Point(currentHS.x,currentHS.y),isDown,false);
					} else if (et==hs4) {
						isDown = true;
						currentPaper = paper;
						currentPaper.setCor(StageAlign.BOTTOM_RIGHT,areFlip);
						fpgotoCor(StageAlign.BOTTOM_RIGHT);
						currentHS = et;
						papers.setChildIndex(currentPaper,papers.numChildren-1);
						SetDataPoint("4",new Point(currentHS.x,currentHS.y),isDown,false);
					} else if (et==hs5) {
						isDown = true;
						currentPaper = paper;
						currentPaper.setCor(StageAlign.TOP,areFlip);
						fpgotoCor(StageAlign.TOP);
						currentHS = et;
						papers.setChildIndex(currentPaper,papers.numChildren-1);
						SetDataPoint("5",new Point(currentHS.x,currentHS.y),isDown,false);
					} else if (et==hs6) {
						isDown = true;
						currentPaper = paper;
						currentPaper.setCor(StageAlign.BOTTOM,areFlip);
						fpgotoCor(StageAlign.BOTTOM);
						currentHS = et;
						papers.setChildIndex(currentPaper,papers.numChildren-1);
						SetDataPoint("6",new Point(currentHS.x,currentHS.y),isDown,false);
					} else if (et==hs7) {
						isDown = true;
						currentPaper = paper;
						currentPaper.setCor(StageAlign.LEFT,areFlip);
						fpgotoCor(StageAlign.LEFT);
						currentHS = et;
						papers.setChildIndex(currentPaper,papers.numChildren-1);
						SetDataPoint("7",new Point(currentHS.x,currentHS.y),isDown,false);
					} else if (et==hs8) {
						isDown = true;
						currentPaper = paper;
						currentPaper.setCor(StageAlign.RIGHT,areFlip);
						fpgotoCor(StageAlign.RIGHT);
						currentHS = et;
						papers.setChildIndex(currentPaper,papers.numChildren-1);
						SetDataPoint("8",new Point(currentHS.x,currentHS.y),isDown,false);
					}
				} else if (e.type==MouseEvent.MOUSE_OVER) {//鼠标离开时
					et.buttonMode = true;
				}
			}
		}
		public function SetFlip(flip:FlipCard) {
			m_Flip = flip;
		}
		public function SetDataPoint(cor:String,point:Point,status:Boolean,isturn:Boolean):void {
			var str:String = point.x + "/" + point.y + "/" + status + "/" + isturn + "/" + cor;
			m_Flip.SetData(str,isturn);
		}
		
		//设置翻页点可用状态
		public function SetStatus(status:Boolean):void {
			isReady = status;
			hs1.buttonMode = status;
			hs2.buttonMode = status;
			hs3.buttonMode = status;
			hs4.buttonMode = status;
			hs5.buttonMode = status;
			hs6.buttonMode = status;
			hs7.buttonMode = status;
			hs8.buttonMode = status;
		}
		public function Destory(){
			for(var index:int=this.numChildren-1;index>=0;index--){
				this.removeChildAt(index);
			}
		}
		public function OpenCard():void{
			currentPaper=paper;
			areFlip = ! areFlip;
			currentPaper.setCor("BL",areFlip);
			//gotoHSPoint(hs3,new Point(_width,0));
			fp = new Point(0,_height / 1.001);
			SetStatus(false);
			SetDataPoint("3",new Point(_width,0),false,true);
			fadeOutShadow();
			papers.setChildIndex(paper,papers.numChildren-1);
			currentPaper = null;
		}
	}
}