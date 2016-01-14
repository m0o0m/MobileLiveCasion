package GameModule.Common{
	import flash.display.MovieClip;
	import flash.text.TextField;
	import flash.utils.getDefinitionByName;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	import IGameFrame.IChipViewPane;
	
	//位置暂时没有确定
	public class ChipHeapView extends MovieClip {
		protected var m_MaxChipCount:int = 5;//筹码最多个数
		protected var m_txtMoney:TextField;//金额数值, 如果有 name=txtmoney 的子级, 直接可以赋值
		protected var m_moneyTotal:Number;//金额总数
		
		protected var m_chipPane:MovieClip;//筹码容器, 如果有 name=chippane 的子级, 直接可以赋值
		protected var m_Parent:IChipViewPane = null;
		//还差自己筹码, 金额后面有背景
		//还差投注成功, 筹码加光圈
		public function ChipHeapView(p:IChipViewPane) {
			stop();
			m_Parent = p;
			if(this.getChildByName("chippane")) {
				m_chipPane = this.getChildByName("chippane") as MovieClip;
			} else {
				m_chipPane = new MovieClip();
				addChild(m_chipPane);
				m_chipPane.x = -10;
				m_chipPane.y = 0;
			}
			
			if(this.getChildByName("txtmoney")) {
				m_txtMoney = this.getChildByName("txtmoney") as TextField;
			} else {
				m_txtMoney = new TextField();
				m_txtMoney.autoSize = TextFieldAutoSize.CENTER;
				
				var format:TextFormat = new TextFormat("Arial", 30, 0xFCEE21, true);
				m_txtMoney.defaultTextFormat = format;
				
				addChild(m_txtMoney);
				m_txtMoney.x = 0;
				m_txtMoney.y = 0;
			}
		}
		//销毁
		public function Destroy():void {
			if(m_chipPane) {
				ClearChipPane();
				removeChild(m_chipPane);
				m_chipPane = null;
			}
			removeChild(m_txtMoney);
			m_txtMoney = null;
			m_Parent = null;
		}
		public function GetMoney():Number {
			return m_moneyTotal;
		}
		//清除筹码
		public function ClearChipPane(){
			if(m_chipPane) {
				var index:int = m_chipPane.numChildren-1;
				while(index >= 0) {
					m_chipPane.removeChildAt(index);
					index --;
				}
			}
			m_txtMoney.text = "";
		}
		//显示筹码
		public function ShowChip(money:Number):void {
			if(m_moneyTotal == money) {
				return;
			}
			ClearChipPane();
			m_moneyTotal = money;
			
			if(m_moneyTotal <= 0) {
				m_txtMoney.text = "";
				ClearChipPane();
				return;
			}
			m_txtMoney.text = m_moneyTotal.toString();
			
			var showIndex:int = 0;
			var index = const_Chip.length - 1;
			while(index >= 0) {
				var chipNum:int = int(const_Chip[index]);//
				
				var count:int = money / chipNum;
				while(count > 0) {
					var chip:MovieClip = GetChipView(index);
					
					m_chipPane.addChild(chip);
					//确定位置 (未实现)
					chip.y = showIndex*-2;
					if(showIndex%2==1){
						chip.x=1;
					}
					/*chip.width=34.05;
					chip.height=23.65*/
					showIndex++;
					//到最大个数不再添加筹码
					if(showIndex >= m_MaxChipCount) {
						break;
					}
					count--;
				}
				money = money % chipNum;
				
				index--;
			}
			m_txtMoney.x = m_chipPane.x + (m_chipPane.width - m_txtMoney.width) / 2;
			m_txtMoney.y = -1 * m_chipPane.height+30;
		}
		public function SetTextMoney(money:Number) {			
			m_txtMoney.text = money.toString();
		}
		public function CloneChipHeapView():ChipHeapView {
			var chv:ChipHeapView = new ChipHeapView(m_Parent);
			chv.ShowChip(m_moneyTotal);
			return chv;
		}
		public function GetChipView(index:int):MovieClip {
			if(m_Parent == null) {
				return null;
			}
			return m_Parent.GetChipView(index);
		}
	}
}
include "../../CommonModule/CHIPCONST.as"