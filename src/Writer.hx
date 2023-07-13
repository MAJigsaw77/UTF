package;

import flixel.FlxG;
import flixel.addons.text.FlxTypeText;

typedef Dialogue = {
	var text:String;
	var delay:Float;
}

class Writer extends FlxTypeText
{
	public var msg(default, set):Array<Dialogue> = [{text: 'Error!', delay: 0.04}];

	private function set_msg(value:Array<Dialogue>):Array<Dialogue>
	{
		page = 0;
		resetText(value[page].text);
		return value;
	}

	public var finishedCallback:Void->Void;

	private var page:Int = 0;
	private var finished:Bool = false;

	public function new(x:Float = 0, y:Float = 0, width:Int = 0):Void
	{
		super(x, y, width, '', 24, true);

		skipKeys = ['ESCAPE'];
		font = Paths.font('DTM-Mono.otf');
		sounds = [FlxG.sound.load(Paths.sound('voices/uifont'))];
	}

	override public function update(elapsed:Float):Void
	{
		if (FlxG.keys.justPressed.ENTER && !finished)
		{
			if (page <= msg.length)
			{
				page++;
				resetText(msg[page].text);
				start(msg[page].delay, true);
			}
			else
			{
				finished = true;
				if (finishedCallback != null)
					finishedCallback();
			}
		}

		super.update(elapsed);
	}
}
