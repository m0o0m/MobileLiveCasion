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

	public class FlipBookT extends MovieClip {

		public var totalPages:uint;//定义总页数变量
		private var paper:Paper = null;//画布
		private var currentPaper:Paper = null;//当前画布

		public var _width:Number;//定义宽
		public var _height:Number;//定义高

		private var fp:Point=new Point();//
		private var hs1,hs2,hs3,hs4,hs5,hs6,hs7,hs8;//定义八个翻页点
		private var currentHS:HotSpot = null;//当前翻页点
		private var areFlip:Boolean = true;//是否达到翻页条件翻页
		private var init:Boolean = true;//是否初始化
		private var isReady:Boolean = true;//是否处于弹起状态
		private var isTurn:Boolean = false;//是否翻页

		private var m_startpoint:Point = new Point(0,0);//翻牌起点坐标
		private var m_endpoint:Point = new Point(0,0);//翻牌结束坐标
		private var m_angle:Number;//翻牌角度正切值
		private var _xy:Number = 0;//坐标变更大小
		public var m_time:int = 10;//坐标变更次数

		protected var corindex:String = "3";//默认从StageAlign.LEFT开始

		public function FlipBookT (_w:Number,_h:Number) {
			visible = false;
			_width = _w;//宽度等于参数_w
			_height = _h;//高度等于参数_h
			addHS ();//增加翻页点
			shadowFMasker._mc.width = _w;
			shadowFMasker._mc.height = _h + 1;
			//shadowFR.height=shadowF.height=Math.sqrt(_w*_w+_h*_h)*2;
			shadowFRMasker.x = _w / 2;
			shadowFRMasker.y = 0;
			shadowFRMasker.width = _w;
			shadowFRMasker.height = _h;
			addEventListener (Event.ENTER_FRAME,enterFrame);
		}
		/*
		 * 添加画布
		 @ pageA 牌的背面
		 @ pageB 牌的正面
		 @ bm_smoothing 位图是否平滑
		*/
		public function addPaper (pageA:DisplayObject,pageB:DisplayObject,bm_smoothing:Boolean=true):void {
			totalPages++;
			if (bm_smoothing) {
				pageA is Bitmap&&(Bitmap(pageA).smoothing=true);
				pageB is Bitmap&&(Bitmap(pageB).smoothing=true);
			}
			paper = new Paper(pageA,pageB,_width,_height);
			papers.addChild (paper);
			papers.setChildIndex (paper,0);
			currentPaper = paper;
			//设置默认翻页点
			paper.setCor (StageAlign.TOP_LEFT,true);
		}


		public function GetData (str:String):Boolean {
			var list:Array = str.split("/");
			var status:Boolean;
			var isturn:Boolean;
			var index:String = list[4];
			var point:Point = new Point(list[0],list[1]);
			if (list[2] == "true") {
				status = true;
			} else {
				status = false;
			}
			if (list[3] == "true") {
				isturn = true;
			} else {
				isturn = false;
			}
			GetCor (index);
			if (point) {
				SetPoint (point,status);
			}
			SetTurn (isturn);
			return isturn;
		}
		/*
		 *设置牌点数
		 *@number为点数所在的帧
		*/
		public function SetPkNumber (number:int) {
			paper.SetPkNumber (number);
		}

		public function SetTurn (isturn:Boolean) {
			isTurn = isturn;
		}
		/*
		 *设置翻牌结束点/坐标变更大小/翻牌角度正切值
		 *@endpoint:翻牌结束位置坐标
		*/
		public function SetPoint (endpoint:Point,status:Boolean) {
			isReady = status;
			m_endpoint = endpoint;
			_xy = (m_startpoint.x-m_endpoint.x) / m_time;
			if (currentHS==hs5||currentHS==hs6) {
				_xy=(m_startpoint.y-m_endpoint.y) / m_time;
			}
			if (_xy<0) {
				_xy =  -  _xy;
			}
			SetAngle (currentHS);
		}
		/*
		 * 翻牌坐标是否超出工作区
		*/
		private function mousePosition ():Boolean {
			if (m_endpoint.y < 0 || m_endpoint.y > _height || m_endpoint.x < 0 || m_endpoint.x > _width) {
				return false;
			}
			return true;
		}
		//ENTER_FRAME事件函数,主要作用是根据坐标不断变化不断调整阴影位置
		public function enterFrame (e):void {
			if (currentPaper) {
				//坐标位置超出工作区，则结束动画
				updatefp ();
				if(isTurn){
					currentPaper=null;
					return;
				}
				currentPaper.Update (fp,currentPaper.currentCor);
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
		//添加八个可翻页的点
		private function addHS () {
			hs1 = new HotSpot(_width,_height,"TL");//左上角翻页点TL=TOP-LEFT
			hs2 = new HotSpot(_width,_height,"TR");//右上角翻页点TR=TOP-RIGHT
			hs3 = new HotSpot(_width,_height,"BL");//左下角翻页点BL=BOTTOM-LEFT
			hs4 = new HotSpot(_width,_height,"BR");//右下角翻页点BR=BOTTOM-RIGHT
			hs5 = new HotSpot(_width,_height,"T");//中上翻页点TC=TOP-CENTER
			hs6 = new HotSpot(_width,_height,"B");//中下翻页点BC=BOTTOM-CENTER
			hs7 = new HotSpot(_width,_height,"L");//左中翻页点LC=LEFT-CENTER
			hs8 = new HotSpot(_width,_height,"R");//右中翻页点RC=RIGHT-CENTER
			hots.addChild (hs1);
			//翻页点添加到舞台;
			hots.addChild (hs2);
			hots.addChild (hs3);
			hots.addChild (hs4);
			hots.addChild (hs5);
			hots.addChild (hs6);
			hots.addChild (hs7);
			hots.addChild (hs8);
			hots.alpha = 0;//设置翻页点透明不可见
		}

		public function GetCor (index:String) {
			if(index==null || index==""){
				return;
			}
			if (index!="") {
				corindex = index;
			}
			switch (corindex) {
				case "1" :
					fpgotoCor (StageAlign.TOP_LEFT);
					break;
				case "2" :
					fpgotoCor (StageAlign.TOP_RIGHT);
					break;
				case "3" :
					fpgotoCor (StageAlign.BOTTOM_LEFT);
					break;
				case "4" :
					fpgotoCor (StageAlign.BOTTOM_RIGHT);
					break;
				case "5" :
					fpgotoCor (StageAlign.TOP);
					break;
				case "6" :
					fpgotoCor (StageAlign.BOTTOM);
					break;
				case "7" :
					fpgotoCor (StageAlign.LEFT);
					break;
				case "8" :
					fpgotoCor (StageAlign.RIGHT);
					break;
			}
		}
		/*
		 * 根据不同的翻页点设置fp的默认坐标点
		 @ cor 翻页点
		*/
		public function fpgotoCor (cor:String) {
			//Tweener.removeTweens(fp);
			if (cor==StageAlign.TOP_LEFT) {
				fp.x = hs1.x,fp.y = hs1.y;
				currentHS = hs1;
			} else if (cor==StageAlign.TOP_RIGHT) {
				fp.x = hs2.x,fp.y = hs2.y;
				currentHS = hs2;
			} else if (cor==StageAlign.BOTTOM_LEFT) {
				fp.x = hs3.x,fp.y = hs3.y;
				currentHS = hs3;
			} else if (cor==StageAlign.BOTTOM_RIGHT) {
				fp.x = hs4.x,fp.y = hs4.y;
				currentHS = hs4;
			} else if (cor == StageAlign.TOP) {
				fp.x = hs5.x,fp.y = hs5.y;
				currentHS = hs5;
			} else if (cor == StageAlign.BOTTOM) {
				fp.x = hs6.x,fp.y = hs6.y;
				currentHS = hs6;
			} else if (cor == StageAlign.LEFT) {
				fp.x = hs7.x,fp.y = hs7.y;
				currentHS = hs7;
			} else if (cor == StageAlign.RIGHT) {
				fp.x = hs8.x,fp.y = hs8.y;
				currentHS = hs8;
			}
			m_startpoint = fp;//设置起点坐标
			fadeInShadow ();//添加阴影
			currentPaper = paper;
			currentPaper.setCor (cor,areFlip);
			papers.setChildIndex (currentPaper,papers.numChildren-1);
		}
		//设置翻页角度
		public function SetAngle (currentHS:HotSpot) {
			if (currentHS==hs1) {
				m_angle = m_endpoint.y / m_endpoint.x;
			} else if (currentHS==hs2) {
				m_angle = m_endpoint.y / (_width - m_endpoint.x);
			} else if (currentHS==hs3) {
				m_angle = (_height - m_endpoint.y) / m_endpoint.x;
			} else if (currentHS==hs4) {
				m_angle = (_height - m_endpoint.y) / (_width - m_endpoint.x);
			} else {
				m_angle = 0;
			}
		}
		//更新fp点坐标
		private function updatefp () {
			if (isReady) {
				//当前翻页点为hs5,hs6
				if (currentHS==hs5||currentHS==hs6) {
					fp.x = m_endpoint.x;
					if (currentHS==hs5) {
						if (m_startpoint.y < m_endpoint.y) {
							m_startpoint.y +=  _xy;
							fp.y +=  (m_startpoint.y - fp.y) * 0.6;
						}
					}
					if (currentHS==hs6) {
						if (m_startpoint.y > m_endpoint.y) {
							m_startpoint.y -=  _xy;
							fp.y +=  (m_startpoint.y - fp.y) * 0.6;
						}
					}
				} else {
					//当前翻页点为hs1,hs3,hs7
					if (m_startpoint.x < m_endpoint.x) {
						m_startpoint.x +=  _xy;
						fp.x +=  (m_startpoint.x - fp.x) * 0.6;
						if (m_startpoint.y < m_endpoint.y) {
							m_startpoint.y +=  _xy * m_angle;
						}
						if (m_startpoint.y > m_endpoint.y) {
							m_startpoint.y -=  _xy * m_angle;
						}
						fp.y +=  (m_startpoint.y - fp.y) * 0.6;
					}
					//当前翻页点为hs2,hs4,hs8
					if (m_startpoint.x > m_endpoint.x) {
						m_startpoint.x -=  _xy;
						fp.x +=  (m_startpoint.x - fp.x) * 0.6;
						if (m_startpoint.y < m_endpoint.y) {
							m_startpoint.y +=  _xy * m_angle;
						}
						if (m_startpoint.y > m_endpoint.y) {
							m_startpoint.y -=  _xy * m_angle;
						}
						fp.y +=  (m_startpoint.y - fp.y) * 0.6;
					}
				}
			} else {
				meHandler ();
				isReady = true;
			}
		}
		/*
		 * 执行翻页
		*/
		private function meHandler ():void {
			var lpoint = new Point(currentPaper.lp.point.x,currentPaper.lp.point.y);
			gotoHSPoint (currentHS,lpoint);

		}
		/*
		 * 翻页
		 @ _hs 翻牌点
		 @ point 当前鼠标位置
		*/
		private function gotoHSPoint (_hs,point:Point):void {
			var hs = _hs;
			//翻页
			if (isTurn) {
				if (hs==hs1||hs==hs3||hs==hs7) {
					areFlip = ! areFlip;
					hs == hs1 && currentPaper.setCor("TL",areFlip);
					hs == hs3 && currentPaper.setCor("BL",areFlip);
					hs == hs7 && currentPaper.setCor("L",areFlip);
					if (hs==hs1||hs==hs7) {
						fp = new Point(0,0);//翻页后将fp坐标重置
					}
					if (hs==hs3) {
						fp = new Point(1,_height);
					}
				} else if (hs==hs2||hs==hs4||hs==hs8) {
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
				} else if (hs==hs5) {
					areFlip = ! areFlip;
					hs == hs5 && currentPaper.setCor("T",areFlip);
					fp=new Point(_width/2,0);
				} else if (hs==hs6) {
					areFlip = ! areFlip;
					hs == hs6 && currentPaper.setCor("B",areFlip);
					fp=new Point(_width/2,_height);
				}
				fadeOutShadow ();
				papers.setChildIndex (paper,papers.numChildren-1);
				//交换层次;
				//显示翻牌结果
				hs == hs1 && currentPaper.setCor("TL",areFlip);
				hs == hs2 && currentPaper.setCor("TR",areFlip);
				hs == hs3 && currentPaper.setCor("BL",areFlip);
				hs == hs4 && currentPaper.setCor("BR",areFlip);
				hs == hs5 && currentPaper.setCor("T",areFlip);
				hs == hs6 && currentPaper.setCor("B",areFlip);
				hs == hs7 && currentPaper.setCor("L",areFlip);
				hs == hs8 && currentPaper.setCor("R",areFlip);
				return;
			}
			//返回;
			//Tweener.removeTweens (fp);
			Tweener.addTween (fp, {x:hs.x,y:hs.y, time:0.5, transition:"easeOutBack",onComplete:complete});
			//完成
			function complete () {
				fadeOutShadow ();
				papers.setChildIndex (paper,papers.numChildren-1);
				//交换层次;
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
		private function fadeInShadow () {
			//Tweener.removeTweens (shadowF);
			//Tweener.removeTweens (shadowFR);
			//shadowFR.visible = shadowF.visible = true;
			//Tweener.addTween (shadowF, {alpha:1,visible:true, time:0, transition:"easeOutSine"});
			//Tweener.addTween (shadowFR, {alpha:1,visible:true, time:0, transition:"easeOutSine"});
		}
		/*
		 * 淡入出阴影
		*/
		private function fadeOutShadow () {
			//Tweener.removeTweens (shadowF);
			//Tweener.removeTweens (shadowFR);
			//Tweener.addTween (shadowF, {alpha:0,visible:false, time:.5, transition:"easeOutSine"});
			//Tweener.addTween (shadowFR, {alpha:0,visible:false, time:.5, transition:"easeOutSine"});
		}

		public function Destory () {
			for (var index:int=this.numChildren-1; index>=0; index--) {
				this.removeChildAt (index);
			}
		}
	}
}