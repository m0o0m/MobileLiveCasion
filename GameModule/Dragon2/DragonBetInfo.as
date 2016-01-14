package {
	import GameModule.Common.BetInfo;
	import flash.utils.Dictionary;

	public class DragonBetInfo extends BetInfo {

		public function DragonBetInfo () {

			super ();
			m_betInfo = new Dictionary();
			if (this.getChildByName("m_DBetInfo")) {
				m_betInfo[1] = this["m_DBetInfo"];
			}
			if (this.getChildByName("m_TiBetInfo")) {
				m_betInfo[2] = this["m_TiBetInfo"];
			}
			if (this.getChildByName("m_TBetInfo")) {
				m_betInfo[0] = this["m_TBetInfo"];
			}
		}
	}
}