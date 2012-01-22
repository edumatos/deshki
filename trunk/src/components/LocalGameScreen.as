package components
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	
	import org.osflash.signals.Signal;
	
	import razor.controls.Button;
	import razor.controls.Label;
	import razor.core.ControlFactory;
	
	public class LocalGameScreen extends Sprite
	{
		private var _gameField:GameField;
		private var _restartButton:Button;
		private var _stateLabel:Label;
		
		public var restartButtonClicked:Signal;
		
		public function LocalGameScreen()
		{
			_gameField = new GameField();
			_gameField.width = 396;
			_gameField.height = 396;
			addChild(_gameField);
			
			_restartButton = ControlFactory.create(Button) as Button;
			_restartButton.label = "Новая игра";
			_restartButton.setSize(200, 30);
			_restartButton.addEventListener(Button.E_CLICK, restartButtonClickedHandler);
			addChild(_restartButton);
			
			_stateLabel = ControlFactory.create(Label) as Label;
			_stateLabel.setSize(200, 300);
			addChild(_stateLabel);
			
			restartButtonClicked = new Signal();
			
			addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
		}
		
		public function get gameField():GameField
		{
			return _gameField;
		}
		
		public function set stateLabelText(value:String):void
		{
			_stateLabel.text = value;
		}
		
		private function addedToStageHandler(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
			
			_gameField.x = 2;
			_gameField.y = 2;
			
			_restartButton.move(stage.stageWidth-_restartButton.width, stage.stageHeight-_restartButton.height);
			
			_stateLabel.move(stage.stageWidth-_stateLabel.width, 0);
		}
		
		private function restartButtonClickedHandler(e:Event):void
		{
			restartButtonClicked.dispatch();
		}
	}
}