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
package mediators
{
	import components.LocalGameScreen;
	
	import context.ApplicationContext;
	
	import entities.Game;
	import entities.Move;
	
	import org.robotlegs.base.ContextEvent;
	import org.robotlegs.mvcs.Mediator;
	
	import proxies.ComputerPlayerProxy;
	import proxies.ComputerPlayerProxyEvent;
	import proxies.GameProxy;
	import proxies.GameProxyEvent;
	
	public class LocalGameScreenMediator extends Mediator
	{
		[Inject]
		public var localGameScreen:LocalGameScreen;
		
		[Inject]
		public var gameProxy:GameProxy;
		
		[Inject]
		public var computerPlayerProxy:ComputerPlayerProxy;
		
		override public function onRegister():void
		{
			localGameScreen.gameField.cellClicked.add(cellClickedHandler);
			localGameScreen.restartButtonClicked.add(restartButtonClickedHandler);
			
			eventMap.mapListener(eventDispatcher, GameProxyEvent.UPDATED, gameProxyUpdated, GameProxyEvent);
			eventMap.mapListener(eventDispatcher, ComputerPlayerProxyEvent.DONE, computerPlayerHandler, ComputerPlayerProxyEvent);
		}	
					
		override public function onRemove():void
		{
			localGameScreen.gameField.cellClicked.remove(cellClickedHandler);
			localGameScreen.restartButtonClicked.remove(restartButtonClickedHandler);
		}
		
		private function cellClickedHandler(x:int, y:int):void
		{
			if(gameProxy.current == GameProxy.HUMAN)
			{
				dispatch(new ContextEvent(ApplicationContext.DO_MOVE, new Move(x, y)));
			}
		}
		
		private function restartButtonClickedHandler():void
		{
			dispatch(new ContextEvent(ApplicationContext.DISPLAY_LOCAL_GAME_SETTINGS_SCREEN));
		}
		
		private function gameProxyUpdated(e:GameProxyEvent):void
		{
			var lastMove:Move = gameProxy.lastMove;
			if(lastMove==null)
			{
				computerPlayerProxy.pickRandomStrategy();
				localGameScreen.gameField.clearNumbers();
			}
			else
			{
				localGameScreen.gameField.setNumber(lastMove.x, lastMove.y, gameProxy.lastMoveNumber);
			}
			localGameScreen.gameField.clearSelections();
			if(gameProxy.state == Game.IN_PROGRESS)
			{
				localGameScreen.stateLabelText = ((gameProxy.lastMoveNumber+1)%2==0 ? "Ход чётных" : "Ход нечётных");
				var moves:Vector.<Move> = gameProxy.getPossibleMoves();
				if(gameProxy.current == GameProxy.HUMAN)
				{
					for(var i:int=0; i<moves.length; ++i)
						localGameScreen.gameField.setSelection(moves[i].x, moves[i].y);
				}
				else if(gameProxy.current == GameProxy.COMPUTER)
				{
					computerPlayerProxy.doMove(gameProxy.game);
				}
			}
			else if(gameProxy.state == Game.EVEN_WON)
			{
				localGameScreen.stateLabelText = "Победа чётных!";
			}
			else if(gameProxy.state == Game.ODD_WON)
			{
				localGameScreen.stateLabelText = "Победа нечётных!";
			}
			else if(gameProxy.state == Game.DRAW)
			{
				localGameScreen.stateLabelText = "Ничья!";
			}
		}
		
		private function computerPlayerHandler(e:ComputerPlayerProxyEvent):void
		{
			dispatch(new ContextEvent(ApplicationContext.DO_MOVE, e.move));
		}
	}
}