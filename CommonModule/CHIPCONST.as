/*const const_Chip:Array = [5,10,50,100,500,1000,5000,10000,50000]; //筹码
const const_ChipClass:Array = ["ChipView5","ChipView10","ChipView50","ChipView100","ChipView500","ChipView1000","ChipView5000","ChipView10000","ChipView50000"];*/
const const_Chip:Array = [1,5,10,20,50,100,500,1000,5000,10000,20000,50000,100000,200000,500000,1000000,2000000,5000000,10000000,20000000,50000000,100000000]; //筹码

/*
 * 返回当前所选筹码代表的币值
 @ index 筹码索引
*/		
function ChipMoney(index:int):Number{
	var money:Number=0;
	if(index>=0&&index<const_Chip.length){
		money=Number(const_Chip[index]);
	}
	return money;
}