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

class KeyBinds extends FlxSubState
{
	var curBind:Int = 0;
	var bindsItems:FlxTypedGroup<FlxText>;

	override function create():Void
	{
		bindsItems = new FlxTypedGroup<FlxText>();

		var i:Int = 0;
		for (key => value in Data.binds)
		{
			var text:FlxText = new FlxText(0, 0, 0, '$key: ${Data.binds.get(key).join(' / ')}', 32);
			text.font = AssetPaths.font('DTM-Sans');
			text.ID = i;
			text.scrollFactor.set();
			bindsItems.add(text);
			i++;
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
		else if (FlxG.keys.anyJustPressed(Data.binds.get('confirm'))) {}
		else if (FlxG.keys.anyJustPressed(Data.binds.get('cancel'))) {}

		super.update(elapsed);
	}

	private function changeBind(num:Int = 0):Void
	{
		curBind = FlxMath.wrap(curBind + num, 0, Data.binds.keys().length - 1);

		bindsItems.forEach(function(spr:FlxText)
		{
			spr.color = spr.ID == curBind ? FlxColor.YELLOW : FlxColor.WHITE;
		});
	}
}
