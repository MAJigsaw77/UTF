package states;

import backend.AssetPaths;
import backend.Controls;
import backend.Data;
import backend.Global;
import backend.Util;
import flixel.group.FlxGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;

typedef Name =
{
	description:String,
	allow:Bool
}

typedef DeltaMap =
{
	delta:Int,
	?special:Array<SpecialDelta>
}

typedef SpecialDelta =
{
	delta:Int,
	start:Int,
	end:Int
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
		['murder', 'mercy'] => {description: 'That\'s a little on-\nthe-nose, isn\'t it...?', allow: true},
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
		['bpants'] => {description: 'You are really scraping the\nbottom of the barrel.', allow: true},
		['jigsaw'] => {description: 'I want to play\na game.', allow: true}
	];

	final keyMap:Map<String, DeltaMap> = [
		'RIGHT' => {delta: 1},
		'LEFT' => {delta: -1},
		'DOWN' => {delta: 7, special: [{start: 21, end: 25, delta: 5}, {start: 19, end: 20, delta: 12}]},
		'UP' => {delta: -7, special: [{start: 26, end: 30, delta: -5}, {start: 31, end: 32, delta: -12}]}
	];

	var selected:Int = 0;
	var selectedChoice:Int = 0;
	final choiceNames:Array<String> = ['Quit', 'Backspace', 'Done'];
	var items:FlxTypedGroup<FlxText>;
	var choices:FlxTypedGroup<FlxText>;
	var name:FlxText;
	var inItems:Bool = true;

	override function create():Void
	{
		var namingText:FlxText = new FlxText(0, 60, 0, 'Name the fallen human.', 32);
		namingText.font = AssetPaths.font('DTM-Sans');
		namingText.screenCenter(X);
		namingText.scrollFactor.set();
		namingText.active = false;
		add(namingText);

		name = new FlxText(280, 110, 0, '', 32);
		name.font = AssetPaths.font('DTM-Sans');
		name.scrollFactor.set();
		add(name);

		items = new FlxTypedGroup<FlxText>();
		choices = new FlxTypedGroup<FlxText>();

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

		add(items);

		// Choices.
		for (i in 0...choiceNames.length)
		{
			var choice:FlxText = new FlxText(0, 0, 0, choiceNames[i], 32);

			switch (choiceNames[i])
			{
				case 'Quit':
					choice.setPosition(120, 400);
				case 'Backspace':
					choice.setPosition(240, 400);
				case 'Done':
					choice.setPosition(440, 400);
			}

			choice.font = AssetPaths.font('DTM-Sans');
			choice.ID = i;
			choice.scrollFactor.set();
			choice.active = false;
			choices.add(choice);
		}

		add(choices);

		super.create();
	}

	override function update(elapsed:Float):Void
	{
		if (inItems)
		{
			if (FlxG.keys.justPressed.RIGHT)
				handleKeyInput("RIGHT");
			else if (FlxG.keys.justPressed.LEFT)
				handleKeyInput("LEFT");
			else if (FlxG.keys.justPressed.DOWN)
				handleKeyInput("DOWN");
			else if (FlxG.keys.justPressed.UP)
				handleKeyInput("UP");
		}
		else
		{
			if (FlxG.keys.justPressed.RIGHT)
				selectedChoice = Util.mod(selectedChoice + 1, 3);
			else if (FlxG.keys.justPressed.LEFT)
				selectedChoice = Util.mod(selectedChoice - 1, 3);

			if (FlxG.keys.justPressed.DOWN || FlxG.keys.justPressed.UP)
			{
				selected = FlxG.keys.justPressed.UP ? [47, 50, 45][selectedChoice] : [0, 3, 5][selectedChoice];

				inItems = true;
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

		#if debug
		FlxG.watch.addQuick('selected', selected);
		FlxG.watch.addQuick('selectedChoice', selectedChoice);
		#end

		items.forEach(function(spr:FlxText)
		{
			final color:FlxColor = inItems && spr.ID == selected ? FlxColor.YELLOW : FlxColor.WHITE;

			if (spr.color != color)
				spr.color = color;

			spr.offset.x = ((spr.frameWidth - spr.width) * 0.5) + FlxG.random.float(-0.5, 0.5);
			spr.offset.y = ((spr.frameHeight - spr.height) * 0.5) + FlxG.random.float(-0.5, 0.5);
		});

		choices.forEach(function(spr:FlxText)
		{
			final color:FlxColor = !inItems && spr.ID == selectedChoice ? FlxColor.YELLOW : FlxColor.WHITE;

			if (spr.color != color)
				spr.color = color;
		});
	}

	private function handleKeyInput(name:String):Void
	{
		var oldSelected:Int = selected;
		var info:DeltaMap = keyMap[name];
		var delta:Int = info.delta;

		if (info.special != null)
		{
			for (sp in info.special)
			{
				if (sp.start <= selected && selected <= sp.end)
					delta = sp.delta;
			}
		}

		selected = Math.floor(FlxMath.bound(selected + delta, 0, 51));

		if (name == "DOWN" && 45 <= oldSelected && oldSelected <= 51)
		{
			if (oldSelected >= 49)
				selectedChoice = 1;
			else if (oldSelected >= 47)
				selectedChoice = 0;
			else
				selectedChoice = 2;

			inItems = false;
		}

		if (name == "UP" && oldSelected <= 6)
		{
			if (oldSelected > 4)
				selectedChoice = 2;
			else if (oldSelected > 2)
				selectedChoice = 1;
			else
				selectedChoice = 0;

			inItems = false;
		}
	}
}
