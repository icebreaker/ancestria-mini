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
	import org.flixel.FlxEmitter;
	import org.flixel.FlxSprite;
	import org.flixel.FlxState;
	import flash.utils.ByteArray;

	/*
		Class: lrGame
	*/
	public class lrGame extends FlxState
	{
		public static const GAME_RESTART:int	=-1;
		public static const GAME_IDLE:uint		= 0;
		public static const GAME_CLASSIC:uint	= 1;
		public static const GAME_ZEN:uint		= 2;

		public static var lostFocus:Boolean = false;

		private var mCurrX:uint;
		private var mCurrY:uint;
	
		private var mEffects:lrEffects;
		private var mBoard:lrBoard;

		private var mGui:lrGui;
		private var mLevel:uint;
		private var mScore:uint;
		private var mCombo:uint;
		private var mCombos:uint;

		private var mMultiplier:FlxEmitter;

		/*
			Method: create
		*/
		override public function create():void
		{					
			// Add the main game background
			add(new FlxSprite(0,0,lrResources.lrBackground));
	
			// see updatePlayer()
			mCurrX = mCurrY = 0;

			// create effects group
			mEffects = new lrEffects();

			// create the board and set the callbacks
			mBoard = new lrBoard(330,150);
			mBoard.gameMode = GAME_IDLE;
			mBoard.setOnBlocksKilled(onBlocksKilled);
			mBoard.setOnGameOver(onGameOver);
			add(mBoard);

			mGui = new lrGui();
			add(mGui);

			// add effects
			add(mEffects);

			// combo display
			mMultiplier = effects.createMultiplier("4x combo", 500, 300, 1.0, 20);
			mMultiplier.setXSpeed(-50, 50);
			mMultiplier.setYSpeed(-50, 0);
			lrEffects.setColor(mMultiplier, lrBlock.colorForType(5));

			add(mMultiplier);

			// in idle mode by default
			startIdle();
		}
		/*
			Getter: effects

			Provides read-only access to the internal effects group.
		*/
		public function get effects():lrEffects
		{
			return mEffects;
		}
		/*	
			Getter: board

			Provides read-only access to the internal board.
		*/
		public function get board():lrBoard
		{
			return mBoard;
		}
		/*
			Getter: gui

			Provides read-only access to the internal gui.
		*/
		public function get gui():lrGui
		{
			return mGui;
		}
		/*
			Method: startIdle

			Sets up idle mode.
		*/
		public function startIdle():void
		{
			mGui.reload(GAME_IDLE);

			mLevel = 0;
			loadLevel(new lrResources.lrLevelIdle(), GAME_IDLE);
			mBoard.hideCurrentBlocks(); // FIXME: is this necessary?
		}
		/*
			Method: startClassic

			Paramaters:
				pLevel - level to start
		*/
		public function startClassic(pLevel:int = 0):void
		{
			mGui.reload(GAME_CLASSIC);

			if(pLevel != GAME_RESTART)
			{
				mLevel = pLevel;
			}

			loadLevel(new lrResources.LEVELS[mLevel](), GAME_CLASSIC);
			mBoard.showCurrentBlocks(); // FIXME: is this necessary?
		}
		/*
			Method: restart
		*/
		public function restart():void
		{
			startClassic(GAME_RESTART);
		}
		/*
			Method: startNext
		*/
		public function startNext():void
		{
			if(mBoard.gameOver)
			{
				if(mBoard.gameOver == lrBoard.GAMEOVER_LEVEL)
				{
					if(nextLevel())
					{
						lrStats.instance.lastLevel = (++mLevel);
						startClassic(mLevel);
						//loadLevel(new lrResources.LEVELS[mLevel](), mBoard.gameMode);
					}
					else
					{
						if(!mGui.creditsVisible())
						{
							mGui.menu = false;
							mGui.hideGameOver();
							mGui.showEndCredits();
						}
						else
						{
							startIdle();
						}
					}
				}
				else
				{
					startIdle();
				}
			}
			else
			{
				startClassic();
			}
		}
		/*
			Method: nextLevel
		*/
		public function nextLevel():Boolean
		{
			return ((mLevel + 1) < lrResources.LEVELS_NUM);
		}
		/*
			Method: loadLevel

			Paramaters:
				pLevel - byte array containing the textual level data
				pMode - desired game mode
				pTest - magick flag :P

			Loads a level from a byte array with proper GUI messaging.
		*/
		public function loadLevel(pLevel:ByteArray, pMode:uint, pTest:Boolean=false):void
		{
			mBoard.gameMode = pMode;
			mBoard.load(pLevel);

			if(pTest)
				mLevel = lrResources.LEVELS_NUM-1;

			if(mBoard.gameMode != GAME_IDLE)
			{
				mGui.setMessage("Level "+ String(uint(mLevel)+1) + ": " +mBoard.levelName,2,false);

				// HACK, HACK, FIXME
				mGui.menuPlay = true;
				mGui.menuMenu = true;
			}

			mGui.hideGameOver();
			mScore = 0;
			mCombo = 0;
			mCombos = 0;
		}
		/*
			Function: mouseJustPressed
		*/
		public function mouseJustPressed():Boolean
		{
			return (FlxG.mouse.justPressed() && FlxG.mouse.x > 200 && FlxG.mouse.y < 560);
		}
		/*
			Method: update
		*/
		override public function update():void
		{
			if(mBoard.gameMode == GAME_IDLE || mBoard.gameOver)
			{
				super.update();
				return;
			}
			else if(FlxG.keys.justPressed("ESCAPE"))
			{
				startIdle();
				return;
			}

			// Update Remaining Time
			mGui.updateTime(mBoard.levelTime);

			// pre-update board
			updateBoard();

			// update
			super.update();

			if(mBoard.areCurrentBlocksMoving()) return;

			// handle input
			if(mouseJustPressed() || FlxG.keys.justPressed("I"))
			{
				// only a click will trigger "onFocus" again ...
				if(lrGame.lostFocus)
				{
					lrGame.lostFocus = false;
					return;
				}

				mBoard.launchCurrentBlocks();
			}
			else if(FlxG.keys.justPressed("SPACE"))
			{
				mBoard.swapCurrentBlocks();
			}
		}
		/*
			Method: updateBoard

			Updates the board.
		*/
		private function updateBoard():void
		{
		 	if(mBoard.areCurrentBlocksMoving()) return;
	
			if(FlxG.keys.justPressed("O"))
			{
				if(mCurrY > 0) mCurrY--;
			}
			else if(FlxG.keys.justPressed("Q"))
			{
				if(mCurrY < mBoard.heightInBlocks-1)
					mCurrY++;
			}
			else // mouse
			{
				var Y:Number = FlxG.mouse.y;

				if(Y > mBoard.y && Y < mBoard.y + mBoard.height)
					mCurrY = FlxU.floor((Y - mBoard.y) / lrBlock.HEIGHT);
			}

			// update the board's row
			mBoard.setCurrentRow(mCurrY);
		}
		/*
			Method: onBlocksKilled

			Called after a group of blocks of the same type
			has been killed.

			Paramaters:
				pType - block type
				pMatches - array of matched blocks
		*/
		private function onBlocksKilled(pType:uint, pMatches:Array):void
		{
			var l:uint = pMatches.length;
			var presents:uint = 0;
			for(var i:uint=0;i<l;i++)
			{
				if(pMatches[i].present) presents++;
				pMatches[i].kill();
			}

			//FlxG.log(l + " killed of type " + pType + ' and ' + presents + ' presents');
			var sc:uint = (l * 10) + (presents * 50);
			if(l >= 6) 
			{
				sc += l * 33 + 1000; // + bonus for combinations with more than 5 blocks!

				lrEffects.setColor(mMultiplier, lrBlock.colorForType(pType));
				lrEffects.setMultiplierText(mMultiplier, String(l) + "x combo");
				
				mMultiplier.at(pMatches[0]);
				mMultiplier.start();

				if(l > mCombo)
				{
					mCombo = l;
				}
			}
			mCombos++;

			mGui.updateScore((mScore+=sc));
		}
		/*
			Method: onGameOver

			Paramaters:
				pState - game over state

			Called on Game Over.
		*/
		private function onGameOver(pState:uint):void
		{
			// No more levels left?
			if(pState == lrBoard.GAMEOVER_LEVEL && !nextLevel())
				pState = lrBoard.GAMEOVER_FINISHED;

			// calculate bonuses
			var bonus:uint = mBoard.levelTime * 100;
			bonus += mCombos;
			bonus += mCombo * 50;

			// get the stored stats for this level
			// if better store these, otherwise use these
			var elapsedTime:Number = mBoard.levelMaxTime - mBoard.levelTime;

			mGui.showGameOver(pState, (mLevel+1), mScore, bonus, mCombo, elapsedTime);
		}
	}
}
