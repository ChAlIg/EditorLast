package  {
	
	import MyObject;
	import flash.display.MovieClip;
	import flash.geom.Point;
	import flash.filters.GlowFilter;
	import flash.filters.BitmapFilterQuality; 
	
	public class PatternWindow extends MyObject {
		
		var editor: Editor;
		var selection: Pattern_selection;
		public var patterns: Vector.<Pattern>;
		public var patternsPosition: int = 0;
		public var lastSelectedPattern: Pattern;
		var capacity: int = 4;
		var i: int;
		public var glow: GlowFilter;
		public var shiftPace: int = 100;
		
		public function PatternWindow(theEditor: Editor) {
			
			editor = theEditor;
			glow = new GlowFilter(0xFFFF66, 1.0, 7.0, 7.0, 2.2, BitmapFilterQuality.HIGH, true);
			
			var testPattern: Pattern;
			patterns = new Vector.<Pattern>()
			var v:Vector.<Point> = new Vector.<Point> ();
			v.push(new Point(1, 1), new Point(1, 2), new Point(1, 3), new Point(2, 1), new Point(2, 4), new Point(-9, -4));
			addPattern(testPattern = new Pattern("Lab_table1", v));
			
			i = 1;
			
			var v2:Vector.<Point> = new Vector.<Point> ();
			v2.push(new Point(5, -3), new Point(3, 3), new Point(6, 1), new Point(2, 2), new Point(2, 3));
			addPattern(testPattern = new Pattern("Lab_table"+(++i), v2));
			addPattern(testPattern = new Pattern("Lab_table"+(++i), v));
			addPattern(testPattern = new Pattern("Lab_table"+(++i), v2));
			addPattern(testPattern = new Pattern("Lab_table"+(++i), v));
			addPattern(testPattern = new Pattern("Lab_table"+(++i), v2));
			addPattern(testPattern = new Pattern("Lab_table"+(++i), v));
			addPattern(testPattern = new Pattern("Lab_table"+(++i), v2));
			addPattern(testPattern = new Pattern("Lab_table"+(++i), v));
			addPattern(testPattern = new Pattern("Lab_table"+(++i), v2));
			addPattern(testPattern = new Pattern("Lab_table"+(++i), v));
			addPattern(testPattern = new Pattern("Lab_table"+(++i), v2));
			addPattern(testPattern = new Pattern("Lab_table"+(++i), v));
			
			selection = new Pattern_selection();
		}
		
		public function addPattern (pattern: Pattern) {
			pattern.y = patterns.length * 100;
			patterns.push(pattern);
			addChild(pattern);
		}
		
		override function onWheel (delta: int): void {
			if ((delta > 0) && (patternsPosition > 0)) {
				--patternsPosition;
				y += shiftPace;
			} else if ((delta < 0) && ((patternsPosition + capacity) < patterns.length)) {
				++patternsPosition;
				y -= shiftPace;
			}
		}
		
		public function deselectPattern() {
			if (lastSelectedPattern != null) {
				lastSelectedPattern.filters = [];
			}
		}
		
	}
	
}
