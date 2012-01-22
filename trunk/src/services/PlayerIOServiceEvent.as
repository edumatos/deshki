package services
{
	import flash.events.Event;
	
	public class PlayerIOServiceEvent extends Event
	{
		/**
		 * Соединение с сервером успешно установлено.
		 * body содержит String c идентификатором пользователя.
		 */
		public static const CONNECTED:String = "connected";
		
		/**
		 * Произошла ошибка.
		 * body содержит String с описанием ошибки.
		 */
		public static const ERROR:String = "error";
		
		/**
		 * Соединение с комнатой потеряно.
		 */
		public static const DISCONNECTED:String = "disconnected";
		
		/**
		 * Список комнат успешно получен.
		 * body содержит Array из элементов типа RoomInfo.
		 */
		public static const ROOM_LIST:String = "roomList";
		
		/**
		 * Вход в комнату успешно выполнен.
		 * body содержит String с типом комнаты.
		 */
		public static const ROOM_JOINED:String = "roomJoined";
		
		/**
		 * Выход из комнаты успешно выполнен.
		 */
		public static const ROOM_LEFT:String = "roomLeft";
		
		/**
		 * Сообщение от сервера успешно пришло.
		 * body содержит Message.
		 */
		public static const MESSAGE:String = "message";
		
		private var _body:Object;
		
		public function PlayerIOServiceEvent(type:String, body:Object = null)
		{
			super(type);
			_body = body;
		}
		
		public function get body():Object
		{
			return _body;
		}
		
		override public function clone():Event
		{
			return new PlayerIOServiceEvent(type, body);
		}
	}
}