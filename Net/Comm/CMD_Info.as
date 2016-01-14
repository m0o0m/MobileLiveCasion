package Net.Comm
{
	import flash.utils.ByteArray;
	//数据包结构信息
	public class CMD_Info
	{
		public var cbCheckCode:int = 0;						//效验字段BYTE		
		public var cbMessageVer:int = 68;					//版本标识BYTE		
		public var wDataSize:int;						//数据大小WORD		
 		public static function readBuffer(buffer:ByteArray):CMD_Info
		{
			var result:CMD_Info = new CMD_Info;
			result.cbCheckCode = buffer.readByte();
			result.cbMessageVer = buffer.readByte();
			result.wDataSize = buffer.readUnsignedShort();
			return result;
		}
		public function writeBuffer(buffer:ByteArray)
		{
			buffer.writeByte(cbCheckCode);
			buffer.writeByte(cbMessageVer);
			buffer.writeShort(wDataSize);
		}
	}
}