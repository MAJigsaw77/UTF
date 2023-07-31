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
	public var finishCallback:Void->Void;

	public function new(x:Float = 0, y:Float = 0, width:Int = 0, size:Int = 8):Void
	{
		super(x, y, width, '', size, true);

		font = AssetPaths.font('DTM-Mono.ttf');
		sounds = [FlxG.sound.load(AssetPaths.sound('txt2'), 0.76)];
	}

	var currentMsg:Int = 0;

	override function update(elapsed:Float):Void
	{
		if (FlxG.keys.anyJustPressed(Data.binds.get('confirm')) && alive)
		{
			if (currentMsg < msg.length)
			{
				currentMsg++;

				if (msg[currentMsg] != null)
				{
					resetText(msg[currentMsg].text);
					start(msg[currentMsg].speed / 100, true);
				}
			}
			else
			{
				kill();
				if (finishCallback != null)
					finishCallback();
			}
		}

		super.update(elapsed);
	}

	private function set_msg(value:Array<DialogueData>):Array<DialogueData>
	{
		currentMsg = 0;

		if (value[currentMsg] != null)
		{
			resetText(value[currentMsg].text);
			start(value[currentMsg].speed / 100, true);
		}

		return value;
	}
}
