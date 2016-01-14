package GameModule.Common{

	import flash.display.MovieClip;
	import flash.utils.getDefinitionByName;
	import flash.geom.Point;
	import flash.text.TextField;
	 import Common.*;

	/*
	 * 用户信息
	*/
	public class UserInfo extends MovieClip {

		//标题 语言
		protected var userInfoLange:UserInfoLange = null;//用户信息语言
		protected var userInfoLangeName:String = "GameModule.Common.UserInfoLange";
		protected var userLange:Point = new Point(17.4,7.6);//用户信息语言位置

		//信息
		protected var txtTablePhone:TextField = null;//直播电话
		protected var txtUserName:TextField = null;//用户名
		protected var txtBalance:TextField = null;//用户余额
		protected var txtTableNumber:TextField = null;//桌子编号
		protected var txtTableName:TextField = null;//桌子名称
		protected var txtGameRoundNo:TextField = null;//游戏局号
		protected var txtDealerName:TextField = null;//荷官名称
		protected var txtQuotamin:TextField = null;//最小投注
		protected var txtQuotamax:TextField = null;//最大投注

		public function UserInfo () {
			InitializeUserInfo ();
		}

		/*
		 * 销毁
		*/
		public function Destroy ():void {
			if (userInfoLange) {
				removeChild (userInfoLange);
				userInfoLange = null;
			}
			txtUserName = null;
			txtBalance = null;
			txtTableNumber = null;
			txtTableName = null;
			txtTablePhone = null;
			txtGameRoundNo = null;
			txtDealerName = null;
			txtQuotamin = null;
			txtQuotamax = null;
		}

		/*
		 * 初始化
		*/
		protected function InitializeUserInfo ():void {
			//头 语言
			if (userInfoLangeName) {
				var userlangeClass:Class = getDefinitionByName(userInfoLangeName) as Class;
				var userlange:* = new userlangeClass  ;
				userInfoLange = userlange as UserInfoLange;
				if (userInfoLange) {
					addChild (userInfoLange);
					userInfoLange.x = userLange.x;
					userInfoLange.y = userLange.y;
				}
			}

			if (this.getChildByName("userName")) {
				txtUserName = this["userName"];
			}
			if (this.getChildByName("balance")) {
				txtBalance = this["balance"];
			}
			if (this.getChildByName("tableNumber")) {
				txtTableNumber = this["tableNumber"];
			}
			if (this.getChildByName("tableName")) {
				txtTableName = this["tableName"];
			}
			if (this.getChildByName("tablePhone")) {
				txtTablePhone = this["tablePhone"];
			}
			if (this.getChildByName("gameRoundNo")) {
				txtGameRoundNo = this["gameRoundNo"];
			}
			if (this.getChildByName("dealerName")) {
				txtDealerName = this["dealerName"];
			}
			if (this.getChildByName("quotamin")) {
				txtQuotamin = this["quotamin"];
			}
			if (this.getChildByName("quotamax")) {
				txtQuotamax = this["quotamax"];
			}
		}

		/*
		 * 显示用户名
		*/
		public function ShowUserName (userName:String):void {
			if (txtUserName) {
				txtUserName.text = userName;
			}
		}

		/*
		 * 显示余额
		*/
		public function ShowBalance (moneyType:String,balance:Number):void {
			if (txtBalance) {
				txtBalance.text =moneyType+"  "+NumberFormat.BalanceFormat(balance);
			}
		}

		/*
		 * 显示桌编号
		*/
		public function ShowTableNumber (tableNumber:String):void {
			if (txtTableNumber) {
				txtTableNumber.text = tableNumber;
			}
		}

		/*
		 * 显示桌名称
		*/
		public function ShowTableName (tableName:String):void {
			if (txtTableName) {
				txtTableName.text = tableName;
			}
		}
		public function ShowTablePhone (tablePhone:String):void {
			if (txtTablePhone) {
				txtTablePhone.text = tablePhone;
			}
		}

		/*
		 * 显示游戏局号
		*/
		public function ShowGameRoundNo (roundNo:String):void {
			if (txtGameRoundNo) {
				txtGameRoundNo.text = roundNo;
			}
		}

		/*
		 * 显示荷官名
		*/
		public function ShowDealerName (dealerName:String):void {
			if (txtDealerName) {
				var arr:Array=dealerName.split(":");
				if(arr.length==2){
				txtDealerName.text = arr[1];
				}
			}
		}

		/*
		 * 显示最小
		*/
		public function ShowQuotaMin(quotamin:String):void {
			if (txtQuotamin) {
				txtQuotamin.text = quotamin;
			}
		}

		/*
		 * 显示最大投注
		*/
		public function ShowQuotaMax (quotamax:String):void {
			if (txtQuotamax) {
				txtQuotamax.text = quotamax;
			}
		}
		public function SetLang(strlang:String):void{
			this["info"].gotoAndStop(strlang);
		}
	}
}