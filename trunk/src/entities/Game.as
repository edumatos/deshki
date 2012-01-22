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
package entities
{
	/**
	 * Класс для хранения состояния игры.
	 */
	public class Game
	{
		/**
		 * Состояние ожидания. Неопределённое состояние.
		 */
		public static const WAITING:int = -1;
		/**
		 * Чётные победили.
		 */
		public static const EVEN_WON:int = 0;
		/**
		 * Нечётные победили.
		 */
		public static const ODD_WON:int = 1;
		/**
		 * Ничья.
		 */
		public static const DRAW:int = 2;
		/**
		 * Игра в процессе.
		 */
		public static const IN_PROGRESS:int = 3;
		
		private var _field:Vector.<Boolean>;
		private var _history:Vector.<int>;
		private var _state:int;
		
		/**
		 * Создаёт новый экземпляр класса.
		 * @param gameObj Если передано null, то содаётся игра в неопределённом состоянии.
		 * Если передано не null, то создаётся копия объекта gameObj.
		 * @param move Если передано не null, то выполняется попытка сделать ход.
		 * Ход выполняется, если он может быть выполнен в текущем состоянии игры.
		 */
		public function Game(gameObj:Game = null, move:Move = null)
		{
			if(gameObj==null)
			{
				_field = new Vector.<Boolean>(16, true);
				_history = new Vector.<int>();
				_state = WAITING;
			}
			else
			{
				_field = gameObj._field.concat();
				_history = gameObj._history.concat();
				_state = gameObj._state;
			}
			if(move!=null && canMove(move.x, move.y))
			{
				doMove(move.x, move.y);
			}
		}
		
		/**
		 * Состояние игры.
		 */
		public function get state():int
		{
			return _state;
		}
		
		/**
		 * Останавливает игру на текущем ходу и определяет победителя,
		 * выполнившего последний ход.
		 */
		public function stop():void
		{
			_state = (_history.length-1)%2==0 ? EVEN_WON : ODD_WON;
		}
		
		/**
		 * Переводит игру в неопределённое состояние.
		 */
		public function gotoWaitingState():void
		{
			_state = WAITING;
		}
		
		/**
		 * Последний выполненный ход в игре или null.
		 */
		public function get lastMove():Move
		{
			if(_history.length>0)
				return new Move(_history[_history.length-1]%4, _history[_history.length-1]/4);
			return null;
		}
		
		/**
		 * Номер последнего хода, начиная с нуля.
		 * Если ходов не было, то -1.
		 */
		public function get lastMoveNumber():int
		{
			return _history.length-1;
		}
		
		/**
		 * Переводит игру в начальное состояние.
		 */
		public function reset():void
		{
			for(var i:int=0; i<16; ++i)
				_field[i] = false;
			_history.length = 0;
			_state = IN_PROGRESS;
		}
		
		/**
		 * Проверяет можно ли выполнить ход.
		 * @param x Координата ячейки по горизонтали, начиная с нуля.
		 * @param y Координата ячейки по вертикали, начиная с нуля.
		 * @return true, если ход можно выполнить.
		 */
		public function canMove(x:int, y:int):Boolean
		{
			if(_state!=IN_PROGRESS || (x<0 || x>=4 || y<0 || y>=4) || _field[y*4+x])
				return false;
			if(_history.length>0)
			{
				var xor:int = _history[_history.length-1]^(y*4+x);
				if(!(xor==1 || xor==2 || xor==4 || xor==8))
					return false;
			}
			return true;
		}
		
		
		/**
		 * Возвращает возможные в текущем состоянии ходы.
		 * @return Возможные ходы.
		 */
		public function getPossibleMoves():Vector.<Move>
		{
			var moves:Vector.<Move> = new Vector.<Move>();
			var i:int, x:int, y:int;
			for(i = 0; i<16; ++i)
			{
				x = i%4;
				y = i/4;
				if(canMove(x,y))
					moves.push(new Move(x, y));
			}
			return moves;
		}
		
		/**
		 * Выполняет ход, переводя игру в другое состояние.
		 * Не проверяет можно ли выполнить ход.
		 * @param x Координата ячейки по горизонтали, начиная с нуля.
		 * @param y Координата ячейки по вертикали, начиная с нуля.
		 */
		public function doMove(x:int, y:int):void
		{
			_field[y*4+x] = true;
			_history.push(y*4+x);
			
			if(_history.length==16)
			{
				_state = DRAW;
			}
			else if(!canMove(x-2, y) &&
				!canMove(x-1, y) &&
				!canMove(x+1, y) &&
				!canMove(x+2, y) &&
				!canMove(x, y-2) &&
				!canMove(x, y-1) &&
				!canMove(x, y+1) &&
				!canMove(x, y+2))
			{
				_state = (_history.length-1)%2==0 ? EVEN_WON : ODD_WON;
			}
		}
	}
}