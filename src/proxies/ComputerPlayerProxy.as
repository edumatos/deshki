package proxies
{
	import ai.AbstractStrategy;
	import ai.ComputerPlayer;
	import ai.GreedyStrategy;
	import ai.RandomStrategy;
	import ai.ShallowStrategy;
	import ai.SimpleStrategy;
	
	import entities.Game;
	import entities.Move;
	
	import org.robotlegs.mvcs.Actor;
	
	public class ComputerPlayerProxy extends Actor
	{
		private var _computerPlayer:ComputerPlayer;
		
		public function ComputerPlayerProxy()
		{
			_computerPlayer = new ComputerPlayer();
			_computerPlayer.done.add(doneHandler);
			_computerPlayer.strategy = new SimpleStrategy();
		}
		
		public function set strategy(value:AbstractStrategy):void
		{
			_computerPlayer.strategy = value;
		}
		
		public function pickRandomStrategy():void
		{
			switch(int(Math.random()*4.0))
			{
				case 0:
					_computerPlayer.strategy = new SimpleStrategy();
					break;
				case 1:
					_computerPlayer.strategy = new RandomStrategy();
					break;
				case 2:
					_computerPlayer.strategy = new GreedyStrategy();
					break;
				case 3:
					_computerPlayer.strategy = new ShallowStrategy();
					break;
			}
		}
		
		public function doMove(game:Game):void
		{
			_computerPlayer.doMove(game);
		}
		
		private function doneHandler(move:Move):void
		{
			dispatch(new ComputerPlayerProxyEvent(ComputerPlayerProxyEvent.DONE, move));
		}
	}
}