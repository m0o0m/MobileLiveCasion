package ChipSelect{

	public class Chip1000 extends ChipBaseView {

		/*
		 * 1000元筹码
		*/
		public function Chip1000 () {
			money = 1000;
			posIndex = 7;
			SetChipStatus (true);
			SetChipOverOrOutStatus (true);
		}
	}

}