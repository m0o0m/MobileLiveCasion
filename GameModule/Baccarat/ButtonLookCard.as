package {
	import CommonModule.ButtonBaseClass;
	public class ButtonLookCard extends ButtonBaseClass {

		public function ButtonLookCard () {
			// constructor code
			super ();
		}
		override public function SetEnabled(enabled:Boolean):void {
			this.enabled = enabled;
			if (enabled == false) {
				m_mcTwinkle.gotoAndStop(3);
				this.buttonMode = false;
				this.mouseEnabled = false;
				m_isOut=false;
			} else {
				m_mcTwinkle.gotoAndStop(1);
				this.buttonMode = true;
				this.mouseEnabled = true;
			}

		}
	}

}