package {
	import flash.text.TextField;
	
	
	public class Lib {
		public static const tileSize:int = 20;
		public static var focusOnTextField: TextField;
		public static var editor: Editor;
		public static var log: TextField;
		public static var isKeyboardCaptured: Boolean = false;
		public static var keyboardCapturer: MyObject;
		
		public function Lib(): void {
			
		}
		
		/*public function drawTile (X: int, Y: int, dest: Graphics) {
			
			dest.lineStyle(0, 0x869E97);
			dest.beginFill(0xB0CCBF);
			dest.drawRect(X*tileSize, Y*tileSize, tileSize, tileSize);
			
			dest.lineStyle(tileSize/10, 0x869E97);
			dest.beginFill(0xB0CCBF);
			dest.drawCircle(X*tileSize + tileSize/2, Y*tileSize + tileSize/2, tileSize*2/5);
			dest.endFill();
			
			dest.moveTo(X*tileSize + tileSize/2, Y*tileSize + tileSize/10);
			dest.lineTo(X*tileSize + tileSize/10, Y*tileSize + tileSize/10);
			dest.lineTo(X*tileSize + tileSize/10, Y*tileSize + tileSize/2);
			
			dest.moveTo(X*tileSize + tileSize/2, Y*tileSize + tileSize*9/10);
			dest.lineTo(X*tileSize + tileSize*9/10, Y*tileSize + tileSize*9/10);
			dest.lineTo(X*tileSize + tileSize*9/10, Y*tileSize + tileSize/2);

		}*/
	}
	
}