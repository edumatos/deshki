package proxies
{
	import flash.events.Event;
	
	public class GameProxyEvent extends Event
	{
		public static const UPDATED:String = "updated";
		
		private var _stateOnly:Boolean;
		
		public function GameProxyEvent(type:String, stateOnly:Boolean=false)
		{
			super(type);
			_stateOnly = stateOnly;
		}
		
		public function get stateOnly():Boolean
		{
			return _stateOnly;
		}
	}
}