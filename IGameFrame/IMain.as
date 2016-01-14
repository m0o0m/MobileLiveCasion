package  IGameFrame{	
	public interface IMain {
		//设置参数
		function SetParam(mainLoad:ILoad, param:Object):void;
		//设备返回时间
		function GoBack():void;
	}
}