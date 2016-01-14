package GameModule.Common{
	import flash.display.MovieClip;
	import flash.text.TextFieldAutoSize;
	import Common.*;
	import flash.text.TextField;

	public class ShowBetPosLimit extends MovieClip{
		protected var str:Array;
		public function ShowBetPosLimit() {
			// constructor code
			
			this.mouseChildren=false;
			this.buttonMode=false;
		}
		//显示投注位置信息
		/*
		@betposname:投注位置名称
		@min：最小投注限额
		@max：最大投注限额
		@type：显示框类型1:投注信息，2:按钮解释
		*/
		public function ShowBetPos(betTotal:Number,min:Number,max:Number,type:int,gameType:Number,w_betpos:int,lang:String):void{
			this.gotoAndStop(type);
			if(this.getChildByName("bettotal")){
				var m_bettotal:TextField=this["bettotal"];
				m_bettotal.autoSize="center";
				m_bettotal.wordWrap=false;
				m_bettotal.text=String(min)+"-"+String(max);
				if(m_bettotal.width>70){
					this["bg"].x=m_bettotal.x-5;
			    	this["bg"].width=m_bettotal.width+10;
				}
			}
			
			//this["bettotal"].text=String(NumberFormat.formatString(min)+"-"+NumberFormat.formatString(max));
			this["maxlimit"].text=GetBetPos(gameType,w_betpos,lang);
			//this["bettotal"].text="100000.00-500000000.00";
			
		}
		public function ShowBetTotal(betTotal:Number,type:int):void{
			this.gotoAndStop(type);
			/*this["bettotal"].text=str[type-1][0].replace("$total$",NumberFormat.formatString(betTotal));*/
		}
		public function ShowExplain(type:int,index:int):void{
			this.gotoAndStop(type);
			this["explain"].text=str[type-1][index];
		}
		public function Destroy():void{
			var index:int=this.numChildren-1;
			for(index;index>=0;index--){
				this.removeChildAt(0);
			}
		}
		public function SetLang(strlang:String):void{
			str=ShowBetPosMessage(strlang);
		}

	}
	
}
include "GameMessage.as"