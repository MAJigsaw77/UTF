package states;

import backend.AssetPaths;
import backend.Global;
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
import openfl.utils.Assets;

using StringTools;

class Room extends FlxTransitionableState
{
	var file:String;
	var data:Xml;
	var script:Script;

	var solids:FlxTypedGroup<FlxSprite>;
	var markers:FlxTypedGroup<FlxSprite>;
	var objects:FlxTypedGroup<FlxSprite>;
	var doors:FlxTypedGroup<FlxSprite>;

	var chara:Chara;

	public function new(room:Int):Void
	{
		super();

		final files:Array<String> = Assets.list(TEXT).filter(function(file:String):Bool
		{
			return Path.directory(file) == 'assets/data/rooms' && Path.extension(file) == 'xml';
		});

		files.sort(function(a:String, b:String):Int
		{
			return (a < b) ? -1 : (a > b) ? 1 : 0;
		});

		for (path in files)
		{
			file = new Path(path).file;

			data = Xml.parse(Assets.getText(path)).firstElement();

			if (Std.parseInt(data.get('id')) == room)
				break;
		}

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

		final fast:Access = new Access(data);

		chara = new Chara(Std.parseFloat(fast.node.chara.att.x), Std.parseFloat(fast.node.chara.att.y), fast.node.chara.att.facing);
		chara.scale.set(2, 2);
		chara.updateHitbox();
		add(chara);

		FlxG.camera.follow(chara);

		solids = new FlxTypedGroup<FlxSprite>();

		for (solid in fast.nodes.solid)
		{
			var object:FlxSprite = new FlxSprite(Std.parseFloat(solid.att.x), Std.parseFloat(solid.att.y), AssetPaths.sprite('solid${solid.att.type}'));

			if (solid.has.scaleX || solid.has.scaleY)
			{
				object.scale.set(solid.has.scaleX ? Std.parseFloat(solid.att.scaleX) : 1, solid.has.scaleY ? Std.parseFloat(solid.att.scaleY) : 1);
				object.updateHitbox();
			}

			object.alpha = #if debug 0.5 #else 0 #end;
			object.immovable = true;
			object.solid = true;
			object.active = false;
			solids.add(object);
		}

		add(solids);

		markers = new FlxTypedGroup<FlxSprite>();

		for (marker in fast.nodes.marker)
		{
			var object:FlxSprite = new FlxSprite(Std.parseFloat(marker.att.x), Std.parseFloat(marker.att.y), AssetPaths.sprite('marker${marker.att.name}'));

			if (marker.has.scaleX || marker.has.scaleY)
			{
				object.scale.set(marker.has.scaleX ? Std.parseFloat(marker.att.scaleX) : 1, marker.has.scaleY ? Std.parseFloat(marker.att.scaleY) : 1);
				object.updateHitbox();
			}

			#if !debug
			object.alpha = 0;
			#end
			object.immovable = true;
			object.active = false;
			markers.add(object);
		}

		add(markers);

		objects = new FlxTypedGroup<FlxSprite>();

		for (obj in fast.nodes.obj)
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

		add(objects);

		doors = new FlxTypedGroup<FlxSprite>();

		for (door in fast.nodes.door)
		{
			var object:FlxSprite = new FlxSprite(Std.parseFloat(door.att.x), Std.parseFloat(door.att.y), AssetPaths.sprite('door${door.att.name}'));

			if (door.has.scaleX || door.has.scaleY)
			{
				object.scale.set(door.has.scaleX ? Std.parseFloat(door.att.scaleX) : 1, door.has.scaleY ? Std.parseFloat(door.att.scaleY) : 1);
				object.updateHitbox();
			}

			#if !debug
			object.alpha = 0;
			#end
			object.immovable = true;
			object.active = false;
			doors.add(object);
		}

		add(doors);

		FlxG.camera.setScrollBoundsRect(0, 0, Std.parseInt(data.get('width')), Std.parseInt(data.get('height')));

		super.create();
	}

	override function update(elapsed:Float):Void
	{
		script.call('update', [elapsed]);

		FlxG.collide(chara, solids);
		FlxG.collide(chara, objects);

		FlxG.overlap(chara, doors, playerOverlapDoors);

		#if debug
		FlxG.watch.addQuick('Chara X', chara.x);
		FlxG.watch.addQuick('Chara Y', chara.y);
		#end

		super.update(elapsed);
	}

	private function playerOverlapDoors(object:Chara, group:FlxTypedGroup<FlxSprite>):Void
	{
		script.call('playerOverlapDoors');
	}
}
