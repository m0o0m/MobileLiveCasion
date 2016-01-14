package {
	import GameModule.Common.BetPosBaseManager;
	import GameModule.Common.BetPosView;import CommandProtocol.GameKindEnum;
	import flash.utils.Dictionary;
	import flash.events.MouseEvent;
	import flash.display.MovieClip;
	import GameModule.Common.BetPosMultiple;
	import GameModule.Common.InfoPane.*;

	public class BetPosManager extends BetPosBaseManager {
		private var m_aBetPosList:Dictionary;//存储需显示投注位置（name）
		private var m_right:RightBetPosManager;//创建right table
		private var m_center:CenterBetPosManager;//创建center table
		
		protected var m_inforpane:InfoPane;
		//private var m_cshowbet:Dictionary;//闪烁
		public function BetPosManager () {
			// constructor code
			//创建right table
			m_right=new RightBetPosManager();
			m_right.x = 8;
			m_right.y = 110;
			addChild (m_right);
			//创建center table
			m_center=new CenterBetPosManager();
			m_center.x = 1062.5;
			m_center.y = 324.9;
			addChild (m_center);
			m_aBetPosList=new Dictionary();
			m_BetPosList=["bp0","bp1","bp2","bp3","bp4","bp5","bp6","bp7","bp8","bp9","bp10","bp11","bp12","bp13","bp14","bp15","bp16","bp17","bp18","bp19","bp20","bp21","bp22","bp23","bp24",
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
			m_aBetPosList["bpsmall"] = ["bp1","bp2","bp3","bp4","bp5","bp6","bp7","bp8","bp9","bp10","bp11","bp12","bp13","bp14","bp15","bp16","bp17","bp18"];
			m_aBetPosList["bpbig"] = ["bp19","bp20","bp21","bp22","bp23","bp24","bp25","bp26","bp27","bp28","bp29","bp30","bp31","bp32","bp33","bp34","bp35","bp36"];
			m_aBetPosList["bpred"] = ["bp1","bp3","bp5","bp7","bp9","bp12","bp14","bp16","bp18","bp19","bp21","bp23","bp25","bp27","bp30","bp32","bp34","bp36"];
			m_aBetPosList["bpblack"] = ["bp2","bp4","bp6","bp8","bp10","bp11","bp13","bp15","bp17","bp20","bp22","bp24","bp26","bp28","bp29","bp31","bp33","bp35"];
			m_aBetPosList["bpodd"] = ["bp1","bp3","bp5","bp7","bp9","bp11","bp13","bp15","bp17","bp19","bp21","bp23","bp25","bp27","bp29","bp31","bp33","bp35"];
			m_aBetPosList["bpeven"] = ["bp2","bp4","bp6","bp8","bp10","bp12","bp14","bp16","bp18","bp20","bp22","bp24","bp26","bp28","bp30","bp32","bp34","bp36"];
			//打
			m_aBetPosList["bp0112"] = ["bp1","bp2","bp3","bp4","bp5","bp6","bp7","bp8","bp9","bp10","bp11","bp12"];
			m_aBetPosList["bp1324"] = ["bp13","bp14","bp15","bp16","bp17","bp18","bp19","bp20","bp21","bp22","bp23","bp24"];
			m_aBetPosList["bp2536"] = ["bp25","bp26","bp27","bp28","bp29","bp30","bp31","bp32","bp33","bp34","bp35","bp36"];
			//列
			m_aBetPosList["bp0134"] = ["bp1","bp4","bp7","bp10","bp13","bp16","bp19","bp22","bp25","bp28","bp31","bp34"];
			m_aBetPosList["bp0235"] = ["bp2","bp5","bp8","bp11","bp14","bp17","bp20","bp23","bp26","bp29","bp32","bp35"];
			m_aBetPosList["bp0336"] = ["bp3","bp6","bp9","bp12","bp15","bp18","bp21","bp24","bp27","bp30","bp33","bp36"];
			//2连
			m_aBetPosList["bp0104"] = ["bp1","bp4"];
			m_aBetPosList["bp0205"] = ["bp2","bp5"];
			m_aBetPosList["bp0306"] = ["bp3","bp6"];
			m_aBetPosList["bp0407"] = ["bp4","bp7"];
			m_aBetPosList["bp0508"] = ["bp5","bp8"];
			m_aBetPosList["bp0609"] = ["bp6","bp9"];
			m_aBetPosList["bp0710"] = ["bp7","bp10"];
			m_aBetPosList["bp0811"] = ["bp8","bp11"];
			m_aBetPosList["bp0912"] = ["bp9","bp12"];
			m_aBetPosList["bp1013"] = ["bp10","bp13"];
			m_aBetPosList["bp1114"] = ["bp11","bp14"];
			m_aBetPosList["bp1215"] = ["bp12","bp15"];
			m_aBetPosList["bp1316"] = ["bp13","bp16"];
			m_aBetPosList["bp1417"] = ["bp14","bp17"];
			m_aBetPosList["bp1518"] = ["bp15","bp18"];
			m_aBetPosList["bp1619"] = ["bp16","bp19"];
			m_aBetPosList["bp1720"] = ["bp17","bp20"];
			m_aBetPosList["bp1821"] = ["bp18","bp21"];
			m_aBetPosList["bp1922"] = ["bp19","bp22"];
			m_aBetPosList["bp2023"] = ["bp20","bp23"];
			m_aBetPosList["bp2124"] = ["bp21","bp24"];
			m_aBetPosList["bp2225"] = ["bp22","bp25"];
			m_aBetPosList["bp2326"] = ["bp23","bp26"];
			m_aBetPosList["bp2427"] = ["bp24","bp27"];
			m_aBetPosList["bp2528"] = ["bp25","bp28"];
			m_aBetPosList["bp2629"] = ["bp26","bp29"];
			m_aBetPosList["bp2730"] = ["bp27","bp30"];
			m_aBetPosList["bp2831"] = ["bp28","bp31"];
			m_aBetPosList["bp2932"] = ["bp29","bp32"];
			m_aBetPosList["bp3033"] = ["bp30","bp33"];
			m_aBetPosList["bp3134"] = ["bp31","bp34"];
			m_aBetPosList["bp3235"] = ["bp32","bp35"];
			m_aBetPosList["bp3336"] = ["bp33","bp36"];
			m_aBetPosList["bp0001"] = ["bp0","bp1"];
			m_aBetPosList["bp0002"] = ["bp0","bp2"];
			m_aBetPosList["bp0003"] = ["bp0","bp3"];
			m_aBetPosList["bp0102"] = ["bp1","bp2"];
			m_aBetPosList["bp0203"] = ["bp2","bp3"];
			m_aBetPosList["bp0405"] = ["bp4","bp5"];
			m_aBetPosList["bp0506"] = ["bp5","bp6"];
			m_aBetPosList["bp0708"] = ["bp7","bp8"];
			m_aBetPosList["bp0809"] = ["bp8","bp9"];
			m_aBetPosList["bp1011"] = ["bp10","bp11"];
			m_aBetPosList["bp1112"] = ["bp11","bp12"];
			m_aBetPosList["bp1314"] = ["bp13","bp14"];
			m_aBetPosList["bp1415"] = ["bp14","bp15"];
			m_aBetPosList["bp1617"] = ["bp16","bp17"];
			m_aBetPosList["bp1718"] = ["bp17","bp18"];
			m_aBetPosList["bp1920"] = ["bp19","bp20"];
			m_aBetPosList["bp2021"] = ["bp20","bp21"];
			m_aBetPosList["bp2223"] = ["bp22","bp23"];
			m_aBetPosList["bp2324"] = ["bp23","bp24"];
			m_aBetPosList["bp2526"] = ["bp25","bp26"];
			m_aBetPosList["bp2627"] = ["bp26","bp27"];
			m_aBetPosList["bp2829"] = ["bp28","bp29"];
			m_aBetPosList["bp2930"] = ["bp29","bp30"];
			m_aBetPosList["bp3132"] = ["bp31","bp32"];
			m_aBetPosList["bp3233"] = ["bp32","bp33"];
			m_aBetPosList["bp3435"] = ["bp34","bp35"];
			m_aBetPosList["bp3536"] = ["bp35","bp36"];
			//3连
			m_aBetPosList["bp000102"] = ["bp0","bp1","bp2"];
			m_aBetPosList["bp000203"] = ["bp0","bp2","bp3"];
			m_aBetPosList["bp0103"] = ["bp1","bp2","bp3"];
			m_aBetPosList["bp0406"] = ["bp4","bp5","bp6"];
			m_aBetPosList["bp0709"] = ["bp7","bp8","bp9"];
			m_aBetPosList["bp1012"] = ["bp10","bp11","bp12"];
			m_aBetPosList["bp1315"] = ["bp13","bp14","bp15"];
			m_aBetPosList["bp1618"] = ["bp16","bp17","bp18"];
			m_aBetPosList["bp1921"] = ["bp19","bp20","bp21"];
			m_aBetPosList["bp2224"] = ["bp22","bp23","bp24"];
			m_aBetPosList["bp2527"] = ["bp25","bp26","bp27"];
			m_aBetPosList["bp2830"] = ["bp28","bp29","bp30"];
			m_aBetPosList["bp3133"] = ["bp31","bp32","bp33"];
			m_aBetPosList["bp3436"] = ["bp34","bp35","bp36"];
			//4连
			m_aBetPosList["bp0105"] = ["bp1","bp2","bp4","bp5"];
			m_aBetPosList["bp0206"] = ["bp2","bp3","bp5","bp6"];
			m_aBetPosList["bp0408"] = ["bp4","bp5","bp7","bp8"];
			m_aBetPosList["bp0509"] = ["bp5","bp6","bp8","bp9"];
			m_aBetPosList["bp0711"] = ["bp7","bp8","bp10","bp11"];
			m_aBetPosList["bp0812"] = ["bp8","bp9","bp11","bp12"];
			m_aBetPosList["bp1014"] = ["bp10","bp11","bp13","bp14"];
			m_aBetPosList["bp1115"] = ["bp11","bp12","bp14","bp15"];
			m_aBetPosList["bp1317"] = ["bp13","bp14","bp16","bp17"];
			m_aBetPosList["bp1418"] = ["bp14","bp15","bp17","bp18"];
			m_aBetPosList["bp1620"] = ["bp16","bp17","bp19","bp20"];
			m_aBetPosList["bp1721"] = ["bp17","bp18","bp20","bp21"];
			m_aBetPosList["bp1923"] = ["bp19","bp20","bp22","bp23"];
			m_aBetPosList["bp2024"] = ["bp20","bp21","bp23","bp24"];
			m_aBetPosList["bp2226"] = ["bp22","bp23","bp25","bp26"];
			m_aBetPosList["bp2327"] = ["bp23","bp24","bp26","bp27"];
			m_aBetPosList["bp2529"] = ["bp25","bp26","bp28","bp29"];
			m_aBetPosList["bp2630"] = ["bp26","bp27","bp29","bp30"];
			m_aBetPosList["bp2832"] = ["bp28","bp29","bp31","bp32"];
			m_aBetPosList["bp2933"] = ["bp29","bp30","bp32","bp33"];
			m_aBetPosList["bp3135"] = ["bp31","bp32","bp34","bp35"];
			m_aBetPosList["bp3236"] = ["bp32","bp33","bp35","bp36"];
			//6连
			m_aBetPosList["bp0106"] = ["bp1","bp2","bp3","bp4","bp5","bp6"];
			m_aBetPosList["bp0409"] = ["bp4","bp5","bp6","bp7","bp8","bp9"];
			m_aBetPosList["bp0712"] = ["bp7","bp8","bp9","bp10","bp11","bp12"];
			m_aBetPosList["bp1015"] = ["bp10","bp11","bp12","bp13","bp14","bp15"];
			m_aBetPosList["bp1318"] = ["bp13","bp14","bp15","bp16","bp17","bp18"];
			m_aBetPosList["bp1621"] = ["bp16","bp17","bp18","bp19","bp20","bp21"];
			m_aBetPosList["bp1924"] = ["bp19","bp20","bp21","bp22","bp23","bp24"];
			m_aBetPosList["bp2227"] = ["bp22","bp23","bp24","bp25","bp26","bp27"];
			m_aBetPosList["bp2530"] = ["bp25","bp26","bp27","bp28","bp29","bp30"];
			m_aBetPosList["bp2833"] = ["bp28","bp29","bp30","bp31","bp32","bp33"];
			m_aBetPosList["bp3136"] = ["bp31","bp32","bp33","bp34","bp35","bp36"];
			//center table
			m_aBetPosList["bpf0"] = ["bp0","bp3","bp15","bp26","bp32"];
			m_aBetPosList["bpf1"] = ["bp1","bp14","bp16","bp20","bp33"];
			m_aBetPosList["bpf2"] = ["bp2","bp4","bp17","bp21","bp25"];
			m_aBetPosList["bpf3"] = ["bp3","bp0","bp12","bp26","bp35"];
			m_aBetPosList["bpf4"] = ["bp4","bp2","bp15","bp19","bp21"];
			m_aBetPosList["bpf5"] = ["bp5","bp10","bp16","bp23","bp24"];
			m_aBetPosList["bpf6"] = ["bp6","bp13","bp17","bp27","bp34"];
			m_aBetPosList["bpf7"] = ["bp7","bp12","bp18","bp28","bp29"];
			m_aBetPosList["bpf8"] = ["bp8","bp10","bp11","bp23","bp24"];
			m_aBetPosList["bpf9"] = ["bp9","bp14","bp18","bp22","bp31"];
			m_aBetPosList["bpf10"] = ["bp10","bp5","bp8","bp23","bp24"];
			m_aBetPosList["bpf11"] = ["bp11","bp8","bp13","bp30","bp36"];
			m_aBetPosList["bpf12"] = ["bp12","bp3","bp7","bp28","bp35"];
			m_aBetPosList["bpf13"] = ["bp13","bp6","bp11","bp27","bp36"];
			m_aBetPosList["bpf14"] = ["bp14","bp1","bp9","bp20","bp31"];
			m_aBetPosList["bpf15"] = ["bp15","bp0","bp4","bp19","bp32"];
			m_aBetPosList["bpf16"] = ["bp16","bp1","bp5","bp24","bp33"];
			m_aBetPosList["bpf17"] = ["bp17","bp2","bp6","bp25","bp34"];
			m_aBetPosList["bpf18"] = ["bp18","bp7","bp9","bp22","bp29"];
			m_aBetPosList["bpf19"] = ["bp19","bp4","bp15","bp21","bp32"];
			m_aBetPosList["bpf20"] = ["bp20","bp1","bp14","bp31","bp33"];
			m_aBetPosList["bpf21"] = ["bp21","bp2","bp4","bp19","bp25"];
			m_aBetPosList["bpf22"] = ["bp22","bp9","bp18","bp29","bp31"];
			m_aBetPosList["bpf23"] = ["bp23","bp5","bp8","bp10","bp30"];
			m_aBetPosList["bpf24"] = ["bp24","bp5","bp10","bp16","bp33"];
			m_aBetPosList["bpf25"] = ["bp25","bp2","bp17","bp21","bp34"];
			m_aBetPosList["bpf26"] = ["bp26","bp0","bp3","bp32","bp35"];
			m_aBetPosList["bpf27"] = ["bp27","bp6","bp13","bp34","bp36"];
			m_aBetPosList["bpf28"] = ["bp28","bp7","bp12","bp29","bp35"];
			m_aBetPosList["bpf29"] = ["bp29","bp7","bp18","bp22","bp28"];
			m_aBetPosList["bpf30"] = ["bp30","bp8","bp11","bp23","bp36"];
			m_aBetPosList["bpf31"] = ["bp31","bp9","bp14","bp20","bp22"];
			m_aBetPosList["bpf32"] = ["bp32","bp0","bp15","bp19","bp26"];
			m_aBetPosList["bpf33"] = ["bp33","bp1","bp16","bp20","bp24"];
			m_aBetPosList["bpf34"] = ["bp34","bp6","bp17","bp25","bp27"];
			m_aBetPosList["bpf35"] = ["bp35","bp3","bp12","bp26","bp28"];
			m_aBetPosList["bpf36"] = ["bp36","bp11","bp13","bp27","bp30"];
			m_aBetPosList["bpleft"] = ["bp5","bp8","bp10","bp11","bp13","bp16","bp23","bp24","bp27","bp30","bp33","bp36"];
			m_aBetPosList["bpcenter"] = ["bp1","bp6","bp9","bp14","bp17","bp20","bp31","bp34"];
			m_aBetPosList["bpright"] = ["bp0","bp2","bp3","bp4","bp7","bp12","bp15","bp18","bp19","bp21","bp22","bp25","bp26","bp28","bp29","bp32","bp35"];
			m_aBetPosList["bpright0"] = ["bp0","bp3","bp12","bp15","bp26","bp32","bp35"];
			m_BetPosPlayList = m_aBetPosList;
			if (m_BetPosList) {
				var index:int = 0;
				while (index<m_BetPosList.length) {//获取投注位置（name）
					if (m_right[m_BetPosList[index]]) {
						var pp:BetPosView = m_right[m_BetPosList[index]] as BetPosView;
					}
					if (m_center[m_BetPosList[index]]) {
						pp = m_center[m_BetPosList[index]] as BetPosView;
					}
					if (pp) {
						pp.SetBetPosManager (this);
					}
					index++;
				}
			}
		}
		public override function SetPlayBetOver (betPos:String):void {
			if (m_BetPosPlayList[betPos] == null) {
				return;
			}
			var index:int = 0;
			var list:Array = m_BetPosPlayList[betPos] as Array;
			while (index < list.length) {
				var name:String = list[index];
				if(m_right.getChildByName(name)){
				m_right[name].gotoAndStop (11);
				}
				index++;
			}
		}
		public override function SetPlayBetOut (betPos:String):void {
			if (m_BetPosPlayList[betPos] == null) {
				return;
			}
			var index:int = 0;
			var list:Array = m_BetPosPlayList[betPos] as Array;
			while (index < list.length) {
				var name:String = list[index];
				if(m_right.getChildByName(name)){
				m_right[name].gotoAndStop (1);
				}
				index++;
			}
		}
		protected override function GetBetPosView (index:int):BetPosView {
			if (index < 0 || index >= m_BetPosList.length) {
				return null;
			}
			var bpvName:String = m_BetPosList[index].toString();
			if (m_right[bpvName]) {
				return (m_right[bpvName] as BetPosView);
			}
			return (m_center[bpvName] as BetPosView);
		}
		override public function SetBetLimitByPos (limitByPos:Array,minLimit:int):void {
			m_betpospoint=new Array();
			var index:int = 0;
			m_betlimitByPos=new Array();
			m_minbetlimitByPos=new Array();
			for (index; index<m_BetPosList.length; index++) {
				if (m_BetPosList[index] && m_right[m_BetPosList[index]]) {
					if (m_aBetPosList[m_BetPosList[index]]) {
						var arr:Array = m_aBetPosList[m_BetPosList[index]];
						switch (arr.length) {
							case 2 ://2连
								m_betlimitByPos[index+1] = limitByPos[1]*BetPosMultiple.Two;
								m_minbetlimitByPos[index+1]=const_Chip[0];
								break;
							case 3 ://3连
								m_betlimitByPos[index+1] = limitByPos[1]*BetPosMultiple.Three;
								m_minbetlimitByPos[index+1]=const_Chip[0];
								break;
							case 4 ://4连
								m_betlimitByPos[index+1] = limitByPos[1]*BetPosMultiple.Four;
								m_minbetlimitByPos[index+1]=const_Chip[0];
								break;
							case 6 ://6连
								m_betlimitByPos[index+1] = limitByPos[1]*BetPosMultiple.Six;
								m_minbetlimitByPos[index+1]=const_Chip[0];
								break;
						}
						if (arr==m_aBetPosList["bp000102"] || arr==m_aBetPosList["bp000203"] ) {
							m_betlimitByPos[index+1] = limitByPos[1]*BetPosMultiple.Three;
							m_minbetlimitByPos[index+1]=const_Chip[0];
						}
						//打
						if (arr==m_aBetPosList["bp0112"] || arr==m_aBetPosList["bp1324"] || arr==m_aBetPosList["bp2536"]) {
							m_betlimitByPos[index+1] = limitByPos[1]*BetPosMultiple.Dozen;
							m_minbetlimitByPos[index+1]=limitByPos[1]*BetPosMultiple.minbet;
						}
						//列
						if (arr==m_aBetPosList["bp0134"] || arr==m_aBetPosList["bp0235"] || arr==m_aBetPosList["bp0336"]) {
							m_betlimitByPos[index+1] = limitByPos[1]*BetPosMultiple.Column;
							m_minbetlimitByPos[index+1]=limitByPos[1]*BetPosMultiple.minbet;
						}
						//大小
						if (arr==m_aBetPosList["bpsmall"] || arr==m_aBetPosList["bpbig"]) {
							m_betlimitByPos[index+1] = limitByPos[1]*BetPosMultiple.BigOrSmall;
							m_minbetlimitByPos[index+1]=limitByPos[1]*BetPosMultiple.minbet;
						}
						//红黑
						if (arr==m_aBetPosList["bpred"] || arr==m_aBetPosList["bpblack"]) {
							m_betlimitByPos[index+1] = limitByPos[1]*BetPosMultiple.RedOrBack;
							m_minbetlimitByPos[index+1]=limitByPos[1]*BetPosMultiple.minbet;
						}
						//单双
						if (arr==m_aBetPosList["bpodd"] || arr==m_aBetPosList["bpeven"]) {
							m_betlimitByPos[index+1] = limitByPos[1]*BetPosMultiple.SingleOrDouble;
							m_minbetlimitByPos[index+1]=limitByPos[1]*BetPosMultiple.minbet;
						}
					} else {
						m_betlimitByPos[index+1] = limitByPos[1]*BetPosMultiple.One;
						m_minbetlimitByPos[index+1]=const_Chip[0];
					}
				var pp:BetPosView = m_right[m_BetPosList[index]] as BetPosView;
				m_betpospoint[index]=pp.GetPoint();
				}
			}
			BetPosLimit(m_betlimitByPos,m_minbetlimitByPos);
			BetPosPoint(m_betpospoint);
		}
		override public function ShowBetTotal (wChairID:int,wBetPos:int,nBetValue:Number):void {
			m_betTotal = nBetValue;
			var view:BetPosView = GetBetPosView(wBetPos-1);
			 if(view){
				 view.ShowBetTotal(m_betTotal);
			 }
		}
		public override function SetLang(strlang:String):void{
			if(m_center && m_center.getChildByName("lang")){
				m_center["lang"].mouseEnabled=false;
				m_center["lang"].gotoAndStop(strlang);
			}
		}
		//下注
		override public function OnBet (betPosIndex:int):void {
			if(m_inforpane){
				m_inforpane.OnBet (betPosIndex);
			}
		}
		override  public function BetPosLimit(betlimitByPos:Array,minbetposlimit:Array):void{
			if(m_inforpane){
				m_inforpane.BetPosLimit(betlimitByPos,minbetposlimit);
			}
		}
		override public function BetPosPoint(arrpoint:Array):void{
			if(m_inforpane){
				m_inforpane.BetPosPoint(arrpoint);
			}
		}
		override public function ShowBetPos(isShow:Boolean,w_BetPos:int,bettotal:Number):void{
			if(m_inforpane){
				m_inforpane.ShowBetPos(isShow,w_BetPos,bettotal);
			}
		}
		override public function SetInfo(infopane:Object):void{
			if(infopane){
				m_inforpane=infopane as InfoPane ;
			}
		}
	}
}
include "../../CommonModule/CHIPCONST.as"