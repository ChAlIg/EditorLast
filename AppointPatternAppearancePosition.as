package  {
	
	import MyObject;
	import Lib;
	import flash.utils.ByteArray;
	import flash.display.Loader;
	import flash.geom.Point;
	import flash.display.Bitmap;
	import flash.events.KeyboardEvent;
	import flash.display.BitmapData;
	import flash.sampler.NewObjectSample;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	
	public class AppointPatternAppearancePosition extends MyObject {
		var appearanceMasked: Loader;
		var appearanceTransparent: Loader;
		var tiles: Bitmap;
		var canvas: PE_Canvas;
		//var t: Sprite;
		
		public function AppointPatternAppearancePosition(imageData: ByteArray, theCanvas: PE_Canvas) {
			canvas = theCanvas;
			canvas.appearance.bitmapData.dispose();
			appearanceMasked = new Loader;
			appearanceTransparent = new Loader;
			tiles = new Bitmap(canvas.appearanceMask.bitmapData);
			tiles.cacheAsBitmap = true;
			appearanceMasked.loadBytes(imageData);
			//appearanceMasked.alpha = 0.9;
			appearanceTransparent.loadBytes(imageData);
			appearanceTransparent.alpha = 0.1;
			tiles.x = canvas.x;
			appearanceMasked.x = appearanceTransparent.x = canvas.x + canvas.grid.forwardMark.x * canvas.scaleX;
			tiles.y = canvas.y;
			appearanceMasked.y = appearanceTransparent.y = canvas.y + canvas.grid.forwardMark.y * canvas.scaleY;
			tiles.scaleX = appearanceMasked.scaleX = appearanceTransparent.scaleX = canvas.scaleX;
			tiles.scaleY = appearanceMasked.scaleY = appearanceTransparent.scaleY = canvas.scaleY;
			appearanceMasked.cacheAsBitmap = true;
			appearanceMasked.mask = tiles;
			
			addChild(appearanceTransparent);
			addChild(appearanceMasked);
			addChild(tiles);
			Lib.log.text = "shift appearance by tile with WASD keys, rotate with Q/E, apply with Enter. Use mouse to drag by pixels (actually does not work)";
			Lib.keyboardCapturer = this;
			Lib.isKeyboardCaptured = true;
		}
	
		override function onKeyInput(e: KeyboardEvent): void {
			switch (e.keyCode) {
				case 69: //e
					appearanceMasked.rotation += 90;
					appearanceTransparent.rotation += 90;
					break;
				case 81: //q
					appearanceMasked.rotation -= 90;
					appearanceTransparent.rotation -= 90;
					break;
				case 87: //w
					appearanceMasked.y -= Lib.tileSize * appearanceMasked.scaleY;
					appearanceTransparent.y -= Lib.tileSize * appearanceTransparent.scaleY;
					break;
				case 65: //a
					appearanceMasked.x -= Lib.tileSize * appearanceMasked.scaleX;
					appearanceTransparent.x -= Lib.tileSize * appearanceTransparent.scaleX;
					break;
				case 83: //s
					appearanceMasked.y += Lib.tileSize * appearanceMasked.scaleY;
					appearanceTransparent.y += Lib.tileSize * appearanceTransparent.scaleY;
					break;
				case 68: //d
					appearanceMasked.x += Lib.tileSize * appearanceMasked.scaleX;
					appearanceTransparent.x += Lib.tileSize * appearanceTransparent.scaleX;
					break;
				case 13: //enter
					Lib.keyboardCapturer = null;
					Lib.isKeyboardCaptured = false;
					canvas.appearance.bitmapData = new BitmapData(canvas.w*Lib.tileSize, canvas.h*Lib.tileSize, true, 0x00000000);
					//var t: Sprite = new Sprite();
					//t.addChild(appearanceMasked);
					Lib.log.text = "" + appearanceMasked.x;
					canvas.appearance.bitmapData.draw(appearanceMasked.content, new Matrix(1, 0, 0, 1, (appearanceMasked.x - canvas.x)/appearanceMasked.scaleX, (appearanceMasked.y - canvas.y)/appearanceMasked.scaleY));
					//canvas.appearance.mask = canvas.appearanceMask;
					parent.removeChild(this);
					break;
				default:
					break;
			}
		}
	}
	
}
