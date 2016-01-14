package  {
	import flash.display.MovieClip;
	
	public class RoulRoadInfo extends MovieClip{
		protected var textList:Array=new Array();
		public function RoulRoadInfo() {
			// constructor code
			textList=[this["big"],this["small"],this["odd"],this["even"],this["red"],this["black"],this["zero"]];
		}
		public function ShowRoadInfo(arr:Array):void{
			for(var index:int=0;index<textList.length;index++){
				if(arr[index]){
					textList[index].text=arr[index].toString();
				}
				else{
					textList[index].text="0";
				}
			}
		}
		public function SetLang(strlang:String):void{
			this["luzi"].gotoAndStop(strlang);
		}

	}
	
}
