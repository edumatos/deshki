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
package proxies
{
	import ai.AbstractStrategy;
	import ai.ComputerPlayer;
	import ai.FullTreeMinimaxStrategy;
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
			_computerPlayer.strategy = new FullTreeMinimaxStrategy();
			/*switch(int(Math.random()*4.0))
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
			}*/
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