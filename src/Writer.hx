package;

import flixel.FlxG;
import flixel.addons.text.FlxTypeText;

typedef Dialogue =
{
	var text:String;
	var speed:Float;
}

class Writer extends FlxTypeText
{
	public var msg:Array<Dialogue> = [];

	private var page:Int = 0;

	public function new(X:Float = 0, Y:Float = 0, Width:Int = 0):Void
	{
		super(X, Y, Width, msgList[page].text, 24, true);

		skipKeys = ['ESCAPE'];
		sounds = [FlxG.sound.load(Paths.sound('voices/uifont'))];
		font = Paths.font('DTM-Mono.otf');
		completeCallback = function()
		{
			page += 1;

			if (page != msgList.length)
			{
				resetText(msgList[page].text);
				start(msgList[page].text, true);
			}
			else
				resetText('');
		}
	}
}
