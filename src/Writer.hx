package;

import flixel.addons.text.FlxTypeText;
import flixel.FlxG;

typedef DialogueData =
{
	?face:String,
	text:String,
	speed:Float
}

class Writer extends FlxTypeText
{
	public var msg(default, set):DialogueData = {text: 'Error!', speed: 4};

	public function new(x:Float = 0, y:Float = 0, width:Int = 0, size:Int = 8):Void
	{
		super(x, y, width, '', size, true);

		font = AssetPaths.font('DTM-Mono');
		sounds = [FlxG.sound.load(AssetPaths.sound('txt2'), 0.76)];
	}

	private function set_msg(value:DialogueData):DialogueData
	{
		if (value.text != null)
		{
			resetText(value.text);
			start(value.speed / 100, true);
		}

		return value;
	}
}
