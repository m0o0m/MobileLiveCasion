package Net
{
	import flash.utils.ByteArray;

	public interface IClientSocketSink
	{
		//网络连接消息
		 function OnSocketConnect(iErrorCode:int,pszErrorDesc:String,pIClientSocket:IClientSocket):Boolean;
		//网络读取消息
		 function OnSocketRead(wMainCmdID:uint,wSubCmdID:uint,pData:String,pIClientSocket:IClientSocket):Boolean;
		//网络关闭消息
		 function OnSocketClose(pIClientSocket:IClientSocket,bCloseByServer:Boolean):Boolean;
	}
}
