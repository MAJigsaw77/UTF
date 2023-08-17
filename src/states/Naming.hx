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

	var charname:FlxText;
	
	override function create():Void
	{
		var namingText:FlxText = new FlxText(0, 60, 0, 'Name the fallen human.', 32);
		namingText.font = AssetPaths.font('DTM-Sans');
		namingText.screenCenter(X);
		namingText.scrollFactor.set();
		add(namingText);

		charname = new FlxText(280, 110, 0, '', 32);
		charname.font = AssetPaths.font('DTM-Sans');
		charname.scrollFactor.set();
		add(charname);

		letterItems = new FlxTypedGroup<FlxText>();
		
		final upLetters:Array<Int> = [for (i in 65...91) i];

		var row:Int = 0;
		var line:Int = 0;

		// UpperCase Letters.
		for (i in 0...upLetters.length)
		{
			var letter:FlxText = new FlxText(120 + line * 64, 150 + row * 28, 0, String.fromCharCode(upLetters[i]), 32);
			letter.font = AssetPaths.font('DTM-Sans');
			letter.ID = i; // Ugh
			letter.scrollFactor.set();
			letterItems.add(letter);

			line++;
			if (line > 6)
			{
				row++;
				line = 0;
			}
		}

		final lowLetters:Array<Int> = [for (i in 97...123) i];

		var row:Int = 0;
		var line:Int = 0;

		// LowerCase Letters.
		for (i in 0...upLetters.length)
		{
			var letter:FlxText = new FlxText(120 + line * 64, 270 + row * 28, 0, String.fromCharCode(lowLetters[i]), 32);
			letter.font = AssetPaths.font('DTM-Sans');
			letter.ID = i + 26; // Ugh
			letter.scrollFactor.set();
			letterItems.add(letter);

			line++;
			if (line > 6)
			{
				row++;
				line = 0;
			}
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
			letterItems.forEach(function(spr:FlxText)
			{
				switch (spr.text)
				{
					case 'Quit':
						FlxG.switchState(new Intro());
					case 'BackSpace':
						charname.text = charname.text.substring(0, charname.length - 1);
					case 'Done':
						// Idk for now.
					default:
						charname.text += spr.text;
				}
			});
		}

		super.update(elapsed);

		letterItems.forEach(function(spr:FlxText)
		{
			spr.offset.x = ((spr.frameWidth - spr.width) * 0.5) + FlxG.random.float(-0.5, 0.5);
                        spr.offset.y = ((spr.frameHeight - spr.height) * 0.5) + FlxG.random.float(-0.5, 0.5);
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
