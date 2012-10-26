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