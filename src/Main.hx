package;

import flixel.FlxG;
import flixel.FlxGame;
import flixel.FlxState;
import openfl.display.FPS;
import openfl.display.Sprite;
import openfl.system.System;
import openfl.utils.Assets;

class Main extends Sprite
{
	public function new():Void
	{
		super();

		FlxG.signals.preStateCreate.add(function(state:FlxState)
		{
			// Clear the loaded graphics if they are no longer in flixel cache...
			for (key in Assets.cache.getBitmapKeys())
				if (!FlxG.bitmap.checkCache(key))
					Assets.cache.removeBitmapData(key);

			// Run the garbage colector...
			System.gc();
		});
		FlxG.signals.postStateSwitch.add(System.gc);

		addChild(new FlxGame(640, 480, MainState, 60, 60));

		var fpsCounter:FPS = new FPS(10, 10, 0xFFFFFF);
		fpsCounter.showRam= #if debug true #else false #end;
		addChild(fpsCounter);
	}
}
