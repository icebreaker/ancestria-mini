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
	
	/*
		Class: lrGameOver

		lrGameOver class.
	*/
	public class lrGameOver extends FlxGroup
	{
		private var mBackground:FlxSprite;
		private var mStatus:lrText;
		private var mScore:lrText;
		private var mCombo:lrText;
		private var mTime:lrText;
		private var mBonus:lrText;
		private var mTotalScore:lrText;
		private var mBtnNext:lrButton;

		/*
			Constructor: lrGameOver
		*/
		public function lrGameOver()
		{
			super();
			
			var w:uint = 576;
			var h:uint = 300;
			var px:uint = (FlxG.width - w) / 2;
			var py:uint = (FlxG.height- h) / 2;

			mBackground = new FlxSprite(px, py, lrResources.lrPanelLarge);
			add(mBackground);
			
			mStatus = new lrText(px,py+20,w,"Game Over");
			mStatus.alignment = "center";
			mStatus.size = 36;
			mStatus.color = 0xFFFFFFFF;
			mStatus.shadow = 1;
			add(mStatus);

			var fntSize:uint = 24;
			var fntOffset:uint = 15;

			var txt:lrText = new lrText(px,py+90-fntOffset,w/2,"Score");
			txt.alignment = "right";
			txt.size = fntSize;
			txt.color = 0xFFFFFFFF;
			txt.shadow = 1;
			add(txt);

			mScore = new lrText(px+(w/2)+50,py+90-fntOffset,w/2,"15000");
			mScore.alignment = "left";
			mScore.size = fntSize;
			mScore.color = 0xFFFFFFFF;
			mScore.shadow = 1;
			add(mScore);

			txt = new lrText(px,py+120-fntOffset,w/2,"Combo");
			txt.alignment = "right";
			txt.size = fntSize;
			txt.color = 0xFFFFFFFF;
			txt.shadow = 1;
			add(txt);

			mCombo = new lrText(px+(w/2)+50,py+120-fntOffset,w/2,"12x");
			mCombo.alignment = "left";
			mCombo.size = fntSize;
			mCombo.color = 0xFFFFFFFF;
			mCombo.shadow = 1;
			add(mCombo);

			txt = new lrText(px,py+150-fntOffset,w/2,"Time");
			txt.alignment = "right";
			txt.size = fntSize;
			txt.color = 0xFFFFFFFF;
			txt.shadow = 1;
			add(txt);

			mTime = new lrText(px+(w/2)+50,py+150-fntOffset,w/2,"00:33");
			mTime.alignment = "left";
			mTime.size = fntSize;
			mTime.color = 0xFFFFFFFF;
			mTime.shadow = 1;
			add(mTime);

			txt = new lrText(px,py+180-fntOffset,w/2,"Time & Combo Bonus");
			txt.alignment = "right";
			txt.size = fntSize;
			txt.color = 0xFFFFFFFF;
			txt.shadow = 1;
			add(txt);

			mBonus = new lrText(px+(w/2)+50,py+180-fntOffset,w/2,"20000");
			mBonus.alignment = "left";
			mBonus.size = fntSize;
			mBonus.color = 0xFFFFFFFF;
			mBonus.shadow = 1;
			add(mBonus);

			txt = new lrText(px,py+210-fntOffset,w/2,"Total Score");
			txt.alignment = "right";
			txt.size = fntSize;
			txt.color = 0xFFFFFFFF;
			txt.shadow = 1;
			add(txt);

			mTotalScore = new lrText(px+(w/2)+50,py+210-fntOffset,w/2,"500000");
			mTotalScore.alignment = "left";
			mTotalScore.size = fntSize;
			mTotalScore.color = 0xFFFFFFFF;
			mTotalScore.shadow = 1;
			add(mTotalScore);

			mBtnNext = new lrButton(px + ((w - 175)/2),py+240,clickContinue,"Continue",175);
			mBtnNext.textActiveColor = 0xFFFFFFFF;
			mBtnNext.textHoverColor = 0xFFFFFFFF;
			mBtnNext.shadow = 1;
			add(mBtnNext);
		}
		/*
			Method: clickContinue
		*/
		public function clickContinue():void
		{
			(FlxG.state as lrGame).startNext();
		}
		/*
			Method: show

			Paramaters:
				pState - status string
				pScore - the actual score for the current level
				pBonus - the actual bonus for the current level
				pCombo - the actual maximum combo for the current level
				pTime  - the actual elapsed time for the current level

			Shows the game over screen.
		*/
		public function show(pStatus:String, pScore:uint, pBonus:uint, pCombo:uint, pTime:Number):void
		{
			var mins:Number = FlxU.floor(pTime / 60.0);
			var secs:Number = FlxU.floor(pTime % 60.0);

			mStatus.text = pStatus;
			mScore.text = String(pScore);
			mCombo.text = String(pCombo) + "x";
			mTime.text = String((mins < 10) ? "0" + mins : mins) + " : " + String((secs < 10) ? "0" + secs : secs);
			mBonus.text = String(pBonus);
			mTotalScore.text = String(pScore + pBonus);

			visible = true;
			mBtnNext.visible = true;
			mBtnNext.exists = true;
		}
		/*
			Method: hide

			Hides the game over screen.
		*/
		public function hide():void
		{
			visible = false;
			mBtnNext.visible = false;
			mBtnNext.exists = false;
		}
	}
}

