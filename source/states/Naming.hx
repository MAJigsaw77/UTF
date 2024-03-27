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
	static var curName:String = '';

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

	final keyActions:Map<String, DeltaMap> = [
		'RIGHT' => {delta: 1},
		'LEFT' => {delta: -1},
		'DOWN' => {delta: 7, special: [{start: 21, end: 25, delta: 5}, {start: 19, end: 20, delta: 12}]},
		'UP' => {delta: -7, special: [{start: 26, end: 30, delta: -5}, {start: 31, end: 32, delta: -12}]}
	];

	var name:FlxText;
	var letters:FlxTypedGroup<FlxText>;
	var choices:FlxTypedGroup<FlxText>;

	var selectedLetter:Int = 0;
	var selectedChoice:Int = 0;
	var writingLetters:Bool = true;

	override function create():Void
	{
		var namingText:FlxText = new FlxText(0, 60, 0, 'Name the fallen human.', 32);
		namingText.font = AssetPaths.font('DTM-Sans');
		namingText.screenCenter(X);
		namingText.scrollFactor.set();
		namingText.active = false;
		add(namingText);

		name = new FlxText(280, 110, 0, curName, 32);
		name.font = AssetPaths.font('DTM-Sans');
		name.scrollFactor.set();
		add(name);

		letters = new FlxTypedGroup<FlxText>();
		choices = new FlxTypedGroup<FlxText>();

		final upLetters:Array<Int> = [for (i in 65...91) i];

		var row:Int = 0;
		var line:Int = 0;

		// UpperCase letters.
		for (i in 0...upLetters.length)
		{
			var letter:FlxText = new FlxText(120 + line * 64, 150 + row * 28, 0, String.fromCharCode(upLetters[i]), 32);
			letter.font = AssetPaths.font('DTM-Sans');
			letter.ID = i;
			letter.scrollFactor.set();
			letter.active = false;
			letters.add(letter);

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

		// LowerCase letters.
		for (i in 0...lowLetters.length)
		{
			var letter:FlxText = new FlxText(120 + line * 64, 270 + row * 28, 0, String.fromCharCode(lowLetters[i]), 32);
			letter.font = AssetPaths.font('DTM-Sans');
			letter.ID = lowLetters.length + i;
			letter.scrollFactor.set();
			letter.active = false;
			letters.add(letter);

			line++;

			if (line > 6)
			{
				row++;

				line = 0;
			}
		}

		add(letters);

		final choiceNames:Array<String> = ['Quit', 'Backspace', 'Done'];

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
		if (writingLetters)
		{
			if (FlxG.keys.justPressed.RIGHT)
				handleKeyInput('RIGHT');
			else if (FlxG.keys.justPressed.LEFT)
				handleKeyInput('LEFT');

			if (FlxG.keys.justPressed.DOWN)
				handleKeyInput('DOWN');
			else if (FlxG.keys.justPressed.UP)
				handleKeyInput('UP');
		}
		else
		{
			if (FlxG.keys.justPressed.RIGHT)
				selectedChoice = Util.mod(selectedChoice + 1, 3);
			else if (FlxG.keys.justPressed.LEFT)
				selectedChoice = Util.mod(selectedChoice - 1, 3);

			if (FlxG.keys.justPressed.DOWN)
			{
				selectedLetter = [0, 3, 5][selectedChoice];

				writingLetters = true;
			}
			else if (FlxG.keys.justPressed.UP)
			{
				selectedLetter = [47, 50, 45][selectedChoice];

				writingLetters = true;
			}
		}

		if (Controls.instance.justPressed('confirm'))
		{
			if (writingLetters)
			{
				letters.forEach(function(spr:FlxText):Void
				{
					if (spr.ID == selectedLetter)
					{
						if (curName.length >= 6)
							curName = curName.substring(0, 5);

						curName += spr.text;

						if (curName.toLowerCase() == 'gaster')
							FlxG.resetGame();
					}
				});
			}
			else
			{
				choices.forEach(function(spr:FlxText):Void
				{
					if (spr.ID == selectedChoice)
					{
						switch (spr.text)
						{
							case 'Quit':
								FlxG.switchState(() -> new Intro());
							case 'Backspace':
								if (curName.length > 0)
									curName = curName.substring(0, curName.length - 1);
							case 'Done':
								if (curName.length <= 0)
									return;

								Global.name = curName;
								Global.flags[0] = 1;
								Global.save();

								FlxG.resetGame();
						}
					}
				});
			}
		}

		super.update(elapsed);

		#if debug
		FlxG.watch.addQuick('currentName', curName);
		FlxG.watch.addQuick('selectedLetter', selectedLetter);
		FlxG.watch.addQuick('selectedChoice', selectedChoice);
		#end

		if (name != null && name.text != curName)
			name.text = curName;

		letters.forEach(function(spr:FlxText):Void
		{
			final color:FlxColor = writingLetters && spr.ID == selectedLetter ? FlxColor.YELLOW : FlxColor.WHITE;

			if (spr.color != color)
				spr.color = color;

			spr.offset.x = ((spr.frameWidth - spr.width) * 0.5) + FlxG.random.float(-0.5, 0.5);
			spr.offset.y = ((spr.frameHeight - spr.height) * 0.5) + FlxG.random.float(-0.5, 0.5);
		});

		choices.forEach(function(spr:FlxText):Void
		{
			final color:FlxColor = !writingLetters && spr.ID == selectedChoice ? FlxColor.YELLOW : FlxColor.WHITE;

			if (spr.color != color)
				spr.color = color;
		});
	}

	private function handleKeyInput(name:String):Void
	{
		final oldLetter:Int = selectedLetter;
		final info:DeltaMap = keyActions[name];

		var delta:Int = info.delta;

		if (info.special != null)
		{
			for (sp in info.special)
			{
				if (sp.start <= selectedLetter && selectedLetter <= sp.end)
					delta = sp.delta;
			}
		}

		selectedLetter = Math.floor(FlxMath.bound(selectedLetter + delta, 0, 51));

		if (name == 'DOWN' && 45 <= oldLetter && oldLetter <= 51)
		{
			if (oldLetter >= 49)
				selectedChoice = 1;
			else if (oldLetter >= 47)
				selectedChoice = 0;
			else
				selectedChoice = 2;

			writingLetters = false;
		}
		else if (name == 'UP' && oldLetter <= 6)
		{
			if (oldLetter > 4)
				selectedChoice = 2;
			else if (oldLetter > 2)
				selectedChoice = 1;
			else
				selectedChoice = 0;

			writingLetters = false;
		}
	}
}
