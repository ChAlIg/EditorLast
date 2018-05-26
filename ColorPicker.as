package  {
	
	import MyObject;
	import flash.display.Bitmap;
	
	public class ColorPicker extends MyObject {
		var colorWheel: Bitmap;
		public var color: uint = 0xAF1E6C;
		public var patternEditor: PatternEditor;
		
		public function ColorPicker(thePatternEditor: PatternEditor) {
			patternEditor = thePatternEditor;
			colorWheel = new Bitmap(new ColorWheel(), "auto", true);
			addChild(colorWheel);
			scaleX = scaleY = 0.75;
		}
		
		override function onMove(): void {
			if (colorWheel.bitmapData.getPixel(colorWheel.mouseX, colorWheel.mouseY)) {
				(parent as PatternEditor).text_color.txt.textColor = colorWheel.bitmapData.getPixel(colorWheel.mouseX, colorWheel.mouseY);
				(parent as PatternEditor).text_color.txt.text = (parent as PatternEditor).text_color.txt.textColor.toString(16).toUpperCase();
			} else {
				(parent as PatternEditor).text_color.txt.textColor = color;
				(parent as PatternEditor).text_color.txt.text = color.toString(16).toUpperCase();
			}
		}
		
		override function onDown(): void {
			if (colorWheel.bitmapData.getPixel(colorWheel.mouseX, colorWheel.mouseY)) {
				patternEditor.tileColour = color = colorWheel.bitmapData.getPixel(colorWheel.mouseX, colorWheel.mouseY);
			}
		}
		
		override function onOut(): void {
			(parent as PatternEditor).text_color.txt.textColor = color;
			(parent as PatternEditor).text_color.txt.text = color.toString(16).toUpperCase();
		}
	}
	
}
