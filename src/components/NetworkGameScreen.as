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
	
	import org.osflash.signals.Signal;
	
	import razor.controls.Button;
	import razor.controls.Label;
	import razor.core.ControlFactory;
	
	public class NetworkGameScreen extends Sprite
	{
		[Embed(source="../../assets/deshki.swf", symbol="Status")]
		private var Status:Class;
		
		private var _gameField:GameField;
		private var _exitButton:Button;
		private var _stateLabel:Label;
		private var _status:Sprite;
		
		public var exitButtonClicked:Signal;
		
		public function NetworkGameScreen()
		{
			_gameField = new GameField();
			_gameField.width = 396;
			_gameField.height = 396;
			addChild(_gameField);
			
			_exitButton = ControlFactory.create(Button) as Button;
			_exitButton.label = "Выйти из комнаты";
			_exitButton.setSize(200, 30);
			_exitButton.addEventListener(Button.E_CLICK, exitButtonClickedHandler);
			addChild(_exitButton);
			
			_stateLabel = ControlFactory.create(Label) as Label;
			_stateLabel.setSize(200, 300);
			addChild(_stateLabel);
			
			_status = new Status;
			_status["evenName"].text = "";
			_status["oddName"].text = "";
			addChild(_status);
			
			exitButtonClicked = new Signal();
			
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
		
		public function set evenName(value:String):void
		{
			_status["evenName"].text = value;
		}
		
		public function set oddName(value:String):void
		{
			_status["oddName"].text = value;
		}
		
		public function setTimers(evenTime:Number, oddTime:Number):void
		{
			if(evenTime<=0.5)
			{
				_status["evenTimer"].timerMask1.rotation = 360*evenTime;
				_status["evenTimer"].timerMask2.rotation = 180;
			}
			else
			{
				_status["evenTimer"].timerMask1.rotation = 180;
				_status["evenTimer"].timerMask2.rotation = 360*evenTime;
			}
			
			if(oddTime<=0.5)
			{
				_status["oddTimer"].timerMask1.rotation = 360*oddTime;
				_status["oddTimer"].timerMask2.rotation = 180;
			}
			else
			{
				_status["oddTimer"].timerMask1.rotation = 180;
				_status["oddTimer"].timerMask2.rotation = 360*oddTime;
			}
		}
		
		private function addedToStageHandler(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
			
			_gameField.x = 2;
			_gameField.y = 2;
			
			_exitButton.move(stage.stageWidth-_exitButton.width, stage.stageHeight-_exitButton.height);
			
			_stateLabel.move(stage.stageWidth-_stateLabel.width, 0);
			
			_status.x = 420;
			_status.y = 40;
		}
		
		private function exitButtonClickedHandler(e:Event):void
		{
			exitButtonClicked.dispatch();
		}
	}
}