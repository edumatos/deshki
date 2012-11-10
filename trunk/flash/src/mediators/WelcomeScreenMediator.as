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
	
	import components.WelcomeScreen;
	
	import context.ApplicationContext;
	
	import org.robotlegs.base.ContextEvent;
	import org.robotlegs.mvcs.Mediator;
	
	public class WelcomeScreenMediator extends Mediator
	{
		[Inject]
		public var welcomeScreen:WelcomeScreen;
		
		[Inject]
		public var tracker:GATracker;
		
		override public function onRegister():void
		{
			welcomeScreen.playLocallyButtonClicked.add(playLocallyButtonClickedHandler);
			welcomeScreen.playNetworkButtonClicked.add(playNetworkButtonClickedHandler);
		}
		
		override public function onRemove():void
		{
			welcomeScreen.playLocallyButtonClicked.remove(playLocallyButtonClickedHandler);
			welcomeScreen.playNetworkButtonClicked.remove(playNetworkButtonClickedHandler);
		}
		
		private function playLocallyButtonClickedHandler():void
		{
			tracker.trackEvent("Welcome Screen", "Click", "Play Locally");
			dispatch(new ContextEvent(ApplicationContext.DISPLAY_LOCAL_GAME_SETTINGS_SCREEN));
		}
		
		private function playNetworkButtonClickedHandler():void
		{
			tracker.trackEvent("Welcome Screen", "Click", "Play via Internet");
			dispatch(new ContextEvent(ApplicationContext.DISPLAY_LOBBY_SCREEN));
		}
	}
}