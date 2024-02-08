package objects;

import backend.AssetPaths;
import backend.Controls;
import backend.Data;
import flixel.addons.text.FlxTypeText;
import flixel.FlxG;
import objects.Typer;

using flixel.util.FlxArrayUtil;

typedef DialogueData =
{
	typer:Typer,
	text:String
}

class Writer extends FlxTypeText
{
	public var finished(default, null):Bool = false;
	public var skippable:Bool = true;

	@:noCompletion
	private var dialogueList:Array<DialogueData> = [];

	@:noCompletion
	private var page:Int = 0;

	public function new(x:Float = 0, y:Float = 0):Void
	{
		super(x, y, 0, '', 8, true);
	}

	public function startDialogue(list:Array<DialogueData>):Void
	{
		finished = false;
		dialogueList = list ??= [{typer: new Typer({name: 'DTM-Mono', size: 32}, {name: 'txt2', volume: 0.86}, 4), text: 'Error!'}];
		page = 0;

		if (dialogueList[page] != null)
			changeDialogue(dialogueList[page]);
		else
			FlxG.log.notice('Hey, there\'s NOTHING in here to be said!');
	}

	public function changeDialogue(dialogue:DialogueData):Void
	{
		if (dialogue == null)
			dialogue = {typer: new Typer({name: 'DTM-Mono', size: 32}, {name: 'txt2', volume: 0.86}, 4), text: 'Error!'};

		sounds = [FlxG.sound.load(AssetPaths.sound(dialogue.typer.sound.name), dialogue.typer.sound.volume)];

		if (font != AssetPaths.font(dialogue.typer.font.name))
			font = AssetPaths.font(dialogue.typer.font.name);

		if (size != dialogue.typer.font.size)
			size = dialogue.typer.font.size;

		@:privateAccess
		{
			if (dialogue.typer.font.spacing != null)
			{
				if (_defaultFormat.letterSpacing != dialogue.typer.font.spacing)
					_defaultFormat.letterSpacing = dialogue.typer.font.spacing;

				updateDefaultFormat();
			}
		}

		resetText(dialogue.text);
		start(dialogue.typer.speed / 100, true);
	}

	override public function update(elapsed:Float):Void
	{
		if (Controls.instance.justPressed('cancel') && !finished && skippable)
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
