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