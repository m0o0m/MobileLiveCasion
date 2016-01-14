package ChipSelect {
	import flash.events.MouseEvent;
	public class ChipSettingRight extends ChipSetting{

		public function ChipSettingRight() {
			// constructor code
		}
		public override function OnClickChip(e:MouseEvent):void{
			if(chbm){
				chbm.ShowTotalChipRight();
			}
		}

	}
	
}
