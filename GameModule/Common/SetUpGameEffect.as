package GameModule.Common{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.sensors.Accelerometer;
	import flash.text.TextField;
	import flash.events.FocusEvent;
	import flash.text.TextFieldType;

	import CommandProtocol.*;

	public class SetUpGameEffect extends MovieClip {
		protected var m_gameView:GameBaseView;
		protected var m_isMusic:Boolean;//是否播放音乐,true:播放
		protected var m_isSound:Boolean;//是否播放声音,true:播放
		protected var m_isLookcard:Boolean;//是否咪牌,true:播放
		protected var m_lang:String;

		protected var m_music:MovieClip;//音乐按钮
		protected var m_sound:MovieClip;//声音按钮
		protected var m_lookCard:MovieClip;//眯牌按钮
		protected var m_password:TextField;//设置密码文本框
		protected var t_music:MovieClip;//音乐
		protected var t_sound:MovieClip;//音效
		protected var t_lookcard:MovieClip;//眯牌
		protected var t_update:MovieClip;//改密码
		/*
		显示游戏设置
		*/
		public function SetUpGameEffect () {
			// constructor code
			this.stop ();
			this["cancel"].addEventListener (MouseEvent.CLICK,Cancel);
			if (this.getChildByName("password")) {
				this["password"].text = "";
				m_password.addEventListener (FocusEvent.FOCUS_IN,HideTips);
				m_password.addEventListener (FocusEvent.FOCUS_OUT,ShowTips);
			}


		}
		//确定
		public function Confirm (e:MouseEvent):void {
			if (this.getChildByName("password")) {
				var setpassword:Boolean = m_gameView.SetPassword(this["password"].text);
				if (setpassword) {
					Cancel (null);
				} else {
					trace ("设置密码失败！");
				}
			}
		}
		//关闭
		public function Cancel (e:MouseEvent):void {
			this.visible = false;
		}
		//初始化设置内容
		public function SetEffect (music:Boolean=false,sound:Boolean=false,lookcard:Boolean=true):void {
			m_isMusic = music;
			m_isSound = sound;
			m_isLookcard = lookcard;
			ShowButton (m_isMusic,m_isSound,m_isLookcard);
		}
		//选择影片剪辑帧数
		public function Goto (isHost:Boolean):void {
			if (isHost) {
				this.gotoAndStop (2);
			} else {
				this.gotoAndStop (1);
			}
			if (this.getChildByName("mc_music")) {
				m_music = this["mc_music"];
				m_music.addEventListener (MouseEvent.CLICK,ChangeMusic);
			}
			if (this.getChildByName("mc_sound")) {
				m_sound = this["mc_sound"];
				m_sound.addEventListener (MouseEvent.CLICK,ChangeSound);
			}
			if (this.getChildByName("mc_lookcard")) {
				m_lookCard = this["mc_lookcard"];
				m_lookCard.addEventListener (MouseEvent.CLICK,ChangeLookCard);
			}
			if (this.getChildByName("confirm")) {
				this["confirm"].addEventListener (MouseEvent.CLICK,Confirm);
				this["confirm"].buttonMode = true;
			}
			if (this.getChildByName("password")) {
				m_password = this["password"];
				m_password.text = "";
				m_password.type = TextFieldType.INPUT;
				m_password.addEventListener (FocusEvent.FOCUS_IN,HideTips);
				m_password.addEventListener (FocusEvent.FOCUS_OUT,ShowTips);
			}
			if (this.getChildByName("tips")) {
				this["tips"].gotoAndStop (m_lang);
				this["tips"].visible = true;
				this["tips"].mouseEnabled = false;
				this["tips"].mouseChildren = false;
			}
			//this["confirm"].IChangLang (m_lang);
			//this["lang"].mouseEnabled=false;
			//this["lang"].mouseChildren=false;
			this["top"].gotoAndStop (m_lang);
			if (this.getChildByName("lang_sound")) {
				t_sound = this["lang_sound"];
				t_sound.buttonMode = true;
				t_sound.mouseEnabled = true;
				t_sound.mouseChildren =false ;
				t_sound.gotoAndStop (m_lang);
				t_sound.addEventListener (MouseEvent.CLICK,ChangeSound);
			}
			if (this.getChildByName("lang_music")) {
				t_music = this["lang_music"];
				t_music.buttonMode = true;
				t_music.mouseEnabled = true;
				t_music.mouseChildren =false ;
				t_music.gotoAndStop (m_lang);
				t_music.addEventListener (MouseEvent.CLICK,ChangeMusic);
			}
			if (this.getChildByName("lang_look")) {
				t_lookcard = this["lang_look"];
				t_lookcard.buttonMode = true;
				t_lookcard.mouseEnabled = true;
				t_lookcard.mouseChildren =false ;
				t_lookcard.gotoAndStop (m_lang);
				t_lookcard.addEventListener (MouseEvent.CLICK,ChangeLookCard);
			}
			if (this.getChildByName("lang_update")) {
				t_update = this["lang_update"];
				t_update.buttonMode = false;
				t_update.mouseEnabled = false;
				t_update.mouseChildren = false;
				t_update.gotoAndStop (m_lang);
			}
		}
		public function SetGameView (gameview:GameBaseView):void {
			m_gameView = gameview;
		}
		//销毁
		public function Destroy ():void {
			if ((m_music && m_music.hasEventListener(MouseEvent.CLICK))) {
				m_music.removeEventListener (MouseEvent.CLICK,ChangeMusic);
				m_music = null;
			}
			if ((m_sound && m_sound.hasEventListener(MouseEvent.CLICK))) {
				m_sound.removeEventListener (MouseEvent.CLICK,ChangeSound);
				m_sound = null;
			}
			if ((m_lookCard && m_lookCard.hasEventListener(MouseEvent.CLICK))) {
				m_lookCard.removeEventListener (MouseEvent.CLICK,ChangeLookCard);
				m_lookCard = null;
			}
			if ((t_sound && t_sound.hasEventListener(MouseEvent.CLICK))) {
				t_sound.removeEventListener (MouseEvent.CLICK,ChangeSound);
				t_sound = null;
			}
			if ((t_music && t_music.hasEventListener(MouseEvent.CLICK))) {
				t_music.removeEventListener (MouseEvent.CLICK,ChangeMusic);
				t_music = null;
			}
			if ((t_lookcard && t_lookcard.hasEventListener(MouseEvent.CLICK))) {
				t_lookcard.removeEventListener (MouseEvent.CLICK,ChangeLookCard);
				t_lookcard = null;
			}
			var index:int = this.numChildren - 1;
			for (index; index >= 0; index--) {
				this.removeChildAt (0);
			}
		}
		//设置语言
		public function SetLang (strlang:String):void {
			m_lang = strlang;
		}
		//变换音乐
		protected function ChangeMusic (e:MouseEvent):void {
			m_isMusic = ! m_isMusic;
			ShowButton (m_isMusic,m_isSound,m_isLookcard);
			if (m_music) {
				m_gameView.GetMusic (m_isMusic);
			}
			if ((m_sound && m_music)) {
				m_gameView.SetGameEffect (m_isMusic,m_isSound);
			}
		}
		//变换声音
		protected function ChangeSound (e:MouseEvent):void {
			m_isSound = ! m_isSound;
			ShowButton (m_isMusic,m_isSound,m_isLookcard);
			if (m_sound) {
				m_gameView.GetSound (m_isSound);
			}
			if ((m_sound && m_music)) {
				m_gameView.SetGameEffect (m_isMusic,m_isSound);
			}
		}
		//变换眯牌
		protected function ChangeLookCard (e:MouseEvent):void {
			m_isLookcard = ! m_isLookcard;
			ShowButton (m_isMusic,m_isSound,m_isLookcard);
			if (m_lookCard) {
				m_gameView.GetLookCard (m_isLookcard);
			}
		}
		//设置密码
		/*protected function ConfirmPassword(e:FocusEvent):void{
		var setpassword:Boolean = m_gameView.SetPassword(m_password.text);
		trace('this["password"].text='+m_password.text)
		if (setpassword==false) {
		trace ("设置密码失败！");
		}
		}*/
		//变换按钮显示
		protected function ShowButton (music:Boolean=false,sound:Boolean=false,lookcard:Boolean=true):void {
			if (m_music) {
				m_music.SetSelectStatus (m_isMusic);
			}
			if (m_sound) {
				m_sound.SetSelectStatus (m_isSound);
			}
			if (m_lookCard) {
				m_lookCard.SetSelectStatus (m_isLookcard);
			}
		}
		//隐藏密码提示
		protected function HideTips (e:FocusEvent):void {
			this["tips"].visible = false;
		}
		protected function ShowTips (e:FocusEvent):void {
			if (m_password.text == "" || m_password.text == null) {
				this["tips"].visible = true;
			}
		}
		//显示密码提示
	}
}