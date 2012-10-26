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
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.filters.DropShadowFilter;
	
	import org.osflash.signals.Signal;
	
	import razor.controls.Button;
	import razor.controls.Label;
	import razor.core.ControlFactory;
	
	public class Alert extends Sprite
	{
		private var _background:Shape;
		private var _messageLabel:Label;
		private var _okButton:Button;
		
		public var okButtonClicked:Signal;
		
		public function Alert()
		{
			_background = new Shape();
			_background.graphics.beginFill(0xFF8899);
			_background.graphics.drawRoundRect(0,0,200,200,10);
			_background.graphics.endFill();
			_background.filters = [new DropShadowFilter(4,45,0,1,4,4,0.5)];
			addChild(_background);
			
			_messageLabel = ControlFactory.create(Label) as Label;
			_messageLabel.setSize(200,170);
			_messageLabel.align = "center";
			addChild(_messageLabel);
			
			_okButton = ControlFactory.create(Button) as Button;
			_okButton.label = "OK";
			_okButton.setSize(100,30);
			_okButton.addEventListener(Button.E_CLICK, okButtonClickedHandler);
			addChild(_okButton);
			
			okButtonClicked = new Signal();
			
			addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
		}
		
		public function set message(value:String):void
		{
			_messageLabel.text = value;
		}
		
		private function addedToStageHandler(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
			
			_okButton.move((_background.width-_okButton.width)*0.5,170);
			
			x = (stage.stageWidth-width)*0.5;
			y = (stage.stageHeight-height)*0.5;
		}
		
		private function okButtonClickedHandler(e:Event):void
		{
			okButtonClicked.dispatch();
		}
	}
}