package mediators
{
	import components.LocalGameSettingsScreen;
	
	import org.robotlegs.base.ContextEvent;
	import org.robotlegs.mvcs.Mediator;
	import context.ApplicationContext;
	
	public class LocalGameSettingsScreenMediator extends Mediator
	{
		[Inject]
		public var localGameSettingsScreen:LocalGameSettingsScreen;
		
		override public function onRegister():void
		{
			localGameSettingsScreen.startButtonClicked.add(startButtonClickedHandler);
		}
		
		override public function onRemove():void
		{
			localGameSettingsScreen.startButtonClicked.remove(startButtonClickedHandler);
		}
		
		private function startButtonClickedHandler(isEvenHuman:Boolean, isOddHuman:Boolean):void
		{
			dispatch(new ContextEvent(ApplicationContext.DISPLAY_LOCAL_GAME_SCREEN, {isEvenHuman:isEvenHuman, isOddHuman:isOddHuman}));
		}
	}
}