package GameModule.Common{
	import flash.display.MovieClip;
	import flash.utils.setTimeout;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.geom.Point;
	public class ShowGameMessage extends MovieClip {
		protected var m_showtime:int = 3000;//文本框显示时间3秒
		protected var m_lang:String;
		protected var bg_width:Number=0;//背景宽度
		protected var bg_x:Number=0;//背景坐标
		public function ShowGameMessage () {
			this.stop ();
		}
		//显示投注信息
		public function ShowBetMessage (msgNo:int, errorList:Array):void {
			this.visible = true;
			this.gotoAndStop (1);
			var m_betmessage:String = ShowBMessage(msgNo,errorList,m_lang);
			var m_beterrormessage:String = ShowErroeMessage(msgNo,errorList,m_lang);
			bg_width=0;
			bg_x=0;
			if (m_betmessage==null) {
				return;
			}
			if (this.getChildByName("message")) {
				this["message"].wordWrap=false;
				this["message"].text=m_betmessage;
				bg_width=this["message"].width+10;
				bg_x=this["message"].x;
				this["message"].mouseEnabled=false;
			}
			if (this.getChildByName("errormessage")) {
				this["errormessage"].wordWrap=false;
				this["errormessage"].visible=false;
				bg_width=this["errormessage"].width+10;
				bg_x=this["errormessage"].x;
				this["errormessage"].mouseEnabled=false;
			}
			if(msgNo==MT_Bet_Fail) {
				//下注失败
				if (m_beterrormessage==null ||m_beterrormessage=="" ) {
					return;
				}
				if (this.getChildByName("errormessage")) {
					this["errormessage"].wordWrap=false;
					this["errormessage"].visible=true;
					this["errormessage"].text=m_beterrormessage;
					bg_width=this["errormessage"].width+10;
					bg_x=this["errormessage"].x;
				}
			}
			if(this.getChildByName("mc_bg")){
				if(bg_width>275){
					this["mc_bg"].x=bg_x-5;
					this["mc_bg"].width=bg_width;
				}
			}
			setTimeout (HideMc,m_showtime);//显示3秒后隐藏
		}
		//显示桌子状态信息
		public function ShowTableMessage (type:int, msgNo:int):void {
			this.visible = true;
			this.gotoAndStop (1);
			var str:String = ShowTMessage(type,msgNo,m_lang);
			bg_width=0;
			bg_x=0;
			if (str==null) {
				return;
			}
			if (this.getChildByName("message")) {
				this["message"].wordWrap=false;
				this["message"].text=str;
				this["message"].mouseEnabled=false;
				bg_width=this["message"].width+10;
				bg_x=this["message"].x;
			}
			if (this.getChildByName("errormessage")) {
				this["errormessage"].visible=false;
				this["errormessage"].mouseEnabled=false;
			}
			if(this.getChildByName("mc_bg")){
				if(bg_width>275){
					this["mc_bg"].x=bg_x-5;
					this["mc_bg"].width=bg_width;
				}
			}
			setTimeout (HideMc,m_showtime);//显示3秒后隐藏
		}
		/*显示输赢状态
		@type:true为赢
		@num:具体金额
		*/
		public function ShowWinMessage (type:int,num:String):void {
			this.visible = true;
			var str:String = GetWin(type,m_lang);
			bg_width=0;
			bg_x=0;
			if (str==null) {
				return;
			}
			this.gotoAndStop (type+2);
			if (this.getChildByName("count")) {
				this["count"].wordWrap=false;
				this["count"].text = num;
				this["count"].mouseEnabled=false;
				bg_width=this["count"].width+10;
				bg_x=this["count"].x;
			}
			if (this.getChildByName("result")) {
				this["result"].wordWrap=false;
				this["result"].text = str;
				this["result"].mouseEnabled=false;
				bg_width=this["count"].width+10;
				bg_x=this["count"].x;
			}
			if(this.getChildByName("mc_bg")){
				if(bg_width>275){
					this["mc_bg"].x=bg_x-5;
					this["mc_bg"].width=bg_width;
				}
			}
			//添加状态文本框内容
			setTimeout (HideMc,m_showtime);//显示3秒后隐藏
		}
		//
		protected function HideMc () {
			this.visible = false;
		}
		//销毁
		public function Destroy ():void {
			var index:int = this.numChildren - 1;
			for (index; index>=0; index--) {
				removeChildAt (index);
			}
		}
		public function SetLang (strlang:String):void {
			m_lang = strlang;
		}
	}

}
include "GameMessage.as"