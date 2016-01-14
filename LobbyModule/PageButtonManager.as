package {
	import flash.display.MovieClip;
	import LobbyModule.Button.ButtonPage;
	public class PageButtonManager extends MovieClip {
		protected var m_btnPageList:Array;
		public function PageButtonManager (count:int) {
			// constructor code
			AddPageButton(count);
		}
		//添加页面按钮for TableListPane
		public function AddPageButton (pageCount:int):void {
			ClearButton ();
			var index:int = 0;
			if ((pageCount > 1)) {
				for (index; index <= pageCount - 1; index++) {
					if ((m_btnPageList == null)) {
						m_btnPageList = new Array  ;
					}
					var m_btnPage:ButtonPage = new ButtonPage  ;
					m_btnPage.x = index * 44;
					addChild (m_btnPage);
					m_btnPageList.push (m_btnPage);
				}
				ChangeButtonView (0);
			}
		}
		public function ChangeButtonView (page:int):void {
			var index:int = 0;
			if (m_btnPageList) {
				for (index; index<m_btnPageList.length; index++) {
					m_btnPageList[index].SetSelectStatus (false);
				}
			}
			m_btnPageList[page].SetSelectStatus (true);
		}
		public function ClearButton ():void {
			var _len:int = this.numChildren;
			for (var index:int=0; index<_len; index++) {
				this.removeChild (this.getChildAt(index));
			}
			if(m_btnPageList){
				m_btnPageList = null;
			}
		}

	}

}