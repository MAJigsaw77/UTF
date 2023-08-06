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
	public var skippable:Bool = true;

	public function new(x:Float = 0, y:Float = 0, width:Int = 0, size:Int = 8):Void
	{
		super(x, y, width, '', size, true);

		font = AssetPaths.font('DTM-Mono');
		sounds = [FlxG.sound.load(AssetPaths.sound('txt2'), 0.76)];
	}

	private function startMsg(value:Array<DialogueData>):Void
	{
		if (value == null)
			msg = [{text: 'Error!', speed: 4}];
		else
			msg = value;

		page = 0;

		if (msg[page] != null)
		{
			resetText(msg[page].text);
			start(msg[page].speed / 100, true);
		}
	}

	private var msg:Array<DialogueData> = [{text: 'Error!', speed: 4}];
	private var page:Int = 0;

	override function update(elapsed:Float):Void
	{
		if (FlxG.keys.anyJustPressed(Data.binds.get('continue')) && msg != null && skippable)
		{
			page++;

			if (msg[page] != null && page < msg.length)
			{
				resetText(msg[page].text);
				start(msg[page].speed / 100, true);
			}
		}

		super.update(elapsed);
	}
}
