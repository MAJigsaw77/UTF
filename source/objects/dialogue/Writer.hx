package objects.dialogue;

import backend.AssetPaths;
import backend.Controls;
import backend.Data;
import flixel.FlxG;
import objects.dialogue.TypeText;
import objects.dialogue.Typer;

using flixel.util.FlxArrayUtil;

typedef DialogueData = {
	typer:Typer,
	text:String
}

class Writer extends TypeText
{
	public var finishCallback:Void->Void = null;

	var list:Array<DialogueData> = [];
	var page:Int = 0;

	public function new(x:Float = 0, y:Float = 0):Void
	{
		super(x, y, 0, 8, true);
	}

	public function startDialogue(list:Array<DialogueData>):Void
	{
		this.list = list ??= [{ typer: new Typer({ name: 'DTM-Mono', size: 32 }, { name: 'txt2', volume: 0.86 }, 4), text: 'Error!' }];

		page = 0;

		if (list[page] != null)
			changeDialogue(list[page]);
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

		if (dialogue.typer.spacing != null && letterSpacing != dialogue.typer.spacing)
			letterSpacing = dialogue.typer.spacing;

		start(dialogue.text, 1 / (dialogue.typer.speed * 10));
	}

	override public function update(elapsed:Float):Void
	{
		if (Controls.instance.justPressed('confirm'))
		{
			if (!finished)
			{
				skip();

				return;
			}

			if (page < list.indexOf(list.last()))
			{
				page++;

				changeDialogue(list[page]);
			}
			else if (page == list.indexOf(list.last()))
			{
				if (finishCallback != null)
					finishCallback();
			}
		}

		super.update(elapsed);
	}
}
