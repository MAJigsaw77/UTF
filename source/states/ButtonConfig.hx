package states;

import backend.AssetPaths;
import backend.Controls;
import backend.Data;
import flixel.addons.display.shapes.FlxShapeBox;
import flixel.input.keyboard.FlxKey;
import flixel.group.FlxGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.FlxG;
import flixel.FlxState;
import states.Settings;

class ButtonConfig extends FlxState
{
	var selected:Int = 0;
	var items:FlxTypedGroup<FlxText>;

	override function create():Void
	{
		FlxG.sound.playMusic(AssetPaths.music('star'));

		var settings:FlxText = new FlxText(0, 40, 0, 'BUTTON CONFIG', 64);
		settings.font = AssetPaths.font('DTM-Sans');
		settings.screenCenter(X);
		settings.scrollFactor.set();
		settings.active = false;
		add(settings);

		var box:FlxShapeBox = new FlxShapeBox(0, 0, Std.int(FlxG.width / 2), Std.int(FlxG.height / 2),
			{thickness: 6, jointStyle: MITER, color: FlxColor.WHITE}, FlxColor.BLACK);
		box.screenCenter();
		box.scrollFactor.set();
		box.active = false;
		add(box);

		items = new FlxTypedGroup<FlxText>();

		for (i in 0...Lambda.count(Data.binds))
		{
			var text:FlxText = new FlxText(0, 180 + i * 40, 0, regenBindText(i), 32);
			text.font = AssetPaths.font('DTM-Sans');
			text.ID = i;
			text.screenCenter(X);
			text.scrollFactor.set();
			text.active = false;
			items.add(text);
		}

		add(items);

		changeBind();

		super.create();
	}

	var keySelected:Bool = false;

	override function update(elapsed:Float):Void
	{
		if (FlxG.keys.justPressed.DOWN && !keySelected)
			changeBind(1);
		else if (FlxG.keys.justPressed.UP && !keySelected)
			changeBind(-1);

		if (FlxG.keys.firstJustPressed() != FlxKey.NONE && keySelected)
		{
			keySelected = false;

			Data.binds[getBind(selected)] = FlxG.keys.firstJustPressed();

			items.forEach(function(spr:FlxText):Void
			{
				if (spr.ID == selected)
				{
					spr.text = regenBindText(selected);
					spr.screenCenter(X);
				}
			});

			Data.save();

			FlxG.sound.play(AssetPaths.sound('menuconfirm'));
		}
		else if (Controls.instance.justPressed('confirm') && !keySelected)
		{
			keySelected = true;

			FlxG.sound.play(AssetPaths.sound('menuconfirm'));
		}
		else if (Controls.instance.justPressed('cancel') && !keySelected)
		{
			if (FlxG.sound.music.playing)
				FlxG.sound.music.stop();

			FlxG.switchState(() -> new Settings());
		}

		super.update(elapsed);
	}

	private function changeBind(num:Int = 0):Void
	{
		selected = FlxMath.wrap(selected + num, 0, Lambda.count(Data.binds) - 1);

		items.forEach(function(spr:FlxText):Void
		{
			spr.color = spr.ID == selected ? FlxColor.YELLOW : FlxColor.WHITE;
		});
	}

	private function regenBindText(num:Int = 0):String
	{
		return '${getBind(num).toUpperCase()}: [${Data.binds[getBind(num)]}]';
	}

	private function getBind(num:Int = 0):String
	{
		return [for (key in Data.binds.keys()) key][num];
	}
}
