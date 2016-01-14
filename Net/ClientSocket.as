package Net
{
	import flash.errors.*;
	import flash.events.*;
	import flash.net.Socket;
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	import flash.utils.Timer;
	import flash.system.*;
	import Net.Comm.*;

	public class ClientSocket implements IClientSocket
	{
		//状态变量
		protected var m_bCloseByServer:Boolean;//关闭方式
		protected var m_SocketState:uint;//连接状态
		protected var m_pIClientSocketSink:IClientSocketSink;//回调接口

		//核心变量
		protected var m_hSocket:Socket;//连接句柄
		protected var m_wRecvSize:int;//接收长度
		protected var m_cbRecvBuf:ByteArray;//接收缓冲
		
		//心跳信号检测
		protected var m_checkTimer:Timer;//
		protected var m_socketDate:Date;//收到Socket数据最后时间
		
		public function ClientSocket() {
			m_cbRecvBuf=CreateLittleEdian();
			
			m_SocketState=SocketState_NoConnect;
		}
		//接口查询
		public function QueryInterface():IClientSocket
		{
			return this;
		}
		//设置接口
		public function SetSocketSink(pIUnknownEx:IClientSocketSink):Boolean
		{
			m_pIClientSocketSink = pIUnknownEx;
			return m_pIClientSocketSink != null;
		}
		//获取接口
		public function GetSocketSink():IClientSocketSink
		{
			return m_pIClientSocketSink;
		}
		//获取状态
		public function GetConnectState():int
		{
			return m_SocketState;
		}
		//连接服务器
		public function Connect(szServerIP:String,wPort:int):Boolean
		{
			if (m_hSocket != null)
			{
				trace("Socket Connected");
				throw new Error("Socket Connected");
			}
			m_hSocket=new Socket();
			
			configureListeners();
			if (m_hSocket.connected)
			{
				trace("Socket Connected");
				throw new Error("Socket Connected");
			}

			m_wRecvSize=0;

			m_hSocket.connect(szServerIP,wPort);
			m_SocketState=SocketState_Connecting;
			
			return true;
		}
		//发送函数
		public function SendCmd(wMainCmdID:int, wSubCmdID:int):Boolean
		{
			//效验状态
			if (m_hSocket == null)
			{
				trace("SendCmd m_hSocket == null");
				return false;
			}
			if (m_SocketState != SocketState_Connected)
			{
				trace("SendCmd m_SocketState != SocketState_Connected");
				return false;
			}

			//构造数据
			var head:CMD_Head = new CMD_Head;
			head.CommandInfo.wMainCmdID=wMainCmdID;
			head.CommandInfo.wSubCmdID=wSubCmdID;

			//发送数据
			return SendBuffer(head.writeBuffer(), null);
		}
		//发送函数
		public function SendData(wMainCmdID:int, wSubCmdID:int, sData:String):Boolean
		{
			//效验状态
			if (m_hSocket == null)
			{
				trace("m_hSocket == null");
				return false;
			}
			if (m_SocketState != SocketState_Connected)
			{
				trace("m_SocketState != SocketState_Connected");
				return false;
			}
			
			var baBuf:ByteArray = CreateLittleEdian();
			baBuf.writeUTFBytes(sData);
			
			if(baBuf == null) {
				trace(" baBuf.length = " +  baBuf.length);
			}

			var head:CMD_Head = new CMD_Head();
			head.CmdInfo.wDataSize = baBuf.length + CMD_Head.size_CMD_Head;
			head.CommandInfo.wMainCmdID = wMainCmdID;
			head.CommandInfo.wSubCmdID = wSubCmdID;

			//发送数据
			return SendBuffer(head.writeBuffer(), baBuf);
		}
		//关闭连接
		public function CloseSocket(bNotify:Boolean):Boolean
		{
			if(m_checkTimer) {
				m_checkTimer.stop();
				m_checkTimer.removeEventListener(TimerEvent.TIMER, onCheckSocket);
				m_checkTimer = null;
			}
			trace("CloseSocket 关闭连接");
			var bClose:Boolean;
			if (m_SocketState == SocketState_NoConnect)
			{
				bClose= false;
			}
			else
			{
				bClose  = true;

			}
			m_SocketState=SocketState_NoConnect;
			if (m_hSocket != null)
			{
				try
				{
					m_hSocket.close();
				}
				catch(e:Error)
				{
					trace(e);
				}

				if (bNotify == true && m_pIClientSocketSink != null)
				{
					try
					{
						m_pIClientSocketSink.OnSocketClose(this,m_bCloseByServer);
					}
					catch (e:Error)
					{
						trace(e);
					}
				}
			}
			//恢复数据
			m_wRecvSize=0;
			m_bCloseByServer=false;
			deconfigureListeners();
			m_hSocket = null;
			return true;
		}

		private function configureListeners():void
		{
			m_hSocket.addEventListener(Event.CLOSE,closeHandler);
			m_hSocket.addEventListener(Event.CONNECT,connectHandler);
			m_hSocket.addEventListener(IOErrorEvent.IO_ERROR,ioErrorHandler);
			m_hSocket.addEventListener(SecurityErrorEvent.SECURITY_ERROR,securityErrorHandler);
			m_hSocket.addEventListener(ProgressEvent.SOCKET_DATA,socketDataHandler);
		}
		private function deconfigureListeners():void
		{
			if (m_hSocket != null)
			{
				m_hSocket.removeEventListener(Event.CLOSE,closeHandler);
				m_hSocket.removeEventListener(Event.CONNECT,connectHandler);
				m_hSocket.removeEventListener(IOErrorEvent.IO_ERROR,ioErrorHandler);
				m_hSocket.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,securityErrorHandler);
				m_hSocket.removeEventListener(ProgressEvent.SOCKET_DATA,socketDataHandler);
			}
		}
		private function closeHandler(event:Event):void
		{
			trace("closeHandler: " + event);
			m_bCloseByServer=true;
			CloseSocket(true);
		}

		private function connectHandler(event:Event):void
		{
			if (m_hSocket.connected)
			{
				m_socketDate = new Date();
				
				if(m_checkTimer == null) {
					m_checkTimer = new Timer(1000);
					m_checkTimer.addEventListener(TimerEvent.TIMER, onCheckSocket);
				}
				m_checkTimer.reset();
				m_checkTimer.start();
				
				m_SocketState=SocketState_Connected;
				trace("Connected");
			}
			else
			{
				CloseSocket(false);
				trace("Connect error CloseSocket");

			}
			var szErrorDesc:String=event.toString();
			if (m_pIClientSocketSink != null)
			{
				m_pIClientSocketSink.OnSocketConnect(0, szErrorDesc, this);
			}
		}

		private function ioErrorHandler(event:IOErrorEvent):void
		{
			trace("ioErrorHandler: " + event);
			m_bCloseByServer=true;
			CloseSocket(true);
		}

		private function securityErrorHandler(event:SecurityErrorEvent):void
		{
			trace("securityErrorHandler: " + event);
			m_bCloseByServer=true;
			CloseSocket(true);
		}

		private function socketDataHandler(event:ProgressEvent):void
		{
			m_socketDate = new Date();
			try
			{
				//读取数据
				var iRetCode:int=m_hSocket.bytesAvailable;
				m_hSocket.readBytes(m_cbRecvBuf, m_wRecvSize, iRetCode);
				
				m_wRecvSize+= iRetCode;
				
				//处理数据
				while (m_wRecvSize >= CMD_Head.size_CMD_Head)
				{
					//变量定义
					var wPacketSize:int=0;
					var pHead:CMD_Head=CMD_Head.readBuffer(m_cbRecvBuf);

					wPacketSize=pHead.CmdInfo.wDataSize;
					
					if (m_wRecvSize < wPacketSize)
					{
						trace("socketDataHandler: no more data " + m_wRecvSize +"<"+ wPacketSize);
						m_cbRecvBuf.position = 0;
						return;
					}
					//拷贝数据
					var buffer:ByteArray = CreateLittleEdian();
					CopyArray(buffer, m_cbRecvBuf, 0, wPacketSize);
					buffer.position = m_cbRecvBuf.position;
					
					var recvBuffer:ByteArray = CreateLittleEdian();
					CopyArray(recvBuffer, m_cbRecvBuf, wPacketSize, m_wRecvSize);
					
					m_wRecvSize -= wPacketSize;
					m_cbRecvBuf = recvBuffer;
					
					var data:String = buffer.readUTFBytes(pHead.CmdInfo.wDataSize - CMD_Head.size_CMD_Head);
					
					//内核命令
					if (pHead.CommandInfo.wMainCmdID == MDM_KN_COMMAND)
					{
						switch (pHead.CommandInfo.wSubCmdID)
						{
							case SUB_KN_DETECT_SOCKET ://网络检测
								{
									//发送数据
									SendBuffer(buffer, null);
									//SendData(MDM_KN_COMMAND, SUB_KN_DETECT_SOCKET, data);
									break;

							}
						};
						continue;
					}
					var bSuccess:Boolean = false;
					//处理数据
					if (m_pIClientSocketSink)
					{
						bSuccess = m_pIClientSocketSink.OnSocketRead(pHead.CommandInfo.wMainCmdID, pHead.CommandInfo.wSubCmdID, data, this as IClientSocket);
					}
				}
			}
			catch (e:Error)
			{
				trace(e);
				trace(e.getStackTrace());
				System.setClipboard(e.getStackTrace());
				CloseSocket(true);
			}
		}
		
		//发送数据
		private function SendBuffer(headBuffer:ByteArray, pBuffer:ByteArray):Boolean
		{
			m_hSocket.writeBytes(headBuffer);
			if(pBuffer != null && pBuffer.length > 0){
				m_hSocket.writeBytes(pBuffer);
			}
			
			m_hSocket.flush();
			return true;
		}
		public function CreateLittleEdian():ByteArray {
			var result:ByteArray = new ByteArray();
			result.endian = "littleEndian";
			return result;
		}
		/*
		* 拷贝数组
		* @参数 baDes 目标数组
		* @参数 baSrc 原始数组
		* @参数 nStartIndex 起始位置
		* @参数 nEndIndex 结束位置位置
		*/
		protected function CopyArray(baDes:ByteArray, baSrc:ByteArray, nStartIndex:int, nEndIndex:int):void {
			for (var i:int = nStartIndex, j = 0; i<nEndIndex; i++, j++) {
				baDes[j] = baSrc[i];
			}
		}
		private function onCheckSocket(event:TimerEvent):void {
			var sysDate:Date = new Date();
			var total:Number = sysDate.time - m_socketDate.time;
			if(total / 1000 > 30) {
				trace("30秒没有收到Socket信号, 关闭连接!");
				m_bCloseByServer=false;
				CloseSocket(true);
			}
		}
	}
}
include "NetModuleIDef.as"
include "GLOBALDEF.as"
include "GLOBALFRAME.as"