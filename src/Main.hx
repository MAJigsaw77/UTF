package;

import flixel.addons.transition.FlxTransitionableState;
import flixel.addons.transition.TransitionData;
import flixel.util.FlxColor;
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

		FlxTransitionableState.defaultTransIn = new TransitionData(FADE, FlxColor.BLACK, 0.5);
		FlxTransitionableState.defaultTransOut = new TransitionData(FADE, FlxColor.BLACK, 0.5);

		addChild(new FlxGame(640, 480, BattleState, 30, 30));

		var fpsCounter:FPS = new FPS(10, 10, FlxColor.WHITE);
		fpsCounter.showMemoryUsage = #if debug true #else false #end;
		addChild(fpsCounter);
	}
}
