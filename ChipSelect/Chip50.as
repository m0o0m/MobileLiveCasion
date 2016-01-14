package ChipSelect{


	public class Chip50 extends ChipBaseView {

		/*
		 * 50元筹码
		*/
		public function Chip50 () {
			money = 50;
			posIndex =4;
			SetChipStatus (true);
			SetChipOverOrOutStatus (true);
		}
	}

}