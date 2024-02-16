package objects.dialogue;

import flixel.FlxG;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.sound.FlxSound;

/**
 * @see https://github.com/SuxxorState/poopshit-public/blob/main/source/objects/UTTypeText.hx
 */
class TypeText extends FlxText
{
	public var delay:Float = 0.05;
	public var eraseDelay:Float = 0.02;
	public var showCursor:Bool = false;
	public var cursorCharacter:String = '|';
	public var cursorBlinkSpeed:Float = 0.5;
	public var prefix:String = '';
	public var autoErase:Bool = false;
	public var waitTime:Float = 1.0;
	public var paused:Bool = false;
	public var sounds:Array<FlxSound>;
	public var finishSounds:Bool = false;
	public var completeCallback:Void->Void;
	public var eraseCallback:Void->Void;

	var _trueDelay:Float = 0.05;
	var _finalText:String = '';
	var _helperText:String = '';
	var _timer:Float = 0.0;
	var _length:Int = 0;
	var _typing:Bool = false;
	var _erasing:Bool = false;
	var _waiting:Bool = false;
	var _waitTimer:Float = 0.0;
	var _cursorTimer:Float = 0.0;
	var _typingVariation:Bool = false;
	var _typeVarPercent:Float = 0.5;

	final _ignoreCharacters:Array<String> = ['`', '~', '!', '*', '(', ')', '-', '_', '=', '+', '{', '}', '[', ']', '\'', '\\', '|', ':', ';', ',', '<', '.', '>', '/', '?', '^', ' '];
	final _punctuationChars:Array<String> = ['.', ',', '!', '?', ':', ';'];

	public function new(X:Float, Y:Float, Width:Int, Text:String, Size:Int = 8, EmbeddedFont:Bool = true)
	{
		super(X, Y, Width, '', Size, EmbeddedFont);

		_finalText = Text;
	}

	public function start(?Delay:Float, ForceRestart:Bool = false, AutoErase:Bool = false, ?Callback:Void->Void):Void
	{
		if (Delay != null)
			delay = Delay;

		_typing = true;
		_erasing = false;
		paused = false;
		_waiting = false;

		if (ForceRestart)
		{
			text = '';
			_length = 0;
		}

		autoErase = AutoErase;

		if (Callback != null)
			completeCallback = Callback;

		insertBreakLines();
	}

	public function erase(?Delay:Float, ForceRestart:Bool = false, ?Callback:Void->Void):Void
	{
		_erasing = true;
		_typing = false;
		paused = false;
		_waiting = false;

		if (Delay != null)
			eraseDelay = Delay;

		if (ForceRestart)
		{
			_length = _finalText.length;
			text = _finalText;
		}

		eraseCallback = Callback;
	}

	public function skip():Void
	{
		if (_erasing || _waiting)
		{
			_length = 0;
			_waiting = false;
		}
		else if (_typing)
			_length = _finalText.length;
	}

	public function resetText(Text:String):Void
	{
		text = '';
		_finalText = Text;
		_typing = false;
		_erasing = false;
		paused = false;
		_waiting = false;
		_length = 0;
		_trueDelay = delay;
	}

	public function setTypingVariation(Amount:Float = 0.5, On:Bool = true):Void
	{
		_typingVariation = On;
		_typeVarPercent = FlxMath.bound(Amount, 0, 1);
	}

	override public function applyMarkup(input:String, rules:Array<FlxTextFormatMarkerPair>):FlxText
	{
		super.applyMarkup(input, rules);

		resetText(text);

		return this;
	}

	override public function update(elapsed:Float):Void
	{
		if (_waiting && !paused)
		{
			_waitTimer -= elapsed;

			if (_waitTimer <= 0)
			{
				_waiting = false;
				_erasing = true;
			}
		}

		if (!_waiting && !paused && ((_length < _finalText.length && _typing) || (_length > 0 && _erasing)))
			_timer += elapsed;

		if (_typing || _erasing)
		{
			if (_typing && _timer >= _trueDelay)
			{
				_length += Std.int(_timer / _trueDelay);

				if (_length > _finalText.length)
					_length = _finalText.length;
			}

			if (_erasing && _timer >= eraseDelay)
			{
				_length -= Std.int(_timer / eraseDelay);

				if (_length < 0)
					_length = 0;
			}

			if ((_typing && _timer >= _trueDelay) || (_erasing && _timer >= eraseDelay))
			{
				if (_punctuationChars.contains(_finalText.charAt(_length - 2))
					&& !_punctuationChars.contains(_finalText.charAt(_length - 1))
					&& !_punctuationChars.contains(_finalText.charAt(_length))
					&& _length > 1)
					_trueDelay = 0.3;
				else
					_trueDelay = _erasing ? eraseDelay : delay;

				if (_typingVariation)
					_timer = FlxG.random.float(-_trueDelay * _typeVarPercent / 2, _trueDelay * _typeVarPercent / 2);
				else
					_timer %= _trueDelay;

				if (!_ignoreCharacters.contains(_finalText.charAt(_length - 1)) && sounds != null)
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

		_helperText = prefix + _finalText.substr(0, _length);

		if (showCursor)
		{
			_cursorTimer += elapsed;

			if (_cursorTimer > cursorBlinkSpeed / 2 && (prefix + _finalText).charAt(_helperText.length) != '\n')
				_helperText += cursorCharacter.charAt(0);

			if (_cursorTimer > cursorBlinkSpeed)
				_cursorTimer = 0;
		}

		if (_helperText != text)
		{
			text = _helperText;

			if (_length >= _finalText.length && _typing && !_waiting && !_erasing)
				onComplete();

			if (_length == 0 && _erasing && !_typing && !_waiting)
				onErased();
		}

		super.update(elapsed);
	}

	function insertBreakLines():Void
	{
		final saveText:String = text;

		var last:Int = _finalText.length;
		var n0:Int = 0;
		var n1:Int = 0;

		while (true)
		{
			last = _finalText.substr(0, last).lastIndexOf(' ');

			if (last <= 0)
				break;

			text = prefix + _finalText;

			n0 = textField.numLines;

			final nextText:String = _finalText.substr(0, last) + '\n' + _finalText.substr(last + 1, _finalText.length);

			text = prefix + nextText;

			n1 = textField.numLines;

			if (n0 == n1)
				_finalText = nextText;
		}

		text = saveText;
	}

	function onComplete():Void
	{
		_timer = 0;
		_typing = false;

		if (sounds != null)
		{
			for (sound in sounds)
				sound.stop();
		}

		if (completeCallback != null)
			completeCallback();

		if (autoErase && waitTime <= 0)
			_erasing = true;
		else if (autoErase)
		{
			_waitTimer = waitTime;
			_waiting = true;
		}
	}

	function onErased():Void
	{
		_timer = 0;
		_erasing = false;

		if (eraseCallback != null)
			eraseCallback();
	}
}
