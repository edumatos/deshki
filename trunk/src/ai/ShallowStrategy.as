package ai
{
	import entities.Game;
	import entities.Move;
	
	import flash.utils.setTimeout;

	public class ShallowStrategy extends AbstractStrategy
	{
		override public function doMove(game:Game):void
		{
			setTimeout(delayedHandler, 500, game);
		}
		
		private function delayedHandler(game:Game):void
		{
			var moves:Vector.<Move> = game.getPossibleMoves();
			var games:Vector.<Game> = new Vector.<Game>(moves.length, true);
			var bestMoves:Vector.<Move> = new Vector.<Move>();
			var i:int, j:int;
			
			// если можно победить одним ходом, то сделать это
			for(i=0; i<moves.length; ++i)
			{
				games[i] = new Game(game, moves[i]);
				if(games[i].state==Game.EVEN_WON || games[i].state==Game.ODD_WON)
				{
					bestMoves.push(moves[i]);
				}
			}
			if(bestMoves.length>0)
			{
				done.dispatch(bestMoves[int(Math.random()*bestMoves.length)]);
				return;
			}
			
			// избегать ходов, которые дают сопернику возможность победить одним ходом
			bestMoves.length = 0;
			var moves2:Vector.<Move>;
			var game2:Game;
			var found:Boolean;
			for(i=0; i<moves.length; ++i)
			{
				moves2 = games[i].getPossibleMoves();
				found = false;
				for(j=0; j<moves2.length; ++j)
				{
					game2 = new Game(games[i], moves2[j]);
					if(game2.state==Game.EVEN_WON || game2.state==Game.ODD_WON)
					{
						found = true;
						break;
					}
				}
				if(!found)
				{
					bestMoves.push(moves[i]);
				}
			}
			if(bestMoves.length>0)
			{
				done.dispatch(bestMoves[int(Math.random()*bestMoves.length)]);
				return;
			}
			
			// случайный ход (скорее всего означает проигрыш на следующем ходу)
			done.dispatch(moves[int(Math.random()*moves.length)]);
		}
	}
}