package ai
{
	import entities.Game;
	import entities.Move;
	
	import flash.utils.setTimeout;

	public class GreedyStrategy extends AbstractStrategy
	{
		override public function doMove(game:Game):void
		{
			setTimeout(delayedHandler, 500, game);
		}
		
		private function delayedHandler(game:Game):void
		{
			var moves:Vector.<Move> = game.getPossibleMoves();
			
			// ищем ходы, которые дают наименьший выбор ходов сопернику
			var bestMoves:Vector.<Move> = new Vector.<Move>();
			var bestValue:int;
			for(var i:int=0; i<moves.length; ++i)
			{
				var newGame:Game = new Game(game, moves[i]);
				if(i>0)
				{
					var value:int = newGame.getPossibleMoves().length;
					if(value<bestValue)
					{
						bestValue = value;
						bestMoves.length = 0;
						bestMoves.push(moves[i]);
					}
					else if(value==bestValue)
					{
						bestMoves.push(moves[i]);
					}
				}
				else
				{
					bestValue = newGame.getPossibleMoves().length;
					bestMoves.push(moves[i]);
				}
			}
			
			done.dispatch(bestMoves[int(Math.random()*bestMoves.length)]);
		}
	}
}