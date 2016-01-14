package {
	import flash.display.Sprite;
	import flash.display.MovieClip;
	import flash.events.ProgressEvent;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.net.URLRequest;
	import flash.net.URLRequestHeader;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;
	//import flash.events.SoftKeyboardEvent;
	import flash.utils.getQualifiedClassName;
	import flash.utils.ByteArray;
	import flash.desktop.NativeApplication;
	import flash.ui.Keyboard;
	import flash.desktop.SystemIdleMode;
	import flash.system.Capabilities;
	//import flash.events.TouchEvent;
	//import flash.ui.Multitouch;
	//import flash.ui.MultitouchInputMode;
	

	import Common.ClassLoader;
	import Common.PostPage;
	import IGameFrame.ILoad;
	import IGameFrame.IMain;
	import ISWFModule.IModule;
	import IGameFrame.IHistoryResultManger;
	import IGameFrame.IChipSelect;
	import IGameFrame.IFlipCard;
	import Dialog.ManageDialog;
	import LangList.LangguageListPane;
	
	public class Login extends MovieClip implements ILoad {
		//login
		protected var m_loginbtn:MovieClip;//登陆按钮
		protected var m_account:TextField;//账号
		protected var m_password:TextField;//账号密码
		protected var m_showlangbtn:MovieClip;//语言按钮
		protected var m_languagePane:LangguageListPane;//语言列表


		//loading
		protected var m_Language:String="ch";
		protected var m_Version:String = "20131118001";
		protected var m_LoadFolder:String = "GameFlash/";
		protected var m_Vipstatus:Boolean = false;
		protected var loader:ClassLoader;//加载
		protected var request:URLRequest;//资源请求
		protected var UserID:int = 0;
		protected var UserPassword:String = "";
		protected var ServerIP:String = "";
		protected var ServerPort:int = 0;
		protected var UserLimit:String = "";
		protected var SystemLimit:String = "";
		protected var RoomInfo:String = "";
		protected var m_LobbyWindowClass:Class;
		protected var m_HistoryResult:IModule;
		protected var m_HistoryResultByGame:IModule;
		protected var m_ChipSelect:IModule;
		protected var m_LookCard:IModule;
		protected var m_loadTotalByts:Number = 957759;
		protected var m_loadedByts:Number = 0;

		protected var window:Object;

		protected var MoneyType:String;
		protected var totalCount:Number = 0;
		protected var total:Number = 0;
		
		protected var isAccount:Boolean=false;
		protected var isPassword:Boolean=false;
		
		protected var handlexml:HandleConfig;
		protected var xmlname:String="version.xml";
		protected var loginurl:String="/Handler1.ashx";
		
		
		public function Login () {
			stop ();
			//设置舞台质量，在移动设备上有影响
			//stage.quality = "8x8";//"8x8linear";
			
			InitBtn();
			InitLangList();
			InitXml();
			
			//NativeApplication.nativeApplication.addEventListener (InvokeEvent.INVOKE, InitParmas);
			//只适用于android设备
			NativeApplication.nativeApplication.addEventListener(KeyboardEvent.KEY_DOWN,StageBack);
			NativeApplication.nativeApplication.addEventListener (Event.ACTIVATE, handleActivate);
			NativeApplication.nativeApplication.addEventListener (Event.DEACTIVATE, handleDeactivate);
			
		}
		
		
		//
		protected function InitBtn():void{
			if (this.getChildByName("btn_login")) {
				m_loginbtn = this["btn_login"];
				m_loginbtn.addEventListener (MouseEvent.CLICK,LoginPost);
				m_loginbtn.IChangLang(m_Language);
			}
			if (this.getChildByName("txt_account")) {
				m_account=this["txt_account"];
				m_account.x=611;
				m_account.y=471;
				m_account.addEventListener (FocusEvent.FOCUS_IN,HideText);
				m_account.addEventListener (FocusEvent.FOCUS_OUT,ShowAccountText);
				
			}
			if (this.getChildByName("txt_password")) {
				m_password=this["txt_password"];
				m_password.x=611;
				m_password.y=617.7;
				m_password.displayAsPassword=false;
				m_password.addEventListener (FocusEvent.FOCUS_IN,HideText);
				m_password.addEventListener (FocusEvent.FOCUS_OUT,ShowPasswordText);
			}
			if(this.getChildByName("mc_showlang")){
				m_showlangbtn=this["mc_showlang"];
				m_showlangbtn.stop();
				m_showlangbtn.buttonMode=true;
				m_showlangbtn.addEventListener(MouseEvent.CLICK,ShowLangPane);
			}
			if(m_account && m_password){
				m_account.text=ShowLoginText(0,m_Language);
				m_password.text=ShowLoginText(1,m_Language);
			}
		}
		//初始化语言列表
		protected function InitLangList():void{
			m_languagePane=new LangguageListPane();
			addChild(m_languagePane);
			if(this.getChildByName("mc_showlang")){
				this.setChildIndex(m_languagePane,this.getChildIndex(this["mc_showlang"])-1)
			}
			m_languagePane.x=1692.7;
			m_languagePane.y=66;
			m_languagePane.SetLogin(this);
		}
		//设置请求语言
		public function SetLang(lang:String):void{
			m_password.displayAsPassword=false;
			m_Language=lang;
			if(handlexml){
				handlexml.SetLanguage(m_Language);
			}
			if(m_showlangbtn){
				m_showlangbtn.gotoAndStop(1);
			}
			if(m_loginbtn){
				m_loginbtn.IChangLang(m_Language);
			}
			if(m_account && m_password){
				m_account.text=ShowLoginText(0,m_Language);
				m_password.text=ShowLoginText(1,m_Language);
			}
			if(this.getChildByName("loginerror")){
				this["loginerror"].text="";
			}
		}
		//显示语言列表
		protected function ShowLangPane(e:MouseEvent):void{
			var bool:Boolean=m_languagePane.ShowLanguageList();
			if(bool){
				m_showlangbtn.gotoAndStop(2);
			}else{
				m_showlangbtn.gotoAndStop(1);
			}
		}
		//网页启动
		/*protected function InitParmas(event:InvokeEvent):void{
			var str = "\n" + "Arguments: " + event.arguments + "," + event.currentDirectory + "," + event.reason + "," + event.bubbles + "," + event.cancelable + "," + event.currentTarget;
			this["show"].text = str;
		}*/
		protected function LoginPost(e:MouseEvent):void{
			var account:String="";
			var pwd:String="";
			if(isAccount==false){
				if(this.getChildByName("loginerror")){
				this["loginerror"].text=ShowAccount(0,m_Language);
			}
				
				return;
			}
			if(isPassword==false){
				if(this.getChildByName("loginerror")){
				this["loginerror"].text=ShowAccount(1,m_Language);
			}
				return;
			}
			if (m_account) {
				account = m_account.text;
			}
			if (m_password) {
				pwd = m_password.text;
			}
			if(this.getChildByName("login_load")){
				this["login_load"].visible=true;
			}
			Post(account,pwd);
		}
		protected function HideText (e:FocusEvent):void {
			var m_text:TextField = e.target as TextField;
			m_text.text = ""
			if(m_text==m_password){
				isPassword=false;
				
				m_password.displayAsPassword=true;
			}else{
				isAccount=false;
			}
		}
		protected function ShowAccountText (e:FocusEvent):void {
			var m_text:TextField = e.target as TextField;
			if (m_text.text == "") {
				m_text.text = ShowLoginText(0,m_Language);
				isAccount=false;
			}else{
				isAccount=true;
			}
		}
		protected function ShowPasswordText (e:FocusEvent):void {
			var m_text:TextField = e.target as TextField;
			m_password.displayAsPassword=true;
			if (m_text.text == "") {
				m_password.displayAsPassword=false;
				m_text.text = ShowLoginText(1,m_Language);
				isPassword=false;
			}else{
				isPassword=true;
			}
		}
		//请求登陆
		protected function Post (account:String,pwd:String):void {
			//Loading("");
			if(handlexml ){
				var url:String=handlexml.GetCurrentLoginUrl();
				var str:String=url+loginurl;
				PostPage.LoadPostPage (str,[["name",account],["pwd",pwd]],Loading);
			}
		}
		public function Loading (_data:String) {
			//trace(_data)
			if(_data==null){
				LoginFail(0);
				return;
			}
			var jsondata=JSON.parse(_data);
			if(jsondata["ErrorCode"]!="0"){
				LoginFail(jsondata["ErrorCode"]);
					//trace(ShowLoginError(jsondata["ErrorCode"],m_Language));
					return 
			}
			var param=jsondata["Data"];
			//var param:Object = root.loaderInfo.parameters;
			if (this.getChildByName("loading")) {
				this["loading"].visible = true;
			}
			
			if (param["u"]) {
				UserID = int(param["u"]);
			}
			if (param["p"]) {
				UserPassword = param["p"];
				UserPassword = JieMaPassowrd(UserPassword);
			}
			if (param["ip"]) {
				ServerIP = param["ip"];
			}
			if (param["port"]) {
				ServerPort = param["port"];
			}
			if (param["limit"]) {
				SystemLimit = param["limit"];
			}
			if (param["ulimit"]) {
				UserLimit = param["ulimit"];
			}
			if (param["room"]) {
				RoomInfo = param["room"];
			}
			if (param["money"]) {
				MoneyType = param["money"];
			}
			if (param["vipstatus"]) {
				m_Vipstatus = param["vipstatus"] == "1" ? true:false;
			}
			
			/*UserID = 3948;//3951 3952 3948
			UserPassword = "Aaaaa1111";
			ServerIP = "127.0.0.1";
			m_Vipstatus = true;
			UserID = 172424;
			UserPassword = "aaa88888";
			ServerIP = "63.217.91.46";
			ServerPort = 8800;
			MoneyType = "CNY";
			UserLimit = "1|2|3|4|5;21";
			SystemLimit = "1#5|500#|4,50|||||||;2#10|500#|4,50|||||||;3#25|750#|4,50|||||||;4#50|1500#|4,50|||||||;5#50|2500#|4,50|||||||;6#50|5000#|4,50|||||||;7#100|5000#|4,50|||||||;8#250|5000#|4,50|||||||;9#100|10000#|4,50|||||||;10#200|10000#|4,50|||||||;11#300|10000#|4,50|||||||;12#150|15000#|4,50|||||||;13#300|15000#|4,50|||||||;14#500|15000#|4,50|||||||;15#500|25000#|4,50|||||||;16#750|25000#|4,50|||||||;17#1250|25000#|4,50|||||||;18#750|40000#|4,50|||||||;19#1250|40000#|4,50|||||||;20#2000|40000#|4,50|||||||;21#1000|50000#|4,50|||||||;22#1500|50000#|4,50|||||||;23#2500|50000#|4,50|||||||;24#2500|100000#|4,50|||||||;25#5000|100000#|4,50|||||||;26#10000|100000#|4,50|||||||;27#5000|150000#|4,50|||||||;28#7500|150000#|4,50|||||||;29#15000|150000#|4,50|||||||;30#10000|250000#|4,50|||||||;31#12500|250000#|4,50|||||||;32#25000|250000#|4,50|||||||";
			RoomInfo = "1#NormalLoby#rtmp://210.5.189.211/goldenasia/gg-live1|||;2#MainLoby#rtmp://210.5.189.211/goldenasia/ga-vip01|||;3#VIPLoby#rtmp://210.5.189.211/goldenasia/ga-vip01|||";
			*/if(this.getChildByName("login_load")){
				this["login_load"].visible=false;
			}
			if(this.getChildByName("loading")){
				this["loading"]["lod0"]["lod"].scaleX = 0;
			}

			loader = new ClassLoader(false);
			loader.m_Version = m_Version;
			loader.addEventListener (ClassLoader.CLASS_LOADED,completeFirstHandler);
			loader.addEventListener (ClassLoader.LOAD_PROGRESS,progressHandler);
			loader.load ((m_LoadFolder + "TBSLobbyModule.swf"));
		}

		public function progressHandler (event:ProgressEvent):void {
			if ((total != event.bytesTotal)) {
				total = event.bytesTotal;
				totalCount +=  total;
				//trace (totalCount);
			}
			var loaded:Number = (m_loadedByts + event.bytesLoaded) / m_loadTotalByts;
				
			if ((loaded <= 1)) {
				if(this.getChildByName("loading")){
					this["loading"]["lod0"].visible = true;
					this["loading"]["lod0"]["lod"].scaleX = loaded;
				}
			}
		}

		public function completeFirstHandler (event:Event):void {
			m_loadedByts +=  total;
			var module:IModule = loader.loader.content as IModule;
			if ((module == null)) {
				return;
			}
			switch (getQualifiedClassName(loader.loader.content)) {
				case "LobbyModule" :
					m_LobbyWindowClass = module.GetClass("LobbyWindow");
					loader.load ((m_LoadFolder + "HistoryResult.swf"));
					break;
				case "TBSLobbyModule" :
					m_LobbyWindowClass = module.GetClass("TBSLobbyWindow");
					loader.load ((m_LoadFolder + "HistoryResult.swf"));
					break;
				case "HistoryResult" :
					m_HistoryResult = module;
					loader.load ((m_LoadFolder + "HistoryResultByGame.swf"));
					break;
				case "HistoryResultByGame" :
					m_HistoryResultByGame = module;
					loader.load ((m_LoadFolder + "ChipSelect.swf"));
					break;
				case "ChipSelect" :
					m_ChipSelect = module;
					loader.load ((m_LoadFolder + "LookCard.swf"));
					break;
					//加的
				case "LookCard" :
					m_LookCard = module;
					StartGame ();
					break;
			}
		}
		public function StartGame ():void {
			//隐藏进度条
			if(this.getChildByName("loading")){
				this["loading"]["lod0"].visible = false;
				this["loading"].visible=false;
			}
			window = new m_LobbyWindowClass  ;
			if (window) {
				var main:IMain = window as IMain;
				var param:Object = {cid:1,userid:UserID,userpassword:UserPassword,userlimit:UserLimit,serverip:ServerIP,serverport:ServerPort,systemlimit:SystemLimit,roominfo:RoomInfo,moneytype:MoneyType,language:m_Language,vipstatus:m_Vipstatus};
				main.SetParam (this,param);
			}
			var sprite:Sprite = window as Sprite;
			addChild (sprite);
		}
		public function GetLoadFolder ():String {
			return m_LoadFolder;
		}
		public function GetHistoryRoad (className:String,gameRoad:Boolean=false):IHistoryResultManger {
			if (((gameRoad == false) && m_HistoryResult)) {
				var resultClass:Class = m_HistoryResult.GetClass(className);
				var obj:Object = new resultClass  ;
				return obj as IHistoryResultManger;
			} else if ((gameRoad && m_HistoryResultByGame)) {
				resultClass = m_HistoryResultByGame.GetClass(className);
				obj = new resultClass  ;
				return obj as IHistoryResultManger;
			}
			return null;
		}
		public function GetChipSelect (className:String):IChipSelect {
			if (m_ChipSelect) {
				var resultClass:Class = m_ChipSelect.GetClass(className);
				var obj:Object = new resultClass  ;
				return obj as IChipSelect;
			}
			return null;
		}
		public function GetFlipCard (className:String):IFlipCard {
			if (m_LookCard) {
				var resultClass:Class = m_LookCard.GetClass(className);
				var obj:Object = new resultClass  ;
				return obj as IFlipCard;
			}
			return null;
		}
		public function GetChipView (index:int):MovieClip {
			if (m_ChipSelect) {
				var resultClass:Class = m_ChipSelect.GetClass(("BetChipView" + index));
				var obj:Object = new resultClass  ;
				return obj as MovieClip;
			}
			return null;
		}
		//重新连接
		public function ResetLink ():void {
			if (window) {
				var sprite:Sprite = window as Sprite;
				var index:int = sprite.numChildren;
				while ((index > 0)) {
					sprite.removeChildAt (0);
					index--;
				}
				sprite = null;
				window = null;
			}
			StartGame ();
		}
		//版本信息
		public function GetVersion ():String {
			return m_Version;
		}
		public function JieMaPassowrd (str:String):String {
			var rx:RegExp = new RegExp("([01]{8})+");
			var resultList:Array = rx.exec(str);
			var split:String = resultList[1];

			var data:ByteArray = new ByteArray  ;
			var index:int = 0;
			var dataIndex:int = 0;
			while ((index < str.length)) {
				var subStr:String = str.substr(index,8);
				if ((subStr != split)) {
					data[dataIndex++] = parseInt(subStr,2);
				}
				index +=  8;
			}
			return data.toString();
		}
		protected function StageBack(event:KeyboardEvent):void{
			if(event.keyCode==Keyboard.BACK){
				event.preventDefault();
				if (window) {
					var main:IMain = window as IMain;
					main.GoBack();
				}else{
					ExitApp();//登陆页面直接退出应用
				}
			}else{
				//trace("无返回")
			}
		}
		public function ExitApp():void{
			NativeApplication.nativeApplication.exit();
		}
		protected function LoginFail(errorcode:Number):void{
			if(this.getChildByName("login_load")){
				this["login_load"].visible=false;
			}
			if(this.getChildByName("loginerror")){
				this["loginerror"].text=ShowLoginError(errorcode,m_Language);
			}
		}
		protected function handleActivate (event:Event):void {
			NativeApplication.nativeApplication.systemIdleMode = SystemIdleMode.KEEP_AWAKE;//保持常亮 一直唤醒的状态  
		}

		protected function handleDeactivate (event:Event):void {
			NativeApplication.nativeApplication.systemIdleMode = SystemIdleMode.NORMAL;//回复正常  
		}
		//应用启动检测
		protected function InitXml():void{
			if(handlexml==null){
				handlexml=new HandleConfig(xmlname);
				addChild(handlexml);
				handlexml.SetMain(this);
				var nativeOperationSystem:String=Capabilities.os;
				nativeOperationSystem=nativeOperationSystem.toUpperCase();
				handlexml.SetSystem(nativeOperationSystem);
			}
			handlexml.InitLoadXML();
		}
		public function SetLangList(id:int):void{
			if(m_languagePane){
				m_languagePane.SetSelectId(id);
			}
		}
		public function SetVersion(version:String):void{
			if(this.getChildByName("mc_version")){
				this["mc_version"].mouseEnabled=false;
				this["mc_version"].text=version;
			}
		}
	}
}
include "./LoginText.as"