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
package services
{
	
	import flash.display.Stage;
	
	import org.robotlegs.mvcs.Actor;
	
	import playerio.Client;
	import playerio.Connection;
	import playerio.Message;
	import playerio.PlayerIO;
	import playerio.PlayerIOError;
	import playerio.PlayerIORegistrationError;
	import playerio.RoomInfo;
	
	public class PlayerIOService extends Actor
	{
		private var _client:Client;
		private var _connection:Connection;
		
		public function get userId():String
		{
			return _client.connectUserId;
		}
		
		public function get isConnected():Boolean
		{
			return _client != null;
		}
		
		public function get isInRoom():Boolean
		{
			return _connection != null && _connection.connected;
		}
		
		public function connect(stage:Stage, gameid:String, connectionid:String, userid:String, auth:String):void
		{
			if(!isConnected)
			{
				PlayerIO.connect(stage, gameid, connectionid, userid, auth, handleConnect, handleError);
			}
		}
		
		public function listRooms(roomType:String, searchCriteria:Object, resultLimit:int, resultOffset:int):void
		{
			if (isConnected)
			{
				_client.multiplayer.listRooms(roomType, searchCriteria, resultLimit, resultOffset, handleRoomList, handleError);
			}
		}
		
		public function createAndJoinRoom(roomId:String, roomType:String, visible:Boolean, roomData:Object, joinData:Object):void
		{
			if (isConnected)
			{
				// Здесь нельзя просто вызвать createJoinRoom, потому что необходимо предотвратить
				// возможность подключения к уже существующей комнате с именем roomId.
				// Приходится сначала вызывать createRoom, а затем joinRoom.
				_client.multiplayer.createRoom(roomId, roomType, visible, roomData,
					function(newRoomId:String):void { handleCreateRoom(roomType, newRoomId, joinData); }, handleError);
			}
		}
		
		public function joinServiceRoom(roomType:String, visible:Boolean, roomData:Object, joinData:Object):void
		{
			if (isConnected)
			{
				_client.multiplayer.createJoinRoom("$service-room$", roomType, visible, roomData, joinData,
					function(connection:Connection):void { handleJoinRoom(roomType, connection); }, handleError);
			}
		}
		
		public function joinRoom(room:RoomInfo, joinData:Object):void
		{
			if (isConnected)
			{
				_client.multiplayer.joinRoom(room.id, joinData,
					function(connection:Connection):void { handleJoinRoom(room.roomType, connection); }, handleError);
			}
		}
		
		public function leaveRoom():void
		{
			if (isInRoom)
			{
				_connection.removeDisconnectHandler(handleDisconnect);
				_connection.disconnect();
				_connection = null;
				
				dispatch(new PlayerIOServiceEvent(PlayerIOServiceEvent.ROOM_LEFT));
			}
		}
		
		public function registerMessageType(type:String):void
		{
			if (isInRoom)
			{
				_connection.addMessageHandler(type, handleMessage);
			}
		}
		
		public function removeMessageType(type:String):void
		{
			if (isInRoom)
			{
				_connection.removeMessageHandler(type, handleMessage);
			}
		}
		
		public function send(type:String, ...args:Array):void
		{
			if (isInRoom)
			{
				_connection.send.apply(null, [type].concat(args));
			}
		}
		
		private function handleConnect(client:Client):void
		{
			_client = client;
			//_client.multiplayer.developmentServer = "localhost:8184";
			
			dispatch(new PlayerIOServiceEvent(PlayerIOServiceEvent.CONNECTED, _client.connectUserId));
		}
		
		private function handleCreateRoom(roomType:String, roomId:String, joinData:Object):void
		{
			_client.multiplayer.joinRoom(roomId, joinData,
				function(connection:Connection):void { handleJoinRoom(roomType, connection); }, handleError);
		}
		
		private function handleError(error:PlayerIOError = null):void
		{
			if(error is PlayerIORegistrationError)
			{
				var regError:PlayerIORegistrationError = error as PlayerIORegistrationError;
				var message:String = regError.usernameError == null ? "" : regError.usernameError;
				message += (regError.passwordError != null ? (message.length > 0 ? "\n" : "") + regError.passwordError : "");
				dispatch(new PlayerIOServiceEvent(PlayerIOServiceEvent.ERROR, message));
			}
			else
			{
				dispatch(new PlayerIOServiceEvent(PlayerIOServiceEvent.ERROR, error.message));
			}
		}
		
		private function handleRoomList(rooms:Array):void
		{
			dispatch(new PlayerIOServiceEvent(PlayerIOServiceEvent.ROOM_LIST, rooms));
		}
		
		private function handleJoinRoom(roomType:String, connection:Connection):void
		{
			// если уже было подключение к комнате, то разорвать это подключение
			if (isInRoom)
			{
				_connection.removeDisconnectHandler(handleDisconnect);
				_connection.disconnect();
			}
			_connection = connection;
			_connection.addDisconnectHandler(handleDisconnect);
			
			dispatch(new PlayerIOServiceEvent(PlayerIOServiceEvent.ROOM_JOINED, roomType));
		}
		
		private function handleDisconnect():void
		{
			_connection.removeDisconnectHandler(handleDisconnect);
			dispatch(new PlayerIOServiceEvent(PlayerIOServiceEvent.DISCONNECTED));
		}
		
		private function handleMessage(m:Message):void
		{
			dispatch(new PlayerIOServiceEvent(PlayerIOServiceEvent.MESSAGE, m));
		}
	}
}