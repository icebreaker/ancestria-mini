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
	import org.flixel.FlxButton;

	/*
		Class lrLevelButton
		
		lrLevelButton class.
	*/
	public class lrLevelButton extends FlxButton
	{
		private var mLevel:uint;

		/*
			Constructor: lrLevelButton
		*/
		public function lrLevelButton(pX:Number, pY:Number, pLevel:uint)
		{
			super(pX, pY, clicked);

			loadGraphic(new FlxSprite(0, 0, lrResources.lrFrameLocked),
						new FlxSprite(0, 0, lrResources.lrFrameUnlocked));

			var txt:lrText = new lrText(0, 12, 80, String(pLevel+1));
			txt.alignment = "center";
			txt.size = 22;
			txt.color = 0xFFFFFFFF;
			txt.shadow = 1;

			loadText(new lrText(0,0, 80,''), txt);

			locked = (pLevel == 0) ? false : true;
			mLevel = pLevel;
		}
		/*
			Method: update
		*/
		override public function update():void
		{
			super.update();

			visibility(false);
			if(_onToggle) visibility(_off.visible);
		}
		/*
			Setter: locked
		*/
		public function set locked(pState:Boolean):void
		{
			on = (pState == false);
		}
		/*
			Getter: locked
		*/
		public function get locked():Boolean
		{
			return (on == false);
		}
		/*
			Method: clicked
		*/
		public function clicked():void
		{
			if(locked == false)
			{
				(FlxG.state as lrGame).startClassic(mLevel);
			}
		}
	}
}
