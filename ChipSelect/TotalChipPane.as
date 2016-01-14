package ChipSelect{

	import flash.display.MovieClip;
	import flash.geom.Point;
	import flash.utils.getDefinitionByName;
	import flash.events.MouseEvent;
	import fl.containers.ScrollPane;
	import flash.display.Sprite;

	public class TotalChipPane extends MovieClip {

		protected var chipHeapManager:ChipSelectBaseManager = null;

		protected var chipNames:Array;//总筹码名称数组
		protected var totalChips:Array;//总筹码实例化存储数组
		protected var selectNumber:Array;//已选中的筹码
		protected var firstPos:Point = new Point(16,20);//第一个筹码位置
		protected var chipSpace:Number = 57;//筹码间距
		protected var maxSelectChip:int = 5;//选中筹码最大个数
		protected var currentSelectChip:int = 0;//当前选中筹码个数

		protected var affirm:Affirm = null;//确认按钮
		protected var cancel:Cancel = null;//取消按钮
		
		protected var scrollBar:ScrollPane;//滚动条
		protected var m_sprite:Sprite;//存放筹码
		//protected var m_selectType:Boolean;//选择类型(可相互切换)
		
		public function TotalChipPane () {
			visible = false;
			affirm=new Affirm();
			affirm.SetEnabled(false);
			addChild (affirm);
			affirm.SetChipPane (this);
			cancel=new Cancel();
			addChild (cancel);
			cancel.SetChipPane (this);
			m_sprite=new Sprite();
			addChild(m_sprite);
			var line:Line=new Line();//撑开滑动区域
			m_sprite.addChild(line);
			scrollBar=new ScrollPane();
			addChild (scrollBar);
			scrollBar.x = 28;
			scrollBar.y = 76.3;
			scrollBar.width = 272;
			scrollBar.height =124;
			scrollBar.horizontalScrollPolicy = "off";
		}
		/*
		 * 销毁
		*/
		public function Destroy ():void {
			if (totalChips) {
				var index:int = 0;
				while (index<totalChips.length) {
					var chipView:ChipBaseView = totalChips[index] as ChipBaseView;
					chipView.Destroy ();
					index++;
				}
				totalChips = null;
			}
			if (affirm) {
				affirm.Destroy ();
				affirm = null;
			}
			if (cancel) {
				cancel.Destroy ();
				cancel = null;
			}
			chipHeapManager = null;
		}

		/*
		 * 实例化筹码堆管理对象
		 @ chbm 筹码堆管理对象
		*/
		public function SetChipHeapManager (chbm:ChipSelectBaseManager):void {
			if (chbm) {
				chipHeapManager = chbm;
			}
		}

		/*
		 * 显示总筹码
		*/
		public function ShowTotalChip ():void {
			if (chipNames) {
				var index:int = 0;
				ClearChip ();
				totalChips=new Array();
				while (index<chipNames.length) {
					
					var ChipType:Class = chipNames[index];
					var ct:*=new ChipType();
					var cbv:ChipBaseView = ct as ChipBaseView;
					if (cbv==null) {
						continue;
					}
					m_sprite.addChild (cbv);
					/*cbv.width*=0.8;
					cbv.height*=0.8;*/
					var row:int=index/4;//设置行数，每行放5个筹码
					cbv.x =firstPos.x+(index-row*4) * chipSpace;
					cbv.y =firstPos.y+ row * (chipSpace-5);
					if (selectNumber) {
						if (selectNumber.indexOf(index) != -1 && currentSelectChip < maxSelectChip) {
							//cbv.AddBgColor ();
							currentSelectChip++;
							cbv.ShowSelectBg();
							cbv.hasSelect = true;
						} else {
							DisableClick (cbv);
						}
					}
					cbv.SetChipHeapManger (chipHeapManager);
					cbv.SetChipType (false);
					cbv.SetChipOverOrOutStatus (false);
					totalChips.push (cbv);
					index++;
				}
				
				if (currentSelectChip>=maxSelectChip) {
					affirm.SetEnabled(true);
				}
			}
			scrollBar.source=m_sprite;
		}

		/*
		 * 清除筹码
		*/
		public function ClearChip ():void {
			if (totalChips) {
				var index:int = 0;
				while (index<totalChips.length) {
					m_sprite.removeChild (totalChips[index]);
					index++;
				}
				totalChips = null;
				currentSelectChip = 0;
			}
		}

		/*
		 * 实例化总筹码数组 和当前可用的筹码数组
		 @ toatlChipNames 总筹码名称数组
		 @ selectChipNumber 当前可用筹码索引数组
		*/
		public function SetArray (toatlChipNames:Array,selectChipNumber:Array):void {
			chipNames=new Array();
			if (toatlChipNames) {
				chipNames = toatlChipNames;
			}
			selectNumber=new Array();
			if (selectChipNumber) {
				var index:int = 0;
				while (index<selectChipNumber.length) {
					selectNumber.push (selectChipNumber[index]);
					index++;
				}
			}
		}

		/*
		 * 筹码单击事件可用
		 * cbv 筹码对象
		*/
		public function AvailableClick (cbv:ChipBaseView):void {
			if (cbv) {
				cbv.SetChipStatus (true);
			}
		}

		/*
		 * 筹码单击事件禁用
		 * cbv 筹码对象
		*/
		public function DisableClick (cbv:ChipBaseView):void {
			if (cbv) {
				cbv.SetChipStatus (false);
			}
		}

		/*
		 * 取消选择的筹码
		 @ posIndex 取消的索引
		*/
		public function CancelChip (posIndex:int):void {
			if (currentSelectChip>0) {
				currentSelectChip--;
				var index = selectNumber.indexOf(posIndex);
				if (index!=-1) {
					selectNumber.splice (index,1);
				}
			}
			//让筹码响应点击事件
			if (currentSelectChip<maxSelectChip&&selectNumber.length<maxSelectChip) {
				if (totalChips) {
					var chipIndex:int = 0;
					while (chipIndex<totalChips.length) {
						AvailableClick (totalChips[chipIndex]);
						chipIndex++;
					}
				}
			}
			//确认按钮不可用
			if (currentSelectChip<maxSelectChip||selectNumber.length<maxSelectChip) {
				if (affirm) {
					affirm.SetEnabled(false);
				}
			}
		}

		/*
		 * 选择的筹码
		 @ posIndex 选择的索引
		*/
		public function AddChip (posIndex:int):void {
			if (currentSelectChip<maxSelectChip) {
				currentSelectChip++;
				if (selectNumber.length < maxSelectChip) {
					selectNumber.push (posIndex);
				}
				selectNumber.sort (Array.NUMERIC);
			}
			//让筹码禁用点击事件
			if (currentSelectChip>=maxSelectChip&&selectNumber.length>=maxSelectChip) {
				if (totalChips) {
					var chipIndex:int = 0;
					while (chipIndex<totalChips.length) {
						var index:int = selectNumber.indexOf(chipIndex);
						if (index==-1) {
							DisableClick (totalChips[chipIndex]);
						}
						chipIndex++;
					}
				}
			}
			//确认按钮可用
			if (currentSelectChip>=maxSelectChip&&selectNumber.length>=maxSelectChip) {
				if (affirm) {
					affirm.SetEnabled(true);
				}
			}
		}

		/*
		 * 确认按钮点击事件
		*/
		public function OnClickAfffirm ():void {
			//(可相互切换)chipHeapManager.OnClickConfirm (selectNumber,m_selectType);
			chipHeapManager.OnClickConfirm (selectNumber);
		}
		//设置语言
		public function SetLang(strlang:String):void{
			if(affirm){
				affirm.IChangLang(strlang);
			}
			if(cancel){
				cancel.IChangLang(strlang);
			}
			if(this.getChildByName("head")){
				this["head"].gotoAndStop(strlang);
				this["head"].mouseChildren=false;
			}
			if(this.getChildByName("mc_select")){
				this["mc_select"].gotoAndStop(strlang);
				this["mc_select"].mouseChildren=false;
			}
		}
		//获得选择类型(可相互切换)
		/*public function SetSelectType(type:Boolean):void{
			m_selectType=type;
			if(m_btnSelect){
				if(m_selectType){
				m_btnSelect.gotoAndStop(1);
				}else{
				m_btnSelect.gotoAndStop(2);
				}
			}
		}*/
		//改变类型(可相互切换)
		/*protected function ChangeSelectType(e:MouseEvent):void{
			if(m_selectType){
			  m_selectType=false;
			  m_btnSelect.gotoAndStop(2);
			}else{
			  m_selectType=true;
			  m_btnSelect.gotoAndStop(1);
			}
		}*/
		//只能切换自选
		public function ChangeSelectType():void{
			chipHeapManager.ChangeSelectType();
		}
		public function Hide():void{
			if(chipHeapManager){
				chipHeapManager.HideTotalPane();
			}
		}

	}

}