package states;

import backend.AssetPaths;
import backend.Data;
import backend.Global;
import backend.Macros;
import flixel.group.FlxGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import openfl.Lib;
import states.Room;
import states.Settings;

class Intro extends FlxState
{
	var curChoice:Int = 0;
	final choices:Array<String> = ['Continue', 'Reset', 'Settings'];
	var choicesItems:FlxTypedGroup<FlxText>;

	override function create():Void
	{
		FlxG.sound.playMusic(AssetPaths.music(Global.hasName ? 'menu1' : 'menu0'));

		if (Global.hasName)
		{
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
		}
		else
		{
			var instructions:FlxText = new FlxText(170, 40, 0, ' --- Instruction --- ', 32);

			// The instructions.
			instructions.text += '\n\n';
			instructions.text += '[${Data.binds['confirm']}] - Confirm\n';
			instructions.text += '[${Data.binds['cancel']}] - Cancel\n';
			instructions.text += '[${Data.binds['menu']}] - Menu (In-Game)\n';
			instructions.text += '[F4] - FullScreen\n';
			instructions.text += '[Hold ${Data.binds['cancel']}] - Quit\n';
			instructions.text += 'When HP is 0, you lose.';

			instructions.font = AssetPaths.font('DTM-Sans');
			instructions.color = 0xFFC0C0C0; // Silver
			instructions.scrollFactor.set();
			add(instructions);

			choices.splice(0, choices.length);
			choices.concat(['Begin Game', 'Settings']);
		}

		choicesItems = new FlxTypedGroup<FlxText>();

		for (i in 0...choices.length)
		{
			var bt:FlxText = new FlxText(0, 0, 0, choices[i], 32);

			if (!choices.contains('Begin Game'))
			{
				switch (choices[i])
				{
					case 'Continue':
						bt.setPosition(170, 210);
					case 'Reset':
						bt.setPosition(385, 210);
					case 'Settings':
						bt.setPosition(260, 250);
				}
			}
			else
			{
				switch (choices[i])
				{
					case 'Begin Game':
						bt.setPosition(70, 160);
					case 'Settings':
						bt.setPosition(70, 200);
				}
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

		if (FlxG.keys.checkStatus(Data.binds['confirm'], JUST_PRESSED))
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
