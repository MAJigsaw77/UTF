package openfl.display;

import backend.AssetPaths;
#if windows
import backend.Memory;
#end
import flixel.util.FlxStringUtil;
import flixel.FlxG;
import openfl.events.Event;
import openfl.system.System;
import openfl.text.TextField;
import openfl.text.TextFormat;
import openfl.utils.Assets;
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

	@:noCompletion
	private var currentTime:Float = 0;

	@:noCompletion
	private var times:Array<Float> = [];

	public function new(x:Float = 10, y:Float = 10, color:Int = 0xFFFFFF)
	{
		super();

		this.x = x;
		this.y = y;

		autoSize = LEFT;
		selectable = mouseEnabled = false;

		#if mobile
		defaultTextFormat = new TextFormat(Assets.getFont(AssetPaths.font('DTM-Sans'), false).fontName,
			Std.int(16 * Math.min(FlxG.stage.stageWidth / FlxG.width, FlxG.stage.stageHeight / FlxG.height)), color);
		#else
		defaultTextFormat = new TextFormat(Assets.getFont(AssetPaths.font('DTM-Sans'), false).fontName, 16, color);
		#end
	}

	// Overrides
	@:noCompletion
	private override function __enterFrame(deltaTime:Int):Void
	{
		currentTime += deltaTime;

		times.push(currentTime);
		while (times[0] < (currentTime - 1000))
			times.shift();

		currentFPS = times.length;

		if (showMemoryUsage)
		{
			#if windows
			text = currentFPS + 'FPS\n' + FlxStringUtil.formatBytes(Memory.getProcessMemory()) + '\n';
			#else
			text = currentFPS + 'FPS\n' + FlxStringUtil.formatBytes(System.totalMemory) + '\n';
			#end
		}
		else
			text = currentFPS + 'FPS\n';
	}
}
