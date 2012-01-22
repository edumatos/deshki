package ai
{
	import entities.Game;
	import entities.Move;
	
	import flash.errors.IllegalOperationError;
	
	import org.osflash.signals.Signal;

	public class AbstractStrategy
	{
		public var done:Signal = new Signal(Move);
		
		public function doMove(game:Game):void
		{
			throw new IllegalOperationError("Must be overridden");
		}
	}
}