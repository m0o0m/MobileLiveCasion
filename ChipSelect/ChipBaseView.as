package ChipSelect {
	
	import flash.display.MovieClip;
	import flash.utils.getDefinitionByName;
	import flash.events.MouseEvent;
	
	public class ChipBaseView extends MovieClip {
		
		protected var chbm:ChipSelectBaseManager=null;//筹码堆管理
		
		public var money:Number;//筹码表示的钱
		public var posIndex:int;//位置索引
		public var hasSelect:Boolean=false;//是否选中
		
		protected var m_chipStatus:Boolean=false;//是否响应鼠标事件
		protected var mvu_chipStatus:Boolean=false;//是否响应移上移除事件
		protected var chipType:Boolean=true;//点击类型 true表示当前可用的，false表示总筹码
		
		protected var _width:Number=48.7;//背景宽度
		protected var _height:Number=42.05;//背景高度
		protected var _x:Number=-2;//背景x坐标
		protected var _y:Number=-6;//背景y坐标
		
		protected var m_chip:Object;
		
		/*
		 * 筹码父类
		*/
		public function ChipBaseView() {
			this.addEventListener(MouseEvent.CLICK, OnClickChip);
			this.addEventListener(MouseEvent.MOUSE_OVER, OnMouseOverChip);
			this.addEventListener(MouseEvent.MOUSE_OUT, OnMouseOutChip);
			m_chip = this.getChildByName("m_bg");
			/*var m_num:Object=this.getChildByName("valueTf");
			if(m_num){
				m_num.mouseEnabled=false;
			}*/
			if(m_chip){
				m_chip.stop()
			}
		}
		public function ShowBg(bool:Boolean):void{
			if(m_chip){
			    if(bool){
				    m_chip.gotoAndStop(11);
					SetValueEnabled();
			    }
			    else{
				     m_chip.gotoAndStop(1);
					 SetValueEnabled();
			    }
			}
		}
		/*
		 * 添加底色
		*/
		public function AddBgColor():void{
			var _color:int=0x66CCFF;
			var _alpha:Number=0.6;
			graphics.beginFill(_color,_alpha);
			graphics.drawRect(_x,_y,_width,_height);
			graphics.endFill();
		}
		
		/*
		 * 销毁
		*/
		public function Destroy ():void {			
			this.removeEventListener(MouseEvent.CLICK, OnClickChip);
			this.removeEventListener(MouseEvent.MOUSE_OVER, OnMouseOverChip);
			this.removeEventListener(MouseEvent.MOUSE_OUT, OnMouseOutChip);
			chbm=null;
			ShowBg(false);
		}
		
		/*
		 * 实例化筹码堆管理
		 @ chipHeapManger 筹码堆管理
		*/
		public function SetChipHeapManger(chipHeapManger:ChipSelectBaseManager):void{
			if(chipHeapManger){
				chbm=chipHeapManger;
			}			
		}
		
		/*
		 * 设置选中筹码
		*/
		public function SetSelectChip():void{
			if(chbm){					
				chbm.OnClickSelectChip(this);
				this.hasSelect=true;
				if(m_chip){
				    m_chip.gotoAndStop(2);
					SetValueEnabled();
			    }
			}
		}
		
		/*
		 * 设置筹码类型
		 hasCurrent 类型 true表示当前选中的 false表示总筹码
		*/
		public function SetChipType(hasCurrent:Boolean):void{
			chipType=hasCurrent;
		}
		
		/*
		 * 设置筹码是否响应事件
		 * chipStatus ture 响应 false 不响应
		*/
		public function SetChipStatus(chipStatus:Boolean):void {
			m_chipStatus=chipStatus;
			if(chipStatus) {
				this.buttonMode = true;
				this.mouseChildren=false;
			} else {
				this.buttonMode = false;
			}
		}
		
		/*
		 * 设置鼠标移上移除是否可用
		 vt 状态 true 可用 false不可用
		*/
		public function SetChipOverOrOutStatus(vt:Boolean):void{
			mvu_chipStatus=vt;
		}
		
		/*
		 * 清除筹码背景
		*/
		public function ClearBg():void{
			ShowBg(false);
			hasSelect=false;
		}
		
		/*
		 * 筹码点击事件
		*/
		public function OnClickChip(e:MouseEvent):void{			
			if(m_chipStatus){
				if(chipType){//可用筹码
					if(!hasSelect){
						SetSelectChip();
					}			
				}else{//总筹码容器中的筹码
					if(hasSelect){
						ShowBg(false);
					}else{
						//ShowBg(true);
						ShowSelectBg()
					}
					chbm.OnClickTotalChip(posIndex,hasSelect);
					hasSelect=!hasSelect;
				}
				
			}			
		}
		
		/*
		 * 鼠标移上
		*/
		public function OnMouseOverChip(e:MouseEvent):void{
			if(m_chipStatus&&mvu_chipStatus){
				if(!hasSelect){
					ShowBg(true);
				}
			}
		}
		
		/*
		 * 鼠标移除
		*/
		public function OnMouseOutChip(e:MouseEvent):void{
			if(m_chipStatus&&mvu_chipStatus){
				if(!hasSelect){
					ShowBg(false);
				}
			}
		}
		public function SetLang(strlang:String):void{
			
		}
		//显示被选中背景
		public function ShowSelectBg(){
			if(m_chip){
				m_chip.gotoAndStop(21);
				SetValueEnabled();
			}
		}
		protected function SetValueEnabled():void{
			if(this["m_bg"].getChildByName("valueTf")){
				this["m_bg"]["valueTf"].mouseEnabled=false;
			}
			
			if(this["m_bg"].getChildByName("mc_numbg")){
				this["m_bg"]["mc_numbg"].mouseEnabled=false;
			}
		}
	}
	
}
