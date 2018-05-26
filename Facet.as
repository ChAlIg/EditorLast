package  {
	
	import MyObject;
	import flash.display.MovieClip;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFormat;
	//import flash.filters.GlowFilter;
	
	public class Facet extends MyObject {
		
		public var editor: Editor;
		public var up: Facet_up;
		public var left: Facet_left;
		public var log: TextField;
		public var textFormat: TextFormat;
		var logSide: LogSide;
		
		public function Facet(theEditor: Editor) {
			editor = theEditor;
			up = new Facet_up();
			left = new Facet_left(editor);
			addChild(up);
			addChild(left);
			left.y = 20;
			logSide = new LogSide();
			addChild(logSide);
			log = new TextField();
			log.height = 24;
			log.width = 595;
			log.x = 205;
			log.y = 588;
			log.embedFonts = true;
			textFormat = new TextFormat (new AvenirItalic().fontName, 12, 0x529EB7);
			textFormat.align = "right";
			log.defaultTextFormat = textFormat;
			log.text = "version 0.1";
			//log.filters = [new GlowFilter(0x000B19, 1.0, 2.0, 2.0, 7.5, 3)]
			addChild(log);
			Lib.log = log;
		
		}
		
		public function alignFacet (nativeWidth: int, nativeHeight: int, fullScreenWidth: int, fullScreenHeight: int) {
			up.x = (nativeWidth - fullScreenWidth)/2;
			up.y = (nativeHeight - fullScreenHeight)/2;
			up.side.width = fullScreenWidth;
			up.exitButton.x = fullScreenWidth - 25;
			
			left.x = (nativeWidth - fullScreenWidth)/2;
			//left.view.x = (nativeWidth - fullScreenWidth)/2;
			left.y = (nativeHeight - fullScreenHeight)/2 + up.height - 1;
			//left.view.y = (nativeWidth - fullScreenWidth)/2;
			left.side.height = fullScreenHeight - up.height + 4;
			//left.view.height = fullScreenHeight - up.height + 4 - left.buttons.length * 20;
			left.patternWindowMask.y = 15;
			left.patternWindowMask.x = 0;
			left.patternWindowMask.height = fullScreenHeight - up.height + 4 - left.buttons.length * 20 - 15;
			//left.removeChild(left.view);
			/*left.view.graphics.clear();
			left.view.graphics.beginFill(0x000000);
			left.view.graphics.drawRect(0, 0, 200, fullScreenHeight - up.height + 4 - left.buttons.length * 20);*/
			//editor.debug.text = ("" + (fullScreenHeight - up.height + 4 - left.buttons.length * 20));
			logSide.width = log.width = fullScreenWidth - 205;
			logSide.x = (nativeWidth + fullScreenWidth)/2;
			logSide.y = (nativeHeight + fullScreenHeight)/2;
			log.x = (nativeWidth - fullScreenWidth)/2 + 205;
			log.y = (nativeHeight + fullScreenHeight)/2 - 18;
			
			for (var i: int = 0; i < left.buttons.length; ++i) {
				left.buttons[i].y = left.side.height - (i+1)*18 - 4;
			}
			
		}
		
		override function isHit(): Boolean {
			return ((left.isHit()) || (up.isHit()));
		}
		
	}
	
}
