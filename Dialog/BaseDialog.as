package  Dialog{
	import flash.display.MovieClip;
	import IGameFrame.ILoad;
	
	public class BaseDialog extends MovieClip{
		protected var _width:int=1440;
		protected var _height:int=800;
		protected var m_dia:SessionBox;//显示文本框
		
		protected var m_str:String;//显示字符串
		protected var m_iload:ILoad;
		public function BaseDialog() {
			// constructor code
			this.x=0;
			this.y=0;
		}
		public function InitDialog():void{
			DrowBackGround();
			InitSessionBox();
		}
		//描绘背景
		public function DrowBackGround():void{
			var _color:int=0x000000;
			var _alpha:Number=0.3;
			graphics.beginFill(_color,_alpha);
			graphics.drawRect(this.x,this.y,_width,_height);
			graphics.endFill();
		}
		//添加消息显示框
		public function InitSessionBox(){
			if(m_dia==null){
			m_dia=new SessionBox();
			}
			m_dia.x=_width*0.4;
			m_dia.y=_height*0.4;
			m_dia.GetDialog(this);
			addChild(m_dia);
			this.setChildIndex(m_dia,this.numChildren-1);
		}
		//获得字符串
		public function GetMessage(str:String):void{
			m_str=str;
			ShowMessage();
		}
		//显示消息
		public function ShowMessage():void{
			if(m_dia&&m_str){
				m_dia.ShowMessage(m_str);
			}
		}
		//销毁
		public function Destory():void{
			graphics.clear();
			if(m_dia){
			m_dia.Destory();
			removeChild(m_dia);
			m_dia=null;}
		}
		public function SetILoad(iload:ILoad):void{
			m_iload=iload
		}
	}
}
