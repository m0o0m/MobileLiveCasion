package ChipSelect{


	public class Chip5000 extends ChipBaseView {

		/*
		 * 5000元筹码
		*/
		public function Chip5000 () {
			money = 5000;
			posIndex = 8;
			SetChipStatus (true);
			SetChipOverOrOutStatus (true);
		}
	}

}