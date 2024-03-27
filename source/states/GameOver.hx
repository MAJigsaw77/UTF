package states;

import backend.AssetPaths;
import backend.Controls;
import backend.Data;
import backend.Global;
import backend.Typers;
import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import objects.dialogue.Writer;
import states.Room;

class GameOver extends FlxState
{
	var bg:FlxSprite;
	var writer:Writer;

	override function create():Void
	{
		Typers.reloadFiles();

		FlxG.sound.playMusic(AssetPaths.music('gameover'));

		bg = new FlxSprite(0, 30, AssetPaths.sprite('gameoverbg'));
		bg.alpha = 0;
		bg.screenCenter(X);
		bg.scrollFactor.set();
		bg.active = false;
		add(bg);

		writer = new Writer(120, 320);
		writer.skippable = false;
		writer.finishCallback = () -> remove(writer);
		writer.scrollFactor.set();
		add(writer);

		super.create();

		FlxTween.tween(bg, {alpha: 1}, 1.5, {
			onComplete: function(twn:FlxTween)
			{
				new FlxTimer().start(1, function(tmr:FlxTimer)
				{
					final lines:Array<String> = [
						'  You cannot give\n  up just yet...',
						'  Our fate rests\n  upon you...',
						'  You\'re going to\n  be alright!',
						'  Don\'t lose hope!',
						'  It cannot end\n  now!'
					];

					writer.startDialogue([
						{typer: Typers.data.get('gameover'), text: FlxG.random.getObject(lines)},
						{typer: Typers.data.get('gameover'), text: '  ${Global.name}!^1\n  Stay determined...'}
					]);
				});
			}
		});
	}

	override function update(elapsed:Float):Void
	{
		if (Controls.instance.justPressed('confirm') && !members.contains(writer) && bg.alpha == 1)
		{
			FlxTween.tween(bg, {alpha: 0}, 1.5, {
				onComplete: (twn:FlxTween) -> FlxG.switchState(() -> new Room(272))
			});

			FlxG.sound.music.fadeOut(1.5);
		}

		super.update(elapsed);
	}
}
