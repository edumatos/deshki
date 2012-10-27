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
package ai
{
	import entities.Game;
	import entities.Move;
	
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	
	import mx.resources.ResourceManager;

	/**
	 * Стратегия минимакса на полном дереве игры.
	 */
	public class MinimaxStrategy extends AbstractStrategy
	{
		private var _loader:URLLoader;
		private var _url:String = ResourceManager.getInstance().getString("Config", "minimax_move_url");
		
		/*private var _loader2:URLLoader;
		private var _url2:String = "http://localhost/deshki/move2.php";
		private var _game:Game;*/
		
		public function MinimaxStrategy()
		{
			_loader = new URLLoader();
			_loader.addEventListener(Event.COMPLETE, loaderCompleteHandler);
			_loader.dataFormat = URLLoaderDataFormat.BINARY;
			
			/*_loader2 = new URLLoader();
			_loader2.addEventListener(Event.COMPLETE, loaderCompleteHandler2);
			_loader2.dataFormat = URLLoaderDataFormat.BINARY;*/
		}
		
		override public function doMove(game:Game):void
		{
			var request:URLRequest = new URLRequest();
			request.url = _url;
			request.method = URLRequestMethod.POST;
			request.contentType = "application/octet-stream";
			request.data = game.toByteArray();
			_loader.load(request);
			
			/*_game = game;*/
		}
		
		private function loaderCompleteHandler(e:Event):void
		{
			var result:ByteArray = _loader.data as ByteArray;
			if(result.length==3)
			{
				var move:int = result[2];
				done.dispatch(new Move(move%4, move/4));
				
				/*var request2:URLRequest = new URLRequest();
				request2.url = _url2;
				request2.method = URLRequestMethod.POST;
				request2.contentType = "application/octet-stream";
				_game = new Game(_game, new Move(move%4, move/4));
				request2.data = _game.toByteArray();
				_loader2.load(request2);*/
			}
		}
		
		/*private function loaderCompleteHandler2(e:Event):void
		{
			trace(_loader2.data);
		}*/
	}
}