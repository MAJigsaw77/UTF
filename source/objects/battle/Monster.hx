package objects.battle;

import backend.AssetPaths;
import backend.Script;
import flixel.group.FlxSpriteGroup;
import haxe.Json;
import openfl.utils.Assets;

typedef MonsterData =
{
	name:String,
	hp:Int,
	maxHp:Int,
	attack:Float,
	defense:Float,
	xpReward:Int,
	goldReward:Int
}

class Monster extends FlxSpriteGroup
{
	public var data(default, null):MonsterData;
	public var script(default, null):Script;

	public function new(x:Float = 0, y:Float = 0, name:String):Void
	{
		super(x, y);

		if (Assets.exists(AssetPaths.data('monsters/$name')))
			data = Json.parse(Assets.getText(AssetPaths.data('monsters/$name')));
		else
		{
			data = {
				name: 'Error',
				hp: 50,
				maxHp: 50,
				attack: 0,
				defense: 0,
				xpReward: 0,
				goldReward: 0
			};
		}

		script = new Script();

		script.set('this', this);

		if (Assets.exists(AssetPaths.script('monsters/$name')))
			script.execute(AssetPaths.script('monsters/$name'));
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
