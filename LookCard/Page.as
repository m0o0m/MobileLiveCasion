package {

	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.geom.Point;
	import flash.display.MovieClip;

	/*
	 * 翻页
	*/
	public class Page extends Sprite {
		private var c_mc1:Sprite,c_mc2:Sprite;//c_mc1 牌背面容器 c_mc2 牌正面容器
		private var target:Sprite;//目标页
		private var wid:Number,hei:Number;//宽度 高度
		private var pa:MovieClip,pb:MovieClip;//pa 牌背面 pb 牌正面
		private var targetPoint:Point=new Point();//目标位置
		public var _rotation:Number;//选择角度
		public var angle:Number;//正玄值

		/*
		 * 初始化方法
		 @ _pa 背面
		 @ _pb 正面
		 @ _w 宽
		 @ _h 高
		*/
		public function Page(_pa,_pb,_w,_h) {
			pa = _pa;
			pb = _pb;
			pa.height=_h;
			pa.width=_w;
			pb.width = _w;
			pb.height = _h;
			wid = _w;
			hei = _h;
			c_mc1=new Sprite();
			c_mc2=new Sprite();
			addChild(c_mc1);
			addChild(c_mc2);
			c_mc1.addChild(_pa);
			c_mc2.addChild(_pb);
			target = c_mc2;
		}
		//设置牌点数
		public function SetPkNumber(number:int) {
			pb.gotoAndStop(number);
		}
		/*
		 * 返回目标页
		*/
		public function get _target() {
			return target;
		}

		/*
		 * 更新角度
		 @ _x 鼠标x坐标
		 @ _y 鼠标y坐标
		*/
		public function updateRotation(_x,_y) {
			angle = Math.atan2(targetPoint.y - _y,targetPoint.x - _x);
			_rotation = target.rotation = 2 * angle * 180 / Math.PI;
		}

		/*
		 * 设置目标点，目标位置和翻页
		 @ _str 翻页点
		 @ isFister 是否翻页 true 翻页 false 返回原状
		*/
		public function setCor(_str:String,isFister:Boolean):void {
			switch (_str) {
				case StageAlign.TOP_LEFT :
					if (isFister==true) {
						pa.x = 0;
						pa.y = 0;
						pb.x =  -  wid;
						pb.y = 0;
						target = c_mc2;
						targetPoint.x = 0;
						targetPoint.y = 0;
						c_mc1.rotation = 0;
						c_mc1.y = 0;
						c_mc1.x = 0;
						setChildIndex(c_mc2,numChildren-1);
					} else {
						pb.x = 0;
						pb.y = 0;
						pa.x =  -  wid;
						pa.y = 0;
						target = c_mc1;
						targetPoint.x = 0;
						targetPoint.y = 0;
						c_mc2.rotation = 0;
						c_mc2.y = 0;
						c_mc2.x = 0;
						setChildIndex(c_mc1,numChildren-1);
					}

					break;
				case StageAlign.TOP_RIGHT :

					if (isFister==true) {
						pa.x = 0;
						pa.y = 0;
						c_mc1.x = 0;
						c_mc1.y = 0;
						pb.x = 0;
						pb.y = 0;
						target = c_mc2;
						targetPoint.x = wid;
						targetPoint.y = 0;
						c_mc1.rotation = 0;
						setChildIndex(c_mc2,numChildren-1);
					} else {
						pb.x = 0;
						pb.y = 0;
						c_mc2.x = 0;
						c_mc2.y = 0;
						pa.x = 0;
						pa.y = 0;
						target = c_mc1;
						targetPoint.x = wid;
						targetPoint.y = 0;
						c_mc2.rotation = 0;
						setChildIndex(c_mc1,numChildren-1);
					}
					break;
				case StageAlign.BOTTOM_LEFT :
					if (isFister==true) {
						pa.x = 0;
						pa.y = 0;
						pb.x =  -  wid;
						pb.y =  -  hei;
						target = c_mc2;
						targetPoint.x = 0;
						targetPoint.y = hei;
						c_mc1.rotation = 0;
						c_mc1.y = 0;
						c_mc1.x = 0;
						setChildIndex(c_mc2,numChildren-1);
					} else {
						pb.x = 0;
						pb.y = 0;
						pa.x =  -  wid;
						pa.y =  -  hei;
						target = c_mc1;
						targetPoint.x = 0;
						targetPoint.y = hei;
						c_mc2.rotation = 0;
						c_mc2.y = 0;
						c_mc2.x = 0;
						setChildIndex(c_mc1,numChildren-1);
					}
					break;
				case StageAlign.BOTTOM_RIGHT :
					if (isFister==true) {
						pa.x = 0;
						pa.y = 0;
						pb.x = 0;
						pb.y =  -  hei;
						target = c_mc2;
						targetPoint.x = wid;
						targetPoint.y = hei;
						c_mc1.rotation = 0;
						c_mc1.y = 0;
						c_mc1.x = 0;
						setChildIndex(c_mc2,numChildren-1);
					} else {
						pb.x = 0;
						pb.y = 0;
						pa.x = 0;
						pa.y =  -  hei;
						target = c_mc1;
						targetPoint.x = wid;
						targetPoint.y = hei;
						c_mc2.rotation = 0;
						c_mc2.y = 0;
						c_mc2.x = 0;
						setChildIndex(c_mc1,numChildren-1);
					}
					break;
				case StageAlign.TOP :
					if (isFister==true) {
						pa.x = 0;
						pa.y = 0;
						c_mc1.x = 0;
						c_mc1.y = 0;
						pb.x =  -  wid;
						pb.y = 0;
						target = c_mc2;
						targetPoint.x = wid / 2;
						targetPoint.y = 0;
						c_mc1.rotation = 0;
						setChildIndex(c_mc2,numChildren-1);
					} else {
						pb.x = 0;
						pb.y = 0;
						c_mc2.x = 0;
						c_mc2.y = 0;
						pa.x =  -  wid;
						pa.y = 0;
						target = c_mc1;
						targetPoint.x = wid / 2;
						targetPoint.y = 0;
						c_mc2.rotation = 0;
						setChildIndex(c_mc1,numChildren-1);
					}
					break;
				case StageAlign.BOTTOM :
					if (isFister==true) {
						pa.x = 0;
						pa.y = 0;
						c_mc1.x = 0;
						c_mc1.y = 0;
						pb.x =  -  wid;
						pb.y =  -  hei;
						target = c_mc2;
						targetPoint.x = wid / 2;
						targetPoint.y = hei;
						c_mc1.rotation = 0;
						setChildIndex(c_mc2,numChildren-1);
					} else {
						pb.x = 0;
						pb.y = 0;
						c_mc2.x = 0;
						c_mc2.y = 0;
						pa.x =  -  wid;
						pa.y =  -  hei;
						target = c_mc1;
						targetPoint.x = wid / 2;
						targetPoint.y = hei;
						c_mc2.rotation = 0;
						setChildIndex(c_mc1,numChildren-1);
					}
					break;
				case StageAlign.LEFT :
					if (isFister==true) {
						pa.x = 0;
						pa.y = 0;
						c_mc1.x = 0;
						c_mc1.y = 0;
						pb.x =  -  wid;
						pb.y =  -  hei;
						target = c_mc2;
						targetPoint.x = 0;
						targetPoint.y = hei / 2;
						c_mc1.rotation = 0;
						setChildIndex(c_mc2,numChildren-1);
					} else {
						pb.x = 0;
						pb.y = 0;
						c_mc2.x = 0;
						c_mc2.y = 0;
						pa.x =  -  wid;
						pa.y =  -  hei;
						target = c_mc1;
						targetPoint.x = 0;
						targetPoint.y = hei / 2;
						c_mc2.rotation = 0;
						setChildIndex(c_mc1,numChildren-1);
					}
					break;
				case StageAlign.RIGHT :
					if (isFister==true) {
						pa.x = 0;
						pa.y = 0;
						c_mc1.x = 0;
						c_mc1.y = 0;
						pb.x = 0;
						pb.y = 0;
						target = c_mc2;
						targetPoint.x = wid;
						targetPoint.y = hei / 2;
						c_mc1.rotation = 0;
						setChildIndex(c_mc2,numChildren-1);
					} else {
						pb.x = 0;
						pb.y = 0;
						c_mc2.x = 0;
						c_mc2.y = 0;
						pa.x = 0;
						pa.y = 0;
						target = c_mc1;
						targetPoint.x = wid;
						targetPoint.y = hei / 2;
						c_mc2.rotation = 0;
						setChildIndex(c_mc1,numChildren-1);
					}
					break;
			}
		}
	}
}