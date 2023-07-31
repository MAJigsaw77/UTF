package;

import flixel.addons.transition.FlxTransitionableState;
import flixel.FlxG;
import flixel.FlxSprite;
import haxe.io.Path;
import haxe.Json;
import openfl.utils.Assets;

using StringTools;

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
	var data:RoomData;
	
	public function new(room:Int):Void
	{
		for (file in Assets.list(TEXT).filter(folder -> folder.startsWith('assets/data/rooms')))
		{
			// Being sure about something...
			if (Path.extension(file) == 'json')
			{
				var roomData:RoomData = Json.parse(Assets.getText(file));
				if (roomData.id == room)
					data = roomData;
			}
		}

		if (data == null)
		{
			data = {
				id: room,
				objects: []
			};
		}
	}

	override function create():Void
	{
		for (object in data.objects)
		{
			var obj:FlxSprite = new FlxSprite(object.position[0], object.position[1], AssetPaths.sprite(object.name));
			obj.scale.set(object.scale[0], object.scale[1]);
			obj.updateHitbox();
			obj.scrollFactor.set();
			add(obj);
		}
		
		super.create();
	}
}
