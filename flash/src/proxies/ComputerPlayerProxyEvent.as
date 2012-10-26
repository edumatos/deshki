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