package;

import flixel.group.FlxSpriteGroup;
import haxe.Json;
import openfl.utils.Assets;

typedef MonsterData = {
	var name:String;
	var hp:Int;
	var maxHp:Int;
	var attack:Float;
	var defense:Float:
	var xpReward:Int;
	var goldReward:Int;
}

class Monster extends FlxSpriteGroup
{
	public var data:MonsterData;
	public var script:Script;

	public function new(x:Float = 0, y:Float = 0, name:String):Void
	{
		super(x, y);

		if (Assets.exists(AssetPaths.data('monsters/$name')))
			data = Json.parse(Assets.getText(AssetPaths.data('monsters/$name')));
	}

	public override function update(elapsed:Float):Void
	{
		super.update(elapsed);
	}
}
