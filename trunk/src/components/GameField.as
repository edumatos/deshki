package components
{
	import fl.text.TLFTextField;
	
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import flashx.textLayout.formats.VerticalAlign;
	
	import org.osflash.signals.Signal;
	
	public class GameField extends Sprite
	{
		[Embed(source="../../assets/deshki.swf", symbol="GameFieldBG")]
		private var GameFieldBG:Class;
		
		private const CELL_SIZE:Number = 100.0;
		private var _numbers:Sprite;
		private var _selections:Sprite;
		
		public var cellClicked:Signal;
		
		public function GameField()
		{
			addChild(new GameFieldBG());
			
			_numbers = new Sprite();
			addChild(_numbers);
			_selections = new Sprite();
			addChild(_selections);
			
			cellClicked = new Signal(int, int);
			
			addEventListener(MouseEvent.CLICK, clickHandler);
		}
		
		public function clearNumbers():void
		{
			while(_numbers.numChildren>0)
				_numbers.removeChildAt(0);
		}
		
		public function clearSelections():void
		{
			while(_selections.numChildren>0)
				_selections.removeChildAt(0);
		}
		
		public function setNumber(x:int, y:int, value:int):void
		{
			var textField:TLFTextField = new TLFTextField();
			var textFormat:TextFormat = new TextFormat("Arial", 32, value%2==0 ? 0x000000 : 0x999999, null, null, null, null, null, TextFormatAlign.CENTER);
			textField.selectable = false;
			textField.defaultTextFormat = textFormat;
			textField.verticalAlign = VerticalAlign.MIDDLE;
			textField.width = CELL_SIZE;
			textField.height = CELL_SIZE;
			textField.x = x*CELL_SIZE;
			textField.y = y*CELL_SIZE;
			textField.text = String(value);
			_numbers.addChild(textField);
		}
		
		public function setSelection(x:int, y:int):void
		{
			var selection:Shape = new Shape();
			selection.graphics.lineStyle(2,0xFF0000);
			selection.graphics.drawRect(0,0,CELL_SIZE,CELL_SIZE);
			selection.x = x*CELL_SIZE;
			selection.y = y*CELL_SIZE;
			_selections.addChild(selection);
		}
		
		private function clickHandler(e:MouseEvent):void
		{
			cellClicked.dispatch(Math.floor(mouseX/CELL_SIZE), Math.floor(mouseY/CELL_SIZE));
		}
	}
}