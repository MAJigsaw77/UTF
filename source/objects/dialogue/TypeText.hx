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

	var _finalText:String = '';
	var _timer:Float = 0;
	var _length:Int = 0;
	var _typing:Bool = false;
	var _waiting:Bool = false;

	final _ignoreCharacters:Array<String> = ['\n', ' ', '^', '!', '.', '?', ',', ':', '/', '\\', '|', '*'];

	public function new(x:Float, y:Float, width:Int, size:Int = 8, embeddedFont:Bool = true):Void
	{
		super(x, y, width, '', size, embeddedFont);
	}

	public function start(text:String, ?delay:Float):Void
	{
		if (delay != null)
			this.delay = delay;

		_finalText = text;
		_typing = true;
		_length = 1;

		this.text = '';
	}

	public function skip():Void
	{
		if (_typing)
			_length = _finalText.length;
	}

	override public function update(elapsed:Float):Void
	{
		if (_length < _finalText.length && _typing && !_waiting)
			_timer += elapsed;

		if (_typing && !_waiting)
		{
			if (_timer >= delay)
			{
				if (_finalText.charAt(_length) == '^')
				{
					final waitTime:Null<Int> = Std.parseInt(_finalText.charAt(_length + 1));

					if (waitTime != null)
					{
						_finalText = _finalText.substring(0, _length) + _finalText.substring(_length + 2);

						_length--;

						if (waitTime > 0)
						{
							_waiting = true;

							new FlxTimer().start(1 / (waitTime * 10), function(tmr:FlxTimer):Void
							{
								_waiting = false;
							});

							return;
						}
					}
					else
						_length += Math.floor(_timer / delay);
				}
				else
					_length += Math.floor(_timer / delay);

				if (_length > _finalText.length)
					_length = _finalText.length;

				_timer %= delay;

				if (sounds != null && !_ignoreCharacters.contains(_finalText.charAt(_length - 1)))
				{
					if (!finishSounds)
					{
						for (sound in sounds)
							sound.stop();
					}

					FlxG.random.getObject(sounds).play(!finishSounds);
				}
			}

			final curText:String = _finalText.substr(0, _length);

			if (text != curText)
			{
				text = curText;

				if (_length >= _finalText.length)
				{
					_timer = 0;
					_typing = false;
				}
			}
		}

		super.update(elapsed);
	}

	private function get_finished():Bool
	{
		return !_typing && _length >= _finalText.length;
	}
}
