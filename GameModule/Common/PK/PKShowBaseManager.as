package GameModule.Common.PK{
	import flash.display.MovieClip;
	import flash.geom.Point;
	import GameModule.Common.*;
	import flash.events.MouseEvent;
	import flash.text.TextField;

	public class PKShowBaseManager extends MovieClip {
		protected var m_gameView:GameView;

		protected var m_bCardInfo:Array = new Array();
		protected var m_pCardInfo:Array = new Array();
		protected var m_bMcCard:Array = new Array();
		protected var m_pMcCard:Array = new Array();

		protected var pkPoint:Point;//pk管理背景位置

		//背景和结果影片剪辑
		protected var pBg:MovieClip;//闲赢背景
		protected var bBg:MovieClip;//庄赢背景
		protected var pResult:TextField;//闲结果
		protected var bResult:TextField;//庄结果

		//扑克
		protected var bPkPoint:Array;//庄扑克牌位置
		protected var pPkPoint:Array;//闲扑克牌位置

		//结果
		protected var m_resultPos:Array;//结果位置数组 索引为0表示庄位置 1表示闲位置 2表示和位置


		//字
		protected var bFont:PkType;//“庄”子
		protected var bFontPos:Point;//“庄”子位置
		protected var pFont:PkType;//“闲”子
		protected var pFontPos:Point;//“闲”子位置

		protected var m_lang:String;//当前语言

		public function PKShowBaseManager () {
			if (pkPoint) {
				x = pkPoint.x;
				y = pkPoint.y;
			}
			if (this["playerBg"]) {
				pBg = this["playerBg"];
			}
			if (this["blankBg"]) {
				bBg = this["blankBg"];
			}
			if (this["playerResult"]) {
				pResult = this["playerResult"];
			}
			if (this["blankResult"]) {
				bResult = this["blankResult"];
			}
			bFont = new PkType(1,bFontPos);
			addChild (bFont);
			this.setChildIndex (bResult,getChildIndex(bFont));
			pFont = new PkType(2,pFontPos);
			addChild (pFont);
			this.setChildIndex (pResult,getChildIndex(pFont));
			HideResultBg ();
			ShowPKResult ();
		}

		//销毁
		public function Destroy ():void {
			if ((m_bMcCard && m_bMcCard.length > 0)) {
				var bIndex:int = m_bMcCard.length - 1;
				while ((bIndex >= 0)) {
					var bpkc:PKCards = m_bMcCard[bIndex] as PKCards;
					if (bpkc) {
						removeChild (bpkc);
					}
					m_bMcCard[bIndex] = null;
					bIndex--;
				}
				m_bMcCard = null;
			}
			if ((m_pMcCard && m_pMcCard.length > 0)) {
				var pIndex:int = m_pMcCard.length - 1;
				while ((pIndex >= 0)) {
					var ppkc:PKCards = m_pMcCard[pIndex] as PKCards;
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
		public function ClearPk () {
			if ((m_bMcCard && m_bMcCard.length > 0)) {
				var bIndex:int = m_bMcCard.length - 1;
				while ((bIndex >= 0)) {
					var bpkc:PKCards = m_bMcCard[bIndex] as PKCards;
					if (bpkc) {
						bpkc.visible = false;
					}
					bIndex--;
				}
			}
			if ((m_pMcCard && m_pMcCard.length > 0)) {
				var pIndex:int = m_pMcCard.length - 1;
				while ((pIndex >= 0)) {
					var ppkc:PKCards = m_pMcCard[pIndex] as PKCards;
					if (ppkc) {
						ppkc.visible = false;
					}
					pIndex--;
				}
			}
			if(m_bCardInfo) {
				m_bCardInfo.splice(0, m_bCardInfo.length);
			}
			if(m_pCardInfo) {
				m_pCardInfo.splice(0, m_pCardInfo.length);
			}
			HideResultBg ();
			ShowPKResult (0,0);
		}

		/*
		 * 显示牌
		 * @ number 牌对应的编号
		 * @ index 索引（从1开始） 表示当前是第几张牌
		 * @ type 类型 1表示闲 2表示庄
		 */
		protected var m_LookCardPosition:int = 0;
		protected var m_ishost:Boolean;
		public function ShowPK (lookCard:Boolean,number:int,index:int,type:int,LookCardPosition:int,ishost:Boolean):void {
			if (((number < 1) || number > 52)) {
				trace (("number=" + number));
				return;
			}
			if (((index < 1) || index > 3)) {
				return;
			}
			m_LookCardPosition = LookCardPosition;
			m_ishost = ishost;
			var cIndex:int = index - 1;
			if ((type == 2)) {
				m_bCardInfo[cIndex] = [number,lookCard];
			} else {
				m_pCardInfo[cIndex] = [number,lookCard];
			}
			ShowCardResult ();
		}
		public function ShowPCardInfo (cardIndex:int):void {
			if (((cardIndex < 1) || cardIndex > 3)) {
				return;
			}
			var cIndex:int = cardIndex - 1;
			if (m_pCardInfo[cIndex]) {
				m_pCardInfo[cIndex][1] = false;
			}
			ShowCardResult ();
		}
		public function ShowBCardInfo (cardIndex:int) {
			if (((cardIndex < 1) || cardIndex > 3)) {
				return;
			}
			var cIndex:int = cardIndex - 1;
			if (m_bCardInfo[cIndex]) {
				m_bCardInfo[cIndex][1] = false;
			}
			ShowCardResult ();
		}
		public function ShowAllCardInfo ():void {
			var index:int = 0;
			while ((index < 3)) {
				if (m_pCardInfo[index]) {
					m_pCardInfo[index][1] = false;
				}
				if (m_bCardInfo[index]) {
					m_bCardInfo[index][1] = false;
				}
				index++;
			}
			ShowCardResult ();
		}
		protected var pNumResult:int;
		protected var bNumResult:int;
		protected var m_isOver:Boolean;
		public function ShowCardResult () {
			m_isOver = false;
			pNumResult = -1;
			bNumResult = -1;
			var index:int = 0;
			while ((index < 3)) {
				//闲
				if (m_pCardInfo[index] && m_pCardInfo[index].length == 2 && m_pCardInfo[index][0] > 0) {
					var pCard:PKCards = null;
					var pPoint:Point = null;
					var pNum:int = -1;

					if (m_pMcCard[index] == null) {
						pCard = new PKCards ();
						addChild (pCard);
						m_pMcCard[index] = pCard;
					} else {
						pCard = m_pMcCard[index] as PKCards;
						pCard.visible = true;
					}
					if (m_pCardInfo[index][1] && m_ishost && m_LookCardPosition>0) {
						pCard.buttonMode = true;
						pCard.mouseEnabled = true;
						pCard.addEventListener (MouseEvent.CLICK,TurnPkp);
					}
					if (m_pCardInfo[index][1] == false) {
						pCard.buttonMode = false;
						pCard.mouseEnabled = false;
					}
					pPoint = pPkPoint[index] as Point;
					if ((pPoint == null)) {
						pPoint = new Point(339.30,128.40);
					}

					if (m_pCardInfo[index][1] == false) {
						pNum = m_pCardInfo[index][0];
						if ((pNumResult == -1)) {
							pNumResult = 0;
						}
						pNumResult +=  computeResult(pNum);
						pNumResult %=  10;
					}
					ShowPKResult (pNumResult,2);
					pCard.ShowPkInfo (pNum,pPoint,index,m_ishost);
				}
				//庄
				if (m_bCardInfo[index] && m_bCardInfo[index].length == 2 && m_bCardInfo[index][0] > 0) {
					var bCard:PKCards = null;
					var bPoint:Point = null;
					var bNum:int = -1;

					if (m_bMcCard[index] == null) {
						bCard = new PKCards ();
						addChild (bCard);
						m_bMcCard[index] = bCard;
					} else {
						bCard = m_bMcCard[index] as PKCards;
						bCard.visible = true;
					}
					if (m_bCardInfo[index][1] && m_ishost  && m_LookCardPosition>0) {
						bCard.buttonMode = true;
						bCard.mouseEnabled = true;
						bCard.addEventListener (MouseEvent.CLICK,TurnPkb);
					}
					if (m_bCardInfo[index][1] == false) {
						bCard.buttonMode = false;
						bCard.mouseEnabled = false;
					}
					bPoint = bPkPoint[index] as Point;
					if ((bPoint == null)) {
						bPoint = new Point(339.30,128.40);
					}

					if (m_bCardInfo[index][1] == false) {
						bNum = m_bCardInfo[index][0];
						if ((bNumResult == -1)) {
							bNumResult = 0;
						}
						bNumResult +=  computeResult(bNum);
						bNumResult %=  10;
					}
					ShowPKResult (bNumResult,1);
					bCard.ShowPkInfo (bNum,bPoint,index,m_ishost);
				}
				index++;
			}
			m_isOver = true;
		}

		public function SetGameView (gameview:GameView):void {
			m_gameView = gameview;
		}

		/*
		 * 得到牌对应的点数
		 @ number 牌索引
		*/
		protected function computeResult (number:int):int {
			var pkResult:int = 0;
			pkResult = number % 13;
			if ((pkResult >= 10)) {
				pkResult = 0;
			}
			return pkResult;
		}

		/*
		 * 显示输赢背景
		 @ baccResult 游戏结果
		*/
		public function ShowResultBg (baccResult:String) {
			var m_win:String = baccResult.substr(0,3);
			//播放结果点数
			trace ("闲：" + pNumResult+ ",庄："+ bNumResult);
			if(pNumResult<0 || bNumResult<0){
				return;
			}
			if ((m_isOver == false)) {
				ShowCardResult ();
			} else {
				PlayPNum ();
				PlayBNum ();
				PlayWin (m_win);
			}
			if (((baccResult == null) || baccResult == "")) {
				return;
			}
			var resultType = int(baccResult.substr(0,1));
			var type:int = resultType == 0 ? 3:resultType;
			if ((type == 1)) {
				if (bBg) {
					bBg.alpha = 1;
					bBg.play ();
				}
			} else if ((type == 2)) {
				if (pBg) {
					pBg.alpha = 1;
					pBg.play ();
				}
			} else {
				HideResultBg ();
				type = 3;
			}

		}
		//播放庄点数
		public function PlayBNum ():void {
			var bNum:String = "1" + String(bNumResult);
			m_gameView.PlaySound (SoundConst.GameResoult,bNum);
		}
		//播放闲点数
		public function PlayPNum ():void {
			var pNum:String = "2" + String(pNumResult);
			m_gameView.PlaySound (SoundConst.GameResoult,pNum);
		}
		//播放输赢
		public function PlayWin (win:String):void {
			m_gameView.PlaySound (SoundConst.GameWin,win);
		}
		/*
		 * 隐藏背景
		*/
		public function HideResultBg () {
			if (pBg) {
				pBg.gotoAndStop (1);
				pBg.alpha = 0;
			}
			if (bBg) {
				bBg.gotoAndStop (1);
				bBg.alpha = 0;
			}
		}
		/*
		 * 显示结果
		 @ number 结果值
		 @ type 1庄 2闲
		*/
		protected function ShowPKResult (number:int=0,type:int=0):void {
			if ((number == -1)) {
				return;
			}
			number = number == 0 ? 0:number;
			if ((type == 1)) {
				if (bResult) {
					bResult.text=String (number);
				}
			} else if ((type == 2)) {
				if (pResult) {
					pResult.text=String (number);
				}
			} else {
				if (pResult) {
					pResult.text=String (number);
				}
				if (bResult) {
					bResult.text=String (number);
				}
			}
		}
		//闲翻牌;
		protected function TurnPkp (e:MouseEvent):void {
			var pCard:PKCards = e.target as PKCards;
			var index:int = m_pMcCard.indexOf(pCard);
			if (((index < 0) || index > 2)) {
				return;
			}
			if (m_pCardInfo[index]) {
				m_pCardInfo[index][1] = false;
			}
			m_gameView.OpenCard (true,index + 1,1);
			pCard.removeEventListener (MouseEvent.CLICK,TurnPkp);
			pCard.buttonMode = false;
			ShowCardResult ();
		}
		//庄翻牌;
		protected function TurnPkb (e:MouseEvent):void {
			var bCard:PKCards = e.target as PKCards;
			var index:int = m_bMcCard.indexOf(bCard);
			if (((index < 0) || index > 2)) {
				return;
			}
			if (m_bCardInfo[index]) {
				m_bCardInfo[index][1] = false;
			}
			m_gameView.OpenCard (true,index + 1,2);
			bCard.removeEventListener (MouseEvent.CLICK,TurnPkb);
			bCard.buttonMode = false;
			ShowCardResult ();
		}
		//换牌
		public function ReplaceCard (lookCard:Boolean,number:int,index:int,type:int,LookCardPosition:int,ishost:Boolean):void {
			var cardIndex:int = index - 1;
			if ((type == 2)) {
				var bpkc:PKCards = m_bMcCard[cardIndex] as PKCards;
				if (bpkc) {
					removeChild (bpkc);
				}
				m_bMcCard[cardIndex] = null;
			}
			if ((type == 1)) {
				var ppkc:PKCards = m_pMcCard[cardIndex] as PKCards;
				if (ppkc) {
					removeChild (ppkc);
				}
				m_pMcCard[cardIndex] = null;
			}
			ShowPK (lookCard,number,index,type,LookCardPosition,ishost);
		}
		public function SetLang (strlang:String):void {
			m_lang = strlang;
			bFont.SetLang (m_lang);
			pFont.SetLang (m_lang);
		}
		//存储cookie值
		public function GetCardInfo ():String {
			var index:int = 0;
			var strb:String = "";
			var strp:String = "";
			if (m_bCardInfo) {
				for (index; index < m_bCardInfo.length; index++) {
					if(m_bCardInfo[index]){
					m_bCardInfo[index]=m_bCardInfo[index].join ("|");
					}
				}
				strb = m_bCardInfo.join(",");
				index = 0;
			}
			if (m_pCardInfo) {
				for (index; index < m_pCardInfo.length; index++) {
					if(m_pCardInfo[index]){
					m_pCardInfo[index]=m_pCardInfo[index].join ("|");
					}
				}
				strp = m_pCardInfo.join(",");
			}
			var str:String=strp + "#" + strb+"#"+m_LookCardPosition
			return str;

		}
	}
}