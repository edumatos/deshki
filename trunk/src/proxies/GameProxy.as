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
	import entities.Game;
	import entities.Move;
	
	import flash.utils.getTimer;
	
	import org.robotlegs.mvcs.Actor;
	
	public class GameProxy extends Actor
	{
		private var _game:Game;
		
		/**
		 * Ожидается ход человека.
		 */
		public static const HUMAN:int = 0;
		/**
		 * Ожидается ход компьютера.
		 */
		public static const COMPUTER:int = 1;
		/**
		 * Ожидается ход сервера.
		 */
		public static const NETWORK:int = 2;
		
		private var _even:int;
		private var _odd:int;
		private var _current:int;
		
		private var _totalTime:int;
		private var _time:int;
		private var _evenTime:int;
		private var _oddTime:int;
		
		private var _hideHistory:Boolean;
		
		public function GameProxy()
		{
			_game = new Game();
		}
		
		public function get game():Game
		{
			return _game;
		}
		
		/**
		 * От кого ожидается ход.
		 */
		public function get current():int
		{
			return _current;
		}
		
		public function get state():int
		{
			return _game.state;
		}
		
		public function stop():void
		{
			_game.stop();
			dispatch(new GameProxyEvent(GameProxyEvent.UPDATED, true));
		}
		
		public function gotoWaitingState():void
		{
			_game.gotoWaitingState();
			dispatch(new GameProxyEvent(GameProxyEvent.UPDATED, true));
		}
		
		public function get lastMove():Move
		{
			return _game.lastMove;
		}
		
		public function get lastMoveNumber():int
		{
			return _game.lastMoveNumber;
		}
		
		public function get hideHistory():Boolean
		{
			return _hideHistory;
		}
		
		/**
		 * @param even От кого ожидают ход чётные.
		 * @param odd От кого ожидают ход нечётные.
		 */
		public function reset(hideHistory:Boolean, even:int, odd:int, totalTime:int):void
		{
			_game.reset();
			_hideHistory = hideHistory;
			_even = even;
			_odd = odd;
			_current = _even;
			_totalTime = totalTime;
			_time = getTimer();
			_evenTime = 0;
			_oddTime = 0;
			dispatch(new GameProxyEvent(GameProxyEvent.UPDATED));
		}
		
		public function getPossibleMoves():Vector.<Move>
		{
			return _game.getPossibleMoves(_current==HUMAN && _hideHistory);
		}
		
		public function get evenTime():Number
		{
			if(_game.state==Game.WAITING)
				return 0.0;
			var t:Number;
			if(_game.state==Game.IN_PROGRESS && (_game.lastMoveNumber+1)%2==0)
				t = (_evenTime+getTimer()-_time)/_totalTime;
			else
				t = _evenTime/_totalTime;
			if(t<0.0)
				return 0.0;
			else if(t>1.0)
				return 1.0;
			return t;
		}
		
		public function get oddTime():Number
		{
			if(_game.state==Game.WAITING)
				return 0.0;
			var t:Number;
			if(_game.state==Game.IN_PROGRESS && (_game.lastMoveNumber+1)%2==1)
				t = (_oddTime+getTimer()-_time)/_totalTime;
			else
				t = _oddTime/_totalTime;
			if(t<0.0)
				return 0.0;
			else if(t>1.0)
				return 1.0;
			return t;
		}
		
		public function doMove(x:int, y:int):void
		{
			if(_game.canMove(x,y,_hideHistory))
			{
				_game.doMove(x,y);
				
				var t:int = getTimer();
				if(_game.lastMoveNumber%2==0)
					_evenTime += t-_time;
				else
					_oddTime += t-_time;
				_time = t;
				
				
				_current = (_current==_even ? _odd : _even);
				dispatch(new GameProxyEvent(GameProxyEvent.UPDATED));
			}
		}
		
		public function formatLastMove():String
		{
			var move:Move = _game.lastMove;
			var number:int = (move.y*4+move.x);
			return _game.lastMoveNumber+". "+number.toString(10)+" ("+("0000"+number.toString(2)).substr(-4)+")";
		}
	}
}