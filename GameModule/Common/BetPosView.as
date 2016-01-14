package GameModule.Common{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;

	public class BetPosView extends MovieClip {
		protected var m_BetPosManager:BetPosBaseManager;//投注管理

		protected var m_BetPosIndex:int = 0;//投注位置
		protected var m_BetPosName:String = "";//投注位置名字

		protected var m_BetStatus:Boolean = false;//是否在投注时间

		protected var m_wOwnIndex:uint = 1;//不能投注

		protected var m_MouseoutIndex:uint = 1;//鼠标移出
		protected var m_MouseoverIndex:uint = 2;//鼠标移上

		protected var m_BetTatol:Number = 0;
		public function BetPosView () {
			stop();
			this.addEventListener (MouseEvent.CLICK, OnBet);
			this.addEventListener (MouseEvent.MOUSE_OVER, OnMouseOver);
			this.addEventListener (MouseEvent.MOUSE_OUT, OnMouseOut);

			stop ();
		}
		public function Destroy ():void {
			this.removeEventListener (MouseEvent.CLICK, OnBet);
			this.removeEventListener (MouseEvent.MOUSE_OVER, OnMouseOver);
			this.removeEventListener (MouseEvent.MOUSE_OUT, OnMouseOut);
		}
		public function SetBetPosManager (betPosManager:BetPosBaseManager):void {
			m_BetPosManager = betPosManager;
		}
		public function SetBetPosIndex (betPosIndex:int):void {
			m_BetPosIndex = betPosIndex;
		}
		public function SetMouseoutIndex (mouseoutIndex:int):void {
			m_MouseoutIndex = mouseoutIndex;
		}
		public function SetMouseoverIndex (mouseoverIndex:int):void {
			m_MouseoverIndex = mouseoverIndex;
		}
		//播放赢动画
		public function PlayWin ():void {
			this.play ();
		}
		public function StopWin ():void {
			this.gotoAndStop (1);
		}
		//设置投注状态
		public function SetBetStatus (betStatus:Boolean):void {
			m_BetStatus = betStatus;
			gotoAndStop (m_MouseoutIndex);

			if (m_BetStatus) {
				this.buttonMode = true;
			} else {
				this.buttonMode = false;
				m_BetTatol=0;
			}

		}
		//鼠标移上
		protected var isOver:Boolean=false;
		protected function OnMouseOver (event:MouseEvent):void {
			if (m_BetStatus) {
				this.gotoAndStop (m_MouseoverIndex);
				if (m_BetPosManager) {
					m_BetPosManager.SetPlayBetOver (m_BetPosName);
					m_BetPosManager.ShowBetPos (true,m_BetPosIndex,m_BetTatol);
				}
				isOver=true;
			}


		}
		//鼠标移出
		protected function OnMouseOut (event:MouseEvent):void {
			if (m_BetStatus) {
				this.gotoAndStop (m_MouseoutIndex);
				if (m_BetPosManager) {
					m_BetPosManager.SetPlayBetOut (m_BetPosName);
					m_BetPosManager.ShowBetPos (false,m_BetPosIndex,m_BetTatol);
				}
				isOver=false;
			}
		}
		protected function OnBet (event:MouseEvent):void {
			if (m_BetStatus == false) {
				return;
			}
			m_BetPosManager.OnBet (m_BetPosIndex);
		}
		public function SetViewInsurance (insurance:int,limit:int):void {
			if (insurance==0) {//庄，闲，和，庄对，闲对可用，庄保险，闲保险不可用
				ViewButtonMode (true,false,false);
			} else if (insurance==1) {
				if (limit==0) {
					ViewButtonMode (false,false,false);
				} else {//闲保险可用
					ViewButtonMode (false,false,true);
				}

			} else if (insurance==2) {
				if (limit==0) {
					ViewButtonMode (false,false,false);
				} else {//庄保险可用
					ViewButtonMode (false,true,false);
				}
			}
		}
		/*投注位置是否可用
		 *@nomal：一般投注位置，true可用
		 *@binsurance：庄保险位置，true可用
		 *@pinsurance：闲保险位置，true可用
		*/
		public function ViewButtonMode (nomal:Boolean,binsurance:Boolean,pinsurance:Boolean):void {
			switch (m_BetPosIndex) {
				case 1 :
				case 2 :
				case 3 :
				case 4 :
				case 5 :
					SetBetStatus (nomal);
					break;
				case 9 :
					SetBetStatus (binsurance);
					break;
				case 8 :
					SetBetStatus (pinsurance);
					break;
			}
		}
		public function GetPoint ():Array {
			return [(this.x+this.width/2),(this.y+this.height/3)];
		}
		public function ShowBetTotal (bettotal:Number):void {
			m_BetTatol = bettotal;
			if (m_BetPosManager && isOver) {
				m_BetPosManager.ShowBetPos (true,m_BetPosIndex,m_BetTatol);
			}
		}
	}
}