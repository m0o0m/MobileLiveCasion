package GameModule.Common{
	import flash.display.MovieClip;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import flash.text.TextFormat;

	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.utils.setTimeout;

	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.net.URLRequest;
	import flash.events.IOErrorEvent;
	import flash.events.Event;
	import flash.geom.Point;

	public class BetTimer extends MovieClip {
		protected var m_timeCount:int = -1;//投注剩余时间
		protected var m_BetTimer:Timer;
		protected var m_totalTime:Number;
		protected var m_GameBaseView:GameBaseView;
		protected var IsBetTime:Boolean = false;//是否显示时间
		protected var m_controlMode:int;

		protected var m_ration:Number;//扇形变换角度;
		protected var moviec:MovieClip;
		var S_angle:Number = 0;//扇形旋转角度
		
		protected var m_CPlaySound:Sound ;//声音
		protected var channel:SoundChannel;//时间播放声音
		protected var m_type:int=0;//播放类型
		protected var count:int=0;//声音播放次数
		protected var timespace:int;//声音重复播放间隔
		protected var soundT:SoundTransform;//声音音量控制
		protected var isComplete:Boolean;//声音文件是否加载完成
		
		protected var m_lang:String;//当前语言
		protected var text_format:TextFormat;
		public function BetTimer () {
			// constructor code
			var stag:Sprite = new Sprite  ;
			this["m_bettime"].addChild (stag);
			moviec = new MovieClip  ;
			stag.addChild (moviec);
			this["m_bettime"].visible = false;
			this["m_bettime"]["mc_shadow"].visible=false;
			this["m_bettime"]["mc_numshadow"].visible=false;
			ChangeStatus (false);
			text_format=new TextFormat();
			text_format.font="Microsoft YaHei";
			this["m_bettime"]["mc_bg"].stop();
		}
		public function SetGameBaseView (gbv:GameBaseView):void {
			m_GameBaseView = gbv;
		}
		public function SetTimerPoint(timerPoint:Point):void {
			if(timerPoint) {
				this["m_bettime"].x = timerPoint.x;
				this["m_bettime"].y = timerPoint.y;
				
			}
		}
		//
		public function SetGameStatus (status:int):void {
			IsBetTime = false;
			switch (status) {
				case 1 :
					ChangeStatus (false);
					graphics.clear ();
					break;
				case 2 :
					if ((m_controlMode == 1)) {
						IsBetTime = true;
						SetBetTimer ();
						ChangeStatus (true);
					} else {
						ChangeStatus (false);
					}
					break;
				case 0 :
				case 3 :
				case 4 :
				case 5 :
				case 6 :
					m_timeCount = -1;
					TimeStop ();
					ChangeStatus (false);
					StopSound();
					graphics.clear ();
					break;
			}
			//this["m_text"].text = GetTableStatus(status,m_lang);
			//this["m_text"].setTextFormat(text_format);
		}
		//获取总时间
		public function SetTotalTime (time:Number):void {
			m_totalTime = time;
		}
		//获取剩余时间
		public function SetDifftime (difftime:int):void {
			m_timeCount = difftime;
			SetBetTimer ();
		}
		//设置游戏类型;
		public function SetControlMode (controlMode:int):void {
			m_controlMode = controlMode;
		}
		public function SetBetTimer ():void {
			if ((((m_totalTime == 0) || IsBetTime == false) || m_timeCount <= 0)) {
				return;
			}
			if ((m_BetTimer == null)) {
				m_BetTimer = new Timer(1000,m_timeCount);
				m_BetTimer.addEventListener (TimerEvent.TIMER,OnShowTimer);
				m_BetTimer.addEventListener (TimerEvent.TIMER_COMPLETE,OnTimeOver);
			} else {
				m_BetTimer.reset ();
			}
			LoadSound ();
			m_ration = 360 / m_totalTime;
			S_angle = (m_totalTime - m_timeCount) * m_ration;
			m_BetTimer.start ();
			this["m_bettime"]["mc_bg"].gotoAndStop(1);
			OnShowTimer (null);
		}
		//时间递减
		public function OnShowTimer (e:TimerEvent):void {
			m_timeCount--;
			if ((m_timeCount < 0)) {
				return;
			}
			
			moviec.graphics.clear ();
			S_angle +=  m_ration;
			DrawSector (moviec,52,52,80,S_angle,270,0x000000);
			this["m_bettime"]["m_text"].text = m_timeCount;
			if (((m_timeCount <= 5) && m_GameBaseView)) {
				PlaySound(m_timeCount);
				//var format:TextFormat = new TextFormat  ;
				//format.color = 0xff0000;
				//this["m_bettime"]["m_text"].setTextFormat (format);
				this["m_bettime"]["mc_shadow"].visible=true;
				this["m_bettime"]["mc_numshadow"].visible=true;
			}
		}
		public function OnTimeOver (e:TimerEvent):void {
			TimeStop ();
		}
		//停止倒计时
		public function TimeStop ():void {
			if (m_BetTimer) {
				m_BetTimer.removeEventListener (TimerEvent.TIMER,OnShowTimer);
				m_BetTimer.removeEventListener (TimerEvent.TIMER_COMPLETE,OnTimeOver);
				m_BetTimer.stop ();
				m_BetTimer = null;
			}
			if(this.getChildByName("m_bettime")){
				this["m_bettime"]["mc_shadow"].visible=false;
				this["m_bettime"]["mc_numshadow"].visible=false;
			}
			StopSound();
			S_angle = 0;
		}
		public function Destroy ():void {
			m_GameBaseView = null;
			if (m_BetTimer) {
				m_BetTimer = null;
			}
			if(m_CPlaySound){
				m_CPlaySound=null;
			}
			if(soundT){
				soundT=null;
			}if(channel){
				StopSound();
			}
			var index:int = this.numChildren - 1;
			for (index; index > 0; index--) {
				this.removeChildAt (0);
			}
		}
		//显示框
		public function ChangeStatus (bool:Boolean) {
			if(this.getChildByName("m_time")){
			this["m_time"].visible = bool;
			}
			this["m_bettime"].visible = bool;
			if(this.getChildByName("m_bg")){
			this["m_bg"].visible = false;
			}
		}
		//添加一个底色
		public function DrawSector (mc:MovieClip,x:Number,y:Number,r:Number,angle:Number,startFrom:Number,color:Number):void {
			mc.graphics.beginFill (color,50);
			mc.graphics.lineStyle (0,0x000000);
			mc.graphics.moveTo (x,y);
			angle = Math.abs(angle) > 360 ? 360:angle;
			var n:Number = Math.ceil(Math.abs(angle) / 45);
			var angleA:Number = angle / n;
			angleA = angleA * Math.PI / 180;
			startFrom = startFrom * Math.PI / 180;
			mc.graphics.lineTo ((x + r * Math.cos(startFrom)),y + r * Math.sin(startFrom));
			for (var i = 1; i <= n; i++) {
				startFrom +=  angleA;
				var angleMid = startFrom - angleA / 2;
				var bx = x + r / Math.cos((angleA / 2)) * Math.cos(angleMid);
				var by = y + r / Math.cos((angleA / 2)) * Math.sin(angleMid);
				var cx = x + r * Math.cos(startFrom);
				var cy = y + r * Math.sin(startFrom);
				mc.graphics.curveTo (bx,by,cx,cy);
			}
			if ((angle != 360)) {
				mc.graphics.lineTo (x,y);
			}
			mc.graphics.endFill ();
		}
		//加载声音
		protected function LoadSound ():void {
			var re:URLRequest = new URLRequest("Sound/bip.mp3");
			if(m_CPlaySound==null){
			m_CPlaySound= new Sound()  ;
			isComplete=false;
			m_CPlaySound.load (re);
			m_CPlaySound.addEventListener (IOErrorEvent.IO_ERROR,LoadSoundError);
			m_CPlaySound.addEventListener (Event.OPEN,OpenHandler);
			m_CPlaySound.addEventListener(Event.COMPLETE,Complete);
			}
		}
		protected function Complete(e:Event):void{
			isComplete=true;
		}
		protected function PlaySound (type:int):void {
			if(isComplete==false){
				return;
			}
			timespace=0;
			/*switch (type) {
				case 5 :
				case 4 :
					break;
				case 3 :
				case 2 :
				case 1 :
				    timespace=500;
					break;
				default :
					break;
			}*/
			m_type=type;
			if(m_CPlaySound){
			channel = m_CPlaySound.play(0);
			}
			SetVolume();
			if(count==1){
				count=0;
				return;
			}
			if(timespace>0){
			setTimeout(positionTimerHandler,timespace);
			}
		}
	    private function positionTimerHandler():void {
			 if(channel){
                 channel.stop();
				 count++;
		         PlaySound(m_type);
			 }
        }
		protected function StopSound():void{
			if(channel){
			   channel.stop();
			   channel=null;
			}
		}
		protected function LoadSoundError (event:IOErrorEvent):void {

		}
		protected function OpenHandler (e:Event):void {

		}
		protected var m_volumne:int;
		public function  GetVolume(volumne:Boolean):void{
			if(volumne){
			    m_volumne=1;
			}else{
				 m_volumne=0;
			}
			SetVolume();
		}
		
		public function SetVolume():void{
			if(soundT==null){
			soundT=new SoundTransform();
			}
			soundT.volume=m_volumne;
			if(channel){
			channel.soundTransform=soundT;
			}
		}
		public function SetLang(strlang:String):void{
			m_lang=strlang;
		}
	}
}
include "../../LobbyModule/LobbyText.as";