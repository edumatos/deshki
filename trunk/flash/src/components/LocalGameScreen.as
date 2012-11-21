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
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	
	import mx.resources.ResourceManager;
	
	import org.osflash.signals.Signal;
	
	import razor.controls.Button;
	import razor.controls.Label;
	import razor.controls.TextArea;
	import razor.core.ControlFactory;
	
	public class LocalGameScreen extends Sprite
	{
		private var _gameField:GameField;
		private var _restartButton:Button;
		private var _stateLabel:Label;
		private var _historyTextArea:TextArea;
		
		public var restartButtonClicked:Signal;
		
		public function LocalGameScreen()
		{
			_gameField = new GameField();
			_gameField.width = 396;
			_gameField.height = 396;
			addChild(_gameField);
			
			_restartButton = ControlFactory.create(Button) as Button;
			_restartButton.label = ResourceManager.getInstance().getString("Strings", "new_game");
			_restartButton.setSize(200, 30);
			_restartButton.addEventListener(Button.E_CLICK, restartButtonClickedHandler);
			addChild(_restartButton);
			
			_stateLabel = ControlFactory.create(Label) as Label;
			_stateLabel.setSize(200, 300);
			addChild(_stateLabel);
			
			_historyTextArea = ControlFactory.create(TextArea) as TextArea;
			_historyTextArea.setSize(200,100);
			addChild(_historyTextArea);
			
			restartButtonClicked = new Signal();
			
			addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
		}
		
		public function get gameField():GameField
		{
			return _gameField;
		}
		
		public function set stateLabelText(value:String):void
		{
			_stateLabel.text = value;
		}
		
		public function appendToHistory(line:String):void
		{
			_historyTextArea.text += (_historyTextArea.text.length>0 ? "\n" : "")+line;
			_historyTextArea.textField.scrollV = _historyTextArea.textField.maxScrollV;
		}
		
		public function set historyVisible(value:Boolean):void
		{
			_historyTextArea.visible = value;
		}
		
		private function addedToStageHandler(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
			
			_gameField.x = 20;
			_gameField.y = 20;
			
			_restartButton.move(stage.stageWidth-_restartButton.width, stage.stageHeight-_restartButton.height);
			
			_stateLabel.move(stage.stageWidth-_stateLabel.width, 0);
			
			_historyTextArea.move(stage.stageWidth-_historyTextArea.width, stage.stageHeight-_restartButton.height-_historyTextArea.height-2);
		}
		
		private function restartButtonClickedHandler(e:Event):void
		{
			restartButtonClicked.dispatch();
		}
	}
}