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
	public var finishedCallback:Void->Void;

	private var msg:Array<Dialogue> = [];
	private var autoContinue:Bool = false;
	private var finished:Bool = false;
	private var page:Int = 0;

	public function new(x:Float = 0, y:Float = 0, width:Int = 0, msg:Array<Dialogue>, autoContinue:Bool = false):Void
	{
		this.msg = msg;
		this.autoContinue = autoContinue;

		super(x, y, width, msg[page].text, 24, true);

		skipKeys = ['ESCAPE'];
		sounds = [FlxG.sound.load(Paths.sound('voices/uifont'))];
		font = Paths.font('DTM-Mono.otf');

		if (autoContinue)
		{
			completeCallback = function()
			{
				if (page <= msg.length)
				{
					page++;
	
					resetText(msg[page].text);

					start(msg[page].text, true);
				}
				else
				{
					finished = true;
					if (finishedCallback != null)
						finishedCallback();
				}
			}
		}
	}

	public override function update(elapsed:Float):Void
	{
		if (FlxG.keys.justPressed.ENTER && !finished && !autoContinue)
		{
			if (page <= msg.length)
			{
				page++;
	
				resetText(msg[page].text);

				start(msg[page].text, true);
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
