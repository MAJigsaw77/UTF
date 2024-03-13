package objects.dialogue;

import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.sound.FlxSound;
import flixel.util.FlxTimer;
import flixel.FlxG;

class TypeText extends FlxText
{
	public var delay:Float = 0.05;
	public var sounds:Array<FlxSound> = [];
	public var finished(get, null):Bool = false;
	public var finishSounds:Bool = false;

	var finalText:String = '';
	var timer:Float = 0;
	var length:Int = 0;
	var typing:Bool = false;
	var waiting:Bool = false;

	final ignoreCharacters:Array<String> = ['\n', ' ', '^', '!', '.', '?', ',', ':', '/', '\\', '|', '*'];

	public function new(x:Float, y:Float, width:Int, size:Int = 8, embeddedFont:Bool = true):Void
	{
		super(x, y, width, '', size, embeddedFont);
	}

	public function start(text:String, ?delay:Float):Void
	{
		if (delay != null)
			this.delay = delay;

		finalText = text;
		timer = delay;
		typing = true;
		length = 0;

		this.text = '';
	}

	public function skip():Void
	{
		if (typing)
			length = finalText.length;
	}

	override public function update(elapsed:Float):Void
	{
		if (length < finalText.length && typing && !waiting)
			timer += elapsed;

		if (typing && !waiting)
		{
			if (timer >= delay)
			{
				if (finalText.charAt(length) == '^')
				{
					final waitTime:Null<Int> = Std.parseInt(finalText.charAt(length + 1));

					if (waitTime != null)
					{
						finalText = finalText.substring(0, length) + finalText.substring(length + 2);

						length--;

						if (waitTime > 0)
						{
							waiting = true;

							new FlxTimer().start(1 / (waitTime * 10), function(tmr:FlxTimer):Void
							{
								waiting = false;
							});

							return;
						}
					}
					else
						length += Math.floor(timer / delay);
				}
				else
					length += Math.floor(timer / delay);

				if (length > finalText.length)
					length = finalText.length;

				timer %= delay;

				if (sounds != null && !ignoreCharacters.contains(finalText.charAt(length - 1)))
				{
					if (!finishSounds)
					{
						for (sound in sounds)
							sound.stop();
					}

					FlxG.random.getObject(sounds).play(!finishSounds);
				}
			}

			final curText:String = finalText.substr(0, length);

			if (text != curText)
			{
				text = curText;

				if (length >= finalText.length)
				{
					timer = 0;
					typing = false;
				}
			}
		}

		super.update(elapsed);
	}

	private function getfinished():Bool
	{
		return !typing && length >= finalText.length;
	}
}
