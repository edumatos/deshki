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
	import components.LocalGameSettingsScreen;
	
	import context.ApplicationContext;
	
	import org.robotlegs.base.ContextEvent;
	import org.robotlegs.mvcs.Mediator;
	
	import proxies.ComputerPlayerProxy;
	
	public class LocalGameSettingsScreenMediator extends Mediator
	{
		[Inject]
		public var localGameSettingsScreen:LocalGameSettingsScreen;
		
		[Inject]
		public var computerPlayerProxy:ComputerPlayerProxy;
		
		override public function onRegister():void
		{
			localGameSettingsScreen.strategies = computerPlayerProxy.namesOfRegisteredStrategies;
			
			localGameSettingsScreen.startButtonClicked.add(startButtonClickedHandler);
			localGameSettingsScreen.backToWelcomeButtonClicked.add(backToWelcomeScreenButtonClickedHandler);
		}
		
		override public function onRemove():void
		{
			localGameSettingsScreen.startButtonClicked.remove(startButtonClickedHandler);
			localGameSettingsScreen.backToWelcomeButtonClicked.remove(backToWelcomeScreenButtonClickedHandler);
		}
		
		private function startButtonClickedHandler(isEvenHuman:Boolean, isOddHuman:Boolean, hideHistory:Boolean, evenStrategy:String, oddStrategy:String):void
		{
			dispatch(new ContextEvent(ApplicationContext.DISPLAY_LOCAL_GAME_SCREEN, {isEvenHuman:isEvenHuman, isOddHuman:isOddHuman, hideHistory:hideHistory, evenStrategy:evenStrategy, oddStrategy:oddStrategy}));
		}
		
		private function backToWelcomeScreenButtonClickedHandler():void
		{
			dispatch(new ContextEvent(ApplicationContext.DISPLAY_WELCOME_SCREEN));
		}
	}
}