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
package deshki;

import java.util.Vector;


public class Game
{
	private boolean[] _field;
	private int _lastMove;
	private int _lastMoveNumber;
	private GameState _state;
	
	public Game(Game game, Move move)
	{
		if(game==null)
		{
			_field = new boolean[16];
			_lastMove = -1;
			_lastMoveNumber = -1;
			_state = GameState.IN_PROGRESS;
		}
		else
		{
			_field = game._field.clone();
			_lastMove = game._lastMove;
			_lastMoveNumber = game._lastMoveNumber;
			_state = game._state;
		}
		if(move!=null && canMove(move.x, move.y))
		{
			doMove(move.x, move.y);
		}
	}
	
	public GameState getState()
	{
		return _state;
	}
	
	public int getLastMoveNumber()
	{
		return _lastMoveNumber;
	}
	
	public boolean canMove(int x, int y)
	{
		if(_state!=GameState.IN_PROGRESS || (x<0 || x>=4 || y<0 || y>=4) || _field[y*4+x])
			return false;
		if(_lastMoveNumber>=0)
		{
			int xor = _lastMove^(y*4+x);
			if(!(xor==1 || xor==2 || xor==4 || xor==8))
				return false;
		}
		return true;
	}
	
	public void doMove(int x, int y)
	{
		_field[y*4+x] = true;
		_lastMove = y*4+x;
		++_lastMoveNumber;
		
		if(_lastMoveNumber==15)
		{
			_state = GameState.DRAW;
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
			_state = _lastMoveNumber%2==0 ? GameState.EVEN_WON : GameState.ODD_WON;
		}
	}
	
	public Vector<Move> getPossibleMoves()
	{
		Vector<Move> moves = new Vector<Move>();
		int i, x, y;
		for(i = 0; i<16; ++i)
		{
			x = i%4;
			y = i/4;
			if(canMove(x,y))
				moves.add(new Move(x, y));
		}
		return moves;
	}
	
	public byte[] toBytes()
	{
		byte[] bytes = new byte[3];
		bytes[2] = (byte) _lastMove;
		for(int i=0; i<16; ++i)
		{
			bytes[1-i/8] |= (_field[i] ? 1 : 0) << (i%8);
		}
		return bytes;
	}
	
	public void fromBytes(byte[] bytes)
	{
		_lastMove = bytes[2];
		_lastMoveNumber = -1;
		for(int i=0; i<16; ++i)
		{
			_field[i] = ((bytes[1-i/8] >> (i%8)) & 1) > 0;
			if(_field[i])
				++_lastMoveNumber;
		}
		_state = GameState.IN_PROGRESS;
		if(_lastMoveNumber<0)
			return;
		int x = _lastMove%4, y = _lastMove/4;
		if(_lastMoveNumber==15)
		{
			_state = GameState.DRAW;
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
			_state = _lastMoveNumber%2==0 ? GameState.EVEN_WON : GameState.ODD_WON;
		}
	}
}
