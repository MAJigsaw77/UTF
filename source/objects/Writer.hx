package objects;

import backend.AssetPaths;
import backend.Data;
import flixel.addons.text.FlxTypeText;
import flixel.FlxG;

using flixel.util.FlxArrayUtil;

typedef DialogueData =
{
	?face:String,
	?font:String,
	?sound:DialogueSound,
	text:String,
	?speed:Null<Float>
}

typedef DialogueSound =
{
	path:String,
	volume:Float
}

/**
 * Helper class for dialogue text
**/
class Writer extends FlxTypeText
{
	public var skippable:Bool = true;
	public var finished(default, null):Bool = false;

	@:noCompletion
	private var dialogueList:Array<DialogueData> = [];

	@:noCompletion
	private var page:Int = 0;

	public function new(x:Float = 0, y:Float = 0, width:Int = 0, size:Int = 8):Void
	{
		super(x, y, width, '', size, true);

		sounds = [FlxG.sound.load(AssetPaths.sound('txt2'), 0.76)];
	}

	public function startDialogue(list:Array<DialogueData>):Void
	{
		finished = false;
		dialogueList = list == null ? [{text: 'Error!', speed: 4}] : list;
		page = 0;

		if (dialogueList[page] != null)
			changeDialogue(dialogueList[page]);
		else
			FlxG.log.notice('Hey, there\'s NOTHING in here to be said!');
	}

	public function changeDialogue(dialogue:DialogueData):Void
	{
		if (dialogue == null)
			dialogue = {text: 'Error!', speed: 4};

		font = AssetPaths.font(dialogue.font != null ? dialogue.font : 'DTM-Mono');

		resetText(dialogue.text != null ? dialogue.text : 'Error!');
		start(dialogue.speed != null ? dialogue.speed / 100 : 0.04, true);
	}

	override function update(elapsed:Float):Void
	{
		if (FlxG.keys.checkStatus(Data.binds['confirm'], JUST_PRESSED) && !finished && skippable)
		{
			page++;

			if (page > dialogueList.indexOf(dialogueList.last()))
			{
				page--;
				finished = true;
				return;
			}

			changeDialogue(dialogueList[page]);
		}

		super.update(elapsed);
	}
}
