package  {
	import Lib;
	import flash.display.MovieClip;
	import flash.geom.Point;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.geom.Rectangle;
	import flash.text.Font;
	import MyObject;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	
	public class Pattern extends MyObject {
		public var patternName: String;
		public var patternType: String;
		public var targetLayer: int;
		public var tileMap: Vector.<Point>;
		public var tiles: Shape;
		public var appearance: Bitmap;
		public var tileColour: uint;
		var i: int;
		public var info: TextField;
		public var textFormat: TextFormat;
		public var patternDelete: Pattern_delete;
		public var patternEdit: Pattern_edit;
		
		public function Pattern(thePatternName: String, theTiles: Vector.<Point>, theTileColour: uint = 0xAF1E6C, thePatternType: String = "Structure", theTargetLayer: int = 2) {
			
			advancedHit = 2;
			hitRect = new Rectangle(0, 0, 200, 100);
			
			targetLayer = theTargetLayer;
			
			tiles = new Shape();
			tiles.cacheAsBitmap = true;
			
			appearance = new Bitmap(new BitmapData(10*Lib.tileSize, 10*Lib.tileSize, true, 0x00000000));
			appearance.cacheAsBitmap = true;
			
			patternName = thePatternName;
			patternType = thePatternType;
			
			tileColour = theTileColour;
			
			tileMap = new Vector.<Point>();
			
			var t: Sprite = new Sprite();
			t.graphics.beginFill(tileColour);
			
			var tile_template: Tile_template;
			
			for (var i: int = 0; i < theTiles.length; ++i) {
				tileMap.push(new Point(theTiles[i].x, theTiles[i].y));
				
				t.graphics.drawRect(tileMap[i].x * Lib.tileSize, tileMap[i].y * Lib.tileSize, Lib.tileSize, Lib.tileSize);
				
				tile_template = new Tile_template();
				tile_template.x = tileMap[i].x * Lib.tileSize;
				tile_template.y = tileMap[i].y * Lib.tileSize;
				
				t.addChild(tile_template);
				
			}
			
			tiles.graphics.drawGraphicsData(t.graphics.readGraphicsData());
			
			appearance.scaleX = appearance.scaleY = tiles.scaleX = tiles.scaleY = Number(80/Math.max(tiles.width, tiles.height));
			addChild(tiles);
			addChild(appearance);
			var rect: Rectangle = tiles.getRect(this);
			tiles.x += 150 - rect.x - rect.width/2;
			appearance.x += 150 - rect.x - rect.width/2;
			tiles.y += 50 - rect.y - rect.height/2;
			appearance.y += 50 - rect.y - rect.height/2;
			
			
			info = new TextField();
			info.width = 90;
			info.height = 90;
			info.x = 5;
			info.y = 5;
			
			info.embedFonts = true;
			textFormat = new TextFormat (new GeometriaItalic().fontName, 13, 0xC1DFD1);
			
			info.appendText (patternName + '\n');
			info.setTextFormat(textFormat);
			
			textFormat.size = 11;
			textFormat.font = new AvenirItalic().fontName;
			info.appendText (patternType + '\n' + tileMap.length + " tile(s)");
			
			info.setTextFormat(textFormat, patternName.length, info.text.length);
			
			addChild(info);
			
			patternDelete = new Pattern_delete();
			patternEdit = new Pattern_edit();
			patternDelete.y = patternEdit.y = 75;
			patternDelete.x = 8;
			patternEdit.x = 30;
			addChild(patternDelete);
			addChild(patternEdit);
		}
		
		override function onMove (): void {
			addChild((parent as PatternWindow).selection);
		}
		
		override function onOut (): void {
			removeChild((parent as PatternWindow).selection);
		}
		
		override function onDown ():void {
			if ((parent as PatternWindow).editor.selectedPattern != this) {
				(parent as PatternWindow).deselectPattern();
				(parent as PatternWindow).lastSelectedPattern = this;
				filters = [(parent as PatternWindow).glow];
				(parent as PatternWindow).editor.selectedPattern = this;
				(parent as PatternWindow).editor.selectedPatternTiles.graphics.clear();
				(parent as PatternWindow).editor.selectedPatternTiles.graphics.copyFrom(tiles.graphics);
				(parent as PatternWindow).editor.selectedPatternRot = 0;
				(parent as PatternWindow).editor.selectedPatternTileMap.length = 0;
				for (i = 0; i < tileMap.length; ++i) {
					(parent as PatternWindow).editor.selectedPatternTileMap.push(new Point(tileMap[i].x, tileMap[i].y));
				}
			}
			Lib.editor.facet.log.text = "Q/E - rotate, right-click - deploy";
		}
		
	}
	
}
