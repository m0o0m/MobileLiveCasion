package  {
	import GameModule.Common.PK.*;
	import flash.geom.Point;
	import flash.events.MouseEvent;
	public class PKShowManagerBySimple extends PKShowBaseManager{

		public function PKShowManagerBySimple() {
			// constructor code
			pkPoint=new Point(0,0);
			bPkPoint=[new Point(210,0),new Point(285,0),new Point(461,16)];
			pPkPoint=[new Point(48,0),new Point(123,0),new Point(41,16)];
			bFontPos=new Point(198,0);
			pFontPos=new Point(40,0);
			m_resultPos=[new Point(476.85,485.45),new Point(164.35,485.45),new Point(330.35,485.45)];
			super();
			if(pResult){
				pResult.visible=false;
			}
			if(bResult){
				bResult.visible=false;
			}
			bFont.visible=false;
			pFont.visible=false;
		}
		public override  function ClearPk () {
			super.ClearPk();
			if(bFont.visible){
				bFont.visible=false;
			}
			if(pFont.visible){
				pFont.visible=false;
			}
		}
		/*
		 * 显示结果
		 @ number 结果值
		 @ type 1庄 2闲
		*/
		protected override function ShowPKResult (number:int=0,type:int=0):void {
		}
		public override  function ShowPK (lookCard:Boolean, number:int,index:int,type:int,LookCardPosition:int,ishost:Boolean):void {
			if(bFont.visible==false){
				bFont.visible=true;
			}
			if(pFont.visible==false){
			    pFont.visible=true;
			}
			super.ShowPK(lookCard,number,index,type,LookCardPosition,ishost)
		}
		public override function ShowCardResult () {
			m_isOver = false;
			pNumResult = -1;
			bNumResult = -1;
			var index:int = 0;
			while (index < 3) {
				//闲
				if (m_pCardInfo[index] && m_pCardInfo[index].length == 2 && m_pCardInfo[index][0] > 0) {
					var pCard:PKCards = null;
					var pPoint:Point = null;
					var pNum:int = -1;

					if (m_pMcCard[index] == null) {
						pCard = new PKCards();
						addChild (pCard);
						this.setChildIndex(pFont,this.getChildIndex(pCard));
						m_pMcCard[index] = pCard;
					} else {
						pCard = m_pMcCard[index] as PKCards;
						pCard.visible = true;
					}
					if (m_pCardInfo[index][1] && m_ishost) {
						pCard.buttonMode = true;
						pCard.mouseEnabled = true;
						pCard.addEventListener (MouseEvent.CLICK,TurnPkp);
					}
					if (m_pCardInfo[index][1] == false) {
						pCard.buttonMode = false;
						pCard.mouseEnabled = false;
					}
					pPoint = pPkPoint[index] as Point;
					if (pPoint==null) {
						pPoint = new Point(0,0);
					}

					if (m_pCardInfo[index][1] == false) {
						pNum = m_pCardInfo[index][0];
						if (pNumResult == -1) {
							pNumResult = 0;
						}
						pNumResult +=  computeResult(pNum);
						pNumResult %=  10;
					}
					ShowPKResult (pNumResult, 2);
					pCard.ShowPkInfo (pNum, pPoint, index,m_ishost);
				}
				//庄
				if (m_bCardInfo[index] && m_bCardInfo[index].length == 2 && m_bCardInfo[index][0] > 0) {
					var bCard:PKCards = null;
					var bPoint:Point = null;
					var bNum:int = -1;

					if (m_bMcCard[index] == null) {
						bCard = new PKCards();
						addChild (bCard);
						this.setChildIndex(bFont,this.getChildIndex(bCard));
						m_bMcCard[index] = bCard;
					} else {
						bCard = m_bMcCard[index] as PKCards;
						bCard.visible = true;
					}
					if (m_bCardInfo[index][1] && m_ishost) {
						bCard.buttonMode = true;
						bCard.mouseEnabled = true;
						bCard.addEventListener (MouseEvent.CLICK,TurnPkb);
					}
					if (m_bCardInfo[index][1] == false) {
						bCard.buttonMode = false;
						bCard.mouseEnabled = false;
					}
					bPoint = bPkPoint[index] as Point;
					if (bPoint==null) {
						bPoint = new Point(0,0);
					}

					if (m_bCardInfo[index][1] == false) {
						bNum = m_bCardInfo[index][0];
						if (bNumResult == -1) {
							bNumResult = 0;
						}
						bNumResult +=  computeResult(bNum);
						bNumResult %=  10;
					}
					ShowPKResult (bNumResult, 1);
					bCard.ShowPkInfo (bNum, bPoint, index,m_ishost);
				}
				index++;
			}
			m_isOver = true;
		}

	}
	
}
