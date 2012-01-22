package mediators
{
	import components.Alert;
	
	import org.robotlegs.mvcs.Mediator;
	
	public class AlertMediator extends Mediator
	{
		[Inject]
		public var alert:Alert;
		
		override public function onRegister():void
		{
			alert.okButtonClicked.add(okButtonClickedHndler);
		}
		
		override public function onRemove():void
		{
			alert.okButtonClicked.remove(okButtonClickedHndler);
		}
		
		private function okButtonClickedHndler():void
		{
			alert.parent.removeChild(alert);
		}
	}
}