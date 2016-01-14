package  ChipSelect{
	import flash.geom.Point;
	import flash.display.Sprite;
	public class TotalChipPaneForMoreGame extends TotalChipPane {

		public function TotalChipPaneForMoreGame() {
			// constructor code
			super();
			affirm.x=58;
			affirm.scaleX=1.2;
			affirm.scaleY=0.99;
			cancel.x=168;
			cancel.scaleX=1.2;
			cancel.scaleY=0.99;
			firstPos=new Point(16,20);
			chipSpace=65;
			if(this.getChildByName("head")){
				this["head"].scaleX=1.2;
				this["head"].scaleY=0.99;
			}
			if(this.getChildByName("mc_select")){
				this["mc_select"].scaleX=1.2;
				this["mc_select"].scaleY=0.99;
			}
		}
		/*
		 * 显示总筹码
		*/
		override public function ShowTotalChip ():void {
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
					var row:int=index/3;//设置行数，每行放3个筹码
					cbv.x =firstPos.x+(index-row*3) * (chipSpace+10);
					cbv.y =firstPos.y+ row * (chipSpace-5);
					cbv.scaleX=1.2;
					cbv.scaleY=0.99;
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

	}
	
}
