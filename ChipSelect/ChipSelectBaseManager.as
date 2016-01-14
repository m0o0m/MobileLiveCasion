package ChipSelect{

	import flash.display.MovieClip;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	import flash.geom.Point;
	import IGameFrame.IChipPane;
	import IGameFrame.IChipSelect;

	public class ChipSelectBaseManager extends MovieClip implements IChipSelect {

		protected var m_ChipPane:IChipPane = null;//游戏视图

		protected var totalChipName:Array = [Chip1,Chip5,Chip10,Chip20,Chip50,Chip100,Chip500,Chip1000,Chip5000,Chip10000,Chip20K,Chip50K,Chip100K,Chip200K,Chip500K,Chip1M,Chip2M,Chip5M,Chip10M,Chip20M,Chip50M,Chip100M];//总筹码名称集合
		protected var chp:TotalChipPane = null;//总筹码容器

		protected var currentChipNumber:Array;//当前可用筹码编号
		protected var currentChipType:Array;//当前筹码类型集合
		protected var currentSpace:Array;//可用筹码坐标

		//protected var sitePos:Point;//筹码设置位置
		//protected var siteChipView:ChipBaseView;//筹码设置对象
		protected var sitePosLeft:Point;//筹码设置位置
		protected var sitePosRight:Point;//筹码设置位置
		protected var siteChipViewLeft:ChipBaseView;//筹码设置对象
		protected var siteChipViewRight:ChipBaseView;//筹码设置对象

		protected var currentSelsetChip:ChipBaseView;//当前选中的筹码
		protected var currentSelect:int = 0;//当前选中筹码的索引

		//protected var distance:int = 2;//被選中籌碼高度

		protected var m_currentStatus:Boolean = true;//筹码目前可视状态
		protected var m_SelectType:Boolean = true;//筹码选择类型@true：左右选择,@false：自选
		//protected var m_selectArr:Array;//切换至自选时的所选筹码(可相互切换)
		protected var m_bg:ChipSelectBg;
		public var m_scalex:Number=1;
		public var m_scaley:Number=1;
		public function ChipSelectBaseManager () {
			InitSelectBg ();
			InitChoice ();
			InitTotalChipPane ();
			currentChipType=new Array();
			currentSpace = [[-39,68],[-39,213],[-39,358],[-39,503],[-39,648]];
		}
		public function InitChoice ():void {
			//sitePos = new Point(700,355);
			//var siteChip:ChipSetting = new ChipSetting();
			//siteChipView = siteChip as ChipBaseView;
			/*if (siteChipView) {
				siteChipView.SetChipHeapManger (this);
				addChild (siteChipView);
				siteChipView.x = sitePos.x;
				siteChipView.y = sitePos.y;
			}*/
			sitePosRight = new Point(0,784);
			sitePosLeft = new Point(0,0);
			var siteChipRight:ChipSettingRight = new ChipSettingRight();
			siteChipViewRight = siteChipRight as ChipBaseView;
			if (siteChipViewRight) {
				siteChipViewRight.SetChipHeapManger (this);
				addChild (siteChipViewRight);
				siteChipViewRight.x = sitePosRight.x;
				siteChipViewRight.y = sitePosRight.y;
			}
			var siteChipLeft:ChipSettingLeft = new ChipSettingLeft();
			siteChipViewLeft = siteChipLeft as ChipBaseView;
			if (siteChipViewLeft) {
				siteChipViewLeft.SetChipHeapManger (this);
				addChild (siteChipViewLeft);
				siteChipViewLeft.x = sitePosLeft.x;
				siteChipViewLeft.y = sitePosLeft.y;
			}
		}
		protected function InitTotalChipPane ():void {
			chp=new TotalChipPane();
			chp.x = 448;
			chp.y = 150;
			addChild (chp);
			chp["mc_bg"].gotoAndStop(1);
			chp.SetChipHeapManager (this);
			//(可相互切换)chp.SetSelectType (m_SelectType);
		}
		protected function InitSelectBg ():void {
			
		}
		public function GetMovieClip ():MovieClip {
			return this;
		}
		/*
		 * 销毁
		*/
		public function Destroy ():void {
			if (chp) {//销毁总筹码区
				chp.Destroy ();
				removeChild (chp);
				chp = null;
			}
			ClearSelectChip ();
			/*if (siteChipView) {
				siteChipView.Destroy ();
				removeChild (siteChipView);
				siteChipView = null;
			}
			if (m_selectArr) {
				m_selectArr = null;
			}*/
			m_ChipPane = null;
			//sitePos = null;
		}

		/*
		 * 实例化游戏视图
		 * gv 游戏视图
		*/
		public function SetChipPane (chipPane:IChipPane):void {
			if (chipPane) {
				m_ChipPane = chipPane;
				var chips:Array = m_ChipPane.GetSelectChips();

				if (chips) {
					currentChipNumber = chips[0];
					currentSelect = chips[1];
				} else {
					currentChipNumber = [0,1,2,3,4];
					currentSelect = 0;
				}
				ShowSelectChip ();
			}
			if(currentChipNumber[0]>0){
				SetLeftChipSettingEnabled(true);
			}else{
				SetLeftChipSettingEnabled(false);
			}
			if(currentChipNumber[0]<5){
				SetRightChipSettingEnabled(true);
			}else{
				SetRightChipSettingEnabled(false);
			}

		}

		/*
		 * 显示总筹码
		*/
		public function ShowTotalChip ():void {
			if (chp) {
				chp.SetArray (totalChipName,currentChipNumber);
				chp.ShowTotalChip ();
			}
		}
		public function ShowTotalChipRight ():void {
			if (chp) {
				GoRight ();
				chp.SetArray (totalChipName,currentChipNumber);
				chp.ShowTotalChip ();
				chp.OnClickAfffirm ();
			}
		}
		public function ShowTotalChipLeft ():void {
			if (chp) {
				GoLeft ();
				chp.SetArray (totalChipName,currentChipNumber);
				chp.ShowTotalChip ();
				chp.OnClickAfffirm ();
			}
		}
		public function GoRight ():void {
			var index:int = currentChipNumber[0];
			if (index<17) {
				currentChipNumber.shift ();
				currentChipNumber.push (index+5);
			}
			if(index==16){
				SetRightChipSettingEnabled(false);
			}else if(index>=0){
				SetLeftChipSettingEnabled(true);
			}
		}
		public function GoLeft ():void {
			var index:int = currentChipNumber[4];
			if (index>4) {
				currentChipNumber.pop ();
				currentChipNumber.unshift (index-5);
			}
			if(index==5){
				SetLeftChipSettingEnabled(false);
			}else if(index<22){
				SetRightChipSettingEnabled(true);
			}
		}
		/*
		 * 显示当前可用筹码
		*/
		public function ShowSelectChip ():void {
			if (currentChipNumber) {
				var index:int = 0;
				ClearSelectChip ();
				currentChipType=new Array();
				while (index<currentChipNumber.length) {
					var ChipType:Class = totalChipName[currentChipNumber[index]] as Class;
					var ct:* = new ChipType();
					var chip:ChipBaseView = ct as ChipBaseView;
					if (chip) {
						addChild (chip);
						currentChipType.push (chip);
						chip.SetChipHeapManger (this);
						chip.x = currentSpace[index][0];
						chip.y = currentSpace[index][1];
						chip.scaleX=m_scalex;
						chip.scaleY=m_scaley;
						chip.visible = m_currentStatus;
						currentChipType[index] = chip;
					}
					index++;
				}
				ChangeCurrentChip ();//默认选中
			}
		}

		/*
		 * 清除显示区的筹码
		*/
		public function ClearSelectChip ():void {
			if (currentChipType) {
				var index:int = 0;
				while (index<currentChipType.length) {
					currentChipType[index].Destroy ();
					removeChild (currentChipType[index]);
					index++;
				}
				currentChipType = null;
			}
		}

		/*
		 * 单击设置
		*/
		public function OnClickSite ():void {
			if (chp) {
				chp.visible = ! chp.visible;
		        if(m_ChipPane){
					m_ChipPane.ShowHideTableListPane(! chp.visible);
				}
				if (chp.visible) {
					ShowTotalChip ();
				}
			}
		}

		/*
		 * 单击可用筹码筹码 改变默认筹码
		 @ cbv 点击的筹码对象
		*/
		public function OnClickSelectChip (cbv:ChipBaseView):void {
			if (cbv) {
				if (currentSelsetChip) {
					currentSelsetChip.ClearBg ();
				}
				/*if (currentSelsetChip!=cbv) {
					currentSelsetChip.y +=  distance;
					cbv.y -=  distance;
				} else {
					currentSelsetChip.y = currentSelsetChip.y;
				}*/
				currentSelsetChip = cbv;
				var selectNumber:int = currentChipType.indexOf(cbv);
				if (selectNumber!=-1) {
					currentSelect = selectNumber;
				}
			}
			SelectChipGather ();
		}

		/*
		 * 单击总筹码区筹码
		 @ posIndex 在总筹码堆中的索引
		 @ hasSelect 当前选中状态
		*/
		public function OnClickTotalChip (posIndex:int,hasSelect:Boolean):void {
			if (chp) {
				if (hasSelect) {
					chp.CancelChip (posIndex);
				} else {
					chp.AddChip (posIndex);
				}
			}
		}

		/*
		 * 改变默认选中筹码
		*/
		public function ChangeCurrentChip ():void {
			if (currentSelsetChip) {
				var currentChipName:String = getQualifiedClassName(currentSelsetChip);
				currentChipName = currentChipName.replace("::",".");
				var index:int = 0;
				while (index<currentChipType.length) {
					var currentTypName:String = getQualifiedClassName(currentChipType[index]);
					currentTypName = currentTypName.replace("::",".");
					if (currentChipName==currentTypName) {
						currentSelect = index;
						break;
					}
					index++;
				}
			}
			var selectChip:ChipBaseView = currentChipType[currentSelect] as ChipBaseView;
			currentSelsetChip = selectChip;
			if (selectChip) {
				selectChip.SetSelectChip ();
				//currentSelsetChip.y -=  distance;
			}
		}

		/*
		 * 筹码选择后单击确定
		 @ selectArr 重新选中的筹码索引
		 @ type 筹码选择类型
		*/
		//可相互切换
		/*public function OnClickConfirm (selectArr:Array,type:Boolean):void {

			//切换自选时存储所选筹码
			if (m_SelectType==true && type==false) {
				m_selectArr = currentChipNumber;
			}
			//切换至左右选择时显示
			if (type==true && m_selectArr && m_SelectType==false) {
				currentChipNumber = m_selectArr;
			}
			m_SelectType = type;
			ChangType (m_SelectType);
			//左右筹码选择显示
			if (selectArr && chp.visible==false && m_SelectType==true) {
				currentChipNumber = selectArr;
			}
			//自选筹码选择显示
			if (selectArr && chp.visible==true && m_SelectType==false) {
				currentChipNumber = selectArr;
			}
			ShowSelectChip ();

		}*/
		/*
		 * 筹码选择后单击确定
		 @ selectArr 重新选中的筹码索引
		 @ type 筹码选择类型
		*/
		//只能切换到自选
		public function OnClickConfirm (selectArr:Array):void {
			if (selectArr) {
				currentChipNumber = selectArr;
				ShowSelectChip ();
			}
		}
		/*
		 * 返回当前可用的筹码集合
		*/
		public function SelectChipGather ():void {
			var chips:Array = [currentChipNumber,currentSelect];
			if (m_ChipPane) {
				if (currentChipNumber) {
					m_ChipPane.SetSelectChips (chips);
				}
			}
		}

		/*
		 * 返回当前所选筹码代表的币值
		 @ index 筹码索引
		*/
		public function ChipMoney (index:int):Number {
			var money:Number = 0;
			if (index>=0 && index<const_Chip.length) {
				money = Number(const_Chip[index]);
			}
			return money;
		}
		//显示变换
		public function HideSelectChip (bool:Boolean):void {
			m_currentStatus = bool;
			if (currentChipType) {
				var index:int = 0;
				while (index<currentChipType.length) {
					currentChipType[index].visible = bool;
					index++;
				}
			}
			if (m_bg) {
				m_bg.visible = bool;
			}
			if (m_SelectType==true) {
				ChangType (bool);
			}
		}
		protected function ChangType (bool:Boolean):void {
			if (m_currentStatus) {
				if (siteChipViewRight) {
					siteChipViewRight.visible = bool;
				}
				if (siteChipViewLeft) {
					siteChipViewLeft.visible = bool;
				}
			}else{
				if (siteChipViewRight) {
					siteChipViewRight.visible = false;
				}
				if (siteChipViewLeft) {
					siteChipViewLeft.visible = false;
				}
			}
		}
		public function SetLang (strLang:String):void {
			if (chp) {
				chp.SetLang (strLang);
			}
			/*if (siteChipView) {
				siteChipView.SetLang (strLang);
			}*/
			if (m_bg) {
				m_bg["lang"].mouseEnabled=false;
				m_bg["lang"].mouseChildren=false;
				m_bg["lang"].gotoAndStop (strLang);
			}
		}
		//只能切换自选
		public function ChangeSelectType():void{
			if (m_SelectType==true) {
				m_SelectType=false;
				ChangType(m_SelectType);
			}
		}
		public function ShowChipPane(arr:Array):void{
			if (arr && arr.length==2) {
				var chips:Array = arr;
				if(currentSelect!=chips[1] || currentChipNumber!=chips[0]){
					var ChipType:Class = totalChipName[chips[0][chips[1]]] as Class;
					var ct:* = new ChipType();
					var chip:ChipBaseView = ct as ChipBaseView;
					OnClickSelectChip(chip);
				}
				if (chips) {
					currentChipNumber = chips[0];
					currentSelect = chips[1];
				} else {
					currentChipNumber = [0,1,2,3,4];
					currentSelect = 0;
				}
				ShowSelectChip ();
			}
		}
		public function HideTotalPane():void{
			if(chp){
				chp.visible=false;
			}
			if(m_ChipPane){
					m_ChipPane.ShowHideTableListPane(true);
			}
				 
		}
		//設置向右按钮
		protected function SetRightChipSettingEnabled(bool:Boolean):void{
			if(siteChipViewRight){
				siteChipViewRight.buttonMode=bool;
				siteChipViewRight.enabled=bool;
				if(siteChipViewRight.getChildByName("mc_right")){
					if(bool){
						siteChipViewRight["mc_right"].gotoAndStop(1);
					}else{
						siteChipViewRight["mc_right"].gotoAndStop(2);
					}
				}
			}
		}
		//設置向左按钮
		protected function SetLeftChipSettingEnabled(bool:Boolean):void{
			if(siteChipViewLeft){
				siteChipViewLeft.buttonMode=bool;
				siteChipViewLeft.enabled=bool;
				if(siteChipViewLeft.getChildByName("mc_left")){
					if(bool){
						siteChipViewLeft["mc_left"].gotoAndStop(1);
					}else{
						siteChipViewLeft["mc_left"].gotoAndStop(2);
					}
				}
			}
		}
	}
}
include "../CommonModule/CHIPCONST.as"