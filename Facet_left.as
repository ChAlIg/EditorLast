package  {
	import MyObject;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.display.Sprite;
	import flash.filters.GlowFilter;
	import flash.filters.BitmapFilterQuality; 
	
	public class Facet_left extends MyObject {
		
		public var editor: Editor;
		public var buttons: Vector.<Facet_left_button> = new Vector.<Facet_left_button>();
		public var patternWindow: PatternWindow;
		var t: Facet_left_button;
		var i: int;
		var point: Point = new Point (-1, -1);
		public var side: Facet_left_side;
		var patternWindowMask: Sprite;
		public var upside: Facet_left_upside;
		public var upButtons: Array;
		public var scroll: Facet_left_scroll;
		
		
		public function Facet_left (theEditor: Editor) {
			editor = theEditor;
			side = new Facet_left_side();
			addChild(side);
			patternWindow = new PatternWindow(editor);
			patternWindow.y = 15;
			addChild(patternWindow);
			
			scroll = new Facet_left_scroll();
			scroll.x = 200;
			scroll.y = 15;
			addChild(scroll);
			
			upside = new Facet_left_upside();
			addChild(upside);
			
			upButtons = new Array();
			upButtons.push(new Button_arrow(), new Button_A(), new Button_T());
			for (i = upButtons.length - 1; i >= 0; --i) {
				upButtons[i].x = i*15;
				addChild(upButtons[i]);
			}
			
			//t = new Facet_left_button();
			//t.txt.text = "New Pattern Type";
			//buttons.push(t);
			
			t = new Facet_left_button();
			t.txt.text = "New Pattern";
			buttons.push(t);
			
			for (i = buttons.length - 1; i >= 0; --i) {
				buttons[i].y = 600 - (i+1)*18 - 4;
				addChild(buttons[i]);
			}
			
			patternWindowMask = new Sprite;
			patternWindowMask.graphics.beginFill(0x000000);
			patternWindowMask.graphics.drawRect(0, 0, 200, 578 - 18*buttons.length);
			addChild(patternWindowMask);
			
			patternWindow.mask = patternWindowMask;
			
			focusRect = false;
			
		}
		
	}
	
}
