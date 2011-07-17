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
	import org.flixel.FlxText;

	/*
		Class: lrText

		lrText class.
	*/
	public class lrText extends FlxText
	{
		private var mElapsed:Number;
		private var mSeconds:Number;

		/*
			Constructor: lrText
		*/
		public function lrText(pX:Number, pY:Number, pWidth:uint, pText:String)
		{
			super(pX, pY, pWidth, pText);

			// Defaults
			font = "Teutonic";
			size = 48;
			//color = 0xb5c4cf;
			//color = 0xbd0028;
			//color = 0x788c9a;
			color = 0x5b6a74;
			//shadow = 1;
			alignment = "center";

			visibility = 0; // default
		}
		/*
			Method: hide
		*/
		public function hide():void
		{
			visible = false;
		}
		/*
			Setter: toggle fade Out

			Paramaters:
				pSeconds - the number of seconds
		*/
		public function set visibility(pSeconds:uint):void
		{
			mSeconds = pSeconds;
			mElapsed = 0.0;
			
			visible = true;
		}
		/*
			Method: update
		*/
		override public function update():void
		{
			if(mSeconds > 0 && visible)
			{
				mElapsed += FlxG.elapsed;
				visible = (mElapsed < mSeconds);
			}

			super.update();
		}
	}
}

