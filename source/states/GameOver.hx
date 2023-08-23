package states;

import backend.AssetPaths;
import objects.Writer;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;

class GameOver extends FlxState
{
	private var writer:Writer;

	override function create():Void
	{
		writer = new Writer(20, 256, 0, 32);

		switch (FlxG.random.int(0, 4))
		{
			case 0:
				writer.startDialogue([
					{text: '  You cannot give\n  up just yet...', speed: 6},
					{text: '  ${Global.name}!\n  Stay determined...', speed: 6}
				]);
			case 1:
				writer.startDialogue([
					{text: '  Our fate rests \n  upon you...', speed: 6},
					{text: '  ${Global.name}!\n  Stay determined...', speed: 6}
				]);
			case 2:
				writer.startDialogue([
					{text: '  You\'re going to\n  be alright!', speed: 6},
					{text: '  ${Global.name}!\n  Stay determined...', speed: 6}
				]);
			case 3:
				writer.startDialogue([
					{text: '  Don\'t lose hope!', speed: 6},
					{text: '  ${Global.name}!\n  Stay determined...', speed: 6}
				]);
			case 4:
				writer.startDialogue([
					{text: '  It cannot end\n  now!', speed: 6},
					{text: '  ${Global.name}!\n  Stay determined...', speed: 6}
				]);
		}

		add(writer);

		super.create();
	}
}
