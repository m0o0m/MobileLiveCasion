package {
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import GameModule.Common.ChipHeapView;
	import GameModule.Common.Button.ButtonConfirm;
	import GameModule.Common.Button.ButtonBack;
	import GameModule.Common.Button.ButtonRepeat;
	import GameModule.Common.Button.ButtonCancel;
	import GameModule.Common.GameBaseView;
	
	import IGameFrame.IChipViewPane;

	public class BetPosForInsurance extends MovieClip implements IChipViewPane {
		protected var m_btnPlayer:MovieClip;//闲保险投注
		protected var m_btnBanker:MovieClip;//庄保险投注
		protected var m_Confirm:MovieClip;//确认按钮
		protected var m_Back:MovieClip;//撤消按钮
		protected var m_Repet:MovieClip;//重复投注按钮
		protected var m_Cancel:MovieClip;//取消按钮

		protected var m_gameView:GameView;
		protected var m_Chair:int;//椅子号
		protected var m_chippoint:Point;//筹码坐标
		protected var m_chipheapList:Array;//筹码堆
		protected var m_odds:Number;//当前赔率
		protected var m_oddList:Array = [1.5,2,3,4,8,9];//赔率数组
		protected var m_oddindex:int;//赔率当前帧

		protected var m_Player:Array;//闲投注总额
		protected var m_Blanker:Array;//庄投注总额
		protected var m_limit:Array;//限额

		protected var m_wBetPos:int;
		public function BetPosForInsurance () {
			// constructor code
			if (this.getChildByName("btn_player")) {
				m_btnPlayer = this["btn_player"];
				m_btnPlayer.stop ();
			}
			if (this.getChildByName("btn_banker")) {
				m_btnBanker = this["btn_banker"];
				m_btnBanker.stop ();
			}
			if (this.getChildByName("mc_podd")) {
				this["mc_podd"].visible=false;
			}
			if (this.getChildByName("mc_bodd")) {
				this["mc_bodd"].visible=false;
			}
			InitButton ();
		}
		public function SetGameView (gameview:GameView):void {
			m_gameView = gameview;
		}
		public function SetChair (chair:int):void {
			m_Chair = chair;
		}
		//设置保险按钮
		public function SetInsurance (insurance:int):void {
			if (m_limit==null) {
				m_limit=new Array();
			}
			switch (insurance) {
				case 1 :
					if (m_Player==null) {
						break;
					}
					for (var index:int=0; index<m_Player.length; index++) {
						if (! m_Player[inde]) {
							m_Player[inde] = 0;
						}
						m_limit[index] = int(m_Player[index] / m_odds);
					}
					if (this.getChildByName("mc_podd")) {
							this["mc_podd"].visible = true;
							this["mc_podd"].gotoAndStop (m_oddindex);
						}
					if (m_limit[m_Chair - 1] > 0) {
						if(m_gameView){
							m_gameView.SetSelctChipView();
						}
						this.visible = true;
						m_btnPlayer.buttonMode = true;
						m_btnPlayer.stop();
						m_btnPlayer.mouseEnabled = true;
						m_btnPlayer.addEventListener (MouseEvent.CLICK,OnBetPlayer);
						m_btnPlayer.addEventListener (MouseEvent.MOUSE_OVER,ShowMouseEvent);
						m_btnPlayer.addEventListener (MouseEvent.MOUSE_OUT,HideMouseEvent);
						m_wBetPos = BetPosition.PlayerInsurance;
					}
					break;
				case 2 :
					if (m_Blanker==null) {
						break;
					}
					for (var inde:int=0; inde<m_Blanker.length; inde++) {
						if (! m_Blanker[inde]) {
							m_Blanker[inde] = 0;
						}
						m_limit[inde] = int(m_Blanker[inde] / m_odds);
					}
					if (this.getChildByName("mc_bodd")) {
							this["mc_bodd"].visible = true;
							this["mc_bodd"].gotoAndStop (m_oddindex);
						}
					if (m_limit[m_Chair - 1] > 0) {
						if(m_gameView){
							m_gameView.SetSelctChipView();
						}
						this.visible = true;
						m_btnBanker.buttonMode = true;
						m_btnBanker.mouseEnabled = true;
						m_btnBanker.stop();
						m_btnBanker.addEventListener (MouseEvent.CLICK,OnBetBanker);
						m_btnBanker.addEventListener (MouseEvent.MOUSE_OVER,ShowMouseEvent);
						m_btnBanker.addEventListener (MouseEvent.MOUSE_OUT,HideMouseEvent);
						m_wBetPos = BetPosition.BankerInsurance;
						
					}
					break;
			}
		}
		//设置赔率
		public function SetOdds (odds:Number):void {
			m_odds = odds;
			var index:int = 0;
			for (index; index<m_oddList.length; index++) {
				if (m_odds==m_oddList[index]) {
					m_oddindex = index + 1;
					return;
				}
			}
		}
		//初始化投注影片剪辑
		public function ResetBetPos ():void {
			if (m_btnPlayer) {
				m_btnPlayer.buttonMode = false;
				m_btnPlayer.mouseEnabled = false;
				m_btnPlayer.gotoAndStop(1);
				if (m_btnPlayer.hasEventListener(MouseEvent.CLICK)) {
				m_btnPlayer.removeEventListener (MouseEvent.CLICK,OnBetPlayer);
				m_btnPlayer.removeEventListener (MouseEvent.MOUSE_OVER,ShowMouseEvent);
				m_btnPlayer.removeEventListener (MouseEvent.MOUSE_OUT,HideMouseEvent);
			}
			}
			if (m_btnBanker) {
				m_btnBanker.buttonMode = false;
				m_btnBanker.mouseEnabled = false;
				m_btnBanker.gotoAndStop(1);
				if (m_btnBanker.hasEventListener(MouseEvent.CLICK)) {
				m_btnBanker.removeEventListener (MouseEvent.CLICK,OnBetBanker);
				m_btnBanker.removeEventListener (MouseEvent.MOUSE_OVER,ShowMouseEvent);
				m_btnBanker.removeEventListener (MouseEvent.MOUSE_OUT,HideMouseEvent);
			}
			}
			if (m_chipheapList) {
				for (var key in m_chipheapList) {
					if(m_chipheapList[key].numChildren>0){
						m_chipheapList[key].ClearChipPane ();
						removeChild (m_chipheapList[key]);
					}
				}
				m_chipheapList = null;
			}
			if (m_limit) {
				m_limit = null;
			}
			
			this.visible = false;
		}
		//闲保险投注
		protected function OnBetPlayer (e:MouseEvent):void {
			m_gameView.OnBet (BetPosition.PlayerInsurance);
		}
		//庄保险投注
		protected function OnBetBanker (e:MouseEvent):void {
			m_gameView.OnBet (BetPosition.BankerInsurance);
		}
		//鼠标移上
		protected function ShowMouseEvent (e:MouseEvent):void {
			var m_clip:MovieClip = e.target as MovieClip;
			m_clip.gotoAndStop (11);
			if (m_clip==m_btnPlayer) {
				m_gameView.ShowBetPosInsurance (true,BetPosition.PlayerInsurance,m_Player[m_Chair-1],new Point(524,405));
			}
			if (m_clip==m_btnBanker) {
				m_gameView.ShowBetPosInsurance (true,BetPosition.BankerInsurance,m_Blanker[m_Chair-1],new Point(661,405));
			}
		}
		//鼠标移出
		protected function HideMouseEvent (e:MouseEvent):void {
			var m_clip:MovieClip = e.target as MovieClip;
			m_clip.gotoAndStop (1);
			if (m_clip==m_btnPlayer) {
				m_gameView.ShowBetPosInsurance (false,BetPosition.PlayerInsurance,m_Player[m_Chair-1],new Point(380,300));
			}
			if (m_clip==m_btnBanker) {
				m_gameView.ShowBetPosInsurance (false,BetPosition.BankerInsurance,m_Blanker[m_Chair-1],new Point(440,300));
			}
		}
		//显示筹码
		public function SetBetTotal (wChairID:int,wBetPos:int,nBetValue:Number):void {
			ShowTotal (wChairID,wBetPos,nBetValue);
			if (this.visible == false) {
				return;
			}
			if(wChairID==m_Chair){
			switch(wBetPos){
				case BetPosition.PlayerInsurance:
				m_chippoint = new Point(50,50);
				break;
				case BetPosition.BankerInsurance:
				m_chippoint = new Point(180,50);
				break;
				default:
				return;
			}
			//设置筹码坐标
			var chipHeap:ChipHeapView = null;
			if (m_chipheapList==null) {
				m_chipheapList=new Array();
			}
			if (m_chipheapList[wBetPos] == null) {
				chipHeap=new ChipHeapView(this);
				addChild (chipHeap);
				m_chipheapList[wBetPos] = chipHeap;
			} else {
				chipHeap = m_chipheapList[wBetPos] as ChipHeapView;
			}
			if (nBetValue==0) {
				chipHeap.visible = false;
			} else {
				chipHeap.alpha = 1;
				chipHeap.visible = true;
				chipHeap.mouseEnabled = false;
				chipHeap.mouseChildren = false;
				chipHeap.x = m_chippoint.x;
				chipHeap.y = m_chippoint.y;
			}
			//显示筹码
			chipHeap.ShowChip (nBetValue);
			}
		}

		public function ShowTotal (wChairID:int,wBetPos:int,nBetValue:Number):void {
			if (m_Player==null) {
				m_Player=new Array();
			}
			if (m_Blanker==null) {
				m_Blanker=new Array();
			}
			if (wBetPos==BetPosition.Player) {
				m_Player[wChairID - 1] = nBetValue;
			}
			if (wBetPos==BetPosition.Banker) {
				m_Blanker[wChairID - 1] = nBetValue;
			}
		}
		//销毁
		public function Destroy ():void {
			ResetBetPos ();
			m_gameView = null;
		}
		private function InitButton ():void {
			if (this.getChildByName("mc_confirm")) {
				m_Confirm = this["mc_confirm"];
				m_Confirm.addEventListener (MouseEvent.CLICK,Confirm);
			}
			if (this.getChildByName("mc_repet")) {
				m_Repet = this["mc_repet"];
				m_Repet.SetEnabled (false);
			}
			if (this.getChildByName("mc_back")) {
				m_Back = this["mc_back"];
				m_Back.addEventListener (MouseEvent.CLICK,GoBack);
			}
			if (this.getChildByName("mc_cancel")) {
				m_Cancel = this["mc_cancel"];
				m_Cancel.addEventListener (MouseEvent.CLICK,Cancel);
			}
			SetButtonEnabled (false);
		}
		protected function Confirm (e:MouseEvent):void {
			if (m_gameView) {
				m_gameView.OnSendBet (e);
			}
		}
		protected function GoBack (e:MouseEvent):void {
			if (m_gameView) {
				m_gameView.BackBetChips (e);
			}
		}
		protected function Cancel (e:MouseEvent):void {
			if (m_gameView) {
				m_gameView.CancelBet (e);
			}
		}
		public function SetButtonEnabled (bool:Boolean):void {
			if (this.visible == false) {
				return;
			}
			if (m_Confirm) {
				m_Confirm.SetEnabled (bool);
			}
			if (m_Back) {
				m_Back.SetEnabled (bool);
			}
			if (m_Cancel) {
				m_Cancel.SetEnabled (bool);
			}
		}
		public function ResetBet():void{
			m_Player=null;
			m_Blanker=null;
			
		}
		public function GetChipView(index:int):MovieClip {
			var gbv:GameBaseView = this.parent as GameBaseView;
			return gbv.GetChipView(index);
		}
	}
}