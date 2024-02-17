package objects.dialogue;

import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.sound.FlxSound;
import flixel.FlxG;

class TypeText extends FlxText
{
	public var delay:Float = 0.05;
	public var sounds:Array<FlxSound> = [];
	public var finishSounds:Bool = false;

	var _finalText:String = '';
	var _timer:Float = 0.0;
	var _length:Int = 0;
	var _typing:Bool = false;

	final _ignoreCharacters:Array<String> = ['`', '~', '!', '*', '(', ')', '-', '_', '=', '+', '{', '}', '[', ']', '\'', '\n', '\\', '|', ':', ';', ',', '<', '.', '>', '/', '?', '^', ' '];

	public function new(x:Float, y:Float, width:Int, text:String, size:Int = 8, embeddedFont:Bool = true):Void
	{
		super(x, y, width, '', size, embeddedFont);

		_finalText = text;
	}

	public function start(?delay:Float):Void
	{
		if (delay != null)
			this.delay = delay;

		_typing = true;
		_length = 0;

		this.text = '';
	}

	public function skip():Void
	{
		if (_typing)
			_length = _finalText.length;
	}

	public function resetText(text:String):Void
	{
		_finalText = text;
		_typing = false;
		_length = 0;

		this.text = '';
	}

	override public function applyMarkup(input:String, rules:Array<FlxTextFormatMarkerPair>):FlxText
	{
		super.applyMarkup(input, rules);

		resetText(text);

		return this;
	}

	override public function update(elapsed:Float):Void
	{
		if (_length < _finalText.length && _typing)
			_timer += elapsed;

		if (_typing)
		{
			if (_timer >= delay)
			{
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
		}

		final curText:String = _finalText.substr(0, _length);

		if (text != curText)
		{
			text = curText;

			if (_typing && _length >= _finalText.length)
			{
				_timer = 0;
				_typing = false;

				if (sounds != null)
				{
					for (sound in sounds)
						sound.stop();
				}
			}
		}

		super.update(elapsed);
	}
}
