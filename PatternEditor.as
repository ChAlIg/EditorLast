package  {
	import MyObject;
	import flash.net.FileReference;
	import flash.events.Event;
	import flash.display.Loader;
	import flash.geom.Point;

	//import flash.display.MovieClip;
	//import flash.geom.Point;
	//import flash.display.Bitmap;
	
	public class PatternEditor extends MyObject {
		
		//public var editor: Editor;
		public var canvas: PE_Canvas;
		public var text_name, text_color: MyInputText;
		public var patternAppearance: Loader;
		//public var patternAppearanceCopy: Loader;
		public var patternAppearance_reference: FileReference;
		public var tileColour: uint = 0xAF1E6C;
		public var colorPicker: ColorPicker;
		public var appointPatternAppearancePosition: AppointPatternAppearancePosition;
		//public var colorWheel: Bitmap;
		
		public function PatternEditor() {
			//editor = theEditor;
			colorPicker = new ColorPicker(this);
			colorPicker.x = 40;
			colorPicker.y = 200;
			addChild(colorPicker);
			
			canvas = new PE_Canvas(this);
			canvas.x = 430;
			canvas.y = 80;
			addChild(canvas);
			
			focusRect = false;
			
			text_name = new MyInputText("NewPattern");
			text_name.x = 130;
			text_name.y = 45;
			addChild(text_name);
			
			text_color = new MyInputText("AF1E6C", 0xAF1E6C);
			text_color.x = 130;
			text_color.y = 105;
			addChild(text_color);
			
			var button_openList = new Button_openList();
			button_openList.x = 330;
			button_openList.y = 65;
			addChild(button_openList);
			
			patternAppearance = new Loader();
			
			/*patternAppearanceCopy = new Loader();
			patternAppearanceCopy.alpha = 0.5;
			patternAppearance.x = patternAppearanceCopy.x = canvas.x;
			patternAppearance.y = patternAppearanceCopy.y = canvas.y;*/
			
			/*colorWheel = new Bitmap(new ColorWheel(), "auto", true);
			colorWheel.x = 25;
			colorWheel.y = 230;
			colorWheel.scaleX = colorWheel.scaleY = 0.75;
			addChild(colorWheel);*/
		}
		
		override function onButtonDown (b: MyButton):void {
			switch (b) {
				case button_browseAppearance:
					patternAppearance_reference = new FileReference();
					patternAppearance_reference.addEventListener(Event.SELECT, onPatternAppearanceSelected);
					patternAppearance_reference.addEventListener(Event.CANCEL, onPatternAppearanceCancel);
					patternAppearance_reference.browse();
					break;
				default:
					break;
			}
		}
		
		function onPatternAppearanceSelected(e: Event):void {
			patternAppearance_reference.addEventListener(Event.COMPLETE, onPatternAppearanceComplete);
			text_appearance.text = patternAppearance_reference.name;
			patternAppearance_reference.load();
		}
		
		function onPatternAppearanceComplete(e: Event):void {
			patternAppearance_reference.removeEventListener(Event.SELECT, onPatternAppearanceSelected);
			patternAppearance_reference.removeEventListener(Event.CANCEL, onPatternAppearanceCancel);
			patternAppearance_reference.removeEventListener(Event.COMPLETE, onPatternAppearanceComplete);
			patternAppearance.loadBytes(patternAppearance_reference.data);
			appointPatternAppearancePosition = new AppointPatternAppearancePosition(patternAppearance_reference.data, canvas);
			addChild(appointPatternAppearancePosition);
			/*patternAppearanceCopy.loadBytes(patternAppearance_reference.data)
			addChild(patternAppearanceCopy);
			addChild(patternAppearance);*/
		}
		
		function onPatternAppearanceCancel(e: Event):void {
			patternAppearance_reference.removeEventListener(Event.SELECT, onPatternAppearanceSelected);
			patternAppearance_reference.removeEventListener(Event.CANCEL, onPatternAppearanceCancel);
		}
		
	}
	
}
