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
package
{
	import context.ApplicationContext;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.system.Capabilities;
	
	import mx.resources.IResourceManager;
	import mx.resources.ResourceManager;
	
	import razor.skins.Settings;
	import razor.skins.plastic.PlasticStyleSheet;
	
	[SWF(width="600", height="400")]
	[ResourceBundle("Strings")]
	[ResourceBundle("Config")]
	public class Deshki extends Sprite
	{
		private var _context:ApplicationContext;
		
		public function Deshki()
		{
			if(stage==null)
			{
				addEventListener(Event.ADDED_TO_STAGE, init);
			}
			else
			{
				init();
			}
		}
		
		private function init(e:Event = null):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			// Вызываем здесь эту строку, чтобы в менеджере ресурсов установился флаг initializedForNonFrameworkApp
			ResourceManager.getInstance().getString("Strings", "deshki");
			
			if (Capabilities.language=="ru")
				ResourceManager.getInstance().localeChain = ['ru_RU'];   
			else
				ResourceManager.getInstance().localeChain = ['en_US'];
			
			_context = new ApplicationContext(this);
		}
	}
}