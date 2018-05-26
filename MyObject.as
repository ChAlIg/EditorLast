package  {
	import flash.display.MovieClip;
	import flash.geom.Point;
	import flash.display.Shape;
	import flash.display.InteractiveObject;
	import flash.geom.Rectangle;
	import flash.events.KeyboardEvent;
	
	public class MyObject extends MovieClip {
		var itera: int;
		public var hitShape: Shape;
		public var hitRect: Rectangle;
		public var advancedHit: int = 0;
		public var lastFocus: MyObject;
		public var hasInnerHit: Boolean;

		public function MyObject() {
			focusRect = false;
			//cacheAsBitmap = true;
		}
		
		function onKeyInput (e: KeyboardEvent): void {
			
		}
		
		function onButtonDown(b: MyButton): void {
			
		}
		
		public function onRightDownTransfer(): void {
			onRightDown();
			for (itera = numChildren - 1; itera >=0; --itera) {
				if (getChildAt(itera) is MyObject) {
					if ((getChildAt(itera) as MyObject).isHit()) {
						(getChildAt(itera) as MyObject).onRightDownTransfer();
						break;
					}
				}
			}
		}
		
		function onRightDown(): void {
			
		}
		
		public function onRightUpTransfer(): void {
			onRightUp();
			for (itera = numChildren - 1; itera >=0; --itera) {
				if (getChildAt(itera) is MyObject) {
					if ((getChildAt(itera) as MyObject).isHit()) {
						(getChildAt(itera) as MyObject).onRightUpTransfer();
						break;
					}
				}
			}
		}
		
		function onRightUp(): void {
			
		}
		
		public function onMoveTransfer(): void {
			onMove();
			hasInnerHit = false;
			for (itera = numChildren - 1; itera >=0; --itera) {
				if (getChildAt(itera) is MyObject) {
					if ((getChildAt(itera) as MyObject).isHit()) {
						hasInnerHit = true;
						if (lastFocus == null) {
							lastFocus = getChildAt(itera) as MyObject;
						} else if (lastFocus != (getChildAt(itera) as MyObject)) {
							lastFocus.onOutTransfer();
							lastFocus = getChildAt(itera) as MyObject;
						}
						stage.focus = getChildAt(itera) as InteractiveObject;
						(getChildAt(itera) as MyObject).onMoveTransfer();
						break;
					}
				}
			}
			if (hasInnerHit == false) {
				if (lastFocus != null) {
					lastFocus.onOutTransfer();
					lastFocus = null;
				}
			}
		}
		
		function onMove(): void {
			
		}
		
		public function onOutTransfer(): void {
			onOut();
			if (lastFocus != null) {
				lastFocus.onOutTransfer();
				lastFocus = null;
			}
		}
		
		function onOut(): void {
			
		}
		
		public function onDownTransfer(): void {
			onDown();
			for (itera = numChildren - 1; itera >=0; --itera) {
				if (getChildAt(itera) is MyObject) {
					if ((getChildAt(itera) as MyObject).isHit()) {
						(getChildAt(itera) as MyObject).onDownTransfer();
						break;
					}
				}
			}
		}
		
		function onDown(): void {
			
		}
		
		public function onUpTransfer(): void {
			onUp();
			for (itera = numChildren - 1; itera >=0; --itera) {
				if (getChildAt(itera) is MyObject) {
					if ((getChildAt(itera) as MyObject).isHit()) {
						(getChildAt(itera) as MyObject).onUpTransfer();
						break;
					}
				}
			}
		}
		
		function onUp(): void {
			
		}
		
		public function onWheelTransfer(delta: int): void {
			onWheel(delta);
			for (itera = numChildren - 1; itera >=0; --itera) {
				if (getChildAt(itera) is MyObject) {
					if ((getChildAt(itera) as MyObject).isHit()) {
						(getChildAt(itera) as MyObject).onWheelTransfer(delta);
						break;
					}
				}
			}
		}
		
		function onWheel(delta: int): void {
			
		}
		
		function isHit(): Boolean {
			switch (advancedHit) {
				case 1:
					return hitTestPoint(stage.mouseX, stage.mouseY, true);
					break;
				case 2:
					if (hitRect) {
						return hitRect.contains(mouseX, mouseY);
					} else {
						return false;
					}
					break;
				case 3:
					if (hitShape) {
						return hitShape.hitTestPoint(stage.mouseX, stage.mouseY, true);
					} else {
						return false;
					}
					break;
				default: //0
					return hitTestPoint(stage.mouseX, stage.mouseY);
					break;
			}
		}

	}
	
}
