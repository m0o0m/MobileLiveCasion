package HistoryRoad {
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.display.DisplayObject;

	public class RoadInfoDragon extends RoadBaseTable{
		public var hrbm:HistoryResultBaseManger;//路子历史管理

		protected var spBAsk:Sprite = null;//庄问路结果
		protected var spPAsk:Sprite = null;//闲问路结果
		//btnBAsk//庄问路按钮
		//btnPAsk//闲问路按钮

		protected var m_btnBAsk:DisplayObject;
		protected var m_btnPAsk:DisplayObject;
		
		public var bAsk:Array;//庄问路结果
		public var pAsk:Array;//闲问路结果

		protected var askIndxe:int;//问路类型，1庄问路，2闲问路

		public function RoadInfoDragon() {
			_width = width;
			_height = height;
			m_btnBAsk = getChildByName("btnBAsk");
			m_btnPAsk = getChildByName("btnPAsk");
			Initialize ();
		}

		//销毁
		public override function Destroy ():void {
			this.dragonNum.text = "0";
			this.tigerNum.text = "0";
			this.tieNum.text = "0";
			this.totalNum.text = "0";
			if (getChildByName("rInfoLange")!=null) {
				removeChild (getChildByName("rInfoLange"));
			}
			hrbm = null;
			if (spBAsk!=null) {
				if (spBAsk.numChildren > 0) {
					var bindex = spBAsk.numChildren - 1;
					while (bindex>=0) {
						spBAsk.removeChildAt (bindex);
						bindex--;
					}
				}
				removeChild (spBAsk);
				spBAsk = null;
			}
			if (spPAsk!=null) {
				if (spPAsk.numChildren > 0) {
					var pindex = spPAsk.numChildren - 1;
					while (pindex>=0) {
						spPAsk.removeChildAt (pindex);
						pindex--;
					}
				}
				removeChild (spPAsk);
				spPAsk = null;
			}
			
			if (m_btnBAsk!=null) {
				m_btnBAsk.removeEventListener(MouseEvent.CLICK, AskEvent);
				removeChild (m_btnBAsk);
				m_btnBAsk = null;
			}
			if (m_btnPAsk!=null) {
				m_btnPAsk.removeEventListener(MouseEvent.CLICK, AskEvent);
				removeChild (m_btnPAsk);
				m_btnPAsk = null;
			}
		}

		//初始化
		public override function Initialize ():void {
			spBAsk=new Sprite();
			spPAsk=new Sprite();
			addChild (spBAsk);
			addChild (spPAsk);
			spBAsk.mouseEnabled = false;
			spBAsk.mouseChildren = false;
			spPAsk.mouseEnabled = false;
			spPAsk.mouseChildren = false;
			
			spBAsk.x = m_btnBAsk.x + 100;
			spBAsk.y = m_btnBAsk.y + 12;
			
			spPAsk.x = m_btnPAsk.x + 100;
			spPAsk.y = m_btnPAsk.y + 12;
			if(m_btnBAsk) {
				m_btnBAsk.addEventListener(MouseEvent.CLICK, AskEvent);
			}
			if(m_btnPAsk) {
				m_btnPAsk.addEventListener(MouseEvent.CLICK, AskEvent);
			}
		}

		//洗牌
		public override function Shuffle ():void {
			this.dragonNum.text = "0";
			this.tigerNum.text = "0";
			this.tieNum.text = "0";
			this.totalNum.text = "0";
			RemoveAskResult ();
		}

		//移除庄问路，闲问路
		private function RemoveAskResult ():void {
			if (spBAsk!=null) {
				if (spBAsk.numChildren > 0) {
					var bindex = spBAsk.numChildren - 1;
					while (bindex>=0) {
						spBAsk.removeChildAt (bindex);
						bindex--;
					}
				}
			}
			if (spPAsk!=null) {
				if (spPAsk.numChildren > 0) {
					var pindex = spPAsk.numChildren - 1;
					while (pindex>=0) {
						spPAsk.removeChildAt (pindex);
						pindex--;
					}
				}
			}
		}

		//庄问路闲问路按钮事件
		public function AskEvent (e:MouseEvent) {
			if (e.type == MouseEvent.MOUSE_OVER) {
				e.target.alpha = 0.4;
			} else if (e.type==MouseEvent.MOUSE_OUT) {
				e.target.alpha = 0;
			} else if (e.type==MouseEvent.CLICK) {
				if (e.target == m_btnBAsk) {
					askIndxe = 1;
				} else {
					askIndxe = 2;
				}
				OnAsk ();
			}
		}

		/*
		 * 显示历史结果统计信息
		 @ number 最新结果
		*/
		public override function ShowRoad (number:int):void {
			if (! number || number == 0) {
				return;
			}
			this.totalNum.text = (1 + int(this.totalNum.text)).toString();
			switch (number) {
				case 1 :
					this.dragonNum.text = (1 + int(this.dragonNum.text)).toString();
					break;
				case 2 :
					this.tigerNum.text = (1 + int(this.tigerNum.text)).toString();
					break;
				case 3 :
					this.tieNum.text = (1 + int(this.tieNum.text)).toString();
					break;
					}
			RemoveAskResult ();
			if (bAsk&&pAsk) {
				var index = 2;
				while (index<5) {
					if (bAsk[index] && bAsk[index] != 0) {
						spBAsk.addChild (new AskRoad(bAsk[index],index-1));
					}
					if (pAsk[index] && pAsk[index] != 0) {
						spPAsk.addChild (new AskRoad(pAsk[index],index-1));
					}
					index++;
				}
			}
		}


		public override function ShowAsk (number:Number):void {
			return;
		}

		//实例化路子管理
		public function SetHistoryManger (hm:HistoryResultBaseManger):void {
			if (hm) {
				hrbm = hm;
			}
		}

		/*
		 * 问路点击函数
		*/
		public function OnAsk () {
			if (hrbm) {
				hrbm.OnAsk (askIndxe);
			}
		}
		public override function SetLang(strlang:String):void{
			super.SetLang(strlang);
			this["btnBAsk"].IChangLang(strlang);
			this["btnPAsk"].IChangLang(strlang);
			if (this.getChildByName("rInfoLange")!=null) {
				this["rInfoLange"].gotoAndStop(strlang);
			}
		}
	}

}