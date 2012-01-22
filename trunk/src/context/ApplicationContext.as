package context
{
	import commands.ContextCommand;
	import commands.PlayerIOServiceCommand;
	
	import components.Alert;
	import components.LobbyScreen;
	import components.LocalGameScreen;
	import components.LocalGameSettingsScreen;
	import components.NetworkGameScreen;
	import components.WelcomeScreen;
	
	import flash.display.DisplayObjectContainer;
	
	import mediators.AlertMediator;
	import mediators.LobbyScreenMediator;
	import mediators.LocalGameScreenMediator;
	import mediators.LocalGameSettingsScreenMediator;
	import mediators.NetworkGameScreenMediator;
	import mediators.WelcomeScreenMediator;
	
	import org.robotlegs.base.ContextEvent;
	import org.robotlegs.mvcs.Context;
	
	import proxies.ComputerPlayerProxy;
	import proxies.GameProxy;
	import proxies.GameProxyEvent;
	import proxies.RoomProxy;
	
	import razor.skins.Settings;
	import razor.skins.plastic.PlasticStyleSheet;
	import razor.skins.plastic.presets.Glass;
	import razor.skins.plastic.presets.Regular;
	
	import services.PlayerIOService;
	import services.PlayerIOServiceEvent;
	
	public class ApplicationContext extends Context
	{
		/**
		 * Показать экран настроек локальной игры.
		 */
		public static const DISPLAY_LOCAL_GAME_SETTINGS_SCREEN:String = "displayLocalGameSettingsScreen";
		/**
		 * Показать экран локальной игры.
		 */
		public static const DISPLAY_LOCAL_GAME_SCREEN:String = "displayLocalGameScreen";
		/**
		 * Показать экран лобби для игры через Интернет.
		 */
		public static const DISPLAY_LOBBY_SCREEN:String = "displayLobbyScreen";
		/**
		 * Показать экран игры через Интернет.
		 */
		public static const DISPLAY_NETWORK_GAME_SCREEN:String = "displayNetworkGameScreen";
		/**
		 * Отобразить окно с сообщением.
		 * body содержит String.
		 */
		public static const DISPLAY_ALERT:String = "displayAlert";
		/**
		 * Выполнить ход.
		 * body содержит Move.
		 */
		public static const DO_MOVE:String = "doMove";
		/**
		 * Подключиться.
		 * body содержит String с именем пользователя для подключения.
		 */
		public static const CONNECT:String = "connect";
		/**
		 * Подключение успешно выполнено.
		 * body содержит String с именем пользователя.
		 */
		public static const CONNECTED:String = "connected";
		/**
		 * Обновить список комнат.
		 */
		public static const REFRESH_ROOM_LIST:String = "refreshRoomList";
		/**
		 * Список комнат получен.
		 * body содержит Array с элементами RoomInfo.
		 */
		public static const ROOM_LIST_ARRIVED:String = "roomListArrived";
		/**
		 * Создать комнату.
		 * body содержит String с именем комнаты.
		 */
		public static const CREATE_ROOM:String = "createRoom";
		/**
		 * Войти в комнату.
		 * body сожержит RoomInfo.
		 */
		public static const JOIN_ROOM:String = "joinRoom";
		/**
		 * Выйти из комнаты.
		 */
		public static const LEAVE_ROOM:String = "leaveRoom";
		/**
		 * Отправить ход.
		 * body содержит Move.
		 */
		public static const SEND_MOVE:String = "sendMove";
		
		public function ApplicationContext(contextView:DisplayObjectContainer=null, autoStartup:Boolean=true)
		{
			super(contextView, autoStartup);
		}
		
		override public function startup():void
		{
			commandMap.mapEvent(DISPLAY_LOCAL_GAME_SETTINGS_SCREEN, ContextCommand, ContextEvent);
			commandMap.mapEvent(DISPLAY_LOCAL_GAME_SCREEN, ContextCommand, ContextEvent);
			commandMap.mapEvent(DO_MOVE, ContextCommand, ContextEvent);
			commandMap.mapEvent(DISPLAY_LOBBY_SCREEN, ContextCommand, ContextEvent);
			commandMap.mapEvent(CONNECT, ContextCommand, ContextEvent);
			commandMap.mapEvent(CREATE_ROOM, ContextCommand, ContextEvent);
			commandMap.mapEvent(JOIN_ROOM, ContextCommand, ContextEvent);
			commandMap.mapEvent(DISPLAY_NETWORK_GAME_SCREEN, ContextCommand, ContextEvent);
			commandMap.mapEvent(SEND_MOVE, ContextCommand, ContextEvent);
			commandMap.mapEvent(REFRESH_ROOM_LIST, ContextCommand, ContextEvent);
			commandMap.mapEvent(LEAVE_ROOM, ContextCommand, ContextEvent);
			commandMap.mapEvent(DISPLAY_ALERT, ContextCommand, ContextEvent);
			
			commandMap.mapEvent(PlayerIOServiceEvent.CONNECTED, PlayerIOServiceCommand, PlayerIOServiceEvent);
			commandMap.mapEvent(PlayerIOServiceEvent.DISCONNECTED, PlayerIOServiceCommand, PlayerIOServiceEvent);
			commandMap.mapEvent(PlayerIOServiceEvent.ERROR, PlayerIOServiceCommand, PlayerIOServiceEvent);
			commandMap.mapEvent(PlayerIOServiceEvent.MESSAGE, PlayerIOServiceCommand, PlayerIOServiceEvent);
			commandMap.mapEvent(PlayerIOServiceEvent.ROOM_JOINED, PlayerIOServiceCommand, PlayerIOServiceEvent);
			commandMap.mapEvent(PlayerIOServiceEvent.ROOM_LEFT, PlayerIOServiceCommand, PlayerIOServiceEvent);
			commandMap.mapEvent(PlayerIOServiceEvent.ROOM_LIST, PlayerIOServiceCommand, PlayerIOServiceEvent);
			
			injector.mapSingleton(GameProxy);
			injector.mapSingleton(RoomProxy);
			injector.mapSingleton(ComputerPlayerProxy);
			
			injector.mapSingleton(PlayerIOService);
			
			mediatorMap.mapView(WelcomeScreen, WelcomeScreenMediator);
			mediatorMap.mapView(LocalGameSettingsScreen, LocalGameSettingsScreenMediator);
			mediatorMap.mapView(LocalGameScreen, LocalGameScreenMediator);
			mediatorMap.mapView(LobbyScreen, LobbyScreenMediator);
			mediatorMap.mapView(NetworkGameScreen, NetworkGameScreenMediator);
			mediatorMap.mapView(Alert, AlertMediator);
			
			Settings.setSkin(new PlasticStyleSheet(), new Regular());
			contextView.addChild(new WelcomeScreen());
		}
	}
}