package  {
	
	import MyObject;
	import MyButton;
	//import flash.display.Shape;
	
	public class ListWindow extends MyObject {
		public var position: int = 0;
		public var capacity: int = 5;
		public var shiftPace: int = 20;
		public var options: Vector.<Button_listOption>;
		//var facet: Shape;
		
		public function ListWindow(): void {
			options = new Vector.<Button_listOption>;
			
			/*facet = new Shape();
			facet.graphics.beginFill(0x000000, 0);
			facet.graphics.lineStyle(2, 0x133241);
			facet.graphics.drawRect(0, 0, 220, 20*5);
			addChild(facet);*/
		}
		override function onButtonDown(b: MyButton): void {
			(parent as MyObject).onButtonDown(b);
		}
		override function onWheel (delta: int): void {
			if ((delta > 0) && (position > 0)) {
				--position;
				y += shiftPace;
			} else if ((delta < 0) && ((position + capacity) < options.length)) {
				++position;
				y -= shiftPace;
			}
		}
		public function addOption (option: MyButton) {
			option.y = options.length * 20;
			options.push(option);
			addChild(option);
		}
	}
	
}
