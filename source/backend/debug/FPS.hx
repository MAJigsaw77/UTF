package backend.debug;

import backend.AssetPaths;
import flixel.util.FlxStringUtil;
import flixel.FlxG;
import haxe.Timer;
import openfl.system.System;
import openfl.text.TextField;
import openfl.text.TextFormat;
import openfl.Lib;

class FPS extends TextField
{
	/**
	 * The current frameRate, expressed using frames-per-second.
	 */
	public var currentFPS(default, null):Int = 0;

	@:noCompletion private var deltaTimeout:Int = 0;
	@:noCompletion private var times:Array<Float> = [];

	public function new(x:Float = 10, y:Float = 10, color:Int = 0xFFFFFF)
	{
		super();

		this.x = x;
		this.y = y;

		autoSize = LEFT;
		selectable = false;
		mouseEnabled = false;
		multiline = true;

		defaultTextFormat = new TextFormat(AssetPaths.font('DTM-Sans'), 16, color);
	}

	// Overrides
	@:noCompletion private override function __enterFrame(deltaTime:Int):Void
	{
		if (deltaTimeout > 1000)
		{
			deltaTimeout = 0;
			return;
		}

		final now:Float = Timer.stamp() * 1000;

		times.push(now);

		while (times[0] < (now - 1000))
			times.shift();

		currentFPS = times.length > FlxG.updateFramerate ? FlxG.updateFramerate : times.length;

		#if debug
		text = currentFPS + 'FPS\n${FlxStringUtil.formatBytes(System.totalMemory)}\n';
		#else
		text = currentFPS + 'FPS\n';
		#end

		deltaTimeout += deltaTime;
	}
}
