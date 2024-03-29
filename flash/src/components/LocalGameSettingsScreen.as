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
package components
{
	import flash.display.Sprite;
	import flash.events.Event;
	
	import mx.resources.ResourceManager;
	
	import org.osflash.signals.Signal;
	
	import razor.controls.Button;
	import razor.controls.CheckBox;
	import razor.controls.ComboBox;
	import razor.controls.Label;
	import razor.controls.RadioButton;
	import razor.controls.RadioGroup;
	import razor.core.ControlFactory;
	
	public class LocalGameSettingsScreen extends Sprite
	{
		private var _evenLabel:Label;
		private var _evenHumanRadioButton:RadioButton;
		private var _evenComputerRadioButton:RadioButton;
		private var _evenStrategy:ComboBox;
		private var _oddLabel:Label;
		private var _oddHumanRadioButton:RadioButton;
		private var _oddComputerRadioButton:RadioButton;
		private var _oddStrategy:ComboBox;
		private var _startButton:Button;
		private var _hideHistoryCheckBox:CheckBox;
		private var _backToWelcomeScreenButton:Button;
		
		public var startButtonClicked:Signal;
		public var backToWelcomeButtonClicked:Signal;
		
		public function LocalGameSettingsScreen()
		{
			_evenLabel = ControlFactory.create(Label) as Label;
			_evenLabel.text = ResourceManager.getInstance().getString("Strings", "even");
			_evenLabel.setSize(150, 30);
			addChild(_evenLabel);
			
			var group:RadioGroup = new RadioGroup();
						
			_evenHumanRadioButton = ControlFactory.create(RadioButton) as RadioButton;
			_evenHumanRadioButton.label = ResourceManager.getInstance().getString("Strings", "human");
			_evenHumanRadioButton.group = group;
			_evenHumanRadioButton.selected = true;
			_evenHumanRadioButton.setSize(150, 30);
			addChild(_evenHumanRadioButton);
			
			_evenComputerRadioButton = ControlFactory.create(RadioButton) as RadioButton;
			_evenComputerRadioButton.label = ResourceManager.getInstance().getString("Strings", "computer");
			_evenComputerRadioButton.group = group;
			_evenComputerRadioButton.setSize(150, 30);
			addChild(_evenComputerRadioButton);
			
			_evenStrategy = ControlFactory.create(ComboBox) as ComboBox;
			_evenStrategy.setSize(150, 30);
			addChild(_evenStrategy);
			
			_oddLabel = ControlFactory.create(Label) as Label;
			_oddLabel.text = ResourceManager.getInstance().getString("Strings", "odd");
			_oddLabel.setSize(150, 30);
			addChild(_oddLabel);
			
			group = new RadioGroup();
			
			_oddHumanRadioButton = ControlFactory.create(RadioButton) as RadioButton;
			_oddHumanRadioButton.label = ResourceManager.getInstance().getString("Strings", "human");
			_oddHumanRadioButton.group = group;
			_oddHumanRadioButton.selected = true;
			_oddHumanRadioButton.setSize(150, 30);
			addChild(_oddHumanRadioButton);
			
			_oddComputerRadioButton = ControlFactory.create(RadioButton) as RadioButton;
			_oddComputerRadioButton.label = ResourceManager.getInstance().getString("Strings", "computer");
			_oddComputerRadioButton.group = group;
			_oddComputerRadioButton.setSize(150, 30);
			addChild(_oddComputerRadioButton);
			
			_oddStrategy = ControlFactory.create(ComboBox) as ComboBox;
			_oddStrategy.setSize(150, 30);
			addChild(_oddStrategy);
			
			_startButton = ControlFactory.create(Button) as Button;
			_startButton.label = ResourceManager.getInstance().getString("Strings", "start");
			_startButton.setSize(200, 30);
			_startButton.addEventListener(Button.E_CLICK, startButtonClickedHandler);
			addChild(_startButton);
			
			_backToWelcomeScreenButton = ControlFactory.create(Button) as Button;
			_backToWelcomeScreenButton.label = ResourceManager.getInstance().getString("Strings", "back");
			_backToWelcomeScreenButton.setSize(200, 30);
			_backToWelcomeScreenButton.addEventListener(Button.E_CLICK, backToWelcomeScreenButtonClickedHandler);
			addChild(_backToWelcomeScreenButton);
			
			_hideHistoryCheckBox = ControlFactory.create(CheckBox) as CheckBox;
			_hideHistoryCheckBox.label = ResourceManager.getInstance().getString("Strings", "hide_history");
			_hideHistoryCheckBox.setSize(200, 30);
			addChild(_hideHistoryCheckBox);
			
			startButtonClicked = new Signal(Boolean, Boolean, Boolean, String, String);
			backToWelcomeButtonClicked = new Signal();
			
			addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
		}
		
		public function set strategies(value:Array):void
		{
			_evenStrategy.dataProvider = value;
			_oddStrategy.dataProvider = value;
			_evenStrategy.selectedIndex = 0;
			_oddStrategy.selectedIndex = 0;
		}
		
		private function addedToStageHandler(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
			
			_evenLabel.x = stage.stageWidth*0.25-_evenLabel.width*0.5;
			_evenLabel.y = 100;
			_evenHumanRadioButton.x = stage.stageWidth*0.25-_evenHumanRadioButton.width*0.5;
			_evenHumanRadioButton.y = 100+30;
			_evenComputerRadioButton.x = stage.stageWidth*0.25-_evenComputerRadioButton.width*0.5;
			_evenComputerRadioButton.y = 100+30+30;
			_evenStrategy.x = stage.stageWidth*0.25-_evenComputerRadioButton.width*0.5;
			_evenStrategy.y = 100+30+30+30;
			
			_oddLabel.x = stage.stageWidth*0.75-_oddLabel.width*0.5;
			_oddLabel.y = 100;
			_oddHumanRadioButton.x = stage.stageWidth*0.75-_oddHumanRadioButton.width*0.5;
			_oddHumanRadioButton.y = 100+30;
			_oddComputerRadioButton.x = stage.stageWidth*0.75-_oddComputerRadioButton.width*0.5;
			_oddComputerRadioButton.y = 100+30+30;
			_oddStrategy.x = stage.stageWidth*0.75-_oddComputerRadioButton.width*0.5;
			_oddStrategy.y = 100+30+30+30;
			
			_startButton.x = (stage.stageWidth-_startButton.width)*0.5;
			_startButton.y = stage.stageHeight*0.5+100;
			
			_backToWelcomeScreenButton.x = (stage.stageWidth-_backToWelcomeScreenButton.width)*0.5;
			_backToWelcomeScreenButton.y = stage.stageHeight*0.5+132;
			
			_hideHistoryCheckBox.move((stage.stageWidth-_hideHistoryCheckBox.width)*0.5, 100+30+30+30+30+20);
		}
		
		private function startButtonClickedHandler(e:Event):void
		{
			startButtonClicked.dispatch(_evenHumanRadioButton.selected, _oddHumanRadioButton.selected, _hideHistoryCheckBox.selected, _evenStrategy.selectedItem, _oddStrategy.selectedItem);
		}
		
		private function backToWelcomeScreenButtonClickedHandler(e:Event):void
		{
			backToWelcomeButtonClicked.dispatch();
		}
	}
}