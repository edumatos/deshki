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
	import components.NetworkGameScreen;
	
	import context.ApplicationContext;
	
	import entities.Game;
	import entities.Move;
	import entities.User;
	
	import flash.events.Event;
	
	import mx.resources.ResourceManager;
	
	import org.robotlegs.base.ContextEvent;
	import org.robotlegs.mvcs.Mediator;
	
	import proxies.GameProxy;
	import proxies.GameProxyEvent;
	import proxies.RoomProxy;
	import proxies.RoomProxyEvent;
	
	public class NetworkGameScreenMediator extends Mediator
	{
		[Inject]
		public var networkGameScreen:NetworkGameScreen;
		
		[Inject]
		public var gameProxy:GameProxy;
		
		[Inject]
		public var roomProxy:RoomProxy;
		
		override public function onRegister():void
		{
			networkGameScreen.gameField.cellClicked.add(cellClickedHandler);
			networkGameScreen.exitButtonClicked.add(exitButtonClickedHandler);
			
			networkGameScreen.addEventListener(Event.ENTER_FRAME, updateTimers);
			
			eventMap.mapListener(eventDispatcher, GameProxyEvent.UPDATED, gameProxyUpdated, GameProxyEvent);
			eventMap.mapListener(eventDispatcher, RoomProxyEvent.USER_ROLES_CHANGED, userRolesChangedHandler, RoomProxyEvent);
			eventMap.mapListener(eventDispatcher, RoomProxyEvent.USER_LEFT, userLeftHandler, RoomProxyEvent);
			
			networkGameScreen.stateLabelText = ResourceManager.getInstance().getString("Strings", "wait_opponent");
		}
		
		override public function onRemove():void
		{
			networkGameScreen.gameField.cellClicked.remove(cellClickedHandler);
			networkGameScreen.exitButtonClicked.remove(exitButtonClickedHandler);
			
			networkGameScreen.removeEventListener(Event.ENTER_FRAME, updateTimers);
		}
		
		private function cellClickedHandler(x:int, y:int):void
		{
			if(gameProxy.current==GameProxy.HUMAN)
			{
				dispatch(new ContextEvent(ApplicationContext.SEND_MOVE, new Move(x, y)));
			}
		}
		
		private function exitButtonClickedHandler():void
		{
			dispatch(new ContextEvent(ApplicationContext.LEAVE_ROOM));
		}
		
		private function updateTimers(e:Event):void
		{
			networkGameScreen.setTimers(gameProxy.evenTime, gameProxy.oddTime);
		}
		
		private function userRolesChangedHandler(e:RoomProxyEvent):void
		{
			networkGameScreen.evenName = roomProxy.getUserById(roomProxy.evenUserId).name;
			networkGameScreen.oddName = roomProxy.getUserById(roomProxy.oddUserId).name;
			networkGameScreen.setTimers(0,0);
		}
		
		private function userLeftHandler(e:RoomProxyEvent):void
		{
			var id:int = (e.body as User).id;
			if(id==roomProxy.evenUserId)
			{
				networkGameScreen.evenName = "";
			}
			else if(id==roomProxy.oddUserId)
			{
				networkGameScreen.oddName = "";
			}
		}
		
		private function gameProxyUpdated(e:GameProxyEvent):void
		{
			if(!e.stateOnly)
			{
				var lastMove:Move = gameProxy.lastMove;
				if(lastMove==null)
				{
					networkGameScreen.gameField.clearNumbers();
				}
				else
				{
					if(gameProxy.hideHistory)
						networkGameScreen.gameField.hideNumbers();
					networkGameScreen.gameField.setCell(lastMove.x, lastMove.y, String(gameProxy.lastMoveNumber));
				}
			}
			networkGameScreen.gameField.clearSelections();
			if(gameProxy.state == Game.IN_PROGRESS)
			{
				if(gameProxy.current==GameProxy.HUMAN)
				{
					networkGameScreen.stateLabelText = ResourceManager.getInstance().getString("Strings", "your_turn");
					var moves:Vector.<Move> = gameProxy.getPossibleMoves();
					for(var i:int=0; i<moves.length; ++i)
						networkGameScreen.gameField.setSelection(moves[i].x, moves[i].y);
				}
				else
				{
					networkGameScreen.stateLabelText = ResourceManager.getInstance().getString("Strings", "opponent_turn");
				}
			}
			else if(gameProxy.state == Game.EVEN_WON || gameProxy.state == Game.ODD_WON)
			{
				if(gameProxy.hideHistory)
					networkGameScreen.gameField.showNumbers();
				
				if((gameProxy.state == Game.EVEN_WON && roomProxy.myUserId==roomProxy.evenUserId) || (gameProxy.state == Game.ODD_WON && roomProxy.myUserId==roomProxy.oddUserId))
				{
					networkGameScreen.stateLabelText = ResourceManager.getInstance().getString("Strings", "you_won");
				}
				else
				{
					networkGameScreen.stateLabelText = ResourceManager.getInstance().getString("Strings", "you_lost");
				}
			}
			else if(gameProxy.state == Game.DRAW)
			{
				if(gameProxy.hideHistory)
					networkGameScreen.gameField.showNumbers();
				
				networkGameScreen.stateLabelText = ResourceManager.getInstance().getString("Strings", "draw");
			}
			else if(gameProxy.state == Game.WAITING)
			{
				networkGameScreen.stateLabelText = ResourceManager.getInstance().getString("Strings", "wait_opponent");
			}
		}
	}
}