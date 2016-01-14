package Common{
	import flash.media.Video;
	import flash.display.MovieClip;
	import flash.net.NetStream;
	import flash.net.NetConnection;
	import flash.events.Event;
	import flash.events.NetStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import flash.net.ObjectEncoding;
	import flash.events.AsyncErrorEvent;
	import flash.display.Graphics;
	import flash.events.NetDataEvent;
	import flash.utils.setTimeout;

	public class UserPlayer extends MovieClip {
		public static var VIDEO_LOADED:String = "videoLoaded";//加载完毕事件
		public static var LOAD_RESUME:String = "loadResume";//加载暂停事件
		public static var LOAD_FAIL:String = "loadFail";//加载失败事件

		var m_ServerVideo:Video = null;
		var m_ServerNc:NetConnection = null;
		var m_PlayNs:NetStream = null;
		var m_PlayUrl:String = "";
		var m_PlayName:String = "";
		var m_ResetConnectTimer:Timer;//重新连接
		var m_ResetTime:int = 600000;//重新连接时间
		var m_FullTimer:Timer;
		var m_EmptyTimer:Timer;
		var m_BufferEmptyTimer:Timer;
		var m_CheckCount:int = 0;
		var customClient:Object;
		var playerWidth:int = 0;
		var playerHeight:int = 0;

		public function UserPlayer (width:int, height:int) {
			this.stop();
			playerWidth = width;
			playerHeight = height;
			var grap:Graphics = this.graphics;
			grap.beginFill (0x203234, 0);
			grap.drawRect (0, 0, width, height);
			grap.endFill ();
			this.width = width;
			this.height = height;
		}
		//销毁
		public function Destroy ():void {
			ClosePlay ();
			if (m_ServerNc) {
				m_ServerNc.close ();
				m_ServerNc.removeEventListener (NetStatusEvent.NET_STATUS, onNetStatusHandler);
				m_ServerNc = null;
			}
			if (m_ServerVideo) {
				m_ServerVideo.clear ();
				removeChild (m_ServerVideo);
				m_ServerVideo = null;
			}
			if (customClient) {
				customClient = null;
			}
			if(m_ResetConnectTimer) {
				m_ResetConnectTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, onResetConnectTimer);
				m_ResetConnectTimer == null;
			}
		}
		//播放视频
		public function PlayVideo (playUrl:String, playName:String):void {
			if (playUrl == "" || playName == "") {
				return;
			}
			m_PlayUrl = playUrl;
			m_PlayName = playName;

			if (m_ServerVideo == null) {
				m_ServerVideo = new Video(playerWidth,playerHeight);
				addChild (m_ServerVideo);
			}

			if (m_ServerNc != null) {
				ClosePlay ();

				m_ServerNc.close ();
				m_ServerNc.connect (m_PlayUrl);
			} else {
				m_ServerNc = new NetConnection();
				m_ServerNc.connect (m_PlayUrl);
				m_ServerNc.objectEncoding = ObjectEncoding.AMF3;
				m_ServerNc.addEventListener (NetStatusEvent.NET_STATUS, onNetStatusHandler);

				// 创建回调函数的对象
				customClient = new Object();
				customClient.onMetaData = metaDataHandler;
				m_ServerNc.client = customClient;
			}
		}
		//暂停播放
		public function PlayPause ():void {
			ClosePlay ();
		}
		//恢复播放
		public function PlayBack ():void {
			Play ();
		}
		//播放
		private function Play ():void {
			if(m_ServerNc.connected == false) {
				return;
			}
			ClosePlay ();
			m_PlayNs = new NetStream(m_ServerNc);
			m_PlayNs.addEventListener (NetStatusEvent.NET_STATUS, onVideoNetStatusHandler);
			m_PlayNs.addEventListener (AsyncErrorEvent.ASYNC_ERROR , onAsyncError);
			m_PlayNs.client = customClient;
			m_PlayNs.play (m_PlayName);
			m_PlayNs.receiveAudio(false);
			//m_PlayNs.videoReliable = false;
			//m_PlayNs.inBufferSeek = false;
			m_PlayNs.bufferTime = 1;
			m_PlayNs.bufferTimeMax =2;
			if(m_ResetTime > 0) {
				if(m_ResetConnectTimer == null) {
					m_ResetConnectTimer = new Timer(m_ResetTime, 1);
					m_ResetConnectTimer.addEventListener(TimerEvent.TIMER_COMPLETE, onResetConnectTimer);
				}
				m_ResetConnectTimer.reset();
				m_ResetConnectTimer.start();
			}
		}
		function onResetConnectTimer(event:TimerEvent):void {
			Play ();
		}
		//关闭播放;
		private function ClosePlay ():void {
			if (m_PlayNs) {
				m_PlayNs.removeEventListener (NetStatusEvent.NET_STATUS, onVideoNetStatusHandler);
				m_PlayNs.close ();
				/*if(m_PlayNs.hasOwnProperty("dispose")){
					m_PlayNs.dispose();//销毁流数据，释放内存
				}*/
				m_PlayNs = null;
			}
		}
		//onMetaData回调函数的事件
		private function metaDataHandler (infoObject:Object):void {
		}
		private function onAsyncError (event:AsyncErrorEvent):void {
			trace ("onAsyncError");
		}
		private function onNetStatusHandler (event:NetStatusEvent):void {
			//trace ("onNetStatusHandler event.info.code="+event.info.code);
			if (event.info.code == "NetConnection.Connect.Success") {
				Play ();
			} else if (event.info.code == "NetConnection.Connect.Failed" ||
			  event.info.code == "NetConnection.Connect.Closed") {
				ClosePlay ();
			}
		}
		private function onVideoNetStatusHandler (event:NetStatusEvent):void {
			//trace("onVideoNetStatusHandler event.info.code="+event.info.code+"; m_PlayNs.bufferLength="+m_PlayNs.bufferLength + "; m_PlayNs.liveDelay="+m_PlayNs.liveDelay);
			if (event.info.code == "NetConnection.Connect.Success") {

			} else if (event.info.code == "NetConnection.Connect.Failed" ||
			  	event.info.code == "NetConnection.Connect.Closed") {
				Play ();
			} else if (event.info.code == "NetConnection.Connect.Empty") {
				m_PlayNs.pause ();
				if (m_EmptyTimer == null) {
					m_EmptyTimer = new Timer(3000,1);
					m_EmptyTimer.addEventListener (TimerEvent.TIMER_COMPLETE, EmptyPlay);
				} else {
					m_EmptyTimer.reset ();
				}
				m_EmptyTimer.start ();

				dispatchEvent (new Event(UserPlayer.LOAD_RESUME));
			} else if (event.info.code == "NetConnection.Connect.Full") {
				if (m_PlayNs.currentFPS == 0) {
					if (m_FullTimer == null) {
						m_FullTimer = new Timer(500);
						m_FullTimer.addEventListener (TimerEvent.TIMER, ResetPlay);
					} else {
						m_FullTimer.reset ();
						if (m_EmptyTimer) {
							m_EmptyTimer.reset ();
						}
						m_CheckCount = 0;
					}
					m_FullTimer.start ();
					return;
				}
			} else if (event.info.code == "NetStream.Buffer.Empty" ||
					   event.info.code == "NetStream.Play.Reset") {
				if (m_BufferEmptyTimer == null) {
					m_BufferEmptyTimer = new Timer(1000,5);
					m_BufferEmptyTimer.addEventListener (TimerEvent.TIMER_COMPLETE, OnBufferCheck);
				} else {
					m_BufferEmptyTimer.reset ();
				}
				m_BufferEmptyTimer.start ();

				dispatchEvent (new Event(UserPlayer.LOAD_RESUME));
			} else if (event.info.code == "NetStream.Play.Start") {
				if (m_BufferEmptyTimer) {
					m_BufferEmptyTimer.stop ();
					m_BufferEmptyTimer.reset ();
				}
				
				//dispatchEvent (new Event(UserPlayer.VIDEO_LOADED));
			}else if(event.info.code == "NetStream.Buffer.Full"){
				//trace(m_PlayNs.bufferLength);
					m_ServerVideo.attachNetStream (m_PlayNs);
				if (m_BufferEmptyTimer) {
					m_BufferEmptyTimer.stop ();
					m_BufferEmptyTimer.reset ();
				}
				
				dispatchEvent (new Event(UserPlayer.VIDEO_LOADED));
			}
		}

		private function ResetPlay (event:TimerEvent):void {
			if (m_CheckCount == 10) {
				if (m_PlayNs.currentFPS == 0) {
					m_PlayNs.resume();
				} else {
					m_FullTimer.stop ();
					if (m_EmptyTimer) {
						m_EmptyTimer.stop ();
					}

					dispatchEvent (new Event(UserPlayer.VIDEO_LOADED));
				}
			}
			m_CheckCount++;
		}
		private function EmptyPlay (event:TimerEvent):void {
			if (m_PlayNs) {
				m_PlayNs.resume();
			}
		}
		private function OnBufferCheck (event:TimerEvent):void {
			if (m_PlayNs) {
				m_PlayNs.resume ();
			}
		}
	}
}