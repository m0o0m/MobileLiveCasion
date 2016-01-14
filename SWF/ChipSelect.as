package  {
	import flash.system.System;
	import flash.system.Security;
	import flash.system.ApplicationDomain;
	import flash.display.MovieClip;
	import ISWFModule.IModule;
	import ChipSelect.*;
	public class ChipSelect extends MovieClip implements IModule{
		public var ClassMap:Array=[
									"Affirm",ChipSelect.Affirm,
									"Cancel",ChipSelect.Cancel,
									"Line",ChipSelect.Line,
									"Chip1",ChipSelect.Chip1,
									"Chip5",ChipSelect.Chip5,
									"Chip10",ChipSelect.Chip10,
									"Chip20",ChipSelect.Chip20,
									"Chip50",ChipSelect.Chip50,
									"Chip100",ChipSelect.Chip100,
									"Chip500",ChipSelect.Chip500,
									"Chip1000",ChipSelect.Chip1000,
									"Chip5000",ChipSelect.Chip5000,
									"Chip10000",ChipSelect.Chip10000,
									"ChipSetting",ChipSelect.ChipSetting,
									"ChipSettingMore",ChipSelect.ChipSettingMore,
									"ChipSettingLeft",ChipSelect.ChipSettingLeft,
									"ChipSettingRight",ChipSelect.ChipSettingRight,
									"TotalChipPane",ChipSelect.TotalChipPane,
									
									"ChipSelectBaseManager",ChipSelect.ChipSelectBaseManager,
									"ChipBaseView",ChipSelect.ChipBaseView
									]
		var BetChipView:Array = [ChipView1,ChipView5,ChipView10,ChipView20,ChipView50,ChipView100,ChipView500,ChipView1000,ChipView5000,ChipView10000,ChipView20K,ChipView50K,ChipView100K,ChipView200K,ChipView500K,ChipView1M,ChipView2M,ChipView5M,ChipView10M,ChipView20M,ChipView50M,ChipView100M];
			
		public function ChipSelect() {
			// constructor code
			//Security.allowDomain("*");
			System.useCodePage=true;
		}
		//获取定义类
		public function GetClass(strName:String):Class {
			if(strName.indexOf("BetChipView") > -1) {
				var chipIndex:int = int(strName.replace("BetChipView", ""));
				
				if(chipIndex < 0 || chipIndex >= BetChipView.length) {
					return BetChipView[0];
				}
				return BetChipView[chipIndex];
			}
			var index:int = ClassMap.indexOf(strName);
			if(index == -1) {
				return null;
			}
			return ClassMap[index+1];
		}
		//获取当前应用域
		public function getApplicationDomain():ApplicationDomain {
			return ApplicationDomain.currentDomain;
		}
	}
}
