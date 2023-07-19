package;

import flixel.addons.transition.FlxTransitionableState;
import flixel.addons.transition.TransitionData;
import flixel.util.FlxColor;
import flixel.FlxG;
import flixel.FlxGame;
import flixel.FlxState;
import haxe.CallStack;
import lime.system.System;
import openfl.display.FPS;
import openfl.display.Sprite;
import openfl.system.System;
import openfl.utils.Assets;
import openfl.events.UncaughtErrorEvent;
import openfl.Lib;
import polymod.Polymod;

class Main extends Sprite
{
	public function new():Void
	{
		super();

		Lib.current.loaderInfo.uncaughtErrorEvents.addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR, onError);

		FlxG.signals.gameResized.add(onResizeGame);
		FlxG.signals.preStateCreate.add(function(state:FlxState)
		{
			// Clear the loaded graphics if they are no longer in flixel cache...
			for (key in Assets.cache.getBitmapKeys())
				if (!FlxG.bitmap.checkCache(key))
					Assets.cache.removeBitmapData(key);

			// Clear the loaded assets from polymod...
			Polymod.clearCache();

			// Run the garbage colector...
			System.gc();
		});
		FlxG.signals.postStateSwitch.add(System.gc);

		FlxTransitionableState.defaultTransIn = new TransitionData(FADE, FlxColor.BLACK, 0.5);
		FlxTransitionableState.defaultTransOut = new TransitionData(FADE, FlxColor.BLACK, 0.5);

		addChild(new FlxGame(640, 480, BattleState, 30, 30, false, false));
		addChild(new FPS(10, 10, FlxColor.WHITE));
	}

	private function onResizeGame(width:Int, height:Int):Void
	{
		if (FlxG.cameras == null)
			return;

		for (cam in FlxG.cameras.list)
		{
			@:privateAccess
			if (cam != null && (cam._filters != null && cam._filters.length > 0))
			{
				var sprite:Sprite = cam.flashSprite; // Shout out to Ne_Eo for bringing this to my attention
				if (sprite != null)
				{
					sprite.__cacheBitmap = null;
					sprite.__cacheBitmapData = null;
				}
			}
		}
	}

	private static function onError(e:UncaughtErrorEvent):Void
	{
		final stack:Array<String> = [];

		stack.push(e.error);

		for (stackItem in CallStack.exceptionStack(true))
		{
			switch (stackItem)
			{
				case CFunction:
					stack.push('C Function');
				case Module(m):
					stack.push('Module ($m)');
				case FilePos(s, file, line, column):
					stack.push('$file (line $line)');
				case Method(classname, method):
					stack.push('$classname (method $method)');
				case LocalFunction(name):
					stack.push('Local Function ($name)');
			}
		}

		e.preventDefault();
		e.stopPropagation();
		e.stopImmediatePropagation();

		Sys.println(stack.join('\n'));
		Lib.application.window.alert(stack.join('\n'), 'Error!');
		System.exit(1);
	}
}
