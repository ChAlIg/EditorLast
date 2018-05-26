package  {
	import Lib;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Matrix;
	import flash.display.Graphics;
	import flash.text.GridFitType;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.media.SoundChannel;
	import flash.geom.Rectangle;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	
	public class Canvas extends MyObject {
		
		public var editor: Editor;
		
		public var tiles: Vector.<Vector.<Tile>>;
		var tileCanvas: Shape;
		
		public var grid: Grid;
		public var backLayers: Vector.<Shape>;
		public var appLayers: Vector.<Bitmap>;
		public var w, h;
		var i, j: int;
		public var currentZoom: int = 0;
		public var zoomPace: int = 2;
		public var minZoom: int = -2;
		public var maxZoom: int = 2;
		var point: Point = new Point (-1, -1);
		var flag: Boolean = false;
		public var selectedTile: Point = new Point (-1, -1);
		var t: Matrix;
		
		public function Canvas (theEditor: Editor, theW: int = 50, theH: int = 50) {
			
			w = theW;
			h = theH;
			editor = theEditor;
			tileCanvas = new Shape();
			
			tiles = new Vector.<Vector.<Tile>>();
			
			for (i = 0; i < w; ++i) {
				tiles.push(new Vector.<Tile>());
				for (j = 0; j < h; ++j) {
					tiles[i].push(new Tile());
					drawTile (i, j, tileCanvas.graphics);
				}
			}
			tileCanvas.cacheAsBitmap = true;
			addChild(tileCanvas);
			//layer hierarchy
			//0 - ground (tile background) - graffiti
			//1 - bottom (what lays on the ground)
			//2 - walls (impassable zones) - graffiti
			//3 - common (general units&bullets)
			//4 - atmosphere (fog etc)
			//5 - above (sufficiently high walls&objects; roofs) - graffiti
			//6 - sky
			//7 - interface
			backLayers = new Vector.<Shape>();
			appLayers = new Vector.<Bitmap>();
			for (i = 0; i < 7; ++i) {
				backLayers.push(new Shape());
				appLayers.push(new Bitmap(new BitmapData(w * Lib.tileSize, h * Lib.tileSize, true, 0x00000000), "auto", true));
				backLayers[i].cacheAsBitmap = appLayers[i].cacheAsBitmap = true;
			}
			grid = new Grid(this);
			selectedTile = new Point(0, 0);
			
			mouseChildren = false;
			for (i = 0; i < 7; ++i) {
				addChild(backLayers[i]);
				addChild(appLayers[i]);
			}
			addChild(grid);

			focusRect = false;
			
			advancedHit = 2;
			hitRect = new Rectangle(0, 0, w * Lib.tileSize, h * Lib.tileSize);
			
		}
		
		override function onWheel (delta:int):void {
			zoomAt(delta, new Point(stage.mouseX, stage.mouseY));
			/*if (!((currentZoom == maxZoom) && (delta > 0)) && !((currentZoom == minZoom) && (delta < 0))) {
				if (delta > 0) {
					++currentZoom;
					i = 1;
				} else {
					--currentZoom;
					i = -1;
				}
				
				t = transform.matrix;
				t.translate(-stage.mouseX, -stage.mouseY);
				t.scale(Math.pow(zoomPace, i), Math.pow(zoomPace, i));
				t.translate(stage.mouseX, stage.mouseY);
				transform.matrix = t;
				grid.alignGrid(globalToLocal(new Point(editor.facet.left.x + editor.facet.left.width, editor.facet.up.y + editor.facet.up.height)));
				editor.canvasButtonContainer.curZoomText.text = "" + int(Math.pow(2, currentZoom)*100) + '%';
				for (j = 0; j < grid.vCounter.numChildren; ++j) {
					grid.vCounter.getChildAt(j).scaleX = grid.vCounter.getChildAt(j).scaleY = Math.pow(1.4, -currentZoom);
				}
				for (j = 0; j < grid.hCounter.numChildren; ++j) {
					grid.hCounter.getChildAt(j).scaleX = grid.hCounter.getChildAt(j).scaleY = Math.pow(1.4, -currentZoom);
				}
			}*/
		}
		
		function zoomAt (delta: int, whereGlobal: Point) {
			if (!((currentZoom == maxZoom) && (delta > 0)) && !((currentZoom == minZoom) && (delta < 0))) {
				if (delta > 0) {
					++currentZoom;
					i = 1;
				} else {
					--currentZoom;
					i = -1;
				}
				
				t = transform.matrix;
				t.translate(-whereGlobal.x, -whereGlobal.y);
				t.scale(Math.pow(zoomPace, i), Math.pow(zoomPace, i));
				t.translate(whereGlobal.x, whereGlobal.y);
				transform.matrix = t;
				grid.alignGrid(globalToLocal(new Point(editor.facet.left.x + editor.facet.left.width, editor.facet.up.y + editor.facet.up.height)));
				editor.canvasButtonContainer.curZoomText.text = "" + int(Math.pow(2, currentZoom)*100) + '%';
				for (j = 0; j < grid.vCounter.numChildren; ++j) {
					grid.vCounter.getChildAt(j).scaleX = grid.vCounter.getChildAt(j).scaleY = Math.pow(1.4, -currentZoom);
				}
				for (j = 0; j < grid.hCounter.numChildren; ++j) {
					grid.hCounter.getChildAt(j).scaleX = grid.hCounter.getChildAt(j).scaleY = Math.pow(1.4, -currentZoom);
				}
			}
		}
		
		
		override function onDown (): void {
			if (editor.selectedPattern != null) {
				selectedTile.x = Math.floor(Number(mouseX/Lib.tileSize));
				selectedTile.y = Math.floor(Number(mouseY/Lib.tileSize));
				flag = false;
				var tile_conflict: Tile_conflict;
				for (i = 0; i < editor.selectedPatternTileMap.length; ++i) {
					if (tiles[selectedTile.x + editor.selectedPatternTileMap[i].x][selectedTile.y + editor.selectedPatternTileMap[i].y].pattern != null) {
						flag = true;
						tile_conflict = new Tile_conflict();
						tile_conflict.x = (selectedTile.x + editor.selectedPatternTileMap[i].x) * Lib.tileSize;
						tile_conflict.y = (selectedTile.y + editor.selectedPatternTileMap[i].y) * Lib.tileSize;
						addChild(tile_conflict);
					}
				}
				
				if (!flag) {
					for (i = 0; i < editor.selectedPatternTileMap.length; ++i) {
						tiles[selectedTile.x + editor.selectedPatternTileMap[i].x][selectedTile.y + editor.selectedPatternTileMap[i].y].pattern = editor.selectedPattern;
					}
					
					var drawSample: Sprite = new Sprite();
					var copyTiles: Shape = new Shape();

					copyTiles.graphics.drawGraphicsData(editor.selectedPatternTiles.graphics.readGraphicsData());
					copyTiles.x = selectedTile.x * Lib.tileSize;
					copyTiles.y = selectedTile.y * Lib.tileSize;
					drawSample.addChild(copyTiles);
					backLayers[editor.selectedPattern.targetLayer].graphics.drawGraphicsData(drawSample.graphics.readGraphicsData());
					var sound_deploy:Sound_deploy = new Sound_deploy(); 
					var channel1:SoundChannel = sound_deploy.play();
				} else {
					var sound_fail:Sound_fail = new Sound_fail(); 
					var channel2:SoundChannel = sound_fail.play();
					editor.facet.log.text = "the place is blocked by another pattern";
				}
			}
		}
		
		override function onMove ():void {
			point.x = mouseX;
			point.y = mouseY;
			selectedTile.x = Math.floor(Number(point.x/Lib.tileSize));
			selectedTile.y = Math.floor(Number(point.y/Lib.tileSize));
			editor.coursor.upperText.text = "X: " + selectedTile.x;
			editor.coursor.lowerText.text = "Y: " + selectedTile.y;
			
			editor.selectedPatternTiles.x = grid.selectedTile.x = selectedTile.x*Lib.tileSize;
			editor.selectedPatternTiles.y = grid.selectedTile.y = selectedTile.y*Lib.tileSize;
			editor.selectedPatternTiles.visible = true;
			grid.selectedTile.visible = true;
		}
		
		override function onOut (): void {
			grid.selectedTile.visible = false;
			editor.selectedPatternTiles.visible = false;
			editor.coursor.upperText.text = "";
			editor.coursor.lowerText.text = "";
		}
		
		public function drawTile (X: int, Y: int, dest: Graphics) {
			
			dest.lineStyle(0, 0x869E97);
			dest.beginFill(0xB0CCBF);
			dest.drawRect(X*Lib.tileSize, Y*Lib.tileSize, Lib.tileSize, Lib.tileSize);
			
			dest.lineStyle(Lib.tileSize/10, 0x869E97);
			dest.beginFill(0xB0CCBF);
			dest.drawCircle(X*Lib.tileSize + Lib.tileSize/2, Y*Lib.tileSize + Lib.tileSize/2, Lib.tileSize*2/5);
			dest.endFill();
			
			dest.moveTo(X*Lib.tileSize + Lib.tileSize/2, Y*Lib.tileSize + Lib.tileSize/10);
			dest.lineTo(X*Lib.tileSize + Lib.tileSize/10, Y*Lib.tileSize + Lib.tileSize/10);
			dest.lineTo(X*Lib.tileSize + Lib.tileSize/10, Y*Lib.tileSize + Lib.tileSize/2);
			
			dest.moveTo(X*Lib.tileSize + Lib.tileSize/2, Y*Lib.tileSize + Lib.tileSize*9/10);
			dest.lineTo(X*Lib.tileSize + Lib.tileSize*9/10, Y*Lib.tileSize + Lib.tileSize*9/10);
			dest.lineTo(X*Lib.tileSize + Lib.tileSize*9/10, Y*Lib.tileSize + Lib.tileSize/2);

		}
		
	}
	
}
