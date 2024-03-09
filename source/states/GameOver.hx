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
	var canExit:Bool = false;
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
		writer.finishCallback = function():Void
		{
			canExit = true;

			remove(writer);

			writer = null;
		}
		writer.scrollFactor.set();
		add(writer);

		super.create();

		FlxTween.tween(bg, {alpha: 1}, 1.5, {
			onComplete: function(twn:FlxTween)
			{
				new FlxTimer().start(1, function(tmr:FlxTimer)
				{
					final typer:Typer = new Typer({name: 'DTM-Mono', size: 32}, {name: 'txt1', volume: 0.86}, 2, 2);

					final lines:Array<String> = [
						'  You cannot give\n  up just yet...',
						'  Our fate rests\n  upon you...',
						'  You\'re going to\n  be alright!',
						'  Don\'t lose hope!',
						'  It cannot end\n  now!'
					];

					writer.startDialogue([
						{typer: typer, text: FlxG.random.getObject(lines)},
						{typer: typer, text: '  ${Global.name}!^1\n  Stay determined...'}
					]);
				});
			}
		});
	}

	override function update(elapsed:Float):Void
	{
		if (Controls.instance.justPressed('confirm') && canExit && bg.alpha == 1)
		{
			FlxTween.tween(bg, {alpha: 0}, 1.5, {
				onComplete: (twn:FlxTween) -> FlxG.switchState(new Room(272))
			});

			FlxG.sound.music.fadeOut(1.5);
		}

		super.update(elapsed);
	}
}
