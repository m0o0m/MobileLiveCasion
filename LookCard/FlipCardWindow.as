package {
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import IGameFrame.IFlipCard;
	import IGameFrame.IFlipCardPane;
	import CommandProtocol.GameKindEnum;

	public class FlipCardWindow extends MovieClip implements IFlipCard {
		var m_FlipCardPane:IFlipCardPane;
		private var m_CardList:Array;
		private var m_CardPoint:Array = [[335,100],[593,100],[476,100]];//牌坐标
		private var m_CardPosition:int = 0;//庄闲
		private var m_CardType:int = 0;//桌主与普通玩家
		private var m_btnOpen:ButtonOpen;//翻牌按钮
		private var m_openlist:Array;//桌主记录翻牌
		private var m_openTlist:Array;//普通玩家记录翻牌
		protected var m_lang:String;//语言

		protected var m_gameking:int;//游戏类型
		
		protected var m_time:LookCardTime;//眯牌时间
		
		protected var isThree:Boolean = false;//判断是否为第三张牌
		
		protected var m_buttonBg:ButtonBg;
		
		public function FlipCardWindow () {
			m_CardList = new Array();
			m_openlist=new Array();
			m_openTlist=new Array();
			this.graphics.drawRect (0, 0, 1000, 500);
			this.graphics.beginFill (0x868686);
			this.graphics.endFill ();
			InitTime ();
		}

		public function SetFlipCardPane (fcPane:IFlipCardPane):void {
			m_FlipCardPane = fcPane;
		}
		public function GetMovieClip ():MovieClip {
			return this;
		}
		//销毁
		public function Destroy ():void {
			Reset ();
			m_CardList = null;
			if (m_btnOpen) {
				m_btnOpen.removeEventListener (MouseEvent.CLICK,OpenCards);
				removeChild (m_btnOpen);
				m_btnOpen = null;
			}
			if (m_time) {
				this.removeChild (m_time);
				m_time.Destroy ();
				m_time = null;
			}
			if(m_buttonBg){
				removeChild(m_buttonBg);
				m_buttonBg=null;
			}
		}
		//重置
		public function Reset ():void {
			var index:int = 0;
			while (index < m_CardList.length) {
				if (m_CardList[index] != null) {
					var card:FlipCard = m_CardList[index] as FlipCard;
					card.Destroy ();
					removeChild (card);
					card = null;
					m_CardList[index] = null;
				}
				index++;
			}
		}
		//扑克类型 (1:主控;2:被动;)
		public function SetCardType (type:int,gameKind:int):void {
			m_CardType = type;
			m_gameking = gameKind;
		}
		//扑克数字
		public function SetCardNum (cardIndex:int, cardPosition:int, cardNum:int,isShow:Boolean=true):void {
			if (cardIndex < 1 || cardIndex > 3) {
				return;
			}
			if (m_CardType==1) {//桌主创建翻牌按钮
				IntiButtonOpen (isShow);
			}
			if (cardIndex == 3) {
				isThree = true;
				if (m_time) {
					if (m_gameking==GameKindEnum.ShareLookBaccarat) {
						m_time.SetTotalTime (10);//共享眯牌时间20秒
					} else {
						m_time.SetTotalTime (30);//VIP第3张眯牌时间30秒
					}
				}
				Reset ();
			} else {
				isThree = false;
			}
			if (cardIndex==1 ||cardIndex==2) {
				if (m_time) {
					if (m_gameking==GameKindEnum.ShareLookBaccarat) {
						if(cardIndex==2){
						  m_time.SetTotalTime (20);//共享眯牌时间20秒
						}
					} else {
						m_time.SetTotalTime (60);//VIP第1,2张眯牌时间60秒
					}
				}
			}
			var index:int = cardIndex - 1;

			var card:FlipCard;

			if (m_CardList[index] != null) {
				card = m_CardList[index] as FlipCard;
				card.Destroy ();
				removeChild (card);
				card = null;
				m_CardList[index] = null;
			}

			card = new FlipCard(this);
			if (m_lang) {
				card.SetLang (m_lang);
			}
			card.SetCardType (m_CardType);
			card.SetCardNum (cardIndex, cardPosition, cardNum);
			m_CardList[index] = card;
			
			card.x = m_CardPoint[index][0];
			card.y = m_CardPoint[index][1];
			addChild (card);
			card.visible=isShow;
			if (m_CardType==1) {
				m_openlist[index] = false;
			}
			if (m_CardType==2) {
				m_openTlist[index] = false;
			}
		}
		public function SendMoveData (data:String, openCard:Boolean, index:int, position:int):void {
			m_openlist[index - 1] = openCard;
			if (isThree==false && m_openlist[0] && m_openlist[1]) {
				if(m_gameking!=GameKindEnum.ShareLookBaccarat){
					m_time.Hide ();
				}
				if (m_btnOpen) {
					m_btnOpen.visible = false;
				}
				if(m_buttonBg){
					m_buttonBg.visible=false;
				}
			}
			if (isThree && m_openlist[2] ) {
				if(m_gameking!=GameKindEnum.ShareLookBaccarat){
					m_time.Hide ();
				}
				if (m_btnOpen) {
					m_btnOpen.visible = false;
				}
				if(m_buttonBg){
					m_buttonBg.visible=false;
				}
			}
			if (m_FlipCardPane) {
				m_FlipCardPane.SendMoveData (data, openCard, index, position);
			}
		}
		public function SetMoveData (cardIndex:int, data:String):void {
			if (cardIndex < 1 || cardIndex > 3) {
				return;
			}
			var index:int = cardIndex - 1;
			if (m_CardList[index] == null) {
				return;
			}
			var card:FlipCard = m_CardList[index] as FlipCard;
			var turn:Boolean = card.SetMoveData(data);
			m_openTlist[cardIndex - 1] = turn;
			if (isThree==false && m_openTlist[0] && m_openTlist[1]) {
				if(m_gameking!=GameKindEnum.ShareLookBaccarat){
					m_time.Hide ();//第1,2张牌翻开后时间消失
				}
			}
			if (isThree && m_openTlist[2] ) {
				if(m_gameking!=GameKindEnum.ShareLookBaccarat){
					m_time.Hide ();//第3张牌翻开后时间消失
				}
			}
		}
		//创建翻牌按钮
		public function IntiButtonOpen (isShow:Boolean):void {
			if (m_btnOpen==null) {
				m_btnOpen=new ButtonOpen();
				if (m_lang) {
					m_btnOpen.IChangLang (m_lang);
				}
				m_btnOpen.x= (m_CardPoint[0][0]+169)-(m_btnOpen.width-(m_CardPoint[1][0]-m_CardPoint[0][0]-175))/2;
				m_btnOpen.y = m_CardPoint[0][1] - 70;
				addChild (m_btnOpen);
				
			}
			if(m_buttonBg==null){
				m_buttonBg=new ButtonBg();
				m_buttonBg.x=m_CardPoint[0][0]-m_buttonBg.width/2+(m_CardPoint[1][0]+169-m_CardPoint[0][0])/2;
				m_buttonBg.y=m_CardPoint[0][1] - 52;;
				addChild(m_buttonBg);
				this.setChildIndex(m_buttonBg,0);
			}
			m_buttonBg.visible=isShow;
			m_btnOpen.visible=isShow;
			m_btnOpen.addEventListener (MouseEvent.CLICK,OpenCards);
		}
		//翻牌
		public function OpenCards (e:MouseEvent):void {
			var index:int = 0;
			var card:FlipCard;
			for (index; index<m_CardList.length; index++) {
				card = m_CardList[index] as FlipCard;
				if (m_openlist[index] == false) {
					if (card) {
						card.OpenCard ();
					}
				}
			}
		}
		//创建翻牌时间
		public function InitTime ():void {
			if (m_time==null) {
				m_time=new LookCardTime();
				m_time.x = 740;
				m_time.y = 370;
				m_time.scaleX=0.5;
				m_time.scaleY=0.5;
				addChild (m_time);
				m_time.SetFlipCardWindow(this);
			}
			m_time.visible = false;
		}
		public function GetVolume (volumne:Boolean):void {
			if (m_time) {
				m_time.GetVolume (volumne);
			}
		}
		//超时自动翻牌
		public function OpenMainCard (cardIndex:int):void {
			var card:FlipCard = m_CardList[cardIndex - 1] as FlipCard;
			if (m_openlist[cardIndex - 1]) {
				return;
			}
			if (card) {
				card.OpenCard ();
			}
		}
		//咪牌剩余时间
		public function SetLookCardDiffTime (difftime:int):void {
			if (m_time) {
				m_time.SetDiffTime (difftime);
			}
		}
		//语言
		public function SetLang (strlang:String):void {
			m_lang = strlang;
		}
		//共享眯牌超时翻牌
		public function OpenTimeOutCards():void{
			var index:int=0;
			for(index;index<m_openlist.length;index++){
				if(m_openlist[index]==false){
					OpenMainCard(index+1);
				}
			}
			m_FlipCardPane.OpenNotLook();
		}
		//为满足眯牌第二张翻开后，第一张牌才消失
		public function HideFirstCard():void{
			if(m_openlist && m_openlist.length>=2){
				if(m_openlist[0] && m_openlist[1] && m_CardList && m_CardList.length>=2){
					if(m_CardList[0]){
						m_CardList[0].visible=false;
					}
					if(m_CardList[1]){
						m_CardList[1].visible=false;
					}
				}
			}
			if(m_openTlist && m_openTlist.length>=2){
				if(m_openTlist[0] && m_openTlist[1] && m_CardList && m_CardList.length>=2){
					if(m_CardList[0]){
						m_CardList[0].visible=false;
					}
					if(m_CardList[1]){
						m_CardList[1].visible=false;
					}
				}
			}
		}

	}
}