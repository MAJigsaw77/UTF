package;

import flixel.group.FlxSpriteGroup;
import haxe.Json;
import openfl.utils.Assets;
import Global;

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
		script.set('add', add);
		script.set('insert', insert);
		script.set('remove', remove);

		if (Assets.exists(AssetPaths.script('monsters/$name')))
			script.execute(AssetPaths.script('monsters/$name'));
	}

	public override function update(elapsed:Float):Void
	{
		script.call('preUpdate', [elapsed]);

		super.update(elapsed);

		script.call('postUpdate', [elapsed]);
	}

	public override function draw():Void
	{
		script.call('preDraw');

		super.draw();

		script.call('postDraw');
	}

	public override function destroy():Void
	{
		script.call('preDestroy');

		super.destroy();

		script.call('postDestroy');

		script.destroy();
	}
}
