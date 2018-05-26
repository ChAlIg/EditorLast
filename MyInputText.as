package  {
	
	import MyObject;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.geom.Rectangle;
	import Lib;
	import flash.display.Shape;
	
	public class MyInputText extends MyObject {
		var txt: TextField;
		var side: Shape;
		
		public function MyInputText(defaultText: String = "Input", textColor: uint = 0xC1DFD1, theWidth: int = 200, theHeight: int = 20, theFormat: TextFormat = null, backColor: uint = 0x133241) {
			side = new Shape;
			side.graphics.beginFill(backColor, 0.5);
			side.graphics.drawRect(0, 0, theWidth, theHeight);
			side.visible = false;
			addChild(side);
			
			txt = new TextField();
			txt.type = "input";
			txt.width = theWidth;
			txt.height = theHeight;
			if (theFormat == null) {
				theFormat = new TextFormat (new GeometriaItalic().fontName, 13, 0xC1DFD1);
			}
			theFormat.color = textColor;
			txt.defaultTextFormat = theFormat;
			txt.embedFonts = true;
			txt.antiAliasType = "advanced";
			txt.text = defaultText;
			addChild(txt);
		}
		
		function select(): void {
			side.visible = true;
		}
		
		function deselect(): void {
			side.visible = false;
		}
		
		override function onMove(): void {
			//stage.focus =
		}
		
		override function onDown(): void {
			if (!Lib.editor.isTextInput) {
				Lib.editor.isTextInput = true;
				Lib.editor.textInputTarget = this;
				select();
			} else if (Lib.editor.textInputTarget != this) {
				Lib.editor.isTextInput = true;
				Lib.editor.textInputTarget.deselect();
				Lib.editor.textInputTarget = this;
				select();
			}
		}
	}
	
}
