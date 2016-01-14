package Common{

	public class NumberFormat {
		public function NumberFormat () {
			// constructor code
		}
		/**
		 * 余额格式化
		 */
		public static function BalanceFormat(obj:Object):String {
			var money:String = String(obj);
			var list:Array = money.split('.');
			if(list.length == 2 && list[1].length > 2) {
				return formatString(list[0]+"."+list[1].substr(0, 2));
			}
			return formatString(obj);
		}
		public static function formatString (obj:Object):String {
			if ((((obj is int) || obj is uint) || obj is Number)) {
				var money:Number = Number(obj);
				var isSmall:Boolean = false;
				if (money<0) {
					money =  -  money;
					isSmall = true;
				}
				var str:String = (Math.round((money / 0.01)) * 0.01).toString();
				var _index:int = str.indexOf(".");
				var cursor:int = 0;
				if ((_index > -1)) {
					cursor = _index;
					str = str.substring(0,_index + 3);
					while (str.length < _index + 3) {
						str = str + "0";
					}
				} else {
					cursor = str.length;
					str = str + ".00";
				}
				var arrStr:Array = new Array  ;
				while (((cursor - 3) >= 0)) {
					arrStr.push (str.substr((cursor - 3),3));
					cursor = cursor - 3;
				}
				if ((cursor > 0)) {
					arrStr.push (str.substr(0,cursor));
				}
				arrStr.reverse ();
				if (isSmall) {
					return "-"+arrStr.join(',') + str.substr(str.indexOf("."));
				}
				return arrStr.join(',') + str.substr(str.indexOf("."));
			} else {
				return obj.toString();
			}
		}
		public static function returnNumber (strNumber:String):Number {
			strNumber = strNumber.replace(",","");
			return Number(strNumber);
		}
	}
}