package states;

import backend.AssetPaths;
import backend.Controls;
import backend.Global;
import backend.Room as RoomLoader;
import backend.Script;
import flixel.addons.display.shapes.FlxShapeBox;
import flixel.addons.transition.FlxTransitionableState;
import flixel.group.FlxGroup;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxSprite;
import haxe.io.Path;
import haxe.xml.Access;
import objects.dialogue.Writer;
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

	var camGame:FlxCamera;
	var camHud:FlxCamera;

	var box:FlxShapeBox;
	var writer:Writer;

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

		camGame = new FlxCamera();
		FlxG.cameras.reset(camGame);

		camHud = new FlxCamera();
		camHud.bgColor.alpha = 0;
		FlxG.cameras.add(camHud, false);

		FlxG.cameras.setDefaultDrawTarget(camGame, true);

		objects = new FlxTypedGroup<Object>();
		add(objects);

		if (data.hasNode.instances)
		{
			final instances:Access = data.node.instances;

			for (instance in instances.nodes.instance)
			{
				switch (instance.att.objName)
				{
					case 'mainchara':
						chara = new Chara(Std.parseFloat(instance.att.x), Std.parseFloat(instance.att.y));
						chara.scale.scale(instance.has.scaleX ? Std.parseFloat(instance.att.scaleX) : 1, instance.has.scaleY ? Std.parseFloat(instance.att.scaleY) : 1);
						chara.updateHitbox();
						add(chara);
					default:
						var object:Object = new Object(Std.parseFloat(instance.att.x), Std.parseFloat(instance.att.y), instance.att.objName);
						object.scale.scale(instance.has.scaleX ? Std.parseFloat(instance.att.scaleX) : 1, instance.has.scaleY ? Std.parseFloat(instance.att.scaleY) : 1);
						object.updateHitbox();
						objects.add(object);
				}
			}
		}
		else
			FlxG.log.notice('There are no instances to load');

		if (chara != null)
			FlxG.camera.follow(chara);

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

			objects.forEach(function(object:Object):Void
			{
				if (Controls.instance.justPressed('confirm') && chara.overlaps(object) && !object.interacting)
					object.interact();
			});
		}

		script.call('postUpdate', [elapsed]);
	}

	private function startDialogue(dialogue:Array<DialogueData>, ?finishCallback:Void->Void):Void
	{
		if (dialogue == null)
			return;

		box = new FlxShapeBox(32, (chara != null && chara.y >= 260) ? 10 : 320, 576, 150, {thickness: 6, jointStyle: MITER, color: FlxColor.WHITE}, FlxColor.BLACK);
		box.scrollFactor.set();
		box.camera = camHud;
		box.active = false;
		add(box);

		writer = new Writer(box.x + 20, box.y + 10);
		writer.finishCallback = function():Void
		{
			if (finishCallback != null)
				finishCallback();
			
			remove(box);
			remove(writer);
		}
		writer.scrollFactor.set();
		writer.camera = camHud;
		add(writer);

		writer.startDialogue(dialogue);
	}
}
