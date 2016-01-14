package {
	import GameModule.Common.PK.*;
	import flash.geom.Point;
	import flash.events.MouseEvent;

	public class PKShowManagerBySimple extends PKShowManager {

		public function PKShowManagerBySimple () {
			super();
			pPkPoint = [new Point(240,-23)];
			bPkPoint = [new Point(70,-23)];
			pFont.x=210;
			bFont.x=40;
			if (pResult) {
				pResult.visible = false;
			}
			if (bResult) {
				bResult.visible = false;
			}
			bFont.visible=false;
			pFont.visible=false;
			
		}
		/*
		 * 显示牌
		 * @ number 牌对应的编号
		 * @ index 索引（从1开始） 表示当前是第几张牌
		 * @ type 类型 1表示龍 2表示虎
		 */
		public override function ShowPK (lookCard:Boolean,number:int,index:int,type:int,LookCardPosition:int,ishost:Boolean):void {
			if(bFont.visible==false){
				bFont.visible=true;
			}
			if(pFont.visible==false){
			    pFont.visible=true;
			}
			super.ShowPK (lookCard,number,index,type,LookCardPosition,ishost);
		}

		//销毁
		override public function Destroy ():void {
			if (m_bMcCard && m_bMcCard.length > 0) {
				var bIndex:int = m_bMcCard.length - 1;
				while (bIndex>=0) {
					var bpkc:PkCardsDragon = m_bMcCard[bIndex] as PkCardsDragon;
					if (bpkc) {
						removeChild (bpkc);
					}
					m_bMcCard[bIndex] = null;
					bIndex--;
				}
				m_bMcCard = null;
			}
			if (m_pMcCard && m_pMcCard.length > 0) {
				var pIndex:int = m_pMcCard.length - 1;
				while (pIndex>=0) {
					var ppkc:PkCardsDragon = m_pMcCard[pIndex] as PkCardsDragon;
					if (ppkc) {
						removeChild (ppkc);
					}
					m_pMcCard[bIndex] = null;
					pIndex--;
				}
				m_pMcCard = null;
			}
			m_bCardInfo = null;
			m_pCardInfo = null;

			if (bFont) {
				removeChild (bFont);
				bFont = null;
			}
			if (pFont) {
				removeChild (pFont);
				pFont = null;
			}

		}
		/**
		 * 清除PK
		 */
		override public function ClearPk () {
			if (m_bMcCard && m_bMcCard.length > 0) {
				var bIndex:int = m_bMcCard.length - 1;
				while (bIndex>=0) {
					var bpkc:PkCardsDragon = m_bMcCard[bIndex] as PkCardsDragon;
					if (bpkc) {
						bpkc.visible = false;
					}
					bIndex--;
				}
			}
			if (m_pMcCard && m_pMcCard.length > 0) {
				var pIndex:int = m_pMcCard.length - 1;
				while (pIndex>=0) {
					var ppkc:PkCardsDragon = m_pMcCard[pIndex] as PkCardsDragon;
					if (ppkc) {
						ppkc.visible = false;
					}
					pIndex--;
				}
			}
			m_bCardInfo = null;
			m_pCardInfo = null;
			m_bCardInfo=new Array();
			m_pCardInfo=new Array();

			HideResultBg ();
			ShowPKResult (0,0);
			if(bFont.visible){
				bFont.visible=false;
			}
			if(pFont.visible){
				pFont.visible=false;
			}
		}
		/*
		 * 得到牌对应的点数
		 @ number 牌索引
		*/
		override protected function computeResult (number:int):int {
			var pkResult:int = 0;
			if (number % 13==0) {
				pkResult = 13;
			} else {
				pkResult = number % 13;
			}
			return pkResult;
		}
		override public function ShowCardResult () {
			pNumResult = -1;
			bNumResult = -1;
			var index:int = 0;
			while (index < 3) {
				//闲
				if (m_pCardInfo[index]) {

					var pCard:PkCardsDragon = null;
					var pPoint:Point = null;
					var pNum:int = -1;

					if (m_pMcCard[index] == null) {
						pCard = new PkCardsDragon();
						addChild (pCard);
						this.setChildIndex (pFont,this.getChildIndex(pCard));
						m_pMcCard[index] = pCard;
					} else {
						pCard = m_pMcCard[index] as PkCardsDragon;
						pCard.visible = true;
					}
					pPoint = pPkPoint[index] as Point;
					if (pPoint==null) {
						pPoint = new Point(339.30,128.40);
					}

					if (m_pCardInfo[index][1] == false) {
						pNum = m_pCardInfo[index][0];
						if (pNumResult == -1) {
							pNumResult = 0;
						}
						pNumResult = computeResult(pNum);
					}
					ShowPKResult (pNumResult, 2);
					pCard.ShowPkInfo (pNum, pPoint, index,m_ishost);
				}
				//庄

				if (m_bCardInfo[index]) {
					var bCard:PkCardsDragon = null;
					var bPoint:Point = null;
					var bNum:int = -1;

					if (m_bMcCard[index] == null) {
						bCard = new PkCardsDragon();
						addChild (bCard);
						this.setChildIndex (bFont,this.getChildIndex(bCard));
						m_bMcCard[index] = bCard;
					} else {
						bCard = m_bMcCard[index] as PkCardsDragon;
						bCard.visible = true;
					}
					bPoint = bPkPoint[index] as Point;
					if (bPoint==null) {
						bPoint = new Point(339.30,128.40);
					}

					if (m_bCardInfo[index][1] == false) {
						bNum = m_bCardInfo[index][0];
						if (bNumResult == -1) {
							bNumResult = 0;
						}
						bNumResult = computeResult(bNum);
					}
					ShowPKResult (bNumResult, 1);
					bCard.ShowPkInfo (bNum, bPoint, index,m_ishost);
				}
				index++;
			}
		}
		/*
		 * 显示结果
		 @ number 结果值
		 @ type 1庄 2闲
		*/
		override protected function ShowPKResult (number:int=0,type:int=0):void {
			if (number == -1) {
				return;
			}

			number = number == 0 ? 14:number;
			if (type==1) {
				if (bResult) {
					bResult.text=String (number);
				}
			} else if (type==2) {
				if (pResult) {
					pResult.text=String (number);
				}
			} else {
				if (pResult) {
					pResult.text=String(number);
				}
				if (bResult) {
					bResult.text=String (number);
				}
			}
		}
	}

}