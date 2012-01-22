package components
{
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.filters.DropShadowFilter;
	
	import org.osflash.signals.Signal;
	
	import razor.controls.Button;
	import razor.controls.Label;
	import razor.core.ControlFactory;
	
	public class Alert extends Sprite
	{
		private var _background:Shape;
		private var _messageLabel:Label;
		private var _okButton:Button;
		
		public var okButtonClicked:Signal;
		
		public function Alert()
		{
			_background = new Shape();
			_background.graphics.beginFill(0xFF8899);
			_background.graphics.drawRoundRect(0,0,200,200,10);
			_background.graphics.endFill();
			_background.filters = [new DropShadowFilter(4,45,0,1,4,4,0.5)];
			addChild(_background);
			
			_messageLabel = ControlFactory.create(Label) as Label;
			_messageLabel.setSize(200,170);
			_messageLabel.align = "center";
			addChild(_messageLabel);
			
			_okButton = ControlFactory.create(Button) as Button;
			_okButton.label = "OK";
			_okButton.setSize(100,30);
			_okButton.addEventListener(Button.E_CLICK, okButtonClickedHandler);
			addChild(_okButton);
			
			okButtonClicked = new Signal();
			
			addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
		}
		
		public function set message(value:String):void
		{
			_messageLabel.text = value;
		}
		
		private function addedToStageHandler(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
			
			_okButton.move((_background.width-_okButton.width)*0.5,170);
			
			x = (stage.stageWidth-width)*0.5;
			y = (stage.stageHeight-height)*0.5;
		}
		
		private function okButtonClickedHandler(e:Event):void
		{
			okButtonClicked.dispatch();
		}
	}
}