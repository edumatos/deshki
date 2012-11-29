/*
* Игра Дешки
* Copyright (C) 2012  Павел Кабакин
* 
* This program is free software: you can redistribute it and/or modify
* it under the terms of the GNU General Public License as published by
* the Free Software Foundation, either version 3 of the License, or
* (at your option) any later version.
* 
* This program is distributed in the hope that it will be useful,
* but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
* GNU General Public License for more details.
* 
* You should have received a copy of the GNU General Public License
* along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/
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
		
		public function hideNumbers():void
		{
			for(var i:int=0; i<_numbers.numChildren; ++i)
				_numbers.getChildAt(i).visible = false;
		}
		
		public function showNumbers():void
		{
			for(var i:int=0; i<_numbers.numChildren; ++i)
				_numbers.getChildAt(i).visible = true;
		}
		
		public function clearSelections():void
		{
			while(_selections.numChildren>0)
				_selections.removeChildAt(0);
		}
		
		public function setCell(x:int, y:int, value:String):void
		{
			var textField:TLFTextField = new TLFTextField();
			var textFormat:TextFormat = new TextFormat("Arial", 32, int(value)%2==0 ? 0x000000 : 0x999999, null, null, null, null, null, TextFormatAlign.CENTER);
			textField.selectable = false;
			textField.defaultTextFormat = textFormat;
			textField.verticalAlign = VerticalAlign.MIDDLE;
			textField.width = CELL_SIZE;
			textField.height = CELL_SIZE;
			textField.x = x*CELL_SIZE;
			textField.y = y*CELL_SIZE;
			textField.text = value;
			_numbers.addChild(textField);
		}
		
		public function setSelection(x:int, y:int, lastMove:Boolean = false):void
		{
			var selection:Shape = new Shape();
			selection.graphics.lineStyle(lastMove ? 5 : 3,lastMove ? 0x000000 : 0x00AA00);
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