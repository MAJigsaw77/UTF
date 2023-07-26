package;

import flixel.addons.transition.FlxTransitionableState;
import flixel.group.FlxGroup;
import flixel.math.FlxMath;
import flixel.sound.FlxSound;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.FlxG;

class Settings extends FlxTransitionableState
{
	var curOption:Int = 0;
	final options:Array<String> = ['Exit', 'Key Binds'];
	var optionsItems:FlxTypedGroup<FlxText>;

	override function create():Void
	{
		var weatherMusic:String = AssetPaths.music('options_fall');
		
		switch (Global.getWeather())
		{
			case 1:
				weatherMusic = AssetPaths.music('options_winter');
			case 3:
				weatherMusic = AssetPaths.music('options_summer');
		}

		FlxG.sound.cache(weatherMusic);

		var settings:FlxText = new FlxText(0, 20, 0, "SETTINGS", 52);
		settings.font = AssetPaths.font('DTM-Mono.ttf');
		settings.screenCenter(X);
		settings.scrollFactor.set();
		add(settings);

		optionsItems = new FlxTypedGroup<FlxText>();
		add(optionsItems);

		for (i in 0...options.length)
		{
			var opt:FlxText = new FlxText(40, 80 + i * 30, 0, options[i].toUpperCase(), 32);
			opt.font = AssetPaths.font('DTM-Mono.ttf');
			opt.ID = i;
			opt.scrollFactor.set();
			optionsItems.add(opt);
		}

		changeOption();

		FlxG.sound.play(AssetPaths.music('harpnoise'), () -> FlxG.sound.playMusic(weatherMusic, 1.0, true));

		super.create();
	}

	override function update(elapsed:Float):Void
	{
		if (FlxG.keys.justPressed.UP)
			changeOption(1);
		else if (FlxG.keys.justPressed.DOWN)
			changeOption(-1);
		else if (FlxG.keys.anyJustPressed(Global.binds.get('confirm'))
			&& (FlxG.sound.music != null && FlxG.sound.music.playing))
		{
			if (options[curOption] == 'Exit')
				FlxG.sound.music.stop();

			switch (options[curOption])
			{
				case 'Exit':
					FlxG.switchState(new IntroMenu());
				case 'Key Binds':
					// TODO
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
