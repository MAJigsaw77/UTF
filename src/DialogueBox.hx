package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;

using StringTools;

class DialogueBox extends FlxSpriteGroup
{
	var curLine:Int = 0;
	var curDialogue:Array<String> = [];

	var box:FlxSprite;
	var writer:FlxTypeText;

	public function new(font:String, dialogue:Array<String>):String
	{
		super();

		box = new FlxSprite(0, 0);
		box.loadGraphic(createDialogBox());
		box.screenCenter(X);
		add(box);

		writer = new FlxTypeText(0, 0, 0, '', 24);
		writer.font = font;
		writer.sounds = [FlxG.sound.load(Paths.sound('pixelText'), 0.6)];
		add(writer);
	}

	override function update(elapsed:Float)
	{
		if (dialogueOpened && !dialogueStarted)
		{
			startDialogue();
			dialogueStarted = true;
		}

		if (FlxG.keys.justPressed.ANY && dialogueEnded)
		{
			FlxG.sound.play(Paths.sound('clickText'), 0.8);

			if (dialogueList[1] == null && dialogueList[0] != null)
			{
				if (!isEnding)
				{
					isEnding = true;

					new FlxTimer().start(0.2, function(tmr:FlxTimer)
					{
						box.alpha -= 1 / 5;
						bgFade.alpha -= 1 / 5 * 0.7;
						portraitLeft.visible = false;
						portraitRight.visible = false;
						writer.alpha -= 1 / 5;
						handSelect.alpha -= 1 / 5;
						dropText.alpha = writer.alpha;
					}, 5);

					new FlxTimer().start(1.2, function(tmr:FlxTimer)
					{
						finishThing();
						kill();
					});
				}
			}
			else
			{
				dialogueList.remove(dialogueList[0]);
				startDialogue();
			}
		}
		else if (FlxG.keys.justPressed.ANY && dialogueStarted)
			writer.skip();

		super.update(elapsed);
	}

	function startDialogue():Void
	{
		writer.resetText(dialogueList[0]);
		writer.start(0.04);
		writer.completeCallback = function()
		{
			;
			dialogueEnded = true;
		};
		dialogueEnded = false;
	}

	private function createDialogBox():BitmapData
	{
		var shape:Shape = new Shape();
		shape.graphics.beginFill(0xFFFFFFFF);
		shape.graphics.drawRect(0, 0, 304, 235);
		shape.graphics.endFill();
		shape.graphics.beginFill(0);
		shape.graphics.drawRect(3, 3, 301, 232);
		shape.graphics.endFill();

		var bitmap:BitmapData = new BitmapData(304, 235, true, 0);
		bitmap.draw(shape, true);
		return bitmap;
	}
}

class Story extends FroggitState
{
	public var Dialogue:StoryText;

	public override function create():Void
	{
		super.create();

		Dialogue = new StoryText(0, 0, 500);
		Dialogue.screenCenter(XY);
		add(Dialogue);

		FlxG.sound.playMusic(Paths.getMusic('event/ut-story'), 1, false);
		FlxG.sound.music.pitch = 0.9;

		FlxG.sound.music.onComplete = function()
		{
			Dialogue.resetText(Dialogue.text);
			FlxG.switchState(new Menu());
		};

		Dialogue.start(Dialogue.curSpeed, true);
	}

	public override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (FlxG.keys.justPressed.ENTER)
		{
			Dialogue.resetText(Dialogue.text);
			FlxG.sound.music.stop();
			FlxG.switchState(new Menu());
		}
	}
}
