package
{
	import flash.events.Event;
	import org.flixel.FlxG;
	import org.flixel.FlxGame;
	import com.leragames.lrGame;
	import com.leragames.lrTextPanel;

	[SWF(width="800", height="600", backgroundColor="#000000")]
	[Frame(factoryClass="com.leragames.lrLoader")]

	public class AncestriaMini extends FlxGame
	{
		/*
			Constructor: AncestriaMini
		*/
		public function AncestriaMini()
		{
			super(800,600,lrGame,1);
			pause = new lrTextPanel("Game Paused");
			useDefaultHotKeys = false;
		}
		/*
			Method: showSoundTray
		*/
		override public function showSoundTray(pSilent:Boolean=false):void
		{
			/* do nothing */
		}
		/*
			Method: update
		*/
		override protected function update(pEvent:Event):void
		{
			super.update(pEvent);

			if(FlxG.keys.justPressed("P"))
				FlxG.pause = !FlxG.pause;
		}
		/*
			Method: onFocusLost
		*/
		override protected function onFocusLost(event:Event=null):void
		{
			super.onFocusLost(event);
			lrGame.lostFocus = true;
		}
	}
}
