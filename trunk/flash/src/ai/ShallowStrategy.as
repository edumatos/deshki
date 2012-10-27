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
package ai
{
	import entities.Game;
	import entities.Move;
	
	import flash.utils.setTimeout;

	/**
	 * Поверхностная стратегия.
	 * Алгоритм такой:
	 * 1. Если можно победить одним ходом, то сделать это.
	 * 2. Если таких ходов нет, то избегать ходов, которые дают сопернику возможность победить одним ходом.
	 * 3. Если ходов не нашлось, то сделать случайный ход.
	 */
	public class ShallowStrategy extends AbstractStrategy
	{
		override public function doMove(game:Game):void
		{
			setTimeout(delayedHandler, 250, game);
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