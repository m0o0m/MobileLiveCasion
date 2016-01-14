package Net.Comm
{
	import flash.utils.ByteArray;
	//数据包命令信息
	public class CMD_Command
	{
		public var wMainCmdID:int = 0xffff;							//主命令码WORD		
		public var wSubCmdID:int = 0xffff;							//子命令码WORD
		public static function readBuffer(buffer:ByteArray):CMD_Command
		{
			var result:CMD_Command = new CMD_Command;
			result.wMainCmdID = buffer.readUnsignedShort();
			result.wSubCmdID = buffer.readUnsignedShort();
			return result;
		}
		public function writeBuffer(buffer:ByteArray)
		{
			buffer.writeShort(wMainCmdID);
			buffer.writeShort(wSubCmdID);
		}
	}
}