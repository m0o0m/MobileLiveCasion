package ChipSelect{

	public class Chip5 extends ChipBaseView {

		/*
		 * 5元筹码
		*/
		public function Chip5 () {
			money = 5;
			posIndex = 1;
			SetChipStatus (true);
			SetChipOverOrOutStatus (true);
		}
	}
}