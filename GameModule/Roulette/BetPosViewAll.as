package {
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.utils.Dictionary;
	import GameModule.Common.BetPosView;
	import GameModule.Common.ShowBetPosLimit;

	public class BetPosViewAll extends BetPosView {
		//投注位置，索引从1开始

		protected var m_cBetPosIndex:Array=[,"bp0","bp1","bp2","bp3","bp4","bp5","bp6","bp7","bp8","bp9","bp10","bp11","bp12","bp13","bp14","bp15","bp16","bp17","bp18","bp19","bp20","bp21","bp22","bp23","bp24",
		   "bp25","bp26","bp27","bp28","bp29","bp30","bp31","bp32","bp33","bp34","bp35","bp36","bp0104","bp0205","bp0306","bp0407","bp0508","bp0609","bp0710","bp0811","bp0912","bp1013","bp1114","bp1215",
		   "bp1316","bp1417","bp1518","bp1619","bp1720","bp1821","bp1922","bp2023","bp2124","bp2225","bp2326","bp2427","bp2528","bp2629","bp2730","bp2831","bp2932",
		   "bp3033","bp3134","bp3235","bp3336","bp0001","bp0002","bp0003","bp0102","bp0203","bp0405","bp0506","bp0708","bp0809","bp1011","bp1112","bp1314","bp1415",
		   "bp1617","bp1718","bp1920","bp2021","bp2223","bp2324","bp2526","bp2627","bp2829","bp2930","bp3132","bp3233","bp3435","bp3536","bp000102","bp000203","bp0103",
		   "bp0406","bp0709","bp1012","bp1315","bp1618","bp1921","bp2224","bp2527","bp2830","bp3133","bp3436","bp0105","bp0206","bp0408","bp0509","bp0711","bp0812","bp1014",
		   "bp1115","bp1317","bp1418","bp1620","bp1721","bp1923","bp2024","bp2226","bp2327","bp2529","bp2630","bp2832","bp2933","bp3135","bp3236","bp0106","bp0409","bp0712",
		   "bp1015","bp1318","bp1621","bp1924","bp2227","bp2530","bp2833","bp3136","bpsmall","bpbig","bpred","bpblack","bpodd","bpeven","bp0112",
		   "bp1324","bp2536","bp0134","bp0235","bp0336","bpf0","bpf1","bpf2","bpf3",
		  "bpf4","bpf5","bpf6","bpf7","bpf8","bpf9",
		  "bpf10","bpf11","bpf12","bpf13","bpf14",
		  "bpf15","bpf16","bpf17","bpf18","bpf19",
		  "bpf20","bpf21","bpf22","bpf23","bpf24",
		  "bpf25","bpf26","bpf27","bpf28","bpf29",
		  "bpf30","bpf31","bpf32","bpf33","bpf34",
		  "bpf35","bpf36","bpleft","bpcenter","bpright","bpright0"];
		//center table投注位置
		private var m_bBetPosList:Dictionary;
		public function BetPosViewAll () {
			this.stop ();
			m_bBetPosList=new Dictionary();
			SetMouseoutIndex (1);
			SetMouseoverIndex (11);
			m_bBetPosList["bpf0"] = ["bp0","bp3","bp15","bp26","bp32"];
			m_bBetPosList["bpf1"] = ["bp1","bp14","bp16","bp20","bp33"];
			m_bBetPosList["bpf2"] = ["bp2","bp4","bp17","bp21","bp25"];
			m_bBetPosList["bpf3"] = ["bp3","bp0","bp12","bp26","bp35"];
			m_bBetPosList["bpf4"] = ["bp4","bp2","bp15","bp19","bp21"];
			m_bBetPosList["bpf5"] = ["bp5","bp10","bp16","bp23","bp24"];
			m_bBetPosList["bpf6"] = ["bp6","bp13","bp17","bp27","bp34"];
			m_bBetPosList["bpf7"] = ["bp7","bp12","bp18","bp28","bp29"];
			m_bBetPosList["bpf8"] = ["bp8","bp10","bp11","bp23","bp24"];
			m_bBetPosList["bpf9"] = ["bp9","bp14","bp18","bp22","bp31"];
			m_bBetPosList["bpf10"] = ["bp10","bp5","bp8","bp23","bp24"];
			m_bBetPosList["bpf11"] = ["bp11","bp8","bp13","bp30","bp36"];
			m_bBetPosList["bpf12"] = ["bp12","bp3","bp7","bp28","bp35"];
			m_bBetPosList["bpf13"] = ["bp13","bp6","bp11","bp27","bp36"];
			m_bBetPosList["bpf14"] = ["bp14","bp1","bp9","bp20","bp31"];
			m_bBetPosList["bpf15"] = ["bp15","bp0","bp4","bp19","bp32"];
			m_bBetPosList["bpf16"] = ["bp16","bp1","bp5","bp24","bp33"];
			m_bBetPosList["bpf17"] = ["bp17","bp2","bp6","bp25","bp34"];
			m_bBetPosList["bpf18"] = ["bp18","bp7","bp9","bp22","bp29"];
			m_bBetPosList["bpf19"] = ["bp19","bp4","bp15","bp21","bp32"];
			m_bBetPosList["bpf20"] = ["bp20","bp1","bp14","bp31","bp33"];
			m_bBetPosList["bpf21"] = ["bp21","bp2","bp4","bp19","bp25"];
			m_bBetPosList["bpf22"] = ["bp22","bp9","bp18","bp29","bp31"];
			m_bBetPosList["bpf23"] = ["bp23","bp5","bp8","bp10","bp30"];
			m_bBetPosList["bpf24"] = ["bp24","bp5","bp10","bp16","bp33"];
			m_bBetPosList["bpf25"] = ["bp25","bp2","bp17","bp21","bp34"];
			m_bBetPosList["bpf26"] = ["bp26","bp0","bp3","bp32","bp35"];
			m_bBetPosList["bpf27"] = ["bp27","bp6","bp13","bp34","bp36"];
			m_bBetPosList["bpf28"] = ["bp28","bp7","bp12","bp29","bp35"];
			m_bBetPosList["bpf29"] = ["bp29","bp7","bp18","bp22","bp28"];
			m_bBetPosList["bpf30"] = ["bp30","bp8","bp11","bp23","bp36"];
			m_bBetPosList["bpf31"] = ["bp31","bp9","bp14","bp20","bp22"];
			m_bBetPosList["bpf32"] = ["bp32","bp0","bp15","bp19","bp26"];
			m_bBetPosList["bpf33"] = ["bp33","bp1","bp16","bp20","bp24"];
			m_bBetPosList["bpf34"] = ["bp34","bp6","bp17","bp25","bp27"];
			m_bBetPosList["bpf35"] = ["bp35","bp3","bp12","bp26","bp28"];
			m_bBetPosList["bpf36"] = ["bp36","bp11","bp13","bp27","bp30"];
			//
			m_bBetPosList["bpleft"] = ["bp0508","bp1011","bp1316","bp2324","bp2730","bp3336"];
			m_bBetPosList["bpcenter"] = ["bp1","bp0609","bp1417","bp20","bp3134"];
			m_bBetPosList["bpright"] = ["bp000203","bp0407","bp1215","bp1821","bp1922","bp2529","bp3235"];
			m_bBetPosList["bpright0"] = ["bp0003","bp1215","bp26","bp3235"];
		}
		//投注：获取投注位置索引，根据索引获取投注坐标（注：必须是投注位置索引与ChipManagerData中m_chipPoint坐标索引完全对应）
		protected override function OnBet (e:MouseEvent):void {
			if (m_BetStatus == false) {
				return;
			}
			var str:String = e.target.name;
			if (m_bBetPosList[str]) {
				var index:int=0;
				for(;index<m_bBetPosList[str].length;index++){;
				SetBetPosIndex (m_cBetPosIndex.indexOf(m_bBetPosList[str][index]));
				m_BetPosManager.OnBet (m_BetPosIndex);
			}
		} else {
			SetBetPosIndex (m_cBetPosIndex.indexOf(str));
			m_BetPosManager.OnBet (m_BetPosIndex);
		}
	}
	//鼠标移入;
	protected override function OnMouseOver (event:MouseEvent):void {
		var str:String = event.target.name;
		if (m_BetStatus) {
			this.gotoAndStop (m_MouseoverIndex);
			m_BetPosName = this.name;
			if (m_BetPosManager) {
				m_BetPosManager.SetPlayBetOver (m_BetPosName);
				SetBetPosIndex (m_cBetPosIndex.indexOf(str));
				if(m_BetPosIndex<157){
				m_BetPosManager.ShowBetPos (true,m_BetPosIndex-1,m_BetTatol);
				}
			}
			isOver=true;
		}
	}
	//鼠标移出
	protected override function OnMouseOut (event:MouseEvent):void {
		var str:String = event.target.name;
		if (m_BetStatus) {
			this.gotoAndStop (m_MouseoutIndex);
			m_BetPosName = this.name;
			if (m_BetPosManager) {
				m_BetPosManager.SetPlayBetOut (m_BetPosName);
				SetBetPosIndex (m_cBetPosIndex.indexOf(str));
				if(m_BetPosIndex<157){
				m_BetPosManager.ShowBetPos (false,m_BetPosIndex-1,m_BetTatol);
				}
			}
			isOver=false;
		}
	}
	//设置投注状态
	public override function SetBetStatus (betStatus:Boolean):void {
		m_BetStatus = betStatus;
		if (m_BetStatus) {
			this.buttonMode = true;
		} else {
			this.buttonMode = false;
			this.gotoAndStop (1);
			m_BetTatol=0;
			//当状态为false时，将所有投注影片放到第一帧;
		}
	}
	override public function ShowBetTotal(bettotal:Number):void{
			m_BetTatol=bettotal;
			if (m_BetPosManager && isOver) {
				var str:String=this.name;
				SetBetPosIndex (m_cBetPosIndex.indexOf(str));
				m_BetPosManager.ShowBetPos(true,m_BetPosIndex-1,m_BetTatol);
			}
		}


}
}