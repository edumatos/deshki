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
			lobbyScreen.backToWelcomeButtonClicked.add(backToWelcomeScreenButtonClickedHandler);
			
			eventMap.mapListener(eventDispatcher, ApplicationContext.ROOM_LIST_ARRIVED, roomListArrivedHandler, ContextEvent);
			eventMap.mapListener(eventDispatcher, ApplicationContext.CONNECTED, connectedHandler, ContextEvent);
		}
		
		override public function onRemove():void
		{
			lobbyScreen.connectButtonClicked.remove(connectButtonClickedHandler);
			lobbyScreen.createRoomButtonClicked.remove(createRoomButtonClickedHandler);
			lobbyScreen.joinRoomButtonClicked.remove(joinRoomButtonClickedHandler);
			lobbyScreen.refreshButtonClicked.remove(refreshButtonClickedHandler);
			lobbyScreen.backToWelcomeButtonClicked.remove(backToWelcomeScreenButtonClickedHandler);
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
		
		private function createRoomButtonClickedHandler(name:String, hideHistory:Boolean):void
		{
			dispatch(new ContextEvent(ApplicationContext.CREATE_ROOM, {name:name, hideHistory:hideHistory}));
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
		
		private function backToWelcomeScreenButtonClickedHandler():void
		{
			dispatch(new ContextEvent(ApplicationContext.DISPLAY_WELCOME_SCREEN));
		}
	}
}