package HistoryRoad
{
	import flash.display.MovieClip;

	/**
	 * 庄问路，闲问路 显示结果
	**/
	public class AskRoad extends MovieClip
	{
		/**
		 * 确定显示的图形
		 @ number 红和蓝，1表示红，2表示蓝
		 @ type 类型 1表示大眼路 2表示小路 3表示小强路
		**/
		public function AskRoad(number:int,type:int)
		{
			if (number==1)
			{
				number = (type - 1) * 2 + number;
			}
			else if (number==2)
			{
				number = number * type;
			}
			gotoAndStop(number);
			x = (width + 6) * (type - 1);
			y = 0;
		}
	}
}