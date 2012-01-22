package mediators
{
	import components.WelcomeScreen;
	
	import context.ApplicationContext;
	
	import org.robotlegs.base.ContextEvent;
	import org.robotlegs.mvcs.Mediator;
	
	public class WelcomeScreenMediator extends Mediator
	{
		[Inject]
		public var welcomeScreen:WelcomeScreen;
		
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
			dispatch(new ContextEvent(ApplicationContext.DISPLAY_LOCAL_GAME_SETTINGS_SCREEN));
		}
		
		private function playNetworkButtonClickedHandler():void
		{
			dispatch(new ContextEvent(ApplicationContext.DISPLAY_LOBBY_SCREEN));
		}
	}
}