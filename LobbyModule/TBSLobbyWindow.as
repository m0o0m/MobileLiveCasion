package {
	import flash.display.Stage;
	import flash.display.StageDisplayState;
	import flash.display.Sprite;
	import flash.utils.Dictionary;
	import flash.events.Event;
	import flash.display.Graphics;
	import flash.events.MouseEvent;
	import flash.events.ProgressEvent;
	import flash.geom.Rectangle;
	import flash.display.MovieClip;
	import flash.geom.Point;
	import flash.net.LocalConnection;
	import flash.display.Loader;
	import flash.net.URLRequest;
	import flash.events.TransformGestureEvent;
	import flash.display.Shape;
	import flash.events.TouchEvent;
	import flash.ui.Multitouch;
	import flash.ui.MultitouchInputMode;
	import flash.system.Capabilities;

	import Common.*;
	import caurina.transitions.Tweener;
	import CommandProtocol.*;
	import Net.*;
	import IGameFrame.*;
	import ISWFModule.IModule;
	import LobbyModule.MessageBox.*;

	public class TBSLobbyWindow extends Sprite implements IMain,IClientSocketSink,IGameClassContainer,IChipViewPane {
		public var m_Version:String = "20131118001";
		protected var m_mainLoad:ILoad;
		public var m_LoadFolder:String;

		protected var m_CID:int;
		protected var m_UserID:int;
		protected var m_UserPassword:String;

		//限额信息
		protected var m_lcBetLimit:Dictionary;//限额参数
		protected var m_lcBetLimitByPos:Dictionary;//限额参数, 每一个投注位置
		protected var m_memBetLimit:Array;//会员投注限额编号

		//网络信息
		protected var m_clientSocket:ClientSocket;//Socket连接
		protected var m_ServerIP:String;//房间地址
		protected var m_ServerPort:uint;//房间端口
		//用户信息
		protected var m_userInfo:cmdMemberLoginToMember;
		protected var m_userBalance:cmdMemberBalance;
		protected var m_VipStatus:Boolean;//是否是VIP账号


		//桌子信息
		protected var m_tableList:Dictionary;//桌子列表
		protected var m_roomList:Dictionary;//房间列表
		protected var m_tableSort:Array;//桌子排序

		protected var m_CurrentShowRoomID:int;//当前显示房间
		protected var m_CurrentShowTableID:int;//当前进入桌子
		protected var m_CurrentBetLimitID:int;//当前进入限额
		protected var m_isHost:Boolean;//是否独享进入游戏
		protected var m_lookOn:Boolean;//是否旁观
		protected var m_tablePassword:String;//进入游戏密码

		protected var m_SelectChips:Array = [[0,1,2,3,4],1];//选择筹码; 二维数组(1:被选择的5个筹码数组,2: 当前选择筹码)
		protected var m_VideoLine:int;//视频线路
		
		protected var m_MoreContainer:MoreGameContainer;//多人桌模式
		protected var m_SelectTableID:Array = null;//多桌选择桌子列表

		//游戏信息
		protected var m_GameClass:IGameClass;

		//游戏加载
		protected var m_cLoader:ClassLoader;

		//房间信息
		protected var m_RoomInfo:Dictionary;

		protected var m_MoneyType:String;//货币类型

		protected var m_langList:Array;//需切换语言数组

		protected var m_Language:String = "ch";//语言,默认为中文
		protected var m_BgMusic:GameBgMusic;//背景音乐
		protected var m_isMusic:Boolean = false;//背景音乐是否播放，true播放
		protected var m_isSound:Boolean = true;//声音，true开启声音
		protected var m_messageBox:MessageBoxManager;//提示信息框

		protected var m_VipLimitType:int = 2;//VIP限额类型
		//房间按钮列表
		protected var roombtnList:Array;

		protected var m_limitpane:MovieClip;
		protected var m_BetLimit:BetLimitPane;

		protected var countPage:int = 0;//总页数
		protected var currentPage:int = 0;//当前页
		protected var room_width:Number=1400;
		protected var room_height:Number=940;
		protected var pageManager:PageButtonManager;
		
		protected var nativeOperationSystem:String;//区分操作系统
		public function TBSLobbyWindow () {
			
			nativeOperationSystem=Capabilities.os;
			nativeOperationSystem=nativeOperationSystem.toUpperCase();
			
			m_tableList = new Dictionary  ;
			m_roomList = new Dictionary  ;
			m_RoomInfo = new Dictionary  ;
			m_langList = new Array  ;
			//默认roomID=1;
			m_CurrentShowRoomID = 1;
			//Multitouch.inputMode=MultitouchInputMode.TOUCH_POINT;
			//旗舰厅;
			if (this.getChildByName("room1")) {
				this["room1"].SetSelectStatus (true);
				this["room1"].addEventListener (MouseEvent.CLICK,OnSwitch1);
				m_langList.push (this["room1"]);
			}
			//多台;
			if (this.getChildByName("room2")) {
				this["room2"].addEventListener (MouseEvent.CLICK,OnSwitch2);
				m_langList.push (this["room2"]);
			}

			//共眯厅
			if (this.getChildByName("room4")) {
				this["room4"].addEventListener (MouseEvent.CLICK,OnSwitch4);
				m_langList.push (this["room4"]);
			}
			if (this.getChildByName("mc_limitpane")) {
				m_limitpane = this["mc_limitpane"];
			}
			
			if(this.getChildByName("mc_back")){
				this["mc_back"].buttonMode=true;
				this["mc_back"].addEventListener(MouseEvent.CLICK,OnExit);
				if(nativeOperationSystem.indexOf("IPHONE")>=0){
					this["mc_back"].visible=false;
				}
			}

			roombtnList = [this["room1"],this["room2"],,this["room4"]];
			InitBgMusic ();

		}
		//大厅加载页面
		public function InitVisible (visible:Boolean):void {
			if (this.getChildByName("m_mcInit")) {
				this["m_mcInit"].visible = visible;
				if (visible) {
					this.setChildIndex (this["m_mcInit"],this.numChildren - 1);
				}
			}
		}
		public function SetParam (mainLoad:ILoad,param:Object):void {
			InitVisible (true);

			m_mainLoad = mainLoad;
			if (m_mainLoad) {
				m_Version = m_mainLoad.GetVersion();
			}
			//会员限额
			if ((m_memBetLimit == null)) {
				m_memBetLimit = new Array  ;
			}
			m_memBetLimit = param["userlimit"].split(';');
			//系统限额(所有限额内容)
			if ((m_lcBetLimit == null)) {
				m_lcBetLimit = new Dictionary  ;
			}
			if ((m_lcBetLimitByPos == null)) {
				m_lcBetLimitByPos = new Dictionary  ;
			}
			var index:int = 0;
			var ulimit:Array = param["systemlimit"].split(';');
			var ulen:int=ulimit.length;
			while ((index < ulen)) {
				var limit:Array = ulimit[index].split('#');
				if (limit.length == 3) {
					m_lcBetLimit[int(limit[0])] = limit[1].split('|');
					m_lcBetLimitByPos[int(limit[0])] = limit[2].split('|');
					var arr = m_lcBetLimitByPos[int(limit[0])] as Array;
					var ind = 0;
					var len:int=arr.length;
					for (ind; ind < len; ind++) {
						if (arr[ind] == "" || arr[ind] == null) {
							arr[ind] = m_lcBetLimit[int(limit[0])] as Array;
						} else {
							arr[ind] = arr[ind].split(",");
						}
					}
					m_lcBetLimitByPos[int(limit[0])] = arr;
				}
				index++;
			}
			m_CID = param["cid"];
			m_UserID = param["userid"];
			m_UserPassword = param["userpassword"];
			m_ServerIP = param["serverip"];
			m_ServerPort = param["serverport"];
			m_MoneyType = param["moneytype"];
			IChangLang (param["language"]);
			m_VipStatus = param["vipstatus"];
			LinkServer ();

			m_LoadFolder = m_mainLoad.GetLoadFolder();
		}
		//游戏获取限额
		public function GetBetLimit (gameKind:int,limitID:int):Array {
			var list:Array = m_lcBetLimitByPos[limitID];
			list = list[gameKind - 1];
			if ((list == null)) {
				return [0,0];
			}
			return list;
		}
		//销毁
		public function Destroy ():void {
			//旗舰厅;
			if (this.getChildByName("room1")) {
				this["room1"].removeEventListener (MouseEvent.CLICK,OnSwitch1);
			}
			//多台;
			if (this.getChildByName("room2")) {
				this["room2"].removeEventListener (MouseEvent.CLICK,OnSwitch2);
			}
			//共眯厅
			if (this.getChildByName("room4")) {
				this["room4"].removeEventListener (MouseEvent.CLICK,OnSwitch4);
			}
			if(this.getChildByName("mc_back")){
				this["mc_back"].removeEventListener(MouseEvent.CLICK,OnExit);
			}
			if (m_clientSocket) {
				m_clientSocket.CloseSocket (false);
				m_clientSocket = null;
			}
			if ((m_cLoader)) {
				m_cLoader.removeEventListener (ClassLoader.CLASS_LOADED,onLoaded);
				m_cLoader.removeEventListener (ClassLoader.LOAD_PROGRESS,onLoadProgress);
				m_cLoader=null;
			}
			if (m_BgMusic) {
				m_BgMusic.Destroy ();
				m_BgMusic = null;

			}
			if (m_messageBox) {
				m_messageBox.Destroy ();
				removeChild (m_messageBox);
				m_messageBox == null;
			}
			m_lcBetLimit = null;
			m_memBetLimit = null;
			m_userInfo = null;
			m_userBalance = null;
			m_tableList = null;

			if (m_GameClass) {
				var mc:MovieClip = m_GameClass.GetMovieClip();
				if (this.getChildIndex(mc) > 0) {
					removeChild (mc);
				}
				m_GameClass.DestroyGameClient ();
			}
			m_GameClass = null;

			while ((numChildren > 0)) {
				removeChildAt (0);
			}
			try {
				var lc:LocalConnection = new LocalConnection  ;
				lc.connect ("foo");
				lc.connect ("foo");
			} catch (error:Error) {

			}
		}
		//连接服务器
		public function LinkServer ():Boolean {
			m_clientSocket = new ClientSocket  ;
			m_clientSocket.SetSocketSink (this);
			return m_clientSocket.Connect(m_ServerIP,m_ServerPort);
		}
		//登录大厅
		public function Login ():Boolean {
			if (((m_clientSocket != null) && m_clientSocket.GetConnectState() == SocketState_Connected)) {
				var login:cmdMemberLoginToLobby = new cmdMemberLoginToLobby  ;
				login.MID = m_UserID;
				login.CID = m_CID;
				login.PWD = m_UserPassword;

				return m_clientSocket.SendData(MDM_LM_FRAME,LobbyForMember.Login,login.PushData());
			}
			return false;
		}
		//网络连接消息
		public function OnSocketConnect (iErrorCode:int,pszErrorDesc:String,pIClientSocket:IClientSocket):Boolean {
			trace ("网络连接消息");
			if (((m_clientSocket != null) && m_clientSocket.GetConnectState() == SocketState_Connected)) {
				trace ("连接成功");
				SocketConnected ();
				return Login();
			}
			return false;
		}
		//网络连接已经成功
		protected function SocketConnected ():void {
		}
		//登录成功
		protected function Logined ():void {
			ShowTopInfo ();
		}
		//用户信息更改
		protected function UserInfoChanged ():void {
			ShowTopInfo ();
		}
		protected function LoginError (errID:int):void {
		}
		//显示提示消息框
		public function ShowMessage (type:int,code:int,confirmfun:Function,confirmparam:Object,cancelfun:Function,cancelparam:Object):void {
			if (m_messageBox==null) {
				m_messageBox=new MessageBoxManager();
				addChild (m_messageBox);
			}
			m_messageBox.SetLang (m_Language);
			this.setChildIndex (m_messageBox,this.numChildren-1);
			m_messageBox.visible = true;
			m_messageBox.ShowMessageBox (type,code,confirmfun,confirmparam,cancelfun,cancelparam);
		}
		//网络读取消息
		public function OnSocketRead (wMainCmdID:uint,wSubCmdID:uint,pData:String,pIClientSocket:IClientSocket):Boolean {
			if ((wMainCmdID == MDM_LM_FRAME)) {
				switch (wSubCmdID) {
					case LobbyForMember.Login ://登录返回结果
						var member:cmdMemberLoginToMember = cmdMemberLoginToMember.FillData(pData);
						if ((member == null)) {
							trace (("member == null" + new Date  ));
							return false;
						}
						if (member.errID == 0) {
							//显示大厅;
							InitVisible (false);

							m_userInfo = member;
							Logined ();
						} else {
							LoginError (member.errID);
						}
						return true;
					case LobbyForMember.LogOut ://登出返回结果
						if (m_GameClass) {
							DestroyGameClass (m_GameClass);
						}
						if (m_clientSocket) {
							m_clientSocket.CloseSocket (false);
							m_clientSocket = null;
						}
						ShowMessage (MessageType.Gameclient, MessageType.Lobby_OtherLogin, Destroy, null, Destroy, null);
						return true;
					case LobbyForMember.Balance ://余额
						var balance:cmdMemberBalance = cmdMemberBalance.FillData(pData);
						if ((balance == null)) {
							return false;
						}
						if (balance.memID == m_userInfo.memID) {
							m_userBalance = balance;
							UserInfoChanged ();
							if (m_MoreContainer) {
								m_MoreContainer.ShowTopInfo (m_userInfo,m_userBalance);
							}
						}
						return true;
					case LobbyForMember.TableInfo ://桌子信息
						var table:cmdMemberTableInfo = cmdMemberTableInfo.FillData(pData);
						if ((table == null)) {
							return false;
						}
						if ((m_tableSort == null)) {
							m_tableSort = new Array  ;
						}
						if (m_tableSort.indexOf(table.TableID) == -1) {
							m_tableSort.push (table.TableID);
						}
						m_tableList[table.TableID] = table;
						return true;
					case LobbyForMember.TableStatus ://桌子状态
						var tableStatus:cmdMemberTableStatus = cmdMemberTableStatus.FillData(pData);
						return SetTableStatus(tableStatus);
					case LobbyForMember.TablePositionBet ://下注位置
						var betPos:cmdMemberTablePositionBet = cmdMemberTablePositionBet.FillData(pData);

						return SetTablePositionBet(betPos);
					case LobbyForMember.TablePositionMembers ://会员位置
						var memPos:cmdMemberTablePositionMembers = cmdMemberTablePositionMembers.FillData(pData);

						return SetTablePositionMembers(memPos);
					case LobbyForMember.HisRoad ://历史结果
						var hisRoad:cmdMemberTableHisRoad = cmdMemberTableHisRoad.FillData(pData);

						return SetTableHisRoad(hisRoad);
					case LobbyForMember.Dealer ://桌主
						var dealer:cmdMemberTableDealer = cmdMemberTableDealer.FillData(pData);
						if ((dealer == null)) {
							return false;
						}
						return SetTableDealer(dealer);
					case LobbyForMember.OnlineMembers ://在线会员
						return true;
					case LobbyForMember.SendTableEnd ://发送桌子结束
						ShowTable ();
						return true;
				}
			}
			return false;
		}
		//网络关闭消息
		public function OnSocketClose (pIClientSocket:IClientSocket,bCloseByServer:Boolean):Boolean {
			DestroyGameClass (m_GameClass);
			if (m_mainLoad) {
				ShowMessage (MessageType.Lobby_OffLine, 0, m_mainLoad.ResetLink, null, Destroy, null);
			}
			return false;
		}
		//显示游戏状态
		protected function SetTableStatus (tableStatus:cmdMemberTableStatus):Boolean {
			if ((tableStatus == null)) {
				return false;
			}
			if (((m_tableList == null) || m_tableList[tableStatus.TableID] == null)) {
				return false;
			}

			var table:cmdMemberTableInfo = m_tableList[tableStatus.TableID] as cmdMemberTableInfo;
			if ((table == null)) {
				return false;
			}
			table.Status = tableStatus.Status;
			table.GameRoundNo = tableStatus.GameRoundNo;
			table.DiffTime = tableStatus.DiffTime;
			table.OnlineMembers = tableStatus.OnlineMembers;
			table.TotalCredit = tableStatus.TotalCredit;
			table.HostMember = tableStatus.HostMember;
			table.NeedPassword = tableStatus.NeedPassword;
			table.PrivateTable = tableStatus.PrivateTable;

			m_tableList[tableStatus.TableID] = table;

			//通知游戏界面
			if ((m_CurrentShowTableID == tableStatus.TableID)) {
				if (m_GameClass) {
					m_GameClass.SetTableStatus (tableStatus);
				}
			}
			//通知多台
			if (m_MoreContainer) {
				m_MoreContainer.SetTableStatus (tableStatus);
			}
			var roomPane = m_roomList[table.RoomID] as RoomPane;
			if (roomPane) {
				roomPane.SetTableStatus (tableStatus);
			}
			return true;
		}
		//显示桌面投注
		protected function SetTablePositionBet (betPos:cmdMemberTablePositionBet):Boolean {
			if ((betPos == null)) {
				return false;
			}
			if (((m_tableList == null) || m_tableList[betPos.TableID] == null)) {
				return false;
			}

			var table:cmdMemberTableInfo = m_tableList[betPos.TableID] as cmdMemberTableInfo;
			if ((table == null)) {
				return false;
			}
			table.PositionTotalBet = betPos.PositionBet;

			if (((m_CurrentShowTableID == betPos.TableID) && m_GameClass)) {
				m_GameClass.SetTablePositionBet (betPos);
			}
			if (m_MoreContainer) {
				m_MoreContainer.SetTablePositionBet (betPos);
			}
			var roomPane = m_roomList[table.RoomID] as RoomPane;
			if (roomPane) {
				roomPane.SetTablePositionBet (betPos);
			}
			return true;
		}
		//显示桌面投注
		protected function SetTablePositionMembers (memPos:cmdMemberTablePositionMembers):Boolean {
			if ((memPos == null)) {
				return false;
			}
			if (((m_tableList == null) || m_tableList[memPos.TableID] == null)) {
				return false;
			}

			var table:cmdMemberTableInfo = m_tableList[memPos.TableID] as cmdMemberTableInfo;
			if ((table == null)) {
				return false;
			}
			table.PositionMembers = memPos.PositionMembers;

			if (((m_CurrentShowTableID == memPos.TableID) && m_GameClass)) {
				m_GameClass.SetTablePositionMembers (memPos);
			}
			if (m_MoreContainer) {
				m_MoreContainer.SetTablePositionMembers (memPos);
			}
			var roomPane = m_roomList[table.RoomID] as RoomPane;
			if (roomPane) {
				roomPane.SetTablePositionMembers (memPos);
			}
			return true;
		}
		//显示历史结果(路子)
		protected function SetTableHisRoad (hisRoad:cmdMemberTableHisRoad):Boolean {
			if ((hisRoad == null)) {
				return false;
			}
			if (((m_tableList == null) || m_tableList[hisRoad.TableID] == null)) {
				return false;
			}

			var table:cmdMemberTableInfo = m_tableList[hisRoad.TableID] as cmdMemberTableInfo;
			if ((table == null)) {
				return false;
			}
			table.HisRoad = hisRoad.HisRoad;

			//通知游戏界面
			if ((m_CurrentShowTableID == hisRoad.TableID)) {
				if (m_GameClass) {
					m_GameClass.SetTableHisRoad (hisRoad);
				}
			}
			if (m_MoreContainer) {
				m_MoreContainer.SetTableHisRoad (hisRoad);
			}
			var roomPane = m_roomList[table.RoomID] as RoomPane;
			if (roomPane) {
				roomPane.SetTableHisRoad (hisRoad);
			}
			return true;
		}
		//设置荷官
		protected function SetTableDealer (dealer:cmdMemberTableDealer):Boolean {
			if ((dealer == null)) {
				return false;
			}
			if (((m_tableList == null) || m_tableList[dealer.TableID] == null)) {
				return false;
			}

			var table:cmdMemberTableInfo = m_tableList[dealer.TableID] as cmdMemberTableInfo;
			if ((table == null)) {
				return false;
			}
			table.Dealer = dealer.Dealer;

			//通知游戏界面
			if ((m_CurrentShowTableID == dealer.TableID)) {
				if (m_GameClass) {
					m_GameClass.SetTableDealer (dealer);
				}
			}
			var roomPane = m_roomList[table.RoomID] as RoomPane;
			if (roomPane) {
				roomPane.SetTableDealer (dealer);
			}
			return true;
		}
		//发送桌子结束,显示桌子
		protected function ShowTable ():void {
			for each (var key in m_tableSort) {
				var table:cmdMemberTableInfo = m_tableList[key];
				if (table) {
					if (table.RoomID == 1) {
						if ((m_SelectTableID == null)) {
							m_SelectTableID = new Array  ;
						}
						if (m_SelectTableID.length < 4) {
							m_SelectTableID.push (table.TableID);
						}
					}
					var roomPane:RoomPane = null;
					if (m_roomList[table.RoomID]) {
						//测试滑动
						roomPane = m_roomList[table.RoomID] as RoomPane;
					} else {
						roomPane = new RoomPane  ;
						roomPane.SetLobbyWindow (this);

						m_roomList[table.RoomID] = roomPane;


						if (table.RoomID == m_CurrentShowRoomID) {
							addChild (roomPane);
							roomPane.x = 214;
							roomPane.y = 145;
						}
					}
					roomPane.IChangLang (m_Language);
					roomPane.SetVipStatus (m_VipStatus);
					m_langList.push (roomPane);
					roomPane.SetMoneyType (m_MoneyType);
					roomPane.AddTable (table);

					var limitList:Array = SetLimitArray(table.LimitType,table);
					roomPane.SetBetLimit (table.TableID,limitList);
				}
			}
			countPage = m_roomList[m_CurrentShowRoomID].GetPageCount();
			currentPage = 0;
			AddPageButton(countPage);
			for (key in m_roomList) {
				if (m_roomList[key]) {
					roomPane = m_roomList[key] as RoomPane;
					roomPane.ShowTable ();
					AssembleRommPane(roomPane,roomPane.width,roomPane.height);
				}
			}
		}
		//分析限额数据
		protected function SetLimitArray (limittype:int,table:cmdMemberTableInfo):Array {
			var index:int = 0;
			var limitList:Array = new Array  ;
			if ((((m_memBetLimit == null) || limittype <= 0) || limittype > m_memBetLimit.length)) {
				return limitList;
			}
			var limit:Array = m_memBetLimit[limittype - 1].split("|");
			if ((limit && limit.length > 0)) {
				while ((index < limit.length)) {
					var limitID:int = limit[index];
					var arr:Array = m_lcBetLimitByPos[limitID] as Array;
					if ((arr && table.GameKind <= arr.length)) {
						var list:Array = arr[table.GameKind - 1];
						if (list) {
							limitList.push ([limitID,list.join("-")]);
							var i:int = limitList.length - 1 
							for (i; i > 0; i--) {
								for (var j:int = 0; j < i; j++) {
									if (limitList[j][1] == limitList[i][1]) {
										limitList.pop ();
									}
								}
							}
						}
					}
					index++;
				}
			}
			return limitList;
		}
		//获取桌子信息
		public function GetMemberTableInfo (tableID:int):cmdMemberTableInfo {
			if (m_tableList) {
				return m_tableList[tableID] as cmdMemberTableInfo;
			}
			return null;
		}
		public function GetTableList ():Dictionary {
			return m_tableList;
		}
		//保存多台选择;
		public function SaveSelectTableID (tableList:Array):void {
			if ((m_SelectTableID == null)) {
				m_SelectTableID = new Array  ;
			}
			var index:int = 0;
			while ((index < tableList.length)) {
				m_SelectTableID[index] = tableList[index++];
			}
		}
		//显示限额
		public function ShowLimitPane (limit:Array,tableID:uint,host:Boolean,more:Boolean,lookon:Boolean,moneyType:String):void {
			if (m_limitpane) {
				m_limitpane.visible = true;
				m_limitpane["limit_back"].buttonMode=true;
				m_limitpane["limit_back"].addEventListener(MouseEvent.CLICK,ExitLimit);
				this.setChildIndex (m_limitpane,this.numChildren-1);
			}
			if (m_BetLimit) {
				m_BetLimit.Destroy ();
				m_limitpane.removeChild (m_BetLimit);
				m_BetLimit = null;
			}
			if (m_BetLimit==null) {
				m_BetLimit=new BetLimitPane();
				m_limitpane.addChild (m_BetLimit);
			}
			m_BetLimit.SetMoneyType (moneyType);
			m_BetLimit.SetBetLimit (limit);
			m_BetLimit.SetParmar (this,tableID,host,more,lookon);
		}
		//进入游戏
		public function EnterGame (limitID:int,tableID:uint,host:Boolean,moreEnter:Boolean,lookon:Boolean):Boolean {
			if (m_limitpane) {
				m_limitpane.visible = false;
			}
			if (((m_CurrentShowTableID > 0) && m_GameClass != null)) {
				DestroyGameClass (m_GameClass);
			}

			m_CurrentShowTableID = tableID;
			m_CurrentBetLimitID = limitID;
			m_isHost = host;
			m_lookOn = lookon;
			if (m_tableList[tableID] != null) {
				var table:cmdMemberTableInfo = m_tableList[tableID] as cmdMemberTableInfo;
				m_roomList[table.RoomID].SetEnterTableID (table.TableID);
				if ((table != null)) {
					LoadGameModule (null);
				}
			}
			return true;
		}
		protected function LoadGameModule (tablePassword:String):Boolean {
			m_tablePassword = tablePassword;
			var table:cmdMemberTableInfo = null;
			if (m_tableList[m_CurrentShowTableID] != null) {
				table = m_tableList[m_CurrentShowTableID] as cmdMemberTableInfo;
			}
			if ((table == null)) {
				return false;
			}
			if ((m_cLoader == null)) {
				m_cLoader = new ClassLoader  ;
				m_cLoader.m_Version = m_Version;
				m_cLoader.addEventListener (ClassLoader.CLASS_LOADED,onLoaded);
				m_cLoader.addEventListener (ClassLoader.LOAD_PROGRESS,onLoadProgress);
			}
			if (this.getChildByName("lodMc")) {
				this["lodMc"]["lod0"]["lod"].scaleX = 0;
				this["lodMc"].visible = true;
				this["lodMc"]["lod0"].visible = true;
				this["lodMc"]["m_connect"].visible = false;
				this.setChildIndex (this["lodMc"],this.numChildren - 1);
			}

			m_cLoader.load (GetLoadGameUrl());
			return true;
		}
		protected function GetLoadGameUrl ():String {
			var table:cmdMemberTableInfo = null;
			if (m_tableList[m_CurrentShowTableID] != null) {
				table = m_tableList[m_CurrentShowTableID] as cmdMemberTableInfo;
			}
			if ((table == null)) {
				return "";
			}

			var gameModule:String = "BaccModuleByNomal.swf";
			switch (table.GameKind) {
				case 1 :
				case 9 :
					gameModule = "BaccModuleByNomal.swf";
					break;
				case 2 :
					gameModule = "RouletteModule.swf";
					break;
				case 4 :
					gameModule = "DragonTigerModule.swf";
					break;
				case 6 :
					gameModule = "BaccModuleByInsurance.swf";
					break;
				case 8 :
					gameModule = "BaccModuleByVip.swf";
					break;
			}
			return m_LoadFolder + gameModule;
		}
		//加载成功,初始化游戏
		protected function InitGameClass ():void {
			if ((m_GameClass != null)) {
				var table:cmdMemberTableInfo = m_tableList[m_CurrentShowTableID] as cmdMemberTableInfo;
				if ((table != null)) {
					var param:Object = {limitid:m_CurrentBetLimitID,ishost:m_isHost,tablepwd:m_tablePassword,moneytype:m_MoneyType,language:m_Language,lookon:m_lookOn};
					m_GameClass.CreateGameClient (this,table,param);
				}
			}
		}
		//活动显示游戏端
		public function ActiveGameClass (game:IGameClass):void {
			if ((game == null)) {
				return;
			}
			if ((m_GameClass && m_GameClass != game)) {
				m_GameClass.SendEventExitGameClient ();
				removeChild (m_GameClass.GetMovieClip());
				m_GameClass.DestroyGameClient ();
				m_GameClass = null;
				m_GameClass = game;
			}
			m_GameClass = game;
			m_GameClass.SetActiveStatus (true);

			if (m_GameClass) {
				var nc:MovieClip = m_GameClass.GetMovieClip();
				addChild (nc);
			}
			if ((m_GameClass && m_GameClass.GetActiveStatus())) {
				if (this.getChildByName("lodMc")) {
					this["lodMc"].visible = false;
				}
			}
		}
		//销毁游戏端
		public function DestroyGameClass (game:IGameClass):void {
			if ((game == null)) {
				return;
			}
			m_CurrentShowTableID = 0;
			if ((m_GameClass == game)) {
				if (m_GameClass.GetActiveStatus()) {
					removeChild (m_GameClass.GetMovieClip());
				}
				m_GameClass.DestroyGameClient ();
				m_GameClass = null;
			}
		}
		//获取会员编号
		public function GetMeUserID ():uint {
			if ((m_userInfo == null)) {
				return 0;
			}
			return m_userInfo.memID;
		}

		//获取会员密码
		public function GetMePassword ():String {
			if ((m_userInfo == null)) {
				return "";
			}
			return m_userInfo.LoginCode;
		}
		/**
		 * 设置筹码选择 
		 * @chips 二维数组(1:被选择的5个筹码数组,2:当前选择筹码)
		 */
		public function SetSelectChips (chips:Array):void {
			m_SelectChips = chips;
		}
		//获取筹码选择
		public function GetSelectChips ():Array {
			return m_SelectChips;
		}
		//设置视频线路
		public function SetVideoLine (index:int):void {
			m_VideoLine = index;
		}
		//获取视频线路
		public function GetVideoLine ():int {
			return m_VideoLine;
		}
		//获取路子
		public function GetHistoryRoad (className:String,gameRoad:Boolean=false):IHistoryResultManger {
			return m_mainLoad.GetHistoryRoad(className,gameRoad);
		}
		//获取筹码选择
		public function GetChipSelect (className:String):IChipSelect {
			return m_mainLoad.GetChipSelect(className);
		}
		//获取眯牌
		public function GetFlipCard (className:String):IFlipCard {
			return m_mainLoad.GetFlipCard(className);
		}
		//获取筹码(显示投注用)
		public function GetChipView (index:int):MovieClip {
			return m_mainLoad.GetChipView(index);
		}
		protected function Logout ():void {
			if (m_clientSocket) {
				m_clientSocket.CloseSocket (false);
				m_clientSocket = null;
			}
			//openWindow.open ("Logout.aspx","_self");
		}
		//添加背景音乐
		public function InitBgMusic ():void {
			m_BgMusic=new GameBgMusic();
			m_BgMusic.GetVolume (m_isSound);
		}
		//将值传给游戏;
		public function GetSoundSetting ():Array {
			return [m_isMusic, m_isSound];
		}
		//从游戏传回值
		public function SetSoundSetting (isMusic:Boolean, isSound:Boolean):void {
			if (isMusic!=m_isMusic) {
				m_BgMusic.PlayBgMusic (isMusic);
				//this["m_topMenu"]["m_btnMusic"].SetSelectStatus (isMusic);
			}
			if (isSound!=m_isSound) {
				m_BgMusic.GetVolume (isSound);
				//this["m_topMenu"]["m_btnSound"].SetSelectStatus (isSound);
			}
			m_isMusic = isMusic;
			m_isSound = isSound;
		}
		//改变声音
		public function UpdateSound (e:MouseEvent):void {
			if (m_isSound) {
				m_isSound = false;
			} else {
				m_isSound = true;
			}
			m_BgMusic.GetVolume (m_isSound);//背景音乐获取声音
			//this["m_topMenu"]["m_btnSound"].SetSelectStatus (m_isSound);
		}
		//改变背景音乐;
		public function UpdateBgMusic (e:MouseEvent):void {
			if (m_isMusic) {
				m_isMusic = false;
			} else {
				m_isMusic = true;
			}
			m_BgMusic.PlayBgMusic (m_isMusic);
			//this["m_topMenu"]["m_btnMusic"].SetSelectStatus (m_isMusic);
		}
		public function IChangLang (strLang:String):void {
			if ((strLang == m_Language)) {
				return;
			}
			if (strLang) {
				m_Language = strLang;
				if (m_langList) {
					var index:int = 0;
					var len:int= m_langList.length
					for (index; index <len; index++) {
						if (m_langList[index]) {
							m_langList[index].IChangLang (strLang);
						}
					}
				}
			}
		}

		public function ShowHideTableListPane (bool:Boolean):void {
			return;
		}
		//普通厅
		private function OnSwitch1 (event:MouseEvent):void {
			if ((m_CurrentShowRoomID == 1)) {
				return;
			}
			ChangeRoom (1);
			SwitchRoom (1);
		}
		//多台
		private function OnSwitch2 (event:MouseEvent):void {
			if (m_MoreContainer == null) {
				m_MoreContainer = new MoreGameContainer();
				addChild (m_MoreContainer);
				m_MoreContainer.SetLang (m_Language);
				m_MoreContainer.SetLobbyWindow (this);
				m_MoreContainer.InitContainer (m_SelectTableID);
				m_MoreContainer.SetLimitId (m_memBetLimit);
				m_MoreContainer.SetMoneyType (m_MoneyType);
				m_MoreContainer.ShowTopInfo (m_userInfo,m_userBalance);
			
			}
		}
		//共眯厅
		private function OnSwitch4 (event:MouseEvent):void {
			if ((m_CurrentShowRoomID == 4)) {
				return;
			}
			ChangeRoom (4);
			SwitchRoom (4);
		}
		//切换房间按钮显示
		protected function ChangeRoom (room:int):void {
			var len:int= roombtnList.length;
			for (var index:int = 0; index < len; index++) {
				if (roombtnList[index]) {
					roombtnList[index].SetSelectStatus (false);
				}
			}
			roombtnList[room - 1].SetSelectStatus (true);
		}
		//切换房间;
		function SwitchRoom (roomID:int):void {
			if (((((m_roomList == null) || roomID < 0) || roomID > m_roomList.length) || m_CurrentShowRoomID == roomID)) {
				return;
			}
			var roomPane:RoomPane=null;
			if(m_roomList[m_CurrentShowRoomID]){
				roomPane = m_roomList[m_CurrentShowRoomID] as RoomPane;
				if(roomPane.hasEventListener(TransformGestureEvent.GESTURE_SWIPE)){
					roomPane.removeEventListener(TransformGestureEvent.GESTURE_SWIPE ,SweepSprite);
				}
				roomPane.parent.removeChild (roomPane);
			}
			if( m_roomList[roomID]){
				roomPane = m_roomList[roomID] as RoomPane;
				this.addChild (roomPane);
				roomPane.x = 214;
				roomPane.y = 145;
				AssembleRommPane(roomPane,roomPane.width,roomPane.height);
			}
			m_CurrentShowRoomID = roomID;
			countPage = m_roomList[m_CurrentShowRoomID].GetPageCount();
			currentPage = 0;
			AddPageButton(countPage);
		}
		public function onLoaded (event:Event):void {
			m_GameClass = m_cLoader.newDefaultIGameClass();
			InitGameClass ();
		}
		public function onLoadProgress (event:ProgressEvent):void {
			var loaded:Number = event.bytesLoaded / event.bytesTotal;
			if ((loaded < 1)) {
				if (this.getChildByName("lodMc")) {
					this["lodMc"]["lod0"]["lod"].scaleX = loaded;
				}
			}
			if ((loaded == 1)) {
				if (this.getChildByName("lodMc")) {
					this["lodMc"]["lod0"].visible = false;
					this["lodMc"]["m_connect"].visible = true;
					this["lodMc"]["m_connect"].gotoAndStop (m_Language);
				}
			}
		}
		//大厅左上角显示会员信息;
		private function ShowTopInfo ():void {
			if (m_userInfo) {
				this["m_topMenu"]["m_UserName"].text = m_userInfo.ShowName;
				if (m_limitpane) {
					m_limitpane["m_topMenu"]["m_UserName"].text = m_userInfo.ShowName;
				}
			}
			if (m_userBalance) {
				this["m_topMenu"]["m_UserBal"].text = m_MoneyType + "  " + NumberFormat.BalanceFormat(m_userBalance.Balance);
				if (m_limitpane) {
					m_limitpane["m_topMenu"]["m_UserBal"].text = m_MoneyType + "  " + NumberFormat.BalanceFormat(m_userBalance.Balance);
				}
			} else {
				this["m_topMenu"]["m_UserBal"].text = m_MoneyType + "  0";
				if (m_limitpane) {
					m_limitpane["m_topMenu"]["m_UserBal"].text = m_MoneyType + "  0";
				}
			}
		}
		//显示注单
		public function ShowStatement ():void {
		}
		//获取VIP限额编号
		public function GetVipLimitID (limitType:int):int {
			return 0;
		}
		protected function DrawRoomPaneShape (_x:Number,_y:Number,s_width:Number,s_height:Number):Shape {
			var shape:Shape=new Shape();
			shape.graphics.beginFill (0xcccccc);
			shape.graphics.drawRoundRect (_x, _y, s_width, s_height, 0);
			shape.graphics.endFill ();
			shape.alpha = 0;
			return shape;
		}
		protected function AssembleRommPane (roomPane:RoomPane,_width:Number,_height:Number):void {
			var _shape:Shape = DrawRoomPaneShape(0,0,_width,room_height);
			var _mask:Shape = DrawRoomPaneShape(215,116,room_width,room_height);
			roomPane.mask = _mask;
			roomPane.addChild (_shape);
			roomPane.addEventListener(TransformGestureEvent.GESTURE_SWIPE ,SweepSprite);
		}
		//滑动大厅
		protected function SweepSprite(e:TransformGestureEvent):void{
			var roomPane:RoomPane=e.target as RoomPane;
			if(e.offsetX==-1){
				trace("向左滑动");
				if(currentPage<(countPage-1)){
					Tweener.addTween(roomPane,{x: roomPane.x+room_width,time: 2})
					currentPage++;
				}
			}
			if(e.offsetX==1){
				trace("向右滑动");
				if(currentPage>0){
					Tweener.addTween(roomPane,{x: roomPane.x-room_width,time: 2})
					currentPage--;
				}
			}
		}
		//添加页面显示
		protected function AddPageButton(pagecount:int):void{
			if(pageManager){
				pageManager.ClearButton();
				removeChild(pageManager);
				pageManager=null;
			}
			if(pageManager==null){
				pageManager=new PageButtonManager(pagecount);
				addChild(pageManager);
				pageManager.x=(1678-pageManager.width)/2;
				pageManager.y=1032;
			}
		}
		//退回到登錄界面
		protected function OnExit(e:MouseEvent):void{
			ShowMessage (MessageType.Gameclient,MessageType.Lobby_ExitGame,ExitApp,null,null,null);
		}
		//退出限額選擇
		protected function ExitLimit(e:MouseEvent):void{
			if (m_limitpane) {
				m_limitpane.visible = false;
				m_limitpane["limit_back"].removeEventListener(MouseEvent.CLICK,ExitLimit);
			}
			if (m_BetLimit) {
				m_BetLimit.Destroy ();
				m_limitpane.removeChild (m_BetLimit);
				m_BetLimit = null;
			}
		}
		//销毁多台
		 public function DestroyMoreGame ():void {
			if (m_MoreContainer) {
				m_MoreContainer.Destroy ();
				removeChild (m_MoreContainer);
				m_MoreContainer = null;
			}
			//默认多台退出显示普通厅;
			ChangeRoom (1);
			SwitchRoom (1);
		}
		//移动设备返回按键
		public function GoBack():void{
			//trace("退出")
			if(m_MoreContainer){
				DestroyMoreGame();
				//trace("退出多台")
			}
			else if(m_GameClass){
				DestroyGameClass(m_GameClass);
				//trace("退出游戏")
			}
			else if(m_limitpane.visible==true){
				m_limitpane.visible=false;
				//trace("退出筹码")
			}
			else if(this["lodMc"].visible==true){
				this["lodMc"].visible=false;
				//trace("退出游戏加载")
			}
			else{
				ShowMessage (MessageType.Gameclient,MessageType.Lobby_ExitGame,ExitApp,null,null,null);
				//trace("退回登陆")
			}
		}
		public function ExitApp():void{
			if(m_mainLoad){
				m_mainLoad.ExitApp();
			}
		}
	}
}
include "../Net/NetModuleIDef.as"
include "../Net/GLOBALDEF.as"
include "../Net/GLOBALFRAME.as"
include "./LobbyText.as"