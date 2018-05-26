package  {
	import MyObject;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.display.Bitmap;
	import flash.system.System;
	
	public class Facet_up extends MyObject {
		
		public var buttons: Vector.<Facet_up_button>;
		public var side: Facet_up_side;
		public var exitButton: ExitButton;
		public var logo: Logo;
		
		public function Facet_up() {
			
			side = new Facet_up_side();
			addChild(side);
			
			buttons = new Vector.<Facet_up_button>();
			
			var t: Facet_up_button;
			t = new Facet_up_button();
			t.txt.text = "New";
			buttons.push(t);
			t = new Facet_up_button();
			t.txt.text = "Open";
			buttons.push(t);
			t = new Facet_up_button();
			t.txt.text = "Save As";
			buttons.push(t);
			t = new Facet_up_button();
			t.txt.text = "Save";
			buttons.push(t);
			
			for (var i: int = 0; i < buttons.length; ++i) {
				buttons[i].x = 30 + i*buttons[i].width;
				addChild(buttons[i]);
			}
			
			exitButton = new ExitButton();
			exitButton.x = 770;
			addChild(exitButton);
			
			logo = new Logo();
			addChild(logo);
			
			focusRect = false;
			
		}
		
		override function onButtonDown (b: MyButton): void {
			if (b == exitButton) {
				System.exit(0);
			}
			/*switch (b) {
				case (logo as MyButton):
					System.exit(0);
					break;
				default:
					break;
				
			}*/
		}
		
	}
	
}
