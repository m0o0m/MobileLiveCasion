package CommandProtocol{
	
	public class Tool {
		public function Tool () {
		}
		public static function getstrToDate ( str:String):Date {
			var dt:Date=new Date();
			try {
				var newstr = str.replace(/-/g,'/').replace(/\s{2,}/g,' ');
				var time:Number = Date.parse(newstr);
				dt.setTime (time);
			} catch (e:Error) {

			}
			return dt;
		}
		public static function DateToString (dt:Date,format:String=''):String {
			var str:String = '';
			/*if (! dt) {
				return str;
			}
			str = dt.toString();
			try {
				var df:DateFormatter=new DateFormatter();
				if (! format || format == '') {
					format = 'YYYY-MM-DD HH:NN:SS';
				}
				df.formatString = format;
				str = df.format(dt);
			} catch (e:Error) {
			}*/
			return str;
		}
		public static function StringToBoolean (str:String):Boolean {
			if (str.toLocaleLowerCase() == 'true') {
				return true;
			}
			return false;
		}
	}
}