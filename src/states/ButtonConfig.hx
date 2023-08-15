package states;

import backend.AssetPaths;
import backend.Data;
import flixel.addons.display.shapes.FlxShapeBox;
import flixel.input.keyboard.FlxKey;
import flixel.group.FlxGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;

using StringTools;

class ButtonConfig extends FlxSubState
{
	var curBind:Int = 0;
	var bindsItems:FlxTypedGroup<FlxText>;

	override function create():Void
	{
		var bg:FlxSprite = new FlxSprite();
		bg.makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		bg.screenCenter();
		bg.scrollFactor.set();
		bg.alpha = 0.5;
		add(bg);

		var box:FlxShapeBox = new FlxShapeBox(0, 0, Std.int(FlxG.width / 2), Std.int(FlxG.height / 2),
			{thickness: 6, jointStyle: MITER, color: FlxColor.WHITE}, FlxColor.BLACK);
		box.screenCenter();
		box.scrollFactor.set();
		add(box);

		bindsItems = new FlxTypedGroup<FlxText>();

		for (i in 0...Lambda.count(Data.binds))
		{
			var text:FlxText = new FlxText(0, 180 + i * 40, 0, genBindText(i), 32);
			text.font = AssetPaths.font('DTM-Sans');
			text.ID = i;
			text.screenCenter(X);
			text.scrollFactor.set();
			bindsItems.add(text);
		}

		add(bindsItems);

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
		else if (FlxG.keys.checkStatus(Data.binds['confirm'], JUST_PRESSED))
		{
			// TODO
		}
		else if (FlxG.keys.checkStatus(Data.binds['cancel'], JUST_PRESSED))
		{
			if (keySelected)
				keySelected = false;
			else
				close();
		}

		super.update(elapsed);
	}

	private function changeBind(num:Int = 0):Void
	{
		curBind = FlxMath.wrap(curBind + num, 0, Lambda.count(Data.binds) - 1);

		bindsItems.forEach(function(spr:FlxText)
		{
			spr.color = spr.ID == curBind ? FlxColor.YELLOW : FlxColor.WHITE;
		});
	}

	private function genBindText(num:Int = 0):String
	{
		final keys:Array<String> = [];
		for (key in Data.binds.keys())
			keys.push(key.toLowerCase());

		// kinda stupid but ok
		return '${keys[num].toUpperCase()}: ${Data.binds[keys[num]]}';
	}
}
