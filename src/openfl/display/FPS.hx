package openfl.display;

import flixel.FlxG;
import flixel.math.FlxMath;
import openfl.Lib;
import openfl.events.Event;
import openfl.system.System;
import openfl.text.TextField;
import openfl.text.TextFormat;
import openfl.utils.Assets;

class FPS extends TextField
{
	/**
		The current frame rate, expressed using frames-per-second
	**/
	public var currentFPS(default, null):Int = 0;

	/**
		Whether to show the ram usage or not.
	**/
	public var showRAM:Bool = true;

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
		defaultTextFormat = new TextFormat(Assets.getFont(Paths.font('DTM-Sans.otf')).fontName,
			Std.int(14 * Math.min(Lib.current.stage.stageWidth / FlxG.width, Lib.current.stage.stageHeight / FlxG.height)), color);
		#else
		defaultTextFormat = new TextFormat(Assets.getFont(Paths.font('DTM-Sans.otf')).fontName, 14, color);
		#end

		currentTime = 0;
		times = [];

		addEventListener(Event.ENTER_FRAME, function(e:Event)
		{
			var time:Int = Lib.getTimer();
			onEnterFrame(time - currentTime);
		});

		#if mobile
		addEventListener(Event.RESIZE, function(e:Event)
		{
			final daSize:Int = Std.int(14 * Math.min(Lib.current.stage.stageWidth / FlxG.width, Lib.current.stage.stageHeight / FlxG.height));
			if (defaultTextFormat.size != daSize)
				defaultTextFormat.size = daSize;
		});
		#end
	}

	private function onEnterFrame(deltaTime:Float):Void
	{
		currentTime += deltaTime;
		times.push(currentTime);

		while (times[0] < currentTime - 1000)
			times.shift();

		var currentFrames:Int = times.length;
		if (currentFrames > Std.int(Lib.current.stage.frameRate))
			currentFPS = Std.int(Lib.current.stage.frameRate);
		else
			currentFPS = currentFrames;

		final stats:Array<String> = [];
		stats.push('FPS: ' + currentFPS);

		if (showRAM)
			stats.push('RAM: ' + getMemorySize(System.totalMemory));

		stats.push(''); // adding this to not hide the last line.
		text = stats.join('\n');
	}

	public function getMemorySize(size:Float):String
	{
		final labels:Array<String> = ['B', 'KB', 'MB', 'GB']; // I don't think a mod can use more lol

		var label:Int = 0;
		while (size >= 1000 && (label < labels.length - 1))
		{
			size /= 1000;
			label++;
		}

		return '${Math.abs(FlxMath.roundDecimal(size, 2))} ${labels[label]}';
	}
}
