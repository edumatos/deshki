package mediators
{
	import components.LobbyScreen;
	
	import context.ApplicationContext;
	
	import org.robotlegs.base.ContextEvent;
	import org.robotlegs.mvcs.Mediator;
	
	import playerio.RoomInfo;
	
	import services.PlayerIOService;
	import services.PlayerIOServiceEvent;
	
	public class LobbyScreenMediator extends Mediator
	{
		[Inject]
		public var lobbyScreen:LobbyScreen;
		
		override public function onRegister():void
		{
			lobbyScreen.connectButtonClicked.add(connectButtonClickedHandler);
			lobbyScreen.createRoomButtonClicked.add(createRoomButtonClickedHandler);
			lobbyScreen.joinRoomButtonClicked.add(joinRoomButtonClickedHandler);
			lobbyScreen.refreshButtonClicked.add(refreshButtonClickedHandler);
			
			eventMap.mapListener(eventDispatcher, ApplicationContext.ROOM_LIST_ARRIVED, roomListArrivedHandler, ContextEvent);
			eventMap.mapListener(eventDispatcher, ApplicationContext.CONNECTED, connectedHandler, ContextEvent);
		}
		
		override public function onRemove():void
		{
			lobbyScreen.connectButtonClicked.remove(connectButtonClickedHandler);
			lobbyScreen.createRoomButtonClicked.remove(createRoomButtonClickedHandler);
			lobbyScreen.joinRoomButtonClicked.remove(joinRoomButtonClickedHandler);
			lobbyScreen.refreshButtonClicked.remove(refreshButtonClickedHandler);
		}
		
		private function connectedHandler(e:ContextEvent):void
		{
			lobbyScreen.connectedAs = e.body as String;
			dispatch(new ContextEvent(ApplicationContext.REFRESH_ROOM_LIST));
		}
		
		private function connectButtonClickedHandler(name:String):void
		{
			dispatch(new ContextEvent(ApplicationContext.CONNECT, name));
		}
		
		private function createRoomButtonClickedHandler(name:String):void
		{
			dispatch(new ContextEvent(ApplicationContext.CREATE_ROOM, name));
		}
		
		private function joinRoomButtonClickedHandler(roomInfo:RoomInfo):void
		{
			dispatch(new ContextEvent(ApplicationContext.JOIN_ROOM, roomInfo));
		}
		
		private function refreshButtonClickedHandler():void
		{
			dispatch(new ContextEvent(ApplicationContext.REFRESH_ROOM_LIST));
		}
		
		private function roomListArrivedHandler(e:ContextEvent):void
		{
			lobbyScreen.roomList = e.body as Array;
		}
	}
}