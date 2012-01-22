package components
{
	import flash.display.Sprite;
	import flash.events.Event;
	
	import org.osflash.signals.Signal;
	
	import playerio.RoomInfo;
	
	import razor.controls.Button;
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
		
		public var connectButtonClicked:Signal;
		public var createRoomButtonClicked:Signal;
		public var joinRoomButtonClicked:Signal;
		public var refreshButtonClicked:Signal;
		
		public function LobbyScreen()
		{
			_yourNameLabel = ControlFactory.create(Label) as Label;
			_yourNameLabel.text = "Ваше имя";
			_yourNameLabel.setSize(100, 30);
			addChild(_yourNameLabel);
			
			_yourNameTextInput = ControlFactory.create(TextInput) as TextInput;
			_yourNameTextInput.setSize(100, 30);
			addChild(_yourNameTextInput);
			
			_connectButton = ControlFactory.create(Button) as Button;
			_connectButton.label = "Подключиться";
			_connectButton.setSize(100, 30);
			_connectButton.addEventListener(Button.E_CLICK, connectButtonClickedHandler);
			addChild(_connectButton);
			
			_roomsLabel = ControlFactory.create(Label) as Label;
			_roomsLabel.text = "Игровые комнаты";
			_roomsLabel.setSize(150, 30);
			addChild(_roomsLabel);
			
			_roomsList = ControlFactory.create(List) as List;
			_roomsList.setSize(600, 200);
			_roomsList.cellClass = RoomInfoCell;
			addChild(_roomsList);
			
			_roomNameLabel = ControlFactory.create(Label) as Label;
			_roomNameLabel.text = "Имя комнаты";
			_roomNameLabel.setSize(100, 30);
			addChild(_roomNameLabel);
			
			_roomNameTextInput = ControlFactory.create(TextInput) as TextInput;
			_roomNameTextInput.setSize(100, 30);
			addChild(_roomNameTextInput);
			
			_createRoomButton = ControlFactory.create(Button) as Button;
			_createRoomButton.label = "Создать";
			_createRoomButton.setSize(100, 30);
			_createRoomButton.addEventListener(Button.E_CLICK, createRoomButtonClickedHandler);
			addChild(_createRoomButton);
			
			_joinRoomButton = ControlFactory.create(Button) as Button;
			_joinRoomButton.label = "Войти";
			_joinRoomButton.setSize(100, 30);
			_joinRoomButton.addEventListener(Button.E_CLICK, joinRoomButtonClickedHandler);
			addChild(_joinRoomButton);
			
			_refreshButton = ControlFactory.create(Button) as Button;
			_refreshButton.label = "Обновить";
			_refreshButton.setSize(100,30);
			_refreshButton.addEventListener(Button.E_CLICK, refreshButtonClickedHandler);
			addChild(_refreshButton);
			
			connectButtonClicked = new Signal(String);
			createRoomButtonClicked = new Signal(String);
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
		}
		
		private function connectButtonClickedHandler(e:Event):void
		{
			connectButtonClicked.dispatch(_yourNameTextInput.text);
		}
		
		private function createRoomButtonClickedHandler(e:Event):void
		{
			createRoomButtonClicked.dispatch(_roomNameTextInput.text);
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