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
	import org.flixel.FlxButton;
	import org.flixel.FlxSprite;
	import org.flixel.FlxG;
	import flash.net.navigateToURL;
	import flash.net.URLRequest;
	
	/*
		Class: lrCredits

		lrCredits class.
	*/
	public class lrCredits extends FlxGroup
	{
		private var mBackground:FlxSprite;
		private var mLogo:FlxButton;
		private var mBtnOK:lrButton;
		private var mEnd:Boolean;

		/*
			Constructor: lrCredits
		*/
		public function lrCredits()
		{
			super();
			
			var w:uint = 576;
			var h:uint = 300;
			var px:uint = (FlxG.width - w) / 2;
			var py:uint = (FlxG.height- h) / 2;

			mBackground = new FlxSprite(px, py, lrResources.lrPanelLarge);
			add(mBackground);

			mLogo = new FlxButton(px + 10, py + 40, openWebsite);
			mLogo.loadGraphic(new FlxSprite(0, 0, lrResources.lrLogoSmall));
			add(mLogo);
			
			var txt:lrText = new lrText(px,py+50,w-20,"Ancestria: Mini");
			txt.alignment = "right";
			txt.size = 40;
			txt.color = 0xFFFFFFFF;
			txt.shadow = 1;
			add(txt);

			txt = new lrText(px+45,(py+h)-70,100,"v1.0.0");
			txt.size = 32;
			txt.color = 0xFFFFFFFF;
			txt.shadow = 1;
			add(txt);

			txt = new lrText(px,py+110,w-20,"Code: Mihail Szabolcs");
			txt.alignment = "right";
			txt.size = 22;
			txt.color = 0xFFFFFFFF;
			txt.shadow = 1;
			add(txt);

			txt = new lrText(px,py+140,w-20,"Art: Melissa Davidson");
			txt.alignment = "right";
			txt.size = 22;
			txt.color = 0xFFFFFFFF;
			txt.shadow = 1;
			add(txt);

			/*
			txt = new lrText(px,py+170,w-20,"Sounds & Music: That Dude");
			txt.alignment = "right";
			txt.size = 22;
			txt.color = 0xFFFFFFFF;
			txt.shadow = 1;
			add(txt);
			*/

			mBtnOK = new lrButton((px+w)-80, (py+h)-50,clickOK,"OK",80);
			mBtnOK.textActiveColor = 0xFFFFFFFF;
			mBtnOK.textHoverColor = 0xFFFFFFFF;
			mBtnOK.shadow = 1;
			add(mBtnOK);

			mEnd = false;
		}
		/*
			Method: clickOK
		*/
		public function clickOK():void
		{
			if(mEnd)
			{
				(FlxG.state as lrGame).startNext();
			}
			else
			{
				(FlxG.state as lrGame).gui.showGameStart();
			}
			hide();
		}
		/*
			Method: openWebsite

			Opens http://leragames.com/ in the default browser.
		*/
		public function openWebsite():void
		{
			navigateToURL(new URLRequest("http://leragames.com"));
		}
		/*
			Method: show

			Paramaters:
				pEnd - end credits state (on Game Over)

			Shows the credit screen.
		*/
		public function show(pEnd:Boolean):void
		{
			visible = true;
			mLogo.visible = true;
			mLogo.exists = true;
			mBtnOK.visible = true;
			mBtnOK.exists = true;
			mEnd = pEnd;
		}
		/*
			Method: hide

			Hides the credit screen.
		*/
		public function hide():void
		{
			visible = false;
			mLogo.visible = false;
			mLogo.exists = false;
			mBtnOK.visible = false;
			mBtnOK.exists = false;
			mEnd = false;
		}
	}
}

