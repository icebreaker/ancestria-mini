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

	/*
		Class: lrUtils

		lrUtils class.
	*/
	public class lrUtils
	{
		/*
			Function: randomNumber

			Returns a random number from 0..(n-1) .
		*/
		public static function randomNumber(pMax:uint):uint
		{
			var b:uint = FlxU.floor(FlxU.random() * pMax);
			return (b == pMax) ? --b : b; // guard!
		}
	}
}

