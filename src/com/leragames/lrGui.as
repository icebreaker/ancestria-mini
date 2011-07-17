/*
	Copyright (c) 2010-2011, Mihail Szabolcs
	Copyright (c) 2010-2011, Lera Games

	All rights reserved.

	This file is part of Ancestria: Mini.

	Ancestria: Mini is free software: you can redistribute it and/or modify
	it under the terms of the GNU General Public License as published by
	the Free Software Foundation, either version 3 of the License, or
	(at your option) any later version.

	Ancestria: Mini is distributed in the hope that it will be useful,
	but WITHOUT ANY WARRANTY; without even the implied warranty of
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
	GNU General Public License for more details.

	You should have received a copy of the GNU General Public License
	along with Ancestria: Mini.  If not, see <http://www.gnu.org/licenses/>.
*/
package com.leragames
{
	import org.flixel.FlxG;
	import org.flixel.FlxU;
	import org.flixel.FlxGroup;
	import org.flixel.FlxButton;
	import org.flixel.FlxSprite;
	import flash.net.navigateToURL;
	import flash.net.URLRequest;
	import flash.net.FileReference;
	import flash.net.FileFilter;
	import flash.events.Event;

	/*
		Class: lrGui

		lrGui class.
	*/
	public class lrGui extends FlxGroup
	{
		private var mSound:lrButton;
		private var mTime:lrText;
		private var mScore:lrText;
		private var mMessage:lrTextPanel;
		private var mGameOver:lrGameOver;
		private var mGameStart:lrGameStart;
		private var mCredits:lrCredits;
		private var mLevelBrowser:lrLevelBrowser;

		private var mWebSite:lrButton;

		private var mMenuPauseButton:FlxButton;
		private var mMenuRestartButton:FlxButton;
		private var mMenuMenuButton:FlxButton;
		private var mMenuCreditsButton:FlxButton;

		// DEBUG / DEV mode
		private var mFileReference:FileReference;
		private var mFileFilter:FileFilter;

		/*
			Constructor: lrGui
		*/
		public function lrGui()
		{
			super();

			// Sound On / Off
			mSound = new lrButton(130,505,setSound,"On",50);
			mSound.textSize = 24;
			mSound.on = true;

			add(mSound);

			// Remaining Time (Timer)
			mTime = new lrText(80,468,90,"00 : 00");
			mTime.size = 22;
			mTime.alignment = "left";
			add(mTime);

			// Score
			mScore = new lrText(25,355,200,"0");
			mScore.size = 24;
			add(mScore);

			// WebSite
			mWebSite = new lrButton(330, 560,openWebsite,"ancestriagame.com/mini",280);
			mWebSite.textSize = 20;
			add(mWebSite);

			// Load Level File From Disk
			if(FlxG.debug)
			{
				mFileReference = new FileReference();
				mFileFilter = new FileFilter("Levels", "*.lvl");
				mFileReference.addEventListener(Event.SELECT, loadLevelSelected);
				mFileReference.addEventListener(Event.COMPLETE, loadLevelCompleted);
			
				var loadLevelBtn:lrButton = new lrButton(45,430,loadLevel,"Load",80);
				loadLevelBtn.textSize = 20;
				loadLevelBtn.textActiveColor = 0xFFFF00AA;
				loadLevelBtn.textHoverColor = 0xFFFFFFFF;
				add(loadLevelBtn);
			}

			// Message Box
			mMessage = new lrTextPanel("Ancestria");
			mMessage.visible = false;
			add(mMessage);

			// Game Over
			mGameOver = new lrGameOver();
			mGameOver.visible = false;
			add(mGameOver);

			// Game Start a.k.a Tutorial & Play
			mGameStart = new lrGameStart();
			mGameStart.visible = false;
			add(mGameStart);

			// Level Browser
			mLevelBrowser = new lrLevelBrowser();
			mLevelBrowser.visible = false;
			add(mLevelBrowser);

			// Credits
			mCredits = new lrCredits();
			mCredits.visible = false;
			add(mCredits);

			// Menu Buttons
			mMenuPauseButton = new FlxButton(0, 10, clickPause);
			mMenuPauseButton.loadGraphic(new FlxSprite(0, 0, lrResources.lrMenuPause));
			add(mMenuPauseButton);

			mMenuRestartButton = new FlxButton(70, -16, clickRestart);
			mMenuRestartButton.loadGraphic(new FlxSprite(0, 0, lrResources.lrMenuRestart));
			add(mMenuRestartButton);

			// FIXME: calc relative to screen size!
			mMenuMenuButton = new FlxButton(705, -5, clickMenu);
			mMenuMenuButton.loadGraphic(new FlxSprite(0, 0, lrResources.lrMenuMenu));
			add(mMenuMenuButton);

			mMenuCreditsButton = new FlxButton(715, 515, clickCredits);
			mMenuCreditsButton.loadGraphic(new FlxSprite(0, 0, lrResources.lrMenuCredits));
			add(mMenuCreditsButton);

			menu = false;
			menuCredits = true;

			// Mouse
			FlxG.mouse.show(lrResources.lrCursor);
		}
		/*
			Method: clickMenu
		*/
		public function clickMenu():void
		{
			(FlxG.state as lrGame).startIdle();
		}
		/*
			Method: clickRestart
		*/
		public function clickRestart():void
		{
			(FlxG.state as lrGame).restart();
		}
		/*
			Method: clickPause
		*/
		public function clickPause():void
		{
			FlxG.pause = !FlxG.pause;
		}
		/*
			Method: clickCredits
		*/
		public function clickCredits():void
		{
			hideGameStart();
			hideLevelBrowser();
			showCredits();
		}
		/*
			Setter: menu

			Shows / hides the menu buttons.
		*/
		public function set menu(pState:Boolean):void
		{
			menuPlay = pState;
			menuMenu = pState;
			menuCredits = pState;
		}
		/*
			Setter: menuPlay
		*/
		public function set menuPlay(pState:Boolean):void
		{
			mMenuPauseButton.visible = mMenuPauseButton.exists = pState;
			mMenuRestartButton.visible = mMenuRestartButton.exists = pState;
		}
		/*
			Setter: menuMenu
		*/
		public function set menuMenu(pState:Boolean):void
		{
			mMenuMenuButton.visible = mMenuMenuButton.exists = pState;
		}
		/*
			Setter: menuCredits
		*/
		public function set menuCredits(pState:Boolean):void
		{
			mMenuCreditsButton.visible = mMenuCreditsButton.exists = pState;
		}
		/*
			Method: setMessage

			Paramaters:
				pMessage - the message to show
				pTimeout - timeout in seconds (to show the message)
				pColor - desired font color
		*/
		public function setMessage(pMessage:String, pTimeout:uint=0, pBackground:Boolean=true, pColor:uint=0xFFFFFFFF):void
		{
			mMessage.color = pColor;
			mMessage.text = pMessage;
			mMessage.visibility = pTimeout;
			mMessage.background = pBackground;
		}
		/*
			Method: hideMessage
		*/
		public function hideMessage():void
		{
			mMessage.hide();
		}
		/*
			Method: showCredits
		*/
		public function showCredits():void
		{
			mCredits.show(false);
		}
		/*
			Method: showEndCredits
		*/
		public function showEndCredits():void
		{
			mCredits.show(true);
		}
		/*
			Function: creditsVisible
		*/
		public function creditsVisible():Boolean
		{
			return mCredits.visible;
		}
		/*
			Method: hideCredits
		*/
		public function hideCredits():void
		{
			mCredits.hide();
		}
		/*
			Method: showLevelBrowser
		*/
		public function showLevelBrowser():void
		{
			mLevelBrowser.show();
		}
		/*
			Method: hideLevelBrowser
		*/
		public function hideLevelBrowser():void
		{
			mLevelBrowser.hide();
		}
		/*
			Method: showGameOver

			Paramaters:
				pState - game over state
				pLevel - the current level
				pScore - the actual score for the current level
				pBonus - the actual bonus for the current level
				pCombo - the actual maximum combo for the current level
				pTime  - the actual elapsed time for the current level
		*/
		public function showGameOver(pState:uint, 
									 pLevel:uint, 
									 pScore:uint, 
									 pBonus:uint,
									 pCombo:uint,
									 mTime:Number):void
		{
			menu = false;

			var st:String = '';
			switch(pState)
			{
				case lrBoard.GAMEOVER_NOMOVE:
					st = 'Game Over, no more moves!';
					break;

				case lrBoard.GAMEOVER_TIME:
					st = 'Game Over, time is up!';
					break;

				case lrBoard.GAMEOVER_FINISHED:
				case lrBoard.GAMEOVER_LEVEL:
					st = 'Level ' + String(pLevel) + ' Completed';
					break;
			}

			mGameOver.show(st, pScore, pBonus, pCombo, mTime);
		}
		/*
			Method: hideGameOver
		*/
		public function hideGameOver():void
		{
			mGameOver.hide();
			
			updateTime(0);
			updateScore(0);
		}
		/*
			Method: showGameStart
		*/
		public function showGameStart():void
		{
			mGameStart.show();
		}
		/*
			Method: hideGameStart
		*/
		public function hideGameStart():void
		{
			mGameStart.hide();
		}
		/*
			Method: updateScore

			Paramaters:
				pScore - the actual score

			Updates the score to the given value.
		*/
		public function updateScore(pScore:Number):void
		{
			mScore.text = String(pScore);
		}
		/*
			Method: setRemainingTime

			Paramaters:
				pTime - current tick count

			Updates the remaining time counter from the tick count.
		*/
		public function updateTime(pTime:Number):void
		{
			if(pTime < 0) return;

			var mins:Number = FlxU.floor(pTime / 60.0);
			var secs:Number = FlxU.floor(pTime % 60.0);

			var txtMins:String = String((mins < 10) ? "0" + mins : mins);
			var txtSecs:String = String((secs < 10) ? "0" + secs : secs);

			mTime.text = txtMins + " : " + txtSecs;

			if(pTime == 0)
			{
				mTime.color = 0xFF5B6A74;
			}
			else if(mins == 0 && secs == 59)
			{
				mTime.color = lrBlock.colorForType(5);
			}
		}
		/*
			Method: reload

			Resets the UI to a good state.
		*/
		public function reload(pMode:uint):void
		{
			FlxG.pause = false;
			menu = false;

			hideGameOver();
			hideLevelBrowser();
			hideCredits();

			if(pMode == lrGame.GAME_IDLE)
			{
				showGameStart();
				menuCredits = true;
			}
			else
			{
				hideGameStart();
				menuPlay = true;
				menuMenu = true;
			}
		}
		/*
			Method: openWebsite

			Opens http://ancestriagame.com/mini in the default browser.
		*/
		public function openWebsite():void
		{
			navigateToURL(new URLRequest("http://ancestriagame.com/mini"));
		}
		/*
			Method: setSound

			Sets the sound ON / OFF.
		*/
		public function setSound():void
		{
			FlxG.mute = !FlxG.mute;

			mSound.text = (FlxG.mute) ? "Off" : "On"; 
			mSound.on = !FlxG.mute;
		}
		/*
			Method: loadLevel

			Triggers the `file browse / open` dialog in order to select and load a level from disk.
		*/
		private function loadLevel():void
		{
			mFileReference.browse([mFileFilter]);
		}
		/*
			Method: loadLevelSelected

			Triggers load on the selected file.
		*/
		private function loadLevelSelected(pEvent:Event):void
		{
			mFileReference.load();
		}
		/*
			Method: loadLevelCompleted

			Loads the actual level into the game (board).
		*/
		private function loadLevelCompleted(pEvent:Event):void
		{
			//FlxG.log("Level File: " + mFileReference.name);
			(FlxG.state as lrGame).loadLevel(mFileReference.data, lrGame.GAME_CLASSIC, true);
		}
	}
}

