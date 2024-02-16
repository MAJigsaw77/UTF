package states;

import backend.AssetPaths;
import backend.Global;
import backend.Room as RoomLoader;
import backend.Script;
// #if debug
// import flixel.addons.display.FlxGridOverlay;
// #end
import flixel.addons.transition.FlxTransitionableState;
import flixel.group.FlxGroup;
import flixel.math.FlxPoint;
import flixel.FlxG;
import flixel.FlxSprite;
import haxe.io.Path;
import haxe.xml.Access;
import objects.Chara;
import objects.Writer;

using StringTools;

class Room extends FlxTransitionableState
{
	var file:String;
	var data:Access;
	var script:Script;

	var chara:Chara;
	var objects:FlxTypedGroup<Objects>;
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
			Global.room = Std.parseInt(data.get('id'));
	}

	override function create():Void
	{
		script = new Script();
		script.set('this', this);
		script.execute(AssetPaths.script('rooms/$file'));

		// #if debug
		// var grid:FlxSprite = FlxGridOverlay.create(40, 40, Std.parseInt(data.get('width')), Std.parseInt(data.get('height')));
		// grid.scrollFactor.set();
		// grid.active = false;
		// add(grid);
		// #end

		chara = new Chara(Std.parseFloat(access.node.chara.att.x), Std.parseFloat(access.node.chara.att.y), access.node.chara.att.facing);
		chara.scale.set(2, 2);
		chara.updateHitbox();
		add(chara);

		FlxG.camera.follow(chara);

		objects = new FlxTypedGroup<FlxSprite>();

		if (access.hasNode.instances)
		{
			final instances:NodeAccess = data.node.instances;

			for (instance in instances.nodes.instance)
			{
			var object:FlxSprite = new FlxSprite(Std.parseFloat(obj.att.x), Std.parseFloat(obj.att.y), AssetPaths.sprite(obj.att.name));

			if (obj.has.scaleX || obj.has.scaleY)
			{
				object.scale.set(obj.has.scaleX ? Std.parseFloat(obj.att.scaleX) : 1, obj.has.scaleY ? Std.parseFloat(obj.att.scaleY) : 1);
				object.updateHitbox();
			}

			object.immovable = true;
			object.solid = true;
			object.active = false;
			objects.add(object);
			}
		}

		add(objects);

		FlxG.camera.setScrollBoundsRect(0, 0, Std.parseInt(data.get('width')), Std.parseInt(data.get('height')));

		super.create();
	}

	override function update(elapsed:Float):Void
	{
		script.call('preUpdate', [elapsed]);

		items.forEach(function(object:Object):Void
		{
			FlxG.collide(chara, object, function(obj1:Chara, obj2:Object):Void
			{
				script.call('playerOverlapObject', [obj1, obj2]);
			});
		});

		super.update(elapsed);

		script.call('postUpdate', [elapsed]);
	}
}
