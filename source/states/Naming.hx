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
	var selected:Int = 0;
	final choices:Array<String> = ['Quit', 'Backspace', 'Done'];
	var items:FlxTypedGroup<FlxText>;
	var name:FlxText;

	override function create():Void
	{
		var namingText:FlxText = new FlxText(0, 60, 0, 'Name the fallen human.', 32);
		namingText.font = AssetPaths.font('DTM-Sans');
		namingText.screenCenter(X);
		namingText.scrollFactor.set();
		add(namingText);

		name = new FlxText(280, 110, 0, '', 32);
		name.font = AssetPaths.font('DTM-Sans');
		name.scrollFactor.set();
		add(name);

		items = new FlxTypedGroup<FlxText>();

		final upLetters:Array<Int> = [for (i in 65...91) i];

		var row:Int = 0;
		var line:Int = 0;

		// UpperCase Letters.
		for (i in 0...upLetters.length)
		{
			var letter:FlxText = new FlxText(120 + line * 64, 150 + row * 28, 0, String.fromCharCode(upLetters[i]), 32);
			letter.font = AssetPaths.font('DTM-Sans');
			letter.ID = i;
			letter.scrollFactor.set();
			items.add(letter);

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
		for (i in 0...lowLetters.length)
		{
			var letter:FlxText = new FlxText(120 + line * 64, 270 + row * 28, 0, String.fromCharCode(lowLetters[i]), 32);
			letter.font = AssetPaths.font('DTM-Sans');
			letter.ID = lowLetters.length + i;
			letter.scrollFactor.set();
			items.add(letter);

			line++;

			if (line > 6)
			{
				row++;
				line = 0;
			}
		}

		// Choices.
		for (i in 0...choices.length)
		{
			var choice:FlxText = new FlxText(0, 0, 0, choices[i], 32);

			switch (choices[i])
			{
				case 'Quit':
					choice.setPosition(120, 400);
				case 'Backspace':
					choice.setPosition(240, 400);
				case 'Done':
					choice.setPosition(440, 400);
			}

			choice.font = AssetPaths.font('DTM-Sans');
			choice.ID = (upLetters.length + lowLetters.length) + i;
			choice.scrollFactor.set();
			items.add(choice);
		}

		add(items);

		changeItem();

		super.create();
	}

	override function update(elapsed:Float):Void
	{
		if (FlxG.keys.justPressed.DOWN)
			changeItem(selected == 26 ? 8 : 7); // Stupid workaround
		else if (FlxG.keys.justPressed.UP)
			changeItem(selected == 26 ? -8 : -7); // Stupid workaround

		if (FlxG.keys.justPressed.RIGHT)
			changeItem(1);
		else if (FlxG.keys.justPressed.LEFT)
			changeItem(-1);

		if (FlxG.keys.checkStatus(Data.binds.get('confirm'), JUST_PRESSED))
		{
			items.forEach(function(spr:FlxText)
			{
				if (spr.ID == selected)
				{
					switch (spr.text)
					{
						case 'Quit':
							FlxG.switchState(new Intro());
						case 'Backspace':
							if (name.text.length > 0)
								name.text = name.text.substring(0, name.text.length - 1);
						case 'Done':
							if (name.text.length <= 0)
								return;

							Global.name = name.text;
							Global.flags[0] = 1;
							Global.save();

							FlxG.resetGame();
						default:
							if (name.text.length >= 6)
								name.text = name.text.substring(0, 5);

							name.text += spr.text;

							if (name.text.toLowerCase() == 'gaster')
								FlxG.resetGame();
					}
				}
			});
		}
		else if (FlxG.keys.checkStatus(Data.binds.get('cancel'), JUST_PRESSED))
		{
			if (name.text.length > 0)
				name.text = name.text.substring(0, name.text.length - 1);
		}

		super.update(elapsed);

		items.forEach(function(spr:FlxText)
		{
			if (!choices.contains(spr.text))
			{
				spr.offset.x = ((spr.frameWidth - spr.width) * 0.5) + FlxG.random.float(-0.5, 0.5);
				spr.offset.y = ((spr.frameHeight - spr.height) * 0.5) + FlxG.random.float(-0.5, 0.5);
			}
		});
	}

	private function changeItem(num:Int = 0):Void
	{
		selected = Math.floor(FlxMath.bound(selected + num, 0, items.length - 1));

		items.forEach(function(spr:FlxText)
		{
			spr.color = spr.ID == selected ? FlxColor.YELLOW : FlxColor.WHITE;
		});
	}
}
