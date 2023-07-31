package;

import flixel.addons.transition.FlxTransitionableState;

typedef RoomData =
{
	id:Int,
	objects:Array<ObjectData>
}

typedef ObjectData =
{
	name:String,
	position:Array<Float>,
	scale:Array<Float>
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
