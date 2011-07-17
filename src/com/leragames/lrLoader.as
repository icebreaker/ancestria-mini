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
	import org.flixel.FlxPreloader;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFormat;

	/*
		Class: lrLoader

		Custom pre-loader class with centered logo and loading bar.
	*/
	public class lrLoader extends FlxPreloader
	{
		private var _frame:Bitmap;

		/*
			Constructor: lrLoader
		*/
		public function lrLoader()
		{
			// FlxPreloader.super
			super();

			className = "AncestriaMini";
			minDisplayTime = 2; // 2 seconds
		}
		/*
			Method: create

			Creates the logo and loading bar.
		*/
		override protected function create():void
		{
			_min = 0;
			if(!FlxG.debug)
				_min = minDisplayTime * 1000;

			_buffer = new Sprite();
			addChild(_buffer);

			_width = stage.stageWidth;
			_height = stage.stageHeight;
			_buffer.addChild(new Bitmap(new BitmapData(_width,_height,false,0x000000)));

			_logo = new lrResources.lrLogo();
			_logo.x = (_width-_logo.width)/2;
			_logo.y = ((_height-_logo.height)/2)-100;
			_buffer.addChild(_logo);

			// FIXME: find a better way to do this :D
			// If you are reading this, you have no life :P
			var b:BitmapData = new BitmapData(256,20,false,0x000000);
			for(var j:uint=0;j<b.height;j++)
			{
				for(var i:uint=0;i<b.width;i++)
				{
					b.setPixel(i,0,0xFFFFFF);
					b.setPixel(i,b.height-1,0xFFFFFF);
				}
				b.setPixel(0,j,0xFFFFFF);
				b.setPixel(b.width-1,j,0xFFFFFF);
			}

			_frame = new Bitmap(b);
			_frame.x = (_width-_frame.width)/2;
			_frame.y = ((_height-_frame.height)/2)+70;
			_buffer.addChild(_frame); // frame

			_bmpBar = new Bitmap(new BitmapData(1,12,false,0xFFFFFF));
			_bmpBar.x = _frame.x + 4;
			_bmpBar.y = ((_height-_bmpBar.height)/2)+70;
			_buffer.addChild(_bmpBar);
		}
		/*
			Method: update

			Paramaters:
				pPercent - how much has loaded
		*/
		override protected function update(pPercent:Number):void
		{
			_bmpBar.scaleX = FlxU.floor(pPercent*(_frame.width-8));
		}	
	}
}
