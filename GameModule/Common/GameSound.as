package GameModule.Common{
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.display.Sprite;
	import flash.net.URLRequest;
	import flash.net.URLLoader;
	import flash.events.Event;
	import flash.media.SoundLoaderContext;
	import flash.events.IOErrorEvent;
	import flash.utils.setTimeout;
	import flash.utils.Dictionary;

	public class GameSound extends Sprite {
		protected var m_LoadXmlUrl:String;
		protected var myxml:XML;
		protected var myloader:URLLoader;
		protected var channel:SoundChannel;
		protected var m_CPlaySound:Sound;
		protected var m_CPlayParam:String;
		protected var m_type:String;
		protected var m_PlayList:Array = new Array();
		protected var m_LoadComplete:Boolean = false;//xml文件是否加载完成
		protected var m_PlayStatus:Boolean = false;
		protected var IsComplete:Boolean = false;//音频是否加载完成
		protected var m_LoadedSound:Dictionary;//已经加载的声音

		protected var m_volumne:int;//声音大小
		public function GameSound () {
			// constructor code
			channel = new SoundChannel ();
			m_LoadedSound = new Dictionary ();
		}
		//加载Xml
		//@str:加载xml文件名
		public function LoadXml(str:String):void {
			m_LoadXmlUrl = str;
			GetSong(SoundConst.EnterGame,null);

			var myre:URLRequest = new URLRequest(str);
			if(myloader == null) {
				myloader = new URLLoader();
				myloader.addEventListener(Event.COMPLETE,MComplete);
				myloader.addEventListener(IOErrorEvent.IO_ERROR,ErrorHandler);
			}
			myloader.load(myre);
		}
		private function MComplete(e:Event) {
			myloader.removeEventListener(Event.COMPLETE,MComplete);
			myloader.removeEventListener(IOErrorEvent.IO_ERROR,ErrorHandler);
			myxml = new XML ();
			try {
				var strXML:String = myloader.data;
				var index:int = strXML.indexOf("</music>");
				
				if(strXML.length >= index + 8) {
					strXML = strXML.substring(0, index + 8);
				}
				myxml = XML(strXML);
			} catch (e:Error) {
				return;
			}
			myloader = null;
			m_LoadComplete = true;
			PlaySound();
		}
		public function SetChair(chair:int):void {
			GetSong(SoundConst.SitDown,chair.toString());
		}
		public function SetType(type):void {
			m_type = type;
		}
		/**获取声音
		 * @status：游戏状态
		 * @str：游戏输赢/游戏结果/座位号
		 */
		//protected var index:int = 0;
		public function GetSong(soundType:String,soundParam:String):void {
			if (m_LoadComplete == false) {
				return;
			}
			m_PlayList.push([soundType,soundParam,new Date()]);
			if (m_PlayList.length > 1) {
				LoadSound(soundType,soundParam);
			}
			PlaySound();
		}
		public function LoadSound(soundType:String,soundParam:String,playStatus:Boolean=false):void {
			m_CPlayParam = soundType + "," + soundParam;

			var snd:Sound = null;
			if (m_LoadedSound[m_CPlayParam] != null) {
				snd = m_LoadedSound[m_CPlayParam] as Sound;
			}
			if(snd == null){
				//加载地址
				var m_url:*;
				if (soundType=="win"||soundType=="resoult"||soundType=="sitdown") {
					m_url=myxml.song.(@name==m_type).mu.(@name==soundType).add.(@name==soundParam);
				} else {
					m_url=myxml.song.(@name==m_type).mu.(@name==soundType);
				}
				if(m_url == "" || m_url == " ") {
					PlaySound();
					return;
				}
				var re:URLRequest = new URLRequest(m_url);
				snd = new Sound();
				snd.load(re);
				snd.addEventListener(IOErrorEvent.IO_ERROR,LoadSoundError);
				snd.addEventListener(Event.OPEN,OpenHandler);
				snd.addEventListener(Event.COMPLETE,Complete);

				m_LoadedSound[m_CPlayParam] = snd;
			}
			if (playStatus) {
				m_CPlaySound = snd;
				channel = snd.play();
				SetVolume();
				channel.addEventListener(Event.SOUND_COMPLETE,OnComplete);
			}
		}
		public function PlaySound():void {
			if (m_PlayStatus == false) {
				if (m_PlayList.length > 0) {
					if (addSeconds(m_PlayList[0][2],10) < new Date()) {
						m_PlayList.shift();
						PlaySound();
						return;
					}
					LoadSound(m_PlayList[0][0],m_PlayList[0][1],true);
					m_PlayStatus = true;
					m_PlayList.shift();
				}
			}
		}

		private function LoadSoundError(event:IOErrorEvent):void {
			event.target.removeEventListener(IOErrorEvent.IO_ERROR,LoadSoundError);
			event.target.removeEventListener(Event.OPEN,OpenHandler);
			event.target.removeEventListener(Event.COMPLETE,Complete);
			
			if (event.target == m_CPlaySound) {
				OnComplete(null);
				m_LoadedSound[m_CPlayParam] = null;
			}
		}
		private function OpenHandler(e:Event):void {
			//设置音频加载超时时间为1秒
			setTimeout(TimeOut,1000);
		}
		//设置音频加载超时;
		public function TimeOut() {
			if (IsComplete == false) {
				if (m_PlayList.length > 0) {
					m_PlayList.shift();
					PlaySound();
					return;
				}
			}
		}
		//音频加载完成
		public function Complete(e:Event):void {
			IsComplete = true;
		}
		//音频播放完成;
		public function OnComplete(e:Event):void {
			m_PlayStatus = false;
			IsComplete = false;
			channel.removeEventListener(Event.SOUND_COMPLETE,OnComplete);
			m_CPlaySound = null;
			PlaySound();
		}
		public function ErrorHandler(e:IOErrorEvent):void {
			trace("加载Xml文件失败:");
		}
		public function Destory():void {
			Stop();
			if(myloader) {
				myloader.close();
				if(myloader.hasEventListener(Event.COMPLETE))
					myloader.removeEventListener(Event.COMPLETE, MComplete);
				if(myloader.hasEventListener(IOErrorEvent.IO_ERROR))
					myloader.removeEventListener(IOErrorEvent.IO_ERROR, ErrorHandler);
			}
			if(channel && channel.hasEventListener(Event.SOUND_COMPLETE)) {
				channel.removeEventListener(Event.SOUND_COMPLETE, OnComplete);
			}
			channel = null;
			if(m_LoadedSound) {
				for(var key:Object in m_LoadedSound) {
					var snd:Sound = m_LoadedSound[key] as Sound;
					if(snd) {
						if(snd.hasEventListener(IOErrorEvent.IO_ERROR))
							snd.removeEventListener(IOErrorEvent.IO_ERROR,LoadSoundError);
						if(snd.hasEventListener(Event.OPEN))
							snd.removeEventListener(Event.OPEN,OpenHandler);
						if(snd.hasEventListener(Event.COMPLETE))
							snd.removeEventListener(Event.COMPLETE,Complete);
					}
					snd = null;
				}
			}
			m_LoadedSound = null;
			
			m_CPlaySound = null;
			myloader = null;
			m_PlayList = null;
			myxml = null;
			soundT = null;
		}
		public function Stop():void {
			channel.stop();
			channel = null;
		}
		public function addSeconds(date:Date,secs:Number):Date {
			var mSecs:Number = secs * 1000;
			var sum:Number = mSecs + date.getTime();
			return new Date(sum);
		}
		//设置声音大小
		public function GetVolume(volumne:Boolean):void {
			if (volumne) {
				m_volumne = 1;
			} else {
				m_volumne = 0;
			}
			SetVolume();
		}
		protected var soundT:SoundTransform;
		public function SetVolume():void {
			if (soundT == null) {
				soundT = new SoundTransform();
			}
			soundT.volume = m_volumne;
			channel.soundTransform = soundT;
		}
	}
}