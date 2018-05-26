package  {
	import Lib;
	import MyObject;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Matrix;
	import flash.text.GridFitType;
	import flash.geom.Rectangle;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	
	public class PE_Canvas extends MyObject {
		
		public var editor: PatternEditor;
		
		public var grid: PE_Grid;
		public var w, h;
		var i, j: int;
		public var selectedTile: Point = new Point (-1, -1);
		public var tiles: Bitmap;
		public var appearanceMask: Bitmap;
		public var appearance: Bitmap;
		public var isTaken: Vector.<Vector.<Boolean>>;
		var tileCanvas: Shape;
		var t: Sprite;
		var tile_dark: Tile_dark;
		public var isFilling: Boolean = false;
		public var isClearing: Boolean = false;
		
		public function PE_Canvas (theEditor: PatternEditor, theW: int = 10, theH: int = 10) {
				
			w = theW;
			h = theH;
			editor = theEditor;
			grid = new PE_Grid(this);
			mouseChildren = false;
				
			tileCanvas = new Shape();
			
			t = new Sprite();
				
			isTaken = new Vector.<Vector.<Boolean>>();
			for (i = 0; i < w; ++i) {
				isTaken.push(new Vector.<Boolean>());
				for (j = 0; j < h; ++j) {
					isTaken[i].push(false);
					tile_dark = new Tile_dark();
					tile_dark.x = i * Lib.tileSize;
					tile_dark.y = j * Lib.tileSize;
						
					t.addChild(tile_dark);
				}
			}
			
			tileCanvas.graphics.drawGraphicsData(t.graphics.readGraphicsData());
			
			t = null;
			tileCanvas.cacheAsBitmap = true;
			
			addChild(tileCanvas);
			
			
			tiles = new Bitmap(new BitmapData(w*Lib.tileSize, h*Lib.tileSize, true, 0x00000000), "auto", true);
			tiles.cacheAsBitmap = true;
			appearanceMask = new Bitmap(tiles.bitmapData);
			appearanceMask.cacheAsBitmap = true;
			appearance = new Bitmap(new BitmapData(10, 10, true, 0x00000000), "auto", true);
			appearance.cacheAsBitmap = true;
			addChild(tiles);
			addChild(appearance);
			appearance.mask = appearanceMask;
			addChild(appearanceMask);
			addChild(grid);
			scaleX = scaleY = 1.5;
			
			advancedHit = 2;
			hitRect = new Rectangle(0, 0, w * Lib.tileSize, h * Lib.tileSize);
			
			}
			
			override function onMove ():void {
				selectedTile.x = Math.floor(Number(mouseX/Lib.tileSize));
				selectedTile.y = Math.floor(Number(mouseY/Lib.tileSize));
				
				grid.selectedTile.x = selectedTile.x*Lib.tileSize;
				grid.selectedTile.y = selectedTile.y*Lib.tileSize;
				grid.selectedTile.visible = true;
				if (isFilling) {
					if (!isTaken[selectedTile.x][selectedTile.y]) {
						drawTile(selectedTile.x, selectedTile.y, editor.tileColour);
						isTaken[selectedTile.x][selectedTile.y] = true;
					}
				} else if (isClearing) {
					if (isTaken[selectedTile.x][selectedTile.y]) {
						tiles.bitmapData.fillRect(new Rectangle(selectedTile.x*Lib.tileSize, selectedTile.y*Lib.tileSize, Lib.tileSize, Lib.tileSize), 0x00000000);
						isTaken[selectedTile.x][selectedTile.y] = false;
					}
				}
			}
			
			override function onOut (): void {
				grid.selectedTile.visible = false;
			}
			
			override function onDown(): void {
				selectedTile.x = Math.floor(Number(mouseX/Lib.tileSize));
				selectedTile.y = Math.floor(Number(mouseY/Lib.tileSize));
				drawTile(selectedTile.x, selectedTile.y, editor.tileColour);
				isTaken[selectedTile.x][selectedTile.y] = true;
				isFilling = true;
			}
			
			override function onUp(): void {
				isFilling = false;
			}
			
			override function onRightDown(): void {
				selectedTile.x = Math.floor(Number(mouseX/Lib.tileSize));
				selectedTile.y = Math.floor(Number(mouseY/Lib.tileSize));
				tiles.bitmapData.fillRect(new Rectangle(selectedTile.x*Lib.tileSize, selectedTile.y*Lib.tileSize, Lib.tileSize, Lib.tileSize), 0x00000000);
				isTaken[selectedTile.x][selectedTile.y] = false;
				isClearing = true;
			}
			
			override function onRightUp(): void {
				isClearing = false;
			}
			
			function drawTile(X: int, Y: int, colour: uint) {
				t = new Sprite();
				t.graphics.beginFill(colour);
				t.graphics.drawRect(X * Lib.tileSize, Y * Lib.tileSize, Lib.tileSize, Lib.tileSize);
				
				var tile_template: Tile_template;
				tile_template = new Tile_template();
				tile_template.x = X * Lib.tileSize;
				tile_template.y = Y * Lib.tileSize;
				t.addChild(tile_template);
				
				var readyToDraw: Sprite = new Sprite();
				readyToDraw.graphics.drawGraphicsData(t.graphics.readGraphicsData());
				tiles.bitmapData.draw(readyToDraw);
				t = null;
			}
			
	}
	
}
