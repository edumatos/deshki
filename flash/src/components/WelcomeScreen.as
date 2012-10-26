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
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	
	import mx.resources.ResourceManager;
	
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
			_titleLabel.text = ResourceManager.getInstance().getString("Strings", "deshki");
			_titleLabel.setSize(200, 100);
			addChild(_titleLabel);
			_playLocallyButton = ControlFactory.create(Button) as Button;
			_playLocallyButton.label = ResourceManager.getInstance().getString("Strings", "play_locally");
			_playLocallyButton.setSize(200, 30);
			_playLocallyButton.addEventListener(Button.E_CLICK, playLocallyButtonClickedHandler);
			addChild(_playLocallyButton);
			
			_playNetworkButton = ControlFactory.create(Button) as Button;
			_playNetworkButton.label = ResourceManager.getInstance().getString("Strings", "play_via_internet");
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