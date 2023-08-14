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

		var flowey:FlxSprite = new FlxSprite(0, 348, AssetPaths.sprite('flowey_1'));
		flowey.scale.set(2, 2);
		flowey.updateHitbox();
		flowey.screenCenter(X);
		flowey.scrollFactor.set();
		add(flowey);

		var name:FlxText = new FlxText(145, 120, 0, Global.name, 32);
		name.font = AssetPaths.font('DTM-Sans');
		name.scrollFactor.set();
		add(name);

		var love:FlxText = new FlxText(285, 120, 0, 'LV ${Global.lv}', 32);
		love.font = AssetPaths.font('DTM-Sans');
		love.scrollFactor.set();
		add(love);

		// TODO
		var time:FlxText = new FlxText(425, 120, 0, '0:0', 32);
		time.font = AssetPaths.font('DTM-Sans');
		time.scrollFactor.set();
		add(time);

		// TODO
		var roomname:FlxText = new FlxText(145, 160, 0, '---', 32);
		roomname.font = AssetPaths.font('DTM-Sans');
		roomname.scrollFactor.set();
		add(roomname);

		choicesItems = new FlxTypedGroup<FlxText>();

		for (i in 0...choices.length)
		{
			var bt:FlxText = new FlxText(0, 0, 0, choices[i], 32);

			switch (choices[i])
			{
				case 'Continue':
					bt.x = 170;
					bt.y = 210;
				case 'Reset':
					bt.x = 385;
					bt.y = 210;
				case 'Settings':
					bt.x = 260;
					bt.y = 250;
			}

			bt.font = AssetPaths.font('DTM-Sans');
			bt.ID = i;
			bt.scrollFactor.set();
			choicesItems.add(bt);
		}

		add(choicesItems);

		#if !debug
		var info:FlxText = new FlxText(0, FlxG.height - 20, 0, 'UTF v${Lib.application.meta['version']} (c) MAJigsaw77 2023', 16);
		#else
		var info:FlxText = new FlxText(0, FlxG.height - 40, 0,
			'UTF v${Lib.application.meta['version']} (c) MAJigsaw77 2023\nCommit ${Macros.getCommitNumber()} (${Macros.getCommitHash()})', 16);
		#end
		info.alignment = 'center';
		info.font = AssetPaths.font('Small');
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
		else if (FlxG.keys.checkStatus(Data.binds['confirm'], JUST_PRESSED))
		{
			if (choices[curChoice] != 'Reset')
				FlxG.sound.music.stop();

			switch (choices[curChoice])
			{
				case 'Continue':
					FlxG.switchState(new Room(Global.room));
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
			spr.color = spr.ID == curChoice ? FlxColor.YELLOW : FlxColor.WHITE;
		});
	}
}
