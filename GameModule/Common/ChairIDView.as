package GameModule.Common{
	import flash.display.MovieClip;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;

	import CommandProtocol.*;
	import flash.events.MouseEvent;

	public class ChairIDView extends MovieClip {
		private var m_nChairID:int;
		private var m_pUserData:cmdMemberInfo;

		protected var m_mcBackground:MovieClip;//背景
		protected var m_txtName:TextField;//名字
		protected var m_txtBalance:TextField;//余额
		//protected var m_picture:MovieClip;//头像
		protected var m_change:MovieClip;//換座位
		protected var m_wNullIndex:uint = 1;//没有人坐帧
		protected var m_wOwnIndex:uint = 2;//自己座位
		protected var m_wOtherIndex:uint = 3;//其他人座位
		protected var m_wShowChange:uint=4;//显示可以换桌
		protected var currentIndex:uint = m_wNullIndex;//椅子当前帧

		protected var m_chair:int;
		protected var m_gameview:GameBaseView;
		protected var isStop:Boolean = false;//是否停止换椅子
		
		protected var m_lang:String;//语言
		public function ChairIDView () {
			stop();
			if (this["background"]) {
				m_mcBackground = this["background"];
				m_mcBackground.mouseEnabled = false;
			}
			if (this["txtname"]) {
				m_txtName = this["txtname"];
				m_txtName.mouseEnabled = false;
			}
			if (this["txtbalance"]) {
				m_txtBalance = this["txtbalance"];
				m_txtBalance.mouseEnabled = false;
			}
			/*if (this["pic"]) {
				m_picture = this["pic"];
				m_picture.mouseEnabled = false;
			}
			m_picture.visible = false;*/
			m_mcBackground.stop ();
			SetMouseEnabled (true);
		}
		public function Destroy ():void {

		}
		public function getChairID ():int {
			return m_nChairID;
		}

		public function getMovieClip ():MovieClip {
			return this;
		}
		public function moveMovieClip (x:Number, y:Number):void {
			this.x = x;
			this.y = y;
		}
		public function SetChairData (wChairID:int, pUserData:cmdMemberInfo, bOwnChair:Boolean):void {
			m_pUserData = pUserData;
			m_nChairID = wChairID;
			SetBackground (pUserData, bOwnChair);
			SetName (pUserData, bOwnChair);
			SetBalance (pUserData, bOwnChair);
		}
		protected function SetBackground (pUserData:cmdMemberInfo, bOwnChair:Boolean):void {
			if (m_mcBackground) {
				if (m_pUserData == null) {
					if (isStop==false) {
						SetMouseEnabled (true);
					}
					
					m_mcBackground.gotoAndStop (m_wNullIndex);
					currentIndex = m_wNullIndex;

					return;
				}
				if (bOwnChair) {
					m_mcBackground.gotoAndStop (m_wOwnIndex);
					currentIndex = m_wOwnIndex;
					SetMouseEnabled (false);
					return;
				} else {
					m_mcBackground.gotoAndStop (m_wOtherIndex);
					currentIndex = m_wOtherIndex;
					SetMouseEnabled (false);
				}
			}
		}
		protected function SetName (pUserData:cmdMemberInfo, bOwnChair:Boolean):void {
			if (m_txtName) {
				if (pUserData == null) {
					m_txtName.text = "";
				} else {
					m_txtName.text = pUserData.ShowName;
				}
				if(bOwnChair) {
					m_txtName.textColor = 0xFCEE21;
				} else {
					m_txtName.textColor = 0x999999;
				}
			}
		}
		protected function SetBalance (pUserData:cmdMemberInfo, bOwnChair:Boolean):void {
			if (m_txtBalance) {
				if (pUserData == null) {
					m_txtBalance.text = "";
				} else {
					m_txtBalance.text = pUserData.Balance.toFixed(2);
				}
				if(bOwnChair) {
					m_txtBalance.textColor = 0xffffff;
				} else {
					m_txtBalance.textColor = 0x999999;
				}
			}
		}
		public function ChangBalance (nBalance:Number):void {
			m_txtBalance.text = nBalance.toFixed(2);
		}
		public function SetLang (strlang:String):void {
			//m_change.gotoAndStop (strlang);
			if(strlang){
				m_lang=strlang;
			}else{
				m_lang="ch";
			}
		}
		public function SetGameView (gameview:GameBaseView):void {
			m_gameview = gameview;
		}
		//点击坐下
		protected function SitDown (e:MouseEvent):void {
			m_gameview.ChangeChair (m_chair);
		}
		//停止更换座位
		public function StopChangeChair ():void {
			isStop = true;
			if (currentIndex==m_wNullIndex) {
				//m_change.visible = false;
				SetMouseEnabled (false);
			}
		}
		//可以更換座位
		public function StartChangeChair ():void {
			isStop = false;
			if (currentIndex==m_wNullIndex) {
				//m_change.visible = true;
				SetMouseEnabled (true);
			}
		}
		protected function SetMouseEnabled (bool:Boolean):void {
			if (m_mcBackground) {
				m_mcBackground.mouseEnabled = bool;
				m_mcBackground.buttonMode = bool;
				if (bool) {
					m_mcBackground.addEventListener (MouseEvent.CLICK,SitDown);
					m_mcBackground.addEventListener (MouseEvent.MOUSE_OVER,ShowChange);
					m_mcBackground.addEventListener (MouseEvent.MOUSE_OUT,HideChange);
				}
				if (m_mcBackground.hasEventListener(MouseEvent.CLICK) && bool == false) {
					m_mcBackground.removeEventListener (MouseEvent.CLICK,SitDown);
					m_mcBackground.removeEventListener (MouseEvent.MOUSE_OVER,ShowChange);
					m_mcBackground.removeEventListener (MouseEvent.MOUSE_OUT,HideChange);
				}
			}
		}
		protected function ShowChange(e:MouseEvent):void{
			m_mcBackground.gotoAndStop(m_wShowChange);
			if(m_mcBackground.getChildByName("click") && m_lang){
				m_mcBackground["click"].gotoAndStop(m_lang);
			}
		}
		protected function HideChange(e:MouseEvent):void{
			m_mcBackground.gotoAndStop(m_wNullIndex);
		}
	}
}