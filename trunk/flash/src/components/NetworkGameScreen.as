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
	import razor.controls.TextInput;
	import razor.core.ControlFactory;
	
	public class NetworkGameScreen extends Sprite
	{
		[Embed(source="../../assets/deshki.swf", symbol="Status")]
		private var Status:Class;
		
		private var _gameField:GameField;
		private var _newGameButton:Button;
		private var _exitButton:Button;
		private var _stateLabel:Label;
		private var _status:Sprite;
		private var _historyTextArea:TextArea;
		private var _chatTextArea:TextArea;
		private var _messageTextInput:TextInput;
		private var _sendButton:Button;
		
		public var exitButtonClicked:Signal;
		public var newGameButtonClicked:Signal;
		public var sendButtonClicked:Signal;
		
		public function NetworkGameScreen()
		{
			_gameField = new GameField();
			_gameField.width = 396;
			_gameField.height = 396;
			addChild(_gameField);
			
			_exitButton = ControlFactory.create(Button) as Button;
			_exitButton.label = ResourceManager.getInstance().getString("Strings", "leave_room");
			_exitButton.setSize(200, 30);
			_exitButton.addEventListener(Button.E_CLICK, exitButtonClickedHandler);
			addChild(_exitButton);
			
			_newGameButton = ControlFactory.create(Button) as Button;
			_newGameButton.label = ResourceManager.getInstance().getString("Strings", "new_game");
			_newGameButton.setSize(200, 30);
			_newGameButton.addEventListener(Button.E_CLICK, newGameButtonClickedHandler);
			addChild(_newGameButton);
			
			_stateLabel = ControlFactory.create(Label) as Label;
			_stateLabel.setSize(200, 300);
			addChild(_stateLabel);
			
			_status = new Status;
			_status["evenTF"].text = ResourceManager.getInstance().getString("Strings", "even");
			_status["oddTF"].text = ResourceManager.getInstance().getString("Strings", "odd");
			_status["evenName"].text = "";
			_status["oddName"].text = "";
			addChild(_status);
			
			_historyTextArea = ControlFactory.create(TextArea) as TextArea;
			_historyTextArea.setSize(200,100);
			addChild(_historyTextArea);
			
			_chatTextArea = ControlFactory.create(TextArea) as TextArea;
			_chatTextArea.setSize(200,100);
			addChild(_chatTextArea);
			
			_messageTextInput = ControlFactory.create(TextInput) as TextInput;
			_messageTextInput.setSize(100, 30);
			_messageTextInput.addEventListener(TextInput.E_ENTER, sendButtonClickedHandler);
			addChild(_messageTextInput);
			
			_sendButton = ControlFactory.create(Button) as Button;
			_sendButton.label = ResourceManager.getInstance().getString("Strings", "send");
			_sendButton.setSize(100, 30);
			_sendButton.addEventListener(Button.E_CLICK, sendButtonClickedHandler);
			addChild(_sendButton);
			
			exitButtonClicked = new Signal();
			newGameButtonClicked = new Signal();
			sendButtonClicked = new Signal(String);
			
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
		
		public function appendToHistory(line:String):void
		{
			_historyTextArea.text += (_historyTextArea.text.length>0 ? "\n" : "")+line;
			_historyTextArea.textField.scrollV = _historyTextArea.textField.maxScrollV;
		}
		
		public function set historyVisible(value:Boolean):void
		{
			_historyTextArea.visible = value;
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
		
		public function get newGameButtonEnabled():Boolean
		{
			return _newGameButton.enabled;
		}
		
		public function set newGameButtonEnabled(value:Boolean):void
		{
			_newGameButton.enabled = value;
		}
		
		public function appendChatMessage(user:String, message:String):void
		{
			_chatTextArea.text += (_chatTextArea.text.length>0 ? "\n" : "")+user+": "+message;
			_chatTextArea.textField.scrollV = _chatTextArea.textField.maxScrollV;
		}
		
		private function addedToStageHandler(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
			
			_gameField.x = 20;
			_gameField.y = 20;
			
			_exitButton.move(stage.stageWidth-_exitButton.width, stage.stageHeight-_exitButton.height);
			
			_newGameButton.move(stage.stageWidth-_newGameButton.width, stage.stageHeight-_exitButton.height-_newGameButton.height-2);
			
			_stateLabel.move(stage.stageWidth-_stateLabel.width, 0);
			
			_status.x = 420;
			_status.y = 40;
			
			_historyTextArea.move(stage.stageWidth-_historyTextArea.width, stage.stageHeight-_exitButton.height-_newGameButton.height-_historyTextArea.height-4);
			
			_messageTextInput.move(stage.stageWidth-_messageTextInput.width-100, _historyTextArea.y-_messageTextInput.height-2);
			
			_sendButton.move(stage.stageWidth-_sendButton.width, _historyTextArea.y-_sendButton.height-2);
			
			_chatTextArea.move(stage.stageWidth-_chatTextArea.width, _messageTextInput.y-_chatTextArea.height-2);
		}
		
		private function exitButtonClickedHandler(e:Event):void
		{
			exitButtonClicked.dispatch();
		}
		
		private function newGameButtonClickedHandler(e:Event):void
		{
			newGameButtonClicked.dispatch();
		}
		
		private function sendButtonClickedHandler(e:Event):void
		{
			if(_messageTextInput.text == "")
				return;
			sendButtonClicked.dispatch(_messageTextInput.text);
			_messageTextInput.text = "";
		}
	}
}