package Common{
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.external.ExternalInterface;
	public class openWindow {
		public function openWindow() {
			
		}
		public static function open (url:String, window:String="_blank", features:String="") {
			var WINDOW_OPEN_FUNCTION:String = "window.open";
			var myURL:URLRequest = new URLRequest(url);
			var browserName:String = getBrowserName();

			if (getBrowserName() == "Firefox") {
				ExternalInterface.call (WINDOW_OPEN_FUNCTION, url, window, features);
			} else if (browserName == "IE") {
				ExternalInterface.call (WINDOW_OPEN_FUNCTION, url, window, features);
			} else if (browserName == "Safari") {
				navigateToURL (myURL, window);
			} else if (browserName == "Opera") {
				navigateToURL (myURL, window);
			} else {
				navigateToURL (myURL, window);
			}
		}
		private static function getBrowserName ():String {
			var browser:String;

			//Uses external interface to reach out to browser and grab browser useragent info.
			var browserAgent:String = ExternalInterface.call("function getBrowser(){return navigator.userAgent;}");

			// Debug.text += "Browser Info: [" + browserAgent + "]";

			//Determines brand of browser using a find index. If not found indexOf returns (-1).
			if (browserAgent != null && browserAgent.indexOf("Firefox") >= 0) {
				browser = "Firefox";
			} else if (browserAgent != null && browserAgent.indexOf("Safari") >= 0) {
				browser = "Safari";
			} else if (browserAgent != null && browserAgent.indexOf("MSIE") >= 0) {
				browser = "IE";
			} else if (browserAgent != null && browserAgent.indexOf("Opera") >= 0) {
				browser = "Opera";
			} else {
				browser = "Undefined";
			}
			return browser;
		}
	}
}