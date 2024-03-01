package objects.settings;

import flixel.system.FlxAssets;
import flixel.FlxG;
import flixel.FlxSprite;

class FallLeaf extends FlxSprite
{
	private var rotSpeed:Int = 0
	private var siner:Int = 0;
	private var sinerFactor:Int = 0;

	public function new(LeafGraphic:FlxGraphicAsset):Void
	{
		super(0, 0, LeafGraphic);

		x = FlxG.random.int(0, FlxG.width);
		alpha = 0.5;
		acceleration.y = 120;
		velocity.set((FlxG.random.bool() ? -1 : 1) * (1 + FlxG.random.int(0, 1)), 60);

		rotSpeed = (FlxG.random.bool() ? -1 : 1) * (2 + FlxG.random.int(0, 4));
		sinerFactor = (FlxG.random.bool() ? -1 : 1) * FlxG.random.int(0, 1);
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed)

		if (y > 500)
			destroy();

		siner++;

		x += Math.sin(siner / 5) * sinerFactor;
		y += Math.cos(siner / 6) * sinerFactor;

		angle += rotSpeed;
	}
}
