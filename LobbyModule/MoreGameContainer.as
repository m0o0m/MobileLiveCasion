package {
	import flash.display.Sprite;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.utils.Dictionary;
	import flash.display.Stage;
	import flash.display.StageDisplayState;
	import flash.display.Graphics;
	import flash.geom.Point;
	import flash.events.MouseEvent;
	import flash.events.TransformGestureEvent;
	import flash.display.Shape;
	

	import CommandProtocol.*;
	import IGameFrame.*;
	import Common.*;
	import LobbyModule.Button.*;
	import caurina.transitions.Tweener;

	public class MoreGameContainer extends Sprite implements IGameClassContainer,IChipPane {
		public var m_LobbyWindow:TBSLobbyWindow;//大厅
		public var m_TableIDList:Array = null;
		public var m_GameClassList:Array = null;
		//加载
		protected var m_cLoader:ClassLoader;
		protected var m_LoadStatus:Boolean = false;//加载状态
		protected var m_LoaderIDList:Array;//需要加载的桌子ID
		//播放器

		protected var m_roomPane:MoreGameRoomPane;//存放未选择桌子列表
		protected var roompanePoint:Point = new Point(1800,188);

		protected var moveDistance:int = 438;//点击上下键桌子列表移动位置

		protected var m_memBetLimit:Array;//会员投注限额编号
		protected var loadSwfPoint:Array = [new Point(205,105),new Point(205,348),new Point(205,593),new Point(205,836)];
		protected var m_ChipSelectManager:IChipSelect;//筹码选择

		protected var loadCycle:Array;//加载旋转
		//protected var enterGame:Array;//进入游戏
		//protected var btnvideo:Array;//切换视频

		protected var mc_mask:Sprite = null;//roompane遮罩层

		//protected var m_btnUp:BuutonUp;
		//protected var m_btnDown:BuutonDown;
		protected var countBtn:int;//设置无法显示桌子，可显示7个
		protected var movedistance:int = 365;//移动高度

		protected var m_isMusic:Boolean;//是否播放背景音乐
		protected var m_isSound:Boolean;//是否有声音

		protected var m_MoneyType:String;//货币类型；
		//protected var currentVideo:int;//当前视频线路

		protected var lang:String;//当前语言
		
		protected var m_showchipbtn:MovieClip;//显示筹码按钮
		protected var m_hidechipbtn:MovieClip;//隐藏筹码按钮
		public function MoreGameContainer () {
			m_LoaderIDList = new Array();
			m_TableIDList = new Array();
			m_roomPane=new MoreGameRoomPane();
			m_roomPane.x = roompanePoint.x;
			m_roomPane.y = roompanePoint.y;
			m_roomPane.SetMoreGameContainer (this);
			addChild (m_roomPane);
			AssembleRommPane();
			mc_mask = RoomPaneMask(roompanePoint.x,roompanePoint.y,135,975);
			addChild (mc_mask);
			m_roomPane.mask = mc_mask;
			//退出;
			this["m_btnExit"].addEventListener (MouseEvent.CLICK, ExitMoreGame);
			loadCycle = [this["loadOne"],this["loadTwo"],this["loadThree"],this["loadFour"]];
			if(this.getChildByName("mc_showchip")){
				m_showchipbtn=this["mc_showchip"];
				m_showchipbtn.visible=true;
				m_showchipbtn.buttonMode=true;
				m_showchipbtn.addEventListener(MouseEvent.CLICK,ShowChipSetting);
			}
			if(this.getChildByName("mc_hidechip")){
				m_hidechipbtn=this["mc_hidechip"];
				m_hidechipbtn.visible=false;
				m_hidechipbtn.buttonMode=true;
				m_hidechipbtn.addEventListener(MouseEvent.CLICK,HideChipSetting)
			}
			/*if (this.getChildByName("btnUp")) {
				m_btnUp = this["btnUp"];
			}
			if (this.getChildByName("btnDown")) {
				m_btnDown = this["btnDown"];
			}*/
		}
		//设置大厅
		public function SetLobbyWindow (lw:TBSLobbyWindow):void {
			m_LobbyWindow = lw;
			m_roomPane.SetLobbyWindow (m_LobbyWindow);
		}
		/**
		 * 设置默认桌子
		 */
		public function InitContainer (tableList:Array):void {
			if (tableList == null || tableList.length <= 0) {
				return;
			}
			var index:int = 0;
			while (index < tableList.length) {
				m_LoaderIDList.push (tableList[index]);
				m_TableIDList[index] = tableList[index++];
			}
			countBtn = tableList.length - 7;
			//加载游戏
			LoadGameClass ();
			//显示未选中桌子列表
			ShowTableListByNotSelect ();
			//加载筹码
			InitChipSelectManager ();
			//上下按钮
			InitBtnUpDown (countBtn);
			//默认播放视频0
			//SwitchVideo (0);
		}
		/**
		 * 播放视频
		 * @游戏位置(0,1,2,3)
		 */
		public function PlayVideo (gameIndex:int):void {
			/*if (gameIndex < 0 || m_LobbyWindow == null || 
			   m_TableIDList == null || m_TableIDList.length <= gameIndex || m_TableIDList[gameIndex] == null) {
				return;
			}
			var table:cmdMemberTableInfo = m_LobbyWindow.GetMemberTableInfo(int(m_TableIDList[gameIndex]));
			if (table == null) {
				return;
			}*/
		}
		public function GetVideoPlayUrl (table:cmdMemberTableInfo):Array {
			/*var lineIndex:int = GetVideoLine();
			var url:String = "";
			if (table) {
				url = table.LiveVideo1;
				switch (lineIndex) {
					case 2 :
						url = table.LiveVideo2;
					case 3 :
						url = table.LiveVideo3;
					case 4 :
						url = table.LiveVideo4;
				}
				var param:Array = url.split('|');
				if (param.length == 2) {
					return param;
				}
			}*/
			return ["",""];
		}
		private function onVideoLoaded (event:Event):void {
			//this["m_videoLoad"].visible = false;
		}
		private function onLoadResume (event:Event):void {
			//this["m_videoLoad"].visible = true;
		}
		//销毁
		public function Destroy ():void {
			//销毁已经加载游戏
			if (m_GameClassList && m_GameClassList.length > 0) {
				var index:int = 0;
				while (index < m_GameClassList.length) {
					DestroyGameClassByID (index);
					index++;
				}
			}
			if (m_cLoader) {
				m_cLoader.removeEventListener (ClassLoader.CLASS_LOADED, onLoaded);
				m_cLoader.removeEventListener (ClassLoader.LOAD_PROGRESS, onLoadProgress);
			}
			m_cLoader = null;

			if (m_roomPane) {
				m_roomPane.Destroy ();
				if(m_roomPane.hasEventListener(TransformGestureEvent.GESTURE_SWIPE)){
					m_roomPane.removeEventListener(TransformGestureEvent.GESTURE_SWIPE ,SweepSprite);
				}
				removeChild (m_roomPane);
				m_roomPane = null;
			}
			if (m_ChipSelectManager) {
				var mc:MovieClip = m_ChipSelectManager.GetMovieClip();
				removeChild (mc);
				m_ChipSelectManager.Destroy ();
				m_ChipSelectManager = null;
			}
			if (mc_mask!=null) {
				removeChild (mc_mask);
				mc_mask = null;
			}
			if(m_showchipbtn){
				if (m_showchipbtn.hasEventListener(MouseEvent.CLICK)) {
					m_showchipbtn.removeEventListener(MouseEvent.CLICK,ShowChipSetting);
				}
				m_showchipbtn=null;
			}
			if(m_hidechipbtn){
				if (m_hidechipbtn.hasEventListener(MouseEvent.CLICK)) {
					m_hidechipbtn.removeEventListener(MouseEvent.CLICK,HideChipSetting);
				}
				m_hidechipbtn=null;
			}
			/*if (m_btnUp) {
				if (m_btnUp.hasEventListener(MouseEvent.CLICK)) {
					m_btnUp.removeEventListener (MouseEvent.CLICK,GoUp);
				}
				m_btnUp = null;
			}
			if (m_btnDown) {
				if (m_btnDown.hasEventListener(MouseEvent.CLICK)) {
					m_btnDown.removeEventListener (MouseEvent.CLICK,GoDown);
				}
				m_btnDown = null;
			}*/
			m_LobbyWindow = null;
			loadCycle = null;
			//enterGame = null;
			//btnvideo = null;
			m_LoaderIDList = null;
			m_TableIDList = null;

		}
		/**
		 * 切换游戏
		 * @桌子编号
		 * @游戏位置(1,2,3,4)
		 */
		public function ChangGameTable (tableID:uint, gameIndex:int):void {
			if (gameIndex < 1 || gameIndex > 4) {
				return;
			}
			gameIndex--;
			//已经存在桌子
			if (m_LoaderIDList && m_LoaderIDList.indexOf(tableID) != -1) {
				return;
			}
			if (m_TableIDList == null) {
				m_TableIDList = new Array();
			}
			DestroyGameClassByID (gameIndex);
			m_TableIDList[gameIndex] = tableID;

			//保存数据
			m_LobbyWindow.SaveSelectTableID (m_TableIDList);
			//切换当前视频;
			/*if (currentVideo==gameIndex) {
				SwitchVideo (currentVideo);
			}*/
			m_LoaderIDList.push (tableID);
			LoadGameClass ();
			ShowTableListByNotSelect ();
		}
		/**
		 * 销毁旧游戏
		 * @游戏位置(0,1,2,3)
		 */
		private function DestroyGameClassByID (gameIndex:int):void {
			if (gameIndex < 0) {
				return;
			}
			//
			if (m_GameClassList && m_GameClassList.length >= gameIndex && m_GameClassList[gameIndex]) {
				if (m_GameClassList[gameIndex].GetActiveStatus()) {
					removeChild (m_GameClassList[gameIndex].GetMovieClip());
				}
				m_GameClassList[gameIndex].DestroyGameClient ();
				m_GameClassList[gameIndex] = null;
			}
		}
		/**
		 * 加载游戏
		 * @游戏位置(0,1,2,3)
		 */
		private function LoadGameClass ():void {
			if (m_LoadStatus || m_LobbyWindow == null || m_LoaderIDList == null || m_LoaderIDList.length <= 0) {
				return;
			}
			var table:cmdMemberTableInfo = m_LobbyWindow.GetMemberTableInfo(int(m_LoaderIDList[0]));
			if (table == null) {
				return;
			}
			if (m_cLoader == null) {
				m_cLoader = new ClassLoader();
				m_cLoader.m_Version = m_LobbyWindow.m_Version;
				m_cLoader.addEventListener (ClassLoader.CLASS_LOADED, onLoaded);
				m_cLoader.addEventListener (ClassLoader.LOAD_PROGRESS, onLoadProgress);
			}
			var index:int = m_TableIDList.indexOf(table.TableID);
			loadCycle[index].visible = true;
			//enterGame[index].visible = false;
			/*进度条如何设计
			this["lodMc"]["lod0"]["lod"].scaleX = 0;
			this["lodMc"].visible = true;
			this["lodMc"]["lod0"].visible = true;
			this["lodMc"]["m_connect"].visible = false;
			this.setChildIndex (this["lodMc"], this.numChildren - 1);
			*/
			var gameModule:String = "";
			switch (table.GameKind) {
				case 1 ://百家乐
					gameModule = "BaccModuleByNomalSimple.swf";
					break;
				case 2 ://轮盘
					gameModule = "RouletteModuleBySimple.swf";
					break;
				case 4 ://龙虎
					gameModule = "DragonTigerModuleBySimple.swf";
					break;
				case 6 ://保险百家乐
					gameModule = "BaccModuleByInsuranceSimple.swf";
					break;
				case 8 ://VIP百家乐
					break;
			}
			if (gameModule == "") {
				/*隐藏进度条*/
				return;
			}
			m_LoadStatus = true;
			m_cLoader.load (m_LobbyWindow.m_LoadFolder + gameModule);
		}
		public function onLoaded (event:Event):void {
			var gameClass:IGameClass = m_cLoader.newDefaultIGameClass();
			if (gameClass != null) {
				var tableID:int = int(m_LoaderIDList[0]);
				var table:cmdMemberTableInfo = m_LobbyWindow.GetMemberTableInfo(tableID) as cmdMemberTableInfo;
				if (table != null && m_memBetLimit) {
					var param:Object = {
						limitid: m_memBetLimit[0],
						ishost: false,
						tablepwd: "",
						moneytype: "",
						language: lang,
						lookon: false
					};
					var isClient:Boolean = gameClass.CreateGameClient(this,table,param);
					if (isClient==false) {
						ExitMoreGame (null);//游戏加载失败
					}
					var index:int = m_TableIDList.indexOf(tableID);
					if (m_GameClassList==null) {
						m_GameClassList=new Array();
					}
					m_GameClassList[index] = gameClass;
				}
			}
			m_LoaderIDList.shift ();
			m_LoadStatus = false;
			if (m_LoaderIDList.length > 0) {
				LoadGameClass ();
			}
		}
		/**
		 * 加载进度(4个进度条)
		 */
		public function onLoadProgress (event:ProgressEvent):void {

		}
		/**
		 * 活动显示游戏端 进度条没有完成
		 */
		public function ActiveGameClass (game:IGameClass):void {
			var haveGame:Boolean = false;
			var index:int = 0;
			while (index < m_GameClassList.length) {
				if (m_GameClassList[index] == game) {
					haveGame = true;
					break;
				}
				index++;
			}
			if (haveGame) {
				loadCycle[index].visible = false;
				//enterGame[index].visible = true;
				//enterGame[index].addEventListener (MouseEvent.CLICK,Enter);
				game.SetActiveStatus (true);
				if (game) {
					var nc:MovieClip = game.GetMovieClip();
					nc.x = loadSwfPoint[index].x;
					nc.y = loadSwfPoint[index].y;
					addChild (nc);
					//this.setChildIndex (this["enter"],this.getChildIndex(nc));
				}
			} else {
				DestroyGameClass (game);
			}
		}
		//销毁游戏端
		public function DestroyGameClass (game:IGameClass):void {
			var haveGame:Boolean = false;
			var tableID:int = 0;
			var gameIndex:int = 0;
			var index:int = 0;
			while (index < m_GameClassList.length) {
				if (m_GameClassList[index] == game) {
					haveGame = true;
					tableID = m_TableIDList[index];
					gameIndex = index + 1;
					break;
				}
				index++;
			}
			if (game.GetActiveStatus()) {
				removeChild (game.GetMovieClip());
			}

			game.DestroyGameClient ();
			game = null;
			
			if (haveGame) {
				m_GameClassList[index] = null;
				m_TableIDList[index] = 0;
				ChangGameTable(tableID, gameIndex);
			}
		}
		//获取限额
		public function GetBetLimit (gameKind:int, limitID:int):Array {
			if (m_LobbyWindow) {
				return m_LobbyWindow.GetBetLimit(gameKind, limitID);
			}
			return null;
		}
		//获取会员编号
		public function GetMeUserID ():uint {
			if (m_LobbyWindow) {
				return m_LobbyWindow.GetMeUserID();
			}
			return 0;
		}
		//获取会员密码
		public function GetMePassword ():String {
			if (m_LobbyWindow) {
				return m_LobbyWindow.GetMePassword();
			}
			return "";
		}
		/**
		 * 设置筹码选择 
		 * @chips 二维数组(1:被选择的5个筹码数组,2:当前选择筹码)
		 */
		public function SetSelectChips (chips:Array):void {
			if (m_LobbyWindow) {
				m_LobbyWindow.SetSelectChips (chips);
			}
			var index:int = 0;
			if (m_GameClassList) {
				var len:int=m_GameClassList.length;
				for (index; index<len; index++) {
					var gameclass:IGameClass = m_GameClassList[index];
					if (gameclass) {
						gameclass.SetMoreTableSelectChips (chips);
					}
				}
			}
		}
		//筹码选择
		public function GetChipSelect (className:String):IChipSelect {
			if (m_LobbyWindow) {
				return m_LobbyWindow.GetChipSelect(className);
			}
			return null;
		}
		public function GetChipView(index:int):MovieClip {
			if (m_LobbyWindow) {
				return m_LobbyWindow.GetChipView(index);
			}
			return null;
		}
		//获取筹码选择
		public function GetSelectChips ():Array {
			if (m_LobbyWindow) {
				return m_LobbyWindow.GetSelectChips();
			}
			return null;
		}
		//设置视频线路
		public function SetVideoLine (index:int):void {
			if (m_LobbyWindow) {
				m_LobbyWindow.SetVideoLine (index);
			}
		}
		//获取视频线路
		public function GetVideoLine ():int {
			if (m_LobbyWindow) {
				return m_LobbyWindow.GetVideoLine();
			}
			return 0;
		}
		//路子
		public function GetHistoryRoad (className:String, gameRoad:Boolean = false):IHistoryResultManger {
			if (m_LobbyWindow) {
				return m_LobbyWindow.GetHistoryRoad(className, gameRoad);
			}
			return null;
		}
		public function GetFlipCard (className:String):IFlipCard {
			if (m_LobbyWindow) {
				return m_LobbyWindow.GetFlipCard(className);
			}
			return null;
		}
		//显示提示消息
		public function ShowMessage (type:int,code:int,confirmfun:Function,confirmparam:Object,cancelfun:Function,cancelparam:Object):void {
			if (m_LobbyWindow) {
				m_LobbyWindow.ShowMessage (type,code,confirmfun,confirmparam,cancelfun,cancelparam);
			}
		}
		//显示注单
		public function ShowStatement ():void {
			if (m_LobbyWindow) {
				m_LobbyWindow.ShowStatement ();
			}
		}
		//从游戏传回声音、音乐值
		public function GetSoundSetting ():Array {
			if (m_LobbyWindow) {
				return m_LobbyWindow.GetSoundSetting();
			}
			return null;
		}
		public function SetSoundSetting (isMusic:Boolean,isSound:Boolean):void {
			if (m_LobbyWindow) {
				m_LobbyWindow.SetSoundSetting (isMusic,isSound);
			}
		}
		//显示所有没有选择的桌子
		public function ShowTableListByNotSelect ():void {
			//删除桌子
			m_roomPane.SetSelectTable (m_TableIDList);
			var tableList:Dictionary = m_LobbyWindow.GetTableList();
			//重新生成桌子
			for (var key in tableList) {
				var table:cmdMemberTableInfo = tableList[key];
				//桌子添加
				if (table && table.RoomID == 1) {
					if (m_roomPane) {
						m_roomPane.IChangLang (lang);
						m_roomPane.AddTable (table);
					}
				}
			}
			m_roomPane.ShowTable ();
		}
		//桌子狀態
		public function SetTableStatus (tableStatus:cmdMemberTableStatus):void {
			if (m_roomPane) {
				m_roomPane.SetTableStatus (tableStatus);
			}
			var index:int = m_TableIDList.indexOf(tableStatus.TableID);
			if ( m_GameClassList && m_GameClassList[index]) {
				var gameclass:IGameClass = m_GameClassList[index];
				if (gameclass) {
					gameclass.SetTableStatus (tableStatus);
				}
			}
		}
		//描写路子
		public function SetTableHisRoad (hisRoad:cmdMemberTableHisRoad):void {
			if (m_roomPane) {
				m_roomPane.SetTableHisRoad (hisRoad);
			}
			var index:int = m_TableIDList.indexOf(hisRoad.TableID);
			if (m_GameClassList && m_GameClassList[index]) {
				var gameclass:IGameClass = m_GameClassList[index];
			}
			if (gameclass) {
				gameclass.SetTableHisRoad (hisRoad);
			}
		}
		//获取tableLimitId
		public function SetLimitId (limitId:Array):void {
			m_memBetLimit = limitId[0].split("|");
		}
		//下注金额
		public function SetTablePositionBet (betPos:cmdMemberTablePositionBet):void {
			var index:int = m_TableIDList.indexOf(betPos.TableID);
			if (m_GameClassList && m_GameClassList[index]) {
				var gameclass:IGameClass = m_GameClassList[index];
				if (gameclass) {
					gameclass.SetTablePositionBet (betPos);
				}
			}
		}
		//下注人数
		public function SetTablePositionMembers (memPos:cmdMemberTablePositionMembers):void {
			var index:int = m_TableIDList.indexOf(memPos.TableID);
			if (  m_GameClassList && m_GameClassList[index]) {
				var gameclass:IGameClass = m_GameClassList[index];
				if (gameclass) {
					gameclass.SetTablePositionMembers (memPos);
				}
			}
		}
		//筹码选择
		protected function InitChipSelectManager ():void {
			m_ChipSelectManager = GetChipSelect("ChipSelectBaseManager");
			m_ChipSelectManager.SetChipPane (this);
			m_ChipSelectManager.SetLang(lang);
			var mc:MovieClip = m_ChipSelectManager.GetMovieClip();
			addChild (mc);
			TargetChipSetting(true);
			this.setChildIndex (mc,(this.numChildren-1));
			mc.x = 86;
			mc.y = 155;
		}
		public function ShowTopInfo (m_userInfo:cmdMemberLoginToMember,m_userBalance:cmdMemberBalance):void {
				if (m_userInfo) {
					this["m_UserName"].text =  m_userInfo.ShowName;
				}
				if (m_userBalance) {
					this["m_UserBal"].text =  m_MoneyType + "  " + NumberFormat.BalanceFormat(m_userBalance.Balance);
				} else {
					this["m_UserBal"].text = "0";
				}
		}
		//显示注单
		protected function InitListForBet (e:MouseEvent):void {
			/*if (m_LobbyWindow) {
				m_LobbyWindow.InitListForBet (e);
			}*/
		}
		//全屏
		protected function OnFullScreen (e:MouseEvent):void {
			/*if (stage.displayState != StageDisplayState.FULL_SCREEN) {
				stage.displayState = StageDisplayState.FULL_SCREEN;
			} else {
				stage.displayState = StageDisplayState.NORMAL;
			}
			this["m_btnFullScreen"].SetSelectStatus (stage.displayState == StageDisplayState.FULL_SCREEN);*/
		}
		//改变背景音乐;
		protected function UpdateBgMusic (e:MouseEvent):void {
		}
		//改变声音;
		protected function UpdateSound (e:MouseEvent):void {
		}
		//退出多台;
		protected function ExitMoreGame (e:MouseEvent):void {
			if (m_LobbyWindow) {
				m_LobbyWindow.DestroyMoreGame ();
			}
		}
		//进入游戏
		protected function Enter (e:MouseEvent):void {
			/*var index:int = enterGame.indexOf(e.target);
			if (m_LobbyWindow) {
				DestroyGameClassByID (index);
				m_LobbyWindow.EnterGame (m_TableIDList[index],m_memBetLimit[0],false,false,false);
				m_LobbyWindow.DestroyMoreGame ();
			}
			e.target.removeEventListener (MouseEvent.CLICK,Enter);*/
		}
		//roompane遮罩层
		protected function RoomPaneMask (m_x:Number,m_y:Number,m_width:Number,m_height:Number):Sprite {
			var mc_mk:Sprite=new Sprite();
			var g:Graphics = mc_mk.graphics;
			g.lineStyle (0,0,1);
			g.beginFill (0xffffff,1);
			g.drawRect (m_x,m_y,m_width,m_height);
			g.endFill ();
			return mc_mk;
		}
		protected function InitBtnUpDown (count:int):void {
			/*if (count>0) {
				m_btnDown.SetEnabled (false);
				m_btnUp.SetEnabled (true);
				m_btnUp.addEventListener (MouseEvent.CLICK,GoUp);
			} else {
				m_btnUp.SetEnabled (false);
				m_btnDown.SetEnabled (false);
			}*/
		}
		protected function GoUp (e:MouseEvent):void {
			if (m_roomPane) {
				m_roomPane.y -=  movedistance;
			}
			countBtn--;
			/*m_btnDown.SetEnabled (true);
			m_btnDown.addEventListener (MouseEvent.CLICK,GoDown);
			if (countBtn<=0) {
				m_btnUp.SetEnabled (false);
				m_btnUp.removeEventListener (MouseEvent.CLICK,GoUp);
			}*/

		}
		protected function GoDown (e:MouseEvent):void {
			if (m_roomPane) {
				m_roomPane.y +=  movedistance;
			}
			countBtn++;
			/*m_btnUp.SetEnabled (true);
			m_btnUp.addEventListener (MouseEvent.CLICK,GoDown);
			if (m_roomPane.y >= roompanePoint.y) {
				m_btnDown.SetEnabled (false);
				m_btnDown.removeEventListener (MouseEvent.CLICK,GoUp);
			}*/
		}
		//选择视频线路
		protected function ChangeVideo (e:MouseEvent):void {
			//var index:int = btnvideo.indexOf(e.target);
			//SwitchVideo (index);
		}
		protected function SwitchVideo (index:int):void {
			/*PlayVideo (index);
			btnvideo[index].SetSelectStatus (true);
			var inde:int = 0;
			for (inde; inde<btnvideo.length; inde++) {
				if (inde!=index) {
					btnvideo[inde].SetSelectStatus (false);
				}
			}*/
		}
		public function SetMoneyType (moneyType:String):void {
			if (moneyType) {
				m_MoneyType = moneyType;
			}
		}
		public function SetLang (strlang:String):void {
			lang = strlang;
			//切换视频按钮语言
			/*this["videoOne"].IChangLang (lang);
			this["videoTwo"].IChangLang (lang);
			this["videoThree"].IChangLang (lang);
			this["videoFour"].IChangLang (lang);
			this["m_btnBetList"].IChangLang (lang);
			//背景音乐;
			this["m_btnMusic"].IChangLang (lang);
			//声音;
			this["m_btnSound"].IChangLang (lang);
			//全屏;
			this["m_btnFullScreen"].IChangLang (lang);
			//退出;
			this["m_btnExit"].IChangLang (lang);
			var index:int = 0;
			for (index; index<enterGame.length; index++) {
				enterGame[index].IChangLang (lang);
			}*/
			if(m_ChipSelectManager){
				m_ChipSelectManager.SetLang(lang);
			}
			if(this.getChildByName("mc_showother")){
				this["mc_showother"].gotoAndStop(lang);
			}
		}
		//获取VIP限额编号
		public function GetVipLimitID(limitType:int):int {
			if (m_LobbyWindow) {
				return m_LobbyWindow.GetVipLimitID (limitType);
			}
			return 0;
		}
		//显示隐藏桌台列表
		public function ShowHideTableListPane(bool:Boolean):void{
			if (m_LobbyWindow) {
				 m_LobbyWindow.ShowHideTableListPane (bool);
			}
		}
		protected function ShowChipSetting(e:MouseEvent):void{
			TargetChipSetting(true);
		}
		protected function HideChipSetting(e:MouseEvent):void{
			TargetChipSetting(false);
		}
		protected function TargetChipSetting(bool:Boolean):void{
			if(m_hidechipbtn && m_showchipbtn){
				m_hidechipbtn.visible=bool;
				m_showchipbtn.visible=!bool;
				if(m_ChipSelectManager){
					var mc:MovieClip = m_ChipSelectManager.GetMovieClip();
					mc.visible=bool;
				}
			}
		}
		protected function DrawRoomPaneShape (_x:Number,_y:Number,s_width:Number,s_height:Number):Shape {
			var shape:Shape=new Shape();
			shape.graphics.beginFill (0xcccccc);
			shape.graphics.drawRoundRect (_x, _y, s_width, s_height, 0);
			shape.graphics.endFill ();
			shape.alpha = 0;
			return shape;
		}
		protected function AssembleRommPane ():void {
			var _shape:Shape = DrawRoomPaneShape(0,0,120,890);
			var _mask:Shape = DrawRoomPaneShape(roompanePoint.x,roompanePoint.y,120,890);
			m_roomPane.mask = _mask;
			m_roomPane.addChild (_shape);
			m_roomPane.addEventListener(TransformGestureEvent.GESTURE_SWIPE ,SweepSprite);
		}
		//滑动神域桌台列表
		protected function SweepSprite(e:TransformGestureEvent):void{
			if(e.offsetY==-1){
				trace("向上滑动");
				if(m_roomPane.y>(890-m_roomPane.height)){
					Tweener.addTween(m_roomPane,{y: m_roomPane.y-moveDistance,time: 2})
				}
			}
			if(e.offsetY==1){
				trace("向下滑动");
				if(m_roomPane.y<0){
					Tweener.addTween(m_roomPane,{y: m_roomPane.y+moveDistance,time: 2})
				}
			}
		}
	}
}
include "./LobbyText.as"