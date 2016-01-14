package{
	import flash.display.MovieClip;
	import flash.net.URLRequest;
	import flash.net.URLLoader;
	import flash.net.navigateToURL;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.events.MouseEvent;
	import Common.PostPage;

	public class HandleConfig extends MovieClip {
		protected var doucumentname:String;//配置文件名
		protected var loginlist:Array;//服务器请求地址
		protected var downloadlist:Array;//应用下载地址
		protected var loginindex:int;//当前服务器请求索引
		protected var downindex:int;//当前应用下载地址索引
		protected var xmlcontent:XML;

		protected var loader:URLLoader;//网页加载内容
		protected var urlquest:URLRequest;

		
		protected var m_chang:MovieClip;
		
		protected var m_main:Login;
		protected var langlist:Array=["ch","en","tw"];
		protected var serveurl:String="/HandlerXML.ashx";
		
		protected var appsystem:String;
		public function HandleConfig (xmlname:String) {
			// constructor code
			doucumentname = xmlname;
			if(this.getChildByName("confirmchang")){
				m_chang= this["confirmchang"];
				m_chang["confirm"].addEventListener(MouseEvent.CLICK,DownLoad);
				m_chang["close"].addEventListener(MouseEvent.CLICK,Close);
			}
			this.visible=false;
		}
		//开启应用请求服务器
		protected function PostServe ():void {
			if (loginlist==null) {
				loginlist = GetLoginUrl();
			}
			loginindex = 0;
			if (loginlist) {
				var str:String=loginlist[loginindex]+serveurl;
				//trace(str)
				PostPage.LoadPostPage (str,null,HandlePostData);
			}
		}
		//处理请求数据
		protected function HandlePostData (data:String):void {
			//trace(data)
			if (data==null) {
				loginindex++;
				if (loginindex<loginlist.length) {//连续请求地址直到连通为止
					var str:String=loginlist[loginindex]+serveurl;
					PostPage.LoadPostPage (str,null,HandlePostData);
				}
				return;
			}
			
			var xml:XML = new XML(data);
			var lang:XML=<userlang></userlang>;
			xml=xml.insertChildBefore(xml.url,lang);
			var version:*=null;
			//trace(xml)
			trace(xml)
			if(appsystem.indexOf("IPHONE")>=0 ){
				version=xml.ios.versionNum;
			}else{
				version=xml.android.versionNum;
			}
			//trace(version+","+GetAppVersion() )
			if (version != GetAppVersion()) {
				this.visible=true;
				IChangLang(GetLanguage());
			} else {
				xml.userlang=GetLanguage();//应用语言不变
				
				WriteXml (xml);
			}
		}
		//加载xml文件
		public function InitLoadXML ():void {
			if (doucumentname==null || doucumentname=="") {
				return;
			}
			var file:File = File.applicationStorageDirectory.resolvePath(doucumentname);
			if (file.exists) {
				ReadXml ();//文件存在直接读取
				return;
			}
			var urlrequest:URLRequest = new URLRequest(doucumentname);
			var urlload:URLLoader=new URLLoader();
			urlload.addEventListener (Event.COMPLETE,Complete);
			urlload.addEventListener (IOErrorEvent.IO_ERROR,ErrorHandler);
			urlload.load (urlrequest);
		}
		//完成加载
		protected function Complete (e:Event):void {
			var m_xml:XML = null;
			try {
				var strXML:String = e.target.data;
				m_xml = new XML(strXML);
			} catch (e:Error) {
				return;
			}
			if (xmlcontent==null) {
				xmlcontent = m_xml;
			}
			WriteXml (m_xml);
			PostServe ();
			var ver:String=GetAppVersion();
			if(m_main){
				m_main.SetVersion("v  "+ver);
			}
		}
		protected function ErrorHandler (e:IOErrorEvent):void {

		}
		//写入xml文件
		public function WriteXml (xml:XML):void {
			var _fs:FileStream =new FileStream();
			var file:File = File.applicationStorageDirectory.resolvePath(doucumentname);
			_fs.open (file,FileMode.WRITE);
			_fs.writeUTFBytes (xml.toString());
			_fs.close ();
		}
		//读取xml文件
		protected function ReadXml ():void {
			var file:File = File.applicationStorageDirectory.resolvePath(doucumentname);
			if (file.exists == false) {
				return;
			}
			//trace(file.nativePath);
			var stream:FileStream = new FileStream();//文件流
			stream.open (file,FileMode.READ);
			var str:String = stream.readUTFBytes(stream.bytesAvailable);
			if (xmlcontent==null) {
				xmlcontent = new XML(str);
			}
			stream.close ();
			PostServe ();
			if(m_main){
				var lang:String=GetLanguage();
				var index:int=langlist.indexOf(lang)+1;
				m_main.SetLangList(index);
			}
			var ver:String=GetAppVersion();
			if(m_main){
				m_main.SetVersion("v  "+ver);
			}
		}
		//从xml中获得版本信息
		public function GetAppVersion ():String {
			var version:* =null;
			if(appsystem.indexOf("IPHONE")>=0 ){
				version=xmlcontent.ios.versionNum;
			}else{
				version=xmlcontent.android.versionNum;
			}
			return version;

		}
		//从xml中获得语言
		public function GetLanguage ():String {
			var lang:* = xmlcontent.userlang;
			return lang;
		}
		public function SetLanguage(lang:String):void{
			xmlcontent.userlang=lang;
			WriteXml(xmlcontent);
		}
		//从xml中获得服务器请求地址
		public function GetDownLoadUrl ():Array {
			var arr:Array=null;
			if(appsystem.indexOf("IPHONE")>=0 ){
				arr=GetUrl("download","ios")
			}else{
				arr=GetUrl("download","android")
			}
			return arr;
		}
		//从xml中获取服务器登陆地址
		public function GetLoginUrl ():Array {
			return GetUrl("login",null);
		}
		//获取请求地址
		protected function GetUrl (str:String,type:String):Array {
			var urllist:Array=new Array();
			var xmllist:XMLList=null;
			if(type==null){
				xmllist=xmlcontent.url.(@name==str).child("a");
			}else if(type=="ios"){
				xmllist=xmlcontent.ios.url.(@name==str).child("a");
			}else{
				xmllist=xmlcontent.android.url.(@name==str).child("a");
			}
			var len:int = xmllist.length();
			for (var i=0; i<len; i++) {
				urllist.push (xmllist[i].toString());
			}
			return urllist;
		}

		//打开网页链接下载
		public function OpenWeb (e:Event):void {
			var str:String = "";
			if (downloadlist==null) {
				downloadlist = GetDownLoadUrl();
			}
			if (loader) {
				loader.removeEventListener (Event.COMPLETE,OpenWeb);
				var loaderdata:String = loader.data;
				var startindex:int = loaderdata.indexOf("<body");
				var endindex:int = loaderdata.indexOf("</body>");
				str = loaderdata.slice(startindex,endindex);
			}
			if (str.length < 10) {//判断网页内容（不是很好的判定方法）
				if (downindex>=downloadlist.length) {
					trace ("所有下载链接地址不可用");
					return;
				}
				urlquest = null;
				loader = null;
				urlquest = new URLRequest(downloadlist[downindex]);
				loader=new URLLoader();
				loader.load (urlquest);
				loader.addEventListener (Event.COMPLETE,OpenWeb);
				loader.addEventListener (IOErrorEvent.IO_ERROR,IoError);
				loader.addEventListener (SecurityErrorEvent.SECURITY_ERROR,SecurityErro);
				downindex++;
			} else {
				if (urlquest) {
					navigateToURL (urlquest,"_blank");
				}
			}
		}
		protected function IoError (e:IOErrorEvent):void {
			OpenWeb (null);
		}
		protected function SecurityErro (e:SecurityErrorEvent):void {
			OpenWeb (null);
		}
		//销毁
		public function Destory ():void {
			if (downloadlist) {
				downloadlist = null;
			}
			if (xmlcontent) {
				xmlcontent = null;
			}
			if (loader) {
				if (loader.hasEventListener(Event.COMPLETE)) {
					loader.removeEventListener (Event.COMPLETE,OpenWeb);
				}
				if (loader.hasEventListener(IOErrorEvent.IO_ERROR)) {
					loader.removeEventListener (IOErrorEvent.IO_ERROR,IoError);
				}
				if (loader.hasEventListener(SecurityErrorEvent.SECURITY_ERROR)) {
					loader.removeEventListener (SecurityErrorEvent.SECURITY_ERROR,SecurityErro);
				}
				loader = null;
			}
			if (urlquest) {
				urlquest = null;
			}
			if(m_chang){
				m_chang=null;
			}
		}
		public function GetCurrentLoginUrl ():String {
			return  loginlist[loginindex];
		}
		
		public function IChangLang(lang:String):void{
			if(lang=="" || lang==null){
				lang="ch";
			}
			if(m_chang){
				 m_chang["top"].gotoAndStop(lang);
				 m_chang["content"].gotoAndStop(lang);
				 m_chang["confirm"].IChangLang(lang);
			}
		}
		protected function DownLoad(e:MouseEvent):void{
			OpenWeb(null);
			m_chang["confirm"].removeEventListener(MouseEvent.CLICK,DownLoad);
		}
		protected function Close(e:MouseEvent):void{
			if(m_main){
				m_main.ExitApp();
				m_chang["close"].removeEventListener(MouseEvent.CLICK,Close);
			}
		}
		public function SetMain(main:Login):void{
			m_main=main;
		}
		public function SetSystem(os:String){
			appsystem=os;
			if(appsystem.indexOf("IPHONE")>=0 && m_chang){
					m_chang["close"].visible=false;
			}
		}
	}
}