package overlay;

import backend.AssetPaths;
#if windows
import backend.WinAPI;
#end
import flixel.util.FlxStringUtil;
import flixel.FlxG;
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

	/**
	 * Whether to show the memory usage or not.
	 */
	public var showMemoryUsage:Bool = #if debug true #else false #end;

	@:noCompletion private var currentTime:Float = 0;
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
		currentTime += deltaTime;

		times.push(currentTime);
		while (times[0] < (currentTime - 1000))
			times.shift();

		currentFPS = (times.length > Std.int(FlxG.stage.frameRate)) ? Std.int(FlxG.stage.frameRate) : times.length;

		if (showMemoryUsage)
			text = currentFPS + 'FPS\n' + FlxStringUtil.formatBytes(#if windows WinAPI.getProcessMemory() #else System.totalMemory #end) + '\n';
		else
			text = currentFPS + 'FPS\n';
	}
}
