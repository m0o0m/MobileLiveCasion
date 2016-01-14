package LangList{
	import flash.events.MouseEvent;
	import flash.display.MovieClip;
	import flash.display.Graphics;
	public class LanguagelistItem extends MovieClip {
		protected var m_listPane:LangguageListPane;
		protected var m_selectId:int;//语言对应Id
		protected var m_index:int;//未选中时对应索引
		public function LanguagelistItem () {
			// constructor code
			this.buttonMode=true;
			this.addEventListener (MouseEvent.CLICK, OnSelect);
			this.addEventListener (MouseEvent.MOUSE_OVER, OnMoveOver);
			this.addEventListener (MouseEvent.MOUSE_OUT, OnMoveOut);
			this.stop();
		}
		public function SetListPane(listpane:LangguageListPane):void{
			m_listPane=listpane;
		}
		//选择语言
		protected function OnSelect (e:MouseEvent):void {
			if (m_listPane) {
				m_listPane.SetSelectId (m_selectId);
			}
		}
		//
		protected function OnMoveOver (e:MouseEvent):void {
			this.gotoAndStop(2);
		}
		//
		protected function OnMoveOut (e:MouseEvent):void {
			this.gotoAndStop(1);
		}
		public function Destroy ():void {
			this.removeEventListener (MouseEvent.CLICK, OnSelect);
			this.removeEventListener (MouseEvent.MOUSE_OVER, OnMoveOver);
			this.removeEventListener (MouseEvent.MOUSE_OUT, OnMoveOut);
		}
		public function GetListArr(list:Array):void{
	         m_index= list.indexOf(m_selectId);
		}
	}
}