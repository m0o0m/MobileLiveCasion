package {
	import flash.display.MovieClip;
	import flash.utils.ByteArray;
	import flash.geom.Point;
	import flash.utils.setTimeout;

	import CommandProtocol.*;
	import GameModule.Common.*;
	import IGameFrame.*;
	import Net.*;
	import Common.Cookie;
	public class GameClassByNomal extends GameClass {
		protected var m_LookCardIndex:Array;//牌状态存储
		protected var m_cookie:Cookie;//存储cookie值（局号，牌点数，牌状态，时间）;
		protected var b_cardinfo:Array;
		protected var p_cardinfo:Array;
		public function GameClassByNomal () {
			// constructor code
			super ();
			m_wChairCount = 7;
			m_BetPosCount = 5;
			m_isMoreTable=false;
			if (m_cookie==null) {
				m_cookie=new Cookie();
			}
		}
		/////////////////////////////////////
		/////////////////////////////////////
		//创建游戏视图
		override protected function CreateGameView ():GameBaseView {
			ReadCookie (m_tableInfo.GameRoundNo);//读取cookie值
			return new GameViewByNomal(this);
		}
		//重置游戏
		public override function ResetGameClass ():void {
			super.ResetGameClass ();
			m_LookCardIndex = null;
		}
		//销毁游戏 (有代码未实现)
		public override function DestroyGameClass ():void {
			WriteCookie ();//写入cookie值
			super.DestroyGameClass ();
			if (m_LookCardIndex) {
				m_LookCardIndex = null;
			}
			if (m_cookie) {
				m_cookie = null;
			}
			if( b_cardinfo){
				b_cardinfo=null;
			}
			if( p_cardinfo){
				p_cardinfo=null;
			}
		}
		protected override function SubGameSubCmd (wSubCmdID:uint,pData:String):Boolean {
			//trace (((("wSubCmdID=" + wSubCmdID) + ";pData=") + pData));
			switch (wSubCmdID) {
				case GameForBaccarat.StartBet ://开始下注
					var startBet:cmdBaccStartBetToMember = cmdBaccStartBetToMember.FillData(pData);
					if (startBet.Insurance == 0) {
						//播放开始投注
						GetPeerGameView().PlaySound (SoundConst.StartBet,null);
						m_LookCardPosition = 0;
						//重置游戏
						if (startBet.Reset) {
							ResetGameClass ();
						}
						//显示开始投注提示框;
						GetPeerGameView().ShowTableMessage (MessageType_Table,MT_Table_StartBetting);
					}
					//设置投注位置可以投注;
					GetPeerGameView().SetBetStatus (true);
					//设置游戏状态;
					SetGameStatus (1);
					//计时
					GetPeerGameView().ShowBetTime (startBet.BetTime,startBet.DiffTime);
					//保险;
					if (startBet.Insurance > 0) {
						if (startBet.Insurance == 1) {
							//显示闲保险投注提示框;
							GetPeerGameView().ShowTableMessage (MessageType_Table,MT_PlayerInsurance_StartBetting);
						}
						if (startBet.Insurance == 2) {
							//显示庄保险投注提示框;
							GetPeerGameView().ShowTableMessage (MessageType_Table,MT_BankerInsurance_StartBetting);
						}
						m_LookCardPosition = 2;
						GetPeerGameView().SetOdds (startBet.Odds);
					}
					GetPeerGameView().SetInsurance (startBet.Insurance);
					m_Insurance = startBet.Insurance;
					m_endResult = true;
					//变更椅子
					GetPeerGameView().StartChangeChair();
					break;
				case GameForBaccarat.StopBet ://停止下注
					//播放停止投注
					GetPeerGameView().PlaySound (SoundConst.StopBet,null);
					//设置游戏状态;
					SetGameStatus (0);
					//清理投注还没有投注筹码
					CancelBetChips ();


					if (m_Insurance==0) {
						SaveRepeatBetList ();
						//创建PK显示
						GetPeerGameView().ShowPkManager ();
					}
					//设置投注按钮不可用;
					GetPeerGameView().SetBetStatus (false);

					//显示结算中;
					GetPeerGameView().BetOver ();
					m_LookCardPosition = ConfirmLookPosition();
					//显示提示框;
					GetPeerGameView().ShowTableMessage (MessageType_Table,MT_Table_StopBetting);
					break;
				case GameForBaccarat.NextRound ://下一轮
					if ((pData == "0")) {

					}
					break;
				case GameForBaccarat.CardInfo ://开结果
					var cardInfo:cmdBaccCardInfo = cmdBaccCardInfo.FillData(pData);
					if (cardInfo) {
						if (m_tableInfo.GameKind == GameKindEnum.ShareLookBaccarat){ //&& m_LookCardPosition > 0) {
							ShowLookPkCard (cardInfo);
							ShowNotLook (cardInfo.Position);
						} else {
							GetPeerGameView().ShowPk (cardInfo.IsLookCard,cardInfo.CardNum,cardInfo.Index,cardInfo.Position,m_LookCardPosition,m_isHost);
						}
					} else {
						GetPeerGameView().ReplaceCard (cardInfo.IsLookCard,cardInfo.CardNum,cardInfo.Index,cardInfo.Position,m_LookCardPosition,m_isHost);
					}
					break;
				case GameForBaccarat.OpenResult ://开结果
					break;
				case GameForBaccarat.BaccResult ://开结果
					//pk堆显示输赢
					var baccResult:cmdBaccResult = cmdBaccResult.FillData(pData);
					if (baccResult) {
						GetPeerGameView().ShowResult (baccResult.RoadInfo);
					}
					//赢的地方闪烁;
					PlayWin (baccResult.RoadInfo);
					break;
				case GameForBaccarat.EndResult ://结算完成
					GetPeerGameView().ShowAllCardInfo ();
					//移动筹码;
					OpenAllLookCard ();
					m_GameClientView.StartMove ();
					if (pData=="0") {
						m_endResult = false;
						m_GameClientView.HideResultBg ();
						m_GameClientView.GameBack ();
						ReturnBack ();
						GetPeerGameView().ShowTableMessage (MessageType_Table,MT_GameBack);
					}
					break;
				case GameForBaccarat.LookCard :
					break;
				case GameForBaccarat.ChangeBoot :
					//播放更换牌靴
					GetPeerGameView().PlaySound (SoundConst.ChangeBoot,null);
					if ((pData == "0")) {

					}
					break;
				case GameForBaccarat.ChangeDealer :
					if ((pData == "0")) {

					}
					break;
			}
			return true;
		}
		//眯牌翻开
		public override function SendLookCard (data:String,openCard:Boolean,index:int,position:int):void {
			if (m_LookCardIndex==null) {
				m_LookCardIndex=new Array();
			}
			if (position==m_LookCardPosition) {
				m_LookCardIndex[index - 1] = openCard;
			}
			if (openCard) {
				switch (position) {
					case 2 :
						GetPeerGameView().ShowBCardInfo (index);
						break;
					case 1 :
						GetPeerGameView().ShowPCardInfo (index);
						break;
				}
			}
			ShowNotLook (position);
		}
		//点击小牌翻开
		public override function OpenCard (openCard:Boolean,index:int,position:int):void {
			if (m_LookCardIndex==null) {
				m_LookCardIndex=new Array();
			}
			if (position==m_LookCardPosition) {
				GetPeerGameView().OpenMainCard (index);
				m_LookCardIndex[index - 1] = openCard;
			}
			ShowNotLook (position);
		}
		//打开不是眯牌方向的牌
		protected function ShowNotLook (position:int):void {
			if (m_LookCardIndex==null) {
				return;
			}
			if (m_LookCardIndex[0] == true && m_LookCardIndex[1] == true) {
				if(m_LookCardIndex.length>=3 && m_LookCardIndex[2]==false || (m_LookCardIndex[2] && position!=m_LookCardPosition)){
					return;
				}
				OpenNotLook ();
			}
			if (m_LookCardIndex[2] && m_LookCardIndex[2] == true) {
				OpenNotLook ();
			}
		}
		override public function OpenNotLook ():void {
			var index:int = 1;
			if(m_LookCardIndex){
			for (index; index<=m_LookCardIndex.length; index++) {
				switch (m_LookCardPosition) {
					case 2 :
						GetPeerGameView().ShowPCardInfo (index);
						break;
					case 1 :
						GetPeerGameView().ShowBCardInfo (index);
						break;
					default:
					    GetPeerGameView().ShowPCardInfo (index);
						//GetPeerGameView().ShowBCardInfo (index);
						break;
				}
			}
			}
		}
		//确定眯牌方向
		protected function ConfirmLookPosition ():int {
			if (m_BetTotalList) {
				if (m_BetTotalList[BetPosition.Banker] && m_BetTotalList[BetPosition.Player] && m_BetTotalList[BetPosition.Banker][0] && m_BetTotalList[BetPosition.Player][0]) {
					return 0;
				}
				if (m_BetTotalList[BetPosition.Banker] && m_BetTotalList[BetPosition.Banker][0]) {
					return 2;
				}
				if (m_BetTotalList[BetPosition.Player] && m_BetTotalList[BetPosition.Player][0]) {
					return 1;
				}

			}
			return 0;
		}
		//超时翻开所有眯牌
		protected function OpenAllLookCard ():void {
			var index:int = 0;
			if (m_LookCardIndex) {
				for (index; index<=m_LookCardIndex.length; index++) {
					if (m_LookCardIndex[index] == false) {
						OpenCard (true,index+1,m_LookCardPosition);
					}
				}
			}
		}
		//在创建眯牌时写入cookie
		protected function WriteCookie ():void {
			if (m_cookie) {
				var str:String = GetPeerGameView().GetCardInfo();
				m_cookie.WriteCookie (m_tableInfo.GameRoundNo,str);
			}
		}
		//在创建视图时加载cookie
		protected function ReadCookie (key):void {
			var str:String = "";
			if (m_cookie) {
				str = m_cookie.ReadCookie(key);
			}
			//测试数据
			//str = "32|false,13|true#34|false#2";
			if (str=="" ||str==null) {
				return;
			}
			var cardInfo:Array = str.split("#");
			if (cardInfo.length == 3) {
				if (b_cardinfo==null) {
					b_cardinfo=new Array();
				}
				b_cardinfo = cardInfo[0].split(",");
				if (p_cardinfo==null) {
					p_cardinfo=new Array();
				}
				p_cardinfo = cardInfo[1].split(",");
				m_LookCardPosition = cardInfo[2];
			}
			var index:int = 0;
			for (index; index<p_cardinfo.length; index++) {
				p_cardinfo[index] = p_cardinfo[index].split("|");
			}
			index = 0;
			for (index; index<b_cardinfo.length; index++) {
				b_cardinfo[index] = b_cardinfo[index].split("|");
			}

		}
		protected function ShowLookPkCard (cardInfo:cmdBaccCardInfo ):void {
			if (cardInfo.Index == 3) {
				OpenAllLookCard ();//发第三张牌时前面所有牌翻开
				/*if(m_LookCardPosition==0){
					GetPeerGameView().ShowAllCardInfo ();
				}*/
			}
			var iSopen:Boolean = true;
			if (cardInfo.Position == 1 && b_cardinfo && b_cardinfo[cardInfo.Index - 1]) {
				if (b_cardinfo[cardInfo.Index - 1][1] == "false") {
					iSopen = false;
				}

			}
			if (cardInfo.Position == 2 && p_cardinfo && p_cardinfo[cardInfo.Index - 1]) {
				if (p_cardinfo[cardInfo.Index - 1][1] == "false") {
					iSopen = false;
				}
			}
			if (iSopen && m_tableInfo.Status==3) {
				if (m_LookCardPosition==cardInfo.Position || (m_LookCardPosition==0 && cardInfo.Position==2) || 
					(m_LookCardPosition!=cardInfo.Position && cardInfo.Index==3 )) {
					if (cardInfo.Index == 2 || cardInfo.Index == 1) {
						GetPeerGameView().SetLookCardDiffTime (20);
					}
					if (cardInfo.Index == 3) {
						GetPeerGameView().SetLookCardDiffTime (10);
					}
					GetPeerGameView().CreaditCard (1,m_tableInfo.GameKind);
					if(m_LookCardPosition==0 ||(m_LookCardPosition!=cardInfo.Position && cardInfo.Index==3)){//不眯牌，则不显示牌,只显示时间
						GetPeerGameView().SetCardNum (cardInfo.Index,cardInfo.Position,cardInfo.CardNum,false);
					}else{
						GetPeerGameView().SetCardNum (cardInfo.Index,cardInfo.Position,cardInfo.CardNum,true);
					}
					if (m_LookCardIndex==null) {
						m_LookCardIndex=new Array();
					}
					m_LookCardIndex.push (false);
				}
				GetPeerGameView().ShowPk (true,cardInfo.CardNum,cardInfo.Index,cardInfo.Position,m_LookCardPosition,true);
			//} else {
				//GetPeerGameView().ShowPk (cardInfo.IsLookCard,cardInfo.CardNum,cardInfo.Index,cardInfo.Position,m_LookCardPosition,m_isHost);
			}else{
				if(m_LookCardPosition==0){
					GetPeerGameView().ShowPk (cardInfo.IsLookCard,cardInfo.CardNum,cardInfo.Index,cardInfo.Position,m_LookCardPosition,false);
				}else{
					GetPeerGameView().ShowPk (cardInfo.IsLookCard,cardInfo.CardNum,cardInfo.Index,cardInfo.Position,m_LookCardPosition,true);
				}
			}
		}
	}
}
include "../Common/GameMessage.as"