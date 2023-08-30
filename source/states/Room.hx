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

	var solids:FlxTypedGroup<FlxSprite>;

	var chara:Chara;

	override function create():Void
	{
		solids = new FlxTypedGroup<FlxSprite>();

		final fast:Access = new Access(data);

		for (sol in fast.nodes.solid)
		{
			var solid:FlxSprite = new FlxSprite(Std.parseFloat(sol.att.x), Std.parseFloat(sol.att.y), AssetPaths.sprite(sol.att.name));
			solid.scale.set(sol.has.scaleX ? Std.parseFloat(sol.att.scaleX) : 1.0, sol.has.scaleY ? Std.parseFloat(sol.att.scaleY) : 1.0);
			solid.updateHitbox();
			solid.alpha = #if debug 0.5 #else 0 #end;
			solid.immovable = true;
			solid.solid = true;
			solids.add(solid);
		}

		add(solids);

		chara = new Chara(Std.parseFloat(obj.att.x), Std.parseFloat(obj.att.y), data.get('facing'));
		chara.scale.set(obj.has.scaleX ? Std.parseFloat(obj.att.scaleX) : 1.0, obj.has.scaleY ? Std.parseFloat(obj.att.scaleY) : 1.0);
		chara.updateHitbox();
		add(chara);

		if (data.get('cameraFollow') == 'true')
			FlxG.camera.follow(chara);

		super.create();
	}

	override function update(elapsed:Float):Void
	{
		FlxG.collide(solids, chara);

		super.update(elapsed);
	}
}
