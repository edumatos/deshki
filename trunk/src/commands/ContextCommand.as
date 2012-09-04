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
package commands
{
	import components.Alert;
	import components.LobbyScreen;
	import components.LocalGameScreen;
	import components.LocalGameSettingsScreen;
	import components.NetworkGameScreen;
	import components.WelcomeScreen;
	
	import context.ApplicationContext;
	
	import entities.Move;
	
	import org.robotlegs.base.ContextEvent;
	import org.robotlegs.mvcs.Command;
	
	import playerio.RoomInfo;
	
	import proxies.GameProxy;
	
	import razor.controls.Application;
	
	import services.PlayerIOService;
	
	public class ContextCommand extends Command
	{
		[Inject]
		public var event:ContextEvent;
		
		override public function execute():void
		{
			switch(event.type)
			{
				case ApplicationContext.DISPLAY_WELCOME_SCREEN:
					handleDisplayWelcomeScreen();
					break;
				
				case ApplicationContext.DISPLAY_LOCAL_GAME_SETTINGS_SCREEN:
					handleDisplayLocalGameSettingsScreen();
					break;
				
				case ApplicationContext.DISPLAY_LOCAL_GAME_SCREEN:
					handleDisplayLocalGameScreen();
					break;
				
				case ApplicationContext.DO_MOVE:
					handleDoMove();
					break;
				
				case ApplicationContext.DISPLAY_LOBBY_SCREEN:
					handleDisplayLobbyScreen();
					break;
				
				case ApplicationContext.CONNECT:
					handleConnect();
					break;
				
				case ApplicationContext.CREATE_ROOM:
					handleCreateRoom();
					break;
				
				case ApplicationContext.JOIN_ROOM:
					handleJoinRoom();
					break;
				
				case ApplicationContext.DISPLAY_NETWORK_GAME_SCREEN:
					handleDisplayNetworkGameScreen();
					break;
				
				case ApplicationContext.SEND_MOVE:
					handleSendMove();
					break;
				
				case ApplicationContext.REFRESH_ROOM_LIST:
					handleRefreshRoomList();
					break;
				
				case ApplicationContext.LEAVE_ROOM:
					handleLeaveRoom();
					break;
				
				case ApplicationContext.DISPLAY_ALERT:
					handleDisplayAlert();
					break;
			}
		}
		
		private function handleDisplayWelcomeScreen():void
		{
			contextView.removeChildAt(0);
			contextView.addChildAt(new WelcomeScreen(), 0);
		}
		
		private function handleDisplayLocalGameSettingsScreen():void
		{
			contextView.removeChildAt(0);
			contextView.addChildAt(new LocalGameSettingsScreen(), 0);
		}
		
		private function handleDisplayLocalGameScreen():void
		{
			contextView.removeChildAt(0);
			contextView.addChildAt(new LocalGameScreen(), 0);
			
			var gameProxy:GameProxy = injector.getInstance(GameProxy) as GameProxy;
			var even:int = (event.body.isEvenHuman as Boolean) ? GameProxy.HUMAN : GameProxy.COMPUTER;
			var odd:int = (event.body.isOddHuman as Boolean) ? GameProxy.HUMAN : GameProxy.COMPUTER;
			gameProxy.reset(event.body.hideHistory as Boolean, even, odd, 5*60*1000);
		}
		
		private function handleDoMove():void
		{
			var gameProxy:GameProxy = injector.getInstance(GameProxy) as GameProxy;
			var move:Move = event.body as Move;
			gameProxy.doMove(move.x, move.y);
		}
		
		private function handleDisplayLobbyScreen():void
		{
			contextView.removeChildAt(0);
			contextView.addChildAt(new LobbyScreen(),0);
			
			var playerIOService:PlayerIOService = injector.getInstance(PlayerIOService) as PlayerIOService;
			if(playerIOService.isConnected)
			{
				dispatch(new ContextEvent(ApplicationContext.CONNECTED, playerIOService.userId));
			}
		}
		
		private function handleConnect():void
		{
			var playerIOService:PlayerIOService = injector.getInstance(PlayerIOService) as PlayerIOService;
			playerIOService.connect(contextView.stage, "deshki-v1lncpcgrk2w6zgwsc0duw", "public", event.body as String, "");
		}
		
		private function handleCreateRoom():void
		{
			var playerIOService:PlayerIOService = injector.getInstance(PlayerIOService) as PlayerIOService;
			playerIOService.createAndJoinRoom(event.body.name as String, "Deshki", true, {hideHistory:event.body.hideHistory as Boolean}, null);
		}
		
		private function handleJoinRoom():void
		{
			var playerIOService:PlayerIOService = injector.getInstance(PlayerIOService) as PlayerIOService;
			playerIOService.joinRoom(event.body as RoomInfo, null);
		}
		
		private function handleDisplayNetworkGameScreen():void
		{
			contextView.removeChildAt(0);
			contextView.addChildAt(new NetworkGameScreen(),0);
		}
		
		private function handleSendMove():void
		{
			var playerIOService:PlayerIOService = injector.getInstance(PlayerIOService) as PlayerIOService;
			var move:Move = event.body as Move;
			playerIOService.send("Move", move.x, move.y);
		}
		
		private function handleRefreshRoomList():void
		{
			var playerIOService:PlayerIOService = injector.getInstance(PlayerIOService) as PlayerIOService;
			playerIOService.listRooms("Deshki", {}, 50, 0);
		}
		
		private function handleLeaveRoom():void
		{
			var playerIOService:PlayerIOService = injector.getInstance(PlayerIOService) as PlayerIOService;
			playerIOService.leaveRoom();
		}
		
		private function handleDisplayAlert():void
		{
			var alert:Alert = new Alert();
			alert.message = event.body as String;
			contextView.addChild(alert);
		}
	}
}