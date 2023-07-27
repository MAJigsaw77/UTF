package;

import flixel.group.FlxGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import openfl.Lib;

class IntroMenu extends FlxState
{
	var curChoice:Int = 0;
	final choices:Array<String> = ['Continue', 'Reset', 'Settings'];
	var choicesItems:FlxTypedGroup<FlxText>;

	override function create():Void
	{
		FlxG.sound.playMusic(AssetPaths.music('menu1'));

		var bg:FlxSprite = new FlxSprite(0, -240, AssetPaths.background('floweyglow'));
		bg.scale.set(2, 2);
		bg.updateHitbox();
		bg.scrollFactor.set();
		add(bg);

		var flowey:FlxSprite = new FlxSprite(0, 338);
		flowey.frames = AssetPaths.spritesheet('flowey', [1]);
		flowey.scale.set(2, 2);
		flowey.updateHitbox();
		flowey.screenCenter(X);
		flowey.scrollFactor.set();
		add(flowey);

		choicesItems = new FlxTypedGroup<FlxText>();
		add(choicesItems);

		for (i in 0...choices.length)
		{
			var bt:FlxText = new FlxText(0, 0, 0, choices[i], 32);

			switch (choices[i])
			{
				case 'Continue':
					bt.x = 155;
					bt.y = 220;
				case 'Reset':
					bt.x = 385;
					bt.y = 220;
				case 'Settings':
					bt.x = 255;
					bt.y = 265;
			}

			bt.font = AssetPaths.font('DTM-Mono.ttf');
			bt.ID = i;
			bt.scrollFactor.set();
			choicesItems.add(bt);
		}

		var info:FlxText = new FlxText(0, FlxG.height - 20, 0, 'UTF v${Lib.application.meta.get('version')} (c) MAJigsaw77 2023', 16);
		info.alignment = 'center';
		info.font = AssetPaths.font('Small.ttf');
		info.color = FlxColor.GRAY;
		info.screenCenter(X);
		info.scrollFactor.set();
		add(info);

		changeOption();

		super.create();
	}

	override function update(elapsed:Float):Void
	{
		if (FlxG.keys.justPressed.RIGHT)
			changeOption(1);
		else if (FlxG.keys.justPressed.LEFT)
			changeOption(-1);
		else if (FlxG.keys.anyJustPressed(Global.binds.get('confirm')))
		{
			if (choices[curChoice] != 'Reset')
				FlxG.sound.music.stop();

			switch (choices[curChoice])
			{
				case 'Continue':
					FlxG.switchState(new Battle());
				case 'Reset':
				// TODO
				case 'Settings':
					FlxG.switchState(new Settings());
			}
		}

		super.update(elapsed);
	}

	private function changeOption(num:Int = 0):Void
	{
		curChoice = FlxMath.wrap(curChoice + num, 0, choices.length - 1);

		choicesItems.forEach(function(spr:FlxText)
		{
			if (spr.ID == curChoice)
				spr.color = FlxColor.YELLOW;
			else
				spr.color = FlxColor.WHITE;
		});
	}
}
