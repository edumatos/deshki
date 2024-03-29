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
	import com.google.analytics.GATracker;
	
	import components.LocalGameScreen;
	
	import context.ApplicationContext;
	
	import entities.Game;
	import entities.Move;
	
	import mx.resources.ResourceManager;
	
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
		
		[Inject]
		public var tracker:GATracker;
		
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
			localGameScreen.gameField.clearSelections();
			if(lastMove==null)
			{
				localGameScreen.gameField.clearNumbers();
			}
			else
			{
				if(gameProxy.hideHistory)
				{
					localGameScreen.gameField.hideNumbers();
					localGameScreen.historyVisible = false;
				}
				localGameScreen.appendToHistory(gameProxy.formatLastMove());
				localGameScreen.gameField.setCell(lastMove.x, lastMove.y, String(gameProxy.lastMoveNumber));
				localGameScreen.gameField.setSelection(lastMove.x, lastMove.y, true);
			}
			if(gameProxy.state == Game.IN_PROGRESS)
			{
				localGameScreen.stateLabelText = ((gameProxy.lastMoveNumber+1)%2==0 ? ResourceManager.getInstance().getString("Strings", "even_turn") : ResourceManager.getInstance().getString("Strings", "odd_turn"));
				if(gameProxy.current == GameProxy.HUMAN)
				{
					var moves:Vector.<Move> = gameProxy.getPossibleMoves();
					for(var i:int=0; i<moves.length; ++i)
						localGameScreen.gameField.setSelection(moves[i].x, moves[i].y);
				}
				else if(gameProxy.current == GameProxy.COMPUTER)
				{
					if((gameProxy.lastMoveNumber+1)%2==0)
						computerPlayerProxy.evenDoMove(gameProxy.game);
					else
						computerPlayerProxy.oddDoMove(gameProxy.game);
				}
			}
			else if(gameProxy.state == Game.EVEN_WON)
			{
				if(gameProxy.hideHistory)
				{
					localGameScreen.gameField.showNumbers();
					localGameScreen.historyVisible = true;
				}
				
				localGameScreen.stateLabelText = ResourceManager.getInstance().getString("Strings", "even_won");
				
				tracker.trackEvent("Local Game Screen", "Game Played", "Even Won");
			}
			else if(gameProxy.state == Game.ODD_WON)
			{
				if(gameProxy.hideHistory)
				{
					localGameScreen.gameField.showNumbers();
					localGameScreen.historyVisible = true;
				}
				
				localGameScreen.stateLabelText = ResourceManager.getInstance().getString("Strings", "odd_won");
				
				tracker.trackEvent("Local Game Screen", "Game Played", "Odd Won");
			}
			else if(gameProxy.state == Game.DRAW)
			{
				if(gameProxy.hideHistory)
				{
					localGameScreen.gameField.showNumbers();
					localGameScreen.historyVisible = true;
				}
				
				localGameScreen.stateLabelText = ResourceManager.getInstance().getString("Strings", "draw");
				
				tracker.trackEvent("Local Game Screen", "Game Played", "Draw");
			}
		}
		
		private function computerPlayerHandler(e:ComputerPlayerProxyEvent):void
		{
			dispatch(new ContextEvent(ApplicationContext.DO_MOVE, e.move));
		}
	}
}