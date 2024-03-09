package objects.room;

import backend.AssetPaths;
import backend.Script;
import flixel.FlxSprite;

class Object extends FlxSprite
{
	public var interacting:Bool = false;
	public var name(default, null):String;
	public var script(default, null):Script;

	public function new(x:Float = 0, y:Float = 0, name:String):Void
	{
		this.name = name;

		super(x, y);

		script = new Script();
		script.set('this', this);
		script.execute(AssetPaths.script('objects/$name'));
	}

	public function interact():Void
	{
		script.call('interact');
	}

	public override function update(elapsed:Float):Void
	{
		script.call('preUpdate', [elapsed]);

		super.update(elapsed);

		script.call('postUpdate', [elapsed]);
	}

	public override function destroy():Void
	{
		script.call('destroy');

		super.destroy();

		script.close();
	}
}
