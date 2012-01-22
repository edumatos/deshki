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
package components
{
	import playerio.RoomInfo;
	
	import razor.controls.grid.SelectableCell;
	
	public class RoomInfoCell extends SelectableCell
	{
		override public function get label():String
		{
			var roomInfo:RoomInfo = dP as RoomInfo;
			return roomInfo.id + " (" + roomInfo.onlineUsers + ")";
		}
	}
}