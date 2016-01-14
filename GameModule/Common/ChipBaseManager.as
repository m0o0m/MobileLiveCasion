package GameModule.Common{
	import flash.display.MovieClip;
	import flash.text.TextField;
	import flash.geom.Point;

	import caurina.transitions.Tweener;
	import CommandProtocol.*;
	
	import IGameFrame.IChipViewPane;

	/**
	 * 筹码管理
	 * @椅子号从1开始, 索引从0开始
	 * @投注位置从1开始, 索引从0开始
	 */
	public class ChipBaseManager extends MovieClip implements IChipViewPane {
		protected var m_BetPosCount:int;//投注位置总数

		protected var m_chipHeapList:Array;//筹码堆数组(2维数组,1维索引表示椅子,2维索引表示投注位置)
		protected var m_winChipHeapList:Array;//赢筹码堆数组(2维数组,1维索引表示椅子,2维索引表示投注位置)
		protected var m_BankerPoint:Point;//庄家筹码位置
		protected var m_chipPoint:Array;//筹码位置(2维数组,1维索引表示椅子,2维索引表示投注位置)
		protected var m_winChipPoint:Array;//赢筹码位置(2维数组,1维索引表示椅子,2维索引表示投注位置)
		protected var m_moveChipPoint:Array;//移动到会员筹码位置(2维数组,1维索引表示椅子,2维:表示赢筹码移动结束位置.) [[0,0],[1,1]]
		protected var m_chipHeapIndex:Array;//筹码层次索引

		protected var m_winAlpha:Number = 1;//移动赢透明度
		protected var m_moveTime:Number = 2;//移动时间(单位秒)
		private var m_winChips:Array;
		private var m_loseChips:Array;
		private var m_drawChips:Array;
		
		private var m_isStart:Boolean;//确定只移动一次

		public function ChipBaseManager () {
			stop();
			this.mouseEnabled = false;
			this.mouseChildren = false;
			m_chipHeapList = new Array();
			m_winChipHeapList = new Array();
		}
		//销毁
		public function Destroy ():void {
			if (m_winChips) {
				m_winChips = null;
			}
			if (m_loseChips) {
				m_winChips = null;
			}
			if (m_drawChips) {
				m_drawChips = null;
			}

			var index:int = 0;
			while (index < m_chipHeapList.length) {
				if (m_chipHeapList[index]) {
					var childIndex:int = 0;
					while (childIndex < m_chipHeapList[index].length) {
						var chipHeap:ChipHeapView = m_chipHeapList[index][childIndex] as ChipHeapView;
						Tweener.removeTweens (chipHeap);
						if (chipHeap) {
							chipHeap.Destroy ();
							removeChild (chipHeap);
							chipHeap = null;
						}
						childIndex++;
					}
				}
				index++;
			}

			index = 0;
			while (index < m_chipHeapList.length) {
				if (m_winChipHeapList[index]) {
					childIndex = 0;
					while (childIndex < m_winChipHeapList[index].length) {
						chipHeap = m_winChipHeapList[index][childIndex] as ChipHeapView;
						Tweener.removeTweens (chipHeap);
						if (chipHeap) {
							chipHeap.Destroy ();
							removeChild (chipHeap);
							chipHeap = null;
						}
						childIndex++;
					}
				}
				index++;
			}

			m_chipHeapList = null;
			m_winChipHeapList = null;
			m_BankerPoint = null;
			m_chipPoint = null;
			m_winChipPoint = null;
			m_moveChipPoint = null;
		}
		//清除筹码
		public function ClearChips ():void {
			if (m_winChips) {
				m_winChips = null;
			}
			if (m_loseChips) {
				m_loseChips = null;
			}
			if (m_drawChips) {
				m_drawChips = null;
			}
			var index:int = 0;
			while (index < m_chipHeapList.length) {
				if (m_chipHeapList[index]) {
					var childIndex:int = 0;
					while (childIndex < m_chipHeapList[index].length) {
						var chipHeap:ChipHeapView = m_chipHeapList[index][childIndex] as ChipHeapView;
						Tweener.removeTweens (chipHeap);
						if (chipHeap) {
							chipHeap.ShowChip (0);
							chipHeap.alpha = 0;
							chipHeap.visible = false;
						}
						childIndex++;
					}
				}
				index++;
			}

			index = 0;
			while (index < m_chipHeapList.length) {
				if (m_winChipHeapList[index]) {
					childIndex = 0;
					while (childIndex < m_winChipHeapList[index].length) {
						chipHeap = m_winChipHeapList[index][childIndex] as ChipHeapView;
						Tweener.removeTweens (chipHeap);
						if (chipHeap) {
							chipHeap.ShowChip (0);
							chipHeap.alpha = 0;
							chipHeap.visible = false;
						}
						childIndex++;
					}
				}
				index++;
			}
			m_isStart=true;//游戏开始和重新结算时可以移动
		}
		//设置大小
		public function SetSize (uWidth:uint, uHeight:uint):void {
			this.graphics.beginFill (0x5C87E7, 0);
			this.graphics.drawRect (0, 0, uWidth, uHeight);

			this.width = uWidth;
			this.height = uHeight;
		}
		//显示下注筹码
		public function ShowBetChips (wChairID:int, wBetPos:int, money:int):void {
			if (wBetPos <= 0 || wBetPos > m_BetPosCount) {
				trace ("ShowBetChips wBetPos="+wBetPos+"; m_BetPosCount="+m_BetPosCount);
				return;
			}
			var betposIndex:int = GetBetPosIndex(wBetPos);
			var chairIndex:int = GetChairIndex(wChairID);

			if (m_chipHeapList[chairIndex] == null) {
				m_chipHeapList[chairIndex] = new Array();
			}

			var chipHeap:ChipHeapView = null;
			if (m_chipHeapList[chairIndex][betposIndex] == null) {
				chipHeap = new ChipHeapView(this);
				addChild (chipHeap);
				m_chipHeapList[chairIndex][betposIndex] = chipHeap;
			} else {
				chipHeap = m_chipHeapList[chairIndex][betposIndex] as ChipHeapView;
			}
			if(m_chipHeapIndex != null && m_chipHeapIndex[chairIndex] != null && m_chipHeapIndex[chairIndex][betposIndex] != null && 
			   int(m_chipHeapIndex[chairIndex][betposIndex]) < this.numChildren) {
				this.setChildIndex(chipHeap, m_chipHeapIndex[chairIndex][betposIndex]);
			}
			if (money == 0) {
				chipHeap.visible = false;
			} else {
				chipHeap.alpha = 1;
				chipHeap.visible = true;
				chipHeap.x = m_chipPoint[chairIndex][betposIndex].x;
				chipHeap.y = m_chipPoint[chairIndex][betposIndex].y;
			}
			moveOver = true;
			chipHeap.ShowChip (money);
		}
		//添加赢筹码
		public function AddWinChips (wChairID:int, wBetPos:int, money:int):void {
			moveOver = false;
			if (m_winChips == null) {
				m_winChips = new Array();
			}
			m_winChips.push ([wChairID, wBetPos, money]);
			m_isStart=true;
		}
		//添加输筹码
		public function AddLoseChips (wChairID:int, wBetPos:int):void {
			if (m_loseChips == null) {
				m_loseChips = new Array();
			}
			m_loseChips.push ([wChairID, wBetPos]);
			m_isStart=true;
		}
		//添加和筹码
		public function AddDrawChips (wChairID:int, wBetPos:int):void {
			if (m_drawChips == null) {
				m_drawChips = new Array();
			}
			m_drawChips.push ([wChairID, wBetPos]);
			m_isStart=true;
		}
		//开始移动
		public function StartMove ():void {
			if(m_isStart==false){
				return;
			}
			//移动和
			var index:int = 0;
			if (m_drawChips) {
				while (index < m_drawChips.length) {
					MoveDrawChips (m_drawChips[index][0], m_drawChips[index][1]);
					index++;
				}
			}
			//移动输
			index = 0;
			if (m_loseChips) {
				while (index < m_loseChips.length) {
					MoveLoseChips (m_loseChips[index][0], m_loseChips[index][1]);
					index++;
				}
			}
			//移动赢
			index = 0;
			if (m_winChips) {
				while (index < m_winChips.length) {
					MoveWinChips (m_winChips[index][0], m_winChips[index][1], m_winChips[index][2]);
					index++;
				}
			}
			m_isStart=false;//移动后就不能再移动
		}
		//移动赢筹码
		private function MoveWinChips (wChairID:int, wBetPos:int, money:int):void {
			if (wBetPos <= 0 || wBetPos >m_BetPosCount || money <= 0) {
				return;
			}
			var betposIndex:int = GetBetPosIndex(wBetPos);
			var chairIndex:int = GetChairIndex(wChairID);

			if (m_winChipHeapList[chairIndex] == null) {
				m_winChipHeapList[chairIndex] = new Array();
			}
			//位置没有下注
			if (m_chipHeapList[chairIndex][betposIndex] == null) {
				return;
			}
			var chipHeap:ChipHeapView = m_chipHeapList[chairIndex][betposIndex] as ChipHeapView;
			var winChipHeap:ChipHeapView = null;

			if (m_winChipHeapList[chairIndex][betposIndex] == null) {
				winChipHeap = chipHeap.CloneChipHeapView();
				addChild (winChipHeap);

				m_winChipHeapList[chairIndex][betposIndex] = winChipHeap;
			} else {
				winChipHeap = m_winChipHeapList[chairIndex][betposIndex] as ChipHeapView;
				winChipHeap.ShowChip (chipHeap.GetMoney());
			}
			winChipHeap.SetTextMoney (money);
			winChipHeap.alpha = 1;
			winChipHeap.visible = true;
			winChipHeap.x = m_BankerPoint.x;
			winChipHeap.y = m_BankerPoint.y;
			//开始移动
			Tweener.addTween (winChipHeap, { x: m_winChipPoint[chairIndex][betposIndex].x, y: m_winChipPoint[chairIndex][betposIndex].y, time: m_moveTime, 
			 onComplete:MoveWinChipsComplete, onCompleteParams:[wChairID, wBetPos]
			  });
		}
		//移动
		private function MoveWinChipsComplete (wChairID:int, wBetPos:int):void {
			var betposIndex:int = GetBetPosIndex(wBetPos);
			var chairIndex:int = GetChairIndex(wChairID);
			//位置没有下注
			if (m_chipHeapList[chairIndex][betposIndex] == null || m_winChipHeapList[chairIndex][betposIndex] == null) {
				return;
			}
			var chipHeap:ChipHeapView = m_chipHeapList[chairIndex][betposIndex] as ChipHeapView;
			var winChipHeap:ChipHeapView = m_winChipHeapList[chairIndex][betposIndex] as ChipHeapView;

			//开始移动
			Tweener.addTween (chipHeap, { x: m_moveChipPoint[chairIndex][0].x, y: m_moveChipPoint[chairIndex][0].y, time: m_moveTime, alpha: m_winAlpha ,onComplete:HideChip});
			Tweener.addTween (winChipHeap, { x: m_moveChipPoint[chairIndex][1].x, y: m_moveChipPoint[chairIndex][1].y, time: m_moveTime, alpha: m_winAlpha,onComplete:HideChip});
		}
		private var moveOver:Boolean = false;
		private function HideChip ():void {
			moveOver = true;
			ClearMemberChips (isInGame);
		}
		//移动输筹码
		private function MoveLoseChips (wChairID:int, wBetPos:int):void {
			if (wBetPos <= 0 || wBetPos >m_BetPosCount) {
				return;
			}
			var betposIndex:int = GetBetPosIndex(wBetPos);
			var chairIndex:int = GetChairIndex(wChairID);

			if (m_chipHeapList[chairIndex] == null) {
				m_chipHeapList[chairIndex] = new Array();
			}
			//位置没有下注
			if (m_chipHeapList[chairIndex][betposIndex] == null) {
				return;
			}
			var chipHeap:ChipHeapView = m_chipHeapList[chairIndex][betposIndex] as ChipHeapView;

			//开始移动
			Tweener.addTween (chipHeap, { x: m_BankerPoint.x, y: m_BankerPoint.y, time: m_moveTime, alpha:0 });
		}
		//行动和筹码(和 退庄闲筹码)
		private function MoveDrawChips (wChairID:int, wBetPos:int):void {
			if (wBetPos <= 0 || wBetPos > m_BetPosCount) {
				return;
			}
			var betposIndex:int = GetBetPosIndex(wBetPos);
			var chairIndex:int = GetChairIndex(wChairID);

			if (m_chipHeapList[chairIndex] == null) {
				m_chipHeapList[chairIndex] = new Array();
			}
			//位置没有下注
			if (m_chipHeapList[chairIndex][betposIndex] == null) {
				return;
			}
			var chipHeap:ChipHeapView = m_chipHeapList[chairIndex][betposIndex] as ChipHeapView;
			if (chipHeap.GetMoney() <= 0) {
				return;
			}

			//开始移动
			Tweener.addTween (chipHeap, { x: m_moveChipPoint[chairIndex][0].x, y: m_moveChipPoint[chairIndex][0].y, time: m_moveTime , alpha: m_winAlpha  });
		}
		//获取索引
		protected function GetChairIndex (wChairID:int):int {
			return wChairID - 1;
		}
		//获取索引
		protected function GetBetPosIndex (wBetPos:int):int {
			return wBetPos - 1;
		}
		//玩家离开清空桌面
		//@endGame：游戏是否结束
		//@bool:true,离开游戏
		protected var isInGame:Array =new Array();;
		public function ClearMemberChips (endGame:Array):void {
			isInGame = endGame;
			if (moveOver==false) {
				return;
			}
			if(isInGame==null){
				return;
			}
			var ind:int = 0;
			var len:int=isInGame.length;
			for (ind; ind<len; ind++) {
				if (isInGame[ind]) {
					var chairIndex:int = GetChairIndex(ind);
					var index:int = 0;
					if(m_winChipHeapList==null ){
						return;
					}
					if(m_winChipHeapList[chairIndex]==null){
						return;
					}
					var winlen:int=m_winChipHeapList[chairIndex].length;
					for (index; index<winlen; index++) {
						if (m_winChipHeapList[chairIndex][index] != "" && m_winChipHeapList[chairIndex][index] != null) {
							var winChipHeap:ChipHeapView = m_winChipHeapList[chairIndex][index] as ChipHeapView;
							winChipHeap.ClearChipPane ();

							if (m_chipHeapList[chairIndex][index] != "" && m_chipHeapList[chairIndex][index] != null) {
								var chipHeap:ChipHeapView = m_chipHeapList[chairIndex][index] as ChipHeapView;
								chipHeap.ClearChipPane ();
							}
						}
					}
				}
			}

		}
		//换座位删除未确定投注筹码
		public function ClearUserChips(chair:int):void{
			if(m_chipHeapList && m_chipHeapList[chair-1]){
				var index:int=0;
				var len:int=m_chipHeapList[chair-1].length;
				for(index;index<len;index++){
					if(m_chipHeapList[chair-1][index]){
					var chipHeap:ChipHeapView = m_chipHeapList[chair-1][index] as ChipHeapView;
					chipHeap.ClearChipPane ();
					}
				}
			}
		}
		public function GetChipView(index:int):MovieClip {
			var gbv:GameBaseView = this.parent as GameBaseView;
			return gbv.GetChipView(index);
		}
		public function SetInfo(infopane:Object):void{
			
		}
	}
}