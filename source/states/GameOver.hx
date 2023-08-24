package states;

import backend.AssetPaths;
import backend.Data;
import objects.Writer;
import flixel.tweens.FlxTween;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;

class GameOver extends FlxState
{
	var bg:FlxSprite;
	var writer:Writer;

	override function create():Void
	{
		FlxG.sound.playMusic(AssetPaths.music('gameover'));

		bg = new FlxSprite(0, 20, AssetPaths.sprite('gameoverbg'));
		bg.alpha = 0;
		bg.screenCenter(X);
		bg.scrollFactor.set();
		add(bg);

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

		writer.scrollFactor.set();
		add(writer);

		super.create();

		FlxTween.tween(bg, {alpha: 1}, 1.5);
	}

	override function update(elapsed:Float):Void
	{
		if (FlxG.keys.checkStatus(Data.binds['confirm'], JUST_PRESSED) && writer == null && bg.alpha == 1)
		{
			FlxTween.tween(bg, {alpha: 1}, 1.5);
			FlxG.sound.music.fadeOut(1.5);
		}

		super.update(elapsed);

		if (writer != null && writer.finished)
		{
			remove(writer);
			writer = null;
		}
	}
}