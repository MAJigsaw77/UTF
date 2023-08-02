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

	public function new(room:Int):Void
	{
		super();

		for (file in Assets.list(TEXT).filter(folder -> folder.startsWith('assets/data/rooms')))
		{
			// Being sure about something...
			if (Path.extension(file) == 'xml')
			{
				data = Xml.parse(Assets.getText(file)).firstElement();
				if (Std.parseInt(data.get('id')) == room)
					break;
			}
		}

		Global.room = Std.parseInt(data.get('id'));
	}

	var objects:FlxTypedGroup<FlxSprite>;
	var chara:Chara;

	override function create():Void
	{
		objects = new FlxTypedGroup<FlxSprite>();
		add(objects);

		final fast:Access = new Access(data);

		for (obj in fast.nodes.obj)
		{
			switch (obj.att.name)
			{
				case 'chara':
					chara = new Chara(Std.parseFloat(obj.att.x), Std.parseFloat(obj.att.y));
					chara.scale.set(obj.has.scaleX ? Std.parseFloat(obj.att.scaleX) : 1.0, obj.has.scaleY ? Std.parseFloat(obj.att.scaleY) : 1.0);
					chara.updateHitbox();
					chara.scrollFactor.set();
					insert(members.indexOf(objects), chara);
				default:
					var object:FlxSprite = new FlxSprite(Std.parseFloat(obj.att.x), Std.parseFloat(obj.att.y), AssetPaths.sprite(obj.att.name));

					if (obj.att.name.startsWith('solid'))
						object.alpha = 0.5;
	
					object.scale.set(obj.has.scaleX ? Std.parseFloat(obj.att.scaleX) : 1.0, obj.has.scaleY ? Std.parseFloat(obj.att.scaleY) : 1.0);
					object.updateHitbox();
					object.scrollFactor.set();
					objects.add(object);
			}
		}

		FlxG.camera.follow(chara);

		super.create();
	}

	override function update(elapsed:Float):Void
	{
		FlxG.collide(chara, objects);

		super.update(elapsed);
	}
}
