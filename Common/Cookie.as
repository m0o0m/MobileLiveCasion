package Common{
	import flash.external.ExternalInterface;
	import flash.events.TimerEvent;
	import flash.utils.Timer;

	public class Cookie {
		protected var m_value:String;
		protected var m_key:String;
		public function Cookie () {
			// constructor code
		}
		//as调用js传回值
		public function ReadCookie (key):String {

			if (ExternalInterface.available) {
				try {
					return ExternalInterface.call("ReadCookie",m_key);
				} catch (error:SecurityError) {
					trace ("A SecurityError occurred: " + error.message + "\n");
				} catch (error:Error) {
					trace ("An Error occurred: " + error.message + "\n");
				}
			}
			return null;
		}
		//as调用js传出值
		public function WriteCookie (key:String,values:String):void {
			if (ExternalInterface.available) {
				try {
					ExternalInterface.call ("WriteCookie",key,values);
				} catch (error:SecurityError) {
					trace ("A SecurityError occurred: " + error.message + "\n");
				} catch (error:Error) {
					trace ("An Error occurred: " + error.message + "\n");
				}
			}
		}
	}
}