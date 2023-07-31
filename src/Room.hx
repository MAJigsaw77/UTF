package;

import Xml;
import haxe.xml.Access;
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
	var data:Xml = Xml.parse('<room id="0"></room>').firstElement();
	var objects:Array<Dynamic> = [];

	public function new(room:Int):Void
	{
		super();

		var didLoad = false;

		for (file in Assets.list(TEXT).filter(folder -> folder.startsWith('assets/data/rooms')))
		{
			// Being sure about something...
			if (Path.extension(file) == 'xml')
			{
				var roomData:String = (Assets.getText(file));
				data = Xml.parse(roomData).firstElement();
				if (Std.parseInt(data.get("id")) == room) {
					var access = new Access(data);
					for(element in access.nodes.obj) {
						objects.push({
							spr: element.att.spr,
							x: Std.parseFloat(element.att.x),
							y: Std.parseFloat(element.att.y),
							sx: element.has.sx ? Std.parseFloat(element.att.sx) : 1.0,
							sy: element.has.sy ? Std.parseFloat(element.att.sy) : 1.0,
						});
					}
					didLoad = true;
					break;
				}
			}
		}
	}

	override function create():Void
	{
		for (object in objects)
		{
			var obj:FlxSprite = new FlxSprite(object.x, object.y, AssetPaths.sprite(object.spr));
			obj.scale.set(object.sx, object.sy);
			obj.updateHitbox();
			obj.scrollFactor.set();
			add(obj);
		}

		super.create();
	}
}
