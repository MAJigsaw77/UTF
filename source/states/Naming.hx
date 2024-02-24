package states;

import backend.AssetPaths;
import backend.Controls;
import backend.Data;
import backend.Global;
import flixel.group.FlxGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;

typedef Name = {
	description:String,
	allow:Bool
}

class Naming extends FlxState
{
	final characterNames:Map<Array<String>, Name> = [
		[''] => {description: 'You must choose a name.', allow: false},
		['aaaaaa'] => {description: 'Not very creative...?', allow: true},
		['asgore'] => {description: 'You cannot.', allow: false},
		['toriel'] => {description: 'I think you should\nthink of your own\nname, my child.', allow: false},
		['sans'] => {description: 'nope.', allow: false},
		['undyne'] => {description: 'Get your OWN name!', allow: false},
		['flowey'] => {description: 'I already CHOSE\nthat name.', allow: false},
		['chara'] => {description: 'The true name.', allow: true},
		['alphys'] => {description: 'D-don\'t do that.', allow: false},
		['alphy'] => {description: 'Uh.... OK?', allow: true},
		['papyru'] => {description: 'I\'LL ALLOW IT!!!!', allow: true},
		['napsta', 'blooky'] => {description: '............\n(They\'re powerless to\nstop you.)', allow: true},
		['murder'] => {description: 'That\'s a little on-\nthe-nose, isn\'t it...?', allow: true},
		['mercy'] => {description: 'That\'s a little on-\nthe-nose, isn\'t it...?', allow: true},
		['asriel'] => {description: '...', allow: false},
		['frisk'] => {description: 'WARNING: This name will\nmake your life hell.\nProceed anyway?', allow: true},
		['catty'] => {description: 'Bratty! Bratty!\nThat\'s MY name!', allow: true},
		['bratty'] => {description: 'Like, OK I guess.', allow: true},
		['MTT', 'metta', 'mett'] => {description: 'OOOOH!!! ARE YOU\nPROMOTING MY BRAND?', allow: true},
		['gerson'] => {description: 'Wah ha ha! Why not?', allow: true},
		['shyren'] => {description: '...?', allow: true},
		['aaron'] => {description: 'Is this name correct? ; )', allow: true},
		['temmie'] => {description: 'hOI!', allow: true},
		['woshua'] => {description: 'Clean name.', allow: true},
		['jerry'] => {description: 'Jerry.', allow: true},
		['bpants'] => {description: 'You are really scraping the\nbottom of the barrel.', allow: true}
	];

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
			letter.active = false;
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
			letter.active = false;
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
			choice.active = false;
			items.add(choice);
		}

		add(items);

		changeItem();

		super.create();
	}

	override function update(elapsed:Float):Void
	{
		if (FlxG.keys.justPressed.RIGHT)
		{
			if (selected == 25)
				changeItem(32, true);
			else if (selected < 60)
				changeItem(1, false);
		}
		else if (FlxG.keys.justPressed.LEFT)
		{
			if (selected == 32)
				changeItem(25, true);
			else if (selected > 0)
				changeItem(-1, false);
		}

		if (FlxG.keys.justPressed.DOWN)
		{
			if (selected <= 57)
			{
				if (selected >= 21 && selected <= 25)
					changeItem(4, false);
				else if (selected == 19 || selected == 20)
					changeItem(11, false);

				changeItem(7, false);

				if (selected >= 58)
					changeItem(59, true);
			}
			else
			{
				if (selected == 60)
					changeItem(5, true);
				else
					changeItem(selected == 59 ? 3 : 0, true);
			}
		}
		else if (FlxG.keys.justPressed.UP)
		{
			if (selected > 6)
			{
				if (selected <= 57)
				{
					if (selected >= 32 && selected <= 36)
						changeItem(-4, false);
					else if (selected == 37 || selected == 38)
						changeItem(-11, false);

					changeItem(-7, false);
				}
				else
					changeItem(57, true);
			}
			else
			{
				if (selected > 4)
					changeItem(60, true);
				else
					changeItem(selected > 2 ? 59 : 58, true);
			}
		}

		if (Controls.instance.justPressed('confirm'))
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
		else if (Controls.instance.justPressed('cancel'))
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

	private function changeItem(num:Int = 0, force:Bool):Void
	{
		selected = Math.floor(FlxMath.bound(!force ? selected + num : num, 0, items.length - 1));

		items.forEach(function(spr:FlxText)
		{
			spr.color = spr.ID == selected ? FlxColor.YELLOW : FlxColor.WHITE;
		});
	}
}
