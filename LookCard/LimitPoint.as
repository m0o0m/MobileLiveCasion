package {
	 
	 /*
	  * 极限点
     */
    import flash.geom.Point
	import flash.display.StageAlign
	public class LimitPoint {


		private var width:Number;//宽
		private var height:Number;//高
		
		private var isStageAlign:String=StageAlign.BOTTOM_RIGHT;//默认翻页点
		
		public var isTop:Boolean;//翻页点是否在上面		
		
		private var tPoint:Point=new Point();//左上翻页点位置
		private var bPoint:Point=new Point();//左下翻页点位置
		
		private var Op:Point=new Point();//默认极限点
		public var _point:Point=new Point();//当前坐标
		
		public function LimitPoint() {
		}
		
		/*
		 * 设置大小
		 @ wid 宽
		 @ hei 高
		 @ initPoint 初始位置
		*/
		public function setSize(wid:Number,hei:Number,initPoint:Point):void {
			_point=new Point()
			width=wid;
			height=hei;
			tPoint=new Point(Op.x,Op.y-hei/2)
			bPoint=new Point(Op.x,Op.y+hei/2)
			update(initPoint.x,initPoint.y,StageAlign.BOTTOM_RIGHT)
		}
		
		/*
		 * 设置左上，右上，左下，右下极限点
		 @ cor 翻页点
		*/
		private function change(cor:String){
			var strT:String;
			if(cor==StageAlign.BOTTOM_RIGHT)
			{
				strT="bottom"
				tPoint.x=0;
				tPoint.y=0;
				bPoint.x=0
				bPoint.y=height/2
			}else if(cor==StageAlign.TOP_RIGHT){
				strT="top"
				tPoint.x=0;
				tPoint.y=height;
				bPoint.x=0
				bPoint.y=height/2;
			}else if(cor==StageAlign.BOTTOM_LEFT){
				strT="bottom"
				tPoint.x=width;
				tPoint.y=0;
				bPoint.x=width
				bPoint.y=height/2;
			}else if(cor==StageAlign.TOP_LEFT){
				strT="top"
				tPoint.x=width;
				tPoint.y=height;
				bPoint.x=width;
				bPoint.y=height/2;
			}
			if(strT=="top"){			
				isTop=true;
			}else{
				isTop=false;
			}
			return isTop
			
		}
		
		/*
		 * 更新极限点
		 @ cor 翻页点
		*/
		public function changeTo(cor:String){
			if(cor!=isStageAlign)
			{
				isStageAlign=cor;
				change(cor);
			}
		}
		
		//结束时默认坐标点
		public function close(){			
		   _point.x=width
		   _point.y=height
		}
		
		/*
		 *更新当前坐标点位置
		 @ _x 鼠标x坐标
		 @ _y 鼠标y坐标
		 @　cor 翻页点
		*/
		public function update(_x,_y,cor:String):void {
            var angle:Number;
			var m_wid=2*width*height*height/(Math.sqrt(width*width+height*height)*Math.sqrt(width*width+height*height));
			if(cor==StageAlign.LEFT||cor==StageAlign.RIGHT||cor==StageAlign.TOP||cor==StageAlign.BOTTOM){
				_point.x=_x
			    _point.y=_y
			}else{
				if((!isTop&&_y<=Op.y+height/2)||(isTop&&_y>=Op.y-height/2)){
					if(getDis(bPoint.x,bPoint.y,_x,_y)<=Math.sqrt(width*width+height*height/4) ) {					
			     		_point.x=_x
			     		_point.y=_y
				  	}else{
						/*angle=getAngleByPoint(bPoint.x,bPoint.y,_x,_y)
						_point.x=Math.cos(angle)* width+bPoint.x
						_point.y=Math.sin(angle)* width+bPoint.y*/
				  	}
			  	}
			}
			//当前坐标保证在规定范围内
			if(cor==StageAlign.TOP_LEFT || cor==StageAlign.BOTTOM_LEFT || cor==StageAlign.LEFT){
				if(_point.x<=0){
				   _point.x=1;
			     }
				 if(_point.x>m_wid){
				   _point.x=m_wid;
			     }
				 if(cor==StageAlign.TOP_LEFT && _point.y>height){
					 _point.y=height;
				 }else if(cor==StageAlign.BOTTOM_LEFT && _point.y<0){
					 _point.y=0;
				 }
			}
			else if(cor==StageAlign.BOTTOM_RIGHT || cor==StageAlign.TOP_RIGHT || cor==StageAlign.RIGHT){
				if(_point.x>=width){
				   _point.x=width-1;
			     }
				 if(_point.x<width-m_wid){
				   _point.x=width-m_wid;
			     }
				 if(cor==StageAlign.TOP_RIGHT  && _point.y>height){
					 _point.y=height;
				 }else if(cor==StageAlign.BOTTOM_RIGHT && _point.y<0){
					 _point.y=0;
				 }
			}
			else if(cor==StageAlign.TOP){
				if(_point.y<0){
				   _point.y=0;
			     }
				 if(_point.y>height*6/5){
					 _point.y=height*6/5;
				 }
			}
			else if(cor==StageAlign.BOTTOM){
				if(_point.y>height){
				   _point.y=height;
			     }
				 if(_point.y<-height/5){
					   _point.y=-height/5 ;
				 }
			}
		}
		private function getDis(p1x,p1y,p2x,p2y):Number{ //求两点之间的距离
			var a=Math.abs(p1x-p2x)
			var b=Math.abs(p1y-p2y)
			return Math.sqrt(a*a+b*b)
		}
		private function getAngleByPoint(p1x,p1y,p2x,p2y){ //求两点所在直线的角度
			return Math.atan2(p2y-p1y,p2x-p1x)
		}
		
		/*
		 * 设置默认极限点
		*/
		public function set O(_p){
			Op=_p
		}
		
		/*
		 * 得到当前坐标
		*/
		public function get point(){
			return _point
		}
		
	}
}