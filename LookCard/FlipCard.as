package {
	import flash.display.MovieClip;
	import flash.geom.Point;
	import flash.display.StageAlign;
	import flash.utils.setTimeout;
	import caurina.transitions.Tweener;
	import flash.events.MouseEvent;
	import flash.display.Sprite;
	import flash.events.Event;

	public class FlipCard extends MovieClip {
		private var m_fcWindow:FlipCardWindow;

		private var myFlipBook:FlipBook;
		private var myFlipBookT:FlipBookT;

		private var m_CardPane:CardPane;
		private var m_CardPaneT:CardPane;
		private var m_cardIndex:int;
		private var m_cardPosition:int;
		private var m_btnRotation:ButtonRotation;
		
		private var m_sprite:Sprite;
		protected var m_lang:String;
		
		protected var m_IsRotation:Boolean;
		
		//旋转按钮位置index=0表示0度，index=1表示旋转90度
		protected var m_ButtonPoint:Array=[[60,90],[65,90]];


		public function FlipCard (fcWindow:FlipCardWindow) {
			m_fcWindow = fcWindow;
		}
		public function GetMovieClip ():MovieClip {
			return this;
		}
		public function Destroy ():void {
			if (myFlipBook) {
				myFlipBook.removeEventListener(FlipBook.START_MOVE, onStartMove);
				myFlipBook.removeEventListener(FlipBook.END_MOVE, onEndMove);
				myFlipBook.Destory ();
				myFlipBook = null;
			}
			if (myFlipBookT) {
				myFlipBookT.Destory ();
				myFlipBookT = null;
			}
			if(m_btnRotation){
				m_btnRotation.removeEventListener (MouseEvent.CLICK,RotationCards);
				removeChild(m_btnRotation);
				m_btnRotation=null;
			}
			for (var index:int=this.numChildren-1; index>=0; index--) {
				this.removeChildAt (index);
			}
			m_fcWindow = null;
		}
		//扑克类型 (1:主控;2:被动;)
		public function SetCardType (type:int):void {
			if (type==1) {
				InitFlipbook ();
				IntiButtonRotation ();
			} else if (type==2) {
				InitFlipbookT ();
			}

		}
		//扑克数字
		public function SetCardNum (cardIndex:int, cardPosition:int, cardNum:int):void {
			m_cardIndex = cardIndex;
			m_cardPosition = cardPosition;
			if (m_CardPane) {
				m_CardPane.SetCardNum (cardNum);
			}
			if (m_CardPaneT) {
				m_CardPaneT.SetCardNum (cardNum);
			}
		}
		//主翻页
		public function InitFlipbook () {
			if(myFlipBook) {
				return;
			}
			m_sprite=new Sprite();
			m_sprite.x=80;
			m_sprite.y=100;
			addChild(m_sprite)
			myFlipBook = new FlipBook(169,251);//new新建一个FlipBook翻书实例，大小是300*450，300是单页的宽度,总宽度则为600
			myFlipBook.addEventListener(FlipBook.START_MOVE, onStartMove);
			myFlipBook.addEventListener(FlipBook.END_MOVE, onEndMove);
			m_CardPane=new CardPane();
			myFlipBook.SetFlip (this);
			myFlipBook.addPaper (new CardBack(),m_CardPane);
			//为翻书效果添加第一张"纸"(正反面)内容;
			myFlipBook.x=-84;
			myFlipBook.y=-125;
			//myFlipBook.x=-myFlipBook.width/2;
			//myFlipBook.y=-myFlipBook.height/2;
			m_sprite.addChild (myFlipBook);//翻书效果添加到舞台上，缺少这句则舞台上不显示翻书效果
		}
		//副翻页
		public function InitFlipbookT () {
			m_sprite=new Sprite();
			m_sprite.x=80;
			m_sprite.y=100;
			addChild(m_sprite)
			myFlipBookT = new FlipBookT(169,251);//new新建一个FlipBook翻书实例，大小是300*450，300是单页的宽度,总宽度则为600
			m_CardPaneT=new CardPane();
			myFlipBookT.addPaper (new CardBack(),m_CardPaneT);
			//为翻书效果添加第一张"纸"(正反面)内容;
            //翻书效果添加到舞台上，缺少这句则舞台上不显示翻书效果
			myFlipBookT.x=-84;
			myFlipBookT.y=-125;
			m_sprite.addChild (myFlipBookT);
		}
		protected var m_istrun:Boolean;
		public function SetData (data:String,isturn:Boolean) {
			if (m_fcWindow) {
				m_fcWindow.SendMoveData (data, isturn, m_cardIndex, m_cardPosition);
			}
			if (m_CardPane) {
				m_CardPane.RemoveShadow (isturn);
			}
			m_istrun = isturn;
			if (isturn==true) {
				if(m_btnRotation){
					m_btnRotation.visible=false;
				}
				if(m_cardIndex>2){//第三张牌直接消失
					setTimeout (HideFlipBook,2000);
				}else{
					if(m_fcWindow){//判断第一二两张牌是否全部翻开后消失
						setTimeout(m_fcWindow.HideFirstCard,2000);
					}
				}
				// HideFlipBook();
			}
		}
		public function SetMoveData (data:String):Boolean{
			var arr:Array=data.split("|");
			if(arr[5]){
				if(arr[5]=="false"){
					m_sprite.rotation=90;
				}
				if(arr[5]=="true"){
					m_sprite.rotation=0;
				}
				
			}
			var isturn:Boolean = myFlipBookT.GetData(data);
			if (isturn) {
				if(m_cardIndex>2){
					setTimeout (HideFlipBookT,2000);
				}else{
					if(m_fcWindow){
						setTimeout(m_fcWindow.HideFirstCard,2000);
					}
				}
			}
			if (m_CardPaneT) {
				m_CardPaneT.RemoveShadow (isturn);
			}
			return isturn;
		}
		public function HideFlipBook ():void {
			if (myFlipBook) {
				myFlipBook.visible = false;
				//Tweener.addTween (myFlipBook, { x:m_monModeX, y: 0,alpha:0,scaleX:0.5,scaleY:0.5, time: 1, onComplete:MoveComplete, onCompleteParams:[true] });
			}
			if(m_btnRotation){
				m_btnRotation.visible=false;
			}
		}
		public function HideFlipBookT ():void {
			if (myFlipBookT) {
				myFlipBookT.visible = false;
				//Tweener.addTween (myFlipBook, { x:m_monModeX, y: 0,alpha:0,scaleX:0.5,scaleY:0.5, time: 1, onComplete:MoveComplete, onCompleteParams:[true] });
			}
		}
		public function OpenCard ():void {
			if (myFlipBook) {
				myFlipBook.OpenCard ();
			}
		}
		public function RotateFlipBook ():void {
			if (myFlipBook) {
				myFlipBook.rotation = 90;
			}
			if (m_CardPane) {
				m_CardPane.rotation = 90;
			}
		}
		public function RotateFlipBookT ():void {
			if (myFlipBookT) {
				myFlipBookT.rotation = 90;
			}
			if (m_CardPaneT) {
				m_CardPaneT.rotation = 90;
			}
		}
		public function IntiButtonRotation ():void {
			if (m_btnRotation==null) {
				m_btnRotation=new ButtonRotation();
				if (myFlipBook) {
					m_btnRotation.x =m_ButtonPoint[0][0];
					m_btnRotation.y =m_ButtonPoint[0][1];
				}
				addChild (m_btnRotation);
				

			}
			if(m_lang){
				   m_btnRotation.IChangLang(m_lang);
				}
			m_IsRotation=false;
			m_btnRotation.addEventListener (MouseEvent.CLICK,RotationCards);
		}
		protected var chang:Boolean=true;
		public function RotationCards (e:MouseEvent):void {
			if (m_sprite) {
			 if(chang){
				m_sprite.rotation = 90;
				chang=false;
			 }else{
				 m_sprite.rotation = 0;
				 chang=true;
			 }
			}
			m_IsRotation=!m_IsRotation;
			var m_button:ButtonRotation=e.target as ButtonRotation;
			if(m_IsRotation){
				m_button.x=m_ButtonPoint[1][0];
				m_button.y=m_ButtonPoint[1][1];
			}else{
				m_button.x=m_ButtonPoint[0][0];
				m_button.y=m_ButtonPoint[0][1];
			}
			var str:String="|||||"+chang;
			SetData(str,false);
		}
		public function SetLang(strlang:String):void{
			m_lang=strlang;
			if(m_btnRotation){
				   m_btnRotation.IChangLang(m_lang);
			}
		}
		private function onStartMove(e:Event):void {
			if(m_istrun) {
				return;
			}
			if (myFlipBook && myFlipBook.visible && m_btnRotation) {
				m_btnRotation.visible=false;
			}
		}
		private function onEndMove(e:Event):void {
			if(m_istrun) {
				return;
			}
			if (myFlipBook && myFlipBook.visible && m_btnRotation) {
				m_btnRotation.visible=true;
			}
		}
	}
}//设置翻页点;