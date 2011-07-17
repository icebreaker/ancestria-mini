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
	import org.flixel.FlxSprite;
	import org.flixel.FlxPoint;
	import org.flixel.FlxEmitter;
	
	/*
		Class: lrBlock
		
		Block class.
	*/
	public class lrBlock extends FlxSprite
	{
		static public const NUM:Number = 6; // "spawn"-able block count
		static public const SPEEDX:Number = 400;
		static public const SPEEDY:Number = 1000;
		static public const WIDTH:Number = 34;
		static public const HEIGHT:Number = 34;

		// lrBlock type constants
		static public const EMPTY:uint	= 0;
		static public const PILLAR:uint = 13;
		static public const GHOST:uint	= 14;
		static public const GLOW:uint	= 15;
		static public const HIGHLIGHT:uint = 15;

		private var mPresent:Boolean;
		
		private var mKillEffectStars:FlxEmitter;
		private var mKillEffectMult:FlxEmitter;
		private var mKillEffectMultPresent:FlxEmitter;

		private var mPosition:FlxPoint;
		private var mMoving:Boolean;

		private var mType:uint;

		/*
			Constructor: lrBlock
			
			Paramaters:
				pPos		- initial position
				pType		- initial type of the block
		*/
		public function lrBlock(pPos:FlxPoint,pType:uint)
		{
			// FlxSprite.super
			super(pPos.x, pPos.y);

			// position point
			mPosition = new FlxPoint(0,0);

			// reset velocity
			velocity.x = 0;
			velocity.y = 0;

			// store type
			type = pType;

			// stop
			moving = false;

			// see kill()
			mKillEffectStars = null;
			mKillEffectMult = null;
			mKillEffectMultPresent = null;
		}
		/*
			Setter: type
			
			Sets the internal block type and loads the graphic.
			
			Paramaters:
				pType - the type of the block
		*/
		public function set type(pType:uint):void
		{
			// not moving by default
			mMoving = false;

			// not a present by default
			mPresent = false;

			// store the given type
			mType = pType;
			
			// load block graphics
			switch(mType) // FIXME: find a better strategy?!
			{
				case 0:
					break;
				case 1:
					loadGraphic(lrResources.lrBlock1);
					break;
				case 2:
					loadGraphic(lrResources.lrBlock2);
					break;
				case 3:
					loadGraphic(lrResources.lrBlock3);
					break;
				case 4:
					loadGraphic(lrResources.lrBlock4);
					break;
				case 5:
					loadGraphic(lrResources.lrBlock5);
					break;
				case 6:
					loadGraphic(lrResources.lrBlock6);
					break;
				case 7:
					loadGraphic(lrResources.lrBlockPS1);
					break;
				case 8:
					loadGraphic(lrResources.lrBlockPS2);
					break;
				case 9:
					loadGraphic(lrResources.lrBlockPS3);
					break;
				case 10:
					loadGraphic(lrResources.lrBlockPS4);
					break;
				case 11:
					loadGraphic(lrResources.lrBlockPS5);
					break;
				case 12:
					loadGraphic(lrResources.lrBlockPS6);
					break;
				case 13:
					loadGraphic(lrResources.lrBlockPI1);
					break;
				case 14:
					loadGraphic(lrResources.lrBlockG1);
					break;
				case 15:
					loadGraphic(lrResources.lrBlockTileGlow);
					break;
				case 16:
					loadGraphic(lrResources.lrBlockH1);
					break;
				case 17:
					loadGraphic(lrResources.lrBlockH2);
					break;
				case 18:
					loadGraphic(lrResources.lrBlockH3);
					break;
				case 19:
					loadGraphic(lrResources.lrBlockH4);
					break;
				case 20:
					loadGraphic(lrResources.lrBlockH5);
					break;
				case 21:
					loadGraphic(lrResources.lrBlockH6);
					break;
	
				default:
					break;
			}

			// Present and/or Joker blocks
			if(mType > lrBlock.NUM && mType <= (lrBlock.NUM+lrBlock.NUM))
			{
				mPresent = true;
				mType -= lrBlock.NUM; // 1..NUM
			}

			// Offset Highlights
			if(mType > lrBlock.HIGHLIGHT && mType <= (lrBlock.HIGHLIGHT+lrBlock.NUM))
			{
				mType -= lrBlock.HIGHLIGHT;
			}

			// hide if this is an empty block?
			visible = (empty) ? false : true;

			// reset internal states
			reset(x,y);

			// adjust the bounding box
			width = WIDTH;
			height= HEIGHT;
		}
		/*
			Method: setPosition

			Sets the position of the block from an <FlxPoint> .

			Paramaters:
				pPosition - <FlxPoint> containing the desired position
		*/
		public function setPosition(pPos:FlxPoint):void
		{
			x = pPos.x;
			y = pPos.y;
		}
		/*
			Setter: position

			Sets the position of the block.
		*/
		public function set position(pPos:FlxPoint):void
		{
			setPosition(pPos);
		}
		/*
			Getter: position

			Returns the position of the block.
		*/
		public function get position():FlxPoint
		{
			mPosition.x = x;
			mPosition.y = y;

			return mPosition;
		}
		/*
			Getter: block

			Returns TRUE if this is a destroyable "normal" block.
		*/
		public function get block():Boolean
		{
			return (mType>lrBlock.EMPTY && mType<=lrBlock.NUM);
		}
		/*
			Getter: present

			Returns TRUE if this is a present.
		*/
		public function get present():Boolean
		{
			return mPresent;
		}
		/*
			Getter: pillar

			Returns TRUE if this is a pillar; otherwise FALSE.
		*/
		public function get pillar():Boolean
		{
			return (mType == lrBlock.PILLAR);
		}
		/*
			Getter: ghost
			
			Returns TRUE if this is a ghost block; otherwise FALSE.
		*/
		public function get ghost():Boolean
		{
			return (mType == lrBlock.GHOST);
		}
		/*
			Getter: type
			
			Returns	the type of the block.
		*/
		public function get type():uint
		{
			return mType;
		}
		/*
			Getter: empty

			Returns the empty state.
		*/
		public function get empty():Boolean
		{
			return (mType==lrBlock.EMPTY);
		}
		/*
			Setter: moving

			Convenience function to stop movement of the block.
		*/
		public function set moving(pState:Boolean):void
		{
			if(pState)
			{
				// determine via facing where this block is heading
				switch(facing)
				{
					case FlxSprite.LEFT:
						velocity.x = -SPEEDX;
						break;
					case FlxSprite.RIGHT:
						velocity.x =  SPEEDX;
						break;
					case FlxSprite.UP:
						velocity.y = -SPEEDY;
						break;
					case FlxSprite.DOWN:
						velocity.y =  SPEEDY;
						break;
				}

				mMoving = true;
			}
			else// if(moving)
			{
				velocity.x = 0;
				velocity.y = 0;

				mMoving = false;
			}
		}
		/*
			Getter: moving

			Convenience function to determine if the block is moving.
		*/
		public function get moving():Boolean
		{
			return mMoving;
		}
		/*
			Function: clone
			
			Returns a clone of this block.
		*/
		public function clone():lrBlock
		{
			return new lrBlock(new FlxPoint(x,y),mType);		
		}
		/*
			Function: getScreenXY

			Paramaters:
				pPoint - position input / output

			Returns the final position of the block.
		*/
		override public function getScreenXY(pPoint:FlxPoint=null):FlxPoint
		{
			pPoint = super.getScreenXY(pPoint);
			switch(mType)
			{
				case lrBlock.PILLAR:
					pPoint.y -= 5;
					break;
				case lrBlock.GLOW:
					pPoint.y += 15;
					break;
			}
			return pPoint;
		}
		/*
			Method: kill

			Performs some additional logic on kill.
		*/
		override public function kill():void
		{
			// don't bother with empty blocks
			if(!empty)
			{
				//FlxG.play(lrResources.lrSoundHit);
				killEffect();

				// kill => empty
				type = lrBlock.EMPTY;
			}
		
			// do whatever the super class wants :|
			super.kill();
		}
		/*
			Method: killEffect
		*/
		private function killEffect():void
		{
			var game:lrGame = (FlxG.state as lrGame);
			if(game==null) return;

			if(mKillEffectMult == null)
			{
				// FIXME: this is hard-coded
				mKillEffectMult = game.effects.createMultiplier("10");
				mKillEffectMult.at(this);
			}

			if(mKillEffectMultPresent == null)
			{
				// FIXME: this is hard-coded
				mKillEffectMultPresent = game.effects.createMultiplier("50");
				mKillEffectMultPresent.at(this);
			}

			if(mKillEffectStars == null)
			{
				mKillEffectStars = game.effects.createSmoke();
				mKillEffectStars.at(this); 
			}

			var c:uint = colorForType(mType);

			// set the color
			lrEffects.setColor(mKillEffectStars, c);
			lrEffects.setColor(mKillEffectMult, c);
			lrEffects.setColor(mKillEffectMultPresent, c);

			// start it
			mKillEffectStars.start();

			// 
			if( present )
			{
				mKillEffectMultPresent.start();
			}
			else
			{
				mKillEffectMult.start();
			}
		}
		/*
			Function: colorForType

			Returns the color of the specified block type.
		*/
		static public function colorForType(pType:uint):uint
		{
			switch(pType)
			{
				case 1:
					return 0xFF2C7FC1;
				case 2:
					return 0xFF2CC1C2;
				case 3:
					return 0xFF777777;
				case 4:
					return 0xFF7B2CC2;
				case 5:
					return 0xFFC22B55;
				case 6:
					return 0xFFC29D2C;
			}

			return 0xFFFFFFFF;
		}
	}
}
