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
	import org.flixel.FlxGroup;
	import org.flixel.FlxSprite;
	import org.flixel.FlxButton;

	/*
		Class: lrLevelBrowser

		lrLevelBrowser class.
	*/
	public class lrLevelBrowser extends FlxGroup
	{
		private var mBtnPrev:lrButton;
		private var mBtnNext:lrButton;

		private var mBackground:FlxSprite;
		private var mTitle:lrText;
		
		private var mPageCnt:lrText;
		private var mPage:uint;

		private var mPagesNum:uint;
		private var mPages:Array;

		private var mLevelsNum:uint;
		private var mLevels:Array;

		/*
			Constructor: lrLevelBrowser
		*/
		public function lrLevelBrowser()
		{
			super();
			
			var txt:lrText = null;
			var grp:FlxGroup = null;
			var lvl:FlxButton = null;

			var w:uint = 576;
			var h:uint = 300;
			var px:uint = (FlxG.width - w) / 2;
			var py:uint = (FlxG.height- h) / 2;

			mBackground = new FlxSprite(px, py, lrResources.lrPanelLarge);
			add(mBackground);
	
			mPageCnt = new lrText(px , py + (w / 2) - 30, w, "1 of 5");
			mPageCnt.alignment = "center";
			mPageCnt.size = 22;
			mPageCnt.color = 0xFFFFFFFF;
			mPageCnt.shadow = 1;
			add(mPageCnt);

			mBtnNext = new lrButton(px + (w-100), py + (w / 2) - 30, clickNext, "Next", 60);
			mBtnNext.textActiveColor = 0xFFFFFFFF;
			mBtnNext.textHoverColor = 0xFFFFFFFF;
			mBtnNext.textSize = 22;
			mBtnNext.shadow = 1;
			add(mBtnNext);

			mBtnPrev = new lrButton(px + 43, py + (w / 2) - 30, clickPrev, "Prev", 60);
			mBtnPrev.textActiveColor = 0xFFFFFFFF;
			mBtnPrev.textHoverColor = 0xFFFFFFFF;
			mBtnPrev.textSize = 22;
			mBtnPrev.shadow = 1;
			add(mBtnPrev);

			mTitle = new lrText(px,py+10,w,"Select Level");
            mTitle.alignment = "center";                                                                                 
			mTitle.size = 32; 
			mTitle.color = 0xFFFFFFFF;
			mTitle.shadow = 1;
			add(mTitle);

			mLevelsNum = 23; // lrResources.NUM_LEVELS;
			mLevels = new Array();

			mPagesNum = FlxU.ceil(mLevelsNum / 18);
			mPages = new Array();

			///////////////////////////////////////// Pages ////////////////////////////////////////

			for(var i:uint=0;i<mPagesNum;i++)
			{
				grp = new FlxGroup();

				var st:uint = i * 18;
				var en:uint = (st + 18) < mLevelsNum ? st + 18 : mLevelsNum;
				var jj:uint = 0;

				for(var j:uint=st;j<en;j++)
				{
					var idx:uint = FlxU.floor(jj/6);
					var lvlButton:lrLevelButton = new lrLevelButton(px + 35 + (jj * 85) - (idx * 6 * 85), py + 60 + (idx * 65), j);

					mLevels.push(lvlButton);
					grp.add(lvlButton);
					
					++jj;
				}

				mPages.push(grp);
				add(grp);
			}

			///////////////////////////////////////// Pages ///////////////////////////////////////

			// Set active page and initial button states
			page = 0;
			//updateButtons();
			//updateLevels();
			//lrStats.instance.erase();
		}
		/*
			Method: clickNext
		*/
		public function clickNext():void
		{
			++page;
			updateButtons();
		}
		/*
			Method: clickPrev
		*/
		public function clickPrev():void
		{
			--page;
			updateButtons();
		}
		/*
			Setter: page
		*/
		public function set page(pPage:uint):void
		{
			for(var i:uint=0;i<mPagesNum;i++)
				mPages[i].active = mPages[i].exists = mPages[i].visible = (i == pPage);

			mPage = pPage;
			mPageCnt.text = String(uint(mPage) + 1) + " of " + String(mPagesNum);
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
			return (mPage + 1 < mPagesNum);
		}
		/*
			Function: prevPage
		*/
		public function prevPage():Boolean
		{
			return (mPage > 0);
		}
		/*
			Method: show

			Shows the game start screen.
		*/
		public function show():void
		{
			page = 0;

			showLevels();
			updateButtons();
			updateLevels();

			visible = true;
		}
		/*
			Method: hide

			Hides the game start screen.
		*/
		public function hide():void
		{
			hideLevels();

			visible = false;
			mBtnNext.exists = mBtnNext.visible = visible;
			mBtnPrev.exists = mBtnPrev.visible = visible;
		}
		/*
			Method: updateButtons
		*/
		private function updateButtons():void
		{
			mBtnNext.exists = mBtnNext.visible = nextPage();
			mBtnPrev.exists = mBtnPrev.visible = prevPage();
		}
		/*
			Method: updateLevels
		*/
		private function updateLevels():void
		{
			var levels:uint = lrStats.instance.lastLevel + 1;
			
			for(var i:uint=0;i<levels;i++)
				mLevels[i].locked = false;
		}
		/*
			Method: showLevels
		*/
		private function showLevels():void
		{
			for(var i:uint=0;i<mLevelsNum;i++)
			{
				mLevels[i].exists = mLevels[i].visible = true;
			}
		}
		/*
			Method: hideLevels
		*/
		private function hideLevels():void
		{
			for(var i:uint=0;i<mLevelsNum;i++)
			{
				mLevels[i].exists = mLevels[i].visible = false;
			}
		}
	}
}
