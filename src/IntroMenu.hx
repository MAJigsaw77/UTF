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

		for (i in 0...options.length)
		{
			var opt:FlxText = new FlxText(150 * i, 220, 0, options[i].toUpperCase(), 24);
			opt.font = AssetPaths.font('DTM-Mono.otf');
			opt.ID = i;
			opt.scrollFactor.set();
			optionsItems.add(opt);
		}

		changeOption();
		
		super.create();
	}

	override function update(elapsed:Float):Void
	{
		if (FlxG.keys.anyJustPressed(Global.binds.get('confirm')))
			FlxG.switchState(new Battle());

		super.update(elapsed);
	}

	override function update(elapsed:Float):Void
	{
		if (FlxG.keys.justPressed.RIGHT)
			changeOption(1);
		else if (FlxG.keys.justPressed.LEFT)
			changeOption(-1);
		else if (FlxG.keys.anyJustPressed(Global.binds.get('continue')))
		{
			if (choices[curOption] != 'Reset')
				FlxG.sound.music.stop();

			switch (choices[curOption])
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
		curOption = FlxMath.wrap(curOption + num, 0, options.length - 1);

		optionsItems.forEach(function(spr:FlxText)
		{
			if (spr.ID == curOption)
				spr.color = FlxColor.YELLOW;
			else
				spr.color = FlxColor.WHITE;
		});
	}
}
