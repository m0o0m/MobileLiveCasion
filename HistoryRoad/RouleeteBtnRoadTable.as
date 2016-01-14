package HistoryRoad{

	import flash.events.MouseEvent;
	import flash.display.DisplayObject;

	public class RouleeteBtnRoadTable extends RoadBaseTable {
		protected var m_ZhuZai:ButtonZhuZai;
		protected var m_btnlist:Array=new Array();
		private var rhrm:RouleeteHistoryResultManger = null;
		
		public function RouleeteBtnRoadTable() {
			singleOrDouble.addEventListener(MouseEvent.CLICK,BtnClick);
			bigOrSmall.addEventListener(MouseEvent.CLICK,BtnClick);
			redOrBlack.addEventListener(MouseEvent.CLICK,BtnClick);
			hitOrColumn.addEventListener(MouseEvent.CLICK,BtnClick);
			if (this.getChildByName("zhuzai")) {
				m_ZhuZai = this["zhuzai"];
				m_ZhuZai.addEventListener(MouseEvent.CLICK,BtnClick);
			}
			m_btnlist = [singleOrDouble,bigOrSmall,redOrBlack,hitOrColumn,m_ZhuZai];
			//默认开始显示红黑
			ShowBtn(2);
		}

		public override function Destroy():void {
			singleOrDouble.removeEventListener(MouseEvent.CLICK,BtnClick);
			bigOrSmall.removeEventListener(MouseEvent.CLICK,BtnClick);
			redOrBlack.removeEventListener(MouseEvent.CLICK,BtnClick);
			hitOrColumn.removeEventListener(MouseEvent.CLICK,BtnClick);
			if (m_ZhuZai) {
				m_ZhuZai.removeEventListener(MouseEvent.CLICK,BtnClick);
			}
		}

		public override function ShowRoad(number:int):void {
			return;
		}

		public function SetRouleetManger(rhrManger:RouleeteHistoryResultManger) {
			if (rhrManger) {
				rhrm = rhrManger;
			}
		}

		private function BtnClick(e:MouseEvent) {
			var strViewName:String = "";
			if (e.currentTarget.name == "zhuzai") {
				strViewName = "HistoryRoad.RouleetePealViewByLobby";
				ShowBtn(4);
			} else if (e.currentTarget.name=="singleOrDouble") {
				strViewName = "HistoryRoad.SingleOrDoubleView";
				ShowBtn(0);
			} else if (e.currentTarget.name=="bigOrSmall") {
				strViewName = "HistoryRoad.BigOrSmallView";
				ShowBtn(1);
			} else if (e.currentTarget.name=="redOrBlack") {
				strViewName = "HistoryRoad.RedOrBlackView";
				ShowBtn(2);
			} else {
				strViewName = "HistoryRoad.HCView";
				ShowBtn(3);
			}
			if (posViewName==strViewName) {
				return;
			}
			trace(strViewName);
			posViewName = strViewName;
			BtnOntClick(posViewName);
		}

		private function BtnOntClick(strViewName:String) {
			if (strViewName=="") {
				return;
			}
			if (rhrm==null) {
				return;
			}
			rhrm.BtnOntClick(strViewName);
		}
		protected function ShowBtn(index:int):void {
			for (var inde:int=0; inde<m_btnlist.length; inde++) {
				m_btnlist[inde].SetSelectStatus(false);
			}
			m_btnlist[index].SetSelectStatus(true);
		}
		public override function SetLang(strlang:String):void{
			super.SetLang(strlang);
			singleOrDouble.IChangLang(m_lang);
			bigOrSmall.IChangLang(m_lang);
			redOrBlack.IChangLang(m_lang);
			hitOrColumn.IChangLang(m_lang);
			m_ZhuZai.IChangLang(m_lang);
		}
	}

}