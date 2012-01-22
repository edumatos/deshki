package components
{
	import flash.display.Sprite;
	import flash.events.Event;
	
	import org.osflash.signals.Signal;
	
	import razor.controls.Button;
	import razor.controls.Label;
	import razor.controls.RadioButton;
	import razor.controls.RadioGroup;
	import razor.core.ControlFactory;
	
	public class LocalGameSettingsScreen extends Sprite
	{
		private var _evenLabel:Label;
		private var _evenHumanRadioButton:RadioButton;
		private var _evenComputerRadioButton:RadioButton;
		private var _oddLabel:Label;
		private var _oddHumanRadioButton:RadioButton;
		private var _oddComputerRadioButton:RadioButton;
		private var _startButton:Button;
		
		public var startButtonClicked:Signal;
		
		public function LocalGameSettingsScreen()
		{
			_evenLabel = ControlFactory.create(Label) as Label;
			_evenLabel.text = "Чётные";
			_evenLabel.setSize(150, 30);
			addChild(_evenLabel);
			
			var group:RadioGroup = new RadioGroup();
						
			_evenHumanRadioButton = ControlFactory.create(RadioButton) as RadioButton;
			_evenHumanRadioButton.label = "Человек";
			_evenHumanRadioButton.group = group;
			_evenHumanRadioButton.selected = true;
			_evenHumanRadioButton.setSize(150, 30);
			addChild(_evenHumanRadioButton);
			
			_evenComputerRadioButton = ControlFactory.create(RadioButton) as RadioButton;
			_evenComputerRadioButton.label = "Компьютер";
			_evenComputerRadioButton.group = group;
			_evenComputerRadioButton.setSize(150, 30);
			addChild(_evenComputerRadioButton);
			
			_oddLabel = ControlFactory.create(Label) as Label;
			_oddLabel.text = "Нечётные";
			_oddLabel.setSize(150, 30);
			addChild(_oddLabel);
			
			group = new RadioGroup();
			
			_oddHumanRadioButton = ControlFactory.create(RadioButton) as RadioButton;
			_oddHumanRadioButton.label = "Человек";
			_oddHumanRadioButton.group = group;
			_oddHumanRadioButton.selected = true;
			_oddHumanRadioButton.setSize(150, 30);
			addChild(_oddHumanRadioButton);
			
			_oddComputerRadioButton = ControlFactory.create(RadioButton) as RadioButton;
			_oddComputerRadioButton.label = "Компьютер";
			_oddComputerRadioButton.group = group;
			_oddComputerRadioButton.setSize(150, 30);
			addChild(_oddComputerRadioButton);
			
			_startButton = ControlFactory.create(Button) as Button;
			_startButton.label = "Начать";
			_startButton.setSize(200, 30);
			_startButton.addEventListener(Button.E_CLICK, startButtonClickedHandler);
			addChild(_startButton);
			
			startButtonClicked = new Signal(Boolean, Boolean);
			
			addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
		}
		
		private function addedToStageHandler(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
			
			_evenLabel.x = stage.stageWidth*0.25-_evenLabel.width*0.5;
			_evenLabel.y = stage.stageHeight*0.5;
			_evenHumanRadioButton.x = stage.stageWidth*0.25-_evenHumanRadioButton.width*0.5;
			_evenHumanRadioButton.y = stage.stageHeight*0.5+30;
			_evenComputerRadioButton.x = stage.stageWidth*0.25-_evenComputerRadioButton.width*0.5;
			_evenComputerRadioButton.y = stage.stageHeight*0.5+60;
			
			_oddLabel.x = stage.stageWidth*0.75-_oddLabel.width*0.5;
			_oddLabel.y = stage.stageHeight*0.5;
			_oddHumanRadioButton.x = stage.stageWidth*0.75-_oddHumanRadioButton.width*0.5;
			_oddHumanRadioButton.y = stage.stageHeight*0.5+30;
			_oddComputerRadioButton.x = stage.stageWidth*0.75-_oddComputerRadioButton.width*0.5;
			_oddComputerRadioButton.y = stage.stageHeight*0.5+60;
			
			_startButton.x = (stage.stageWidth-_startButton.width)*0.5;
			_startButton.y = stage.stageHeight*0.5+100;
		}
		
		private function startButtonClickedHandler(e:Event):void
		{
			startButtonClicked.dispatch(_evenHumanRadioButton.selected, _oddHumanRadioButton.selected);
		}
	}
}