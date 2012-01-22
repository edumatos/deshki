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