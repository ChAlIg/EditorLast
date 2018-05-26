package  {
	
	import MyButton;
	
	
	public class Button_exit extends MyButton {
		
		var firstClick: Boolean = false;
		var second: Button_exit_second;
		
		public function Button_exit() {
			second = new Button_exit_second();
			second.y = 20;
		}
		override function onMove(): void {
			if (!firstClick) {
				gotoAndStop(2);
			}
		}
		override function onOut(): void {
			firstClick = false;
			if (contains(second)) {
				removeChild(second);
			}
			gotoAndStop(1);
		}
		override function onDown(): void {
			if (firstClick) {
				if (!(second.isHit())) {
					firstClick = false;
					if (contains(second)) {
						removeChild(second);
					}
					gotoAndStop(2);
				}
			} else {
				firstClick = true;
				addChild(second);
				gotoAndStop(3);
			}
		}
		override function onButtonDown(b: MyButton): void {
			if (b == second) {
				(parent as MyObject).onButtonDown(this);
			}
		}
		
	}
	
}
