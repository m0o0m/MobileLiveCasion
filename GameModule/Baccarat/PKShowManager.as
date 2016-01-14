package {
	import GameModule.Common.PK.PKShowBaseManager;
	import flash.geom.Point;
	
	public class PKShowManager extends PKShowBaseManager {

		public function PKShowManager() {
			pkPoint=new Point(0,0);
			width=426;
			height=320;
			bPkPoint=[new Point(254,115),new Point(337,115),new Point(384.2,233)];
			pPkPoint=[new Point(35,115),new Point(118,115),new Point(166.6,233)];
			bFontPos=new Point(210,0);
			pFontPos=new Point(0,0);
			m_resultPos=[new Point(436.85,485.45),new Point(124.35,485.45),new Point(290.35,485.45)];
			super();
		}
	}
}
