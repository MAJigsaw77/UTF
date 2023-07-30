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
	public static var fps:FPS;

	public function new():Void
	{
		super();

		#if !debug
		Lib.current.loaderInfo.uncaughtErrorEvents.addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR, onUncaughtError);
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
		FlxG.signals.postStateSwitch.add(System.gc);

		addChild(new FlxGame(640, 480, Startup, 30, 30, false, false));

		fps = new FPS(10, 10, FlxColor.WHITE);
		fps.visible = Data.settings.get('fps');
		addChild(fps);
	}

	private inline function onUncaughtError(event:UncaughtErrorEvent):Void
	{
		event.preventDefault();
		event.stopImmediatePropagation();

		var log:Array<String> = [Std.string(event.error)];

		for (item in CallStack.exceptionStack(true))
		{
			switch (item)
			{
				case CFunction:
					log.push('C Function');
				case Module(m):
					log.push('Module [$m]');
				case FilePos(s, file, line, column):
					log.push('$file [line $line]');
				case Method(classname, method):
					log.push('$classname [method $method]');
				case LocalFunction(name):
					log.push('Local Function [$name]');
			}
		}

		Sys.println(log.join('\n'));
		Lib.application.window.alert(log.join('\n'), 'Error!');
		System.exit(1);
	}

	private inline function onResizeGame(width:Int, height:Int):Void
	{
		if (FlxG.cameras != null)
		{
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

		if (FlxG.game != null)
		{
			@:privateAccess
			{
				FlxG.game.__cacheBitmap = null;
				FlxG.game.__cacheBitmapData = null;
			}
		}
	}
}
