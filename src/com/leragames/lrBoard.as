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
	import org.flixel.FlxU;
	import org.flixel.FlxG;
	import org.flixel.FlxGroup;
	import org.flixel.FlxPoint;
	import org.flixel.FlxSprite;
	import flash.utils.ByteArray;
	
	/*
		Class: lrBoard
		
		Adds functionality on the top of the standard FlxGroup; this includes
		level loading, player management and a bunch of other things.
	*/
	public class lrBoard extends FlxGroup
	{
		/*
			Constants:

			Various Game Over states instead of just being
			a plain boolean, we extended this to be able to store
			various conditions and handle them appropriately.
			(i.e in classic mode the game is over when the give
			time frame for the given level elapsed)

			GAMEOVER_FALSE	- not game over (default state)
			GAMEOVER_NOMOVE - game over because there are no more moves left
			GAMEOVER_TIME	- game over because the time elapsed
			GAMEOVER_LEVEL	- game over because the board has been cleared and the level is complete
			GAMEOVER_FINISHED - game over because all levels completed
		*/
		static public const GAMEOVER_FALSE:uint		= 0;
		static public const GAMEOVER_NOMOVE:uint	= 1;
		static public const GAMEOVER_TIME:uint		= 2;
		static public const GAMEOVER_LEVEL:uint		= 3;
		static public const GAMEOVER_FINISHED:uint	= 4;

		/*
			Contants:

			MATCH_LEFT	- match blocks left
			MATCH_RIGHT - match blocks right
			MATCH_UP	- match blocks up
			MATCH_DOWN	- match blocks down
		*/
		private const MATCH_LEFT:int	= 1 << 0;
		private const MATCH_RIGHT:int	= 1 << 1;
		private const MATCH_UP:int		= 1 << 2;
		private const MATCH_DOWN:int	= 1 << 3;
		private const MATCH_ALL:int		= MATCH_LEFT | MATCH_RIGHT | MATCH_UP | MATCH_DOWN;

		private var mGameMode:uint;
		private var mTmp1Array:Array;
		private var mTmp2Array:Array;
		private var mTmp3Array:Array;
		private var mPointZero:FlxPoint;

		private var mBeziers:Array;
	
		private var mCurrX:uint;
		private var mCurrY:uint;
		
		private var mOnBlocksKilled:Function;
		private var mOnGameOver:Function;
		private var mGameOver:uint;
		
		private var mWidthInBlocks:uint;
		private var mHeightInBlocks:uint;
		private var mHalfWidthInBlocks:uint;
		private var mHalfHeightInBlocks:uint;
		
		private var mBlocks:Array;
		private var mBlocksHightlights:Array;
		private var mCurrentBlocks:Array;
		private var mCurrentTargets:Array;
		private var mCurrentBlocksSwapping:Boolean;
		private var mRowShifted:Boolean;
		
		private var mExcludedBlocks:Array;
		private var mNonExcludedBlocks:Array;

		private var mBlockTileGlow:lrBlock;
		
		private var mLevelName:String;
		private var mLevelTime:Number;
		private var mLevelMaxTime:Number;

		/*
			Constructor: lrBoard
			
			Paramaters:
				pX - initial position on the X axis
				pY - initial position on the Y axis
		*/
		public function lrBoard(pX:uint, pY:uint)
		{
			var i:uint = 0, j:uint = 0;

			// FlxGroup.super
			super();

			// Default Game Mode is Time Based
			mGameMode = lrGame.GAME_IDLE;

			// Not Game Over :D
			mGameOver = GAMEOVER_FALSE;

			// temporary Array storage
			mTmp1Array = new Array();
			mTmp2Array = new Array();
			mTmp3Array = new Array();

			// zero point
			mPointZero = new FlxPoint(0,0);

			// Two Bezier Curve Solvers
			mBeziers = new Array(2);
			for(i=0;i<2;i++)
				mBeziers[i] = new lrBezier( mPointZero,
											mPointZero,
											mPointZero,
											mPointZero );

			// see update() for more information
			setCurrentRow(0);
			
			// set default "action" callbacks
			setOnBlocksKilled(onBlocksKilled);
			setOnGameOver(onGameOver);
			
			// see load() for more information
			mWidthInBlocks = mHeightInBlocks = 0;
			mHalfWidthInBlocks = mHalfHeightInBlocks = 0;

			// group position
			x = pX;
			y = pY;

			// load available blocks
			mBlocks = new Array(2);
			for(j=0;j<2;j++)
			{
				mBlocks[j] = new Array(lrBlock.NUM);
				for(i=0;i<lrBlock.NUM;i++)
				{
					var b:lrBlock = new lrBlock(mPointZero,i+1);
					//b.alpha = 0.8;

					mBlocks[j][i] = b;
				}
			}
	
			// load available block Highlights
			mBlocksHightlights = new Array(2);
			for(j=0;j<2;j++)
			{
				mBlocksHightlights[j] = new Array(lrBlock.NUM);
				for(i=0;i<lrBlock.NUM;i++)
					mBlocksHightlights[j][i] = new lrBlock(mPointZero,i+1+lrBlock.HIGHLIGHT);
			}
				
			// two current blocks
			mCurrentBlocks = new Array(2);
			mCurrentBlocks[0] = 0;
			mCurrentBlocks[1] = 0;

			// two current targets
			mCurrentTargets = new Array(2);
			for(i=0;i<2;i++)
				mCurrentTargets[i] = new FlxPoint(-1,-1);

			// not swapping blocks by default
			mCurrentBlocksSwapping = false;

			// no row shifted by default
			mRowShifted = false;

			// excluded blocks (for random, etc)
			mExcludedBlocks = new Array();

			// non excluded blocks (for random, etc)
			mNonExcludedBlocks = new Array();
			for(i=0;i<lrBlock.NUM;i++)
				mNonExcludedBlocks.push(i+1);

			// glow block tile
			mBlockTileGlow = new lrBlock(mPointZero,lrBlock.GLOW);
			mBlockTileGlow.blend = "screen";

			// randomize current blocks
			randomizeCurrentBlock(0);
			randomizeCurrentBlock(1);

			// hide them by default
			hideCurrentBlocks();
				
			// set default level properties
			mLevelName = "Demo";
			mLevelTime = -1;
			mLevelMaxTime = -1;
		}
		/*
			Getter: gameMode

			Returns the current game mode.
		*/
		public function get gameMode():uint
		{
			return mGameMode;
		}
		/*
			Setter: gameMode

			Sets the current game mode.
		*/
		public function set gameMode(pGameMode:uint):void
		{
			mGameMode = pGameMode;

			if(mGameMode == lrGame.GAME_IDLE)
				hideCurrentBlocks();
			else
				showCurrentBlocks();
		}
		/*
			Getter: gameOver

			Returns game over state.
		*/
		public function get gameOver():uint
		{
			return mGameOver;
		}
		/*
			Getter: levelTime

			Returns the remaining time.
		*/
		public function get levelTime():Number
		{
			return mLevelTime;
		}
		/*
			Getter: levelMaxTime

			Returns the maximum time.
		*/
		public function get levelMaxTime():Number
		{
			return mLevelMaxTime;
		}
		/*
			Getter: levelName

			Returns the name of the currently active level.
		*/
		public function get levelName():String
		{
			return mLevelName;
		}
		/*
			Method: load
			
			Loads a level.
			
			Paramaters:
				pLevel - the level id or index
		*/
		public function load(pLevel:ByteArray):void
		{
			var i:uint = 0;

			// pre-update
			update();

			// perform some clean-up
			clear();

			// load the "blocks" and figure out the dimensions of the board
			var rows:Array = pLevel.readUTFBytes(pLevel.length).split("\n");			
			mLevelName = rows.shift(); // fetch NAME
			mLevelTime = uint(rows.shift()); // fetch TIME
			
			//FlxG.log("Level: " + mLevelName);
			//FlxG.log("Time: " + mLevelTime + " minutes");

			if(mGameMode != lrGame.GAME_CLASSIC)
				mLevelTime = -1;
			else
				mLevelTime *= 60; // convert to seconds

			mLevelMaxTime = mLevelTime;

			var l:uint = rows.length; mWidthInBlocks = 0; mHeightInBlocks = l;
			for(var yy:uint=0;yy<l;yy++)
			{
				var cols:Array = rows[yy].split(" ");
				if(mWidthInBlocks==0) mWidthInBlocks = cols.length;
				
				// skip odd rows
				if(cols.length!=mWidthInBlocks)
				{
					mHeightInBlocks--;
					continue;
				}
							
				for(var xx:uint=0;xx<mWidthInBlocks;xx++)
					members.push(new lrBlock(mPointZero,uint(cols[xx])));
			}

			// update the positions based on the board size and offsets
			l = mWidthInBlocks * mHeightInBlocks;
			for(i=0;i<l;i++)
				members[i].setPosition(pointFromOffset(i,true));

			// update real width and height
			width = mWidthInBlocks * lrBlock.WIDTH;
			height= mHeightInBlocks * lrBlock.HEIGHT;

			// save the half size in blocks
			mHalfWidthInBlocks = FlxU.floor(mWidthInBlocks / 2);
			mHalfHeightInBlocks = FlxU.floor(mHeightInBlocks / 2);

			// update excluded vs non-excluded blocks we get the right colors
			// the number of colors available in a certain game will be determined
			// by how many of the initial colors were present when the level was
			// loaded ...
			for(i=0;i<lrBlock.NUM;i++)
				updateExcludedNonExcluded(i+1);
			
			// be sure to get some random blocks which are within the limits imposed
			// by the excluded vs non-excluded block lists ...
			randomizeCurrentBlocks();

			// make sure both blocks are visible at this time ... 
			showCurrentBlocks();
		}
		/*
			Getter: heightInBlocks

			Returns the height of the board in blocks.
		*/
		public function get heightInBlocks():uint
		{
			return mHeightInBlocks;
		}
		/*
			Getter: widthInBlocks

			Returns the width of the board in blocks.
		*/
		public function get widthInBlocks():uint
		{
			return mWidthInBlocks;
		}
		/*
			Method: setCurrentRow

			Sets the currently active row index.

			Paramaters:
				pIndex - the desired active row index
		*/
		public function setCurrentRow(pIndex:uint):void
		{
			mCurrY = pIndex;
		}
		/*
			Method: shiftCurrentRow

			Shifts the blocks on the current row by one position
			if possible.

			Paramaters:
				pFacing - the desired direction

			Returns TRUE if the blocks has been shifted; otherwise FALSE.
		*/
		public function shiftCurrentRow(pFacing:uint):Boolean
		{
			var b:lrBlock;
			var bb:lrBlock;
			var i:int = 0;
			var first:int = -1;
			var last:int = -1;

			// locate the first and last empty blocks
			for(i=0;i<mWidthInBlocks;i++)
			{
				b = blockAt(i,mCurrY);
				if((b!=null) && (!b.empty)) continue;

				if(first == -1) first = i;
				last = i;
			}

			if(pFacing == FlxSprite.LEFT)
			{
				// edge cases when we don't want and cannot shift
				if( last == -1 ||
					last ==  0 ||
					last == mWidthInBlocks - 1 )
					return false;

				// if there is a pillar abort the operation
				for(i=last;i<mWidthInBlocks;i++)
				{
					b = blockAt(i,mCurrY);
					if((b!=null) && b.pillar) return false;
				}

				// shift by swapping
				for(i=last;i<mWidthInBlocks-1;i++)
					swapCurrentRowBlocks(i, i+1);


				// FIXME: DRY
				b = blockAtSafe(last-1,mCurrY);
				if((b!=null) && b.type == lrBlock.GHOST)
				{
					bb = blockAtSafe(last,mCurrY);
					if((bb!=null) && bb.type != lrBlock.GHOST && bb.type != lrBlock.PILLAR) 
						b.type = bb.type;
				}
				b = blockAtSafe(last,mCurrY);
				if((b!=null) && b.type == lrBlock.GHOST)
				{
					bb = blockAtSafe(last-1,mCurrY);
					if((bb!=null) && bb.type != lrBlock.GHOST && bb.type != lrBlock.PILLAR) 
						b.type = bb.type;
				}

				return true;
			}

			if(pFacing == FlxSprite.RIGHT)
			{
				// edge cases when we don't want and cannot shift
				if( first == -1 ||
					first ==  0 ||
					first == mWidthInBlocks - 1 )
					return false;

				// if there is a pillar abort the operation
				for(i=0;i<first;i++)
				{
					b = blockAt(i,mCurrY);
					if((b!=null) && b.pillar) return false;
				}

				// shift by swapping
				for(i=first;i>=1;i--)
					swapCurrentRowBlocks(i, i-1);

				// FIXME: DRY
				b = blockAtSafe(first+1,mCurrY);
				if((b!=null) && b.type == lrBlock.GHOST)
				{
					bb = blockAtSafe(first,mCurrY);
					if((bb!=null) && bb.type != lrBlock.GHOST && bb.type != lrBlock.PILLAR) 
						b.type = bb.type;
				}
				b = blockAtSafe(first,mCurrY);
				if((b!=null) && b.type == lrBlock.GHOST)
				{
					bb = blockAtSafe(first+1,mCurrY);
					if((bb!=null) && bb.type != lrBlock.GHOST && bb.type != lrBlock.PILLAR) 
						b.type = bb.type;
				}

				return true;
			}

			return false;
		}
		/*
			Method: setOnBlocksKilled
			
			Sets the callback to be called after the destruction of a given
			number of blocks of the same type.
			
			Paramaters:
				pOnBlocksKilled - callback
				
			See also:
				<setOnGameOver>
		*/
		public function setOnBlocksKilled(pOnBlocksKilled:Function):void
		{
			mOnBlocksKilled = pOnBlocksKilled;
		}
		/*
			Method: setOnGameOver
			
			Sets the callback to be called on game over.
			
			Parameters:
				pOnGameOver - callback
				
			See also:
				<setOnBlocksKilled>
		*/
		public function setOnGameOver(pOnGameOver:Function):void
		{
			mOnGameOver = pOnGameOver;
		}
		/*
			Function: currentBezier

			Paramaters:
				pBlock - the current block index

			Returns the currently active block's bezier curve.
		*/
		public function currentBezier(pBlock:uint):lrBezier
		{
			return mBeziers[pBlock] as lrBezier;
		}
		/*
			Function: currentBlock

			Paramaters:
				pBlock - the current block index

			Returns the currently active block.
		*/
		public function currentBlock(pBlock:uint):lrBlock
		{
			return mBlocks[pBlock][mCurrentBlocks[pBlock]] as lrBlock;
		}
		/*
			Function: currentBlockHightlight

			Paramaters:
				pBlock - the current block index

			Returns the currently active block's hightlight.
		*/
		public function currentBlockHighlight(pBlock:uint):lrBlock
		{
			return mBlocksHightlights[pBlock][mCurrentBlocks[pBlock]] as lrBlock;
		}
		/*
			Function: currentTarget

			Paramaters:
				pBlock - the current block index

			Returns the target for the currently active block.
		*/
		public function currentTarget(pBlock:uint):FlxPoint
		{
			return mCurrentTargets[pBlock] as FlxPoint;
		}
		/*
			Method: showCurrentBlock
			
			Shows the currently active block.

			Parameters:
				pBlock - the current block index
		*/
		public function showCurrentBlock(pBlock:uint):void
		{
			currentBlock(pBlock).visible = true;
		}
		/*
			Method: hideCurrentBlock
			
			Hides the currently active block.

			Paramaters:
				pBlock - the current block index
		*/
		public function hideCurrentBlock(pBlock:uint):void
		{
			currentBlock(pBlock).visible = false;
		}
		/*
			Function: isCurrentBlockExcluded

			Paramaters:
				pBlock - the current block index

			Returns TRUE if the current block is on the excluded blocks list; otherwise FALSE.
		*/
		public function isCurrentBlockExcluded(pBlock:uint):Boolean
		{
			return (mExcludedBlocks.indexOf(currentBlock(pBlock).type) != -1);
		}
		/*
			Function: isCurrentBlockMoving

			Paramaters:
				pBlock - the current block index

			Returns TRUE if the currently active block is moving.
		*/
		public function isCurrentBlockMoving(pBlock:uint):Boolean
		{
			return currentBlock(pBlock).moving;
		}
		/*
			Function: areCurrentBlocksMoving

			Convenience function to check both currently moving block's moving status.
		*/
		public function areCurrentBlocksMoving():Boolean
		{
			return (isCurrentBlockMoving(0) || isCurrentBlockMoving(1));
		}
		/*
			Method: randomizeCurrentBlock
			
			Randomize the currently active block.

			Paramaters:
				pBlock - the current block index
		*/
		public function randomizeCurrentBlock(pBlock:uint):void
		{
			// FIXME: better random?
			mCurrentBlocks[pBlock] = lrUtils.randomNumber(lrBlock.NUM);

			if(mGameMode == lrGame.GAME_CLASSIC)
			{
				switch(mNonExcludedBlocks.length)
				{
					case 0:
					break;

					case 1:
					{
						mCurrentBlocks[pBlock] = (mNonExcludedBlocks[0]-1);
					}
					break;

					case 2:
					{
						mCurrentBlocks[pBlock] = (mNonExcludedBlocks[lrUtils.randomNumber(2)]-1);
					}
					break;

					default:
					{
						var i:int = 0;
						while(++i<10000)
						{
							if(!isCurrentBlockExcluded(pBlock)) break;
							mCurrentBlocks[pBlock] = lrUtils.randomNumber(lrBlock.NUM);
						}

						// FIXME: this should never ever happen!
						if(i == 10000)
							FlxG.log('------------- FIXME: BUMMMMMEEERRRRRRRR --------');
					}
					break;
				}
			}

			updateCurrentBlock(pBlock); // reset position and other properties
		}
		/*
			Method: canSpawnCurrentBlock

			Parameters:
				pBlock - the current block index
		*/
		public function canSpawnCurrentBlock(pBlock:uint):Boolean
		{
			var idx:Number = pBlock * (mWidthInBlocks-1);
			return ((blockAt(idx, mCurrY).type == lrBlock.EMPTY) || 
					(currentTarget(pBlock).x == idx));
		}
		/*
			Method: spawnCurrentBlock

			Paramaters:
				pBlock - the current block index
		*/
		public function spawnCurrentBlock(pBlock:uint):void
		{
			// setup the current target
			var t:FlxPoint = currentTarget(pBlock);
			t.y = y + (mCurrY * lrBlock.HEIGHT);
			
			switch(pBlock)
			{
				case 0:
					t.x = x - lrBlock.WIDTH;
					break;

				case 1:
					t.x = x + width;
					break;
			}

			// setup and launch the current block
			var f:uint = FlxU.abs(1-pBlock) + 2;

			var b:lrBlock = currentBlock(pBlock);
			b.alpha = 0.5;
			switch(f)
			{
				case FlxSprite.UP:
				{
					b.y = y + (mHeightInBlocks * lrBlock.HEIGHT);
				}
				break;

				case FlxSprite.DOWN:
				{
					b.y = y - lrBlock.HEIGHT;
				}
				break;
			}
			b.facing = f;
			b.moving = true;
		}
		/*
		    Function: canLaunchCurrentBlock

			Paramaters:
				pBlock - the current block index

			Returns the launchable status of the current block.
		*/
		public function canLaunchCurrentBlock(pBlock:uint):Boolean
		{
			var t:FlxPoint = updateCurrentTarget(pBlock);

			if(t.x == -1 || t.y == -1) 
			{
				//FlxG.log("No empty space found for "+pBlock);
				return false;
			}

			return true;
		}
		/*
			Function: launchCurrentBlock

			Launches the currently active block.

			Paramaters:
				pBlock - the current block index

			Returns TRUE if the block can and has been launched, FALSE otherwise.
		*/
		public function launchCurrentBlock(pBlock:uint):Boolean
		{
			// the block is moving so block this ...
			if(isCurrentBlockMoving(pBlock)) 
			{
				//FlxG.log(pBlock+" is still moving");
				return false;
			}

			// cannot launch?
			if(!canLaunchCurrentBlock(pBlock))
			{
				// cannot shift?
				if(!shiftCurrentRow(FlxU.abs(1-pBlock)))
				{
					//FlxG.log("Cannot shift " + mCurrY + " row");
					return false;
				}
				else
				{
					mRowShifted = true;
				}
			}

			// setup and launch the current block
			var b:lrBlock = currentBlock(pBlock);
			b.facing = FlxU.abs(1-pBlock);
			b.moving = true;

			return true;	
		}
		/*
			Method: spawnCurrentBlocks

			Convenience method to spawn both currently active blocks.
		*/
		public function spawnCurrentBlocks():void
		{
			spawnCurrentBlock(0);
			spawnCurrentBlock(1);
		}
		/*
			Method: launchCurrentBlocks

			Convenience method to launch both currently active blocks.
		*/
		public function launchCurrentBlocks():void
		{
			launchCurrentBlock(0);
			launchCurrentBlock(1);
		}
		/*
			Method: showCurrentBlocks

			Convenience method to show both currently active blocks.
		*/
		public function showCurrentBlocks():void
		{
			showCurrentBlock(0);
			showCurrentBlock(1);
		}
		/*
			Method: hideCurrentBlocks

			Convenience method to hide both currently active blocks.
		*/
		public function hideCurrentBlocks():void
		{
			hideCurrentBlock(0);
			hideCurrentBlock(1);
		}
		/*
			Method: randomizeCurrentBlocks

			Convenience method to randomize both currently active blocks.
		*/
		public function randomizeCurrentBlocks():void
		{
			randomizeCurrentBlock(0);
			randomizeCurrentBlock(1);
		}
		/*
			Method: swapCurrentBlocks

			Swaps the two active blocks.
		*/
		public function swapCurrentBlocks():void
		{
			if(mCurrentBlocksSwapping || areCurrentBlocksMoving()) return;

			mCurrentBlocksSwapping = true;

			// bezier curve 1
			var bc1:lrBezier = currentBezier(0);
			// bezier curve 2
			var bc2:lrBezier = currentBezier(1);

			var b1:lrBlock = currentBlock(0);
			var b2:lrBlock = currentBlock(1);

			// start and end
			bc1.startPoint	= b1.position;
			bc1.endPoint	= b2.position;

			bc2.startPoint	= b2.position;
			bc2.endPoint	= b1.position;

			// control point 
			// FIXME: precompute these once!
			var hw1:uint = ((b1.x + x + width) / 2) - 50;
			var hw2:uint = ((b2.x + x + width) / 2) - 50;
			var hh:uint = 100; // magick number?

			// FIXME: take the block height in account
			// when calculating the relative height for the
			// control points
			bc1.controlPointOne = new FlxPoint(hw1,b1.y - (2*hh));
			bc1.controlPointTwo = new FlxPoint(hw2,b1.y - (2*hh));

			bc2.controlPointOne = new FlxPoint(hw1,b2.y - (2*hh));
			bc2.controlPointTwo = new FlxPoint(hw2,b2.y - (2*hh));

			// launch the blocks
			b1.facing = 5; // no direction
			b1.moving = true;

			b2.facing = 5; // no direction
			b2.moving = true;

			//FlxG.log("Swapping blocks ...");
		}
		/*
			Method: killCurrentRow

			Kills surounding blocks on a row.
		*/
		public function killCurrentRow():void
		{
			for(var x:uint=0;x<mWidthInBlocks;x++)
			{
				var b:lrBlock = blockAt(x,mCurrY);
				if(!b.block) continue; // skip any non-blocks

				var matches:Array = matchBlocks(x,mCurrY,b.type,MATCH_ALL);
				var l:uint = matches.length;
				if(l < 3) continue; // skip if less than 3 blocks

				var t:uint = b.type;

				// emit callback
				mOnBlocksKilled(t,matches);

				if(mGameMode == lrGame.GAME_CLASSIC)
					updateExcludedNonExcluded(t);
			}
		}
		/*
			Method: updateExcludedNonExcluded

			Paramaters:
				pType - the block type
		*/
		private function updateExcludedNonExcluded(pType:uint):void
		{
			var i:uint = 0;

			if(mExcludedBlocks.indexOf(pType)==-1 && firstBlock(pType)==null)
			{
				// Last block type, but we got some more ghost blocks so let the player
				// enjoy these last moments destroying them ... just for fun :D
				if(mExcludedBlocks.length == lrBlock.NUM - 1 && firstBlock(lrBlock.GHOST)!=null)
					return;
				
				//FlxG.log("added type "+pType+" to the excluded blocks list");
				mExcludedBlocks.push(pType);

				// reset the non excluded list of blocks
				mNonExcludedBlocks.length = 0;
				for(i=0;i<lrBlock.NUM;i++)
				{
					if(mExcludedBlocks.indexOf(i+1) == -1)
						mNonExcludedBlocks.push(i+1);
				}
			}
		}
		/*
			Method: updateTime
		*/
		private function updateTime():void
		{
			if(mLevelTime > 0) 
			{
				mLevelTime -= FlxG.elapsed;
				
				if(mLevelTime < 0) mLevelTime = 0;
			}
		}
		/*
			Method: update
		*/
		override public function update():void
		{
			super.update();
			
			if(gameOver || gameMode == lrGame.GAME_IDLE) 
				return;
			
			updateCurrentBlocks();
			updateGameOver();

			if(mGameMode == lrGame.GAME_CLASSIC)
				updateTime();
		}
		/*
			Method: renderMembers
			
			Renders memebers in the correct order.
		*/
		override protected function renderMembers():void
		{
			// Render Board Group Members
			var b:lrBlock, bh:lrBlock;
			for(var yy:uint=0;yy<mHeightInBlocks;yy++)
			{
				// Render Block Tile Glow
				if(yy == mCurrY) // current row only!
				{
					for(var xxx:Number=0;xxx<mWidthInBlocks;xxx++)
					{
						b = blockAt(xxx,yy);
						if((b != null) && (!b.exists || !b.visible))
						{
							mBlockTileGlow.position = b.position;
							mBlockTileGlow.render();
						}
					}
				}

				// Render Block 2
				if(yy == mCurrY)
				{
					b = currentBlock(1);
					if(b.visible)
					{
						bh = currentBlockHighlight(1);
						bh.position = b.position;

						b.render();
						bh.render();
					}
				}

				// Render "Regular" Blocks
				for(var xx:Number=mWidthInBlocks-1;xx>=0;xx--)
				{
					b = blockAt(xx,yy);
					if((b != null) && b.exists && b.visible)
						b.render();
				}

				// Render Block 1
				if(yy == mCurrY)
				{
					b = currentBlock(0);
					if(b.visible) 
					{
						bh = currentBlockHighlight(0);
						bh.position = b.position;

						b.render();
						bh.render();
					}
				}
			}
		}
		/*
			Method: updateGameOver

			Updates the Game Over state.
		*/
		private function updateGameOver():void
		{
			// classics mode special conditions, board cleared or time up!
			if(mGameMode == lrGame.GAME_CLASSIC)
			{
				// all blocks excluded?
				if(mExcludedBlocks.length == lrBlock.NUM)
					mGameOver = GAMEOVER_LEVEL;
				else if(mLevelTime == 0) // time reached 0?
					mGameOver = GAMEOVER_TIME;

				// emit onGameOver once ...
				if(gameOver)
				{
					hideCurrentBlocks();
					mOnGameOver(mGameOver);
					return;
				}
			}

			var b:lrBlock;
			var i:uint = 0;
			var l:uint = members.length;
		
			// if the board is full the game is over regardless
			// of the initial game type you've chosen ...
			mGameOver = GAMEOVER_NOMOVE;
			for(i=0;i<l;i++)
			{
				b = members[i] as lrBlock;
				if((b!=null) && b.empty)
				{
					mGameOver = GAMEOVER_FALSE;
					break;
				}
			}

			// emit onGameOver once ...
			if(gameOver)
			{
				hideCurrentBlocks();
				mOnGameOver(mGameOver);
			}
		}
		/*
			Method: updateCurrentTarget

			Updates the currently active target.

			Paramaters:
				pBlock - the current block index

			Returns the updated currently active target.
		*/
		private function updateCurrentTarget(pBlock:uint):FlxPoint
		{
			var xx:int = -1;
			var yy:int = mCurrY;

			var b:lrBlock;
			var first:int = -1;
			var last:int = -1;

			// locate the first and last non-empty blocks
			for(var i:uint=0;i<mWidthInBlocks;i++)
			{
				b = blockAt(i, mCurrY);
				if((b!=null) && b.empty) continue;

				if(first == -1) first = i;
				last = i;
			}

			// the current row is empty?
			if(first == -1 && last == -1)
			{
				xx = mHalfWidthInBlocks + (pBlock-1);
			}
			else
			{
				if(pBlock == 0 && first > 0) // left, first half
				{
					xx = first - 1;
				}
				else if(pBlock == 1 && last < mWidthInBlocks - 1) // right, second half
				{
					xx = last + 1;
				}
			}

			var t:FlxPoint = currentTarget(pBlock);
			t.x = xx;
			t.y = yy;

			return t;
		}
		/*
			Method: updateCurrentBlocks

			Convenience method to update both currently active blocks.
		*/
		private function updateCurrentBlocks():void
		{
			updateCurrentBlock(0);
			updateCurrentBlock(1);
		}
		/*
			Method: updateCurrentBlockSwapping
		*/
		private function updateCurrentBlockSwapping(pB:lrBlock, pBzc:lrBezier):void
		{
			// end of line?
			if(pBzc.isAtEnd) 
			{
				// reset and stop motion
				pBzc.reset();
				pB.moving = false;
			}
			else
			{
				// move to the new position
				pB.position = pBzc.update(FlxG.elapsed);
			}

			// will happen after both blocks have landed
			if(!areCurrentBlocksMoving())
			{								
				// get out of block swap mode
				mCurrentBlocksSwapping = false;

				// swap
				var tmp:uint = mCurrentBlocks[0];
				mCurrentBlocks[0] = mCurrentBlocks[1];
				mCurrentBlocks[1] = tmp;

				// pre-update
				updateCurrentBlocks();

				// make sure they are visible
				showCurrentBlocks();
			}
		}
		/*
			Method: updateCurrentBlockHorizontal
		*/
		private function updateCurrentBlockHorizontal(pBlock:uint, pB:lrBlock):void
		{
			if(mRowShifted)	
			{
				//FlxG.log("rows have been shifted so update targets ...");
				updateCurrentTarget(pBlock);
				//updateCurrentTarget(1);
				
				//mRowShifted = false;
			}

			// FIXME: digg into this 
			var t:FlxPoint = currentTarget(pBlock);
			if(t.x == -1 || t.y == -1)
			{
				//FlxG.log("FIXME: this should never happen!");
				pB.moving = false;
				return;
			}

			var s:FlxPoint = mapLocalToScreen(t.x, t.y);
			var stop:Boolean = false;

			switch(pBlock)
			{
				case 0:
					if(pB.x > s.x) stop = true;
					break;

				case 1:
					if(pB.x < s.x) stop = true;
					break;
			}

			if(stop)
			{
				blockAt(t.x,t.y).type = pB.type;
				pB.moving = false;

				// FIXME: DRY
				var dir:int = 2 * FlxU.abs(1-pBlock) - 1.0; // [0,1] to [-1,1]
				var bb:lrBlock = blockAtSafe(t.x+dir,t.y);
				if((bb!=null) && bb.type == lrBlock.GHOST)
					bb.type = pB.type;

				// hide the current block
				hideCurrentBlock(pBlock);

				// get a new one
				randomizeCurrentBlock(pBlock);

				// play block hit sound
				// FlxG.play(lrResources.lrSoundHit);

				// both blocks landed 
				if(!areCurrentBlocksMoving())
				{
					mRowShifted = false;

					killCurrentRow();
					//updateGameOver();

					if(!gameOver)
					{
						// refresh blocks if necessary taking extra
						// care to don't refresh them if not launched, etc.

						if(isCurrentBlockExcluded(0))
							randomizeCurrentBlock(0);

						if(isCurrentBlockExcluded(1))
							randomizeCurrentBlock(1);

						if(canSpawnCurrentBlock(0))
							spawnCurrentBlock(0);

						if(canSpawnCurrentBlock(1))
							spawnCurrentBlock(1);

						// show blocks
						showCurrentBlocks();
					}
					else
					{
						// hide both just in case one wasn't launched
						hideCurrentBlocks();
					}
				}
			}
		}
		/*
			Method: updateCurrentBlockVertical
		*/
		private function updateCurrentBlockVertical(pBlock:uint, pB:lrBlock):void
		{
			var t:FlxPoint = currentTarget(pBlock);
			var d:uint = 32;

			switch(pBlock)
			{
				case 0:
					if(pB.y >= t.y - d)
					{
						pB.moving = false;
						pB.alpha = 1.0;
					}
					break;

				case 1:
					if(pB.y <= t.y + d) 
					{
						pB.moving = false;
						pB.alpha = 1.0;
					}
					break;
			}
		}
		/*
			Method: updateCurrentBlock

			Updates the currently active block.

			Paramaters:
				pBlock - the current block index
		*/
		private function updateCurrentBlock(pBlock:uint):void
		{
			// grab the current block
			var b:lrBlock = currentBlock(pBlock);
			
			// Update internals
			b.update();

			// Detour if we are moving
			if(b.moving)
			{
				// swapping the two currently active blocks
				if(mCurrentBlocksSwapping)
					updateCurrentBlockSwapping(b, currentBezier(pBlock));
				// spawning of new blocks => top <=> down
				else if(b.facing == FlxSprite.UP || b.facing == FlxSprite.DOWN)
					updateCurrentBlockVertical(pBlock, b);
				// spawning of existing blocks => left <=> right
				else if(b.facing == FlxSprite.LEFT || b.facing == FlxSprite.RIGHT)
					updateCurrentBlockHorizontal(pBlock, b);

				if(b.moving) return;
			}

			// Reset the initial launch position based on player movement
			b.y = y + (mCurrY * lrBlock.HEIGHT);
			
			switch(pBlock)
			{
				case 0:
					b.x = x - lrBlock.WIDTH;
					break;

				case 1:
					b.x = x + width;
					break;
			}
		}
		/*
			Method: swapCurrentRowBlocks

			Paramaters:
				pX1 - position on the X axis of the first block
				pX2 - position on the X axis of the second block

			Swaps two blocks on the current row.
		*/
		private function swapCurrentRowBlocks(pX1:uint, pX2:uint):void
		{
			// get the two blocks
			var b1:lrBlock = blockAt(pX1, mCurrY);
			var b2:lrBlock = blockAt(pX2, mCurrY);

			/*
				Notes: we could just swap the types using one
				temporary variable, but we need to offset back
				the presents to their original type value.

				This should be handled at the <lrBlock> level,
				but for now it's OK :D
			*/
			var t1:uint = b1.type;
			if(t1 > 0 && b1.present)
				t1 += lrBlock.NUM;

			var t2:uint = b2.type;
			if(t2 > 0 && b2.present)
				t2 += lrBlock.NUM;

			// swap the types
			b1.type = t2;
			b2.type = t1;
		}
		/*
			Method: matchBlock

			Paramaters:
				pX - initial position on the X axis
				pY - initial position on the Y axis
				pMatcher - callback function
				pDir - direction(s) to match

			Recursive "matcher" which will explore blocks in "4" directions.
		*/
		private function matchBlock(pX:uint, pY:uint, pMatcher:Function, pDir:int):void
		{
			// Match itself?
			// if(!pMatcher(pX, pY)) return;
					
			// Try to go left and match
			if(pDir & MATCH_LEFT && pMatcher(pX-1, pY)) matchBlock(pX-1, pY, pMatcher, pDir);

			// Try to go right and match
			if(pDir & MATCH_RIGHT && pMatcher(pX+1, pY)) matchBlock(pX+1, pY, pMatcher, pDir);

			// Try to go up and match
			if(pDir & MATCH_UP && pMatcher(pX, pY-1)) matchBlock(pX, pY-1, pMatcher, pDir);

			// Try to go down and match
			if(pDir & MATCH_DOWN && pMatcher(pX, pY+1)) matchBlock(pX, pY+1, pMatcher, pDir);
		}
		/*
			Function: matchBlocks

			Paramaters:
				pX - initial position on the X axis
				pY - initial position on the Y axis
				pType - desired block type
				pDir - direction(s) to match

			Returns an array of matched blocks of the given type.
		*/
		private function matchBlocks(pX:uint, pY:uint, pType:uint, pDir:int):Array
		{
			mTmp1Array.length = 0; // matches
			mTmp2Array.length = 0; // visited

			// internal matcher method
			var matcher:Function = function(pX:uint, pY:uint):Boolean
			{
				var b:lrBlock = blockAtSafe(pX, pY); // fetch the block
				if(b==null) return false; // cannot go any further
				if(mTmp2Array.indexOf(b) != -1) return false; // already visited
				
				// do we have a match? Oh YEAH!
				if(b.type == pType)
				{
					mTmp1Array.push(b); // add it to matches
					mTmp2Array.push(b); // mark it as visited
					return true;
				}

				mTmp2Array.push(b); // mark it as visited
				return false;
			}

			// start the recursive matcher
			matchBlock(pX, pY, matcher, pDir);

			// we could just access this internal "cache" array inside
			// the lrBoard class, but we are returning it for the sake
			// of clarity and simplicity
			return mTmp1Array;
		}
		/*
			Method: transformBlocks

			Paramaters:
				pX - position on the X axis
				pY - position on the Y axis
				pS - the source block type (the ones to search for)
				pD - the destination block type (the ones to transform into)
				pDir - direction(s) to transform blocks

			Transforms blocks surounding the given position.
		*/
		private function transformBlocks(pX:uint, pY:uint, pS:uint, pD:uint, pDir:int):void
		{
			var matches:Array = matchBlocks(pX, pY, pS, pDir);

			var l:uint = matches.length;
			for(var i:uint=0;i<l;i++)
				matches[i].type = pD;

			//FlxG.log(matches.length + " blocks transformed");
		}
		/*
			Function : firstBlock
			
			Paramaters:
				pType - the desired block type

			Returns the first block matching the give type; otherwise NULL.
		*/
		private function firstBlock(pType:uint):lrBlock
		{
			var b:lrBlock;
			var l:uint = members.length;
			for(var i:uint=0;i<l;i++)
			{
				b = members[i] as lrBlock;
				if((b!=null) && b.type == pType)
					return b;
			}

			return null;
		}
		/*
			Function: blockAtSafe

			Paramaters:
				pX - position on the X axis
				pY - position on the Y axis

			Convenience function which is basically a blockAt() with bounds check.

			Returns the block at the given local X, Y coordinates or NULL if out of bounds.
		*/
		private function blockAtSafe(pX:uint, pY:uint):lrBlock
		{
			// verify bounds on the X axis
			if(pX < 0 || pX > mWidthInBlocks - 1) return null;
			// verify bounds on the Y axis
			if(pY < 0 || pY > mHeightInBlocks - 1) return null;
			// return the block
			return blockAt(pX, pY);
		}
		/*
			Function: blockAt

			Paramaters:
				pX - position on the X axis
				pY - position on the Y axis

			Returns the block at the given local X, Y coordinates.
		*/
		private function blockAt(pX:uint, pY:uint):lrBlock
		{
			return (members[offsetFromPoint(pX,pY)] as lrBlock);
		}
		/*
			Function: offsetFromPoint
			
			Calculates the offset for a given point.
			
			Paramaters:
				pX - position on the X axis
				pY - position on the Y axis
				
			Returns the offset in the 1D array.
 		*/
		private function offsetFromPoint(pX:uint, pY:uint):uint
		{
			return pX + (pY * mWidthInBlocks);
		}
		/*
			Function: pointFromOffset
			
			Paramaters:
				pOffset - the offset
				pScreenSpace - flag to return the point in screen space (default: false)
			
			Returns the local coordinates for the given offset in the 1D array.
		*/	
		private function pointFromOffset(pOffset:uint, pScreenSpace:Boolean=false):FlxPoint
		{
			var point:FlxPoint = new FlxPoint(0,0);
			point.y = FlxU.floor(pOffset / mWidthInBlocks);
			point.x = pOffset - (point.y * mWidthInBlocks);
			if(pScreenSpace)
			{
				point.x *= lrBlock.WIDTH;
				point.y *= lrBlock.HEIGHT;
				
				// offset relative to the group
				point.x += x;
				point.y += y;
			}
			return point;
		}
		/*
			Function: mapLocalToScreen

			Paramaters:
				pX - position on the X axis in local space
				pY - position on the Y axis in local space

			Returns the point in screen space.
		*/
		private function mapLocalToScreen(pX:uint, pY:uint):FlxPoint
		{
			return new FlxPoint(x + (pX * lrBlock.WIDTH), 
								y + (pY * lrBlock.HEIGHT));
		}
		/*
			Function: mapScreenToLocal

			Paramaters:
				pX - position on the X axis in screen space
				pY - position on the Y axis in screen space

			Returns the point in local space.
		*/
		private function mapScreenToLocal(pX:uint, pY:uint):FlxPoint
		{
			return new FlxPoint(FlxU.floor((pX - x) / lrBlock.WIDTH),
								FlxU.floor((pY - y) / lrBlock.HEIGHT));
		}
		/*
			Method: onBlocksKilled
			
			Default callback. 

			Paramaters:
				pType - block type
				pMatches - array of matched blocks
		*/
		private function onBlocksKilled(pType:uint, pMatches:Array):void
		{
			var l:uint = pMatches.length;
			for(var i:uint=0;i<l;i++)
				pMatches[i].kill();
		}
		/*
			Method: onGameOver
			
			Paramaters:
				pState - game over state

			Default callback.
		*/
		private function onGameOver(pState:uint):void
		{
			// do nothing by default
		}
		/*
			Method: clear
			
			Clears some reusable internals.

			FIXME: merge this with the constructor so we don't
			initialize these in two places, plus we will be able
			to call it in the constructor itself to reset these
			variables in a safe-initial-state.
		*/
		private function clear():void
		{
			// we can safely reset these
			setCurrentRow(0);

			mPointZero.x = 0;
			mPointZero.y = 0;

			mTmp1Array.length = 0;
			mTmp2Array.length = 0;
			mTmp3Array.length = 0;

			destroyMembers();

			mExcludedBlocks.length = 0;

			mNonExcludedBlocks.length = 0;
			for(var i:uint=0;i<lrBlock.NUM;i++)
				mNonExcludedBlocks.push(i+1);

			//
			mRowShifted = false;

			// 
			mGameOver = GAMEOVER_FALSE;

			// reset beziers
			currentBezier(0).reset();
			currentBezier(1).reset();
		}
	}
}
