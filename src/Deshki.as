package
{
	import flash.display.Sprite;
	import flash.events.Event;
	
	import razor.skins.Settings;
	import razor.skins.plastic.PlasticStyleSheet;
	import context.ApplicationContext;
	
	[SWF(width="600", height="400")]
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
			
			_context = new ApplicationContext(this);
		}
	}
}