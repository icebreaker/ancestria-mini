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
	import org.flixel.FlxSprite;
	import org.flixel.FlxG;

	/*
		Class: lrGameStart

		lrGameStart class.
	*/
	public class lrGameStart extends FlxGroup
	{
		private const PAGES_NUM:uint = 5;

		private var mBtnNext:lrButton;
		private var mBtnPlay:lrButton;

		private var mBackground:FlxSprite;
		private var mPageCnt:lrText;
		private var mPage:uint;
		private var mPages:Array;

		/*
			Constructor: lrGameStart
		*/
		public function lrGameStart()
		{
			super();
			
			var txt:lrText = null;
			var grp:FlxGroup = null;

			var w:uint = 576;
			var h:uint = 300;
			var px:uint = (FlxG.width - w) / 2;
			var py:uint = (FlxG.height- h) / 2;

			mBackground = new FlxSprite(px, py, lrResources.lrPanelLarge);
			add(mBackground);
	
			mPageCnt = new lrText(px + (w-82),py+10,100,"1 of 5");
			mPageCnt.alignment = "left";
			mPageCnt.size = 22;
			mPageCnt.color = 0xFFFFFFFF;
			mPageCnt.shadow = 1;
			add(mPageCnt);

			mBtnNext = new lrButton(px + (w-100), py + (w / 2) - 40, clickNext, "Next", 85);
			mBtnNext.textActiveColor = 0xFFFFFFFF;
			mBtnNext.textHoverColor = 0xFFFFFFFF;
			mBtnNext.shadow = 1;
			add(mBtnNext);

			mBtnPlay = new lrButton(px + 20, py + (w / 2) - 40, clickPlay, "Play", 85);
			mBtnPlay.textActiveColor = 0xFFFFFFFF;
			mBtnPlay.textHoverColor = 0xFFFFFFFF;
			mBtnPlay.shadow = 1;
			add(mBtnPlay);

			mPages = new Array(PAGES_NUM);

			///////////////////////////////////////// Page One ///////////////////////////////////

			grp = new FlxGroup();

			txt = new lrText(px,py+50,w,"Ancestria: Mini");
			txt.alignment = "center";
			txt.size = 40;
			txt.color = 0xFFFFFFFF;
			txt.shadow = 1;
			grp.add(txt);

			txt = new lrText(px,py+140,w,"Click `Next` to proceed with the `Tutorial`\nor `Play` to start the game.");
			txt.alignment = "center";
			txt.size = 20;
			txt.color = 0xFFFFFFFF;
			txt.shadow = 1;
			grp.add(txt);

			add(grp);
			mPages[0] = grp;

			///////////////////////////////////////// Page Two ///////////////////////////////////

			grp = new FlxGroup();
		
			grp.add(new FlxSprite(px+60, py+40, lrResources.lrStep1));
		
			txt = new lrText(px,py+180,w,"Move the blocks on the border of the\n game field by using the mouse.");
			txt.alignment = "center";
			txt.size = 20;
			txt.color = 0xFFFFFFFF;
			txt.shadow = 1;
			grp.add(txt);
						
			add(grp);
			mPages[1] = grp;

			///////////////////////////////////////// Page Three ///////////////////////////////////

			grp = new FlxGroup();
		
			grp.add(new FlxSprite(px+60, py+40, lrResources.lrStep2));

			txt = new lrText(px,py+140,w,"Push blocks onto the game field\n by pressing the left mouse button.");
			txt.alignment = "center";
			txt.size = 20;
			txt.color = 0xFFFFFFFF;
			txt.shadow = 1;
			grp.add(txt);
	
			txt = new lrText(px,py+200,w,"Tip: Press space to swap the blocks\n on the border of the game field.");
			txt.alignment = "center";
			txt.size = 16;
			//txt.color = 0xFFFFFFFF;
			txt.color = 0xFFCFDBE7;
			txt.shadow = 1;
			grp.add(txt);
				
			add(grp);
			mPages[2] = grp;

			///////////////////////////////////////// Page Four ///////////////////////////////////

			grp = new FlxGroup();
		
			grp.add(new FlxSprite(px+40, py+30, lrResources.lrStep3));

			txt = new lrText(px+200,py+100,w-220,"Three or more blocks of the same color will create a combination.");
			txt.alignment = "center";
			txt.size = 20;
			txt.color = 0xFFFFFFFF;
			txt.shadow = 1;
			grp.add(txt);
	
			add(grp);
			mPages[3] = grp;

			///////////////////////////////////////// Page Five ///////////////////////////////////

			grp = new FlxGroup();
		
			grp.add(new FlxSprite(px + (w-180), py + 40, lrResources.lrStep4));

			txt = new lrText(px+20,py+100,w-220,"To win a level, clear the game field by creating combinations, before the time is up.");
			txt.alignment = "center";
			txt.size = 20;
			txt.color = 0xFFFFFFFF;
			txt.shadow = 1;
			grp.add(txt);
	
			add(grp);
			mPages[4] = grp;

			page = 0;
		}
		/*
			Method: clickNext
		*/
		public function clickNext():void
		{
			if(nextPage())
			{
				page = page + 1;
				
				if(!nextPage())
					mBtnNext.text = "Play";

				mBtnPlay.visible = false;
			}
			else
			{
				clickPlay();
			}
		}
		/*
			Method: clickPlay
		*/
		public function clickPlay():void
		{
			hide();
			(FlxG.state as lrGame).gui.showLevelBrowser();
		}
		/*
			Setter: page
		*/
		public function set page(pPage:uint):void
		{
			for(var i:uint=0;i<PAGES_NUM;i++)
				mPages[i].visible = (i == pPage);

			mPage = pPage;
			mPageCnt.text = String(uint(mPage) + 1) + " of " + String(PAGES_NUM);
		}
		/*
			Getter: page
		*/
		public function get page():uint
		{
			return mPage;
		}
		/*
			Function: nextPage
		*/
		public function nextPage():Boolean
		{
			return (mPage + 1 < PAGES_NUM);
		}
		/*
			Method: show

			Shows the game start screen.
		*/
		public function show():void
		{
			mBtnNext.text = "Next";
			mBtnNext.visible = true;
			mBtnNext.exists = true;
			mBtnPlay.visible = true;
			mBtnPlay.exists = true

			page = 0;

			visible = true;
		}
		/*
			Method: hide

			Hides the game start screen.
		*/
		public function hide():void
		{
			visible = false;
			mBtnNext.visible = false;
			mBtnNext.exists = false;
			mBtnPlay.visible = false;
			mBtnPlay.exists = false;
		}
	}
}

