package;

import flixel.util.FlxColor;
import flixel.FlxG;
import flixel.FlxGame;
import flixel.FlxState;
import haxe.CallStack;
import lime.system.System;
import openfl.display.FPS;
import openfl.display.Sprite;
import openfl.events.UncaughtErrorEvent;
import openfl.system.System;
import openfl.utils.Assets;
import openfl.Lib;
import polymod.Polymod;

class Main extends Sprite
{
	public function new():Void
	{
		super();

		#if !debug
		Lib.current.loaderInfo.uncaughtErrorEvents.addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR, onError);

		#if cpp
		untyped __global__.__hxcpp_set_critical_error_handler(function(message:String)
		{
			throw message;
		});
		#end
		#end

		FlxG.signals.gameResized.add(onResizeGame);
		FlxG.signals.preStateCreate.add(function(state:FlxState)
		{
			// Clear the loaded graphics if they are no longer in flixel cache...
			for (key in Assets.cache.getBitmapKeys())
				if (!FlxG.bitmap.checkCache(key))
					Assets.cache.removeBitmapData(key);

			// Clear all the loaded sounds from the cache...
			for (key in Assets.cache.getSoundKeys())
				Assets.cache.removeSound(key);

			// Clear the loaded assets from polymod...
			Polymod.clearCache();

			// Run the garbage colector...
			System.gc();
		});

		addChild(new FlxGame(640, 480, Startup, 30, 30, false, false));
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
				// Shout out to Ne_Eo for bringing this to my attention.
				var sprite:Sprite = cam.flashSprite;

				if (sprite != null)
				{
					sprite.__cacheBitmap = null;
					sprite.__cacheBitmapData = null;
				}
			}
		}
	}

	private function onError(e:UncaughtErrorEvent):Void
	{
		e.preventDefault();
		e.stopPropagation();
		e.stopImmediatePropagation();

		final stack:Array<String> = [Std.string(e.error)];

		for (item in CallStack.exceptionStack(true))
		{
			switch (item)
			{
				case CFunction:
					stack.push('C Function');
				case Module(m):
					stack.push('Module [$m]');
				case FilePos(s, file, line, column):
					stack.push('$file [line $line]');
				case Method(classname, method):
					stack.push('$classname [method $method]');
				case LocalFunction(name):
					stack.push('Local Function [$name]');
			}
		}

		Sys.println(stack.join('\n'));
		Lib.application.window.alert(stack.join('\n'), 'Error!');
		System.exit(1);
	}
}
