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
	/*
		Class: lrResources

	 	Provides access to all embedded resources.
	*/
	public class lrResources
	{
		///////////////////// SFX  ///////////////////////////////////////////
		//[Embed(source="../../../data/sfx/hit.mp3")] 	
		//public static var lrSoundHit:Class;

		///////////////////// CURSORS  ///////////////////////////////////////
		[Embed(source="../../../data/gfx/cursor.png")] 			
		public static var lrCursor:Class;	

		///////////////////// FONTS  /////////////////////////////////////////
		//[Embed(source="../../../data/fonts/teutonic1.ttf", fontFamily="Teutonic", embedAsCFF="false")]
		//public static var lrFontOne:String;
		[Embed(source="../../../data/fonts/GRAMN___.TTF", fontFamily="Teutonic", embedAsCFF="false")]
		public static var lrFontOne:String;

		///////////////////// LOGOS  /////////////////////////////////////////
		[Embed(source="../../../data/gfx/leragames_m.png")] 			
		public static var lrLogo:Class;
		[Embed(source="../../../data/gfx/leragames_s.png")] 			
		public static var lrLogoSmall:Class;

		///////////////////// BACKGROUNDS  ///////////////////////////////////
		[Embed(source="../../../data/gfx/bg.jpg")] 			
		public static var lrBackground:Class;
		[Embed(source="../../../data/gfx/panel_large.jpg")] 			
		public static var lrPanelLarge:Class;
		[Embed(source="../../../data/gfx/panel_small.jpg")] 			
		public static var lrPanelSmall:Class;

		///////////////////// TUTORIAL STEPS  ///////////////////////////////////
		[Embed(source="../../../data/gfx/step1.png")] 			
		public static var lrStep1:Class;
		[Embed(source="../../../data/gfx/step2.png")] 			
		public static var lrStep2:Class;
		[Embed(source="../../../data/gfx/step3.png")] 			
		public static var lrStep3:Class;
		[Embed(source="../../../data/gfx/step4.png")] 			
		public static var lrStep4:Class;

		///////////////////// LEVEL BROWSER  ///////////////////////////////////
		[Embed(source="../../../data/gfx/lvl_frame.png")] 			
		public static var lrFrameUnlocked:Class;
		[Embed(source="../../../data/gfx/lvl_frame_locked_one.png")] 			
		public static var lrFrameLocked:Class;

		///////////////////// FX /////////////////////////////////////////////
		[Embed(source="../../../data/gfx/star.png")] 	
		public static var lrStar:Class;

		///////////////////// SPAWNABLE BLOCKS  //////////////////////////////
		[Embed(source="../../../data/gfx/b1.png")] 	
		public static var lrBlock1:Class;
		[Embed(source="../../../data/gfx/b2.png")] 	
		public static var lrBlock2:Class;	
		[Embed(source="../../../data/gfx/b3.png")] 	
		public static var lrBlock3:Class;	
		[Embed(source="../../../data/gfx/b4.png")] 	
		public static var lrBlock4:Class;	
		[Embed(source="../../../data/gfx/b5.png")] 	
		public static var lrBlock5:Class;
		[Embed(source="../../../data/gfx/b6.png")] 	
		public static var lrBlock6:Class;

		///////////////////// HIGHLIGHTED BLOCKS  //////////////////////////////
		[Embed(source="../../../data/gfx/h1.png")] 	
		public static var lrBlockH1:Class;
		[Embed(source="../../../data/gfx/h2.png")] 	
		public static var lrBlockH2:Class;	
		[Embed(source="../../../data/gfx/h3.png")] 	
		public static var lrBlockH3:Class;	
		[Embed(source="../../../data/gfx/h4.png")] 	
		public static var lrBlockH4:Class;	
		[Embed(source="../../../data/gfx/h5.png")] 	
		public static var lrBlockH5:Class;
		[Embed(source="../../../data/gfx/h6.png")] 	
		public static var lrBlockH6:Class;

		///////////////////// PRESENT BLOCKS  ////////////////////////////////
		[Embed(source="../../../data/gfx/j1.png")] 	
		public static var lrBlockPS1:Class;
		[Embed(source="../../../data/gfx/j2.png")] 	
		public static var lrBlockPS2:Class;	
		[Embed(source="../../../data/gfx/j3.png")] 	
		public static var lrBlockPS3:Class;	
		[Embed(source="../../../data/gfx/j4.png")] 	
		public static var lrBlockPS4:Class;	
		[Embed(source="../../../data/gfx/j5.png")] 	
		public static var lrBlockPS5:Class;
		[Embed(source="../../../data/gfx/j6.png")] 	
		public static var lrBlockPS6:Class;

		///////////////////// OTHER NON-DESTRYOABLE BLOCKS  //////////////////
		[Embed(source="../../../data/gfx/pillar1.png")] 	
		public static var lrBlockPI1:Class;
		[Embed(source="../../../data/gfx/g1.png")] 	
		public static var lrBlockG1:Class;

		///////////////////// MISC TILES ///////////////////////////////////
		[Embed(source="../../../data/gfx/glow.png")] 	
		public static var lrBlockTileGlow:Class;

		///////////////////// MENU BUTTON ICONS ///////////////////////////////////
		[Embed(source="../../../data/gfx/pause.png")] 	
		public static var lrMenuPause:Class;
		[Embed(source="../../../data/gfx/restart.png")] 	
		public static var lrMenuRestart:Class;
		[Embed(source="../../../data/gfx/menu.png")] 	
		public static var lrMenuMenu:Class;
		[Embed(source="../../../data/gfx/credits.png")] 	
		public static var lrMenuCredits:Class;

		///////////////////// LEVELS /////////////////////////////////////////
		[Embed(source="../../../data/levels/idle.lvl",mimeType="application/octet-stream")] 	
		public static var lrLevelIdle:Class;
		[Embed(source="../../../data/levels/level00.lvl",mimeType="application/octet-stream")] 	
		public static var lrLevel0:Class;
		[Embed(source="../../../data/levels/level01.lvl",mimeType="application/octet-stream")] 	
		public static var lrLevel1:Class;
		[Embed(source="../../../data/levels/level02.lvl",mimeType="application/octet-stream")] 	
		public static var lrLevel2:Class;
		[Embed(source="../../../data/levels/level03.lvl",mimeType="application/octet-stream")] 	
		public static var lrLevel3:Class;
		[Embed(source="../../../data/levels/level04.lvl",mimeType="application/octet-stream")] 	
		public static var lrLevel4:Class;
		[Embed(source="../../../data/levels/level05.lvl",mimeType="application/octet-stream")] 	
		public static var lrLevel5:Class;
		[Embed(source="../../../data/levels/level06.lvl",mimeType="application/octet-stream")] 	
		public static var lrLevel6:Class;
		[Embed(source="../../../data/levels/level07.lvl",mimeType="application/octet-stream")] 	
		public static var lrLevel7:Class;
		[Embed(source="../../../data/levels/level08.lvl",mimeType="application/octet-stream")] 	
		public static var lrLevel8:Class;
		[Embed(source="../../../data/levels/level09.lvl",mimeType="application/octet-stream")] 	
		public static var lrLevel9:Class;

		public static var LEVELS_NUM:Number = 10;
		public static var LEVELS:Array = new Array();
		LEVELS.push(lrLevel0);
		LEVELS.push(lrLevel1);
		LEVELS.push(lrLevel2);
		LEVELS.push(lrLevel3);
		LEVELS.push(lrLevel4);
		LEVELS.push(lrLevel5);
		LEVELS.push(lrLevel6);
		LEVELS.push(lrLevel7);
		LEVELS.push(lrLevel8);
		LEVELS.push(lrLevel9);
	}
}
