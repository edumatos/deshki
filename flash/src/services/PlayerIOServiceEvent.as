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
	import flash.events.Event;
	
	public class PlayerIOServiceEvent extends Event
	{
		/**
		 * Соединение с сервером успешно установлено.
		 * body содержит String c идентификатором пользователя.
		 */
		public static const CONNECTED:String = "connected";
		
		/**
		 * Произошла ошибка.
		 * body содержит String с описанием ошибки.
		 */
		public static const ERROR:String = "error";
		
		/**
		 * Соединение с комнатой потеряно.
		 */
		public static const DISCONNECTED:String = "disconnected";
		
		/**
		 * Список комнат успешно получен.
		 * body содержит Array из элементов типа RoomInfo.
		 */
		public static const ROOM_LIST:String = "roomList";
		
		/**
		 * Вход в комнату успешно выполнен.
		 * body содержит String с типом комнаты.
		 */
		public static const ROOM_JOINED:String = "roomJoined";
		
		/**
		 * Выход из комнаты успешно выполнен.
		 */
		public static const ROOM_LEFT:String = "roomLeft";
		
		/**
		 * Сообщение от сервера успешно пришло.
		 * body содержит Message.
		 */
		public static const MESSAGE:String = "message";
		
		private var _body:Object;
		
		public function PlayerIOServiceEvent(type:String, body:Object = null)
		{
			super(type);
			_body = body;
		}
		
		public function get body():Object
		{
			return _body;
		}
		
		override public function clone():Event
		{
			return new PlayerIOServiceEvent(type, body);
		}
	}
}