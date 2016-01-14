package {
	import flash.display.MovieClip;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.display.Sprite
	import flash.utils.setTimeout;
	import flash.text.TextFormat;
	
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.net.URLRequest;
	import flash.events.IOErrorEvent;
	import flash.events.Event;

	public class LookCardTime extends MovieClip {
		protected var m_looktime:Timer;
		protected var m_totalTime:int;
		protected var m_timeCount:int;
		protected var isHide:Boolean;
		
		protected var m_ration:Number;
		protected var moviec:MovieClip
		var S_angle:Number=0;
		
		protected var m_CPlaySound:Sound ;//声音
		protected var channel:SoundChannel;//时间播放声音
		protected var m_type:int=0;//播放类型
		protected var count:int=0;//声音播放次数
		protected var timespace:int;//声音重复播放间隔
		protected var soundT:SoundTransform;//声音音量控制
		protected var isComplete:Boolean;//声音文件是否加载完成
		
		protected var m_flipCardWindow:FlipCardWindow;
		public function LookCardTime () {
			// constructor code
			var stag:Sprite=new Sprite();
			m_bettime.addChild (stag);
			moviec= new MovieClip  ;
			stag.addChild (moviec);
			this["m_bettime"]["mc_shadow"].visible=false;
			this["m_bettime"]["mc_numshadow"].visible=false;
			this["m_bettime"]["mc_bg"].stop();
		}
		public function SetTotalTime(total:int):void{
			m_totalTime=total;
			SetBetTimer();
		}
		public function SetDiffTime(difftime:int):void{
			m_timeCount=difftime;
		}
		public function SetBetTimer ():void {
			if(m_timeCount<=0 && m_totalTime<=0){
				return;
			}
			moviec.graphics.clear();
			m_ration=360/m_totalTime;
			S_angle=(m_totalTime-m_timeCount)*m_ration
			this.visible=true;
			isHide=false;
			if (m_looktime==null) {
				m_looktime = new Timer(1000,m_timeCount);
				m_looktime.addEventListener (TimerEvent.TIMER, OnShowTimer);
				m_looktime.addEventListener (TimerEvent.TIMER_COMPLETE, OnTimeOver);
			} else {
				m_looktime.reset ();
			}
			LoadSound();
			m_looktime.start ();
			OnShowTimer(null);
			this["m_bettime"]["mc_bg"].gotoAndStop(1);
		}
		public function OnShowTimer (e:TimerEvent):void {
			m_timeCount--;
			if (m_timeCount < 0 ) {
				return;
			}
			S_angle+=m_ration;
			DrawSector (moviec,52,52,80,S_angle,270,0x000000);
			this["m_bettime"]["m_text"].text = m_timeCount;
			if(m_timeCount<=5){
				PlaySound(m_timeCount);
				this["m_bettime"]["mc_shadow"].visible=true;
				this["m_bettime"]["mc_numshadow"].visible=true;
			}
			//this["m_time"].text = m_timeCount.toString();
			//MoveMcTimer (m_timeCount / m_totalTime);
		}
		/*private function MoveMcTimer (rate:Number):void {
			this["m_load"].x = (1 - rate) * this["m_load"].width;
		}*/
		public function OnTimeOver (e:TimerEvent):void {
            Hide();
		}
		public function Hide():void{
			
			if(isHide){
				return;
			}
			m_timeCount=30;
			isHide=true;
			m_looktime.stop();
			m_looktime=null;
			S_angle=0;
			if(this.getChildByName("m_bettime")){
				this["m_bettime"]["mc_shadow"].visible=false;
				this["m_bettime"]["mc_numshadow"].visible=false;
			}
			if(m_flipCardWindow){
				m_flipCardWindow.OpenTimeOutCards();
			}
			//this["m_load"].x=0;
			this.visible=false;
		}
		//添加一个底色
		public function DrawSector (mc:MovieClip,x:Number,y:Number,r:Number,angle:Number,startFrom:Number,color:Number):void {
			mc.graphics.beginFill (color,50);
			mc.graphics.lineStyle (0,0x000000);
			mc.graphics.moveTo (x,y);
			angle=(Math.abs(angle)>360)?360:angle;
			var n:Number = Math.ceil(Math.abs(angle) / 45);
			var angleA:Number = angle / n;
			angleA = angleA * Math.PI / 180;
			startFrom = startFrom * Math.PI / 180;
			mc.graphics.lineTo (x+r*Math.cos(startFrom),y+r*Math.sin(startFrom));
			for (var i=1; i<=n; i++) {
				startFrom +=  angleA;
				var angleMid = startFrom - angleA / 2;
				var bx=x+r/Math.cos(angleA/2)*Math.cos(angleMid);
				var by=y+r/Math.cos(angleA/2)*Math.sin(angleMid);
				var cx = x + r * Math.cos(startFrom);
				var cy = y + r * Math.sin(startFrom);
				mc.graphics.curveTo (bx,by,cx,cy);
			}
			if (angle!=360) {
				mc.graphics.lineTo (x,y);
			}
			mc.graphics.endFill ();
		}
		//加载声音
		protected function LoadSound ():void {
			var re:URLRequest = new URLRequest("Sound/bip.mp3");
			if(m_CPlaySound==null){
			m_CPlaySound= new Sound() ;
			isComplete=false;
			m_CPlaySound.load (re);
			}
			
			m_CPlaySound.addEventListener (IOErrorEvent.IO_ERROR,LoadSoundError);
			m_CPlaySound.addEventListener (Event.OPEN,OpenHandler);
			m_CPlaySound.addEventListener (Event.COMPLETE,Complete);
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
			channel = m_CPlaySound.play(0);
			SetVolume();
			if(count==2){
				count=1;
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
		public function Destroy():void{
			if(m_looktime){
			m_looktime.stop();
			m_looktime=null;
			}
			if(soundT){
				soundT=null;
			}
			if(channel){
				channel.stop();
				channel=null;
			}
			if(m_CPlaySound){
				m_CPlaySound=null;
			}
			var index:int=this.numChildren-1;
			for(index;index>=0;index--){
				this.removeChildAt(0);
			}
		}
		public function SetFlipCardWindow(flipCardWindow:FlipCardWindow){
			m_flipCardWindow=flipCardWindow;
		}
	}

}