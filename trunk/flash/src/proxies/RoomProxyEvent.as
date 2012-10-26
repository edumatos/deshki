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
package proxies
{
	import flash.events.Event;
	
	public class RoomProxyEvent extends Event
	{
		public static const USER_LIST_CHANGED:String = "userListChanged";
		public static const USER_JOINED:String = "userJoined";
		public static const USER_LEFT:String = "userLeft";
		public static const USER_ROLES_CHANGED:String = "userRolesChanged";
		
		private var _body:Object;
		
		public function RoomProxyEvent(type:String, body:Object = null)
		{
			super(type);
			_body = body;
		}
		
		public function get body():Object
		{
			return _body;
		}
	}
}