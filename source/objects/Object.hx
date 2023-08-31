package objects;

import backend.AssetPaths;
import backend.Script;
import flixel.FlxSprite;
import openfl.utils.Assets;

class Object extends FlxSprite
{
	public var script(default, null):Script;

	public function new(x:Float = 0, y:Float = 0, key:String):Void
	{
		super(x, y, AssetPaths.sprite(key));

		script = new Script();

		script.set('this', this);

		if (Assets.exists(AssetPaths.script('objects/$name')))
			script.execute(AssetPaths.script('objects/$name'));
	}

	public override function update(elapsed:Float):Void
	{
		script.call('preUpdate', [elapsed]);

		super.update(elapsed);

		script.call('postUpdate', [elapsed]);
	}

	public override function destroy():Void
	{
		script.call('preDestroy');

		super.destroy();

		script.call('postDestroy');

		script.close();
	}
}
