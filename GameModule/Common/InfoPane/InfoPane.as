package GameModule.Common.InfoPane{
	import flash.display.MovieClip;
	import flash.display.DisplayObject;
	import GameModule.Common.GameBaseView;

	public class InfoPane extends MovieClip {
		public var m_mcTopPane:InfoPaneTopPane;
		public var m_mcBottomPane:InfoPaneBottomPane;

		protected var m_mcBottom:MovieClip;
		protected var m_mcMask:MovieClip;

		protected var m_gameView:GameBaseView;
		/**
		 * @
		 * @
		 * @
		 * @是否可以伸缩
		 */
		public function InfoPane (topHeight:int,minBottomHeigth:int,maxBottomHeigth:int,expression:Boolean,_width:Number) {
			m_mcBottom = new MovieClip  ;
			addChild (m_mcBottom);
			m_mcBottom.y = topHeight;

			m_mcMask = new MovieClip  ;
			m_mcMask.graphics.beginFill (0x000000);
			m_mcMask.graphics.drawRect (0,0,_width,maxBottomHeigth + minBottomHeigth);
			m_mcMask.graphics.endFill ();
			addChild (m_mcMask);
			m_mcMask.y = topHeight;
			m_mcBottom.mask = m_mcMask;

			m_mcTopPane = new InfoPaneTopPane(topHeight,_width);
			addChild (m_mcTopPane);
			if ((topHeight <= 0)) {
				m_mcTopPane.visible = false;
			}

			m_mcBottomPane = new InfoPaneBottomPane(minBottomHeigth,maxBottomHeigth,expression,_width);
			//m_mcBottomPane.SetInfoPane(this);
			m_mcBottom.addChild (m_mcBottomPane);
			m_mcBottomPane.y = 0;
		}
		public function addChildByTop (mc:DisplayObject,mcX:int,mcY:int):void {
			m_mcTopPane.addChild (mc);
			mc.x = mcX;
			mc.y = mcY;
		}
		public function addChildByBottom (mc:DisplayObject,mcX:int,mcY:int):void {
			m_mcBottomPane.addChild (mc);
			mc.x = mcX;
			mc.y = mcY;
		}
		public function Destroy ():void {
			if (m_mcTopPane) {
				var index:int = m_mcTopPane.numChildren;
				while ((index > 0)) {
					m_mcTopPane.removeChild (m_mcTopPane.getChildAt(0));
					index--;
				}
				removeChild (m_mcTopPane);
				m_mcTopPane.Destroy ();
				m_mcTopPane = null;
			}
			if (m_mcBottom) {
				if (m_mcBottomPane) {
					index = m_mcBottomPane.numChildren;
					while ((index > 0)) {
						m_mcBottomPane.removeChild (m_mcBottomPane.getChildAt(0));
						index--;
					}

					m_mcBottom.removeChild (m_mcBottomPane);
					m_mcBottomPane.Destroy ();
					m_mcBottomPane = null;
				}
				removeChild (m_mcBottom);
				m_mcBottom = null;
			}
			if (m_mcMask) {
				removeChild (m_mcMask);
				m_mcMask = null;
			}
			m_gameView = null;
		}
		//如何显示

		public function MovePane (bool:Boolean):void {
			if (m_mcBottomPane) {
				m_mcBottomPane.MovePane (bool);
			}
		}

		public function SetGameView (gameview):void {
			m_gameView = gameview;
		}

		public function BetPosLimit (betlimitByPos:Array,minbetposlimit:Array):void {
			if (m_gameView) {
				m_gameView.BetPosLimit (betlimitByPos,minbetposlimit);
			}
		}

		public function BetPosPoint (arrpoint:Array):void {
			if (m_gameView) {
				m_gameView.BetPosPoint (arrpoint);
			}
		}

		public function ShowBetPos (isShow:Boolean,w_BetPos:int,bettotal:Number):void {
			if (m_gameView) {
				m_gameView.ShowBetPos (isShow,w_BetPos,bettotal);
			}
		}

		public function OnBet (betPosIndex:int):void {
			if (m_gameView) {
				m_gameView.OnBet (betPosIndex);
			}
		}
		public function GetChipView (index:int):MovieClip {
			if (m_gameView) {
				return m_gameView.GetChipView(index);
			}
			return null;
		}
		//点击关闭按钮效果
		/*public function HideInfoPane():void{
		if(m_gameView){
		m_gameView.RightInfoChange(3);//没有选中任何
		}
		HideVisible();
		}
		//隐藏
		public function HideVisible():void{
		if(m_mcBottom){
		m_mcBottom.visible=false;
		}
		}
		//显示
		public function ShowBottom():void{
		if(m_mcBottom){
		m_mcBottom.visible=true;
		}
		}*/

	}
}