package ChipSelect{

	public class Chip10000 extends ChipBaseView {

		/*
		 * 10000元筹码
		*/
		public function Chip10000 () {
			money = 10000;
			posIndex = 9;
			SetChipStatus (true);
			SetChipOverOrOutStatus (true);
		}
	}
}