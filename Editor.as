package  {
	import MyObject;
	import Lib;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.FullScreenEvent;
	import flash.ui.Mouse;

	//import flash.display.Stage;
	import flash.display.StageDisplayState;
	import flash.display.StageScaleMode;
	import flash.events.MouseEvent;
	//import flash.events.FullScreenEvent;

	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.sampler.NewObjectSample;
	import flash.display.Sprite;
	import flash.display.Shape;
	
	public class Editor extends MyObject {
		
		public var canvas: Canvas;
		public var facet: Facet;
		public var coursor: Coursor;
		public var canvasButtonContainer: CanvasButtonContainer;
		/*public var button_centerCanvas: Button_centerCanvas;
		public var button_resetZoom: Button_resetZoom;
		public var button_showMapping: Button_showMapping;
		public var button_refreshMapping: Button_refreshMapping;*/
		public var patternEditor: PatternEditor;
		
		public var shiftPace: int = 30;
		public var nativeWidth: int;
		public var nativeHeight: int;
		
		public var mousePoint: Point = new Point (0, 0);
		public var clickPoint: Point = new Point (0, 0);
		public var leftMouseIsDown: Boolean = false;
		//public var leftMouseHasReleased: Boolean = false;
		
		public var isPEOpened: Boolean = false;
		public var selectedPattern: Pattern;
		public var selectedPatternTiles: Sprite;
		public var selectedPatternRot: int;
		public var selectedPatternTileMap: Vector.<Point> = new Vector.<Point>();
		
		public var drawSample: Sprite;
		public var copyTiles: Shape;
		
		public var isTextInput: Boolean = false;
		public var textInputTarget: MyInputText;
		
		var toggleFullscreenButton: ToggleFullscreenButton;
		
		var i, j, t: int;
		
		public function Editor(): void {
			Lib.editor = this;
			
			canvas = new Canvas(this);
			facet = new Facet(this);
			canvasButtonContainer = new CanvasButtonContainer(this);
			/*button_centerCanvas = new Button_centerCanvas();
			button_resetZoom = new Button_resetZoom();
			button_showMapping = new Button_showMapping();
			button_refreshMapping = new Button_refreshMapping();*/
			coursor = new Coursor();
			
			addChild(canvas);
			addChild(facet);
			/*addChild(button_centerCanvas);
			addChild(button_resetZoom);
			addChild(button_showMapping);
			addChild(button_refreshMapping);*/
			addChild(canvasButtonContainer);
			addChild(coursor);
			
			nativeWidth = stage.stageWidth;
			nativeHeight = stage.stageHeight;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			toggleFullscreenButton = new ToggleFullscreenButton();
			
			addChild(toggleFullscreenButton);
			toggleFullscreenButton.addEventListener(MouseEvent.CLICK, toggleFullscreen);
			
			//stage.addEventListener(MouseEvent.CLICK, onClick);
			stage.addEventListener(MouseEvent.RIGHT_MOUSE_DOWN, onRightDown_event);
			stage.addEventListener(MouseEvent.RIGHT_MOUSE_UP, onRightUp_event);
			stage.addEventListener(MouseEvent.MOUSE_DOWN, onDown_event);
			stage.addEventListener(MouseEvent.MOUSE_UP, onUp_event);
			stage.addEventListener(MouseEvent.MOUSE_WHEEL, onWheel_event);
			
			stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDown);
			
			addEventListener(Event.ENTER_FRAME, tick, false, 0, true);
			
			selectedPatternTiles = new Sprite();
			selectedPatternTiles.cacheAsBitmap = true;
			canvas.addChild(selectedPatternTiles);
			selectedPatternTiles.visible = false;
			

		}
		
		public function keyDown (e: KeyboardEvent) {
			if (e.keyCode == 27) { //esc
				returnToggleFullscreen();
			} else if (Lib.isKeyboardCaptured) {
				Lib.keyboardCapturer.onKeyInput(e);
			} else if (isTextInput) {
				if (e.keyCode == 13) {
					textInputTarget.side.visible = false;
					isTextInput = false;
				} else if (e.keyCode == 8) {
					if (textInputTarget.txt.length) {
						textInputTarget.txt.replaceText(textInputTarget.txt.length-1, textInputTarget.txt.length, "");
					}
				} else {
					textInputTarget.txt.appendText(String.fromCharCode(e.charCode));
				}
			} else {
				switch (e.keyCode) {
					case 69: //e
						if ((selectedPattern != null) && (selectedPatternTiles.visible == true)) {
							(++selectedPatternRot) % 4;
							drawSample = new Sprite();
							copyTiles = new Shape();
							copyTiles.graphics.drawGraphicsData(selectedPatternTiles.graphics.readGraphicsData());
							copyTiles.rotation = 90;
							copyTiles.x += Lib.tileSize;
							drawSample.addChild(copyTiles);
							selectedPatternTiles.graphics.clear();
							selectedPatternTiles.graphics.drawGraphicsData(drawSample.graphics.readGraphicsData());
							
							for (i = 0; i < selectedPatternTileMap.length; ++i) {
								j = selectedPatternTileMap[i].x;
								t = selectedPatternTileMap[i].y;
								selectedPatternTileMap[i].x = -t;
								selectedPatternTileMap[i].y = j;
							}
						}
						break;
					case 81: //q
						if ((selectedPattern != null) && (selectedPatternTiles.visible == true)) {
							(--selectedPatternRot) % 4;
							drawSample = new Sprite();
							copyTiles = new Shape();
							copyTiles.graphics.drawGraphicsData(selectedPatternTiles.graphics.readGraphicsData());
							copyTiles.rotation = 270;
							copyTiles.y += Lib.tileSize;
							drawSample.addChild(copyTiles);
							selectedPatternTiles.graphics.clear();
							selectedPatternTiles.graphics.drawGraphicsData(drawSample.graphics.readGraphicsData());
							
							for (i = 0; i < selectedPatternTileMap.length; ++i) {
								j = selectedPatternTileMap[i].x;
								t = selectedPatternTileMap[i].y;
								selectedPatternTileMap[i].x = t;
								selectedPatternTileMap[i].y = -j;
							}
						}
						break;
					case 87: //w
						canvas.y += shiftPace;
						canvas.grid.alignGrid(canvas.globalToLocal(new Point(facet.left.x + facet.left.width, facet.up.y + facet.up.height)));
						break;
					case 65: //a
						canvas.x += shiftPace;
						canvas.grid.alignGrid(canvas.globalToLocal(new Point(facet.left.x + facet.left.width, facet.up.y + facet.up.height)));
						break;
					case 83: //s
						canvas.y -= shiftPace;
						canvas.grid.alignGrid(canvas.globalToLocal(new Point(facet.left.x + facet.left.width, facet.up.y + facet.up.height)));
						break;
					case 68: //d
						canvas.x -= shiftPace;
						canvas.grid.alignGrid(canvas.globalToLocal(new Point(facet.left.x + facet.left.width, facet.up.y + facet.up.height)));
						break;
					default:
						break;
				}
			}
		}
		
		/*public function onClick(e:MouseEvent):void {
            trace("Hello click :)");
		}*/
		
		public function onRightDown_event(e:MouseEvent):void {
			onRightDownTransfer();
		}
		
		public function onRightUp_event(e:MouseEvent):void {
			onRightUpTransfer();
		}
		
		override function onRightDown(): void {
			if (selectedPattern != null) {
				facet.left.patternWindow.deselectPattern();
				facet.left.patternWindow.lastSelectedPattern = null;
				selectedPattern = null;
				selectedPatternTiles.graphics.clear();
				selectedPatternRot = 0;
				selectedPatternTileMap.length = 0;
			}
		}
		
		public function onDown_event(e:MouseEvent):void {
			onDownTransfer();
		}
		
		override function onDown(): void {
			
		}
		
		public function onUp_event(e:MouseEvent):void {
            onUpTransfer();
		}
		
		override function onUp(): void {
			//leftMouseIsDown = false;
		}
		
		public function onWheel_event(e:MouseEvent):void {
			onWheelTransfer(e.delta);
		}

		public function tick (e: Event): void {
			/*if (selectedPatternTileMap.length > 0) {
				debug.text = "" + selectedPatternTileMap[0].x;
			} else {
				debug.text = "" + "err";
			}*/
			//debug.text = "" + selectedPatternTileMap.length + ' ' + selectedPatternRot;
			//selectedPattern: Pattern;
		//public var selectedPatternTiles: Sprite;
		//public var selectedPatternRot: int;
		//public var selectedPatternTileMap
			//moving coursor
			coursor.x = mousePoint.x = mouseX; 
			coursor.y = mousePoint.y = mouseY;
			
			//shifting canvas
			if (mousePoint.x == (nativeWidth - stage.fullScreenWidth)/2) {
				canvas.x += shiftPace;
				canvas.grid.alignGrid(canvas.globalToLocal(new Point(facet.left.x + facet.left.width, facet.up.y + facet.up.height)));
			}
			if (mousePoint.x == nativeWidth - (nativeWidth - stage.fullScreenWidth)/2 - 1) {
				canvas.x -= shiftPace;
				canvas.grid.alignGrid(canvas.globalToLocal(new Point(facet.left.x + facet.left.width, facet.up.y + facet.up.height)));
			}
			if (mousePoint.y == (nativeHeight - stage.fullScreenHeight)/2) {
				canvas.y += shiftPace;
				canvas.grid.alignGrid(canvas.globalToLocal(new Point(facet.left.x + facet.left.width, facet.up.y + facet.up.height)));
			}
			if (mousePoint.y == nativeHeight - (nativeHeight - stage.fullScreenHeight)/2 - 1) {
				canvas.y -= shiftPace;
				canvas.grid.alignGrid(canvas.globalToLocal(new Point(facet.left.x + facet.left.width, facet.up.y + facet.up.height)));
			}
		
			onMoveTransfer();
		}

		public function toggleFullscreen(e: MouseEvent): void {
			stage.displayState = StageDisplayState.FULL_SCREEN;
			Mouse.hide();
			
			toim.x = (nativeWidth - toim.width)/2;
			toim.y = (nativeHeight - toim.height)/2;
			
			//verInfo.x = (nativeWidth + stage.fullScreenWidth)/2 - verInfo.width;
			//verInfo.y = (nativeHeight + stage.fullScreenHeight)/2 - verInfo.height;
			
			canvasButtonContainer.x = (nativeWidth - stage.fullScreenWidth)/2 + 205;
			canvasButtonContainer.y = (nativeHeight - stage.fullScreenHeight)/2 + 25;
			
			/*button_centerCanvas.x = (nativeWidth - stage.fullScreenWidth)/2 + 205 + 10;
			button_centerCanvas.y = (nativeHeight - stage.fullScreenHeight)/2 + 25 + 10;
			
			button_resetZoom.x = (nativeWidth - stage.fullScreenWidth)/2 + 205 + 10;
			button_resetZoom.y = (nativeHeight - stage.fullScreenHeight)/2 + 25 + 10 + 25;
			
			button_showMapping.x = (nativeWidth - stage.fullScreenWidth)/2 + 205 + 10 + 40;
			button_showMapping.y = (nativeHeight - stage.fullScreenHeight)/2 + 25 + 10;
			
			button_refreshMapping.x = (nativeWidth - stage.fullScreenWidth)/2 + 205 + 10 + 40;
			button_refreshMapping.y = (nativeHeight - stage.fullScreenHeight)/2 + 25 + 10 + 25;*/
			
			facet.alignFacet (nativeWidth, nativeHeight, stage.fullScreenWidth, stage.fullScreenHeight);
			
			toggleFullscreenButton.removeEventListener(MouseEvent.CLICK, toggleFullscreen);
			removeChild(toggleFullscreenButton);
			
			mouseChildren = false;
			
		}
		
		public function returnToggleFullscreen(): void {
			Mouse.show();
			addChild(toggleFullscreenButton);
			toggleFullscreenButton.addEventListener(MouseEvent.CLICK, toggleFullscreen);
			
			mouseChildren = true;
		}
		
		/*public function howMany (container): int {
			var sum: int = 0;
			for (var s: int = 0; s < container.numChildren; ++s) {
				if (container.getChildAt(s).hasOwnProperty("numChildren")) {
					sum += howMany(container.getChildAt(s));
				} else {
					++sum;
				}
			}
			return sum;
		}
		
		public function whatNames (container): String {
			var names: String = "";
			for (var s: int = 0; s < container.numChildren; ++s) {
				if (container.getChildAt(s).hasOwnProperty("numChildren")) {
					names += whatNames(container.getChildAt(s))+'\n';
				} else {
					names += typeof(container.getChildAt(s))+'\n';
				}
			}
			return names += typeof(container)+'\n';
		}*/
	}
	
}
