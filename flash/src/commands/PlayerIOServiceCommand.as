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
package commands
{
	import context.ApplicationContext;
	
	import entities.Move;
	import entities.User;
	
	import org.robotlegs.base.ContextEvent;
	import org.robotlegs.mvcs.Command;
	
	import playerio.Message;
	
	import proxies.GameProxy;
	import proxies.RoomProxy;
	
	import services.PlayerIOService;
	import services.PlayerIOServiceEvent;
	
	public class PlayerIOServiceCommand extends Command
	{
		[Inject]
		public var event:PlayerIOServiceEvent;
		
		override public function execute():void
		{
			switch(event.type)
			{
				case PlayerIOServiceEvent.CONNECTED:
					handleConnected();
					break;
				
				case PlayerIOServiceEvent.ERROR:
					handleError();
					break;
				
				case PlayerIOServiceEvent.DISCONNECTED:
					handleDisconnected();
					break;
				
				case PlayerIOServiceEvent.ROOM_LIST:
					handleRoomList();
					break;
				
				case PlayerIOServiceEvent.ROOM_JOINED:
					handleRoomJoined();
					break;
				
				case PlayerIOServiceEvent.ROOM_LEFT:
					handleRoomLeft();
					break;
				
				case PlayerIOServiceEvent.MESSAGE:
					handleMessage();
					break;
			}
		}
		
		private function handleConnected():void
		{
			var playerIOService:PlayerIOService = injector.getInstance(PlayerIOService) as PlayerIOService;
			dispatch(new ContextEvent(ApplicationContext.CONNECTED, playerIOService.userId));
		}
		
		private function handleError():void
		{
			dispatch(new ContextEvent(ApplicationContext.DISPLAY_ALERT, event.body));
		}
		
		private function handleDisconnected():void
		{
			dispatch(new ContextEvent(ApplicationContext.DISPLAY_LOBBY_SCREEN));
		}
		
		private function handleRoomList():void
		{
			dispatch(new ContextEvent(ApplicationContext.ROOM_LIST_ARRIVED, event.body as Array));
		}
		
		private function handleRoomJoined():void
		{
			var playerIOService:PlayerIOService = injector.getInstance(PlayerIOService) as PlayerIOService;
			playerIOService.registerMessageType("UserList");
			playerIOService.registerMessageType("UserJoined");
			playerIOService.registerMessageType("UserLeft");
			playerIOService.registerMessageType("ChatMessage");
			playerIOService.registerMessageType("Start");
			playerIOService.registerMessageType("Stop");
			playerIOService.registerMessageType("Move");
			playerIOService.registerMessageType("TimeIsUp");
			
			dispatch(new ContextEvent(ApplicationContext.DISPLAY_NETWORK_GAME_SCREEN));
		}
		
		private function handleRoomLeft():void
		{
			dispatch(new ContextEvent(ApplicationContext.DISPLAY_LOBBY_SCREEN));
		}
		
		private function handleMessage():void
		{
			var message:Message = event.body as Message;
			switch(message.type)
			{
				case "UserList":
					handleUserList(message);
					break;
				
				case "UserJoined":
					handleUserJoined(message);
					break;
				
				case "UserLeft":
					handleUserLeft(message);
					break;
				
				case "ChatMessage":
					handleChatMessage(message);
					break;
				
				case "Start":
					handleStart(message);
					break;
					
				case "Stop":
					handleStop(message);
					break;
					
				case "Move":
					handleMove(message);
					break;
				
				case "TimeIsUp":
					handleTimeIsUp(message);
					break;
			}
		}
		
		private function handleUserList(message:Message):void
		{
			var roomProxy:RoomProxy = injector.getInstance(RoomProxy) as RoomProxy;
			var users:Vector.<User> = new Vector.<User>();
			for(var i:int = 1; i<message.length; i += 2)
			{
				users.push(new User(message.getInt(i), message.getString(i+1)));
			}
			roomProxy.setUserList(message.getInt(0), users);
		}
		
		private function handleUserJoined(message:Message):void
		{
			var roomProxy:RoomProxy = injector.getInstance(RoomProxy) as RoomProxy;
			roomProxy.userJoined(new User(message.getInt(0), message.getString(1)));
		}
		
		private function handleUserLeft(message:Message):void
		{
			var roomProxy:RoomProxy = injector.getInstance(RoomProxy) as RoomProxy;
			roomProxy.userLeft(roomProxy.getUserById(message.getInt(0)));
		}
		
		private function handleChatMessage(message:Message):void
		{
			var roomProxy:RoomProxy = injector.getInstance(RoomProxy) as RoomProxy;
			dispatch(new ContextEvent(ApplicationContext.MESSAGE_ARRIVED, {user:roomProxy.getUserById(message.getInt(0)).name, message:message.getString(1)}));
		}
		
		private function handleStart(message:Message):void
		{
			var gameProxy:GameProxy = injector.getInstance(GameProxy) as GameProxy;
			var roomProxy:RoomProxy = injector.getInstance(RoomProxy) as RoomProxy;
			roomProxy.setUserRoles(message.getInt(1), message.getInt(2));
			if(roomProxy.myUserId==roomProxy.evenUserId)
			{
				gameProxy.reset(message.getBoolean(0), GameProxy.HUMAN, GameProxy.NETWORK, message.getInt(3));
			}
			else if(roomProxy.myUserId==roomProxy.oddUserId)
			{
				gameProxy.reset(message.getBoolean(0), GameProxy.NETWORK, GameProxy.HUMAN, message.getInt(3));
			}
			else
			{
				gameProxy.reset(message.getBoolean(0), GameProxy.NETWORK, GameProxy.NETWORK, message.getInt(3));
			}
		}
		
		private function handleStop(message:Message):void
		{
			var gameProxy:GameProxy = injector.getInstance(GameProxy) as GameProxy;
			gameProxy.gotoWaitingState();
		}
		
		private function handleMove(message:Message):void
		{
			dispatch(new ContextEvent(ApplicationContext.DO_MOVE, new Move(message.getInt(0), message.getInt(1))));
		}
		
		private function handleTimeIsUp(message:Message):void
		{
			var gameProxy:GameProxy = injector.getInstance(GameProxy) as GameProxy;
			gameProxy.stop();
		}
	}
}