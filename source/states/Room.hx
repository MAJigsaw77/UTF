package states;

import backend.AssetPaths;
import backend.Global;
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
	var data:Xml;

	var solids:FlxTypedGroup<FlxSprite>;
	var markers:FlxTypedGroup<FlxSprite>;
	var doors:FlxTypedGroup<FlxSprite>;

	var chara:Chara;

	public function new(room:Int):Void
	{
		super();

		for (file in Assets.list(TEXT).filter(folder -> folder.startsWith('assets/data/rooms')))
		{
			// Being sure about something...
			if (Assets.exists(file, TEXT) && Path.extension(file) == 'xml')
			{
				data = Xml.parse(Assets.getText(file)).firstElement();
				if (Std.parseInt(data.get('id')) == room)
					break;
			}
		}

		Global.room = Std.parseInt(data.get('id'));
	}

	override function create():Void
	{
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
			object.scale.set(solid.has.scaleX ? Std.parseFloat(solid.att.scaleX) : 1.0, solid.has.scaleY ? Std.parseFloat(solid.att.scaleY) : 1.0);
			object.updateHitbox();
			object.alpha = #if debug 0.5 #else 0 #end;
			object.immovable = true;
			object.solid = true;
			solids.add(object);
		}

		add(solids);

		markers = new FlxTypedGroup<FlxSprite>();

		for (marker in fast.nodes.marker)
		{
			var object:FlxSprite = new FlxSprite(Std.parseFloat(marker.att.x), Std.parseFloat(marker.att.y), AssetPaths.sprite('marker${marker.att.name}'));
			object.scale.set(marker.has.scaleX ? Std.parseFloat(marker.att.scaleX) : 1.0, marker.has.scaleY ? Std.parseFloat(marker.att.scaleY) : 1.0);
			object.updateHitbox();
			object.immovable = true;
			markers.add(object);
		}

		add(markers);

		doors = new FlxTypedGroup<FlxSprite>();

		for (door in fast.nodes.door)
		{
			var object:FlxSprite = new FlxSprite(Std.parseFloat(door.att.x), Std.parseFloat(door.att.y), AssetPaths.sprite('door${door.att.name}'));
			object.scale.set(door.has.scaleX ? Std.parseFloat(door.att.scaleX) : 1.0, door.has.scaleY ? Std.parseFloat(door.att.scaleY) : 1.0);
			object.updateHitbox();
			object.immovable = true;
			doors.add(object);
		}

		add(doors);

		FlxG.worldBounds.set(0, 0, Std.parseInt(data.get('width')), Std.parseInt(data.get('height')));

		super.create();
	}

	override function update(elapsed:Float):Void
	{
		FlxG.collide(chara, solids);

		if (FlxG.overlap(chara, doors, playerOverlapDoors))
		{
			#if debug
			trace("the player is overlapping the door");
			#end
		}

		super.update(elapsed);
	}

	private function playerOverlapDoors(object:Chara, group:FlxTypedGroup<FlxSprite>):Void
	{
		// Do something here.
	}

	override function destroy():Void
	{
		FlxG.worldBounds.set(0, 0, FlxG.width, FlxG.height);

		super.destroy();
	}
}
