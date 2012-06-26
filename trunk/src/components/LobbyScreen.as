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
	import flash.display.Sprite;
	import flash.events.Event;
	
	import mx.resources.ResourceManager;
	
	import org.osflash.signals.Signal;
	
	import playerio.RoomInfo;
	
	import razor.controls.Button;
	import razor.controls.CheckBox;
	import razor.controls.Label;
	import razor.controls.List;
	import razor.controls.TextInput;
	import razor.core.ControlFactory;
	
	public class LobbyScreen extends Sprite
	{
		private var _yourNameLabel:Label;
		private var _yourNameTextInput:TextInput;
		private var _connectButton:Button;
		private var _roomsLabel:Label;
		private var _roomsList:List;
		private var _roomNameLabel:Label;
		private var _roomNameTextInput:TextInput;
		private var _createRoomButton:Button;
		private var _joinRoomButton:Button;
		private var _refreshButton:Button;
		private var _hideHistoryCheckBox:CheckBox;
		
		public var connectButtonClicked:Signal;
		public var createRoomButtonClicked:Signal;
		public var joinRoomButtonClicked:Signal;
		public var refreshButtonClicked:Signal;
		
		public function LobbyScreen()
		{
			_yourNameLabel = ControlFactory.create(Label) as Label;
			_yourNameLabel.text = ResourceManager.getInstance().getString("MyResources", "your_name");
			_yourNameLabel.setSize(100, 30);
			addChild(_yourNameLabel);
			
			_yourNameTextInput = ControlFactory.create(TextInput) as TextInput;
			_yourNameTextInput.setSize(100, 30);
			addChild(_yourNameTextInput);
			
			_connectButton = ControlFactory.create(Button) as Button;
			_connectButton.label = ResourceManager.getInstance().getString("MyResources", "connect");
			_connectButton.setSize(100, 30);
			_connectButton.addEventListener(Button.E_CLICK, connectButtonClickedHandler);
			addChild(_connectButton);
			
			_roomsLabel = ControlFactory.create(Label) as Label;
			_roomsLabel.text = ResourceManager.getInstance().getString("MyResources", "rooms");
			_roomsLabel.setSize(150, 30);
			addChild(_roomsLabel);
			
			_roomsList = ControlFactory.create(List) as List;
			_roomsList.setSize(600, 200);
			_roomsList.cellClass = RoomInfoCell;
			addChild(_roomsList);
			
			_roomNameLabel = ControlFactory.create(Label) as Label;
			_roomNameLabel.text = ResourceManager.getInstance().getString("MyResources", "room_name");
			_roomNameLabel.setSize(100, 30);
			addChild(_roomNameLabel);
			
			_roomNameTextInput = ControlFactory.create(TextInput) as TextInput;
			_roomNameTextInput.setSize(100, 30);
			addChild(_roomNameTextInput);
			
			_createRoomButton = ControlFactory.create(Button) as Button;
			_createRoomButton.label = ResourceManager.getInstance().getString("MyResources", "create_room");
			_createRoomButton.setSize(100, 30);
			_createRoomButton.addEventListener(Button.E_CLICK, createRoomButtonClickedHandler);
			addChild(_createRoomButton);
			
			_joinRoomButton = ControlFactory.create(Button) as Button;
			_joinRoomButton.label = ResourceManager.getInstance().getString("MyResources", "join_room");
			_joinRoomButton.setSize(100, 30);
			_joinRoomButton.addEventListener(Button.E_CLICK, joinRoomButtonClickedHandler);
			addChild(_joinRoomButton);
			
			_refreshButton = ControlFactory.create(Button) as Button;
			_refreshButton.label = ResourceManager.getInstance().getString("MyResources", "refresh");
			_refreshButton.setSize(100,30);
			_refreshButton.addEventListener(Button.E_CLICK, refreshButtonClickedHandler);
			addChild(_refreshButton);
			
			_hideHistoryCheckBox = ControlFactory.create(CheckBox) as CheckBox;
			_hideHistoryCheckBox.label = ResourceManager.getInstance().getString("MyResources", "hide_history");
			_hideHistoryCheckBox.setSize(200, 30);
			addChild(_hideHistoryCheckBox);
			
			connectButtonClicked = new Signal(String);
			createRoomButtonClicked = new Signal(String, Boolean);
			joinRoomButtonClicked = new Signal(RoomInfo);
			refreshButtonClicked = new Signal();
			
			addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
		}
		
		public function set connectedAs(userId:String):void
		{
			_yourNameTextInput.text = userId;
			_yourNameTextInput.editable = false;
			_connectButton.visible = false;
			_connectButton.enabled = false;
		}
		
		public function set roomList(value:Array):void
		{
			_roomsList.dataProvider = value;
		}
		
		private function addedToStageHandler(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
			
			_yourNameLabel.move(0,0);
			_yourNameTextInput.move(100,0);
			_connectButton.move(200,0);
			_roomsLabel.move(0,30);
			_roomsList.move(0,60);
			_roomNameLabel.move(0,260);
			_roomNameTextInput.move(100,260);
			_createRoomButton.move(200,260);
			_joinRoomButton.move(300, 260);
			_refreshButton.move(400,260);
			_hideHistoryCheckBox.move(0,290);
		}
		
		private function connectButtonClickedHandler(e:Event):void
		{
			connectButtonClicked.dispatch(_yourNameTextInput.text);
		}
		
		private function createRoomButtonClickedHandler(e:Event):void
		{
			createRoomButtonClicked.dispatch(_roomNameTextInput.text, _hideHistoryCheckBox.selected);
		}
		
		private function joinRoomButtonClickedHandler(e:Event):void
		{
			var roomInfo:RoomInfo = _roomsList.selectedItem as RoomInfo;
			if(roomInfo != null)
			{
				joinRoomButtonClicked.dispatch(roomInfo);
			}
		}
		
		private function refreshButtonClickedHandler(event:Event):void
		{
			refreshButtonClicked.dispatch();
		}
	}
}