package;

import flixel.addons.transition.FlxTransitionableState;
import flixel.FlxG;
import flixel.FlxSprite;
import haxe.io.Path;
import haxe.xml.Access;
import openfl.utils.Assets;

using StringTools;

typedef ObjectData =
{
	name:String,
	x:Float,
	y:Float,
	scaleX:Float,
	scaleY:Float
}

class Room extends FlxTransitionableState
{
	var data:Xml = Xml.parse('<room id="0"></room>').firstElement();
	var objects:Array<ObjectData> = [];

	public function new(room:Int):Void
	{
		super();

		for (file in Assets.list(TEXT).filter(folder -> folder.startsWith('assets/data/rooms')))
		{
			// Being sure about something...
			if (Path.extension(file) == 'xml')
			{
				data = Xml.parse(Assets.getText(file)).firstElement();

				if (Std.parseInt(data.get("id")) == room)
				{
					var access = new Access(data);

					for (element in access.nodes.obj)
					{
						objects.push({
							name: element.att.name,
							x: Std.parseFloat(element.att.x),
							y: Std.parseFloat(element.att.y),
							scaleX: element.has.scaleX ? Std.parseFloat(element.att.scaleX) : 1.0,
							scaleY: element.has.scaleY ? Std.parseFloat(element.att.scaleY) : 1.0,
						});
					}
	
					break;
				}
			}
		}
	}

	override function create():Void
	{
		for (object in objects)
		{
			var obj:FlxSprite = new FlxSprite(object.x, object.y, AssetPaths.sprite(object.name));
			obj.scale.set(object.scaleX, object.scaleY);
			obj.updateHitbox();
			obj.scrollFactor.set();
			add(obj);
		}

		super.create();
	}
}
