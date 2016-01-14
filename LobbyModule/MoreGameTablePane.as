package  {
	import flash.events.MouseEvent;
	
	public class MoreGameTablePane extends TablePane{
		public function MoreGameTablePane() {
			// constructor code
			super();
			ButtonClick();
		}
		protected function ButtonClick():void{
			if(this.getChildByName("positionOne")){
			this["positionOne"].addEventListener(MouseEvent.CLICK,ChangeOne);
			}
			if(this.getChildByName("positionTwo")){
			this["positionTwo"].addEventListener(MouseEvent.CLICK,ChangeTwo);
			}
			if(this.getChildByName("positionThree")){
			this["positionThree"].addEventListener(MouseEvent.CLICK,ChangeThree);
			}
			if(this.getChildByName("positionFour")){
			this["positionFour"].addEventListener(MouseEvent.CLICK,ChangeFour);
			}
		}
		protected function ChangeOne(e:MouseEvent):void{
			Load(1);
		}
		protected function ChangeTwo(e:MouseEvent):void{
			Load(2);
		}
		protected function ChangeThree(e:MouseEvent):void{
			Load(3);
		}
		protected function ChangeFour(e:MouseEvent):void{
			Load(4);
		}
		protected function Load(index:int):void{
			var roompane:MoreGameRoomPane=m_roomPane as MoreGameRoomPane;
			roompane.ChangGameTable(m_wTableID,index);
		}
		public override function Destroy ():void {
			super.Destroy();
			if(this.getChildByName("positionOne")){
			this["positionOne"].removeEventListener(MouseEvent.CLICK,ChangeOne);
			}
			if(this.getChildByName("positionTwo")){
			this["positionTwo"].removeEventListener(MouseEvent.CLICK,ChangeTwo);
			}
			if(this.getChildByName("positionThree")){
			this["positionThree"].removeEventListener(MouseEvent.CLICK,ChangeThree);
			}
			if(this.getChildByName("positionFour")){
			this["positionFour"].removeEventListener(MouseEvent.CLICK,ChangeFour);
			}
		}

	}
	
}
