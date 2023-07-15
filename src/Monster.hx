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
	public function new():Void
	{
		super();
	}

	public override function update(elapsed:Float):Void
	{
		super.update(elapsed);
	}
}
