package Net.Comm
{
	import flash.utils.ByteArray;
	//数据包传递包头
	public class CMD_Head
	{
		public static const size_CMD_Head:int = 8;
		public var CmdInfo:CMD_Info = new CMD_Info();	//基础结构
		public var CommandInfo:CMD_Command = new CMD_Command();//命令信息

		public static function readBuffer(buffer:ByteArray):CMD_Head
		{
			var result:CMD_Head = new CMD_Head;
			result.CmdInfo = CMD_Info.readBuffer(buffer);
			result.CommandInfo = CMD_Command.readBuffer(buffer);
			return result;
		}
		public function writeBuffer():ByteArray
		{
			var buffer:ByteArray = new ByteArray();
			buffer.endian = "littleEndian";
			var pos:int = buffer.position;
						
			CmdInfo.writeBuffer(buffer);
			CommandInfo.writeBuffer(buffer);
			buffer.position = pos;
			return buffer;
		}
	}
}