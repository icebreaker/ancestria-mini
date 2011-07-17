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
	import org.flixel.FlxPoint;

	/*
		Class: lrBezier

		lrBezier curve class.
	*/
	public class lrBezier
	{
		private var mS:FlxPoint;
		private var mC1:FlxPoint;
		private var mC2:FlxPoint;
		private var mE:FlxPoint;
		private var mPoint:FlxPoint;
		private var mStep:Number;

		/*
			Constructor: lrBezier

			Paramaters:
				pS  - the start point
				pC1 - the first control point
				pC2 - the second control point
				pE  - the end point
		*/
		public function lrBezier(pS:FlxPoint, pC1:FlxPoint, pC2:FlxPoint, pE:FlxPoint)
		{
			mPoint	= new FlxPoint(0,0);
			mS		= new FlxPoint(0,0);
			mC1		= new FlxPoint(0,0);
			mC2		= new FlxPoint(0,0);
			mE		= new FlxPoint(0,0);

			// update points
			setPoints(pS,pC1,pC2,pE);

			// reset step
			reset();
		}
		/*
			Getter: isAtEnd

			Returns TRUE if the step reaches 1.0; otherwise FALSE.
		*/
		public function get isAtEnd():Boolean
		{
			return (mStep == 1.0);
		}
		/*
			Method: reset

			Resets the internal step to 0.0.
		*/
		public function reset():void
		{
			mStep = 0.0;
		}
		/*
			Setter: startPoint
			
			Sets the start point.
		*/
		public function set startPoint(pStart:FlxPoint):void
		{
			mS.x = pStart.x;
			mS.y = pStart.y;
		}
		/*
			Setter: controlPointOne
			
			Sets the first control point.
		*/
		public function set controlPointOne(pControlPointOne:FlxPoint):void
		{
			mC1.x = pControlPointOne.x;
			mC1.y = pControlPointOne.y;
		}
		/*
			Setter: controlPointTwo
			
			Sets the second control point.
		*/
		public function set controlPointTwo(pControlPointTwo:FlxPoint):void
		{
			mC2.x = pControlPointTwo.x;
			mC2.y = pControlPointTwo.y;
		}
		/*
			Setter: endPoint
			
			Sets the end point.
		*/
		public function set endPoint(pEnd:FlxPoint):void
		{
			mE.x = pEnd.x;
			mE.y = pEnd.y;
		}
		/*
			Method: setPoints

			Sets the 4 points required by the Bezier curve.
	
			Paramaters:
				pS  - the start point
				pC1 - the first control point
				pC2 - the second control point
				pE  - the end point
		*/
		public function setPoints(pS:FlxPoint, pC1:FlxPoint, pC2:FlxPoint, pE:FlxPoint):void
		{
			mS.x = pS.x;
			mS.y = pS.y;

			mC1.x = pC1.x;
			mC1.y = pC1.y;

			mC2.x = pC2.x;
			mC2.y = pC2.y;

			mE.x = pE.x;
			mE.y = pE.y;
		}
		/*

			Method: update

			Updates and evaluates thei curve equation.

			Paramaters:
				pT - a (step) value in the [0 .. 1] range

			Returns the "interpolated" <FlxPoint> after evaluating the equation.
		*/
		public function update(pT:Number):FlxPoint
		{

			mPoint.x =	(mS.x  * ( (1-mStep) * (1-mStep) * (1-mStep) )) + 
						(mC1.x * ( 3 * mStep * (1-mStep) * (1-mStep) )) + 
						(mC2.x * ( 3 * mStep * mStep * (1-mStep) )) + 
						(mE.x  * ( mStep * mStep * mStep ));

			mPoint.y =	(mS.y  * ( (1-mStep) * (1-mStep) * (1-mStep) )) + 
						(mC1.y * ( 3 * mStep * (1-mStep) * (1-mStep) )) + 
						(mC2.y * ( 3 * mStep * mStep * (1-mStep) )) + 
						(mE.y  * ( mStep * mStep * mStep ));

			mStep += pT; if(mStep>1.0) mStep = 1.0;

			return mPoint;
		}
		/*
			Getter: position

			Returns the current position.
		*/
		public function get position():FlxPoint
		{
			return mPoint;
		}
	}
}

