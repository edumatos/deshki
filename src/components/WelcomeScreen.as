package components
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	
	import org.osflash.signals.Signal;
	
	import razor.controls.Button;
	import razor.controls.Label;
	import razor.core.ControlFactory;
	import razor.skins.StyleSheet;
	
	public class WelcomeScreen extends Sprite
	{
		private var _titleLabel:Label;
		private var _playLocallyButton:Button;
		private var _playNetworkButton:Button;
		
		public var playLocallyButtonClicked:Signal;
		public var playNetworkButtonClicked:Signal;
		
		public function WelcomeScreen()
		{
			var styleSheet:StyleSheet = ControlFactory.defaultFactory.rootStyleSheet;
			styleSheet.addRule("title", new StyleSheet({fontSize: 48, bold: true, underline: true, align: "center"}));
			_titleLabel = ControlFactory.create(Label, "title") as Label;
			_titleLabel.text = "Дешки";
			_titleLabel.setSize(200, 100);
			addChild(_titleLabel);
			_playLocallyButton = ControlFactory.create(Button) as Button;
			_playLocallyButton.label = "Играть локально";
			_playLocallyButton.setSize(200, 30);
			_playLocallyButton.addEventListener(Button.E_CLICK, playLocallyButtonClickedHandler);
			addChild(_playLocallyButton);
			
			_playNetworkButton = ControlFactory.create(Button) as Button;
			_playNetworkButton.label = "Играть через Интернет";
			_playNetworkButton.setSize(200, 30);
			_playNetworkButton.addEventListener(Button.E_CLICK, playNetworkButtonClickedHandler);
			addChild(_playNetworkButton);
			
			playLocallyButtonClicked = new Signal();
			playNetworkButtonClicked = new Signal();
			
			addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
		}
		
		private function addedToStageHandler(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
			
			_titleLabel.x = (stage.stageWidth-_titleLabel.width)*0.5;
			_playLocallyButton.x = (stage.stageWidth-_playLocallyButton.width)*0.5;
			_playLocallyButton.y = 300;
			
			_playNetworkButton.x = (stage.stageWidth-_playNetworkButton.width)*0.5;
			_playNetworkButton.y = 340;
		}
		
		private function playLocallyButtonClickedHandler(e:Event):void
		{
			playLocallyButtonClicked.dispatch();
		}
		
		private function playNetworkButtonClickedHandler(e:Event):void
		{
			playNetworkButtonClicked.dispatch();
		}
	}
}