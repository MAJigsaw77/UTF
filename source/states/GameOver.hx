package states;

import backend.AssetPaths;
import backend.Controls;
import backend.Data;
import backend.Global;
import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import objects.dialogue.Typer;
import objects.dialogue.Writer;
import states.Room;

class GameOver extends FlxState
{
	var bg:FlxSprite;
	var writer:Writer;

	override function create():Void
	{
		FlxG.sound.playMusic(AssetPaths.music('gameover'));

		bg = new FlxSprite(0, 30, AssetPaths.sprite('gameoverbg'));
		bg.alpha = 0;
		bg.screenCenter(X);
		bg.scrollFactor.set();
		bg.active = false;
		add(bg);

		writer = new Writer(120, 320);
		writer.scrollFactor.set();
		add(writer);

		super.create();

		FlxTween.tween(bg, {alpha: 1}, 1.5, {
			onComplete: function(twn:FlxTween)
			{
				new FlxTimer().start(1, function(tmr:FlxTimer)
				{
					final typer:Typer = new Typer({name: 'DTM-Mono', size: 32}, {name: 'txt2', volume: 0.86}, 2, 2);

					switch (FlxG.random.int(0, 5))
					{
						case 0:
							writer.startDialogue([
								{typer: typer, text: '  You cannot give\n  up just yet...'},
								{typer: typer, text: '  ${Global.name}!^1\n  Stay determined...'}
							]);
						case 1:
							writer.startDialogue([
								{typer: typer, text: '  Our fate rests\n  upon you...'},
								{typer: typer, text: '  ${Global.name}!^1\n  Stay determined...'}
							]);
						case 2:
							writer.startDialogue([
								{typer: typer, text: '  You\'re going to\n  be alright!'},
								{typer: typer, text: '  ${Global.name}!^1\n  Stay determined...'}
							]);
						case 3:
							writer.startDialogue([
								{typer: typer, text: '  Don\'t lose hope!'},
								{typer: typer, text: '  ${Global.name}!^1\n  Stay determined...'}
							]);
						case 4:
							writer.startDialogue([
								{typer: typer, text: '  It cannot end\n  now!'},
								{typer: typer, text: '  ${Global.name}!^1\n  Stay determined...'}
							]);
					}
				});
			}
		});
	}

	override function update(elapsed:Float):Void
	{
		if (Controls.instance.justPressed('confirm') && writer == null && bg.alpha == 1)
		{
			FlxTween.tween(bg, {alpha: 0}, 1.5, {
				onComplete: (twn:FlxTween) -> FlxG.switchState(new Room(272))
			});

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
