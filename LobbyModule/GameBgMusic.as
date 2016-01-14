package  {
	import flash.display.Sprite;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.net.URLRequest;
	import flash.net.URLLoader;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	
	public class GameBgMusic extends Sprite{
		protected var myxml:XML;
		protected var myloader:URLLoader;
		protected var channel:SoundChannel;
		protected var m_PlayMusic:Sound;
		protected var m_musicArr:Array;//存放所有背景音乐
		protected var m_index:int;//当前背景音乐索引
		protected var count:int=1;//背景音乐首数
		public function GameBgMusic() {
			// constructor code
			channel=new SoundChannel();
			m_musicArr=new Array();
			LoadXml ();
		}
		//加载Xml
		//
		protected function LoadXml ():void {
			myxml=new XML();
			var myre:URLRequest = new URLRequest("Sound/BGMusic.xml");
			myloader = new URLLoader(myre);
			myloader.addEventListener (Event.COMPLETE,OnComplete);
			myloader.addEventListener (IOErrorEvent.IO_ERROR,ErrorHandler);
			function OnComplete(e:Event){
				myxml=XML(myloader.data);
				LoadMusic();
			}
			
		}
		//加载背景音乐列表
		protected function LoadMusic():void{
			var index:int=0;
			for(index;index<count;index++){
			var myre:URLRequest = new URLRequest(myxml.song.(@name==(index+1).toString()));
			m_PlayMusic=new Sound();
			m_PlayMusic.load(myre);
			m_PlayMusic.addEventListener(IOErrorEvent.IO_ERROR, LoadMusicError);
			m_musicArr.push(m_PlayMusic);
			}
		}
		//@isPlay:是否播放音乐。true:播放，false:停止播放
		public function PlayBgMusic(isPlay:Boolean):void{
			if(isPlay){
				Play();
			}else{
				Stop();
			}
		}
		//播放音乐
		protected function Play():void{
			if(m_index==count){
				m_index=0;
			}
			m_PlayMusic=m_musicArr[m_index];
			channel=m_PlayMusic.play();
			SetVolume();
			channel.addEventListener(Event.SOUND_COMPLETE,PlayNext);
			m_index++;
		}
		//循环播放
		protected function PlayNext(e:Event):void{
			Play();
		}
		//停止播放
		protected function Stop():void{
			channel.stop();
		}
		public function ErrorHandler(e:IOErrorEvent):void{
			
		}
		public function LoadMusicError(e:IOErrorEvent):void{
			
		}
		//销毁
		public function Destroy():void{
			channel.stop();
			channel=null;
			m_musicArr=null;
			m_PlayMusic=null;
			myxml=null;
		}
		protected var soundT:SoundTransform;
		protected var m_volumne:Number=0.2;//声音大小
		//设置声音大小
		public function  GetVolume(volumne:Boolean):void{
			if(volumne){
			    m_volumne=0.2;
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
			channel.soundTransform=soundT;
		}
	}
}
