package  {
	
	import MyButton;
	import flash.display.Sprite;
	import flash.display.Shape;
	import flash.geom.Rectangle;
	
	
	public class Button_openList extends MyButton {
		
		var isListOpened: Boolean = false;
		var listWindow: ListWindow;
		var listWindowMask: Sprite;
		var side: Shape;
		var facet: Shape;
		var smallHitRect: Rectangle = new Rectangle(0, 0, 20, 20);
		var tempRect: Rectangle;
		
		public function Button_openList(): void {
			
			listWindow = new ListWindow();
			listWindow.y = 20;
			listWindow.x = -200;
			
			hitRect = new Rectangle(-200, 0, 220, 20+listWindow.capacity*20);
			
			side = new Shape();
			side.graphics.beginFill(0x051120);
			side.graphics.lineStyle();
			side.graphics.drawRect(0, 0, 200+20, listWindow.capacity*20);
			side.x = -200;
			side.y = 20;
			
			listWindow.addOption(new Button_listOption("(0) Graffiti"));
			listWindow.addOption(new Button_listOption("(1) Item"));
			listWindow.addOption(new Button_listOption("(2) Wall brush"));
			listWindow.addOption(new Button_listOption("(2) Structure"));
			listWindow.addOption(new Button_listOption("(2) Unit"));
			listWindow.addOption(new Button_listOption("(3) Atmosphere effect"));
			listWindow.addOption(new Button_listOption("(4) Roof"));
			listWindow.addOption(new Button_listOption("(5) Sky object"));
			
			facet = new Shape();
			facet.graphics.beginFill(0x000000, 0);
			facet.graphics.lineStyle(2, 0x133241);
			facet.graphics.drawRect(0, 0, 200+20, listWindow.capacity*20);
			facet.x = -200;
			facet.y = 20;
			
			listWindowMask = new Sprite;
			listWindowMask.graphics.beginFill(0x000000);
			listWindowMask.graphics.drawRect(-200-1, 20-1, 200+20+2, listWindow.capacity*20+2);
			
			//addChild(listWindowMask);
			//listWindow.mask = listWindowMask;
		}
		
		override function onMove(): void {
			if (!isListOpened) {
				gotoAndStop(2);
			}
		}
		override function onOut(): void {
			isListOpened = false;
			if (contains(listWindow)) {
				removeChild(side);
				removeChild(listWindow);
				removeChild(listWindowMask);
				removeChild(facet);
				advancedHit = 0;
			}
			gotoAndStop(1);
		}
		override function onDown(): void {
			if (isListOpened) {
				tempRect = smallHitRect;
				smallHitRect = hitRect;
				hitRect = tempRect;
				if (isHit()) {
					isListOpened = false;
					if (contains(listWindow)) {
						removeChild(side);
						removeChild(listWindow);
						removeChild(listWindowMask);
						removeChild(facet);
						advancedHit = 0;
					}
					gotoAndStop(2);
				}
				tempRect = smallHitRect;
				smallHitRect = hitRect;
				hitRect = tempRect;
			} else {
				isListOpened = true;
				addChild(side);
				addChild(listWindow);
				addChild(listWindowMask);
				listWindow.mask = listWindowMask;
				addChild(facet);
				advancedHit = 2;
				gotoAndStop(3);
			}
		}
		override function onButtonDown(b: MyButton): void {
			
		}
		
	}
	
}
