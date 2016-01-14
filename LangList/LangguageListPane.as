package LangList{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.display.GradientType;
	import flash.display.SpreadMethod;

	public class LangguageListPane extends MovieClip {
		protected var m_login:Login;
		//所有语言数组
		protected var listArr:Array;
		//未选中语言对应ID数组
		protected var listId:Array;
		//未选择语言列表
		protected var container:Sprite;
		//选中语言
		//protected var m_select:LanguagelistItem;
		//选中语言对应ID
		protected var m_selectId:int=1;
		//语言
		protected var m_lang:String;
		var _height:int = 123;
		protected var m_bg:MovieClip;
		public function LangguageListPane () {
			// constructor code
			listArr=[new LanguageCH(),new LanguageEN(),new LanguageTW()];
			listId=[2,3];
			container=new Sprite();
			container.y = _height;
			container.visible = false;
			addChild (container);
			AddList ();
		}
		public function SetLogin(login:Login):void{
			m_login=login;
		}
		//显示语言列表
		public function ShowLanguageList ():Boolean {
			container.visible = !container.visible;
			return container.visible;
		}
		//添加列表
		protected function AddList ():void {
			DestroyContainer();
			//添加已选择语言
			if (listArr && listArr[m_selectId-1]) {
				listArr[m_selectId - 1].mouseEnabled = false;
				listArr[m_selectId - 1].y=0;
				listArr[m_selectId - 1].gotoAndStop(1);
				addChild (listArr[m_selectId-1]);
			}
			var index:int = 0;
			//添加未选择语言列表
			for (index; index<listId.length; index++) {
				listArr[listId[index] - 1].y = index * _height;
				listArr[listId[index] - 1].SetListPane(this);
				listArr[listId[index] - 1].GetListArr (listId);
				listArr[listId[index] - 1].mouseEnabled = true;
				container.visible = false;
				container.addChild (listArr[listId[index]-1]);
			}
		}
		//变换语言
		public function SetSelectId (selectId:int):void {
			if (m_selectId==selectId) {
				return;
			}
			if (selectId<=0) {
				selectId = 1;
			}
			var index = listId.indexOf(selectId);
			if (index>=0) {//避免第一次加载出错
				if (m_selectId>0) {
					removeChild (listArr[m_selectId-1]);
					listId.splice (index,1,m_selectId);
				}
			}
			//切换未选择语言;
			m_selectId = selectId;
			AddList ();
			GetLang ();
		}
		//销毁容器
		protected function DestroyContainer ():void {
			var index:int = container.numChildren - 1;
			for (index; index>=0; index--) {
				container.removeChildAt (index);
			}
		}
		//销毁
		public function Destroy ():void {
			if (container) {
				DestroyContainer ();
				removeChild (container);
				container = null;
			}
			listArr = null;
			listId = null;
			this["btn"].removeEventListener (MouseEvent.CLICK,ShowLanguageList);
			var index:int = this.numChildren - 1;
			for (index; index>=0; index--) {
				this.removeChildAt (index);
			}
		}
		//设置语言
		public function GetLang ():void {
			var strlang:String = "";
			switch (m_selectId) {
				case 1 :
					strlang = "ch";
					break;
				case 2 :
					strlang = "en";
					break;
				case 3 :
					strlang = "tw";
					break;
				default :
					strlang = "ch";//默认为中文
					break;
			}
			if (strlang==m_lang) {
				return;
			}
			m_lang = strlang;
			m_login.SetLang (strlang);
		}
		public function HideContainer(_x,_y):void{
			if(container){
				var m_width=_x-container.x;
				var m_height=_y-container.y;
				if(m_width>=0 && m_height>=0 && m_width<=container.width && m_height<=container.height){
					return;
				}
				container.visible=false;
			}
		}
	}
}