package objects.dialogue;

import backend.AssetPaths;
import backend.Controls;
import backend.Data;
import backend.Typers;
import flixel.FlxG;
import objects.dialogue.TypeText;

using flixel.util.FlxArrayUtil;

typedef DialogueData =
{
	typer:TyperData,
	text:String
}

class Writer extends TypeText
{
	public var skippable:Bool = true;
	public var finishCallback:Void->Void = null;

	var done:Bool = false;
	var list:Array<DialogueData> = [];
	var page:Int = 0;

	public function new(x:Float = 0, y:Float = 0):Void
	{
		super(x, y, 0, 8, true);
	}

	public function startDialogue(list:Array<DialogueData>):Void
	{
		this.list = list ?? [{
			typer: {
				font: {
					name: 'DTM-Mono',
					size: 32
				},
				sounds: [{
					name: 'txt1',
					volume: 1
				}],
				delay: 0.05,
				spacing: null
			},
			text: 'Error!'
		}];

		page = 0;

		if (list[page] != null)
			changeDialogue(list[page]);
	}

	public function changeDialogue(dialogue:DialogueData):Void
	{
		if (dialogue == null)
		{
			dialogue = {
				typer: {
					font: {
						name: 'DTM-Mono',
						size: 32
					},
					sounds: [{
						name: 'txt1',
						volume: 1
					}],
					delay: 0.05,
					spacing: null
				},
				text: 'Error!'
			};
		}

		sounds = [];

		for (sound in dialogue.typer.sounds)
			sounds.push(FlxG.sound.load(AssetPaths.sound(sound.name), sound.volume));

		if (font != AssetPaths.font(dialogue.typer.font.name))
			font = AssetPaths.font(dialogue.typer.font.name);

		if (size != dialogue.typer.font.size)
			size = dialogue.typer.font.size;

		if (dialogue.typer.spacing != null && letterSpacing != dialogue.typer.spacing)
			letterSpacing = dialogue.typer.spacing;

		done = false;

		start(dialogue.text, dialogue.typer.delay);
	}

	override public function update(elapsed:Float):Void
	{
		if (Controls.instance.justPressed('confirm') && finished && !done)
		{
			if (page < list.indexOf(list.last()))
			{
				page++;

				changeDialogue(list[page]);
			}
			else if (page == list.indexOf(list.last()))
			{
				if (finishCallback != null)
					finishCallback();

				done = true;
			}
		}
		else if (Controls.instance.justPressed('cancel') && !finished && skippable)
			skip();

		super.update(elapsed);
	}
}
