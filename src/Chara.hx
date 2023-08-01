package;

import flixel.FlxSprite;

class Chara extends FlxSprite
{
	public function new(x:Float, y:Float, facing:String = 'down'):Void
	{
		super(x, y);

		frames = AssetPaths.spritesheet({
			key: 'tobdog_summer',
			sheet: [
				{animation: 'chara down', path: 'f_maincharad', frames: [3, 2, 1, 0]},
				{animation: 'chara left', path: 'f_maincharal', frames: [1, 0]},
				{animation: 'chara right', path: 'f_maincharar', frames: [1, 0]},
				{animation: 'chara up', path: 'f_maincharau', frames: [3, 2, 1, 0]}
			]
		});
		animation.addByPrefix('down', 'chara down', 4);
		animation.addByPrefix('left', 'chara right', 2);
		animation.addByPrefix('right', 'chara left', 2);
		animation.addByPrefix('up', 'chara up', 4);
		animation.play(facing);
	}

	override function update(elapsed:Float):Void
	{
		if (FlxG.keys.pressed.DOWN)
			animation.play('down');
		else if (FlxG.keys.pressed.UP)
			animation.play('up');

		if (FlxG.keys.pressed.LEFT)
			animation.play('left');
		else if (FlxG.keys.pressed.RIGHT)
			animation.play('right');

		super.update(elapsed);
	}
}
