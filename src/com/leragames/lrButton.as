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
	import org.flixel.FlxButton;
	/*
		Class: lrButton

		lrButton class.
	*/
	public class lrButton extends FlxButton
	{
		/*
			Constructor: lrButton
		*/
		public function lrButton(pX:uint, pY:uint, pCallback:Function, pText:String="Default", pWidth:uint=100)
		{
			super(pX, pY, pCallback);
	
			var t:lrText = new lrText(0,0,pWidth,pText);
			t.size = 32;
			t.alignment = "left";

			var h:lrText = new lrText(0,0,pWidth,pText);
			h.color = 0xFF788c9a;
			h.size = 32;
			h.alignment = "left";
	
			loadText(t,h);

			// FIXME: find a better way to hide these :P
			_on.alpha = 0;
			_off.alpha = 0;

			// FIXME: ugly!
			width = pWidth;
			height = t.size;
		}
		/*
			Setter: textActiveColor
			Sets the active color.
		*/
		public function set textActiveColor(pColor:uint):void
		{
			_offT.color = pColor;
		}
		/*
			Setter: textHoverColor
			Sets the hover color.
		*/
		public function set textHoverColor(pColor:uint):void
		{
			_onT.color = pColor;
		}
		/*
			Setter: textFont
			Sets the text font family.
		*/
		public function set textFont(pFontFace:String):void
		{
			_onT.font = pFontFace;
			_offT.font = pFontFace;
		}
		/*
			Setter: textSize
			Sets the text size.
		*/
		public function set textSize(pSize:uint):void
		{
			_onT.size = pSize;
			_offT.size = pSize;
			height = pSize; // FIXME: ugly?!
		}
		/*
			Setter: textLabel
			Sets the actual text.
		*/
		public function set text(pText:String):void
		{
			_onT.text = pText;
			_offT.text = pText;
		}
		/*
			Setter: shadow

			Sets shadow type.
		*/
		public function set shadow(pType:uint):void
		{
			_onT.shadow = pType;
			//_offT.shadow = pType;
		}
	}
}

