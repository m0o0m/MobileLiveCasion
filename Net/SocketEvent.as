package Net{
	import flash.events.Event;
	public class SocketEvent extends Event {
		public static  const CONNECTED = "Connected";
		public static  const DISCONNECTED = "DisConnected";
		public static  const MESSAGE = "Message";

		public var MainCmd = 0;
		public var SubCmd = 0;
		public var Data = "";

		public function SocketEvent(type:String, mainCmd:int = 0, subCmd:int = 0, data:String = "") {
			super(type);
			MainCmd = mainCmd;
			SubCmd = subCmd;
			Data = data;
		}
	}
}