package Common{
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLLoaderDataFormat;
	import flash.events.Event;
	import flash.events.SecurityErrorEvent;
	import flash.events.IOErrorEvent;
	import flash.utils.ByteArray;

	//请求网页
	public class PostPage {
		private var m_CallBack:Function;//回调

		private var m_UrlLoader:URLLoader;

		public function PostPage (url:String,PostData:Array,CallBack:Function) {
			if ((PostData == null)) {
				//CallBack(null);
				PostData = new Array  ;
			}
			m_CallBack = CallBack;
			Load (url,PostData);
		}
		public static function LoadPostPage (url:String,PostData:Array,CallBack:Function):PostPage {
			return new PostPage(url,PostData,CallBack);
		}
		private function Load (url:String,PostData:Array):void {
			var urlRequest:URLRequest = new URLRequest(url);
			var strURL:String = "";
			for (var i:uint = 0; i < PostData.length; i++) {
				if (PostData[i][0] != null && PostData[i][1] != null) {
					strURL = strURL + PostData[i][0].toString() + "=" + PostData[i][1].toString();
					if ((i < PostData.length - 1)) {
						strURL +=  "&";
					}
				}
			}
			var result:ByteArray = new ByteArray  ;
			result.writeUTFBytes (strURL);
			urlRequest.data = result;
			urlRequest.method = URLRequestMethod.POST;
			m_UrlLoader = new URLLoader  ;
			m_UrlLoader.dataFormat = URLLoaderDataFormat.BINARY;
			m_UrlLoader.load (urlRequest);
			m_UrlLoader.addEventListener (Event.COMPLETE,completeHandler);
			m_UrlLoader.addEventListener (SecurityErrorEvent.SECURITY_ERROR,securityErrorHandler);
			m_UrlLoader.addEventListener (IOErrorEvent.IO_ERROR,ioErrorHandler);
		}
		private function completeHandler (e:Event):void {
			if (e.target == null) {
				trace ("e.target = null");
				m_CallBack (null);
				Destroy ();
				return;
			}
			if (e.target.data == null) {
				trace ("e.target.data = null");
				m_CallBack (null);
				Destroy ();
				return;
			}
			var result:ByteArray = ByteArray(e.target.data);
			result.position = 0;
			var souceStr:String = result.readUTFBytes(result.length);
			result.position = 0;

			if(m_CallBack != null) {
				m_CallBack (souceStr);
			}
			Destroy ();
		}

		private function securityErrorHandler (event:SecurityErrorEvent):void {
			trace (("securityErrorHandler: " + event));
			if(m_CallBack != null) {
				m_CallBack (null);
			}
			Destroy ();
		}

		private function ioErrorHandler (event:IOErrorEvent):void {
			trace (("ioErrorHandler: " + event));
			if(m_CallBack != null) {
				m_CallBack (null);
			}
			Destroy ();
		}
		private function Destroy ():void {
			m_UrlLoader.removeEventListener (Event.COMPLETE,completeHandler);
			m_UrlLoader.removeEventListener (SecurityErrorEvent.SECURITY_ERROR,securityErrorHandler);
			m_UrlLoader.removeEventListener (IOErrorEvent.IO_ERROR,ioErrorHandler);
			m_UrlLoader = null;
			m_CallBack = null;
		}
	}
}