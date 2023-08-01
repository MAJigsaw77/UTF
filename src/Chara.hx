package;

import flixel.input.keyboard.FlxKey;
import flixel.FlxG;
import flixel.FlxSprite;

class Chara extends FlxSprite
{
	public function new(x:Float, y:Float, facing:String = 'down'):Void
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
	}

	override function update(elapsed:Float):Void
	{
		if (FlxG.keys.pressed.DOWN)
		{
			animation.play('down');

			y += 6;
			if (FlxG.keys.anyPressed(Data.binds.get('cancel')))
				y += 10;
		}
		else if (FlxG.keys.pressed.UP)
		{
			animation.play('up');

			y -= 6;
			if (FlxG.keys.anyPressed(Data.binds.get('cancel')))
				y -= 10;
		}

		if (FlxG.keys.pressed.LEFT)
		{
			animation.play('left');

			x -= 6;
			if (FlxG.keys.anyPressed(Data.binds.get('cancel')))
				x -= 10;
		}
		else if (FlxG.keys.pressed.RIGHT)
		{
			animation.play('right');

			x += 6;
			if (FlxG.keys.anyPressed(Data.binds.get('cancel')))
				x -= 10;
		}

		if (FlxG.keys.anyJustReleased([DOWN, UP, LEFT, RIGHT]))
			animation.finish();

		super.update(elapsed);
	}
}
