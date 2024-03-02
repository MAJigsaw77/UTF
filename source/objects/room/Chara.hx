package objects.room;

import backend.AssetPaths;
import backend.Data;
import flixel.input.keyboard.FlxKey;
import flixel.FlxG;
import flixel.FlxSprite;

class Chara extends FlxSprite
{
	public var interacting:Bool = false;
	public var hitbox:FlxSprite;

	public function new(x:Float = 0, y:Float = 0, facing:String):Void
	{
		super(x, y);

		frames = AssetPaths.spritesheet({
			key: 'f_mainchara',
			sheet: [
				{animation: 'chara down', path: 'f_maincharad', frames: [3, 2, 1, 0]},
				{animation: 'chara left', path: 'f_maincharal', frames: [1, 0]},
				{animation: 'chara right', path: 'f_maincharar', frames: [1, 0]},
				{animation: 'chara up', path: 'f_maincharau', frames: [3, 2, 1, 0]}
			]
		});

		animation.addByPrefix('down', 'chara down', 6, false);
		animation.addByPrefix('left', 'chara left', 6, false);
		animation.addByPrefix('right', 'chara right', 6, false);
		animation.addByPrefix('up', 'chara up', 6, false);
		animation.play(facing);

		animation.finish();

		hitbox = new FlxSprite(x, y);
		hitbox.makeGraphic(Math.floor(width / 2), Math.floor(height / 2), FlxG.TRANSPARENT);
		hitbox.offset.set(width / 4, height / 4);
	}

	override public function update(elapsed:Float):Void
	{
		if (!interacting)
		{
			if (FlxG.keys.pressed.DOWN)
			{
				if (!FlxG.keys.anyPressed([RIGHT, LEFT]))
					animation.play('down');

				velocity.y = 180;
				#if debug
				if (FlxG.keys.checkStatus(Data.binds.get('cancel'), PRESSED))
					velocity.y = 300;
				#end
			}
			else if (FlxG.keys.pressed.UP)
			{
				if (!FlxG.keys.anyPressed([RIGHT, LEFT]))
					animation.play('up');

				velocity.y = -180;
				#if debug
				if (FlxG.keys.checkStatus(Data.binds.get('cancel'), PRESSED))
					velocity.y = -300;
				#end
			}

			if (FlxG.keys.pressed.RIGHT)
			{
				animation.play('right');

				velocity.x = 180;
				#if debug
				if (FlxG.keys.checkStatus(Data.binds.get('cancel'), PRESSED))
					velocity.x = 300;
				#end
			}
			else if (FlxG.keys.pressed.LEFT)
			{
				animation.play('left');

				velocity.x = -180;
				#if debug
				if (FlxG.keys.checkStatus(Data.binds.get('cancel'), PRESSED))
					velocity.x = -300;
				#end
			}
		}
		else if (!animation.finished)
		{
			animation.finish();

			velocity.set();
		}

		if (FlxG.keys.anyJustReleased([DOWN, UP, RIGHT, LEFT]))
		{
			animation.finish();
			velocity.set();
		}

		hitbox.setPosition(x + width / 4, y + height / 4);

		super.update(elapsed);
	}
}
