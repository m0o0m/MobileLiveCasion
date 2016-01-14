package GameModule.Common{
	import flash.display.MovieClip;
	import flash.utils.ByteArray;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import flash.utils.setTimeout;
	import flash.net.LocalConnection;

	import CommandProtocol.*;
	import Net.*;
	import IGameFrame.*;
	import LobbyModule.MessageBox.MessageType;

	public class GameBaseClass extends MovieClip implements IGameClass,IClientSocketSink {
		protected var m_clientContainer:IGameClassContainer;//视图容器
		protected var m_clientSocket:ClientSocket;//Socket

		protected var m_ActiveStatus:Boolean = false;

		protected var m_GameClientView:GameBaseView;//游戏视图

		protected var m_wChairCount:uint = 0;//椅子总数
		
		protected var m_isMoreTable:Boolean=true;//是否是多人桌
		//房间信息
		protected var m_tableInfo:cmdMemberTableInfo;//桌子属性
		protected var m_wBetLimitID:int;//投注限额编号
		protected var m_isHost:Boolean;//是否独享
		protected var m_lookOn:Boolean;//是否旁观
		protected var m_changeChairStatus:Boolean = false;//是否切换位置状态
		protected var m_wTableID:uint;//桌子号码
		protected var m_wChairID:uint;//椅子号码
		protected var m_MaxBet:Number;//最大投注
		protected var m_MinBet:Number;//最小投注
		protected var m_betLimitForPos:Array;//每个投注位置限额
		protected var m_tablePassword:String;//桌子密码
		//固有信息
		protected var m_dwUserID:uint;//用户 I D

		//游戏信息
		protected var m_bInquire:Boolean;//关闭询问
		protected var m_bGameStatus:uint;//游戏状态

		//用户信息
		protected var m_pMeUserItem:cmdMemberInfo;//自己信息
		protected var m_pUserItem:Array;//玩家信息 椅子号从1开始, 索引 = Chair - 1

		//投注筹码
		protected var m_SelectChip:Number = 0;//选择筹码大小.
		protected var m_BetPosCount:uint = 0;//投注位置总数
		protected var m_BetTotalList:Array;//投注总数 1维索引投注位置, 2维:1已经确认投注,2等待确认投注
		protected var m_BetList:Array;//未确认投注 1维索引投注顺序，2维：0索引投注位置,1索引投注金额
		protected var m_RepeatBetList:Array;//重复投注

		//投注信息
		protected var m_SubmitStatus:Boolean = false;//提交中. true: 正在提交,还没有返回; false: 允许现在提交
		protected var m_BetErrorList:Array;//投注错误列表
		protected var m_BetCount:int;//投注总个数
		protected var m_BetReturnCount:int;//投注返回总个数

		protected var m_sound:GameSound;//声音

		protected var endGame:Array;//游戏是否结束(视移动筹码完成为游戏结束)
		protected var m_totalBet:Array;

		protected var m_MoneyType:String;//货币类型

		//坐下超时
		protected var m_SiteDownTimer:Timer;
		protected var m_SiteDownTimeOutTime:int = 30000;

		protected var m_lang:String;//当前语言
		//最大限额数组
		protected var betlimitByPos:Array;
		//最小限额数组
		protected var minbetlimitByPos:Array;
		//输赢结果
		protected var m_totalWin:String = "";
		
		public function GameBaseClass () {
			stop();
			m_pUserItem = new Array();
			m_BetTotalList = new Array();
			m_BetList=new Array();
			endGame=new Array();
		}
		//////////////////////////////////////////////
		/**
		 * 创建游戏 (有代码未实现)
		 * @clientContainer
		 * @table 桌子信息
		 * @limitID 限额编号
		 * @isHost 是否独享
		 */
		public function CreateGameClient (clientContainer:IGameClassContainer, table:cmdMemberTableInfo, param:Object):Boolean {
			
			m_clientContainer = clientContainer;
			m_tableInfo = table;
			m_wBetLimitID = param["limitid"];
			m_isHost = param["ishost"];
			m_tablePassword = param["tablepwd"];
			m_MoneyType = param["moneytype"];
			m_lang = param["language"];
			m_lookOn = param["lookon"];
			SetLimit (m_wBetLimitID);
			//加载播放文件
			InitGameSound ();
			if ((table == null)) {
				return false;
			}
			m_wTableID = table.TableID;
			//初始化游戏类
			if (InitGameClass() == false) {
				return false;
			}
			m_dwUserID = m_clientContainer.GetMeUserID();

			m_clientSocket = new ClientSocket();
			m_clientSocket.SetSocketSink (this);
			//连接Socket;
			if (m_clientSocket.Connect(table.ServerIP,table.ServerPort)) {
				return true;
			}

			DestroyGameClient ();
			return false;
		}
		//销毁游戏 (有代码未实现)
		public function DestroyGameClient ():void {
			if ((m_clientContainer != null)) {
				DestroyGameClass ();
				m_clientContainer = null;
			}
			for (var i:int = numChildren - 1; i >= 0; i--) {
				removeChildAt (i);
			}
		}
		//加载声音播放文件
		protected function InitGameSound ():void {
			m_sound=new GameSound();
			//重写加载xml文件
		}
		//获取影片剪辑
		public function GetMovieClip ():MovieClip {
			return this;
		}
		public function ResetGameClass ():void {
			m_SubmitStatus = false;
			m_BetErrorList = null;
			m_BetCount = 0;
			m_BetReturnCount = 0;

			m_BetTotalList = new Array();
			m_totalWin = "";

			m_GameClientView.ResetGameView ();
		}
		//获取激活状态;
		public function SetActiveStatus (active:Boolean):void {
			m_ActiveStatus = active;
		}
		//获取激活状态
		public function GetActiveStatus ():Boolean {
			return m_ActiveStatus;
		}
		//获取游戏视图
		public function GetGameView ():IGameView {
			if ((m_GameClientView == null)) {
				return null;
			} else {
				return m_GameClientView as IGameView;
			}
		}
		//创建游戏视图
		protected function CreateGameView ():GameBaseView {
			return null;
		}
		//发送退出游戏
		public function SendEventExitGameClient ():void {
			if (m_clientContainer) {
				m_clientContainer.DestroyGameClass (this);
			}
		}
		///////////////////////////////////////////////////////;
		//初始化游戏 (有代码未实现)
		public function InitGameClass ():Boolean {
			do {
				m_dwUserID = 0;

				if ((m_GameClientView == null)) {
					//创建游戏视图
					m_GameClientView = CreateGameView();
					if ((m_GameClientView == null)) {
						break;
					}
					m_GameClientView.x = 0;
					m_GameClientView.y = 0;

					addChild (m_GameClientView);
					//传递播放文件
					if (m_sound) {
						m_GameClientView.SetSound (m_sound);
					}
					m_GameClientView.SetLookOn (m_lookOn);
					m_GameClientView.SetLang (m_lang);
					m_GameClientView.SetBetLimitByPos (m_betLimitForPos,m_MinBet);
					m_GameClientView.SetHost (m_isHost);
					//初始化游戏视图;
					if (m_GameClientView.InitGameView() == false) {
						break;
					}
					if (m_clientContainer) {
						var soundSetting:Array = m_clientContainer.GetSoundSetting();
						if (soundSetting.length == 2) {
							m_GameClientView.GetMusic (soundSetting[0]);
							m_GameClientView.GetSound (soundSetting[1]);
						}
					}
				}
				return true;
			} while (false);
			return false;
		}
		//销毁游戏 (有代码未实现)
		public function DestroyGameClass ():void {
			if (m_clientSocket) {
				m_clientSocket.CloseSocket (false);
				m_clientSocket = null;
			}
			removeSiteDownTimeOut ();

			if (m_GameClientView) {
				m_GameClientView.DestroyGameView ();
				removeChild (m_GameClientView);
				m_GameClientView = null;
			}
			while (this.numChildren > 0) {
				removeChildAt (0);
			}
			try {
				var lc:LocalConnection = new LocalConnection();
				lc.connect ("foo");
				lc.connect ("foo");
			} catch (error:Error) {

			}
			if (betlimitByPos) {
				betlimitByPos = null;
			}
			if (minbetlimitByPos) {
				minbetlimitByPos = null;
			}
			if (m_totalBet) {
				m_totalBet = null;
			}
			if(m_clientContainer){
				m_clientContainer=null;
			}
		}

		/////////////////////////////////////////////////////
		//发送下注 (有代码未实现)
		
		public function OnSendBet ():Boolean {
			//不在投注状态
			if (m_bGameStatus != 1) {
				m_GameClientView.ShowTableMessage (MessageType_Bet, MT_Bet_Status);
				return false;
			}
			if (m_SubmitStatus) {
				m_GameClientView.ShowTableMessage (MessageType_Bet, MT_Bet_Submit);
				return true;
			}
			SetBetPosLimit ();
			m_SubmitStatus = true;
			var bet:cmdMemberBet = new cmdMemberBet();
			bet.memID = m_dwUserID;
			bet.TableID = m_wTableID;
			bet.Chair = m_wChairID;
			bet.GameRoundNo = m_tableInfo.GameRoundNo;
			var betTotal:int = 0;
			var index:int = 0;
			var sum:int = 0;
			while (index < m_BetTotalList.length) {
				if (m_BetTotalList[index] && m_BetTotalList[index][1]) {
					var betMoney:int = int(m_BetTotalList[index][1]) + int(m_BetTotalList[index][0]);
					if (betMoney > 0) {
						//判断位置最大投注和最小投注(未实现)
						if (betMoney > betlimitByPos[index]) {
							//提示超过最大投注
							//trace ("发送下注 提示超过最大投注");
							m_SubmitStatus = false;
							m_GameClientView.ShowBetMessage (MT_Bet_Fail, [index, 6]);
							return false;
						}
						if (betMoney < minbetlimitByPos[index]) {
							//提示低于最小投注
							//trace ("发送下注 提示低于最小投注");
							m_SubmitStatus = false;
							m_GameClientView.ShowBetMessage (MT_Bet_Fail, [index, 6]);
							return false;
						}
						//累计总投注
						betTotal +=  betMoney;
					}
					sum +=  int(m_BetTotalList[index][1]);
				}
				index++;
			}
			//播放余额不足
			if (sum>m_pMeUserItem.Balance) {
				m_GameClientView.PlaySound (SoundConst.LackBalance,null);
				m_GameClientView.ShowBetMessage (MT_Bet_Fail, [index, 4]);
				m_SubmitStatus = false;
				return false;
			}
			//判断投注是否超过额度(未实现)
			//判断是否超过信用(未实现)
			//投注
			m_BetErrorList = new Array();

			index = 0;
			var betPosition:Array=new Array();
			var betAmount:Array=new Array();
			while (index < m_BetTotalList.length) {
				if (m_BetTotalList[index] && m_BetTotalList[index][1]) {
					betMoney = int(m_BetTotalList[index][1]);
					if (betMoney > 0) {
						betPosition.push (index.toString());
						betAmount.push (betMoney.toString());
						m_BetCount++;
					}

				}
				index++;
			}
			bet.BetPosition = betPosition.join("|");
			bet.BetAmount = betAmount.join("|");
			if (betlimitByPos) {
				betlimitByPos = null;
			}
			if (minbetlimitByPos) {
				minbetlimitByPos = null;
			}
			if (SendData(GameForMember.Bet, bet.PushData()) == false) {
				//trace ("发送下注 发送投注");
				m_SubmitStatus = false;
				m_GameClientView.ShowBetMessage (MT_Bet_Fail, [index, 3]);
				return false;
			}
			return true;
		}
		//发送站起命令
		public function OnSendStandUp ():void {
			var standUp:cmdMemberStandUp = new cmdMemberStandUp();
			standUp.memID = m_dwUserID;
			standUp.Chair = m_wChairID;
			SendData (GameForMember.StandUp, standUp.PushData());
			m_clientSocket.CloseSocket (false);
			SendEventExitGameClient ();
		}
		//发送数据
		public function SendData (wSubCmdID:int, sData:String):Boolean {
			if (m_clientSocket == null) {
				return false;
			}
			return m_clientSocket.SendData(MDM_GF_FRAME, wSubCmdID, sData);
		}
		/////////////////////////////////////////////////////
		//网络连接消息 (有代码未实现)
		public function OnSocketConnect (iErrorCode:int,pszErrorDesc:String,pIClientSocket:IClientSocket):Boolean {
			if (m_clientSocket != null && m_clientSocket.GetConnectState() == SocketState_Connected) {//网络联结成功
				//发送坐下命令;
				var sit:cmdMemberSitDown = new cmdMemberSitDown();
				sit.memID = m_clientContainer.GetMeUserID();
				sit.LoginCode = m_clientContainer.GetMePassword();//用户密码
				sit.TableID = m_wTableID;
				sit.blID = m_wBetLimitID;//限额编号
				sit.Host = m_isHost;//是否包桌
				sit.LookOn = m_lookOn;//是否旁观
				//VIP包桌和进入,限额传0;
				if(m_tableInfo.GameKind == GameKindEnum.VipBaccarat && m_lookOn == false) {
					sit.blID = 0;
				}
				if (m_isHost) {
					m_tablePassword = "";
				}
				sit.SitPassword = m_tablePassword;//桌子密码
				SendData (GameForMember.SitDown, sit.PushData());

				if (m_SiteDownTimer == null) {
					m_SiteDownTimer = new Timer(m_SiteDownTimeOutTime,1);
					m_SiteDownTimer.addEventListener (TimerEvent.TIMER_COMPLETE, onCheckSiteDownTimeOut);
				} else {
					m_SiteDownTimer.reset ();
				}
				m_SiteDownTimer.start ();
			}
			return false;
		}
		private function removeSiteDownTimeOut ():void {
			if (m_SiteDownTimer) {
				m_SiteDownTimer.stop ();
				m_SiteDownTimer.removeEventListener (TimerEvent.TIMER_COMPLETE, onCheckSiteDownTimeOut);
				m_SiteDownTimer = null;
			}
		}
		protected function onCheckSiteDownTimeOut (event:TimerEvent):void {
			ShowMessageBox (MessageType.SitDownError,SitDownError.SeatError,null,null,null,null);
			SendEventExitGameClient ();
		}
		//网络读取消息 (有代码未实现)
		public function OnSocketRead (wMainCmdID:uint,wSubCmdID:uint,pData:String,pIClientSocket:IClientSocket):Boolean {
			if (wMainCmdID == MDM_GF_FRAME) {
				switch (wSubCmdID) {
					case GameForMember.SitDown ://坐下返回
						removeSiteDownTimeOut ();//删除检查返回定时器
						var sitResult:cmdMemberSitResult = cmdMemberSitResult.FillData(pData);
						if (sitResult.errID == 0) {
							m_wChairID = sitResult.Chair;
							m_lookOn = sitResult.LookOn;
							//坐下成功. 显示游戏界面
							ActiveGameFrame ();
							if (m_lookOn==false) {
								endGame[m_wChairID] = false;
								//播放坐下
								if (m_wChairCount > 1) {
									m_sound.SetChair (m_wChairID);
								}
							}
						} else {
							//提示错误消息
							ShowMessageBox (MessageType.SitDownError,sitResult.errID,null,null,null,null);
							//离开游戏;
							SendEventExitGameClient ();
						}
						return true;
					case GameForMember.StandUp ://站起返回
						//离开游戏
						var standUp:cmdMemberStandUp = cmdMemberStandUp.FillData(pData);
						if (standUp) {
							endGame[standUp.Chair] = true;
							DeleteUserItem (standUp.memID);
							if (standUp.memID == m_dwUserID) {
								ShowMessageBox (MessageType.StandUpError,standUp.errID,null,null,null,null);
								SendEventExitGameClient ();
							}
						}
						return true;
					case GameForMember.MemberInfo ://会员信息
						var memInfo:cmdMemberInfo = cmdMemberInfo.FillData(pData);
						//旁观坐下,清除旁观状态
						if (m_changeChairStatus && m_lookOn && memInfo.memID == m_dwUserID) {
							m_changeChairStatus = false;
							m_lookOn = false;
							m_GameClientView.SetLookOn (m_lookOn);
							//删除旁观筹码;
							m_GameClientView.ClearLookOnChips ();

							//m_pMeUserItem.Chair = memInfo.Chair;
							//m_wChairID = memInfo.Chair;
							var limitID:int = m_clientContainer.GetVipLimitID(m_tableInfo.LimitType);
							SetLimit (limitID);
							m_totalBet[memInfo.Chair - 1] = null;

						}
						//增加用户
						return ActiveUserItem(memInfo);
					case GameForMember.MemberBalace ://会员余额
						var memBalance:cmdMemberBalance = cmdMemberBalance.FillData(pData);
						//通知余额改变
						OnEventBalanceChang (memBalance);
						return true;
					case GameForMember.Bet ://下注返回
						//trace("GameForMember.Bet "+pData);
						var memBetBack:cmdMemberBetBack = cmdMemberBetBack.FillData(pData);
						OnBetPosition (memBetBack.Chair, memBetBack.BetPosition, memBetBack.BetAmount, memBetBack.err);
						return true;
					case GameForMember.PositionTotalBet ://投注位置总投注
						//通知显示筹码
						//trace("GameForMember.PositionTotalBet "+pData);
						var totalBet:cmdMemberPositionTotalBet = cmdMemberPositionTotalBet.FillData(pData);
						return OnMemberPositionTotalBet(totalBet);
					case GameForMember.PositionWin ://投注输赢
						var totalWin:cmdMemberPositionWin = cmdMemberPositionWin.FillData(pData);
						return OnMemberPositionWinLose(totalWin);
					case GameForMember.ChangeChair ://变更座位返回
						var changResult:cmdMemberChangeChairBack = cmdMemberChangeChairBack.FillData(pData);
						if (changResult.err == 0) {
							ChangeChairID (changResult.OldChair,changResult.NewChair);
						} else {
							m_changeChairStatus = false;
							//提示错误消息
							ShowMessageBox (MessageType.SitDownError,changResult.err,null,null,null,null);
						}
						return true;
				}
				return SubGameSubCmd(wSubCmdID, pData);
			}
			return false;
		}
		//网络关闭消息
		public function OnSocketClose (pIClientSocket:IClientSocket, bCloseByServer:Boolean):Boolean {
			//游戏断开
			ShowMessageBox (MessageType.Gameclient,MessageType.Game_OffLine,null,null,null,null);
			SendEventExitGameClient ();
			return false;
		}
		public function ShowMessageBox(type:int,code:int,confirmfun:Function,confirmparam:Object,cancelfun:Function,cancelparam:Object):void{
			if(m_clientContainer){
				m_clientContainer.ShowMessage(type,code,confirmfun,confirmparam,cancelfun,cancelparam);
			}
		}
		//游戏命令
		protected function SubGameSubCmd (wSubCmdID:uint,pData:String):Boolean {
			return false;
		}
		//设置桌子密码
		public function SetPassword (tablePassword:String):Boolean {
			var setPwd:cmdMemberSetPassword = new cmdMemberSetPassword();
			setPwd.TableID = m_wTableID;
			setPwd.pwd = tablePassword;
			return SendData(GameForMember.SetPassword, setPwd.PushData());
		}
		/////////////////////////////////////////////////////
		//信息接口
		//房间属性
		public function GetServerAttribute ():cmdMemberTableInfo {
			return m_tableInfo;
		}
		//状态接口
		//游戏状态
		public function GetGameStatus ():uint {
			return m_bGameStatus;
		}
		//游戏状态
		public function SetGameStatus (bGameStatus:uint):void {
			m_bGameStatus = bGameStatus;
		}
		//用户接口
		//自己位置
		public function GetMeChairID ():uint {
			return m_wChairID;
		}
		//获取自己
		public function GetMeUserInfo ():cmdMemberInfo {
			return m_pMeUserItem;
		}
		//获取玩家
		public function GetUserInfo (wChairID:uint):cmdMemberInfo {
			return m_pUserItem[wChairID];
		}
		//激活游戏
		public function ActiveGameFrame ():void {
			if (m_clientContainer) {
				m_clientContainer.ActiveGameClass (this);
			}
			if (m_GameClientView) {
				m_GameClientView.ActiveGameView ();
			}
		}
		//增加用户;
		public function ActiveUserItem (pActiveUserData:cmdMemberInfo):Boolean {
			if (pActiveUserData) {
				if (pActiveUserData.Chair > m_wChairCount) {
					return false;
				}
				if (m_lookOn==false || pActiveUserData.memID!=m_dwUserID) {
					m_pUserItem[pActiveUserData.Chair - 1] = pActiveUserData;
				}
				//判断自己
				if (m_dwUserID == pActiveUserData.memID) {
					m_pMeUserItem = pActiveUserData;
					m_wChairID = pActiveUserData.Chair;
					m_GameClientView.ShowUserName (pActiveUserData.ShowName);
					m_GameClientView.ShowBalance (m_MoneyType,pActiveUserData.Balance);
					m_GameClientView.ShowQuotaMin (m_MinBet.toString());
					m_GameClientView.ShowQuotaMax (m_MaxBet.toString());
				}

				//通知改变
				OnEventUserEnter (pActiveUserData);
				return true;
			}
			return false;
		}
		//删除用户
		public function DeleteUserItem (dwUserID:uint):Boolean {
			//游戏用户
			var pUserData:cmdMemberInfo = null;
			for (var i:uint=0; i < m_wChairCount; i++) {
				pUserData = m_pUserItem[i];
				if (pUserData != null && pUserData.memID == dwUserID) {
					//通知改变
					OnEventUserLeft (pUserData);
					//设置变量
					m_pUserItem[i] = null;
					return true;
				}
			}
			return false;
		}
		//更新用户
		public function UpdateUserScore (dwUserID:uint):Boolean {
			return true;
		}
		//修改用户信息
		public function UpdateUserItem (dwUserID:uint,cbUserStatus:uint,wNetDelay:uint) {
			return true;
		}
		//查找用户
		public function SearchUserItem (dwUserID:uint):cmdMemberInfo {
			if (m_pUserItem) {
				var index:int = 0;
				while (index < m_pUserItem.length) {
					if (m_pUserItem[index]) {
						var memInfo:cmdMemberInfo = m_pUserItem[index] as cmdMemberInfo;
						if (memInfo && memInfo.memID == dwUserID) {
							return memInfo;
						}
					}
					index++;
				}
			}
			return null;
		}
		//设置桌子状态
		public function SetTableStatus (tableStatus:cmdMemberTableStatus):void {
			if (m_GameClientView) {
				m_GameClientView.ShowGameRoundNo (tableStatus.GameRoundNo);
				m_GameClientView.SetTableStatus (tableStatus.Status,tableStatus.DiffTime);
				m_GameClientView.ShowMemberCount (tableStatus.OnlineMembers);
			}
			if (tableStatus) {
				m_tableInfo.Status = tableStatus.Status;
				m_tableInfo.GameRoundNo = tableStatus.GameRoundNo;
				m_tableInfo.DiffTime = tableStatus.DiffTime;
				m_tableInfo.OnlineMembers = tableStatus.OnlineMembers;
				m_tableInfo.TotalCredit = tableStatus.TotalCredit;
				m_tableInfo.HostMember = tableStatus.HostMember;
				m_tableInfo.NeedPassword = tableStatus.NeedPassword;
				m_tableInfo.PrivateTable = tableStatus.PrivateTable;
			}

		}
		//设置桌子历史结果
		public function SetTableHisRoad (hisRoad:cmdMemberTableHisRoad):void {
			if (m_GameClientView) {
				m_GameClientView.SetTableHisRoad (hisRoad.HisRoad);
			}
		}
		//设置荷官;
		public function SetTableDealer (dealer:cmdMemberTableDealer):void {
			if (m_GameClientView) {
				m_GameClientView.ShowDealerName (dealer.Dealer);
			}
		}
		public function SetTablePositionBet (betPos:cmdMemberTablePositionBet):void {
			if (m_GameClientView) {
				m_GameClientView.SetTablePositionBet (betPos.PositionBet);
			}
		}
		public function SetTablePositionMembers (memPos:cmdMemberTablePositionMembers):void {
			if (m_GameClientView) {
				m_GameClientView.SetTablePositionMembers (memPos.PositionMembers);
			}
		}
		//用户进入;
		//m_GameClientView.SetNetSpeed(); //显示网络状态;
		protected function OnEventUserEnter (pUserData:cmdMemberInfo):void {
			if (pUserData.Chair == GetMeChairID()) {
				if (GetLookOn()==false) {
					m_GameClientView.SetUserInfo (pUserData.Chair, pUserData, true);
				}
			} else {
				endGame[pUserData.Chair] = false;
				m_GameClientView.SetUserInfo (pUserData.Chair, pUserData, false);
				m_GameClientView.ClearMemberChips (endGame);
			}
		}
		//用户离开
		protected function OnEventUserLeft (pUserData:cmdMemberInfo):void {
			if(pUserData == null || m_GameClientView == null) {
				return;
			}
			var own:Boolean = false;
			if (pUserData.memID == m_dwUserID) {
				own = true;
			}
			m_GameClientView.SetUserInfo (pUserData.Chair, null, own);
			m_GameClientView.ClearMemberChips (endGame);
			if(m_totalBet && m_totalBet[pUserData.Chair - 1]) {
				m_totalBet[pUserData.Chair - 1] = null;
			}
		}
		//投注位置;
		protected function OnMemberPositionTotalBet (totalBet:cmdMemberPositionTotalBet):Boolean {
			if (m_totalBet==null) {
				m_totalBet=new Array();
			}
			if (m_tableInfo.Status == 5 || m_tableInfo.Status == 6) {
				return false;
			}
			if (totalBet == null) {
				return false;
			}

			var BetList:Array = totalBet.TotalBet.split('|');
			var meTotalBet:Number = 0;
			m_totalBet[totalBet.Chair - 1] = BetList;
			var index:int = 0;
			while (index < BetList.length) {
				if (BetList[index] == "" || BetList[index] == "0") {
					index++;
					continue;
				}
				var money:Number = Number(BetList[index]);
				if (money <= 0) {
					index++;
					continue;
				}
				var betPosIndex:int = index + 1;

				meTotalBet +=  money;
				if (totalBet.memID == m_dwUserID) {
					if (m_BetTotalList == null) {
						m_BetTotalList = new Array();
					}
					if (m_BetTotalList[betPosIndex] == null) {
						m_BetTotalList[betPosIndex] = new Array();
					}

					m_BetTotalList[betPosIndex][0] = money;
					m_BetTotalList[betPosIndex][1] = 0;
				}
				if(m_isMoreTable || totalBet.memID == m_dwUserID){
					m_GameClientView.OnBetPosition (totalBet.Chair, betPosIndex, money);
				}
				
				index++;
			}
			if (totalBet.memID == m_dwUserID) {
				if (meTotalBet>0) {
					m_GameClientView.StopChangeChair ();
				}
				m_GameClientView.ShowQuotaMoney (meTotalBet);
				m_BetReturnCount++;
				BetReturnMessage ();
			}
			return true;
		}
		//会员下注结果;(投注成功不返回, 投注失败才处理)
		protected function OnBetPosition (wChairID:int, wBetPos:int, nBetValue:Number, betResult:int):void {
			if (wChairID == GetMeChairID() && betResult != 0) {
				if (m_BetTotalList == null) {
					m_BetTotalList = new Array();
				}
				if (m_BetTotalList[wBetPos] == null) {
					return;
				}
				var sBetTotal:Number = Number(m_BetTotalList[wBetPos][0]);

				m_BetTotalList[wBetPos][1] = 0;
				//显示筹码
				m_GameClientView.OnBetPosition (wChairID, wBetPos, sBetTotal);

				m_BetErrorList.push ([wBetPos, betResult]);
				m_BetReturnCount++;
				BetReturnMessage ();
			}
		}
		//下注返回消息(有代码没有实现)
		protected function BetReturnMessage ():void {
			if (m_BetCount == 0 || m_BetReturnCount < m_BetCount) {
				return;
			}
			m_BetCount = 0;
			m_BetReturnCount = 0;
			m_SubmitStatus = false;

			if (m_BetErrorList == null || m_BetErrorList.length == 0) {
				m_BetList = null;//投注成功，清空
				m_GameClientView.ShowBetMessage (MT_Bet_Sucess, null);
				m_GameClientView.StopChangeChair ();
				//播放投注成功;
				m_GameClientView.PlaySound (SoundConst.BetSuccess,null);
				return;
			}
			//有位置投注错误
			//显示提示框
			m_GameClientView.ShowBetMessage (MT_Bet_Fail, m_BetErrorList);
		}
		//会员输赢;
		protected function OnMemberPositionWinLose (totalWin:cmdMemberPositionWin):Boolean {
			if (totalWin == null) {
				return false;
			}
			if(m_totalWin == totalWin.TotalWin) {
				return true;
			}
			m_totalWin = totalWin.TotalWin;
			
			var WinList:Array = totalWin.TotalWin.split('|');
			var ownTotalWin:Number = 0;
			var betTotal:Number = 0;
			var total:Number = 0;
			var index:int = 0;
			while (index < WinList.length) {
				if (WinList[index] == "") {
					index++;
					continue;
				}
				var money:Number = Number(WinList[index]);
				//统计赢 (本金+赢)
				var betPosIndex:int = index + 1;
				if (totalWin.Chair == m_wChairID && m_BetTotalList[betPosIndex] && m_BetTotalList[betPosIndex].length > 0) {
					ownTotalWin +=  money + m_BetTotalList[betPosIndex][0];
					total +=  money;
					betTotal +=  m_BetTotalList[betPosIndex][0];
				}
				var chair=1;
				if(m_isMoreTable==false && totalWin.Chair != m_wChairID){
					index++;
					continue;
				}
				if(m_isMoreTable){
					chair=totalWin.Chair;
				}
				if (money > 0) {
					m_GameClientView.AddWinChips (chair, index + 1, money);
				} else if (money == 0) {
					m_GameClientView.AddDrawChips (chair, index + 1);
				} else {
					m_GameClientView.AddLoseChips (chair, index + 1);
				}
				index++;
			}
			if (totalWin.Chair == m_wChairID && betTotal != 0) {
				m_GameClientView.ShowMemberTotalWin (total,ownTotalWin);
			}
			return true;
		}
		//余额改变
		protected function OnEventBalanceChang (memBalance:cmdMemberBalance):void {
			if (memBalance) {
				if (m_lookOn) {
					m_GameClientView.ShowBalance (m_MoneyType,memBalance.Balance);
					m_pMeUserItem.Balance = memBalance.Balance;
				}
				var memInfo:cmdMemberInfo = SearchUserItem(memBalance.memID);
				if (memInfo) {
					if (m_lookOn==false) {
						m_GameClientView.BalanceChang (memInfo.Chair, memBalance.Balance);
					}
					if (GetMeChairID() == memInfo.Chair) {
						m_GameClientView.ShowBalance (m_MoneyType,memBalance.Balance);
						m_pMeUserItem.Balance = memBalance.Balance;
					}
				}

			}
		}
		protected function SetBetPosLimit ():void {
			if (betlimitByPos==null) {
				betlimitByPos = m_GameClientView.GetBetLimitByPos();
			}
			if (minbetlimitByPos==null) {
				minbetlimitByPos = m_GameClientView.GetMinBetLimitByPos();
			}
		}
		//会员下注
		public function OnBet (betPosIndex:int):Boolean {
			if (m_BetPosCount < betPosIndex) {
				return false;
			}
			if (m_BetTotalList == null) {
				m_BetTotalList = new Array();
			}
			if (m_BetList==null) {
				m_BetList=new Array();
			}
			SetBetPosLimit ();
			if (m_BetTotalList[betPosIndex] == null) {
				m_BetTotalList[betPosIndex] = new Array();
				m_BetTotalList[betPosIndex][0] = 0;
				m_BetTotalList[betPosIndex][1] = 0;
			}
			var sBetTotal:Number = Number(m_BetTotalList[betPosIndex][0]);
			var betTotal:Number = Number(m_BetTotalList[betPosIndex][1]);
			var index:int = 0;
			//还未确认投注总和
			var allbetTotal:Number = 0;
			for (index; index <= m_BetPosCount; index++) {
				if (m_BetTotalList && m_BetTotalList[index]) {
					allbetTotal +=  m_BetTotalList[index][1];
				}
			}
			//投注已经超出限额
			if (betTotal+sBetTotal>=betlimitByPos[betPosIndex]) {
				m_GameClientView.ShowBetMessage (MT_Bet_Over, [betPosIndex, 0]);
				return false;
			}
			//余额不足
			if(allbetTotal >= m_pMeUserItem.Balance ){
				m_GameClientView.ShowBetMessage (MT_Bet_Fail, [index, 4]);
				return false;
			}
			var betValue = m_SelectChip;//投注金额
			var minBet = minbetlimitByPos[betPosIndex] - betTotal - sBetTotal;
			var maxBet = betlimitByPos[betPosIndex] - betTotal - sBetTotal;
			//投注小于最小限额
			if(betValue < minBet) {
				betValue = minBet;
				m_GameClientView.ShowBetMessage (MT_Bet_Down, [betPosIndex, 0]);
			}
			//投注大于最大投注
			if(betValue > maxBet) {
				betValue = maxBet;
			}
			//信用额度比较
			if(betValue + allbetTotal > m_pMeUserItem.Balance) {
				betValue = m_pMeUserItem.Balance - allbetTotal;
			}
			
			if(betValue <= 0) {
				return false;
			}
			if(betValue < minBet){
				return false;
			}
			if(betValue > maxBet){
				return false;
			}
			m_BetList.push ([betPosIndex,betValue]);
			allbetTotal+=betValue;
			betTotal+=betValue;
			sBetTotal +=  betTotal;
			m_BetTotalList[betPosIndex][1] = betTotal;
			ShowChange(allbetTotal);
			//显示筹码
			m_GameClientView.OnBetPosition (GetMeChairID(), betPosIndex, sBetTotal);

			return true;
		}
		//取消下注筹码
		public function CancelBetChips ():void {
			m_BetList = null;//取消投注，清空
			var wChairID:int = GetMeChairID();
			var index:int = 0;
			if (m_BetTotalList) {
				while (index < m_BetTotalList.length) {
					if (m_BetTotalList[index] && m_BetTotalList[index][1]) {
						var betMoney:int = int(m_BetTotalList[index][1]);
						if (betMoney > 0) {
							var sBetTotal:Number = Number(m_BetTotalList[index][0]);
							m_BetTotalList[index][1] = 0;
							//显示筹码
							m_GameClientView.OnBetPosition (wChairID, index, sBetTotal);
						}
					}
					index++;
				}
			}
			ShowChange(0);
		}
		//撤消下注
		public function BackBetChips ():Boolean {
			if (m_BetList.length > 0) {
				var wChairID:int = GetMeChairID();
				var w_betPos:int = m_BetList[m_BetList.length - 1][0];//投注位置
				var betValue:int = m_BetList[m_BetList.length - 1][1];//投注金额
				if (m_BetTotalList[w_betPos][1] >= betValue) {
					m_BetTotalList[w_betPos][1] = m_BetTotalList[w_betPos][1] - betValue;
				}
				var index:int = 0;
				var allBetTotal:Number=0;
				while (index < m_BetTotalList.length) {
					if (m_BetTotalList[index] && m_BetTotalList[index][1] >= 0) {
						allBetTotal+=m_BetTotalList[index][1]
						var betMoney:int = int(m_BetTotalList[index][1]);
						var sBetTotal:Number = Number(m_BetTotalList[index][0] + betMoney);
						//显示筹码
						m_GameClientView.OnBetPosition (wChairID, index, sBetTotal);
					}
					index++;
				}
				m_BetList.pop ();
				ShowChange(allBetTotal);
			}
			if (m_BetList.length == 0) {
				return false;
			}
			return true;
		}
		public function SaveRepeatBetList ():void {
			//重复投注数据
			m_RepeatBetList = new Array();
			var index:int = 0;
			if (m_BetTotalList) {
				while (index < m_BetTotalList.length) {
					if (m_BetTotalList[index] && m_BetTotalList[index][0]) {
						var betMoney:int = int(m_BetTotalList[index][0]);
						if (betMoney > 0) {
							m_RepeatBetList[index] = betMoney;
						}
					}
					index++;
				}
			}
			//播放本局未投注
			if (m_BetTotalList==null || m_BetTotalList.length == 0) {
				m_GameClientView.PlaySound (SoundConst.NoBet,null);
			}
			if (m_RepeatBetList==null || m_RepeatBetList.length == 0) {
				m_GameClientView.IsReapetBet (false);
			} else {
				m_GameClientView.IsReapetBet (true);
			}
		}
		//重复上局下注
		public function RepeatBet ():void {
			if (m_BetList==null) {
				m_BetList=new Array();
			}
			if (m_RepeatBetList == null) {
				return;
			}
			var index:int = 0;
			var allBetTotal:Number=0;
			while (index < m_RepeatBetList.length) {
				if (m_RepeatBetList[index]) {
					allBetTotal+=m_RepeatBetList[index];
					var betMoney:int = int(m_RepeatBetList[index]);
					if (betMoney > 0) {
						if (m_BetTotalList == null) {
							m_BetTotalList = new Array();
						}
						if (m_BetTotalList[index] == null) {
							m_BetTotalList[index] = new Array();
							m_BetTotalList[index][0] = 0;
							m_BetTotalList[index][1] = 0;
						}
						m_BetTotalList[index][1] = betMoney;
						//显示筹码
						m_GameClientView.OnBetPosition (GetMeChairID(), index, betMoney);
						m_BetList.push ([index,betMoney]);
					}
				}
				index++;
			}
			ShowChange(allBetTotal);
			m_RepeatBetList = null;
		}
		/**
		 * 设置筹码选择 
		 * @chips 二维数组(1:被选择的5个筹码数组,2:当前选择筹码)
		 */
		public function SetMoreTableSelectChips (chips:Array):void {
			m_SelectChip = ChipMoney(chips[0][chips[1]]);
		}
		public function SetSelectChips (chips:Array):void {
			if (m_clientContainer) {
				m_clientContainer.SetSelectChips (chips);
				m_SelectChip = ChipMoney(chips[0][chips[1]]);
			}
		}
		//获取筹码选择
		public function GetSelectChips ():Array {
			var chipindex:int = 0;
			var index:int = 0;
			var len:int=const_Chip.length;
			for (index; index<len; index++) {
				if (m_MinBet<const_Chip[index]) {
					chipindex = index - 1;
					break;
				}
			}
			if (chipindex>5) {
				chipindex = 5;
			}
			var list:Array =new Array();
			var arr:Array=new Array();
			for (var ind:int=0; ind<5; ind++) {
				arr.push (chipindex);
				chipindex++;
			}
			list[0] = arr;
			list[1] = 2;
			if (list == null && list.length!=2) {
				m_SelectChip = ChipMoney(list[0]);
				return null;
			}
			m_SelectChip = ChipMoney(list[0][list[1]]);
			return list;
		}
		//设置视频线路
		public function SetVideoLine (index:int):void {
			if (m_clientContainer) {
				m_clientContainer.SetVideoLine (index);
			}
		}
		//获取视频线路;
		public function GetVideoLine ():int {
			if (m_clientContainer) {
				return m_clientContainer.GetVideoLine();
			}
			return 0;
		}
		public function GetVideoPlayUrl ():Array {
			var lineIndex:int = GetVideoLine();
			var url:String = "";
			if (m_tableInfo) {
				url = m_tableInfo.LiveVideo1;
				switch (lineIndex) {
					case 2 :
						url = m_tableInfo.LiveVideo2;
					case 3 :
						url = m_tableInfo.LiveVideo3;
					case 4 :
						url = m_tableInfo.LiveVideo4;
				}
				var param:Array = url.split('|');
				if (param.length == 2) {
					return param;
				}
			}
			return ["",""];
		}
		//播放赢动画
		protected function PlayWin (result:String):void {
			var list:Array = GetWinBetPosList(result);

			if (list) {
				m_GameClientView.PlayWin (list);
			}
		}
		//获取赢投注位置列表
		protected function GetWinBetPosList (result:String):Array {
			return null;
		}
		//投注结束(倒计时结束)
		public function BetOver ():void {
			m_GameClientView.SetBetStatus (false);
		}
		//路子;
		public function GetHistoryRoad (className:String):IHistoryResultManger {
			return m_clientContainer.GetHistoryRoad(className, true);
		}
		//筹码选择
		public function GetChipSelect (className:String):IChipSelect {
			return m_clientContainer.GetChipSelect(className);
		}
		public function GetFlipCard (className:String):IFlipCard {
			return m_clientContainer.GetFlipCard(className);
		}
		public function GetChipView(index:int):MovieClip {
			return m_clientContainer.GetChipView(index);
			
		}
		//显示注单
		public function ShowListBet ():void {
			if (m_clientContainer) {
				m_clientContainer.ShowStatement ();
			}
		}
		//从游戏传回大厅值;
		public function SetGameEffect (isMusic:Boolean,isSound:Boolean):void {
			if (m_clientContainer) {
				m_clientContainer.SetSoundSetting (isMusic, isSound);
			}
		}
		public function ReturnBack ():void {
			m_totalWin = "";
			if (m_totalBet==null) {
				return;
			}
			var index:int = 0;
			while (index < m_totalBet.length) {
				if (m_totalBet[index] == null) {
					index++;
					continue;
				}
				var posinde:int = 0;
				var len:int=m_totalBet[index].length;
				for (posinde; posinde<len; posinde++) {
					var chair:int = index + 1;
					var betPosIndex:int = posinde + 1;
					if (m_totalBet[index][posinde]) {
						var money:Number = m_totalBet[index][posinde];
						m_GameClientView.OnBetPosition (chair, betPosIndex, money);
					}
				}
				index++;
			}
		}
		public function GetLookOn ():Boolean {
			return m_lookOn;
		}
		//点击申请变更
		public function ChangeChair (chair:int):void {
			m_changeChairStatus = true;
			var m_changeChair:cmdMemberChangeChair=new cmdMemberChangeChair();
			m_changeChair.TableID = m_wTableID;
			m_changeChair.Chair = chair;
			SendData (GameForMember.ChangeChair,m_changeChair.PushData());
		}
		//变更椅子
		private function ChangeChairID (oldChairID:int, newChairID:int):void {
			if (oldChairID != 0) {
				endGame[oldChairID] = false;
				var userInfo:cmdMemberInfo = m_pUserItem[oldChairID - 1];
				if (userInfo) {
					DeleteUserItem (userInfo.memID);
					userInfo.Chair = newChairID;
					ActiveUserItem (userInfo);
				}
				m_GameClientView.ClearUserChips (oldChairID);
			}
			if (newChairID == m_wChairID) {
				var betPosIndex:int = 1;
				if (m_BetTotalList) {
					var len:int=m_BetTotalList.length;
					for (betPosIndex; betPosIndex<=len; betPosIndex++) {
						m_GameClientView.OnBetPosition (oldChairID, betPosIndex, 0);
					}
				}
				//播放坐下
				if (m_wChairCount > 1) {
					m_sound.SetChair (m_wChairID);
				}
				m_GameClientView.SetButtonEnabled(false);
				//清除未下注筹码;
				m_BetTotalList = null;
				//清除下注筹码
				m_BetList = null;
			}
			if (m_GameClientView && newChairID==m_wChairID) {
				m_GameClientView.ActiveGameView ();
				m_GameClientView.SetBetLimitByPos (m_betLimitForPos,m_MinBet);
			}
		}
		private function SetLimit (limitID:int):void {
			m_wBetLimitID = limitID;
			var limitList:Array = m_clientContainer.GetBetLimit(m_tableInfo.GameKind,m_wBetLimitID);
			m_MinBet = limitList[0];
			m_MaxBet = limitList[1];
			m_betLimitForPos = limitList;
		}
		public function OpenNotLook ():void {
			
		}
		//显示隐藏桌台列表
		public function ShowHideTableListPane(bool:Boolean):void{
			if(m_clientContainer){
				m_clientContainer.ShowHideTableListPane(bool);
			}
		}
		//投注，余额发生变化
		protected function ShowChange(allbetTotal:Number):void{
			var allBet:Number=0;
			var inde:int=0;
			for(inde;inde<=m_BetPosCount;inde++){
				if (m_BetTotalList && m_BetTotalList[inde]) {
					allBet+=(m_BetTotalList[inde][0]+m_BetTotalList[inde][1]);
				}
			}
			m_GameClientView.ShowQuotaMoney(allBet);
			m_GameClientView.ShowBalance(m_MoneyType,m_pMeUserItem.Balance-allbetTotal);
		}
	}
}
include "../../Net/NetModuleIDef.as"
include "../../Net/GLOBALDEF.as"
include "../../Net/GLOBALFRAME.as"
include "../../CommonModule/CHIPCONST.as"
include "GameMessage.as"