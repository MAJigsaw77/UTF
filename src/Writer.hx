package;

import flixel.FlxG;
import flixel.addons.text.FlxTypeText;

typedef Dialogue = {
	var text:String;
	var delay:Float;
}

class Writer extends FlxTypeText
{
	public var msg(default, set):Dialogue = {text: 'Error!', delay: 0.04};

	public function new(x:Float = 0, y:Float = 0, width:Int = 0):Void
	{
		super(x, y, width, '', 24, true);

		font = AssetPaths.font('DTM-Mono.otf');
		sounds = [FlxG.sound.load(AssetPaths.sound('txt2'), 0.76)];
	}

	private function set_msg(value:Dialogue):Dialogue
	{
		if (value.text != null)
		{
			resetText(value.text);
			start(value.delay, true);
		}

		return value;
	}
}
