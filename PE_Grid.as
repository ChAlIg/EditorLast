package  {
	
	import Lib;
	import flash.display.MovieClip;
	import flash.geom.Point;
	
	public class PE_Grid extends MovieClip {
		
		var i, j: int;
		var hCounter, vCounter: MovieClip;
		var canvas: PE_Canvas;
		public var selectedTile: Tile_selected;
		var forwardMark: Tile_forward;
		
		//hCounter - номера горизонтальных линий по вертикали
		//vCounter - номера вертикальных линий по горизонтали
		
		public function PE_Grid(theCanvas: PE_Canvas, w: int = 10, h: int = 10) {
			
			canvas = theCanvas;
			cacheAsBitmap = true;
			
			graphics.lineStyle(1, 0x654E5E);
			for (i = 0; i <= w; i += 5) {
				graphics.moveTo(i*Lib.tileSize, -5);
				graphics.lineTo(i*Lib.tileSize, h*Lib.tileSize + 5);
			}
			for (i = 0; i <= h; i += 5) {
				graphics.moveTo(-5, i*Lib.tileSize);
				graphics.lineTo(w*Lib.tileSize + 5, i*Lib.tileSize);
			}
			forwardMark = new Tile_forward();
			forwardMark.x = forwardMark.y = int((w+1)/2) * Lib.tileSize;
			addChild(forwardMark);
			
			selectedTile = new Tile_selected();
			addChild(selectedTile);
			selectedTile.visible = false;
				
		}
	}
	
}
