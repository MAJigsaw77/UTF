package;

import flixel.addons.transition.FlxTransitionableState;

typedef RoomData =
{
	id:Int,
	objects:Array<Dynamic>
}

class Room extends FlxTransitionableState
{
	public function new(room:Int):Void {}

	override function create():Void
	{
		super.create();
	}

	override function update(elapsed:Float):Void
	{
		super.update(elapsed);
	}
}
