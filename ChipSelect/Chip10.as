package ChipSelect{

	public class Chip10 extends ChipBaseView {

		/*
		 * 10元筹码
		*/
		public function Chip10 () {
			money = 10;
			posIndex = 2;
			SetChipStatus (true);
			SetChipOverOrOutStatus (true);
		}
	}
}