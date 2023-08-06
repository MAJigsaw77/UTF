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
	public var msg(default, set):Array<DialogueData> = [{text: 'Error!', speed: 4}];
	public var skippable:Bool = true;

	public function new(x:Float = 0, y:Float = 0, width:Int = 0, size:Int = 8):Void
	{
		super(x, y, width, '', size, true);

		font = AssetPaths.font('DTM-Mono');
		sounds = [FlxG.sound.load(AssetPaths.sound('txt2'), 0.76)];
	}

	private var page:Int = 0;

	override function update(elapsed:Float):Void
	{
		if (FlxG.keys.anyJustPressed(Data.binds.get('continue')) && skippable)
		{
			page++;

			if (msg[page] != null && page < msg.length)
			{
				resetText(msg[page].text);
				start(msg[page].speed / 100, 
			}
		}

		super.update(elapsed);
	}

	private function set_msg(value:Array<DialogueData>):Array<DialogueData>
	{
		page = 0;

		if (value[page] != null)
		{
			resetText(value[page].text);
			start(value[page].speed / 100, true);
		}

		return value;
	}
}
