package  {
	
	import MyObject;
	import Lib;
	import flash.geom.Point;
	
	public class CanvasButtonContainer extends MyObject {
		
		var editor: Editor;
		var direct: int;
		
		public function CanvasButtonContainer(theEditor: Editor) {
			editor = theEditor;
		}
		
		override function onButtonDown(b: MyButton): void {
			switch (b) {
				case button_resetZoom:
					if (editor.canvas.currentZoom < 0) {
						direct = 1;
					} else {
						direct = -1;
					}
					for (var zoom:int = Math.abs(editor.canvas.currentZoom); zoom > 0; --zoom) {
						editor.canvas.zoomAt(direct, new Point((editor.nativeWidth + 205)/2, (editor.nativeHeight + 25)/2));
					}
					break;
					/*var centerPoint: Point = editor.canvas.globalToLocal(new Point((stage.fullScreenWidth + 205)/2, (stage.fullScreenHeight + 25)/2));
					if (editor.canvas.currentZoom < 0) {
						direct = 1;
					} else {
						direct = -1;
					}
					for (var zoom:int = Math.abs(editor.canvas.currentZoom); zoom > 0; --zoom) {
						editor.canvas.onWheel(direct);
					}
					editor.canvas.x = -editor.canvas.localToGlobal(centerPoint).x;
					editor.canvas.y = -editor.canvas.localToGlobal(centerPoint).y;
					break;*/
				case button_centerCanvas:
					var acceptedSizeX: int = stage.fullScreenWidth - 205;
					var acceptedSizeY: int = stage.fullScreenHeight - 25;
					var targetZoom: int = editor.canvas.maxZoom;
					var curX: int = editor.canvas.w * Lib.tileSize * Math.pow(2, targetZoom);
					var curY: int = editor.canvas.h * Lib.tileSize * Math.pow(2, targetZoom);
					while ((targetZoom > editor.canvas.minZoom) && ((curX > acceptedSizeX) || (curY > acceptedSizeY))) {
						--targetZoom;
						curX = editor.canvas.w * Lib.tileSize * Math.pow(2, targetZoom);
						curY = editor.canvas.h * Lib.tileSize * Math.pow(2, targetZoom);
					}
					if (targetZoom - editor.canvas.currentZoom > 0) {
						direct = 1;
					} else {
						direct = -1;
					}
					for (targetZoom = Math.abs(targetZoom - editor.canvas.currentZoom); targetZoom > 0; --targetZoom) {
						editor.canvas.onWheel(direct);
					}
					editor.canvas.x = (editor.nativeWidth - stage.fullScreenWidth)/2 + 205 + (acceptedSizeX - curX)/2;
					editor.canvas.y = (editor.nativeHeight - stage.fullScreenHeight)/2 + 25 + (acceptedSizeY - curY)/2;
					editor.canvas.grid.alignGrid(editor.canvas.globalToLocal(new Point(editor.facet.left.x + editor.facet.left.width, editor.facet.up.y + editor.facet.up.height)));
					break;
					/*if (editor.canvas.currentZoom != 0) {
						var direct: int;
						if (editor.canvas.currentZoom > 0) {
							direct = -1;
						} else {
							direct = 1;
						}
						while (editor.canvas.currentZoom != 0) {
							editor.canvas.onWheel(direct);
						}
					}
					editor.canvas.x = (editor.nativeWidth - editor.fullScreenWidth)/2 + (editor.fullScreenWidth - 205 - editor.canvas.w * Lib.tileSize)/2;
					break;*/
				default:
					break;
			}
		}
	}
	
}
