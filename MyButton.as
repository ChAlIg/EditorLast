package  {
	import MyObject;
	
	public class MyButton extends MyObject {

		public function MyButton() {
			
		}
		
		override function onDown(): void {
			(parent as MyObject).onButtonDown(this);
		}
		
		override function onMove(): void {
			gotoAndStop(2);
		}
		override function onOut(): void {
			gotoAndStop(1);
		}

	}
	
}
