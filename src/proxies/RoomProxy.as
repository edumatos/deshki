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
	import entities.User;
	
	import org.robotlegs.mvcs.Actor;
	
	public class RoomProxy extends Actor
	{
		private var _users:Vector.<User> = new Vector.<User>();
		private var _myUserId:int;
		private var _evenUserId:int;
		private var _oddUserId:int;
		
		public function get myUserId():int
		{
			return _myUserId;
		}
		
		public function setUserList(myUserId:int, users:Vector.<User>):void
		{
			_myUserId = myUserId;
			_users = users;
			
			dispatch(new RoomProxyEvent(RoomProxyEvent.USER_LIST_CHANGED));
		}
		
		public function userJoined(user:User):void
		{
			var index:int = _users.indexOf(user);
			if(index<0)
			{
				_users.push(user);
				dispatch(new RoomProxyEvent(RoomProxyEvent.USER_JOINED, user));
			}
		}
		
		public function userLeft(user:User):void
		{
			var index:int = _users.indexOf(user);
			if(index>=0)
			{
				_users.splice(index,1);
				dispatch(new RoomProxyEvent(RoomProxyEvent.USER_LEFT, user));
			}
		}
		
		public function getUserById(id:int):User
		{
			for(var i:int=0; i<_users.length; ++i)
				if(_users[i].id==id)
					return _users[i];
			return null;
		}
		
		public function setUserRoles(evenUserId:int, oddUserId:int):void
		{
			_evenUserId = evenUserId;
			_oddUserId = oddUserId;
			dispatch(new RoomProxyEvent(RoomProxyEvent.USER_ROLES_CHANGED));
		}
		
		public function get evenUserId():int
		{
			return _evenUserId;
		}
		
		public function get oddUserId():int
		{
			return _oddUserId;
		}
	}
}