package {
     /**
          by kingofkofs
     */
	import flash.display.DisplayObject
	import flash.display.MovieClip
	import flash.display.Sprite
	
	import flash.geom.Point
	import flash.events.Event
	import flash.display.StageAlign
	public class Paper extends Sprite {        
		
		private var pageMC:Page=null;//牌页面
		public var lp:LimitPoint=null;//极限点
		public var currentCor:String;//当前翻页点
		public var currentDir:String="right";//阴影方向
		public var targetPage:Sprite;//目标页
		private var mask_mc=new p;//遮罩层
		private var _width:Number; //宽
		private var _height:Number;//高
		
		public function Paper(pa,pb,pwid,phei) {			
			addChild(mask_mc);
			_width=pwid;
			_height=phei;
		    mask_mc.width=Math.sqrt(_width*_width+_height*_height);			
			mask_mc.height=mask_mc.width*2;
			
        	lp=new LimitPoint();
        	lp.O=new Point(0,phei/2);
        	lp.setSize(pwid,phei,new Point());
       		pageMC=new Page(pa,pb,pwid,phei);
			pageMC.mask=mask_mc;
			this.addChild(pageMC);
			setCor(StageAlign.BOTTOM_RIGHT,true); 
        	setChildIndex(mask_mc,numChildren-1);
		
		}
		//设置牌点数
		public function SetPkNumber(number:int) {
			pageMC.SetPkNumber(number);
		}
		
		/*
		 * 设置阴影方向，极限点以及固定位置
		 @ Cor 翻页点
		 @ isFist 是否第一次
		*/
		public function setCor(Cor:String,isFist:Boolean){
			
			currentCor=Cor;
			pageMC.setCor(Cor,isFist);
			
			targetPage=pageMC._target;
			if(Cor==StageAlign.TOP_RIGHT||Cor==StageAlign.BOTTOM_RIGHT){
				currentDir="right";
			}else{
				currentDir="left";
				
			}
			if(Cor==StageAlign.TOP||Cor==StageAlign.RIGHT||Cor==StageAlign.BOTTOM){
				currentDir="right";
			}
			if(Cor==StageAlign.LEFT){
				currentDir="left";
			}
			if(Cor==StageAlign.TOP_LEFT||Cor==StageAlign.TOP_RIGHT){
				mask_mc.y=0;
			}else if(Cor==StageAlign.BOTTOM_LEFT||Cor==StageAlign.BOTTOM_RIGHT){
				mask_mc.y=_height;
			}
			lp.changeTo(Cor)
			
			fix(Cor)			
			
		}
		
		
		/*
		 * 设置遮罩层位置和目标页位置
		 @ 翻页点
		*/
		private function fix(Cor){
			if(Cor=="TL"){
				mask_mc.x=0
				mask_mc.y=0
		        mask_mc.rotation=180
				targetPage.rotation=90
				targetPage.x=0
				targetPage.y=-_height
			}else if(Cor=="TR"){
				mask_mc.x=0
				mask_mc.y=0
		        mask_mc.rotation=180
				targetPage.rotation=90
				targetPage.x=-_width
				targetPage.y=_height
			}else if(Cor=="BL"){
				mask_mc.x=0
		        mask_mc.rotation=180
				targetPage.rotation=90
				targetPage.x=-_width
				targetPage.y=-_height
			}else if(Cor=="BR"){
				mask_mc.x=0
		        mask_mc.rotation=180
				targetPage.rotation=90
				targetPage.x=-_width
				targetPage.y=-_height
			}else if(Cor=="T"){
				mask_mc.x=0;
				mask_mc.y=0;
				mask_mc.rotation=180
				targetPage.rotation=90
				targetPage.x=-_width
				targetPage.y=_height
			}else if(Cor=="B"){
				mask_mc.x=0;
				mask_mc.y=_height;
				mask_mc.rotation=180
				targetPage.rotation=90
				targetPage.x=-_width
				targetPage.y=-_height
			}else if(Cor=="L"){
				mask_mc.x=0;
				mask_mc.y=_height;
				mask_mc.rotation=180
				targetPage.rotation=90
				targetPage.y=-_height;
				targetPage.x=-_width
			}else if(Cor=="R"){
				mask_mc.x=0;
				mask_mc.y=_height;
				mask_mc.rotation=180
				targetPage.rotation=90
				targetPage.y=_height
				targetPage.x=-_width
			}
		}
		
		/*
		 * 更新遮罩层位置
		 @ point 当前位置
		 @ cor 当前翻页点
		*/
		public function Update(point:Point,cor:String):void{
			lp.update(point.x,point.y,cor)
			update()
		}
		
		/*
		 * 更新遮罩层位置
		*/
		private function update():void{			
			targetPage.x=lp.point.x
			targetPage.y=lp.point.y
			pageMC.updateRotation(lp.point.x,lp.point.y)			
			var _sin=Math.sin(pageMC.angle*2)			
			var _x
			if(currentCor==StageAlign.BOTTOM_RIGHT){
				_x=_width-(_height-lp.point.y)/_sin
				if(!_sin){
			   		mask_mc.x=_width-(_width-lp.point.x)/2
				}else{
					if(_sin>0){
			   		if(_x>0 ){
			   			    mask_mc.x=_x
						    mask_mc.y=_height;
						}else{
							mask_mc.x=0
						    mask_mc.y=_height-(_x)*Math.tan(Math.PI/2+pageMC.angle);
						}
					}
				}
				mask_mc.rotation=pageMC._rotation/2
			
			}else if(currentCor==StageAlign.TOP_RIGHT){
				_x=_width-(-lp.point.y)/_sin
				if(!_sin){
			  	 mask_mc.x=_width-(_width-lp.point.x)/2
				}else{
			  	         if(_x>0){
			   			mask_mc.x=_x
						mask_mc.y=0
						}else{
							mask_mc.x=0;
						    mask_mc.y=_x*Math.tan(Math.PI/2-pageMC.angle);
						}
				}
				mask_mc.rotation=pageMC._rotation/2
			}else if(currentCor==StageAlign.TOP_LEFT){
				_x=lp.point.y/_sin				
				if(pageMC.angle==Math.PI){
			   	mask_mc.x=lp.point.x/2+lp.point.x
				}else{
					if(_sin>=0){
						if(_x<_width){
			   			mask_mc.x=_x
						mask_mc.y=0
						}else{
							mask_mc.x=_width
						    mask_mc.y=(_x-_width)*Math.tan(Math.PI/2-pageMC.angle);
						}
					}else{
					 	mask_mc.x=0
					}
				}
			   	mask_mc.rotation=pageMC._rotation/2
			}else if(currentCor==StageAlign.BOTTOM_LEFT){
				_x=-(_height-lp.point.y)/_sin
				if(pageMC.angle==Math.PI){
			   		mask_mc.x=(-lp.point.x)/2+lp.point.x
				}else{
					if(_sin<=0){
			      		if(_x<_width){
			   			    mask_mc.x=_x
						    mask_mc.y=_height;
						}else{
							mask_mc.x=_width
						    mask_mc.y=_height-(_x-_width)*Math.tan(Math.PI/2+pageMC.angle);
						}
				  
					}else{
					 	mask_mc.x=0
					}
				}
				mask_mc.rotation=pageMC._rotation/2	
			}else if(currentCor==StageAlign.TOP){
				targetPage.x=0;
				targetPage.rotation=180
				mask_mc.x=0;
				mask_mc.y=lp.point.y/2
				mask_mc.rotation=-90
			}else if(currentCor==StageAlign.BOTTOM){
				targetPage.x=0;
				targetPage.rotation=-180
				mask_mc.x=0;
				mask_mc.y=(lp.point.y+_height)/2
				mask_mc.rotation=90
			}else if(currentCor==StageAlign.LEFT){
				targetPage.rotation=0
				targetPage.y=_height
				mask_mc.x=lp.point.x/2
				mask_mc.rotation=180
			}else if(currentCor==StageAlign.RIGHT){
				targetPage.rotation=0
				targetPage.y=0
				mask_mc.y=0;
				mask_mc.x=(_width+lp.point.x)/2
				mask_mc.rotation=0
			}
			
		}
		
		//返回遮罩层旋转角度
		public function get mask_rotation(){
			return  mask_mc.rotation
		}
		
		//返回遮罩层x坐标
		public function get mask_x(){
			return  mask_mc.x
		}
		
		//返回遮罩层y坐标
		public function get mask_y(){
			return  mask_mc.y
		}
		
		//返回页面
		public function get page(){
			return pageMC._target.getChildAt(0)
		}
	}
}
