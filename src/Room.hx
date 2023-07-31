package;

import flixel.addons.transition.FlxTransitionableState;
import flixel.group.FlxGroup;
import flixel.FlxG;
import flixel.FlxSprite;
import haxe.io.Path;
import haxe.xml.Access;
import openfl.utils.Assets;

using StringTools;

class Room extends FlxTransitionableState
{
	var data:Xml = Xml.parse('<room id="0"></room>').firstElement();

	var objects:FlxTypedGroup<ObjectData>;

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
					break;
			}
		}
	}

	override function create():Void
	{
		var access:Access = new Access(data);

		for (element in access.nodes.obj)
		{
			var obj:FlxSprite = new FlxSprite(Std.parseFloat(element.att.x), Std.parseFloat(element.att.y), AssetPaths.sprite(element.att.name));
			obj.scale.set(element.has.scaleX ? Std.parseFloat(element.att.scaleX) : 1.0, element.has.scaleY ? Std.parseFloat(element.att.scaleY) : 1.0);
			obj.updateHitbox();
			obj.scrollFactor.set();
			add(obj);
		}

		super.create();
	}
}
