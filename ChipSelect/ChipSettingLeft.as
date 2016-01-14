package ChipSelect {
	import flash.events.MouseEvent;	
	public class ChipSettingLeft extends ChipSetting{

		public function ChipSettingLeft() {
			// constructor code
			super();
		}
		/*
		 * 单击事件
		*/
		public override function OnClickChip(e:MouseEvent):void{
			if(chbm){
				chbm.ShowTotalChipLeft();
			}
		}
	}
	
}
