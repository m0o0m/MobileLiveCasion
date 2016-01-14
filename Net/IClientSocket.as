package Net
{

	import flash.utils.ByteArray;
	import flash.errors.EOFError;

	public interface IClientSocket
	{
		//设置接口
		function SetSocketSink(pIUnknownEx:IClientSocketSink):Boolean;
		//获取接口
		function GetSocketSink():IClientSocketSink;
		//获取状态
		function GetConnectState():int;
		//连接服务器
		function Connect(szServerIP:String,wPort:int):Boolean;
		//发送函数
		function SendCmd(wMainCmdID:int,wSubCmdID:int):Boolean;
		//发送函数
		function SendData(wMainCmdID:int,wSubCmdID:int,pData:String):Boolean;
		//关闭连接
		function CloseSocket(bNotify:Boolean):Boolean;
		//接口查询
		function QueryInterface():IClientSocket;
	}
}
