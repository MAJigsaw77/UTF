package states;

import backend.AssetPaths;
import backend.Data;
import backend.Global;
import flixel.group.FlxGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;

class Naming extends FlxState
{
	var curLetter:Int = 0;
	var letterItems:FlxTypedGroup<FlxText>;

	override function create():Void
	{
		var namingText:FlxText = new FlxText(180, 60, 0, 'Name the fallen human.', 32);
		namingText.font = AssetPaths.font('DTM-Sans');
		namingText.screenCenter(X);
		namingText.scrollFactor.set();
		add(namingText);

		letterItems = new FlxTypedGroup<FlxText>();
		
		// UpperCase Letters.
		for (i in 65...91)
		{
			var letter:FlxText = new FlxText(0, 0, 0, String.fromCharCode(i), 32);
			letter.font = AssetPaths.font('DTM-Sans');
			letter.ID = i; // Ugh
			letter.scrollFactor.set();
			letterItems.add(letter);
		}

		// LowerCase Letters.
		for (i in 97...123)
		{
			var letter:FlxText = new FlxText(0, 0, 0, String.fromCharCode(i), 32);
			letter.font = AssetPaths.font('DTM-Sans');
			letter.ID = i; // Ugh
			letter.scrollFactor.set();
			letterItems.add(letter);
		}

		add(letterItems);

		changeLetter();

		super.create();
	}

	override function update(elapsed:Float):Void
	{
		if (FlxG.keys.justPressed.DOWN)
			changeLetter(1);
		else if (FlxG.keys.justPressed.UP)
			changeLetter(-1);

		if (FlxG.keys.justPressed.RIGHT)
			changeLetter(1);
		else if (FlxG.keys.justPressed.LEFT)
			changeLetter(-1);

		if (FlxG.keys.checkStatus(Data.binds['confirm'], JUST_PRESSED))
		{
			// TODO
		}

		super.update(elapsed);

		letterItems.forEach(function(spr:FlxText)
		{
			// Shaking shit
		});
	}

	private function changeLetter(num:Int = 0):Void
	{
		curLetter = FlxMath.wrap(curLetter + num, 0, letterItems.length - 1);

		letterItems.forEach(function(spr:FlxText)
		{
			spr.color = spr.ID == curLetter ? FlxColor.YELLOW : FlxColor.WHITE;
		});
	}
}
