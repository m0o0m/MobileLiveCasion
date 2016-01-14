package  {
	import flash.display.MovieClip;
	
	public class CardPane extends MovieClip {

		public function CardPane() {
			this["card"].stop();
		}
		public function SetCardNum(cardNum:int):void {
			this["card"].gotoAndStop(cardNum);
		}
		//删除遮罩
		public function RemoveShadow(isturn:Boolean){
			if(isturn){
				if(this.numChildren>2){
				if(this["m_shadowO"]){
				this.removeChild(this["m_shadowO"]);
				}
				if(this["m_shadowT"]){
				this.removeChild(this["m_shadowT"]);
				}
				if(this["m_shadowS"]){
				this.removeChild(this["m_shadowS"]);
				}
				if(this["m_shadowF"]){
				this.removeChild(this["m_shadowF"]);
				}
				}
			}
		}
	}
}