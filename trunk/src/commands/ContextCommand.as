package commands
{
	import components.Alert;
	import components.LobbyScreen;
	import components.LocalGameScreen;
	import components.LocalGameSettingsScreen;
	import components.NetworkGameScreen;
	
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
			gameProxy.reset(even, odd, 5*60*1000);
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
			playerIOService.createAndJoinRoom(event.body as String, "Deshki", true, null, null);
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