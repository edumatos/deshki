package proxies
{
	import entities.Move;
	
	import flash.events.Event;
	
	public class ComputerPlayerProxyEvent extends Event
	{
		public static const DONE:String = "done";
		
		private var _move:Move;
		
		public function ComputerPlayerProxyEvent(type:String, move:Move)
		{
			super(type);
			_move = move;
		}
		
		public function get move():Move
		{
			return _move;
		}
	}
}