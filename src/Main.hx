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
			for (key => value in Assets.cache.bitmapData)
				if (!FlxG.bitmap.checkCache(key))
					Assets.cache.removeBitmapData(key);

			// Clear the loaded songs as they use the most memory...
			Assets.cache.clear(getPath('songs', 'songs'));

			// Run the garbage colector...
			System.gc();
		});
		FlxG.signals.postStateCreate.add(System.gc);

		addChild(new FlxGame(1280, 720, MainState, 60, 60));

		var fpsCounter:FPS = new FPS(10, 3, 0xFFFFFF);
		fpsCounter.showMemory = #if debug true #else false #end;
		addChild(fpsCounter);
	}
}
