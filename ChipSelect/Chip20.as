package ChipSelect{


	public class Chip20 extends ChipBaseView {

		/*
		 * 20元筹码
		*/
		public function Chip20 () {
			money = 20;
			posIndex = 3;
			SetChipStatus (true);
			SetChipOverOrOutStatus (true);
		}
	}

}