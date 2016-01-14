package {
	import GameModule.Common.BetInfo;
	import flash.utils.Dictionary;

	public class BaccBetInfo extends BetInfo {

		public function BaccBetInfo () {
			super ();
			m_betInfo = new Dictionary();
			if (this.getChildByName("m_PBetInfo")) {
				m_betInfo[0] = this["m_PBetInfo"];
			}
			if (this.getChildByName("m_BBetInfo")) {
				m_betInfo[1] = this["m_BBetInfo"];
			}
			if (this.getChildByName("m_DBetInfo")) {
				m_betInfo[2] = this["m_DBetInfo"];
			}
			if (this.getChildByName("m_PPBetInfo")) {
				m_betInfo[3] = this["m_PPBetInfo"];
			}
			if (this.getChildByName("m_BPBetInfo")) {
				m_betInfo[4] = this["m_BPBetInfo"];
			}
			if (this.getChildByName("m_BigBetInfo")) {
				m_betInfo[5] = this["m_BigBetInfo"];
			}
			if (this.getChildByName("m_SmallBetInfo")) {
				m_betInfo[6] = this["m_SmallBetInfo"];
			}
		}
	}
}