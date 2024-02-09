package;

#if android
import android.content.Context;
import android.os.Build;
#end
import backend.AssetPaths;
import backend.Data;
import backend.PercentOfHeightScaleMode;
import flixel.util.FlxColor;
import flixel.FlxG;
import flixel.FlxGame;
import flixel.FlxState;
import haxe.io.Path;
import haxe.CallStack;
import haxe.Exception;
import haxe.Log;
#if hl
import hl.Api;
#end
import lime.system.System as LimeSystem;
import openfl.display.Bitmap;
import openfl.display.FPS;
import openfl.display.Sprite;
import openfl.errors.Error;
import openfl.events.ErrorEvent;
import openfl.events.UncaughtErrorEvent;
import openfl.system.System as OpenFLSystem;
import openfl.utils.AssetCache;
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
	public static var border:Bitmap;
	public static var fps:FPS;

	public function new():Void
	{
		super();

		#if android
		Sys.setCwd(Path.addTrailingSlash(VERSION.SDK_INT > 30 ? Context.getObbDir() : Context.getExternalFilesDir()));
		#elseif (ios || switch)
		Sys.setCwd(LimeSystem.applicationStorageDirectory);
		#end

		Lib.current.loaderInfo.uncaughtErrorEvents.addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR, onUncaughtError);

		#if hl
		Api.setErrorHandler(onCriticalError);
		#elseif cpp
		untyped __global__.__hxcpp_set_critical_error_handler(onCriticalError);
		#end

		FlxG.scaleMode = new PercentOfHeightScaleMode(0.88);

		FlxG.signals.gameResized.add(onResizeGame);
		FlxG.signals.preStateCreate.add(onPreStateCreate);
		FlxG.signals.postStateSwitch.add(OpenFLSystem.gc);

		border = new Bitmap(Assets.getBitmapData(AssetPaths.border('line')));
		// border.bitmapData = Assets.getBitmapData(AssetPaths.border('line'));
		addChild(border);

		addChild(new FlxGame(640, 480, Startup, 60, 60));

		#if android
		FlxG.android.preventDefaultKeys = [BACK];
		#end

		fps = new FPS(10, 10, FlxColor.RED);
		fps.visible = Data.settings.get('fps-overlay');
		FlxG.game.addChild(fps);
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
			Log.trace('Couldn\'t save error message "${e.message}"', null);
		#end

		Log.trace(msg, null);
		Lib.application.window.alert(msg, 'Error!');
		LimeSystem.exit(1);
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
			Log.trace('Couldn\'t save error message "${e.message}"', null);
		#end

		Log.trace(msg, null);
		Lib.application.window.alert(msg, 'Error!');
		LimeSystem.exit(1);
	}

	private inline function onResizeGame(width:Int, height:Int):Void
	{
		final scale:Float = Math.min(FlxG.stage.stageWidth / FlxG.width, FlxG.stage.stageHeight / FlxG.height);

		if (fps != null)
			fps.scaleX = fps.scaleY = (scale > 1 ? scale : 1);

		if (border != null && border.bitmapData != null)
		{
			final scale:Float = Lib.current.stage.stageHeight / 1080;
			border.scaleX = scale;
			border.scaleY = scale;
			border.x = (Lib.current.stage.stageWidth - border.width) * 0.5;
		}

		if (FlxG.cameras != null && (FlxG.cameras.list != null && FlxG.cameras.list.length > 0))
		{
			for (camera in FlxG.cameras.list)
			{
				if (camera != null && (camera.filters != null && camera.filters.length > 0))
				{
					// Shout out to Ne_Eo for bringing this to my attention.
					@:privateAccess
					if (camera.flashSprite != null)
					{
						camera.flashSprite.__cacheBitmap = null;
						camera.flashSprite.__cacheBitmapData = null;
					}
				}
			}
		}

		@:privateAccess
		if (FlxG.game != null)
		{
			FlxG.game.__cacheBitmap = null;
			FlxG.game.__cacheBitmapData = null;
		}
	}

	private inline function onPreStateCreate(state:FlxState):Void
	{
		var cache:AssetCache = cast(Assets.cache, AssetCache);

		// Clear the loaded graphics if they are no longer in flixel cache...
		for (key in cache.bitmapData.keys())
			if (!FlxG.bitmap.checkCache(key))
				cache.bitmapData.remove(key);

		// Clear all the loaded sounds from the cache...
		for (key in cache.sound.keys())
			cache.sound.remove(key);

		// Clear all the loaded fonts from the cache...
		for (key in cache.font.keys())
			cache.font.remove(key);

		#if MODS
		// Clear the loaded assets from polymod...
		Polymod.clearCache();
		#end
	}
}
