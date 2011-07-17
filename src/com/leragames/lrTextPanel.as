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
	import org.flixel.FlxGroup;
	import org.flixel.FlxPoint;
	import org.flixel.FlxSprite;

	/*
		Class: lrTextPanel

		lrTextPanel class.
	*/
	public class lrTextPanel extends FlxGroup
	{
		private var mText:lrText;
		private var mTextPos:FlxPoint;
		private var mBackground:FlxSprite;
		private var mSeconds:uint;
		private var mElapsed:Number;

		/*
			Constructor: lrTextPanel
		*/
		public function lrTextPanel(pText:String)
		{
			super();
			
			var w:uint = 300; // FIXME: hardcoded!
			var h:uint = 156; // FIXME: hardcoded!
			var px:uint = (FlxG.width - w) / 2;
			var py:uint = (FlxG.height- h) / 2;
			
			mBackground = new FlxSprite(px, py,lrResources.lrPanelSmall);
			add(mBackground);

			mTextPos = new FlxPoint(px - w/2,(FlxG.height - 40) / 2);
			mText = new lrText(mTextPos.x, mTextPos.y, w+w, pText);
			mText.color = 0xFFFFFFFF;
			mText.size = 40;
			mText.shadow = 1;
			add(mText);

			visibility = 0; // default
		}
		/*
			Setter: color
		*/
		public function set color(pColor:uint):void
		{
			mText.color = pColor;
		}
		/*
			Getter: color
		*/
		public function get color():uint
		{
			return mText.color;
		}
		/*
			Setter: background

			Show / Hide background.
		*/
		public function set background(pState:Boolean):void
		{
			mBackground.visible = pState;

			if(mBackground.visible)
			{
				mText.x = mTextPos.x;
				mText.y = mTextPos.y;
			}
			else
			{
				mText.x = mTextPos.x + 100;
				mText.y = mTextPos.y - 50;
			}
		}
		/*
			Setter: text

			Sets the text of the panel.
		*/
		public function set text(pText:String):void
		{
			mText.text = pText;
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
			Method: hide

			Hide on-demand.
		*/
		public function hide():void
		{
			mSeconds = 0;
			mElapsed = 0;
			visible = false;
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

