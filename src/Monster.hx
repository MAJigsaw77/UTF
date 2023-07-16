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

		script = new Script();
		script.set('this', this);
		script.set('add', add);
		script.set('insert', insert);
		script.set('remove', remove);

		if (Assets.exists(AssetPaths.script('monsters/$name')))
			script.execute(AssetPaths.script('monsters/$name'));
	}

	public override function update(elapsed:Float):Void
	{
		script.call('update', [elapsed]);

		super.update(elapsed);
	}

	public override function destroy():Void
	{
		script.call('destroy');

		super.destroy();

		script.destroy();
	}
}
