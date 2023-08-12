package;

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
		bindsItems = new FlxTypedGroup<FlxText>();

		for (i in 0...Lambda.count(Data.binds))
		{
			var text:FlxText = new FlxText(0, 120 + i * 40, 0, genBindText(i), 32);
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

	override function update(elapsed:Float):Void
	{
		if (FlxG.keys.justPressed.DOWN)
			changeBind(1);
		else if (FlxG.keys.justPressed.UP)
			changeBind(-1);
		else if (FlxG.keys.checkStatus(Data.binds['confirm'], JUST_PRESSED))
		{
			// TODO
		}
		else if (FlxG.keys.checkStatus(Data.binds['cancel'], JUST_PRESSED))
			close();

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
		final key:String = Lambda.array(Data.binds)[num];

		return '$key: ' + cast(Data.binds[key], String);
	}
}
