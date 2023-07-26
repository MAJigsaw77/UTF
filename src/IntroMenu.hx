package;

import flixel.group.FlxGroup;
import flixel.math.FlxMath;
import flixel.util.FlxColor;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;

class IntroMenu extends FlxState
{
	var curChoice:Int = 0;
	final choices:Array<String> = ['Continue', 'Reset', 'Settings'];
	var choicesItems:FlxTypedGroup<FlxSprite>;

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

		for (i in 0...choices.length)
		{
			var bt:FlxText = new FlxText(150 * i, 220, 0, choices[i].toUpperCase(), 24);
			bt.font = AssetPaths.font('DTM-Mono.otf');
			bt.ID = i;
			bt.scrollFactor.set();
			choicesItems.add(bt);
		}

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
