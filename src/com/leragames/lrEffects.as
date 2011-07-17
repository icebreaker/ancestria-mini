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
	import org.flixel.FlxGroup;
	import org.flixel.FlxEmitter;
	import org.flixel.FlxSprite;

	/*
		Class: lrEffects

		Provides helper methods for all available effects.
	*/
	public class lrEffects extends FlxGroup
	{
		/*
			Function: createSmoke

			Returns an "smoke" explosion like particle emitter.
		*/
		public function createSmoke():FlxEmitter
		{
			var emitter:FlxEmitter = new FlxEmitter();
			emitter.delay = 0.3;
			emitter.gravity = 0;
			emitter.maxRotation = 0;
			emitter.setXSpeed(-100, 100);
			emitter.setYSpeed(-100, 100);

			for(var i:uint=0;i<3;i++)
			{
				var particle:FlxSprite = new FlxSprite(0,0,lrResources.lrStar);
				//particle.color = 0xAACCAAAA;
				//particle.blend = "screen";
				//particle.blend = "overlay";
				particle.blend = "hardlight";
				particle.exists = false;
				emitter.add(particle);
			}

			add(emitter);
			return emitter;
		}
		/*
			Method: createMultiplier
		*/
		public function createMultiplier(pText:String, pX:Number = 0, pY:Number = 0, pDelay:Number = 0.6, pSize:Number = 16):FlxEmitter
		{
			var emitter:FlxEmitter = new FlxEmitter(pX, pY);
			emitter.delay = pDelay;
			emitter.gravity = 0;
			emitter.minRotation = 0;
			emitter.maxRotation = 0;
			emitter.setXSpeed(-100, 100);
			emitter.setYSpeed(-100, 0);

			var particle:lrText = new lrText(0,0,200,pText);
			particle.size = pSize;
			particle.color = 0xFFFFFFFF;
			particle.shadow = 1;
			//particle.color = 0xAACCAAAA;
			//particle.blend = "screen";
			//particle.blend = "overlay";
			particle.blend = "hardlight";
			particle.exists = false;
			emitter.add(particle);

			add(emitter);
			return emitter;
		}
		/*
			Method: setMultiplierText
		*/
		static public function setMultiplierText(pEmitter:FlxEmitter, pText:String):void
		{
			pEmitter.members[0].text = pText;
		}
		/*
			Method: setColor

			Paramaters:
				pColor - the new color
		*/
		static public function setColor(pEmitter:FlxEmitter, pColor:uint):void
		{
			var l:uint = pEmitter.members.length;
			for(var i:uint=0;i<l;i++)
				pEmitter.members[i].color = pColor;
		}
	}
}
