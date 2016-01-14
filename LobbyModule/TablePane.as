package {
	import flash.display.Sprite;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.display.Graphics;
	import flash.utils.setTimeout;
	import flash.utils.clearTimeout;
	import flash.geom.Rectangle;
	import flash.net.URLRequest;

	import Common.*;
	import CommandProtocol.*;
	import IGameFrame.IHistoryResultManger;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import flash.display.Loader;
	import IGameFrame.IChangLang;
	import flash.geom.Point;
	import flash.text.TextFormat;

	public class TablePane extends Sprite implements IChangLang {
		protected var m_roomPane:RoomPane;

		protected var m_wTableID:uint;//桌子编号
		protected var m_wControlMode:int;//桌子控制模式
		protected var m_strTableInfo:String;
		protected var m_strCreditTotal:String;
		protected var m_totalMember:String;

		protected var m_BetLimit:BetLimitPane;

		protected var m_HostEnter:Boolean = false;
		protected var m_LookOnEnter:Boolean = false;

		var hrm:IHistoryResultManger = null;

		protected var m_onlineCount:int = 0;
		protected var m_betlist:Array;
		protected var m_memberlist:Array;
		protected var m_more:Boolean;

		public var m_rect:Rectangle;//限额显示范围

		protected var IsBetTime:Boolean = false;
		//
		protected var loadmap:Loader;
		//限额
		protected var m_limit:Array;

		protected var m_MoneyType:String;//货币类型

		protected var lang:String;//当前语言
		protected var m_creditTotal:Number;//临时存储（切换语言）
		protected var m_historyroad:Array;//路子统计（切换语言）
		protected var m_tablename:String;//桌台名（切换语言）
		public var m_BetLimitPoint:Point = new Point(0,35.55);//限额坐标
		public var m_loadmapPoint:Point = new Point(4,34.95);//相片位置

		protected var m_ration:Number;//扇形变换角度;
		protected var moviec:MovieClip;
		var S_angle:Number = 0;//扇形旋转角度

		public function TablePane () {
			m_strCreditTotal = GetTableInfo("total","ch");
			m_totalMember = GetTableInfo("totalcount","ch");

			if (this.getChildByName("m_tableName")) {
				this["m_tableName"].mouseEnabled = false;
			}
			if (this.getChildByName("btnEnter")) {
				this["btnEnter"].addEventListener (MouseEvent.CLICK,ShowBetLimit);
			}
			var stag:Sprite = new Sprite  ;
			if (this.getChildByName("m_bettime")) {
				this["m_bettime"].addChild (stag);
				this["m_bettime"].mouseChildren=false;
				this["m_bettime"].mouseEnabled = false;
			}
			if (this.getChildByName("m_status")) {
				this["m_status"].mouseEnabled = false;
			}
			if (this.getChildByName("mc_shadow")) {
				this["mc_shadow"].mouseEnabled = false;
			}
			moviec = new MovieClip  ;
			stag.addChild (moviec);
		}
		protected function InitHistoryResult ():void {
		}
		public function SetRoomPane (rp:RoomPane):void {
			m_roomPane = rp;

			InitHistoryResult ();
		}
		public function GetMeUserID ():int {
			if (m_roomPane) {
				return m_roomPane.GetMeUserID();
			}
			return 0;
		}
		public function Destroy ():void {
			if (this.getChildByName("btnEnter")) {
				this["btnEnter"].removeEventListener (MouseEvent.CLICK,ShowBetLimit);
			}
			if(hrm){
				removeChild (hrm.GetMovieClip());
				hrm.Destroy ();
				hrm = null;
			}
			if (loadmap) {
				this.removeChild (loadmap);
				loadmap = null;
			}
		}
		/**
		 * 设置投注限额
		 * @限额 [[编号,范围],[编号,范围]]
		 */
		public function SetBetLimit (limit:Array):void {
			m_limit = limit;
		}
		//进入游戏
		public function EnterGame (limitID:int):void {
			if ((m_roomPane != null)) {
				m_roomPane.EnterGame (m_wTableID,limitID,m_HostEnter,m_more,m_LookOnEnter);
			}
		}
		//设置桌子信息
		public function SetTableInfo (table:cmdMemberTableInfo) {
			if ((table != null)) {
				m_wTableID = table.TableID;
				m_wControlMode = table.ControlMode;
				m_tablename = table.TableName;
				if(hrm){
					hrm.StringSplit (table.HisRoad);
					ShowRoadInfo (hrm.GetResoultList());
				}
				ShowTableInfo (table.OnlineMembers,table.TotalCredit,table.Status);
				if (this.getChildByName("m_tableName") && lang) {
					//trace(table.TableName);
					this["m_tableName"].text = ShowCMDLang(table.TableName,lang);
				}
				m_totalTime = table.BetTime;
				m_timeCount = table.DiffTime;
				SetBetTimer ();
			}
		}

		//显示桌面投注
		public function SetTablePositionBet (betPos:cmdMemberTablePositionBet):void {
		}
		//显示桌面投注
		public function SetTablePositionMembers (memPos:cmdMemberTablePositionMembers):void {
		}
		public function GetTotalBetStyle (betValue:Object):String {
			var money:Number = Number(betValue);

			return money.toFixed(2);
		}
		//显示游戏状态
		public function SetTableStatus (tableStatus:cmdMemberTableStatus) {
			m_timeCount = tableStatus.DiffTime;
			ShowTableInfo (tableStatus.OnlineMembers,tableStatus.TotalCredit,tableStatus.Status);
		}
		protected var m_gamestatus:int;
		private function ShowTableInfo (memberCount:int,creditTotal:Number,status:int):void {
			m_gamestatus = status;
			m_onlineCount = memberCount;
			m_creditTotal = creditTotal;
			if (this.getChildByName("m_bettime")) {
				this["m_bettime"]["red"].visible = false;
				this["m_bettime"]["numred"].visible = false;
			}
			IsBetTime = false;
			switch (status) {
				case 2 :
					IsBetTime = true;
					if (this.getChildByName("mc_shadow")) {
						this["mc_shadow"].visible = false;
					}
					SetBetTimer ();
					if (this.getChildByName("m_status")) {
						this["m_status"].text = GetTableStatus(status,lang);
					}
					break;
				case 0 :
				case 1 :
				case 3 :
				case 4 :
				case 5 :
				case 6 :
					m_timeCount = -1;
					TimeStop ();
					//MoveMcTimer (0);
					if (this.getChildByName("m_status")) {
						this["m_status"].text = GetTableStatus(status,lang);
					}
					break;
			}
		}
		//历史结果
		public function SetTableHisRoad (hisRoad:cmdMemberTableHisRoad):void {
			if(hrm){
				hrm.StringSplit (hisRoad.HisRoad);
				ShowRoadInfo (hrm.GetResoultList());
			}
		}
		public function SetTableDealer (dealer:cmdMemberTableDealer):void {

		}
		//统计庄闲和数量
		public function ShowRoadInfo (arr:Array) {

		}
		//设置限额选择
		public function SetTableBetLimit ():void {

		}
		//显示限额
		public function ShowBetLimit (event:MouseEvent):void {
			m_LookOnEnter = false;
			m_HostEnter = false;
			m_more = false;
			if (((m_wControlMode == 2) && m_limit)) {
				EnterGame (0);
				return;
			}
			if ((m_roomPane != null)) {
				m_roomPane.ShowLimitPane (m_limit,m_wTableID,m_HostEnter,m_more,m_LookOnEnter,m_MoneyType);
			}
			//SetBetLimitStatus (true,m_HostEnter);
		}
		public function SetBetLimitStatus (show:Boolean,host:Boolean):void {
			/*if (show) {
				if (m_BetLimit.GetShowStatus() == false) {
					this.setChildIndex (m_BetLimit,this.numChildren - 1);
					m_BetLimit.ShowBetLimit (true);
					if ((host || m_more)) {
						m_BetLimit.x = m_BetLimitPoint.x;
						m_BetLimit.y = m_BetLimitPoint.y;
					} else {
						m_BetLimit.x = m_BetLimitPoint.x;
						m_BetLimit.y = m_BetLimitPoint.y;
					}
				}
			} else {
				m_BetLimit.ShowBetLimit (false);
			}

			var _y:Number = m_BetLimit.y - m_BetLimit._height;*/
		}
		//倒计时
		protected var m_timeCount:int = -1;//投注剩余时间
		protected var m_BetTimer:Timer;
		protected var m_totalTime:Number;//总时间
		public function SetBetTimer ():void {
			if ((m_wControlMode == 2)) {
				/*if (this.getChildByName("m_load")) {
				this["m_load"]["m_timer"].x = this["m_load"]["m_timer"].width;
				}*/
				if ((m_gamestatus == 2)) {
					if (this.getChildByName("mc_shadow")) {
						this["mc_shadow"].visible = true;
					}
					if (this.getChildByName("m_status")) {
						this["m_status"].text = GetTableStatus(2,lang);
					}
				}
				return;
			}
			if ((((m_totalTime == 0) || IsBetTime == false) || m_timeCount <= 0)) {
				return;
			}
			if ((m_BetTimer == null)) {
				m_BetTimer = new Timer(1000,m_timeCount);
				m_BetTimer.addEventListener (TimerEvent.TIMER,OnShowTimer);
				m_BetTimer.addEventListener (TimerEvent.TIMER_COMPLETE,OnTimeOver);
			} else {
				m_BetTimer.reset ();
			}
			m_ration = 360 / m_totalTime;
			S_angle = (m_totalTime - m_timeCount) * m_ration;
			m_BetTimer.start ();
			//MoveMcTimer (0);
			OnShowTimer (null);
		}
		public function OnShowTimer (e:TimerEvent):void {
			m_timeCount--;
			if ((m_timeCount < 0)) {
				return;
			}
			moviec.graphics.clear ();
			S_angle +=  m_ration;
			DrawSector (moviec,11,11,12,S_angle,270,0x000000);
			if (this.getChildByName("m_bettime")) {
				this["m_bettime"]["m_text"].text = m_timeCount;
				if ((m_timeCount <= 5)) {
					this["m_bettime"]["red"].visible = true;
					this["m_bettime"]["numred"].visible = true;

				}
			}
			//MoveMcTimer (m_timeCount / m_totalTime);
		}
		private function MoveMcTimer (rate:Number):void {
			/*if (this.getChildByName("m_load")) {
			this["m_load"]["m_timer"].x = (1 - rate) * this["m_load"]["m_timer"].width;
			}*/
		}
		public function OnTimeOver (e:TimerEvent):void {
			TimeStop ();
		}
		//停止倒计时
		public function TimeStop ():void {
			if (m_BetTimer) {
				m_BetTimer.removeEventListener (TimerEvent.TIMER,OnShowTimer);
				m_BetTimer.removeEventListener (TimerEvent.TIMER_COMPLETE,OnTimeOver);
				m_BetTimer.stop ();
				m_BetTimer = null;
			}
			if (this.getChildByName("mc_shadow")) {
				this["mc_shadow"].visible = true;
			}
			S_angle = 0;
		}
		public function SetMoneyType (moneyType:String):void {
			m_MoneyType = moneyType;
		}
		public function IChangLang (strLang:String):void {
			lang = strLang;
			if (hrm) {
				hrm.SetLang (lang);
			}
			m_strCreditTotal = GetTableInfo("total",lang);
			m_totalMember = GetTableInfo("totalcount",lang);
			ShowTableInfo (m_onlineCount,m_creditTotal,m_gamestatus);
			if (this.getChildByName("m_tableName") && m_tablename) {
				this["m_tableName"].text = ShowCMDLang(m_tablename,lang);
			}
		}
		public function GetVipStatus (vipstatus:Boolean):void {
		}
		//更改时间进度为扇形
		public function DrawSector (mc:MovieClip,x:Number,y:Number,r:Number,angle:Number,startFrom:Number,color:Number):void {
			mc.graphics.beginFill (color,50);
			mc.graphics.lineStyle (0,0x000000);
			mc.graphics.moveTo (x,y);
			angle = Math.abs(angle) > 360 ? 360:angle;
			var n:Number = Math.ceil(Math.abs(angle) / 45);
			var angleA:Number = angle / n;
			angleA = angleA * Math.PI / 180;
			startFrom = startFrom * Math.PI / 180;
			mc.graphics.lineTo ((x + r * Math.cos(startFrom)),y + r * Math.sin(startFrom));
			for (var i = 1; i <= n; i++) {
				startFrom +=  angleA;
				var angleMid = startFrom - angleA / 2;
				var bx = x + r / Math.cos((angleA / 2)) * Math.cos(angleMid);
				var by = y + r / Math.cos((angleA / 2)) * Math.sin(angleMid);
				var cx = x + r * Math.cos(startFrom);
				var cy = y + r * Math.sin(startFrom);
				mc.graphics.curveTo (bx,by,cx,cy);
			}
			if ((angle != 360)) {
				mc.graphics.lineTo (x,y);
			}
			mc.graphics.endFill ();
		}
		//设置游戏多人桌
		/*public function SetGameKind(kind:int):void{
		
		}*/
	}
}
include "./LobbyText.as";