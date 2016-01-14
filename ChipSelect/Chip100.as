package ChipSelect{

	public class Chip100 extends ChipBaseView {

		/*
		 * 100元筹码
		*/
		public function Chip100 () {
			money = 100;
			posIndex = 5;
			SetChipStatus (true);
			SetChipOverOrOutStatus (true);
		}
	}

}