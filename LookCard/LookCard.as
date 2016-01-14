package  {
	import flash.system.System;
	import flash.system.Security;
	import flash.system.ApplicationDomain;
	import flash.display.MovieClip;
	import ISWFModule.IModule;
	
	public class LookCard extends MovieClip implements IModule {
		public var ClassMap:Array = [
									 "FlipCardWindow", FlipCardWindow
									 ];
		public function LookCard() {
			//Security.allowDomain("*");
			System.useCodePage=true;
		}
		//获取定义类
		public function GetClass(strName:String):Class {
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