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
	import org.flixel.FlxSave;

	/*
		Class: lrStats
	*/
	public class lrStats
	{
		private var mSave:FlxSave;

		/*
			Constructor: lrStats
		*/
		public function lrStats()
		{
			mSave = new FlxSave();
			mSave.bind("AncestriaMiniStats");
		}
		/*
			Method: erase
		*/
		public function erase():void
		{
			mSave.erase();
		}
		/*
			Method: setValueForKey
		*/
		public function setValueForKey(pKey:String, pValue:Number):void
		{
			mSave.write(pKey, pValue);
		}
		/*
			Function: valueForKey
		*/
		public function valueForKey(pKey:String, pDefault:Number = 0):Number
		{
			var v:Object = mSave.read(pKey);
			return (v != null) ? (v as Number) : pDefault;
		}
		/*
			Getter: lastLevel
		*/
		public function get lastLevel():uint
		{
			return valueForKey('last_level');
		}
		/*
			Setter: lastLevel
		*/
		public function set lastLevel(pLevel:uint):void
		{
			if(pLevel > lastLevel)
			{
				setValueForKey('last_level', pLevel);
			}
		}
		public static var instance:lrStats = new lrStats();
	}
}

