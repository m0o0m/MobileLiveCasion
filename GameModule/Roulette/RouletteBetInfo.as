package {
	import flash.display.MovieClip;
	import GameModule.Common.BetInfo;
	import flash.utils.Dictionary;

	public class RouletteBetInfo extends BetInfo {

		public function RouletteBetInfo () {
			// constructor code
			super ();
			m_betInfo=new Dictionary();
			if (this.getChildByName("big")) {
				m_betInfo[145] = this["big"];
			}
			if (this.getChildByName("small")) {
				m_betInfo[144] = this["small"];
			}
			if (this.getChildByName("odd")) {
				m_betInfo[148] = this["odd"];
			}
			if (this.getChildByName("even")) {
				m_betInfo[149] = this["even"];
			}
			if (this.getChildByName("red")) {
				m_betInfo[146] = this["red"];
			}
			if (this.getChildByName("black")) {
				m_betInfo[147] = this["black"];
			}
			if (this.getChildByName("zero")) {
				m_betInfo[0] = this["zero"];
			}
		}
	}
}