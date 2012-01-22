package ai
{
	import entities.Game;
	import entities.Move;
	
	import org.osflash.signals.Signal;

	public class ComputerPlayer
	{
		private var _strategy:AbstractStrategy;
		
		public var done:Signal = new Signal(Move);
		
		public function set strategy(value:AbstractStrategy):void
		{
			if(_strategy!=null)
			{
				_strategy.done.remove(doneHandler);
			}
			_strategy = value;
			_strategy.done.add(doneHandler);
		}
		
		public function doMove(game:Game):void
		{
			_strategy.doMove(game);
		}
		
		private function doneHandler(move:Move):void
		{
			done.dispatch(move);
		}
	}
}