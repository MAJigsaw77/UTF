package openfl.display;

import flixel.FlxG;
import flixel.util.FlxStringUtil;
import openfl.Lib;
import openfl.events.Event;
import openfl.system.System;
import openfl.text.TextField;
import openfl.text.TextFormat;
import openfl.utils.Assets;

class FPS extends TextField
{
	/**
	 * The current frame rate, expressed using frames-per-second.
	 */
	public var currentFPS(default, null):Int = 0;

	/**
	 * Whether to show the memory usage or not.
	 */
	public var showMemoryUsage:Bool = #if debug true #else false #end;

	@:noCompletion private var currentTime:Float;
	@:noCompletion private var times:Array<Float>;

	public function new(x:Float = 10, y:Float = 10, color:Int = 0xFFFFFF)
	{
		super();

		this.x = x;
		this.y = y;

		autoSize = LEFT;
		selectable = mouseEnabled = false;

		#if mobile
		defaultTextFormat = new TextFormat(Assets.getFont(AssetPaths.font('DTM-Sans')).fontName,
			Std.int(16 * Math.min(FlxG.stage.stageWidth / FlxG.width, FlxG.stage.stageHeight / FlxG.height)), color);
		#else
		defaultTextFormat = new TextFormat(Assets.getFont(AssetPaths.font('DTM-Sans')).fontName, 16, color);
		#end

		currentTime = 0;
		times = [];

		addEventListener(Event.ENTER_FRAME, function(e:Event)
		{
			var time:Int = Lib.getTimer();
			onEnterFrame(time - currentTime);
		});
	}

	private function onEnterFrame(deltaTime:Float):Void
	{
		currentTime += deltaTime;

		times.push(currentTime);
		while (times[0] < currentTime - 1000)
			times.shift();

		currentFPS = (times.length > Std.int(FlxG.stage.frameRate)) ? Std.int(FlxG.stage.frameRate) : times.length;

		final stats:Array<String> = [];
		stats.push('FPS: ' + currentFPS);

		if (showMemoryUsage)
			stats.push('Memory: ' + FlxStringUtil.formatBytes(System.totalMemory));

		stats.push(''); // adding this to not hide the last line.
		text = stats.join('\n');
	}
}
