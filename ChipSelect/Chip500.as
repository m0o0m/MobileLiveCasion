package ChipSelect{

	public class Chip500 extends ChipBaseView {

		/*
		 * 500元筹码
		*/
		public function Chip500 () {
			money = 500;
			posIndex = 6;
			SetChipStatus (true);
			SetChipOverOrOutStatus (true);
		}
	}

}