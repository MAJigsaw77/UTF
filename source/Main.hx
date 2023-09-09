package;

#if android
import android.content.Context;
#end
import backend.Data;
#if windows
import backend.Windows;
#end
import flixel.util.FlxColor;
import flixel.FlxG;
import flixel.FlxGame;
import flixel.FlxState;
import haxe.CallStack;
import haxe.Exception;
import haxe.Log;
#if hl
import hl.Api;
#end
import lime.system.System;
import openfl.display.FPS;
import openfl.display.Sprite;
import openfl.errors.Error;
import openfl.events.ErrorEvent;
import openfl.events.UncaughtErrorEvent;
import openfl.system.System;
import openfl.utils.Assets;
import openfl.Lib;
#if MODS
import polymod.Polymod;
#end
import states.Startup;
#if sys
import sys.io.File;
import sys.FileSystem;
#end

using StringTools;

class Main extends Sprite
{
	public static var fps:FPS;

	public function new():Void
	{
		super();

		#if android
		Sys.setCwd(Context.getExternalFilesDir() + '/');
		#elseif (ios || switch)
		Sys.setCwd(System.applicationStorageDirectory);
		#end

		Lib.current.loaderInfo.uncaughtErrorEvents.addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR, onUncaughtError);

		#if hl
		Api.setErrorHandler(onCriticalError);
		#elseif cpp
		untyped __global__.__hxcpp_set_critical_error_handler(onCriticalError);
		#end

		FlxG.signals.gameResized.add(onResizeGame);
		FlxG.signals.preStateCreate.add(onPreStateCreate);

		// Run the garbage colector on after the state switched...
		FlxG.signals.postStateSwitch.add(System.gc);

		#if windows
		Windows.setWindowTheme(DARK);
		#end
		
		addChild(new FlxGame(640, 480, Startup, 30, 30));

		#if android
		FlxG.android.preventDefaultKeys = [BACK];
		#end

		fps = new FPS(10, 10, FlxColor.RED);
		fps.visible = Data.settings['fps'];
		addChild(fps);
	}

	private inline function onUncaughtError(event:UncaughtErrorEvent):Void
	{
		event.preventDefault();
		event.stopImmediatePropagation();

		final log:Array<String> = [];

		if (Std.isOfType(event.error, Error))
			log.push(cast(event.error, Error).message);
		else if (Std.isOfType(event.error, ErrorEvent))
			log.push(cast(event.error, ErrorEvent).text);
		else
			log.push(Std.string(event.error));

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

		final msg:String = log.join('\n');

		#if sys
		try
		{
			if (!FileSystem.exists('errors'))
				FileSystem.createDirectory('errors');

			File.saveContent('errors/' + Date.now().toString().replace(' ', '-').replace(':', "'") + '.txt', msg);
		}
		catch (e:Exception)
			Log.trace('Couldn\'t save error message "${e.message}"');
		#end

		Log.trace(msg);
		Lib.application.window.alert(msg, 'Error!');
		System.exit(1);
	}

	private inline function onCriticalError(error:Dynamic):Void
	{
		final log:Array<String> = [Std.isOfType(error, String) ? error : Std.string(error)];

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

		final msg:String = log.join('\n');

		#if sys
		try
		{
			if (!FileSystem.exists('errors'))
				FileSystem.createDirectory('errors');

			File.saveContent('errors/' + Date.now().toString().replace(' ', '-').replace(':', "'") + '.txt', msg);
		}
		catch (e:Exception)
			Log.trace('Couldn\'t save error message "${e.message}"');
		#end

		Log.trace(msg);
		Lib.application.window.alert(msg, 'Error!');
		System.exit(1);
	}

	private inline function onResizeGame(width:Int, height:Int):Void
	{
		if (FlxG.cameras != null)
		{
			for (camera in FlxG.cameras.list)
			{
				@:privateAccess
				if (camera != null && (camera._filters != null && camera._filters.length > 0))
				{
					// Shout out to Ne_Eo for bringing this to my attention.
					if (camera.flashSprite != null)
					{
						camera.flashSprite.__cacheBitmap = null;
						camera.flashSprite.__cacheBitmapData = null;
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

	private inline function onPreStateCreate(state:FlxState):Void
	{
		// Clear the loaded graphics if they are no longer in flixel cache...
		for (key in Assets.cache.getBitmapKeys())
			if (!FlxG.bitmap.checkCache(key))
				Assets.cache.removeBitmapData(key);

		// Clear all the loaded sounds from the cache...
		for (key in Assets.cache.getSoundKeys())
			Assets.cache.removeSound(key);

		// Clear all the loaded fonts from the cache...
		for (key in Assets.cache.getFontKeys())
			Assets.cache.removeFont(key);

		#if MODS
		// Clear the loaded assets from polymod...
		Polymod.clearCache();
		#end
	}
}
