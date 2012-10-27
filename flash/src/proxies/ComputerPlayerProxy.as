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
	import ai.ComputerPlayer;
	
	import entities.Game;
	import entities.Move;
	
	import flash.utils.Dictionary;
	
	import org.robotlegs.mvcs.Actor;
	
	public class ComputerPlayerProxy extends Actor
	{
		private var _evenComputerPlayer:ComputerPlayer;
		private var _oddComputerPlayer:ComputerPlayer;
		private var _strategies:Dictionary;
		
		public function ComputerPlayerProxy()
		{
			_evenComputerPlayer = new ComputerPlayer();
			_evenComputerPlayer.done.add(doneHandler);
			
			_oddComputerPlayer = new ComputerPlayer();
			_oddComputerPlayer.done.add(doneHandler);
			
			_strategies = new Dictionary();
		}
		
		public function registerStrategy(strategyClass:Class, name:String):void
		{
			_strategies[name] = strategyClass;
		}
		
		public function get namesOfRegisteredStrategies():Array
		{
			var names:Array = new Array();
			for(var name:String in _strategies)
			{
				names.push(name);
			}
			return names;
		}
		
		public function set evenStrategy(value:String):void
		{
			_evenComputerPlayer.strategy = new (_strategies[value] as Class)();
		}
		
		public function set oddStrategy(value:String):void
		{
			_oddComputerPlayer.strategy = new (_strategies[value] as Class)();
		}
		
		public function evenDoMove(game:Game):void
		{
			_evenComputerPlayer.doMove(game);
		}
		
		public function oddDoMove(game:Game):void
		{
			_oddComputerPlayer.doMove(game);
		}
		
		private function doneHandler(move:Move):void
		{
			dispatch(new ComputerPlayerProxyEvent(ComputerPlayerProxyEvent.DONE, move));
		}
	}
}