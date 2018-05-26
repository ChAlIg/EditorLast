package  {
	import Lib;
	import flash.display.MovieClip;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.geom.Point;
	import flash.filters.GlowFilter;
	import flash.filters.BitmapFilterQuality; 
	import flash.display.Sprite;
	
	
	public class Grid extends MovieClip {
		
		var i, j: int;
		var hCounter, vCounter: Sprite;
		var t: TextField;
		var canvas: Canvas;
		var glow: GlowFilter;
		public var selectedTile: Tile_selected;
		//hCounter - номера горизонтальных линий по вертикали
		//vCounter - номера вертикальных линий по горизонтали
		
		public function Grid(theCanvas: Canvas, w: int = 50, h: int = 50) {
			
			canvas = theCanvas;
			vCounter = new Sprite();
			hCounter = new Sprite();
			addChild(vCounter);
			addChild(hCounter);
			
			glow = new GlowFilter(0xAAC4B8, 1.0, 2, 2, 5, BitmapFilterQuality.LOW);
			
			graphics.lineStyle(1, 0x4D3444);
			var format1:TextFormat = new TextFormat(new PhageRegular().fontName, 14, 0x4D3444);
			for (i = 0; i <= w; i += 5) {
				graphics.moveTo(i*Lib.tileSize, -40);
				graphics.lineTo(i*Lib.tileSize, h*Lib.tileSize + 40);
				t = new TextField();
				t.defaultTextFormat = format1;
				t.embedFonts = true;
				t.antiAliasType = "advanced";
				t.height = 30;
				t.width = 40;
				t.text = ""+i;
				t.x = i*Lib.tileSize;
				t.filters = [glow];
				vCounter.addChild(t);
			}
			for (i = 0; i <= h; i += 5) {
				graphics.moveTo(-40, i*Lib.tileSize); 
				graphics.lineTo(w*Lib.tileSize + 40, i*Lib.tileSize);
				t = new TextField();
				t.defaultTextFormat = format1;
				t.embedFonts = true;
				t.antiAliasType = "advanced";
				t.height = 30;
				t.width = 40;
				t.text = ""+i;
				t.y = i*Lib.tileSize;
				t.filters = [glow];
				hCounter.addChild(t);
			}
			
			//vCounter.cacheAsBitmap = true;
			//hCounter.cacheAsBitmap = true;
			
			//vCounter.filters.push(glow);
			//hCounter.filters.push(glow);
			
			selectedTile = new Tile_selected();
			addChild(selectedTile);
			selectedTile.visible = false;
		}
		public function alignGrid(leftUpCorner: Point): void {
			if (leftUpCorner.x <= -40) {
				leftUpCorner.x = -40;
			} else if (leftUpCorner.x >= canvas.w*Lib.tileSize + 30) {
				leftUpCorner.x = canvas.w*Lib.tileSize + 30;
			}
			if (leftUpCorner.y <= -40) {
				leftUpCorner.y = -40;
			} else if (leftUpCorner.y >= canvas.h*Lib.tileSize + 30) {
				leftUpCorner.y = canvas.h*Lib.tileSize + 30;
			}
			hCounter.x = leftUpCorner.x;
			vCounter.y = leftUpCorner.y;
		}
	}
	
}
