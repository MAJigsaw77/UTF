package states;

import backend.AssetPaths;
import backend.Controls;
import backend.Data;
import backend.Global;
#if debug
import backend.Macros;
#end
import flixel.group.FlxGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import openfl.Lib;
#if debug
import states.Battle;
#end
import states.Room;
import states.Settings;

class Intro extends FlxState
{
	var selected:Int = 0;
	var choices:Array<String> = [];
	var items:FlxTypedGroup<FlxText>;

	override function create():Void
	{
		if (Global.flags[0] == 1)
		{
			FlxG.sound.playMusic(AssetPaths.music('menu1'));

			var bg:FlxSprite = new FlxSprite(0, -240, AssetPaths.background('floweyglow'));
			bg.scale.set(2, 2);
			bg.updateHitbox();
			bg.scrollFactor.set();
			bg.active = false;
			add(bg);

			var flowey:FlxSprite = new FlxSprite(0, 348, AssetPaths.sprite('flowey_1'));
			flowey.scale.set(2, 2);
			flowey.updateHitbox();
			flowey.screenCenter(X);
			flowey.scrollFactor.set();
			flowey.active = false;
			add(flowey);

			var name:FlxText = new FlxText(145, 120, 0, Global.name, 32);
			name.font = AssetPaths.font('DTM-Sans');
			name.scrollFactor.set();
			name.active = false;
			add(name);

			var love:FlxText = new FlxText(285, 120, 0, 'LV ${Global.lv}', 32);
			love.font = AssetPaths.font('DTM-Sans');
			love.scrollFactor.set();
			love.active = false;
			add(love);

			// TODO
			var time:FlxText = new FlxText(425, 120, 0, '0:0', 32);
			time.font = AssetPaths.font('DTM-Sans');
			time.scrollFactor.set();
			time.active = false;
			add(time);

			// TODO
			var room:FlxText = new FlxText(145, 160, 0, '---', 32);
			room.font = AssetPaths.font('DTM-Sans');
			room.scrollFactor.set();
			room.active = false;
			add(room);

			choices = ['Continue', 'Reset', 'Settings'];
		}
		else
		{
			FlxG.sound.playMusic(AssetPaths.music('menu0'));

			var list:Array<String> = [];
			
			list.push(' --- Instruction --- ');
			list.push('');
			list.push('[${Data.binds.get('cancel')}] - Confirm');
			list.push('[${Data.binds.get('cancel')}] - Cancel');
			list.push('[${Data.binds.get('menu')}] - Menu (In-Game)');
			list.push('');
			list.push('When HP is 0, you lose.');

			var instructions:FlxText = new FlxText(170, 40, 0, list.join('\n'), 32);
			instructions.font = AssetPaths.font('DTM-Sans');
			instructions.color = 0xFFC0C0C0; // Silver
			instructions.scrollFactor.set();
			instructions.active = false;
			add(instructions);

			choices = ['Begin Game', 'Settings'];
		}

		items = new FlxTypedGroup<FlxText>();

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
						bt.setPosition(170, 320);
					case 'Settings':
						bt.setPosition(170, 360);
				}
			}

			bt.font = AssetPaths.font('DTM-Sans');
			bt.ID = i;
			bt.scrollFactor.set();
			bt.active = false;
			items.add(bt);
		}

		add(items);

		#if debug
		var info:FlxText = new FlxText(0, FlxG.height - 40, 0,
			'UTF v${Lib.application.meta['version']} (c) MAJigsaw77 2023\nCommit ${Macros.getCommitNumber()} (${Macros.getCommitHash()})', 16);
		#else
 		var info:FlxText = new FlxText(0, FlxG.height - 20, 0, 'UTF v${Lib.application.meta['version']} (c) MAJigsaw77 2023', 16);
 		#end
		info.alignment = CENTER;
		info.font = AssetPaths.font('Small');
		info.color = FlxColor.GRAY;
		info.screenCenter(X);
		info.scrollFactor.set();
		info.active = false;
		add(info);

		changeOption();

		super.create();
	}

	override function update(elapsed:Float):Void
	{
		if (Global.flags[0] == 1 ? FlxG.keys.justPressed.RIGHT : FlxG.keys.justPressed.DOWN)
			changeOption(1);
		else if (Global.flags[0] == 1 ? FlxG.keys.justPressed.LEFT : FlxG.keys.justPressed.UP)
			changeOption(-1);

		if (Controls.instance.justPressed('confirm'))
		{
			if (FlxG.sound.music.playing && (choices[selected] != 'Reset' && choices[selected] != 'Begin Game'))
				FlxG.sound.music.stop();

			switch (choices[selected])
			{
				case 'Continue':
					FlxG.switchState(new Room(Global.room));
				case 'Begin Game':
					FlxG.switchState(new Naming());
				case 'Settings':
					FlxG.switchState(new Settings());
			}
		}

		#if debug
		if (FlxG.keys.justPressed.B)
			FlxG.switchState(new Battle());
		#end

		super.update(elapsed);
	}

	private function changeOption(num:Int = 0):Void
	{
		selected = Global.flags[0] == 1 ? FlxMath.wrap(selected + num, 0, choices.length - 1) : Math.floor(FlxMath.bound(selected + num, 0, choices.length - 1));

		items.forEach(function(spr:FlxText)
		{
			spr.color = spr.ID == selected ? FlxColor.YELLOW : FlxColor.WHITE;
		});
	}
}
