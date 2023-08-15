package states;

import backend.AssetPaths;
import backend.Global;
import objects.Chara;
import objects.Writer;
import flixel.addons.transition.FlxTransitionableState;
import flixel.group.FlxGroup;
import flixel.math.FlxPoint;
import flixel.FlxG;
import flixel.FlxSprite;
import haxe.io.Path;
import haxe.xml.Access;
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

	var solid:FlxTypedGroup<FlxSprite>;
	var chara:Chara;

	override function create():Void
	{
		solid = new FlxTypedGroup<FlxSprite>();
		add(solid);

		final fast:Access = new Access(data);

		for (obj in fast.nodes.obj)
		{
			switch (obj.att.name)
			{
				case 'chara':
					chara = new Chara(Std.parseFloat(obj.att.x), Std.parseFloat(obj.att.y), data.get('facing'));
					chara.scale.set(obj.has.scaleX ? Std.parseFloat(obj.att.scaleX) : 1.0, obj.has.scaleY ? Std.parseFloat(obj.att.scaleY) : 1.0);
					chara.updateHitbox();
					add(chara);
				default:
					var object:FlxSprite = new FlxSprite(Std.parseFloat(obj.att.x), Std.parseFloat(obj.att.y), AssetPaths.sprite(obj.att.name));
					object.scale.set(obj.has.scaleX ? Std.parseFloat(obj.att.scaleX) : 1.0, obj.has.scaleY ? Std.parseFloat(obj.att.scaleY) : 1.0);
					object.updateHitbox();

					if (obj.att.name.startsWith('solid'))
					{
						object.alpha = 0.5;
						object.immovable = true;
						object.solid = true;
						solid.add(object);
					}
					else
						add(object);
			}
		}

		if (data.get('cameraFollow') == 'true')
			FlxG.camera.follow(chara);

		super.create();
	}

	var writer:Writer;

	override function update(elapsed:Float):Void
	{
		FlxG.collide(chara, solid);

		if (FlxG.keys.justPressed.CONTROL)
		{
			writer = new Writer(5, 5, 0, 32);
			writer.startDialogue([
				{text: '* hmmm...', speed: 4},
				{text: '* guess we didn\'t need\n  your help to have a\n  good time after all.', speed: 4},
				{text: '* ...', speed: 4},
				{text: '* say, i\'ve been\n  thinking.', speed: 4},
				{text: '* seems like you\'re\n  gonna fight my brother\n  pretty soon.', speed: 4},
				{text: '* here\'s some friendly\n  advice.', speed: 4},
				{text: '* if you keep going the\n  way you are now...', speed: 4},
				{text: '* ...', speed: 4},
				{text: '* you\'re gonna have a\n  bad time.', speed: 4},
			]);
			add(writer);
		}

		if (writer != null && writer.finished)
		{
			writer.destroy();
			remove(writer);
		}

		super.update(elapsed);
	}
}
