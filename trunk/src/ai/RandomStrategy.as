package ai
{
	import entities.Game;
	import entities.Move;
	
	import flash.utils.setTimeout;
	
	public class RandomStrategy extends AbstractStrategy
	{
		override public function doMove(game:Game):void
		{
			setTimeout(delayedHandler, 500, game);
		}
		
		private function delayedHandler(game:Game):void
		{
			var moves:Vector.<Move> = game.getPossibleMoves();
			done.dispatch(moves[int(Math.random()*moves.length)]);
		}
	}
}