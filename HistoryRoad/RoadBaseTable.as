package HistoryRoad {
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.utils.getDefinitionByName;
	import flash.display.Graphics;
	import flash.text.TextField;
	import flash.events.MouseEvent;
	
	/*
	 * 路子列表父类
	*/
	public class RoadBaseTable extends MovieClip {
		
		public var posViewName:String;//路子结果形状，类名
		
		protected var askRoad:*=null;//问路图形
		protected var lastRoadView:*=null;//最后一个图形对象		
		
		protected var row:int=6;//表格行数
		protected var posArray:Array;//标识表格占位
		
		protected var mc_mask:Sprite=null;//遮罩层
		protected var _x:Number=-1;//遮罩层的x坐标
		protected var _y:Number=-1;//遮罩层的y坐标
		protected var _width:Number=0;//表格宽度
		protected var _height:Number=0;//表格高度
		protected var MovingDistance:Number=0;//内容超出后移动的宽度
		
		protected var mcParent:Sprite;//路子图形容器
		protected var btnLeftMobile:BtnMobile=null;//左边滚动按钮
		protected var btnRightMobile:BtnMobile=null;//右边滚动按钮
		
		protected var m_lang:String//当前语言
		
		public function RoadBaseTable() {			
			
		}
		
		//销毁
		public function Destroy():void{
			if(mcParent!=null){
				if(mcParent.numChildren>0){
					var index=mcParent.numChildren-1;
					while(index>=0){
						mcParent.removeChildAt(index);
						index--;
					}
				}
				removeChild(mcParent)
				mcParent=null;
			}
			
			if(mc_mask!=null){
				removeChild(mc_mask);
				mc_mask=null;
			}
			
			lastRoadView=null;
			askRoad=null;
			
			posArray=null;
			
			//左右滚动按钮
			if(btnLeftMobile==null){
				removeChild(btnLeftMobile);
				btnLeftMobile=null;
			}
			if(btnRightMobile==null){
				removeChild(btnRightMobile);
				btnRightMobile=null;
			}
		}		
		
		//洗牌
		public function Shuffle():void{
			if(mcParent!=null){
				if(mcParent.numChildren>0){
					var index=mcParent.numChildren-1;
					while(index>=0){
						mcParent.removeChildAt(index);
						index--;
					}
				}
				mcParent.x=0;
				mcParent.y=0;
			}
			
			
			lastRoadView=null;
			askRoad=null;
			
			posArray=new Array();
			posArray.push(new Array(row));
			
			//左右滚动按钮
			if(btnLeftMobile){
				btnLeftMobile.alpha=0;
				btnLeftMobile.buttonMode=false;
			}
			if(btnRightMobile){
				btnRightMobile.alpha=0;
				btnRightMobile.buttonMode=false;
			}
			
		}
		
		//初始化
		public function Initialize():void{
			posArray=new Array();
			posArray.push(new Array(row));
			
			//路子容器
			mcParent = new Sprite();
			addChild(mcParent);	
			
			//遮罩层
			mc_mask=RoadMask(_x,_y,_width,_height);
			addChild(mc_mask);
			mask=mc_mask;
			
			//滚动按钮
			btnLeftMobile=new BtnMobile(_width,_height,MobileRoadEvent,true);
			addChild(btnLeftMobile);
			btnRightMobile=new BtnMobile(_width,_height,MobileRoadEvent,false);
			addChild(btnRightMobile);
		}
		
		//左右滚动事件
		public function MobileRoadEvent(e:MouseEvent){			
			if(e.target.alpha<=0){
				return;
			}
			if(e.type==MouseEvent.CLICK){
				if(e.target==btnLeftMobile){
					if(mcParent.x>=0){
						mcParent.x=0;
					}else{
						mcParent.x+=MovingDistance;
					}
					ShowMoilbBtn();
				}else{
					if(mcParent.x+mcParent.width>_width){
						mcParent.x-=MovingDistance;
					}
					ShowMoilbBtn();
				}
			}else if(e.type==MouseEvent.MOUSE_OUT){
				e.target.alpha=0.2;
			}else if(e.type==MouseEvent.MOUSE_OVER){
				e.target.alpha=0.6;
			}
		}
		
		/*
		 * 显示路子
		 @ number 路子结果对应的索引
		*/
		public function ShowRoad(number:int):void{
			RemoveAsk();
			var roadClass:Class = getDefinitionByName(posViewName) as Class;
			var rc:*=new roadClass(number);
			rc.RoadPosition(lastRoadView,number,posArray);
			rc.SetLang(m_lang);
			lastRoadView=rc;
			FillingArray(rc.Column,rc.Row,1);
			mcParent.addChild(rc);
			MobileRoad();
		}
		
		/*
		 * 显示问路
		 @ number 问路结果对应的索引
		*/
		public function ShowAsk(number:Number):void{
			if(!number||number==0){
				return;
			}
			RemoveAsk();
			var roadClass:Class = getDefinitionByName(posViewName) as Class;
			askRoad=new roadClass(number);
			askRoad.SetLang(m_lang);
			askRoad.RoadPosition(lastRoadView,number,posArray);
			mcParent.addChild(askRoad);
			askRoad.alpha=0.8;
			MobileRoad();
		}
		
		//移除问路
		public function RemoveAsk():void{
			if(mcParent==null||askRoad==null){
				return;
			}
			if(mcParent.contains(askRoad)==false){
				return;
			}
			mcParent.removeChild(askRoad);
		}
		
		/*
		 * 改变路子透明度
		 @ alphaNumber 透明度
		*/
		public function RoadAlpha(alphaNumber:Number):void{
			if(!alphaNumber){
				return;
			}
			if(askRoad==null){
				return;
			}
			askRoad.alpha=alphaNumber;
		}
		
		/*
		 * 数组填充值
		 @ i 一维索引
		 @ j 二维索引
		*/
		protected function FillingArray(i:Number,j:Number,val):void{
			if(posArray.length<i+1){
				posArray.push(new Array(row));
			}
			posArray[i][j]=val;
		}
		
		//向左移动
		protected function MobileRoad():void{
			while((mcParent.x+mcParent.width)-_width>0){
				mcParent.x-=MovingDistance;
			}
			ShowMoilbBtn();
		}
		
		//是否显示滚动按钮
		protected function ShowMoilbBtn():void{
			if(mcParent.x<0){
				btnLeftMobile.alpha=0.2;
				btnLeftMobile.buttonMode=true;
			}else{
				btnLeftMobile.alpha=0;
				btnLeftMobile.buttonMode=false;
			}
			if(mcParent.x+mcParent.width>=_width){
				btnRightMobile.alpha=0.2;
				btnRightMobile.buttonMode=true;
			}else{
				btnRightMobile.alpha=0;
				btnRightMobile.buttonMode=false;
			}
		}
		
		//路子遮罩层
		protected function RoadMask(m_x:Number,m_y:Number,m_width:Number,m_height:Number):Sprite{
			var mc_mk:Sprite=new Sprite();
			var g:Graphics=mc_mk.graphics;
			g.lineStyle(0,0,1);
			g.beginFill(0xffffff,1);
			g.drawRect(m_x,m_y,m_width,m_height);
			g.endFill();			
			return mc_mk;
		}	
		public function SetLang(strlang:String):void{
			m_lang=strlang;
			
		}
	}
	
}
