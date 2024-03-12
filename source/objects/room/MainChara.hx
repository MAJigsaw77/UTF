package objects.room;

import backend.AssetPaths;
import backend.Data;
import backend.Global;
import flixel.input.keyboard.FlxKey;
import flixel.util.FlxColor;
import flixel.FlxG;
import flixel.FlxSprite;
import objects.room.Object;

class MainChara extends Object
{
	public var interacting:Bool = false;

	public function new(x:Float = 0, y:Float = 0):Void
	{
		super(x, y);

		frames = AssetPaths.spritesheet('f_mainchara');

		animation.addByPrefix('down', 'f_maincharad', 6, false);
		animation.addByPrefix('right', 'f_maincharar', 6, false);
		animation.addByPrefix('up', 'f_maincharau', 6, false);
		animation.addByPrefix('left', 'f_maincharal', 6, false);

		switch (Global.facing)
		{
			case 0:
				animation.play('down');
			case 1:
				animation.play('right');
			case 2:
				animation.play('up');
			case 3:
				animation.play('left');
		}

		animation.finish();
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

		super.update(elapsed);
	}
}
