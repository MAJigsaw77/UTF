package objects.room;

import backend.AssetPaths;
import backend.Script;
import flixel.FlxSprite;
import haxe.Json;
import openfl.utils.Assets;

typedef ObjectData =
{
	immovable:Bool,
	solid:Bool,
	active:Bool
}

class Object extends FlxSprite
{
	public var name(default, null):String;
	public var data(default, null):ObjectData;
	public var script(default, null):Script;

	public function new(x:Float = 0, y:Float = 0, name:String):Void
	{
		this.name = name;

		super(x, y);

		if (Assets.exists(AssetPaths.data('objects/$name')))
			data = Json.parse(Assets.getText(AssetPaths.data('objects/$name')));
		else
			data = {immovable: true, solid: false, active: false};

		immovable = data.immovable;
		solid = data.solid;
		active = data.active;

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
