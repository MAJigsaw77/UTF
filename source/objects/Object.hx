package objects;

import backend.AssetPaths;
import backend.Script;
import flixel.group.FlxSpriteGroup;
import haxe.Json;
import openfl.utils.Assets;

typedef ObjectrData =
{
	immovable:Bool,
	solid:Bool,
	active:Bool
}

class Object extends FlxSprite
{
	public var data(default, null):MonsterData;
	public var script(default, null):Script;

	public function new(x:Float = 0, y:Float = 0, name:String):Void
	{
		super(x, y);

		if (Assets.exists(AssetPaths.data('objects/$name')))
			data = Json.parse(Assets.getText(AssetPaths.data('objects/$name')));
		else
		{
			FlxG.log.notice('Loading default data for $name object');

			data = {immovable: true, solid: false, maxHp: active};
		}

		script = new Script();
		script.set('this', this);
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
