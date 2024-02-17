package states;

import backend.AssetPaths;
import backend.Global;
import backend.Room as RoomLoader;
import backend.Script;
import flixel.addons.transition.FlxTransitionableState;
import flixel.group.FlxGroup;
import flixel.math.FlxPoint;
import flixel.FlxG;
import flixel.FlxSprite;
import haxe.io.Path;
import haxe.xml.Access;
import objects.room.Chara;
import objects.room.Object;

using StringTools;

class Room extends FlxTransitionableState
{
	var file:String;
	var data:Access;
	var script:Script;

	var chara:Chara;
	var objects:FlxTypedGroup<Object>;
	var tiles:FlxTypedGroup<FlxSprite>;

	public function new(room:Null<Int>):Void
	{
		super();

		if (room != null)
		{
			RoomLoader.reloadFiles();

			if (RoomLoader.data.exists(room))
			{
				file = RoomLoader.data.get(room).file;
				data = RoomLoader.data.get(room).content;
			}
		}
		else
		{
			if (RoomLoader.data.exists(Global.room))
			{
				file = RoomLoader.data.get(Global.room).file;
				data = RoomLoader.data.get(Global.room).content;
			}
		}

		if (data != null)
			Global.room = Std.parseInt(data.node.id.innerData);
	}

	override function create():Void
	{
		script = new Script();
		script.set('this', this);
		script.execute(AssetPaths.script('rooms/$file'));

		objects = new FlxTypedGroup<Object>();

		if (data.hasNode.instances)
		{
			final instances:Access = data.node.instances;

			for (instance in instances.nodes.instance)
			{
				switch (instance.att.objName)
				{
					case 'mainchara':
						chara = new Chara(Std.parseFloat(instance.att.x), Std.parseFloat(instance.att.y), null);

						if (instance.has.scaleX || instance.has.scaleY)
						{
							chara.scale.set(instance.has.scaleX ? Std.parseFloat(instance.att.scaleX) : 1, instance.has.scaleY ? Std.parseFloat(instance.att.scaleY) : 1);
							chara.updateHitbox();
						}

						add(chara);

						FlxG.camera.follow(chara);
					default:
						var object:Object = new Object(Std.parseFloat(instance.att.x), Std.parseFloat(instance.att.y), instance.att.objName);

						if (instance.has.scaleX || instance.has.scaleY)
						{
							object.scale.set(instance.has.scaleX ? Std.parseFloat(instance.att.scaleX) : 1, instance.has.scaleY ? Std.parseFloat(instance.att.scaleY) : 1);
							object.updateHitbox();
						}

						objects.add(object);
				}
			}
		}

		add(objects);

		FlxG.camera.setScrollBoundsRect(0, 0, Std.parseInt(data.node.width.innerData), Std.parseInt(data.node.height.innerData));

		super.create();
	}

	override function update(elapsed:Float):Void
	{
		script.call('preUpdate', [elapsed]);

		super.update(elapsed);

		if (chara != null)
		{
			FlxG.collide(chara, objects, function(obj1:Chara, obj2:FlxTypedGroup<Object>):Void
			{
				script.call('playerCollideObjects', [obj1, obj2]);
			});
		}

		script.call('postUpdate', [elapsed]);
	}
}
