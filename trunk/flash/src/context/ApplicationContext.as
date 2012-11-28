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
package context
{
	import ai.GreedyStrategy;
	import ai.MinimaxStrategy;
	import ai.RandomStrategy;
	import ai.ShallowStrategy;
	import ai.SimpleStrategy;
	
	import com.google.analytics.GATracker;
	
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
	
	import mx.resources.ResourceManager;
	
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
		 * Показать экран приветствия.
		 */
		public static const DISPLAY_WELCOME_SCREEN:String = "displayWelcomeScreen";
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
		/**
		 * Отправить сообщение готовности.
		 */
		public static const SEND_READY:String = "sendReady";
		
		public function ApplicationContext(contextView:DisplayObjectContainer=null, autoStartup:Boolean=true)
		{
			super(contextView, autoStartup);
		}
		
		override public function startup():void
		{
			commandMap.mapEvent(DISPLAY_WELCOME_SCREEN, ContextCommand, ContextEvent);
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
			commandMap.mapEvent(SEND_READY, ContextCommand, ContextEvent);
			
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
			injector.mapValue(GATracker, new GATracker(contextView, ResourceManager.getInstance().getString("Config", "ga_account"), ResourceManager.getInstance().getString("Config", "ga_mode")));
			
			var computerPlayerProxy:ComputerPlayerProxy = injector.getInstance(ComputerPlayerProxy) as ComputerPlayerProxy;
			computerPlayerProxy.registerStrategy(SimpleStrategy, ResourceManager.getInstance().getString("Strings", "simple_strategy"));
			computerPlayerProxy.registerStrategy(RandomStrategy, ResourceManager.getInstance().getString("Strings", "random_strategy"));
			computerPlayerProxy.registerStrategy(GreedyStrategy, ResourceManager.getInstance().getString("Strings", "greedy_strategy"));
			computerPlayerProxy.registerStrategy(ShallowStrategy, ResourceManager.getInstance().getString("Strings", "shallow_strategy"));
			computerPlayerProxy.registerStrategy(MinimaxStrategy, ResourceManager.getInstance().getString("Strings", "minimax_strategy"));
			
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